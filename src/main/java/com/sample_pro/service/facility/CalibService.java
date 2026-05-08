package com.sample_pro.service.facility;

import com.sample_pro.domain.CalibThermocouple;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;
import java.util.Map;

public interface CalibService {
    List<CalibThermocouple> getList(Map<String, Object> params);
    List<CalibThermocouple> getDdayAlerts();
    void save(Map<String, Object> body);
    void delete(int calibId);
    String uploadAttach(int calibId, MultipartFile file) throws Exception;
}
