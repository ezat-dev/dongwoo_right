package com.sample_pro.dao.facility;

import com.sample_pro.domain.CalibThermocouple;
import java.util.List;
import java.util.Map;

public interface CalibDao {
    List<CalibThermocouple> selectList(Map<String, Object> params);
    CalibThermocouple       selectById(int calibId);
    List<CalibThermocouple> selectDdayAlerts();
    void insert(CalibThermocouple c);
    void update(CalibThermocouple c);
    void updateAttach(Map<String, Object> params);
    void softDelete(int calibId);
}
