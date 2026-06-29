package com.sample_pro.controller.facility;

import com.sample_pro.domain.SeAlarm;
import com.sample_pro.service.monitor.SeAlarmService;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
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

    /* ── 알람 엑셀 다운로드 ── */
    @RequestMapping(value = "/alarm/excel", method = RequestMethod.GET)
    public void alarmExcel(
            @RequestParam("from") String from,
            @RequestParam("to")   String to,
            @RequestParam(value = "areaMask", defaultValue = "0") int areaMask,
            HttpServletResponse response) throws Exception {

        List<SeAlarm> list =
                seAlarmService.getSeAlarmList(from, to, areaMask > 0 ? areaMask : null);

        try (Workbook wb = new XSSFWorkbook()) {
            Sheet sh = wb.createSheet("알람이력");

            CellStyle hdrSt = wb.createCellStyle();
            Font hdrFont = wb.createFont();
            hdrFont.setBold(true);
            hdrSt.setFont(hdrFont);
            hdrSt.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
            hdrSt.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            hdrSt.setBorderBottom(BorderStyle.THIN);

            String[] headers = {"#", "설비", "PV", "설정값", "발생시간", "복귀시간", "알람내용"};
            Row hdrRow = sh.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                Cell c = hdrRow.createCell(i);
                c.setCellValue(headers[i]);
                c.setCellStyle(hdrSt);
            }

            for (int i = 0; i < list.size(); i++) {
                SeAlarm r = list.get(i);
                Row row = sh.createRow(i + 1);
                row.createCell(0).setCellValue(i + 1);
                row.createCell(1).setCellValue(nvl(r.getSource()));
                row.createCell(2).setCellValue(nvl(r.getPv()));
                row.createCell(3).setCellValue(nvl(r.getTripValue()));
                row.createCell(4).setCellValue(nvl(r.getTimeAct()));
                row.createCell(5).setCellValue(nvl(r.getTimeRtn()));
                row.createCell(6).setCellValue(nvl(r.getDescString()));
            }

            sh.setColumnWidth(0,  6 * 256);
            sh.setColumnWidth(1, 10 * 256);
            sh.setColumnWidth(2, 20 * 256);
            sh.setColumnWidth(3, 20 * 256);
            sh.setColumnWidth(4, 22 * 256);
            sh.setColumnWidth(5, 22 * 256);
            sh.setColumnWidth(6, 60 * 256);

            String fname = URLEncoder.encode("알람이력_" + from + "_" + to + ".xlsx", "UTF-8");
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + fname);
            wb.write(response.getOutputStream());
        }
    }

    private String nvl(Object o) { return o == null ? "" : o.toString(); }

    private Map<String, Object> err(String msg) {
        Map<String, Object> m = new HashMap<>();
        m.put("success", false);
        m.put("error",   msg);
        return m;
    }
}
