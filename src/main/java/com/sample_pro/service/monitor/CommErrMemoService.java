package com.sample_pro.service.monitor;

import com.sample_pro.dao.monitor.TempDao;
import com.sample_pro.domain.TempMemo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.Date;
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
    private final Map<String, Boolean> alertingMap = new ConcurrentHashMap<>();

    @Autowired
    private TempDao tempDao;

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

                TempMemo memo = new TempMemo();
                memo.setEquipId(bcfId.replace("_", "")); // "BCF_7" → "BCF7"
                memo.setTcRegtime(rtStr);
                memo.setTcName(bcfId + "_통신오류(" + hhmm + ")");
                memo.setTcDesc("연속 3회 이상 NULL 감지 - 통신 불량");
                memo.setTcUserCode(0);
                memo.setTcUserName("시스템");

                try {
                    tempDao.insertMemo(memo);
                } catch (Exception ex) {
                    // 삽입 실패 무시
                }
                alertingMap.put(bcfId, true);

            } else if (!allNull && wasAlerting) {
                // 통신 복구 → 상태 초기화
                alertingMap.put(bcfId, false);
            }
        }
    }

    private String formatTime(Object rtObj, SimpleDateFormat sdf) {
        if (rtObj instanceof Date) return sdf.format((Date) rtObj);
        return rtObj != null ? rtObj.toString() : "";
    }
}
