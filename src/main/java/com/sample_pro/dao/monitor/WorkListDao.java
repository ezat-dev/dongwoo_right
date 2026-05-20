package com.sample_pro.dao.monitor;

import com.sample_pro.domain.WorkListItem;
import java.util.List;

public interface WorkListDao {
    List<WorkListItem> selectPendingWorkList(String equtCd);
}
