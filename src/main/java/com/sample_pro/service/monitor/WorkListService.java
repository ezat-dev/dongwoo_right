package com.sample_pro.service.monitor;

import com.sample_pro.domain.WorkListItem;
import java.util.List;

public interface WorkListService {
    List<WorkListItem> getPendingWorkList(String equtCd);
}
