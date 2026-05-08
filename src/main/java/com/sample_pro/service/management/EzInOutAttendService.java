package com.sample_pro.service.management;

import java.util.List;
import java.util.Map;

import com.sample_pro.domain.EzInOutRecord;

public interface EzInOutAttendService {

    /**
     * PLC에서 D45~D54 값 읽어 현재 상태 Map 반환
     * keys: d45, d46, d51, d52, d53, d54, cardCode, inOutGubun, inOutName, empName, saveable
     */
    Map<String, Object> readPlcStatus();

    /**
     * 스케줄러에서 호출: PLC 상태 읽고 조건 충족 시 DB에 저장
     * 저장 결과 로그 문자열 반환 (없으면 null)
     */
    String checkAndSave();

    /** 최근 이력 N건 */
    List<EzInOutRecord> getRecentRecords(int limit);

    /** 최근 스케줄러 로그 목록 */
    List<String> getRecentLogs();

    /** 카드 마스터 전체 목록 (테스트 화면 select용) */
    List<Map<String, String>> getCardMasterList();

    /** 기간+사원 조건 기록 조회 */
    List<EzInOutRecord> getRecordsByCondition(Map<String, Object> params);

    /** 기간 내 기록 있는 사원 목록 (좌측 명단) */
    List<Map<String, Object>> getEmpListInPeriod(Map<String, Object> params);

    /** 전체 엑셀 다운로드용 기록 (사원·날짜 정렬) */
    List<EzInOutRecord> getAllRecordsForExcel(Map<String, Object> params);

    /** 하루 1줄 그룹핑 - 리스트 페이지 / 엑셀 공용 */
    List<Map<String, Object>> getDailyRecords(Map<String, Object> params);

    /**
     * 테스트용 PLC 쓰기
     * D45: 1=출근 / 2=외근 / 3=퇴근
     * D51~D54: cardCode 8자리 → 2글자씩 WORD 변환 후 write
     */
    void writePlcTest(int d45, String cardCode) throws Exception;

    /**
     * 경비 센서 모니터링용 PLC 읽기 (D2 값)
     */
    int[] readPlcWordsForSecurity() throws Exception;

    /**
     * PLC WORD 직접 쓰기 (경비 센서 비트 초기화 등)
     */
    void writePlcWordPublic(int address, int value) throws Exception;
}
