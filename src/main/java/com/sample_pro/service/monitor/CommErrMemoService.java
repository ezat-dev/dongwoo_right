package com.sample_pro.service.monitor;

import com.sample_pro.dao.monitor.TempDao;
import com.sample_pro.domain.TempMemo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class CommErrMemoService {

    // 호기명 → 대표 컬럼 (연속 NULL 감지 기준)
    private static final String[][] BCF_COLS = {
        {"BCF_1",  "BCF_1_CT_PV"},
        {"BCF_2",  "BCF_2_CT_PV"},
        {"BCF_3",  "BCF_3_CT_PV"},
        {"BCF_4",  "BCF_4_CT_PV"},
        {"BCF_5",  "BCF_5_CT_PV"},
        {"BCF_6",  "BCF_6_CT1_PV"},
        {"BCF_7",  "BCF_7_CT_PV"},
        {"BCF_8",  "BCF_8_CT_PV"},
        {"BCF_9",  "BCF_9_CT_PV"},
        {"BCF_10", "BCF_10_CT_PV"},
        {"BCF_11", "BCF_11_ROOM1_TEMP_PV"},
        {"BCF_12", "BCF_12_CT_PV"},
    };

    // 중복 삽입 방지: 호기별 오류 상태 (정상→오류 전환 시에만 메모 삽입)
    private final Map<String, Boolean> alertingMap  = new ConcurrentHashMap<>();
    // 오류 최초 감지 시각 (오류 중인 호기만 보관)
    private final Map<String, String>  alertStartMap = new ConcurrentHashMap<>();

    @Autowired
    private TempDao tempDao;

    /** 현재 통신 오류 중인 호기 목록 반환 (Controller에서 REST 노출용) */
    public List<Map<String, String>> getCommErrors() {
        List<Map<String, String>> result = new ArrayList<>();
        for (String[] bcf : BCF_COLS) {
            String bcfId = bcf[0];
            if (Boolean.TRUE.equals(alertingMap.get(bcfId))) {
                Map<String, String> item = new HashMap<>();
                item.put("equipId", bcfId.replace("_", "")); // BCF_7 → BCF7
                item.put("since",   alertStartMap.getOrDefault(bcfId, ""));
                result.add(item);
            }
        }
        return result;
    }

    @Scheduled(fixedDelay = 60000)
    public void checkCommErrors() {
        List<Map<String, Object>> rows;
        try {
            rows = tempDao.selectRecentSnapshot();
        } catch (Exception e) {
            return;
        }
        if (rows == null || rows.size() < 3) return;

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        for (String[] bcf : BCF_COLS) {
            String bcfId  = bcf[0];
            String colKey = bcf[1];

            // 최근 3행 모두 NULL 여부 확인
            boolean allNull = true;
            for (int i = 0; i < 3; i++) {
                if (rows.get(i).get(colKey) != null) { allNull = false; break; }
            }

            boolean wasAlerting = Boolean.TRUE.equals(alertingMap.get(bcfId));

            if (allNull && !wasAlerting) {
                // 연속 NULL 3번째 행의 record_time을 오류 시작 시각으로 사용
                String rtStr = formatTime(rows.get(2).get("record_time"), sdf);
                String hhmm  = rtStr.length() >= 16 ? rtStr.substring(11, 16) : "";

                String equipId = bcfId.replace("_", ""); // "BCF_7" → "BCF7"
                TempMemo memo = new TempMemo();
                memo.setEquipId(equipId);
                memo.setTcRegtime(rtStr);
                memo.setTcName(equipId + "_통신오류");   // 최대 10자: "BCF12_통신오류"
                memo.setTcDesc(hhmm + " 연속3회NULL - 통신불량");
                memo.setTcUserCode(0);
                memo.setTcUserName("시스템");

                try {
                    tempDao.insertMemo(memo);
                } catch (Exception ex) {
                    // 삽입 실패 무시
                }
                appendCommErrLog(equipId, rtStr, hhmm);
                alertStartMap.put(bcfId, rtStr);
                alertingMap.put(bcfId, true);

            } else if (!allNull && wasAlerting) {
                // 통신 복구 → 상태 초기화
                alertStartMap.remove(bcfId);
                alertingMap.put(bcfId, false);
            }
        }
    }

    private void appendCommErrLog(String equipId, String rtStr, String hhmm) {
        try (BufferedWriter bw = new BufferedWriter(
                new FileWriter("D:\\sample_pro\\통신 이상 발생.txt", true))) {
            bw.write("[" + rtStr + "] " + equipId + " 통신 이상 감지 (" + hhmm + " 연속3회NULL)");
            bw.newLine();
        } catch (Exception ignored) {}
    }

    private String formatTime(Object rtObj, SimpleDateFormat sdf) {
        if (rtObj instanceof Date) return sdf.format((Date) rtObj);
        return rtObj != null ? rtObj.toString() : "";
    }
}
