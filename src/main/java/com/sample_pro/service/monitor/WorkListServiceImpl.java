package com.sample_pro.service.monitor;

import com.sample_pro.dao.monitor.WorkListDao;
import com.sample_pro.domain.WorkListItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service("workListService")
public class WorkListServiceImpl implements WorkListService {

    @Autowired
    private WorkListDao workListDao;

    @Override
    public List<WorkListItem> getPendingWorkList(String equtCd) {
        return workListDao.selectPendingWorkList(equtCd);
    }
}
