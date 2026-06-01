package com.sample_pro.service.monitor;

import com.sample_pro.dao.monitor.SeAlarmDao;
import com.sample_pro.domain.SeAlarm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SeAlarmServiceImpl implements SeAlarmService {

    @Autowired
    private SeAlarmDao seAlarmDao;

    @Override
    public List<SeAlarm> getSeAlarmList(String from, String to, Integer areaMask) {
        Map<String, Object> params = new HashMap<>();
        params.put("from",     from + " 00:00:00");
        params.put("to",       to   + " 23:59:59");
        params.put("areaMask", areaMask);
        return seAlarmDao.selectSeAlarmList(params);
    }

    @Override
    public List<Map<String, Object>> getBcfTrendData(int bcf, String from, String to) {
        Map<String, Object> params = new HashMap<>();
        params.put("tableName", "bcf" + bcf + "_");
        params.put("from", from);
        params.put("to",   to);
        return seAlarmDao.selectBcfTrendData(params);
    }
}
