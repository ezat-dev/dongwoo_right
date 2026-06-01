package com.sample_pro.service.monitor;

import com.sample_pro.domain.SeAlarm;
import java.util.List;
import java.util.Map;

public interface SeAlarmService {
    List<SeAlarm> getSeAlarmList(String from, String to, Integer areaMask);
    List<Map<String, Object>> getBcfTrendData(int bcf, String from, String to);
}
