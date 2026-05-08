package com.sample_pro.service.management;

import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Deque;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentLinkedDeque;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.sample_pro.dao.management.EzInOutAttendDao;
import com.sample_pro.domain.EzInOutCardMaster;
import com.sample_pro.domain.EzInOutRecord;

@Service
public class EzInOutAttendServiceImpl implements EzInOutAttendService {

    /* ── C# PLC API (LS Electric) ── */
    private static final String CSHARP_API  = "http://localhost:5050";

    /* ── PLC 주소 ── */
    // D45: 상태 영역 (WORD) - 1=출근 / 2=외근 / 3=퇴근
    private static final int ADDR_D45 = 45;
    private static final int ADDR_D61 = 61;
    private static final int ADDR_D62 = 62;
    private static final int ADDR_D63 = 63;
    private static final int ADDR_D64 = 64;
    private static final int ADDR_D46 = 46;
    // D46: 저장 트리거 (WORD) - 1이면 저장 요청, DB 저장 완료 후 자바에서 0으로 리셋
    // D61~D64: 동작용 카드코드 ASCII 값 (각 1바이트 → 2자리 HEX 문자열)
    // D45~D64 범위를 한 번에 읽기 위한 count (D45=idx0, D46=idx1, D61=idx16 ... D64=idx19)
    private static final int READ_COUNT = 20;

    /* ── 중복 방지 기준 (초) ── */
    private static final int DUPLICATE_SEC = 120;  // 2분 이내 동일 card_code + 상태 재저장 방지

    /* ── 최근 로그 (최대 100건, thread-safe) ── */
    private static final int LOG_MAX = 100;
    private final Deque<String> logQueue = new ConcurrentLinkedDeque<>();

    private final RestTemplate restTemplate = new RestTemplate();

    @Autowired
    private EzInOutAttendDao attendDao;

    /* =============================================
       PLC D45~D64 일괄 읽기
       start=45, count=20 → index 0=D45, 1=D46, 16=D61, 17=D62, 18=D63, 19=D64
    ============================================= */
    @SuppressWarnings("unchecked")
    private int[] readPlcWords() throws Exception {
        String url = CSHARP_API + "/api/plc/read?start=" + ADDR_D45 + "&count=" + READ_COUNT;
        Map<?, ?> resp = restTemplate.getForObject(url, Map.class);
        if (resp == null || !Boolean.TRUE.equals(resp.get("success"))) {
            throw new Exception("PLC read 실패: " + (resp != null ? resp.get("error") : "응답 없음"));
        }
        List<Number> values = (List<Number>) resp.get("values");
        if (values == null || values.size() < READ_COUNT) {
            throw new Exception("PLC 응답 값 부족: size=" + (values != null ? values.size() : 0));
        }
        int[] words = new int[READ_COUNT];
        for (int i = 0; i < READ_COUNT; i++) {
            words[i] = values.get(i).intValue();
        }
        return words;
    }

    /* =============================================
       WORD 값(16bit 정수) → ASCII 2글자 쌍
       LS PLC는 카드코드 2글자를 WORD 1개에 담아 전송
       low byte = 앞 글자, high byte = 뒷 글자

       예) 13616 = 0x3530
             low  = 0x30 = '0'
             high = 0x35 = '5'
             → "05"

           13876 = 0x3634
             low  = 0x34 = '4'
             high = 0x36 = '6'
             → "46"

       D61+D62+D63+D64 각 2글자씩 합치면 8자리 카드코드 완성
    ============================================= */
    /**
     * PLC WORD → 카드코드 2글자
     * low byte = 앞글자, high byte = 뒷글자 (ASCII)
     * 값이 0이거나 출력불가 문자면 "00" 반환
     */
    private String wordToAsciiPair(int word) {
        int lo = word & 0xFF;
        int hi = (word >> 8) & 0xFF;
        // 둘 다 0이면 카드 미삽입
        if (lo == 0 && hi == 0) return "00";
        char cLo = (lo >= 32 && lo <= 126) ? (char) lo : (char)('0');
        char cHi = (hi >= 32 && hi <= 126) ? (char) hi : (char)('0');
        return (String.valueOf(cLo) + String.valueOf(cHi)).toUpperCase();
    }

