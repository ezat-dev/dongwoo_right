package com.sample_pro.controller.monitor;

import com.sample_pro.service.monitor.CommErrMemoService;
import com.sample_pro.service.monitor.MonitorCacheService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * GET /monitor/snapshot — MonitorCacheService 가 2초마다 갱신한 스냅샷 반환.
 *
 * 브라우저 → GET /monitor/snapshot → 캐시된 태그→값 맵
 * PLC 폴링은 MonitorCacheService (@Scheduled) 에서 서버 사이드로 처리.
 */
@RestController
@RequestMapping("/monitor")
public class NewMonitoringController {

    private final MonitorCacheService cacheService;

    @Autowired
    private CommErrMemoService commErrMemoService;

    public NewMonitoringController(MonitorCacheService cacheService) {
        this.cacheService = cacheService;
    }

    @GetMapping(value = "/snapshot", produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> snapshot() {
        return cacheService.getSnapshot();
    }

    /** 현재 통신 오류 호기 목록 — main_monitor.jsp 팝업용 */
    @GetMapping(value = "/comm-errors", produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> commErrors() {
        List<Map<String, String>> errors = commErrMemoService.getCommErrors();
        Map<String, Object> resp = new java.util.HashMap<>();
        resp.put("errors", errors);
        return resp;
    }
}
