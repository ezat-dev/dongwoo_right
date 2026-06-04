package com.sample_pro.controller.facility;

import com.sample_pro.domain.ConsumableLedger;
import com.sample_pro.domain.ConsumableLedgerHistory;
import com.sample_pro.service.facility.ConsumableLedgerService;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("/consumable")
public class ConsumableLedgerController {

    @Autowired
    private ConsumableLedgerService consumableLedgerService;

    /* ── 목록 조회 ── */
    @RequestMapping(value = "/list", method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> list() {
        try {
            List<ConsumableLedger> list = consumableLedgerService.getList();
            Map<String, Object> m = ok();
            m.put("data", list);
            return ResponseEntity.ok(m);
        } catch (Exception e) {
            return ResponseEntity.ok(err("조회 실패: " + e.getMessage()));
        }
    }

    /* ── 저장 (추가/수정) ── */
    @RequestMapping(value = "/save", method = RequestMethod.POST,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> save(@RequestBody Map<String, Object> body) {
        try {
            ConsumableLedger item = new ConsumableLedger();
            if (body.get("id") != null && !body.get("id").toString().isEmpty()) {
                try { item.setId(Long.parseLong(body.get("id").toString())); } catch (Exception ignored) {}
            }
            item.setCategory(str(body.get("category")));
            item.setItemName(str(body.get("itemName")));
            item.setPackageUnit(str(body.get("packageUnit")));
            item.setStockQty(str(body.get("stockQty")));
            item.setStockUnit(str(body.get("stockUnit")));
            item.setSafetyQty(str(body.get("safetyQty")));
            item.setSafetyUnit(str(body.get("safetyUnit")));
            item.setRemark(str(body.get("remark")));
            try { item.setSortOrder(Integer.parseInt(body.get("sortOrder").toString())); } catch (Exception ignored) {}
            consumableLedgerService.save(item);
            return ResponseEntity.ok(ok());
        } catch (Exception e) {
            return ResponseEntity.ok(err("저장 실패: " + e.getMessage()));
        }
    }

    /* ── 삭제 (논리 삭제) ── */
    @RequestMapping(value = "/delete", method = RequestMethod.POST,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> delete(@RequestBody Map<String, Object> body) {
        try {
            Long id = Long.parseLong(body.get("id").toString());
            consumableLedgerService.delete(id);
            return ResponseEntity.ok(ok());
        } catch (Exception e) {
            return ResponseEntity.ok(err("삭제 실패: " + e.getMessage()));
        }
    }

    /* ── 이력 목록 조회 ── */
    @RequestMapping(value = "/history/list", method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> historyList(
            @RequestParam(required = false) String ledgerId,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) String fromDt,
            @RequestParam(required = false) String toDt) {
        try {
            Map<String, Object> params = new HashMap<>();
            if (ledgerId != null && !ledgerId.isEmpty()) params.put("ledgerId", Long.parseLong(ledgerId));
            if (type   != null && !type.isEmpty())   params.put("type",   type);
            if (fromDt != null && !fromDt.isEmpty()) params.put("fromDt", fromDt);
            if (toDt   != null && !toDt.isEmpty())   params.put("toDt",   toDt);
            List<ConsumableLedgerHistory> list = consumableLedgerService.getHistoryList(params);
            Map<String, Object> m = ok(); m.put("data", list);
            return ResponseEntity.ok(m);
        } catch (Exception e) {
            return ResponseEntity.ok(err("이력 조회 실패: " + e.getMessage()));
        }
    }

    /* ── 이력 저장 (입고/사용) ── */
    @RequestMapping(value = "/history/save", method = RequestMethod.POST,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> historySave(@RequestBody Map<String, Object> body) {
        try {
            consumableLedgerService.saveHistory(body);
            return ResponseEntity.ok(ok());
        } catch (Exception e) {
            return ResponseEntity.ok(err("저장 실패: " + e.getMessage()));
        }
    }

    /* ── 이력 삭제 ── */
    @RequestMapping(value = "/history/delete", method = RequestMethod.POST,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> historyDelete(@RequestBody Map<String, Object> body) {
        try {
            Long id = Long.parseLong(body.get("id").toString());
            consumableLedgerService.deleteHistory(id);
            return ResponseEntity.ok(ok());
        } catch (Exception e) {
            return ResponseEntity.ok(err("삭제 실패: " + e.getMessage()));
        }
    }

    /* ── 엑셀 다운로드 ── */
    @RequestMapping(value = "/excel", method = RequestMethod.GET)
    public void excel(HttpServletResponse response) throws Exception {
        List<ConsumableLedger> list = consumableLedgerService.getList();
        String today = new SimpleDateFormat("yyyyMMdd").format(new Date());

        try (Workbook wb = new XSSFWorkbook()) {
            Sheet sheet = wb.createSheet("유류소모재관리대장");

            CellStyle titleStyle      = makeTitleStyle(wb);
            CellStyle yellowHdrStyle  = makeYellowHeaderStyle(wb);
            CellStyle dataStyle       = makeDataStyle(wb);
            CellStyle dataCenterStyle = makeDataCenterStyle(wb);
            CellStyle sectionStyle    = makeSectionStyle(wb);
            CellStyle infoLabelStyle  = makeInfoLabelStyle(wb);

            /* ── 열 너비 (A~H) ── */
            sheet.setColumnWidth(0, 16 * 256);  // A: 구분
            sheet.setColumnWidth(1, 22 * 256);  // B: 품명/규격
            sheet.setColumnWidth(2, 14 * 256);  // C: 포장단위
            sheet.setColumnWidth(3, 12 * 256);  // D: 보유재고 수량
            sheet.setColumnWidth(4, 10 * 256);  // E: 보유재고 단위
            sheet.setColumnWidth(5, 14 * 256);  // F: 안전재고 수량
            sheet.setColumnWidth(6, 10 * 256);  // G: 안전재고 단위
            sheet.setColumnWidth(7, 30 * 256);  // H: 비고

            int r = 0;

            /* ── Row 0~2 (Excel 1~3행): 제목 ── */
            Row row0 = sheet.createRow(r++); row0.setHeightInPoints(36);
            Cell titleCell = row0.createCell(0);
            titleCell.setCellValue("유류, 소모재 관리대장");
            titleCell.setCellStyle(titleStyle);
            sheet.addMergedRegion(new CellRangeAddress(0, 2, 0, 7));

            Row row1 = sheet.createRow(r++); row1.setHeightInPoints(26);
            Row row2 = sheet.createRow(r++); row2.setHeightInPoints(26);
            for (int c = 0; c <= 7; c++) {
                if (c > 0) row0.createCell(c).setCellStyle(titleStyle);
                row1.createCell(c).setCellStyle(titleStyle);
                row2.createCell(c).setCellStyle(titleStyle);
            }

            /* ── Row 3 (Excel 4행): 빈 간격 ── */
            sheet.createRow(r++).setHeightInPoints(8);

            /* ── Row 4 (Excel 5행 = F5): 점검일 ── */
            Row rowInfo1 = sheet.createRow(r++); rowInfo1.setHeightInPoints(20);
            Cell dtLbl = rowInfo1.createCell(5);
            dtLbl.setCellValue("점검일 :");
            dtLbl.setCellStyle(infoLabelStyle);
            Cell dtVal = rowInfo1.createCell(6);
            dtVal.setCellValue("     년         월         일");
            dtVal.setCellStyle(dataStyle);
            sheet.addMergedRegion(new CellRangeAddress(r - 1, r - 1, 6, 7));

            /* ── Row 5 (Excel 6행): 섹션 헤더 + 점검자 ── */
            Row rowInfo2 = sheet.createRow(r++); rowInfo2.setHeightInPoints(20);
            Cell secCell = rowInfo2.createCell(0);
            secCell.setCellValue("1. 유류 점검");
            secCell.setCellStyle(sectionStyle);
            sheet.addMergedRegion(new CellRangeAddress(r - 1, r - 1, 0, 4));
            Cell nmLbl = rowInfo2.createCell(5);
            nmLbl.setCellValue("점검자 :");
            nmLbl.setCellStyle(infoLabelStyle);

            /* ── Row 6 (Excel 7행): 컬럼 헤더 (황색) ── */
            Row hdrRow1 = sheet.createRow(r++); hdrRow1.setHeightInPoints(20);
            String[] hdrs = {"구분", "품명/규격", "포장단위", "보유 재고", "", "안전 재고", "", "비고 (특이사항)"};
            for (int i = 0; i < hdrs.length; i++) {
                Cell c = hdrRow1.createCell(i);
                c.setCellValue(hdrs[i]);
                c.setCellStyle(yellowHdrStyle);
            }
            sheet.addMergedRegion(new CellRangeAddress(r - 1, r - 1, 3, 4));
            sheet.addMergedRegion(new CellRangeAddress(r - 1, r - 1, 5, 6));

            /* ── Row 7 (Excel 8행): 서브 헤더 ── */
            Row hdrRow2 = sheet.createRow(r++); hdrRow2.setHeightInPoints(16);
            String[] subHdrs = {"", "", "", "수량", "단위", "수량", "단위", ""};
            for (int i = 0; i < subHdrs.length; i++) {
                Cell c = hdrRow2.createCell(i);
                c.setCellValue(subHdrs[i]);
                c.setCellStyle(yellowHdrStyle);
            }
            sheet.addMergedRegion(new CellRangeAddress(r - 2, r - 1, 0, 0));
            sheet.addMergedRegion(new CellRangeAddress(r - 2, r - 1, 1, 1));
            sheet.addMergedRegion(new CellRangeAddress(r - 2, r - 1, 2, 2));
            sheet.addMergedRegion(new CellRangeAddress(r - 2, r - 1, 7, 7));

            /* ── 데이터 행 ── */
            String prevCat = null;
            int catStartRow = r;
            for (int i = 0; i < list.size(); i++) {
                ConsumableLedger item = list.get(i);
                Row dr = sheet.createRow(r); dr.setHeightInPoints(18);

                Cell cc = dr.createCell(0); cc.setCellValue(nvl(item.getCategory())); cc.setCellStyle(dataCenterStyle);
                Cell bc = dr.createCell(1); bc.setCellValue(nvl(item.getItemName()));   bc.setCellStyle(dataStyle);
                Cell pc = dr.createCell(2); pc.setCellValue(nvl(item.getPackageUnit())); pc.setCellStyle(dataCenterStyle);
                Cell sq = dr.createCell(3); sq.setCellValue(nvl(item.getStockQty()));  sq.setCellStyle(dataCenterStyle);
                Cell su = dr.createCell(4); su.setCellValue(nvl(item.getStockUnit())); su.setCellStyle(dataCenterStyle);
                Cell fq = dr.createCell(5); fq.setCellValue(nvl(item.getSafetyQty())); fq.setCellStyle(dataCenterStyle);
                Cell fu = dr.createCell(6); fu.setCellValue(nvl(item.getSafetyUnit())); fu.setCellStyle(dataCenterStyle);
                Cell rm = dr.createCell(7); rm.setCellValue(nvl(item.getRemark()));    rm.setCellStyle(dataStyle);

                String curCat = nvl(item.getCategory());
                if (!curCat.equals(prevCat)) catStartRow = r;
                boolean isLast = (i == list.size() - 1);
                String nextCat = isLast ? null : nvl(list.get(i + 1).getCategory());
                if (isLast || !curCat.equals(nextCat)) {
                    if (r > catStartRow) sheet.addMergedRegion(new CellRangeAddress(catStartRow, r, 0, 0));
                }
                prevCat = curCat;
                r++;
            }
            if (list.isEmpty()) {
                Row er = sheet.createRow(r);
                Cell ec = er.createCell(0); ec.setCellValue("데이터가 없습니다."); ec.setCellStyle(dataStyle);
                sheet.addMergedRegion(new CellRangeAddress(r, r, 0, 7));
            }

            /* ── 응답 ── */
            String filename = URLEncoder.encode("유류_소모재_관리대장_" + today + ".xlsx", "UTF-8");
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + filename);
            wb.write(response.getOutputStream());
        }
    }

    /* ═══════════════════════════
       Excel 스타일 헬퍼
    ═══════════════════════════ */
    private CellStyle makeTitleStyle(Workbook wb) {
        CellStyle s = wb.createCellStyle();
        Font f = wb.createFont(); f.setBold(true); f.setFontHeightInPoints((short) 18);
        s.setFont(f);
        s.setAlignment(HorizontalAlignment.CENTER);
        s.setVerticalAlignment(VerticalAlignment.CENTER);
        s.setBorderBottom(BorderStyle.MEDIUM); s.setBorderTop(BorderStyle.MEDIUM);
        s.setBorderLeft(BorderStyle.MEDIUM);  s.setBorderRight(BorderStyle.MEDIUM);
        return s;
    }

    private CellStyle makeYellowHeaderStyle(Workbook wb) {
        CellStyle s = wb.createCellStyle();
        Font f = wb.createFont(); f.setBold(true); f.setFontHeightInPoints((short) 11);
        s.setFont(f);
        s.setAlignment(HorizontalAlignment.CENTER);
        s.setVerticalAlignment(VerticalAlignment.CENTER);
        s.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
        s.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        s.setBorderBottom(BorderStyle.MEDIUM); s.setBorderTop(BorderStyle.MEDIUM);
        s.setBorderLeft(BorderStyle.MEDIUM);   s.setBorderRight(BorderStyle.MEDIUM);
        return s;
    }

    private CellStyle makeDataStyle(Workbook wb) {
        CellStyle s = wb.createCellStyle();
        Font f = wb.createFont(); f.setFontHeightInPoints((short) 10);
        s.setFont(f);
        s.setVerticalAlignment(VerticalAlignment.CENTER);
        s.setBorderBottom(BorderStyle.THIN); s.setBorderTop(BorderStyle.THIN);
        s.setBorderLeft(BorderStyle.THIN);   s.setBorderRight(BorderStyle.THIN);
        s.setWrapText(true);
        return s;
    }

    private CellStyle makeDataCenterStyle(Workbook wb) {
        CellStyle s = makeDataStyle(wb);
        s.setAlignment(HorizontalAlignment.CENTER);
        return s;
    }

    private CellStyle makeSectionStyle(Workbook wb) {
        CellStyle s = wb.createCellStyle();
        Font f = wb.createFont(); f.setBold(true); f.setFontHeightInPoints((short) 11);
        s.setFont(f);
        s.setVerticalAlignment(VerticalAlignment.CENTER);
        s.setBorderBottom(BorderStyle.THIN);
        return s;
    }

    private CellStyle makeInfoLabelStyle(Workbook wb) {
        CellStyle s = wb.createCellStyle();
        Font f = wb.createFont(); f.setBold(true); f.setFontHeightInPoints((short) 10);
        s.setFont(f);
        s.setVerticalAlignment(VerticalAlignment.CENTER);
        return s;
    }

    /* ═══════════════════════════
       유틸
    ═══════════════════════════ */
    private String str(Object o) { return o == null ? "" : o.toString().trim(); }
    private String nvl(String s) { return s == null ? "" : s; }

    private Map<String, Object> ok() {
        Map<String, Object> m = new HashMap<>(); m.put("success", true); return m;
    }
    private Map<String, Object> err(String msg) {
        Map<String, Object> m = new HashMap<>(); m.put("success", false); m.put("error", msg); return m;
    }
}
