package com.sample_pro.controller.facility;

import com.sample_pro.service.facility.FProofListService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("/fprooflist")
public class FProofListController {

    @Autowired
    private FProofListService fProofListService;

    /** Fool Proof 세션 목록 (시작/종료 페어) */
    @RequestMapping(value = "/sessions", method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> sessions(@RequestParam String from,
                                      @RequestParam String to) {
        try {
            return ResponseEntity.ok(fProofListService.getSessions(from, to));
        } catch (Exception e) {
            Map<String, Object> err = new HashMap<>();
            err.put("error", e.getMessage());
            return ResponseEntity.ok(err);
        }
    }

    /** 세션 구간의 F/PROOF 지정 알람 이력 */
    @RequestMapping(value = "/detail", method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> detail(@RequestParam String plcId,
                                    @RequestParam String start,
                                    @RequestParam(required = false) String end) {
        try {
            if (end == null || end.isEmpty()) {
                end = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
            }
            return ResponseEntity.ok(fProofListService.getDetail(plcId, start, end));
        } catch (Exception e) {
            Map<String, Object> err = new HashMap<>();
            err.put("error", e.getMessage());
            return ResponseEntity.ok(err);
        }
    }
}
