package com.sample_pro.service.facility;

import java.util.List;
import java.util.Map;

public interface FProofListService {
    List<Map<String, Object>> getSessions(String from, String to);
    List<Map<String, Object>> getDetail(String plcId, String start, String end);
}
