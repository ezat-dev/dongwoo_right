package com.sample_pro.service.facility;

import com.sample_pro.dao.facility.InspectDao;
import com.sample_pro.domain.InspectHeader;
import com.sample_pro.domain.InspectItem;
import com.sample_pro.domain.InspectResult;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.InputStream;
import java.util.*;

@Service
public class InspectServiceImpl implements InspectService {

    @Autowired
    private InspectDao inspectDao;

    private String currentYm() {
        Calendar c = Calendar.getInstance();
        return String.format("%04d%02d", c.get(Calendar.YEAR), c.get(Calendar.MONTH) + 1);
    }

    private String nextYm() {
        Calendar c = Calendar.getInstance();
        c.add(Calendar.MONTH, 1);
        return String.format("%04d%02d", c.get(Calendar.YEAR), c.get(Calendar.MONTH) + 1);
    }

    private String getLoginName(HttpSession session) {
        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> emp = (Map<String, Object>) session.getAttribute("loginEmp");
            if (emp != null && emp.get("emp_name") != null) return emp.get("emp_name").toString();
            com.sample_pro.domain.Users user =
                    (com.sample_pro.domain.Users) session.getAttribute("loginUser");
            if (user != null && user.getUser_name() != null) return user.getUser_name();
        } catch (Exception ignored) {}
        return "";
    }

    @Override
    public Map<String, Object> loadData(String equipId, String ym, HttpSession session) {
        Map<String, Object> p = new HashMap<>();
        p.put("equipId", equipId);
        p.put("ym", ym);

        List<InspectItem>   items   = inspectDao.selectItems(p);
        List<InspectResult> results = inspectDao.selectResults(p);
        InspectHeader       header  = inspectDao.selectHeader(p);

        // itemId -> day -> shift -> val  (D=주간, N=야간)
        Map<Integer, Map<Integer, Map<String, String>>> resultMatrix = new HashMap<>();
        for (InspectResult r : results) {
            resultMatrix
                .computeIfAbsent(r.getItemId(), k -> new HashMap<>())
                .computeIfAbsent(r.getInspectDay(), k -> new HashMap<>())
                .put(r.getShift(), r.getVal() != null ? r.getVal() : "");
        }

        int year  = Integer.parseInt(ym.substring(0, 4));
        int month = Integer.parseInt(ym.substring(4, 6));
        Calendar cal = Calendar.getInstance();
        cal.set(year, month - 1, 1);
        int daysInMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

        List<Map<String, Object>> itemRows = new ArrayList<>();
        for (InspectItem item : items) {
            Map<String, Object> row = new HashMap<>();
            row.put("itemId",    item.getItemId());
            row.put("itemName",  item.getItemName());
            row.put("itemStd",   item.getItemStd());
            row.put("imgFile",   item.getImgFile() != null ? item.getImgFile() : "");
            row.put("inputType", item.getInputType() != null ? item.getInputType() : "NUM");
            // results: { 1: {D:"12.5", N:"11.0"}, 2:{...}, ... }
            row.put("results",   resultMatrix.getOrDefault(item.getItemId(), new HashMap<>()));
            itemRows.add(row);
        }

        Map<String, Object> resp = new HashMap<>();
        resp.put("loginName",     getLoginName(session));
        resp.put("inspectorName", header != null ? header.getInspectorName() : "");
        resp.put("confirmerName", header != null ? header.getConfirmerName() : "");
        resp.put("status",        header != null ? header.getStatus()        : "TEMP");
        resp.put("daysInMonth",   daysInMonth);
        resp.put("items",         itemRows);
        return resp;
    }

    @Override
    public void addItem(Map<String, Object> params) {
        InspectItem item = new InspectItem();
        item.setEquipId(params.get("equipId").toString());
        item.setItemName(params.get("itemName").toString());
        item.setItemStd(params.getOrDefault("itemStd", "").toString());
        item.setSortOrder(params.containsKey("sortOrder")
                ? Integer.parseInt(params.get("sortOrder").toString()) : 0);
        item.setApplyFromYm(currentYm());
        item.setInputType("OX");
        inspectDao.insertItem(item);
    }

    @Override
    public void editItem(Map<String, Object> params) {
        int itemId = Integer.parseInt(params.get("itemId").toString());
        InspectItem existing = inspectDao.selectItemById(itemId);
        if (existing == null) return;

        String curYm = currentYm();
        if (existing.getApplyFromYm().compareTo(curYm) > 0) {
            existing.setItemName(params.get("itemName").toString());
            existing.setItemStd(params.getOrDefault("itemStd", "").toString());
            if (params.containsKey("sortOrder"))
                existing.setSortOrder(Integer.parseInt(params.get("sortOrder").toString()));
            inspectDao.updateItem(existing);
        } else {
            existing.setDelFromYm(nextYm());
            inspectDao.updateItemDel(existing);

            InspectItem newItem = new InspectItem();
            newItem.setEquipId(existing.getEquipId());
            newItem.setItemName(params.get("itemName").toString());
            newItem.setItemStd(params.getOrDefault("itemStd", "").toString());
            newItem.setSortOrder(params.containsKey("sortOrder")
                    ? Integer.parseInt(params.get("sortOrder").toString()) : existing.getSortOrder());
            newItem.setInputType(existing.getInputType() != null ? existing.getInputType() : "NUM");
            newItem.setApplyFromYm(nextYm());
            inspectDao.insertItem(newItem);
        }
    }

    @Override
    public void updateItemInputType(int itemId, String inputType) {
        inspectDao.updateItemInputType(itemId, inputType);
    }

    @Override
    public void deleteItem(int itemId) {
        InspectItem existing = inspectDao.selectItemById(itemId);
        if (existing == null) return;

        String curYm = currentYm();
        if (existing.getApplyFromYm().compareTo(curYm) > 0) {
            inspectDao.deleteItem(itemId);
        } else {
            existing.setDelFromYm(nextYm());
            inspectDao.updateItemDel(existing);
        }
    }

    @Override
    public void saveHeader(Map<String, Object> body) {
        InspectHeader header = new InspectHeader();
        header.setEquipId(body.get("equipId").toString());
        header.setInspectYm(body.get("ym").toString());
        header.setInspectorName(body.getOrDefault("inspector", "").toString());
        header.setConfirmerName(body.getOrDefault("confirmer", "").toString());
        header.setStatus(body.getOrDefault("status", "TEMP").toString());
        inspectDao.upsertHeader(header);
    }

    @Override
    public void saveCell(Map<String, Object> body) {
        InspectResult r = new InspectResult();
        r.setEquipId(body.get("equipId").toString());
        r.setInspectYm(body.get("ym").toString());
        r.setInspectDay(Integer.parseInt(body.get("day").toString()));
        r.setItemId(Integer.parseInt(body.get("itemId").toString()));
        r.setShift(body.getOrDefault("shift", "D").toString());
        r.setVal(body.getOrDefault("val", "").toString());
        inspectDao.upsertCell(r);
    }

    /* ── 엑셀 출력 ── */
    @Override
    public Workbook exportExcel(String equipId, String ym, HttpSession session) {
        Map<String, Object> p = new HashMap<>();
        p.put("equipId", equipId);
        p.put("ym", ym);

        List<InspectItem>   items   = inspectDao.selectItems(p);
        List<InspectResult> results = inspectDao.selectResults(p);
        InspectHeader       header  = inspectDao.selectHeader(p);

        Map<Integer, Map<Integer, Map<String, String>>> matrix = new HashMap<>();
        for (InspectResult r : results) {
            matrix.computeIfAbsent(r.getItemId(), k -> new HashMap<>())
                  .computeIfAbsent(r.getInspectDay(), k -> new HashMap<>())
                  .put(r.getShift(), r.getVal() != null ? r.getVal() : "");
        }

        int year  = Integer.parseInt(ym.substring(0, 4));
        int month = Integer.parseInt(ym.substring(4, 6));
        Calendar cal = Calendar.getInstance();
        cal.set(year, month - 1, 1);
        int totalDays = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
        int half1End  = Math.min(16, totalDays); // 첫 번째 절반: 1~16일

        String inspector = header != null ? header.getInspectorName() : getLoginName(session);
        String confirmer = header != null ? header.getConfirmerName() : "";

        XSSFWorkbook wb    = new XSSFWorkbook();
        XSSFSheet    sheet = wb.createSheet(equipId + "_" + ym);

        // ─── 스타일 정의 ──────────────────────────────────────────────────
        // 제목 (보라색 배경, 흰색 텍스트)
        XSSFCellStyle sTitle = wb.createCellStyle();
        XSSFFont fTitle = wb.createFont();
        fTitle.setBold(true); fTitle.setFontHeightInPoints((short) 13);
        fTitle.setColor(IndexedColors.WHITE.getIndex());
        sTitle.setFont(fTitle);
        sTitle.setAlignment(HorizontalAlignment.CENTER);
        sTitle.setVerticalAlignment(VerticalAlignment.CENTER);
        sTitle.setFillForegroundColor(new XSSFColor(new byte[]{(byte)91,(byte)55,(byte)185}, null));
        sTitle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        setBorderAll(sTitle);

        // 결재 레이블 (세로쓰기)
        XSSFCellStyle sApvKet = wb.createCellStyle();
        XSSFFont fApvKet = wb.createFont(); fApvKet.setBold(true); fApvKet.setFontHeightInPoints((short) 11);
        sApvKet.setFont(fApvKet);
        sApvKet.setAlignment(HorizontalAlignment.CENTER);
        sApvKet.setVerticalAlignment(VerticalAlignment.CENTER);
        sApvKet.setRotation((short) 90);
        sApvKet.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        sApvKet.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        setBorderAll(sApvKet);

        // 결재 헤더 (작성/검토/승인)
        XSSFCellStyle sApvHead = wb.createCellStyle();
        XSSFFont fApvHead = wb.createFont(); fApvHead.setBold(true); fApvHead.setFontHeightInPoints((short) 10);
        sApvHead.setFont(fApvHead);
        sApvHead.setAlignment(HorizontalAlignment.CENTER);
        sApvHead.setVerticalAlignment(VerticalAlignment.CENTER);
        sApvHead.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        sApvHead.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        setBorderAll(sApvHead);

        // 결재 입력칸
        XSSFCellStyle sApvCell = wb.createCellStyle();
        sApvCell.setAlignment(HorizontalAlignment.CENTER);
        sApvCell.setVerticalAlignment(VerticalAlignment.CENTER);
        setBorderAll(sApvCell);

        // 결재 구분선 "/"
        XSSFCellStyle sApvSlash = wb.createCellStyle();
        sApvSlash.setAlignment(HorizontalAlignment.RIGHT);
        sApvSlash.setVerticalAlignment(VerticalAlignment.BOTTOM);
        setBorderAll(sApvSlash);

        // 데이터 헤더 (회색)
        XSSFCellStyle sDataHead = wb.createCellStyle();
        XSSFFont fDataHead = wb.createFont(); fDataHead.setBold(true); fDataHead.setFontHeightInPoints((short) 10);
        sDataHead.setFont(fDataHead);
        sDataHead.setAlignment(HorizontalAlignment.CENTER);
        sDataHead.setVerticalAlignment(VerticalAlignment.CENTER);
        sDataHead.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        sDataHead.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        setBorderAll(sDataHead);

        // 날짜 헤더 (연한 파랑)
        XSSFCellStyle sDayHead = wb.createCellStyle();
        XSSFFont fDayHead = wb.createFont(); fDayHead.setBold(true); fDayHead.setFontHeightInPoints((short) 10);
        fDayHead.setColor(IndexedColors.DARK_BLUE.getIndex());
        sDayHead.setFont(fDayHead);
        sDayHead.setAlignment(HorizontalAlignment.CENTER);
        sDayHead.setVerticalAlignment(VerticalAlignment.CENTER);
        sDayHead.setFillForegroundColor(new XSSFColor(new byte[]{(byte)235,(byte)248,(byte)255}, null));
        sDayHead.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        setBorderAll(sDayHead);

        // 데이터 셀
        XSSFCellStyle sCell = wb.createCellStyle();
        sCell.setAlignment(HorizontalAlignment.CENTER);
        sCell.setVerticalAlignment(VerticalAlignment.CENTER);
        setBorderAll(sCell);

        // 항목명 셀 (굵은 글씨, 좌측정렬)
        XSSFCellStyle sItem = wb.createCellStyle();
        XSSFFont fItem = wb.createFont(); fItem.setBold(true);
        sItem.setFont(fItem);
        sItem.setAlignment(HorizontalAlignment.LEFT);
        sItem.setVerticalAlignment(VerticalAlignment.CENTER);
        setBorderAll(sItem);

        // 기준 셀 (좌측정렬)
        XSSFCellStyle sStd = wb.createCellStyle();
        sStd.setAlignment(HorizontalAlignment.LEFT);
        sStd.setVerticalAlignment(VerticalAlignment.CENTER);
        setBorderAll(sStd);

        // ─── 컬럼 레이아웃 ───────────────────────────────────────────────
        // Col 0 (A): 점검 항목, Col 1 (B): 점검 기준, Col 2+ (C~): 날짜 데이터
        final int COL_ITEM = 0;
        final int COL_STD  = 1;
        final int COL_DATA = 2;

        // ─── 상단 헤더 (행 0~3): 제목 + 결재란 ──────────────────────────
        for (int i = 0; i < 4; i++) {
            Row row = sheet.createRow(i);
            row.setHeightInPoints(i == 1 || i == 2 ? 36 : 20);
        }

        // 제목: A1:AA4 = 행 0~3, 열 0~26
        for (int r = 0; r < 4; r++)
            for (int c = 0; c <= 26; c++)
                sheet.getRow(r).createCell(c).setCellStyle(sTitle);
        String titleStr = equipId + " 일상점검일지 [" + year + "년 " + month + "월]"
                + "   점검자: " + inspector + "   확인자: " + confirmer;
        sheet.getRow(0).getCell(0).setCellValue(titleStr);
        sheet.addMergedRegion(new CellRangeAddress(0, 3, 0, 26));

        // 결재란: AB1:AK4 = 행 0~3, 열 27~36
        // 결재 세로 레이블 (열 27, 행 0~3 병합)
        for (int r = 0; r < 4; r++) sheet.getRow(r).createCell(27).setCellStyle(sApvKet);
        sheet.getRow(0).getCell(27).setCellValue("결재");
        sheet.addMergedRegion(new CellRangeAddress(0, 3, 27, 27));

        // 작성(AC-AE=28-30), 검토(AF-AH=31-33), 승인(AI-AK=34-36)
        String[] apvNames  = {"작성", "검토", "승인"};
        int[]    apvStarts = {28, 31, 34};
        for (int i = 0; i < 3; i++) {
            int sc = apvStarts[i], ec = sc + 2;
            // 행 0: 레이블
            for (int c = sc; c <= ec; c++) sheet.getRow(0).createCell(c).setCellStyle(sApvHead);
            sheet.getRow(0).getCell(sc).setCellValue(apvNames[i]);
            sheet.addMergedRegion(new CellRangeAddress(0, 0, sc, ec));
            // 행 1~2: 입력칸
            for (int r = 1; r <= 2; r++)
                for (int c = sc; c <= ec; c++) sheet.getRow(r).createCell(c).setCellStyle(sApvCell);
            sheet.addMergedRegion(new CellRangeAddress(1, 2, sc, ec));
            // 행 3: "/" 구분선
            for (int c = sc; c <= ec; c++) sheet.getRow(3).createCell(c).setCellStyle(sApvSlash);
            sheet.getRow(3).getCell(sc).setCellValue("/");
            sheet.addMergedRegion(new CellRangeAddress(3, 3, sc, ec));
        }

        // ─── 데이터 섹션 ─────────────────────────────────────────────────
        int rowIdx = 4;

        // 전반부: 1~16일
        rowIdx = writeSection(sheet, items, matrix, 1, half1End, rowIdx,
                COL_ITEM, COL_STD, COL_DATA, sDataHead, sDayHead, sItem, sStd, sCell);

        // 후반부: 17일~말일 (2행 공백 후 재시작)
        if (half1End < totalDays) {
            rowIdx += 2;
            writeSection(sheet, items, matrix, half1End + 1, totalDays, rowIdx,
                    COL_ITEM, COL_STD, COL_DATA, sDataHead, sDayHead, sItem, sStd, sCell);
        }

        // ─── 열 너비 ─────────────────────────────────────────────────────
        sheet.setColumnWidth(COL_ITEM, 45 * 256); // 너비 45
        sheet.setColumnWidth(COL_STD,  45 * 256); // 너비 45
        for (int d = 0; d < 31; d++) {
            sheet.setColumnWidth(COL_DATA + d * 2,     1100);
            sheet.setColumnWidth(COL_DATA + d * 2 + 1, 1100);
        }
        sheet.setColumnWidth(27, 800); // 결재
        for (int c = 28; c <= 36; c++) sheet.setColumnWidth(c, 1400);

        return wb;
    }

    private int writeSection(Sheet sheet, List<InspectItem> items,
            Map<Integer, Map<Integer, Map<String, String>>> matrix,
            int startDay, int endDay, int rowIdx,
            int colItem, int colStd, int colData,
            CellStyle sHead, CellStyle sDayHead, CellStyle sItem, CellStyle sStd, CellStyle sCell) {

        // 헤더 행1: 항목명, 기준, 날짜 그룹
        Row h1 = sheet.createRow(rowIdx++);
        h1.setHeightInPoints(18);
        createStyledCell(h1, colItem, "점검 항목", sHead);
        createStyledCell(h1, colStd,  "점검 기준", sHead);
        for (int d = startDay; d <= endDay; d++) {
            int c = colData + (d - startDay) * 2;
            createStyledCell(h1, c,     d + "일", sDayHead);
            createStyledCell(h1, c + 1, "",        sDayHead);
            sheet.addMergedRegion(new CellRangeAddress(rowIdx - 1, rowIdx - 1, c, c + 1));
        }

        // 헤더 행2: 주간/야간
        Row h2 = sheet.createRow(rowIdx++);
        h2.setHeightInPoints(16);
        createStyledCell(h2, colItem, "", sHead);
        createStyledCell(h2, colStd,  "", sHead);
        for (int d = startDay; d <= endDay; d++) {
            int c = colData + (d - startDay) * 2;
            createStyledCell(h2, c,     "주간", sHead);
            createStyledCell(h2, c + 1, "야간", sHead);
        }

        // 데이터 행
        for (InspectItem item : items) {
            Row row = sheet.createRow(rowIdx++);
            row.setHeightInPoints(18);
            createStyledCell(row, colItem, item.getItemName(), sItem);
            createStyledCell(row, colStd,  item.getItemStd() != null ? item.getItemStd() : "", sStd);
            Map<Integer, Map<String, String>> dayMap = matrix.getOrDefault(item.getItemId(), new HashMap<>());
            for (int d = startDay; d <= endDay; d++) {
                int c = colData + (d - startDay) * 2;
                Map<String, String> shift = dayMap.getOrDefault(d, new HashMap<>());
                String dv = shift.getOrDefault("D", "");
                String nv = shift.getOrDefault("N", "");
                createStyledCell(row, c,     "99".equals(dv) ? "√" : dv, sCell);
                createStyledCell(row, c + 1, "99".equals(nv) ? "√" : nv, sCell);
            }
        }
        return rowIdx;
    }

    private void setBorderAll(CellStyle style) {
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
    }

    private void createStyledCell(Row row, int col, String value, CellStyle style) {
        Cell cell = row.createCell(col);
        cell.setCellValue(value);
        cell.setCellStyle(style);
    }

    /* ── 엑셀 임포트 ── */
    @Override
    public int importExcel(String equipId, String ym, MultipartFile file) {
        int count = 0;
        try (InputStream is = file.getInputStream();
             Workbook wb = WorkbookFactory.create(is)) {

            Sheet sheet = wb.getSheetAt(0);
            // row 0=타이틀, row 1=날짜헤더, row 2=주간/야간헤더, row 3+=데이터
            int firstDataRow = 3;
            int lastRow = sheet.getLastRowNum();

            for (int ri = firstDataRow; ri <= lastRow; ri++) {
                Row row = sheet.getRow(ri);
                if (row == null) continue;

                Cell nameCell = row.getCell(0);
                if (nameCell == null) continue;
                String itemName = getCellStr(nameCell).trim();
                if (itemName.isEmpty()) continue;

                // col 2+: day1주간, day1야간, day2주간, day2야간 ...
                int lastCol = row.getLastCellNum();
                for (int ci = 2; ci < lastCol; ci++) {
                    int idx   = ci - 2;
                    int day   = idx / 2 + 1;
                    String sh = (idx % 2 == 0) ? "D" : "N";
                    String val = getCellStr(row.getCell(ci)).trim();
                    if (val.isEmpty()) continue;

                    InspectResult r = new InspectResult();
                    r.setEquipId(equipId);
                    r.setInspectYm(ym);
                    r.setInspectDay(day);
                    r.setItemId(0); // itemId를 name으로 매핑할 수 없어 0으로 설정
                    r.setShift(sh);
                    r.setVal(val);
                    inspectDao.upsertCell(r);
                    count++;
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("엑셀 파싱 실패: " + e.getMessage(), e);
        }
        return count;
    }

    /* ── 이미지 업로드 ── */
    private static final String IMG_DIR = "D:/save/Inspect";

    @Override
    public String uploadItemImage(int itemId, MultipartFile file) throws Exception {
        File dir = new File(IMG_DIR);
        if (!dir.exists()) dir.mkdirs();

        String origName = file.getOriginalFilename();
        String ext = (origName != null && origName.contains("."))
                ? origName.substring(origName.lastIndexOf('.')) : "";
        String savedName = "item_" + itemId + "_" + System.currentTimeMillis() + ext;

        File dest = new File(dir, savedName);
        file.transferTo(dest);

        inspectDao.updateItemImg(itemId, savedName);
        return savedName;
    }

    private String getCellStr(Cell cell) {
        if (cell == null) return "";
        switch (cell.getCellType()) {
            case STRING:  return cell.getStringCellValue();
            case NUMERIC: return String.valueOf(cell.getNumericCellValue());
            case BOOLEAN: return cell.getBooleanCellValue() ? "1" : "0";
            default:      return "";
        }
    }
}
