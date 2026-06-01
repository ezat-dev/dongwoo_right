package com.sample_pro.dao.monitor;

import com.sample_pro.domain.SeAlarm;
import java.util.List;
import java.util.Map;

public interface SeAlarmDao {
    List<SeAlarm> selectSeAlarmList(Map<String, Object> params);
    List<Map<String, Object>> selectBcfTrendData(Map<String, Object> params);
}
