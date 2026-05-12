package com.sample_pro.controller.management;

import com.sample_pro.service.facility.InspectService;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.util.*;

@Controller
@RequestMapping("/productInsert")
public class ProductInsertController {

    @Autowired
    private InspectService inspectService;



    
    @RequestMapping(value = "/load", method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> load(@RequestParam String equipId,
                                   @RequestParam String ym,
                                   HttpSession session) {
        try {
            return ResponseEntity.ok(inspectService.loadData(equipId, ym, session));
        } catch (Exception e) {
            return ResponseEntity.ok(err("데이터 조회 실패: " + e.getMessage()));
        }
    }

    

    private Map<String, Object> ok()  { Map<String,Object> m=new HashMap<>(); m.put("success",true);  return m; }
    private Map<String, Object> err(String msg) { Map<String,Object> m=new HashMap<>(); m.put("success",false); m.put("error",msg); return m; }
}
