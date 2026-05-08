package com.sample_pro.dao.management;

import java.util.List;
import java.util.Map;

import com.sample_pro.domain.EzInOutCardMaster;
import com.sample_pro.domain.EzInOutRecord;

public interface EzInOutAttendDao {

    /** 카드 마스터 전체 목록 */
    List<EzInOutCardMaster> selectCardMasterList();

    /** 카드 마스터: card_code로 사원명 조회 */
    EzInOutCardMaster selectCardMasterByCode(String cardCode);

    /** 중복 저장 방지: 동일 card_code + in_out_gubun 이 최근 N초 이내에 저장됐는지 확인 */
    int countRecentDuplicate(Map<String, Object> params);

    /** 출퇴근 기록 insert */
    void insertRecord(EzInOutRecord record);

    /** 최근 저장 이력 N건 조회 (테스트 페이지용) */
    List<EzInOutRecord> selectRecentRecords(int limit);

    /**
     * 기간+사원 조건 조회 (리스트 페이지용)
     * params: fromDt, toDt, empName(optional)
     */
    List<EzInOutRecord> selectRecordsByCondition(Map<String, Object> params);

    /**
     * 기간 내 기록 있는 사원 목록 (좌측 명단)
     * params: fromDt, toDt
     */
    List<Map<String, Object>> selectEmpListInPeriod(Map<String, Object> params);

    /**
     * 전체 다운로드용: 사원별로 정렬된 전체 기록 (엑셀 시트 분리용)
     * params: fromDt, toDt
     */
    List<EzInOutRecord> selectAllRecordsForExcel(Map<String, Object> params);

    /**
     * 하루 1줄 그룹핑 (리스트 페이지 / 엑셀용)
     * params: fromDt, toDt, empName(optional), orderBy(optional: "emp" or null)
     * returns: empName, cardCode, workDate, inTime, extTime, outTime
     */
    List<Map<String, Object>> selectDailyRecords(Map<String, Object> params);
}
