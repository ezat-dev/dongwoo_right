package com.sample_pro.controller.facility;

import com.sample_pro.domain.CalibThermocouple;
import com.sample_pro.service.facility.CalibService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.util.*;

@Controller
@RequestMapping("/calib")
public class CalibController {

    @Autowired
    private CalibService calibService;

    private static final String ATTACH_DIR = "D:/save/Calib";

    /* 목록 조회 */
    @RequestMapping(value = "/list", method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> list(@RequestParam(required = false) String equipType,
                                  @RequestParam(required = false) String status,
                                  @RequestParam(required = false) String keyword) {
        try {
            Map<String, Object> params = new HashMap<>();
            if (equipType != null && !equipType.isEmpty()) params.put("equipType", equipType);
            if (status    != null && !status.isEmpty())    params.put("status",    status);
            if (keyword   != null && !keyword.isEmpty())   params.put("keyword",   "%" + keyword + "%");

            List<CalibThermocouple> list = calibService.getList(params);
            Map<String, Object> m = ok();
            m.put("data", list);
            return ResponseEntity.ok(m);
        } catch (Exception e) {
            return ResponseEntity.ok(err("조회 실패: " + e.getMessage()));
        }
    }

    /* D-Day 7일 이내 알림 목록 */
    @RequestMapping(value = "/dday/alert", method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> ddayAlert() {
        try {
            List<CalibThermocouple> list = calibService.getDdayAlerts();
            Map<String, Object> m = ok();
            m.put("data", list);
            return ResponseEntity.ok(m);
        } catch (Exception e) {
            return ResponseEntity.ok(err("알림 조회 실패: " + e.getMessage()));
        }
    }

    /* 저장 (추가/수정) */
    @RequestMapping(value = "/save", method = RequestMethod.POST,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> save(@RequestBody Map<String, Object> body) {
        try {
            calibService.save(body);
            return ResponseEntity.ok(ok());
        } catch (Exception e) {
            return ResponseEntity.ok(err("저장 실패: " + e.getMessage()));
        }
    }

    /* 삭제 */
    @RequestMapping(value = "/delete", method = RequestMethod.POST,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> delete(@RequestBody Map<String, Object> body) {
        try {
            int calibId = Integer.parseInt(body.get("calibId").toString());
            calibService.delete(calibId);
            return ResponseEntity.ok(ok());
        } catch (Exception e) {
            return ResponseEntity.ok(err("삭제 실패: " + e.getMessage()));
        }
    }

    /* 첨부 파일 업로드 */
    @RequestMapping(value = "/attach/upload", method = RequestMethod.POST,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> attachUpload(@RequestParam int calibId,
                                          @RequestParam("file") MultipartFile file) {
        try {
            String saved = calibService.uploadAttach(calibId, file);
            Map<String, Object> m = ok();
            m.put("attachFile", saved);
            return ResponseEntity.ok(m);
        } catch (Exception e) {
            return ResponseEntity.ok(err("업로드 실패: " + e.getMessage()));
        }
    }

    /* 첨부 파일 다운로드/서빙 */
    @RequestMapping(value = "/attach/{filename:.+}", method = RequestMethod.GET)
    public void attachServe(@PathVariable String filename,
                            HttpServletResponse response) throws Exception {
        File f = new File(ATTACH_DIR, filename);
        if (!f.exists()) { response.sendError(404); return; }

        String mimeType = Files.probeContentType(f.toPath());
        if (mimeType == null) mimeType = "application/octet-stream";
        response.setContentType(mimeType);
        response.setContentLength((int) f.length());

        String encodedName = URLEncoder.encode(filename, "UTF-8");
        if (mimeType.startsWith("image/") || mimeType.equals("application/pdf")) {
            response.setHeader("Content-Disposition", "inline; filename*=UTF-8''" + encodedName);
        } else {
            response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encodedName);
        }

        try (FileInputStream fis = new FileInputStream(f)) {
            byte[] buf = new byte[8192];
            int len;
            while ((len = fis.read(buf)) != -1) response.getOutputStream().write(buf, 0, len);
        }
    }

    private Map<String, Object> ok()  { Map<String,Object> m=new HashMap<>(); m.put("success",true);  return m; }
    private Map<String, Object> err(String msg) { Map<String,Object> m=new HashMap<>(); m.put("success",false); m.put("error",msg); return m; }
}
