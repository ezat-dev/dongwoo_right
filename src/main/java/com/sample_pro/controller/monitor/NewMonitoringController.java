package com.sample_pro.controller.monitor;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 메인 모니터 화면 실시간 PLC 데이터 제공
 *
 * 브라우저(AJAX 1.5s 폴링) → 이 컨트롤러 → C# API(localhost:5050) → PLC 장비
 *
 * POST /monitor/main-data
 *   - 요청 바디: JSP가 DOM에서 수집한 태그 클래스명 리스트
 *       예) ["bcf1_s_40045", "bcf1_60", "bcf12_s_D1083", ...]
 *   - 응답: 태그명 → 값 맵
 *       예) {"bcf1_s_40045": 950, "bcf1_60": 1, "bcf12_s_D1083": 870}
 *
 * 태그 명명 규칙 (JSP 클래스명 기반):
 *   bcfN_s_ADDR  → 온도(워드) 태그  — ADDR 은 Modbus 4x 주소 또는 Mitsubishi D번호
 *   bcfN_s_DADDR → Mitsubishi D레지스터 온도 태그  (예: bcf12_s_D1083 → D1083)
 *   bcfN_ADDR    → 신호(비트) 태그  — Modbus Coil 주소 (0x/1x 범위)
 *
 * PLC ID 매핑 (tb_plc.plc_id):
 *   bcf1~bcf9  → dongwoo_01 ~ dongwoo_09  (MODBUS_TCP)
 *   bcf10~bcf11 → dongwoo_10 ~ dongwoo_11 (MODBUS_TCP)
 *   bcf12       → dongwoo_12              (MITSUBISHI — readBits 미지원)
 */
@RestController
@RequestMapping("/monitor")
public class NewMonitoringController {

    private static final String CSHARP = "http://localhost:5050";

    private final RestTemplate rest = new RestTemplate();

    /** 태그 클래스명 패턴: 온도 (D 접두사 선택적) */
    private static final Pattern WORD_PAT = Pattern.compile("^bcf(\\d+)_s_D?(\\d+)$");

    /** 태그 클래스명 패턴: 신호 비트 */
    private static final Pattern BIT_PAT  = Pattern.compile("^bcf(\\d+)_(\\d+)$");

    /**
     * DOM 수집 태그 목록을 받아 PLC 일괄 읽기 후 태그→값 맵 반환.
     *
     * 동작 순서:
     *   1. 태그 파싱 → PLC 번호, 주소, 워드/비트 구분
     *   2. PLC별 min~max 범위로 묶어 C# API 1회 호출 (불필요한 요청 최소화)
     *   3. 범위 읽기 결과에서 개별 주소 값 추출 → 태그명으로 반환
     */
    @PostMapping(value = "/main-data", produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> mainData(@RequestBody List<String> tags) {

        // tag → [plcNum, addrInt, type(1=word / 0=bit)]
        Map<String, int[]> tagMeta = new LinkedHashMap<>();
        for (String tag : tags) {
            Matcher m = WORD_PAT.matcher(tag);
            if (m.matches()) {
                tagMeta.put(tag, new int[]{Integer.parseInt(m.group(1)), Integer.parseInt(m.group(2)), 1});
                continue;
            }
            m = BIT_PAT.matcher(tag);
            if (m.matches()) {
                tagMeta.put(tag, new int[]{Integer.parseInt(m.group(1)), Integer.parseInt(m.group(2)), 0});
            }
        }

        // PLC 번호별 주소 집합 분리
        Map<Integer, TreeSet<Integer>> wordAddrs = new HashMap<>();
        Map<Integer, TreeSet<Integer>> bitAddrs  = new HashMap<>();
        for (int[] meta : tagMeta.values()) {
            (meta[2] == 1 ? wordAddrs : bitAddrs)
                .computeIfAbsent(meta[0], k -> new TreeSet<>())
                .add(meta[1]);
        }

        // 읽기 결과 캐시: plcNum → (주소 → 값)
        Map<Integer, Map<Integer, Object>> wordCache = new HashMap<>();
        Map<Integer, Map<Integer, Object>> bitCache  = new HashMap<>();

        // 워드(온도) 읽기 — LS/Mitsubishi/Modbus 모두 /api/plc/read/{id} 사용
        wordAddrs.forEach((plcNum, addrs) -> {
            int start = addrs.first();
            int count = addrs.last() - start + 1;
            String url = CSHARP + "/api/plc/read/" + plcId(plcNum) + "?start=" + start + "&count=" + count;
            System.out.println(">>> [MONITOR/WORD/" + plcId(plcNum) + "] " + url);
            try {
                Map<?, ?> res = rest.getForObject(url, Map.class);
                if (res != null && Boolean.TRUE.equals(res.get("success"))) {
                    List<?> vals = (List<?>) res.get("values");
                    Map<Integer, Object> m = new HashMap<>();
                    for (int addr : addrs) {
                        int idx = addr - start;
                        if (idx >= 0 && idx < vals.size()) m.put(addr, vals.get(idx));
                    }
                    wordCache.put(plcNum, m);
                }
            } catch (Exception e) {
                System.out.println(">>> [MONITOR/WORD ERR/" + plcId(plcNum) + "] " + e.getMessage());
            }
        });

        // 비트(신호) 읽기 — MODBUS_TCP 전용 /api/plc/readBits/{id}
        bitAddrs.forEach((plcNum, addrs) -> {
            int start = addrs.first();
            int count = addrs.last() - start + 1;
            String url = CSHARP + "/api/plc/readBits/" + plcId(plcNum) + "?start=" + start + "&count=" + count;
            System.out.println(">>> [MONITOR/BIT/" + plcId(plcNum) + "] " + url);
            try {
                Map<?, ?> res = rest.getForObject(url, Map.class);
                if (res != null && Boolean.TRUE.equals(res.get("success"))) {
                    List<?> vals = (List<?>) res.get("values");
                    Map<Integer, Object> m = new HashMap<>();
                    for (int addr : addrs) {
                        int idx = addr - start;
                        if (idx >= 0 && idx < vals.size()) m.put(addr, vals.get(idx));
                    }
                    bitCache.put(plcNum, m);
                }
            } catch (Exception e) {
                System.out.println(">>> [MONITOR/BIT ERR/" + plcId(plcNum) + "] " + e.getMessage());
            }
        });

        // 태그명 → 값 최종 조합
        Map<String, Object> result = new LinkedHashMap<>();
        tagMeta.forEach((tag, meta) -> {
            int plcNum = meta[0], addr = meta[1], type = meta[2];
            Map<Integer, Object> cache = (type == 1 ? wordCache : bitCache).get(plcNum);
            if (cache == null || !cache.containsKey(addr)) return;

            Object val = cache.get(addr);
            if (type == 0) {
                // 비트: true/false → 1/0 으로 정규화
                result.put(tag, Boolean.TRUE.equals(val) ? 1 : 0);
            } else {
                result.put(tag, val);
            }
        });

        return result;
    }

    /** bcfN → dongwoo_NN (1~9 는 두 자리 패딩) */
    private String plcId(int n) {
        return n < 10 ? "dongwoo_0" + n : "dongwoo_" + n;
    }
}
