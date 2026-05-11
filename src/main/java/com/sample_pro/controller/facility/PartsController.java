package com.sample_pro.controller.facility;

import com.sample_pro.domain.Parts;
import com.sample_pro.domain.StockHistory;
import com.sample_pro.domain.Users;
import com.sample_pro.service.facility.PartsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
@RequestMapping("/parts")
public class PartsController {

    @Autowired
    private PartsService partsService;





    /* ── 재고 현황 목록 (마스터 + 계산 재고) ── */
    @RequestMapping(value = "/list", method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> list(@RequestParam(required = false) String category,
                                  @RequestParam(required = false) String keyword) {
        try {
            Map<String, Object> params = new HashMap<>();
            if (category != null && !category.isEmpty()) params.put("category", category);
            if (keyword  != null && !keyword.isEmpty())  params.put("keyword",  "%" + keyword + "%");
            List<Parts> list = partsService.getPartsList(params);
            Map<String, Object> m = ok(); m.put("data", list);
            return ResponseEntity.ok(m);
        } catch (Exception e) { return ResponseEntity.ok(err("조회 실패: " + e.getMessage())); }
    }

    /* ── 부품 마스터 저장 (추가/수정) ── */
    @RequestMapping(value = "/save", method = RequestMethod.POST,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> save(@RequestBody Map<String, Object> body) {
        try { partsService.saveParts(body); return ResponseEntity.ok(ok()); }
        catch (Exception e) { return ResponseEntity.ok(err("저장 실패: " + e.getMessage())); }
    }

    /* ── 부품 마스터 삭제 ── */
    @RequestMapping(value = "/delete", method = RequestMethod.POST,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> delete(@RequestBody Map<String, Object> body) {
        try { partsService.deleteParts(body.get("partNo").toString()); return ResponseEntity.ok(ok()); }
        catch (Exception e) { return ResponseEntity.ok(err("삭제 실패: " + e.getMessage())); }
    }

    /* ── 이력 조회 ── */
    @RequestMapping(value = "/history/list", method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> historyList(@RequestParam(required = false) String partNo,
                                         @RequestParam(required = false) String type,
                                         @RequestParam(required = false) String fromDt,
                                         @RequestParam(required = false) String toDt) {
        try {
            Map<String, Object> params = new HashMap<>();
            if (partNo != null && !partNo.isEmpty()) params.put("partNo", partNo);
            if (type   != null && !type.isEmpty())   params.put("type",   type);
            if (fromDt != null && !fromDt.isEmpty()) params.put("fromDt", fromDt);
            if (toDt   != null && !toDt.isEmpty())   params.put("toDt",   toDt);
            List<StockHistory> list = partsService.getHistoryList(params);
            Map<String, Object> m = ok(); m.put("data", list);
            return ResponseEntity.ok(m);
        } catch (Exception e) { return ResponseEntity.ok(err("이력 조회 실패: " + e.getMessage())); }
    }

    /* ── 이력 저장 (입고/사용) ── */
    @RequestMapping(value = "/history/save", method = RequestMethod.POST,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> historySave(@RequestBody Map<String, Object> body,
                                         HttpSession session) {
        try {
            // 담당자 미입력 시 로그인 사용자명 자동 세팅
            if (body.get("userName") == null || body.get("userName").toString().trim().isEmpty()) {
                body.put("userName", getLoginName(session));
            }
            partsService.saveHistory(body);
            return ResponseEntity.ok(ok());
        } catch (Exception e) { return ResponseEntity.ok(err("저장 실패: " + e.getMessage())); }
    }

    /* ── 이력 삭제 ── */
    @RequestMapping(value = "/history/delete", method = RequestMethod.POST,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> historyDelete(@RequestBody Map<String, Object> body) {
        try { partsService.deleteHistory(Integer.parseInt(body.get("id").toString())); return ResponseEntity.ok(ok()); }
        catch (Exception e) { return ResponseEntity.ok(err("삭제 실패: " + e.getMessage())); }
    }

    private String getLoginName(HttpSession session) {
        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> emp = (Map<String, Object>) session.getAttribute("loginEmp");
            if (emp != null && emp.get("emp_name") != null) return emp.get("emp_name").toString();
            com.sample_pro.domain.Users u = (com.sample_pro.domain.Users) session.getAttribute("loginUser");
            if (u != null && u.getUser_name() != null) return u.getUser_name();
        } catch (Exception ignored) {}
        return "";
    }

    private Map<String, Object> ok()  { Map<String,Object> m=new HashMap<>(); m.put("success",true); return m; }
    private Map<String, Object> err(String msg) { Map<String,Object> m=new HashMap<>(); m.put("success",false); m.put("error",msg); return m; }
}
