package com.sample_pro.service.monitor;

import com.sample_pro.domain.WorkListItem;
import java.util.List;
import java.util.Map;

public interface WorkListService {
    List<WorkListItem> getPendingWorkList(String equtCd);
    List<WorkListItem> getAllPendingWorkList();
    List<Map<String, Object>> getJacupByRange(String equtCd, String from, String to);
    int softDeleteJacup(int statusSeq);
}
