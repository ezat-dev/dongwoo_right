package com.sample_pro.service.facility;

import com.sample_pro.dao.facility.CalibDao;
import com.sample_pro.domain.CalibThermocouple;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.*;

@Service
public class CalibServiceImpl implements CalibService {

    @Autowired
    private CalibDao calibDao;

    private static final String ATTACH_DIR = "D:/save/Calib";

    @Override
    public List<CalibThermocouple> getList(Map<String, Object> params) {
        return calibDao.selectList(params);
    }

    @Override
    public List<CalibThermocouple> getDdayAlerts() {
        return calibDao.selectDdayAlerts();
    }

    @Override
    public void save(Map<String, Object> body) {
        CalibThermocouple c = new CalibThermocouple();

        Object calibIdObj = body.get("calibId");
        int calibId = (calibIdObj != null && !calibIdObj.toString().isEmpty())
                ? Integer.parseInt(calibIdObj.toString()) : 0;

        c.setEquipType(str(body.get("equipType")));
        c.setEquipName(str(body.get("equipName")));
        c.setZoneLocation(str(body.get("zoneLocation")));
        c.setMeasLocation(str(body.get("measLocation")));
        c.setLastCalibDt(str(body.get("lastCalibDt")));
        c.setNextCalibDt(str(body.get("nextCalibDt")));
        c.setJudgment(str(body.get("judgment")));
        c.setStatus(str(body.get("status")));
        c.setHandler(str(body.get("handler")));
        c.setRemark(str(body.get("remark")));

        try { c.setStdTemp(Double.parseDouble(body.get("stdTemp").toString())); } catch (Exception ignored) {}
        try { c.setMeasTemp(Double.parseDouble(body.get("measTemp").toString())); } catch (Exception ignored) {}

        // 편차 자동 계산
        if (c.getStdTemp() != null && c.getMeasTemp() != null) {
            double dev = Math.round((c.getMeasTemp() - c.getStdTemp()) * 100.0) / 100.0;
            c.setDeviation(dev);
        }

        // 상태 자동 계산 (저장 시 최신화)
        if (c.getNextCalibDt() != null && !c.getNextCalibDt().isEmpty()) {
            c.setStatus(calcStatus(c.getNextCalibDt()));
        }

        if (calibId > 0) {
            c.setCalibId(calibId);
            calibDao.update(c);
        } else {
            calibDao.insert(c);
        }
    }

    @Override
    public void delete(int calibId) {
        calibDao.softDelete(calibId);
    }

    @Override
    public String uploadAttach(int calibId, MultipartFile file) throws Exception {
        File dir = new File(ATTACH_DIR);
        if (!dir.exists()) dir.mkdirs();

        String orig = file.getOriginalFilename();
        String ext  = (orig != null && orig.contains(".")) ? orig.substring(orig.lastIndexOf('.')) : "";
        String saved = "calib_" + calibId + "_" + System.currentTimeMillis() + ext;
        file.transferTo(new File(dir, saved));

        Map<String, Object> p = new HashMap<>();
        p.put("calibId",    calibId);
        p.put("attachFile", saved);
        calibDao.updateAttach(p);
        return saved;
    }

    /* ── 유틸 ── */
    private String str(Object o) { return o == null ? "" : o.toString().trim(); }

    private String calcStatus(String nextCalibDt) {
        try {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
            Date next = sdf.parse(nextCalibDt);
            Date today = new Date();
            long diffMs   = next.getTime() - today.getTime();
            long diffDays = diffMs / (1000L * 60 * 60 * 24);
            if (diffDays < 0)       return "초과";
            if (diffDays <= 7)      return "보정필요";
            if (diffDays <= 30)     return "보정예정";
            return "정상";
        } catch (Exception e) {
            return "정상";
        }
    }
}
