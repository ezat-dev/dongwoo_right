// package com.sample_pro.controller.facility;

// import com.sample_pro.service.facility.InspectService;
// import org.apache.poi.ss.usermodel.Workbook;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.http.MediaType;
// import org.springframework.http.ResponseEntity;
// import org.springframework.stereotype.Controller;
// import org.springframework.web.bind.annotation.*;
// import org.springframework.web.multipart.MultipartFile;

// import javax.servlet.http.HttpServletResponse;
// import javax.servlet.http.HttpSession;
// import java.io.File;
// import java.io.FileInputStream;
// import java.net.URLEncoder;
// import java.nio.file.Files;
// import java.util.*;

// @Controller
// @RequestMapping("/inspect")
// public class InspectController {

//     @Autowired
//     private InspectService inspectService;

//     @RequestMapping(value = "/load", method = RequestMethod.GET,
//             produces = MediaType.APPLICATION_JSON_VALUE)
//     @ResponseBody
//     public ResponseEntity<?> load(@RequestParam String equipId,
//                                    @RequestParam String ym,
//                                    HttpSession session) {
//         try {
//             return ResponseEntity.ok(inspectService.loadData(equipId, ym, session));
//         } catch (Exception e) {
//             return ResponseEntity.ok(err("데이터 조회 실패: " + e.getMessage()));
//         }
//     }

//     @RequestMapping(value = "/item/add", method = RequestMethod.POST,
//             produces = MediaType.APPLICATION_JSON_VALUE)
//     @ResponseBody
//     public ResponseEntity<?> itemAdd(@RequestBody Map<String, Object> body) {
//         try { inspectService.addItem(body); return ResponseEntity.ok(ok()); }
//         catch (Exception e) { return ResponseEntity.ok(err("항목 추가 실패: " + e.getMessage())); }
//     }

//     @RequestMapping(value = "/item/edit", method = RequestMethod.POST,
//             produces = MediaType.APPLICATION_JSON_VALUE)
//     @ResponseBody
//     public ResponseEntity<?> itemEdit(@RequestBody Map<String, Object> body) {
//         try { inspectService.editItem(body); return ResponseEntity.ok(ok()); }
//         catch (Exception e) { return ResponseEntity.ok(err("항목 수정 실패: " + e.getMessage())); }
//     }

//     @RequestMapping(value = "/item/delete", method = RequestMethod.POST,
//             produces = MediaType.APPLICATION_JSON_VALUE)
//     @ResponseBody
//     public ResponseEntity<?> itemDelete(@RequestBody Map<String, Object> body) {
//         try {
//             inspectService.deleteItem(Integer.parseInt(body.get("itemId").toString()));
//             return ResponseEntity.ok(ok());
//         } catch (Exception e) { return ResponseEntity.ok(err("항목 삭제 실패: " + e.getMessage())); }
//     }

//     /* 셀 단위 결과 저장 (클릭 즉시 저장) */
//     @RequestMapping(value = "/result/cell", method = RequestMethod.POST,
//             produces = MediaType.APPLICATION_JSON_VALUE)
//     @ResponseBody
//     public ResponseEntity<?> resultCell(@RequestBody Map<String, Object> body) {
//         try { inspectService.saveCell(body); return ResponseEntity.ok(ok()); }
//         catch (Exception e) { return ResponseEntity.ok(err("저장 실패: " + e.getMessage())); }
//     }

//     /* 헤더 저장 (점검자/확인자/상태) */
//     @RequestMapping(value = "/header/save", method = RequestMethod.POST,
//             produces = MediaType.APPLICATION_JSON_VALUE)
//     @ResponseBody
//     public ResponseEntity<?> headerSave(@RequestBody Map<String, Object> body) {
//         try { inspectService.saveHeader(body); return ResponseEntity.ok(ok()); }
//         catch (Exception e) { return ResponseEntity.ok(err("저장 실패: " + e.getMessage())); }
//     }

//     /* 엑셀 출력 */
//     @RequestMapping(value = "/excel/export", method = RequestMethod.GET)
//     public void excelExport(@RequestParam String equipId,
//                             @RequestParam String ym,
//                             HttpSession session,
//                             HttpServletResponse response) throws Exception {
//         String fileName = URLEncoder.encode(equipId + "_" + ym + "_일상점검일지.xlsx", "UTF-8");
//         response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
//         response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + fileName);
//         try (Workbook wb = inspectService.exportExcel(equipId, ym, session)) {
//             wb.write(response.getOutputStream());
//         }
//     }

//     /* 엑셀 임포트 */
//     @RequestMapping(value = "/excel/import", method = RequestMethod.POST,
//             produces = MediaType.APPLICATION_JSON_VALUE)
//     @ResponseBody
//     public ResponseEntity<?> excelImport(@RequestParam String equipId,
//                                           @RequestParam String ym,
//                                           @RequestParam("file") MultipartFile file) {
//         try {
//             int count = inspectService.importExcel(equipId, ym, file);
//             Map<String, Object> m = ok();
//             m.put("count", count);
//             return ResponseEntity.ok(m);
//         } catch (Exception e) { return ResponseEntity.ok(err("임포트 실패: " + e.getMessage())); }
//     }

//     private static final String IMG_DIR = "D:/save/Inspect";

//     /* 이미지 업로드 */
//     @RequestMapping(value = "/item/image/upload", method = RequestMethod.POST,
//             produces = MediaType.APPLICATION_JSON_VALUE)
//     @ResponseBody
//     public ResponseEntity<?> imageUpload(@RequestParam int itemId,
//                                          @RequestParam("file") MultipartFile file) {
//         try {
//             String savedName = inspectService.uploadItemImage(itemId, file);
//             Map<String, Object> m = ok();
//             m.put("imgFile", savedName);
//             return ResponseEntity.ok(m);
//         } catch (Exception e) { return ResponseEntity.ok(err("이미지 업로드 실패: " + e.getMessage())); }
//     }

//     /* 이미지 서빙 */
//     @RequestMapping(value = "/item/image/{filename:.+}", method = RequestMethod.GET)
//     public void imageServe(@PathVariable String filename,
//                            HttpServletResponse response) throws Exception {
//         File f = new File(IMG_DIR, filename);
//         if (!f.exists()) { response.sendError(404); return; }
//         response.setContentType(Files.probeContentType(f.toPath()));
//         response.setContentLength((int) f.length());
//         try (FileInputStream fis = new FileInputStream(f)) {
//             byte[] buf = new byte[8192];
//             int len;
//             while ((len = fis.read(buf)) != -1) response.getOutputStream().write(buf, 0, len);
//         }
//     }

//     private Map<String, Object> ok()  { Map<String,Object> m=new HashMap<>(); m.put("success",true);  return m; }
//     private Map<String, Object> err(String msg) { Map<String,Object> m=new HashMap<>(); m.put("success",false); m.put("error",msg); return m; }
// }
