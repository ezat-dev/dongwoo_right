package com.sample_pro.controller.facility;

import com.sample_pro.domain.AlarmTag;
import com.sample_pro.service.facility.FProofService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/fproof")
public class FProofController {

    @Autowired
    private FProofService fProofService;

    /** 설비 전체 태그 + 지정 여부 */
    @RequestMapping(value = "/list", method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> list(@RequestParam String plcId) {
        try {
            List<AlarmTag>  all      = fProofService.getAllTags(plcId);
            List<Integer>   selected = fProofService.getSelectedTagIds(plcId);
            Map<String, Object> res  = new HashMap<>();
            res.put("all",      all);
            res.put("selected", selected);
            return ResponseEntity.ok(res);
        } catch (Exception e) {
            return ResponseEntity.ok(err("조회 실패: " + e.getMessage()));
        }
    }

    /** F/PROOF 지정 추가 */
    @RequestMapping(value = "/select", method = RequestMethod.POST,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> select(@RequestBody Map<String, Object> body) {
        try {
            fProofService.select(toInt(body.get("tagId")), str(body.get("plcId")));
            return ResponseEntity.ok(ok());
        } catch (Exception e) {
            return ResponseEntity.ok(err("지정 실패: " + e.getMessage()));
        }
    }

    /** F/PROOF 지정 해제 */
    @RequestMapping(value = "/deselect", method = RequestMethod.POST,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> deselect(@RequestBody Map<String, Object> body) {
        try {
            fProofService.deselect(toInt(body.get("tagId")), str(body.get("plcId")));
            return ResponseEntity.ok(ok());
        } catch (Exception e) {
            return ResponseEntity.ok(err("해제 실패: " + e.getMessage()));
        }
    }

    private int    toInt(Object v) { return v == null ? 0 : Integer.parseInt(v.toString()); }
    private String str(Object v)   { return v == null ? "" : v.toString(); }

    private Map<String, Object> ok() {
        Map<String,Object> m = new HashMap<>(); m.put("success", true); return m;
    }
    private Map<String, Object> err(String msg) {
        Map<String,Object> m = new HashMap<>(); m.put("success", false); m.put("error", msg); return m;
    }
}
