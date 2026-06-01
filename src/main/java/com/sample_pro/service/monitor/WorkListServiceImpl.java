package com.sample_pro.service.monitor;

import com.sample_pro.dao.monitor.WorkListDao;
import com.sample_pro.domain.WorkListItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("workListService")
public class WorkListServiceImpl implements WorkListService {

    @Autowired
    private WorkListDao workListDao;

    @Override
    public List<WorkListItem> getPendingWorkList(String equtCd) {
        return workListDao.selectPendingWorkList(equtCd);
    }

    @Override
    public List<Map<String, Object>> getJacupByRange(String equtCd, String from, String to) {
        Map<String, Object> params = new HashMap<>();
        params.put("equtCd", (equtCd != null && !equtCd.isEmpty()) ? equtCd : null);
        params.put("from", from);
        params.put("to",   to);
        return workListDao.selectJacupByRange(params);
    }
}