    /* =============================================
       카드코드 2글자 쌍 → WORD (쓰기 역변환)
       예) "73" → lo='7'(0x37), hi='3'(0x33) → 0x3337 = 13111
    ============================================= */
    private int asciiPairToWord(String pair) {
        int lo = (int) pair.charAt(0) & 0xFF;
        int hi = (int) pair.charAt(1) & 0xFF;
        return (hi << 8) | lo;
    }

    /* =============================================
       PLC 단일 WORD 쓰기 (Content-Type 헤더 명시)
    ============================================= */
    private void writePlcWord(int address, int value) throws Exception {
        Map<String, Object> body = new HashMap<>();
        body.put("address", address);
        body.put("value",   value);

        org.springframework.http.HttpHeaders headers = new org.springframework.http.HttpHeaders();
        headers.setContentType(org.springframework.http.MediaType.APPLICATION_JSON);
        org.springframework.http.HttpEntity<Map<String, Object>> entity =
            new org.springframework.http.HttpEntity<>(body, headers);

        Map<?, ?> resp = restTemplate.postForObject(CSHARP_API + "/api/plc/write", entity, Map.class);
        if (resp == null || !Boolean.TRUE.equals(resp.get("success"))) {
            throw new Exception("PLC write 실패 D" + address + ": " + (resp != null ? resp.get("error") : "응답 없음"));
        }
    }

    /* =============================================
       D45 값 → 상태명
    ============================================= */
    private String d45ToName(int d45) {
        switch (d45) {
            case 1: return "출근";
            case 2: return "외근";
            case 3: return "퇴근";
            default: return "알수없음";
        }
    }

    /* =============================================
       현재 PLC 상태 읽기 (화면 폴링용)
    ============================================= */
    @Override
    public Map<String, Object> readPlcStatus() {
        Map<String, Object> result = new LinkedHashMap<>();
        try {
            int[] words = readPlcWords();

            int d45 = words[0];   // D45
            int d46 = words[1];   // D46
            // D61~D64: index 16~19 (D45=0, D46=1, ..., D60=15, D61=16, D62=17, D63=18, D64=19)
            String d61 = wordToAsciiPair(words[16]);
            String d62 = wordToAsciiPair(words[17]);
            String d63 = wordToAsciiPair(words[18]);
            String d64 = wordToAsciiPair(words[19]);
            String cardCode  = d61 + d62 + d63 + d64;
            String inOutName = d45ToName(d45);

            // 사원명 조회
            String empName = "";
            boolean cardFound = false;
            if (!cardCode.equals("00000000") && !cardCode.isEmpty()) {
                EzInOutCardMaster master = attendDao.selectCardMasterByCode(cardCode);
                if (master != null) {
                    empName    = master.getEmpName();
                    cardFound  = true;
                }
            }

            // 저장 가능 여부 판단 (D46=1, D45=1~3, 카드코드 유효, 사원 존재)
            boolean saveable = (d46 == 1) && (d45 >= 1 && d45 <= 3) && cardFound;

            result.put("success",    true);
            result.put("d45",        d45);
            result.put("d45Name",    inOutName);
            result.put("d46",        d46);
            result.put("d61",        d61);
            result.put("d62",        d62);
            result.put("d63",        d63);
            result.put("d64",        d64);
            result.put("cardCode",   cardCode);
            result.put("empName",    empName);
            result.put("cardFound",  cardFound);
            result.put("saveable",   saveable);
            result.put("timestamp",  LocalDateTime.now().format(DateTimeFormatter.ofPattern("HH:mm:ss")));

        } catch (Exception e) {
            result.put("success", false);
            result.put("error",   "PLC 읽기 실패: " + e.getMessage());
        }
        return result;
    }

