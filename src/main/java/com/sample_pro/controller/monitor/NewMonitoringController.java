package com.sample_pro.controller.monitor;

import com.sample_pro.service.monitor.MonitorCacheService;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

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

    public NewMonitoringController(MonitorCacheService cacheService) {
        this.cacheService = cacheService;
    }

    @GetMapping(value = "/snapshot", produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> snapshot() {
        return cacheService.getSnapshot();
    }
}
