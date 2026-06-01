package com.sample_pro.controller.facility;

import com.sample_pro.service.monitor.SeAlarmService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/backup")
public class BackupController {

    @Autowired
    private SeAlarmService seAlarmService;

    @RequestMapping(value = "/alarm/list", method = RequestMethod.GET,
                    produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> alarmList(
            @RequestParam("from") String from,
            @RequestParam("to")   String to,
            @RequestParam(value = "areaMask", defaultValue = "0") int areaMask) {
        try {
            return ResponseEntity.ok(
                seAlarmService.getSeAlarmList(from, to, areaMask > 0 ? areaMask : null)
            );
        } catch (Exception e) {
            return ResponseEntity.ok(err(e.getMessage()));
        }
    }

    @RequestMapping(value = "/trend/data", method = RequestMethod.GET,
                    produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> trendData(
            @RequestParam("bcf")  int    bcf,
            @RequestParam("from") String from,
            @RequestParam("to")   String to) {
        try {
            if (bcf < 1 || bcf > 12) return ResponseEntity.ok(err("bcf 범위 오류 (1-12)"));
            return ResponseEntity.ok(seAlarmService.getBcfTrendData(bcf, from, to));
        } catch (Exception e) {
            return ResponseEntity.ok(err(e.getMessage()));
        }
    }

    private Map<String, Object> err(String msg) {
        Map<String, Object> m = new HashMap<>();
        m.put("success", false);
        m.put("error",   msg);
        return m;
    }
}
