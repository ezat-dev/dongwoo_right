package com.sample_pro.dao.monitor;

import com.sample_pro.domain.WorkListItem;
import java.util.List;
import java.util.Map;

public interface WorkListDao {
    List<WorkListItem> selectPendingWorkList(String equtCd);
    List<Map<String, Object>> selectJacupByRange(Map<String, Object> params);
}
