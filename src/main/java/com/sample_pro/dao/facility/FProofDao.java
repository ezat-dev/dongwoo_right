package com.sample_pro.dao.facility;

import com.sample_pro.domain.AlarmTag;

import java.util.List;
import java.util.Map;

public interface FProofDao {
    /** 설비의 전체 알람 태그 */
    List<AlarmTag> selectAllTags(String plcId);
    /** 설비의 지정된(선택된) 알람 tag_id 목록 */
    List<Integer>  selectSelectedTagIds(String plcId);
    /** F/PROOF 지정 추가 */
    void           insertSelected(Map<String, Object> params);
    /** F/PROOF 지정 해제 */
    void           deleteSelected(Map<String, Object> params);
}
