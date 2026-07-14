package com.sample_pro.controller.monitor;

import com.sample_pro.domain.WorkListItem;
import com.sample_pro.service.monitor.WorkListService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@Controller
@RequestMapping("/work")
public class WorkListController {

    @Autowired
    private WorkListService workListService;

    // BCF 태그 → EQUT_CD 매핑 (BCF6=2420M011 등 순번 불일치 주의)
    private static final List<Map<String, String>> MACHINES;
    static {
        String[][] data = {
            { "BCF1",  "2420M001" },
            { "BCF2",  "2420M002" },
            { "BCF3",  "2420M003" },
            { "BCF4",  "2420M004" },
            { "BCF5",  "2420M005" },
            { "BCF6",  "2420M011" },
            { "BCF7",  "2420M006" },
            { "BCF8",  "2420M007" },
            { "BCF9",  "2420M008" },
            { "BCF10", "2420M009" },
            { "BCF11", "2420M010" },
            { "BCF12", "2421M002" },
        };
        List<Map<String, String>> list = new ArrayList<>();
        for (String[] row : data) {
            Map<String, String> m = new LinkedHashMap<>();
            m.put("machineTag", row[0]);
            m.put("equtCd",     row[1]);
            list.add(m);
        }
        MACHINES = Collections.unmodifiableList(list);
    }

    // POST /work/softDelete → START_DTTM = '2000-12-31 00:00:00' (사실상 삭제)
    @RequestMapping(value = "/softDelete", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public ResponseEntity<?> softDelete(@RequestBody Map<String, String> body) {
        String seqStr = body.get("statusSeq");
        Map<String, Object> res = new HashMap<>();
        if (seqStr == null || seqStr.isEmpty()) {
            res.put("success", false);
            res.put("error", "statusSeq 필요");
            return ResponseEntity.ok(res);
        }
        try {
            int updated = workListService.softDeleteJacup(Integer.parseInt(seqStr));
            res.put("success", updated > 0);
            res.put("updated", updated);
        } catch (Exception e) {
            res.put("success", false);
            res.put("error", e.getMessage());
        }
        return ResponseEntity.ok(res);
    }

    // GET /work/jacup/range → 트렌드용 시간범위 조회
    @RequestMapping(value = "/jacup/range", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public ResponseEntity<?> jacupRange(@RequestParam(required = false, defaultValue = "") String equtCd,
                                         @RequestParam String from,
                                         @RequestParam String to) {
        try {
            List<Map<String, Object>> data = workListService.getJacupByRange(equtCd, from, to);
            return ResponseEntity.ok(data);
        } catch (Exception e) {
            return ResponseEntity.ok(Collections.emptyList());
        }
    }

    // GET /work/listData → 12개 설비 미시작 작업지시 일괄 반환 (쿼리 1회)
    @RequestMapping(value = "/listData", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public ResponseEntity<?> listData() {
        try {
            // DB 1번 호출로 전체 조회
            List<WorkListItem> allItems = workListService.getAllPendingWorkList();

            // equtCd별 그룹핑 (최대 5개, DB에서 이미 EQUT_CD·WORK_INDCT_NUM 순 정렬됨)
            Map<String, List<WorkListItem>> grouped = new LinkedHashMap<>();
            for (WorkListItem item : allItems) {
                List<WorkListItem> list = grouped.computeIfAbsent(item.getEqutCd(), k -> new ArrayList<>());
                if (list.size() < 5) list.add(item);
            }

            // 기존 응답 구조 그대로 유지
            List<Map<String, Object>> result = new ArrayList<>();
            for (Map<String, String> machine : MACHINES) {
                String equtCd = machine.get("equtCd");
                Map<String, Object> entry = new LinkedHashMap<>();
                entry.put("machineTag", machine.get("machineTag"));
                entry.put("equtCd",     equtCd);
                entry.put("items",      grouped.getOrDefault(equtCd, Collections.emptyList()));
                result.add(entry);
            }
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("error",   e.getMessage());
            return ResponseEntity.ok(err);
        }
    }
}
