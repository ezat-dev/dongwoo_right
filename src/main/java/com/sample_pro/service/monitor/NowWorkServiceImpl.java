package com.sample_pro.service.monitor;

import com.sample_pro.dao.monitor.NowWorkDao;
import com.sample_pro.domain.NowWorkItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NowWorkServiceImpl implements NowWorkService {

    @Autowired
    private NowWorkDao nowWorkDao;

    @Override
    public List<NowWorkItem> getListByPageNo(int pageNo) {
        return nowWorkDao.selectByPageNo(pageNo);
    }
}
