package com.sample_pro.service.monitor;

import com.sample_pro.domain.WorkListItem;
import java.util.List;
import java.util.Map;

public interface WorkListService {
    List<WorkListItem> getPendingWorkList(String equtCd);
    List<Map<String, Object>> getJacupByRange(String equtCd, String from, String to);
}