    /* =============================================
       스케줄러 호출: PLC 감시 → 조건 충족 시 저장
    ============================================= */
    @Override
    public String checkAndSave() {
        String ts = LocalDateTime.now().format(DateTimeFormatter.ofPattern("HH:mm:ss"));

        // ── STEP 1: PLC 읽기 ──
        int[] words;
        try {
            words = readPlcWords();
        } catch (Exception e) {
            String log = "[" + ts + "] PLC 읽기 오류: " + e.getMessage();
            addLog(log);
            fileLog("STEP1 PLC 읽기 실패: " + e.getMessage());
            return log;
        }

        int    d45      = words[0];
        int    d46      = words[1];
        String d61      = wordToAsciiPair(words[16]);
        String d62      = wordToAsciiPair(words[17]);
        String d63      = wordToAsciiPair(words[18]);
        String d64      = wordToAsciiPair(words[19]);
        String cardCode = d61 + d62 + d63 + d64;

        // ── STEP 2: 저장 트리거 확인 (D46 == 1) ──
        if (d46 != 1) {
            return null; // 대기 중 — 로그 없음
        }

        // D46=1 확인된 시점부터 파일 로그 시작
        fileLog("=== 카드 감지 [" + ts + "] ===");
        fileLog("D45=" + d45 + "(" + d45ToName(d45) + "), D46=" + d46
                + ", D61=" + d61 + ", D62=" + d62 + ", D63=" + d63 + ", D64=" + d64
                + ", cardCode=" + cardCode);
        addLog("[" + ts + "] D45=" + d45 + ", D46=" + d46 + ", card_code=" + cardCode + " 감지");

        // ── STEP 3: D45 범위 확인 ──
        if (d45 < 1 || d45 > 3) {
            String log = "[" + ts + "] D45 값 범위 외 (" + d45 + "), 저장 생략";
            addLog(log);
            fileLog("STEP3 D45 범위 외(" + d45 + ") → 종료");
            return log;
        }
        fileLog("STEP3 D45 범위 OK (" + d45 + "=" + d45ToName(d45) + ")");

        // ── STEP 4: 카드코드 유효성 확인 ──
        if (cardCode.equals("00000000") || cardCode.trim().isEmpty()) {
            String log = "[" + ts + "] card_code 비어있음, 저장 생략";
            addLog(log);
            fileLog("STEP4 cardCode 비어있음 → 종료");
            return log;
        }
        fileLog("STEP4 cardCode 유효: " + cardCode);

        // ── STEP 5: 사원명 조회 ──
        fileLog("STEP5 사원 조회 시작: cardCode=" + cardCode);
        EzInOutCardMaster master = null;
        try {
            master = attendDao.selectCardMasterByCode(cardCode);
        } catch (Exception e) {
            String log = "[" + ts + "] 사원 조회 오류: " + e.getMessage();
            addLog(log);
            fileLog("STEP5 사원 조회 DB 오류 → 종료: " + e.getMessage());
            return log;
        }

        if (master == null) {
            String log = "[" + ts + "] card_code=" + cardCode + " 미등록 카드, 저장 생략";
            addLog(log);
            fileLog("STEP5 미등록 카드(" + cardCode + ") → 종료");
            return log;
        }
        fileLog("STEP5 사원 조회 성공: " + master.getEmpName() + " (card=" + cardCode + ")");
        addLog("[" + ts + "] 사원명 조회 성공: " + master.getEmpName());

        // ── STEP 6: D46 → 0 리셋 (트리거 해제, 최대 3회 재시도) ──
        fileLog("STEP6 D46 리셋 시작");
        {
            int maxRetry = 3;
            Exception lastResetEx = null;
            boolean resetOk = false;
            for (int attempt = 1; attempt <= maxRetry; attempt++) {
                fileLog("STEP6 D46 리셋 시도 " + attempt + "/" + maxRetry);
                try {
                    writePlcWord(ADDR_D46, 0);
                    addLog("[" + ts + "] D46 리셋 완료 (0) [시도 " + attempt + "/" + maxRetry + "]");
                    fileLog("STEP6 D46 리셋 성공 [시도 " + attempt + "]");
                    resetOk = true;
                    break;
                } catch (Exception resetEx) {
                    lastResetEx = resetEx;
                    addLog("[" + ts + "] D46 리셋 실패 [시도 " + attempt + "/" + maxRetry + "]: " + resetEx.getMessage());
                    fileLog("STEP6 D46 리셋 실패 [시도 " + attempt + "]: " + resetEx.getMessage());
                    if (attempt < maxRetry) {
                        try { Thread.sleep(150); } catch (InterruptedException ie) { Thread.currentThread().interrupt(); }
                    }
                }
            }
            if (!resetOk) {
                String log = "[" + ts + "] D46 리셋 " + maxRetry + "회 모두 실패, DB 저장 생략: "
                             + (lastResetEx != null ? lastResetEx.getMessage() : "");
                addLog(log);
                System.err.println(">>> [EzInOut] " + log);
                fileLog("STEP6 D46 리셋 3회 모두 실패 → DB 저장 생략, 종료");
                return log;
            }
        }

        // ── STEP 7: 중복 저장 방지 ──
        fileLog("STEP7 중복 체크 시작: card=" + cardCode + ", gubun=" + d45 + ", 기준=" + DUPLICATE_SEC + "초");
        try {
            Map<String, Object> dupParams = new HashMap<>();
            dupParams.put("cardCode",    cardCode);
            dupParams.put("inOutGubun",  d45);
            dupParams.put("seconds",     DUPLICATE_SEC);
            int dupCount = attendDao.countRecentDuplicate(dupParams);
            fileLog("STEP7 중복 체크 결과: dupCount=" + dupCount);
            if (dupCount > 0) {
                String log = "[" + ts + "] 중복 데이터 감지로 저장 생략 (card=" + cardCode + ", gubun=" + d45 + ")";
                addLog(log);
                fileLog("STEP7 중복 감지 → 저장 생략, 종료");
                return log;
            }
            fileLog("STEP7 중복 없음 → DB 저장 진행");
        } catch (Exception e) {
            // 중복 체크 쿼리 실패 시 저장은 계속 진행 (D46은 이미 0)
            String log = "[" + ts + "] 중복 체크 오류 (INSERT 계속 진행): " + e.getMessage();
            addLog(log);
            fileLog("STEP7 중복 체크 DB 오류 → INSERT 강행: " + e.getMessage());
        }

        // ── STEP 8: DB 저장 ──
        fileLog("STEP8 DB INSERT 시작: emp=" + master.getEmpName() + ", gubun=" + d45ToName(d45));
        try {
            EzInOutRecord record = new EzInOutRecord();
            record.setInOutGubun(d45);
            record.setInOutName(d45ToName(d45));
            record.setPlcD45Value(d45);
            record.setPlcD46Value(d46);
            record.setD61Value(d61);
            record.setD62Value(d62);
            record.setD63Value(d63);
            record.setD64Value(d64);
            record.setCardCode(cardCode);
            record.setEmpName(master.getEmpName());
            record.setRegDate(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
            record.setSaveYn("Y");

            attendDao.insertRecord(record);

            String log = "[" + ts + "] " + d45ToName(d45) + " 기록 저장 완료 → " + master.getEmpName() + " (" + cardCode + ")";
            addLog(log);
            fileLog("STEP8 DB INSERT 성공 → " + master.getEmpName() + "(" + cardCode + ") " + d45ToName(d45));
            fileLog("=== checkAndSave 완료 ===");
            return log;

        } catch (Exception e) {
            String log = "[" + ts + "] DB 저장 실패: " + e.getMessage();
            addLog(log);
            fileLog("STEP8 DB INSERT 실패 → 종료: " + e.getMessage());
            return log;
        }
    }

    /* =============================================
       최근 이력 조회
    ============================================= */
    @Override
    public List<EzInOutRecord> getRecentRecords(int limit) {
        return attendDao.selectRecentRecords(limit);
    }

    /* =============================================
       로그 관리
    ============================================= */
    @Override
    public List<String> getRecentLogs() {
        return new ArrayList<>(logQueue);
    }

    /* =============================================
       기간+사원 조건 기록 조회
    ============================================= */
    @Override
    public List<EzInOutRecord> getRecordsByCondition(Map<String, Object> params) {
        return attendDao.selectRecordsByCondition(params);
    }

    /* =============================================
       기간 내 사원 목록 (좌측 명단)
    ============================================= */
    @Override
    public List<Map<String, Object>> getEmpListInPeriod(Map<String, Object> params) {
        return attendDao.selectEmpListInPeriod(params);
    }

    /* =============================================
       전체 엑셀 다운로드용 기록
    ============================================= */
    @Override
    public List<EzInOutRecord> getAllRecordsForExcel(Map<String, Object> params) {
        return attendDao.selectAllRecordsForExcel(params);
    }

    /* =============================================
       하루 1줄 그룹핑
    ============================================= */
    @Override
    public List<Map<String, Object>> getDailyRecords(Map<String, Object> params) {
        return attendDao.selectDailyRecords(params);
    }

    /* =============================================
       카드 마스터 전체 목록 (테스트 화면 select용)
    ============================================= */
    @Override
    public List<Map<String, String>> getCardMasterList() {
        List<EzInOutCardMaster> list = attendDao.selectCardMasterList();
        List<Map<String, String>> result = new ArrayList<>();
        for (EzInOutCardMaster m : list) {
            Map<String, String> item = new HashMap<>();
            item.put("cardCode", m.getCardCode());
            item.put("empName",  m.getEmpName());
            result.add(item);
        }
        return result;
    }

    /* =============================================
       테스트용 PLC 쓰기
       D45 = d45 (1/2/3)
       D61~D64 = cardCode 8자리를 2글자씩 WORD 변환 후 write
    ============================================= */
    @Override
    public void writePlcTest(int d45, String cardCode) throws Exception {
        if (cardCode == null || cardCode.length() != 8) {
            throw new IllegalArgumentException("카드코드는 8자리여야 합니다: " + cardCode);
        }

        // D45 쓰기
        writePlcWord(ADDR_D45, d45);

        // D51~D54: 카드코드 8자리를 2글자씩 쪼개 WORD로 변환
        // cardCode = "73054C46"
        //   D61 = "73" → asciiPairToWord("73") = 0x3337
        //   D62 = "05" → asciiPairToWord("05") = 0x3530
        //   D63 = "4C" → asciiPairToWord("4C") = 0x4334 ('4'=0x34, 'C'=0x43)
        //   D64 = "46" → asciiPairToWord("46") = 0x3634
        String p61 = cardCode.substring(0, 2);
        String p62 = cardCode.substring(2, 4);
        String p63 = cardCode.substring(4, 6);
        String p64 = cardCode.substring(6, 8);

        writePlcWord(ADDR_D61, asciiPairToWord(p61));  // D61
        writePlcWord(ADDR_D62, asciiPairToWord(p62));  // D62
        writePlcWord(ADDR_D63, asciiPairToWord(p63));  // D63
        writePlcWord(ADDR_D64, asciiPairToWord(p64));  // D64

        String ts = java.time.LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss"));
        addLog("[" + ts + "] [테스트 쓰기] D45=" + d45 + "(" + d45ToName(d45) + "), cardCode=" + cardCode + " → PLC 전송 완료");
    }

    @Override
    public void writePlcWordPublic(int address, int value) throws Exception {
        writePlcWord(address, value);
    }

    @Override
    @SuppressWarnings("unchecked")
    public int[] readPlcWordsForSecurity() throws Exception {
        // start=2, count=43 → index 0=D2(센서비트), index 42=D44(경비 온/오프)
        String url = CSHARP_API + "/api/plc/read?start=2&count=43";
        Map<?, ?> resp = restTemplate.getForObject(url, Map.class);
        if (resp == null || !Boolean.TRUE.equals(resp.get("success"))) {
            throw new Exception("PLC read 실패: " + (resp != null ? resp.get("error") : "응답 없음"));
        }
        List<Number> values = (List<Number>) resp.get("values");
        if (values == null || values.size() < 43) {
            throw new Exception("PLC 응답 값 부족: size=" + (values != null ? values.size() : 0));
        }
        int d2Val  = values.get(0).intValue();   // D2  (센서 비트 A~E)
        int d44Val = values.get(42).intValue();  // D44 (경비 온/오프)
        return new int[]{ d2Val, d44Val };
    }

    private void addLog(String msg) {
        logQueue.addFirst(msg);
        while (logQueue.size() > LOG_MAX) {
            logQueue.pollLast();
        }
    }

    /* =============================================
       파일 로그 (D:\출퇴근 이력\YYYY-MM-DD.log)
    ============================================= */
    private static final String FILE_LOG_DIR = "D:\\출퇴근 이력";

    private void fileLog(String msg) {
        try {
            File dir = new File(FILE_LOG_DIR);
            if (!dir.exists()) dir.mkdirs();

            String date     = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            String datetime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS"));
            File   logFile  = new File(dir, date + ".log");

            try (BufferedWriter bw = new BufferedWriter(
                    new java.io.OutputStreamWriter(
                        new java.io.FileOutputStream(logFile, true),
                        java.nio.charset.StandardCharsets.UTF_8))) {
                bw.write("[" + datetime + "] " + msg);
                bw.newLine();
            }
        } catch (IOException e) {
            System.err.println(">>> [FileLog] 파일 로그 실패: " + e.getMessage());
        }
    }
}
