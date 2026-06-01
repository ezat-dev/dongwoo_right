package com.sample_pro.controller.monitor;

import com.sample_pro.domain.WorkListItem;
import com.sample_pro.service.monitor.WorkListService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@Controller
@RequestMapping("/work")
public class WorkListController {

    @Autowired
    private WorkListService workListService;

    // BCF 태그 → EQUT_CD 매핑 (BCF6=2420M011 등 순번 불일치 주의)
    private static final List<Map<String, String>> MACHINES;
    static {
        String[][] data = {
            { "BCF1",  "2420M001" },
            { "BCF2",  "2420M002" },
            { "BCF3",  "2420M003" },
            { "BCF4",  "2420M004" },
            { "BCF5",  "2420M005" },
            { "BCF6",  "2420M011" },
            { "BCF7",  "2420M006" },
            { "BCF8",  "2420M007" },
            { "BCF9",  "2420M008" },
            { "BCF10", "2420M009" },
            { "BCF11", "2420M010" },
            { "BCF12", "2421M002" },
        };
        List<Map<String, String>> list = new ArrayList<>();
        for (String[] row : data) {
            Map<String, String> m = new LinkedHashMap<>();
            m.put("machineTag", row[0]);
            m.put("equtCd",     row[1]);
            list.add(m);
        }
        MACHINES = Collections.unmodifiableList(list);
    }

    // GET /work/jacup/range → 트렌드용 시간범위 조회
    @RequestMapping(value = "/jacup/range", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public ResponseEntity<?> jacupRange(@RequestParam(required = false, defaultValue = "") String equtCd,
                                         @RequestParam String from,
                                         @RequestParam String to) {
        try {
            List<Map<String, Object>> data = workListService.getJacupByRange(equtCd, from, to);
            return ResponseEntity.ok(data);
        } catch (Exception e) {
            return ResponseEntity.ok(Collections.emptyList());
        }
    }

    // GET /work/listData → 12개 설비 미시작 작업지시 일괄 반환
    @RequestMapping(value = "/listData", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public ResponseEntity<?> listData() {
        try {
            List<Map<String, Object>> result = new ArrayList<>();
            for (Map<String, String> machine : MACHINES) {
                String equtCd = machine.get("equtCd");
                List<WorkListItem> items = workListService.getPendingWorkList(equtCd);
                Map<String, Object> entry = new LinkedHashMap<>();
                entry.put("machineTag", machine.get("machineTag"));
                entry.put("equtCd",     equtCd);
                entry.put("items",      items);
                result.add(entry);
            }
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("error",   e.getMessage());
            return ResponseEntity.ok(err);
        }
    }
}
