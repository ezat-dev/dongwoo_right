package com.sample_pro.dao.facility;

import java.util.List;
import java.util.Map;

public interface FProofListDao {
    List<Map<String, Object>> selectSessions(Map<String, Object> params);
    List<Map<String, Object>> selectDetail(Map<String, Object> params);
}
