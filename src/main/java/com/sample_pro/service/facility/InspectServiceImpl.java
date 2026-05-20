// package com.sample_pro.service.facility;

// import com.sample_pro.dao.facility.InspectDao;
// import com.sample_pro.domain.InspectHeader;
// import com.sample_pro.domain.InspectItem;
// import com.sample_pro.domain.InspectResult;
// import org.apache.poi.ss.usermodel.*;
// import org.apache.poi.ss.util.CellRangeAddress;
// import org.apache.poi.xssf.usermodel.*;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.stereotype.Service;
// import org.springframework.web.multipart.MultipartFile;

// import javax.servlet.http.HttpSession;
// import java.io.File;
// import java.io.InputStream;
// import java.util.*;

// @Service
// public class InspectServiceImpl implements InspectService {

//     @Autowired
//     private InspectDao inspectDao;

//     private String currentYm() {
//         Calendar c = Calendar.getInstance();
//         return String.format("%04d%02d", c.get(Calendar.YEAR), c.get(Calendar.MONTH) + 1);
//     }

//     private String nextYm() {
//         Calendar c = Calendar.getInstance();
//         c.add(Calendar.MONTH, 1);
//         return String.format("%04d%02d", c.get(Calendar.YEAR), c.get(Calendar.MONTH) + 1);
//     }

//     private String getLoginName(HttpSession session) {
//         try {
//             @SuppressWarnings("unchecked")
//             Map<String, Object> emp = (Map<String, Object>) session.getAttribute("loginEmp");
//             if (emp != null && emp.get("emp_name") != null) return emp.get("emp_name").toString();
//             com.sample_pro.domain.Users user =
//                     (com.sample_pro.domain.Users) session.getAttribute("loginUser");
//             if (user != null && user.getUser_name() != null) return user.getUser_name();
//         } catch (Exception ignored) {}
//         return "";
//     }

//     @Override
//     public Map<String, Object> loadData(String equipId, String ym, HttpSession session) {
//         Map<String, Object> p = new HashMap<>();
//         p.put("equipId", equipId);
//         p.put("ym", ym);

//         List<InspectItem>   items   = inspectDao.selectItems(p);
//         List<InspectResult> results = inspectDao.selectResults(p);
//         InspectHeader       header  = inspectDao.selectHeader(p);

//         // itemId -> day -> result
//         Map<Integer, Map<Integer, String>> resultMatrix = new HashMap<>();
//         for (InspectResult r : results) {
//             resultMatrix
//                 .computeIfAbsent(r.getItemId(), k -> new HashMap<>())
//                 .put(r.getInspectDay(), r.getResult());
//         }

//         // 해당 월 일수 계산
//         int year  = Integer.parseInt(ym.substring(0, 4));
//         int month = Integer.parseInt(ym.substring(4, 6));
//         Calendar cal = Calendar.getInstance();
//         cal.set(year, month - 1, 1);
//         int daysInMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

//         List<Map<String, Object>> itemRows = new ArrayList<>();
//         for (InspectItem item : items) {
//             Map<String, Object> row = new HashMap<>();
//             row.put("itemId",    item.getItemId());
//             row.put("itemName",  item.getItemName());
//             row.put("itemStd",   item.getItemStd());
//             row.put("imgFile",   item.getImgFile() != null ? item.getImgFile() : "");
//             row.put("results",   resultMatrix.getOrDefault(item.getItemId(), new HashMap<>()));
//             itemRows.add(row);
//         }

//         Map<String, Object> resp = new HashMap<>();
//         resp.put("loginName",     getLoginName(session));
//         resp.put("inspectorName", header != null ? header.getInspectorName() : "");
//         resp.put("confirmerName", header != null ? header.getConfirmerName() : "");
//         resp.put("status",        header != null ? header.getStatus()        : "TEMP");
//         resp.put("daysInMonth",   daysInMonth);
//         resp.put("items",         itemRows);
//         return resp;
//     }

//     @Override
//     public void addItem(Map<String, Object> params) {
//         InspectItem item = new InspectItem();
//         item.setEquipId(params.get("equipId").toString());
//         item.setItemName(params.get("itemName").toString());
//         item.setItemStd(params.getOrDefault("itemStd", "").toString());
//         item.setSortOrder(params.containsKey("sortOrder")
//                 ? Integer.parseInt(params.get("sortOrder").toString()) : 0);
//         item.setApplyFromYm(currentYm());
//         inspectDao.insertItem(item);
//     }

//     @Override
//     public void editItem(Map<String, Object> params) {
//         int itemId = Integer.parseInt(params.get("itemId").toString());
//         InspectItem existing = inspectDao.selectItemById(itemId);
//         if (existing == null) return;

//         String curYm = currentYm();
//         if (existing.getApplyFromYm().compareTo(curYm) > 0) {
//             existing.setItemName(params.get("itemName").toString());
//             existing.setItemStd(params.getOrDefault("itemStd", "").toString());
//             if (params.containsKey("sortOrder"))
//                 existing.setSortOrder(Integer.parseInt(params.get("sortOrder").toString()));
//             inspectDao.updateItem(existing);
//         } else {
//             existing.setDelFromYm(nextYm());
//             inspectDao.updateItemDel(existing);

//             InspectItem newItem = new InspectItem();
//             newItem.setEquipId(existing.getEquipId());
//             newItem.setItemName(params.get("itemName").toString());
//             newItem.setItemStd(params.getOrDefault("itemStd", "").toString());
//             newItem.setSortOrder(params.containsKey("sortOrder")
//                     ? Integer.parseInt(params.get("sortOrder").toString()) : existing.getSortOrder());
//             newItem.setApplyFromYm(nextYm());
//             inspectDao.insertItem(newItem);
//         }
//     }

//     @Override
//     public void deleteItem(int itemId) {
//         InspectItem existing = inspectDao.selectItemById(itemId);
//         if (existing == null) return;

//         String curYm = currentYm();
//         if (existing.getApplyFromYm().compareTo(curYm) > 0) {
//             inspectDao.deleteItem(itemId);
//         } else {
//             existing.setDelFromYm(nextYm());
//             inspectDao.updateItemDel(existing);
//         }
//     }

//     @Override
//     public void saveHeader(Map<String, Object> body) {
//         InspectHeader header = new InspectHeader();
//         header.setEquipId(body.get("equipId").toString());
//         header.setInspectYm(body.get("ym").toString());
//         header.setInspectorName(body.getOrDefault("inspector", "").toString());
//         header.setConfirmerName(body.getOrDefault("confirmer", "").toString());
//         header.setStatus(body.getOrDefault("status", "TEMP").toString());
//         inspectDao.upsertHeader(header);
//     }

//     @Override
//     public void saveCell(Map<String, Object> body) {
//         InspectResult r = new InspectResult();
//         r.setEquipId(body.get("equipId").toString());
//         r.setInspectYm(body.get("ym").toString());
//         r.setInspectDay(Integer.parseInt(body.get("day").toString()));
//         r.setItemId(Integer.parseInt(body.get("itemId").toString()));
//         r.setResult(body.getOrDefault("result", "-").toString());
//         inspectDao.upsertCell(r);
//     }

//     /* ── 엑셀 출력 ── */
//     @Override
//     public Workbook exportExcel(String equipId, String ym, HttpSession session) {
//         Map<String, Object> p = new HashMap<>();
//         p.put("equipId", equipId);
//         p.put("ym", ym);

//         List<InspectItem>   items   = inspectDao.selectItems(p);
//         List<InspectResult> results = inspectDao.selectResults(p);
//         InspectHeader       header  = inspectDao.selectHeader(p);

//         // itemId -> day -> result
//         Map<Integer, Map<Integer, String>> matrix = new HashMap<>();
//         for (InspectResult r : results) {
//             matrix.computeIfAbsent(r.getItemId(), k -> new HashMap<>())
//                   .put(r.getInspectDay(), r.getResult());
//         }

//         int year  = Integer.parseInt(ym.substring(0, 4));
//         int month = Integer.parseInt(ym.substring(4, 6));
//         Calendar cal = Calendar.getInstance();
//         cal.set(year, month - 1, 1);
//         int days = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

//         XSSFWorkbook wb    = new XSSFWorkbook();
//         XSSFSheet    sheet = wb.createSheet(equipId + "_" + ym);

//         /* 스타일 정의 */
//         CellStyle styleTitle = wb.createCellStyle();
//         XSSFFont fontTitle = wb.createFont();
//         fontTitle.setBold(true); fontTitle.setFontHeightInPoints((short)13);
//         styleTitle.setFont(fontTitle);
//         styleTitle.setAlignment(HorizontalAlignment.CENTER);
//         styleTitle.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
//         styleTitle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

//         CellStyle styleHead = wb.createCellStyle();
//         XSSFFont fontHead = wb.createFont();
//         fontHead.setBold(true); fontHead.setFontHeightInPoints((short)10);
//         styleHead.setFont(fontHead);
//         styleHead.setAlignment(HorizontalAlignment.CENTER);
//         styleHead.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
//         styleHead.setFillPattern(FillPatternType.SOLID_FOREGROUND);
//         styleHead.setBorderBottom(BorderStyle.THIN);
//         styleHead.setBorderTop(BorderStyle.THIN);
//         styleHead.setBorderLeft(BorderStyle.THIN);
//         styleHead.setBorderRight(BorderStyle.THIN);

//         CellStyle styleCell = wb.createCellStyle();
//         styleCell.setAlignment(HorizontalAlignment.CENTER);
//         styleCell.setBorderBottom(BorderStyle.THIN);
//         styleCell.setBorderTop(BorderStyle.THIN);
//         styleCell.setBorderLeft(BorderStyle.THIN);
//         styleCell.setBorderRight(BorderStyle.THIN);

//         CellStyle styleItemName = wb.createCellStyle();
//         XSSFFont fontItem = wb.createFont();
//         fontItem.setBold(true);
//         styleItemName.setFont(fontItem);
//         styleItemName.setBorderBottom(BorderStyle.THIN);
//         styleItemName.setBorderTop(BorderStyle.THIN);
//         styleItemName.setBorderLeft(BorderStyle.THIN);
//         styleItemName.setBorderRight(BorderStyle.THIN);

//         CellStyle styleOk = wb.createCellStyle();
//         styleOk.cloneStyleFrom(styleCell);
//         styleOk.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
//         styleOk.setFillPattern(FillPatternType.SOLID_FOREGROUND);

//         CellStyle styleNg = wb.createCellStyle();
//         styleNg.cloneStyleFrom(styleCell);
//         styleNg.setFillForegroundColor(IndexedColors.ROSE.getIndex());
//         styleNg.setFillPattern(FillPatternType.SOLID_FOREGROUND);

//         int rowIdx = 0;

//         /* 타이틀 행 */
//         Row titleRow = sheet.createRow(rowIdx++);
//         titleRow.setHeightInPoints(22);
//         Cell titleCell = titleRow.createCell(0);
//         String inspector = header != null ? header.getInspectorName() : getLoginName(session);
//         String confirmer = header != null ? header.getConfirmerName() : "";
//         titleCell.setCellValue(equipId + " 일상점검일지 [" + year + "년 " + month + "월]"
//                 + "   점검자: " + inspector + "   확인자: " + confirmer);
//         titleCell.setCellStyle(styleTitle);
//         sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, days + 2));

//         /* 헤더 행: item_id(숨김) | 항목명 | 기준 | 1~days */
//         Row headRow = sheet.createRow(rowIdx++);
//         headRow.setHeightInPoints(18);
//         createStyledCell(headRow, 0, "ID",    styleHead);
//         createStyledCell(headRow, 1, "점검 항목", styleHead);
//         createStyledCell(headRow, 2, "점검 기준", styleHead);
//         for (int d = 1; d <= days; d++) {
//             createStyledCell(headRow, d + 2, String.valueOf(d), styleHead);
//         }

//         /* 데이터 행 */
//         for (InspectItem item : items) {
//             Row row = sheet.createRow(rowIdx++);
//             row.setHeightInPoints(16);
//             createStyledCell(row, 0, String.valueOf(item.getItemId()), styleCell);
//             createStyledCell(row, 1, item.getItemName(), styleItemName);
//             createStyledCell(row, 2, item.getItemStd() != null ? item.getItemStd() : "", styleCell);

//             Map<Integer, String> dayMap = matrix.getOrDefault(item.getItemId(), new HashMap<>());
//             for (int d = 1; d <= days; d++) {
//                 String res = dayMap.getOrDefault(d, "-");
//                 CellStyle cs = "Y".equals(res) ? styleOk : "N".equals(res) ? styleNg : styleCell;
//                 createStyledCell(row, d + 2, res, cs);
//             }
//         }

//         /* 열 너비 */
//         sheet.setColumnHidden(0, true);  // ID 열 숨김
//         sheet.setColumnWidth(1, 5000);   // 항목명
//         sheet.setColumnWidth(2, 6000);   // 기준
//         for (int d = 1; d <= days; d++) sheet.setColumnWidth(d + 2, 900);

//         return wb;
//     }

//     private void createStyledCell(Row row, int col, String value, CellStyle style) {
//         Cell cell = row.createCell(col);
//         cell.setCellValue(value);
//         cell.setCellStyle(style);
//     }

//     /* ── 엑셀 임포트 ── */
//     @Override
//     public int importExcel(String equipId, String ym, MultipartFile file) {
//         int count = 0;
//         try (InputStream is = file.getInputStream();
//              Workbook wb = WorkbookFactory.create(is)) {

//             Sheet sheet = wb.getSheetAt(0);
//             // row 0 = 타이틀, row 1 = 헤더, row 2+ = 데이터
//             int firstDataRow = 2;
//             int lastRow = sheet.getLastRowNum();

//             for (int ri = firstDataRow; ri <= lastRow; ri++) {
//                 Row row = sheet.getRow(ri);
//                 if (row == null) continue;

//                 Cell idCell = row.getCell(0);
//                 if (idCell == null) continue;
//                 String idStr = getCellStr(idCell).trim();
//                 if (idStr.isEmpty()) continue;

//                 int itemId;
//                 try { itemId = Integer.parseInt(idStr); } catch (Exception e) { continue; }

//                 // 열 3부터 일자 결과
//                 int lastCol = row.getLastCellNum();
//                 for (int ci = 3; ci < lastCol; ci++) {
//                     int day = ci - 2;  // col 3 = day 1
//                     String val = getCellStr(row.getCell(ci)).trim().toUpperCase();
//                     if (!val.equals("Y") && !val.equals("N") && !val.equals("-")) {
//                         val = "-";
//                     }
//                     InspectResult r = new InspectResult();
//                     r.setEquipId(equipId);
//                     r.setInspectYm(ym);
//                     r.setInspectDay(day);
//                     r.setItemId(itemId);
//                     r.setResult(val);
//                     inspectDao.upsertCell(r);
//                     count++;
//                 }
//             }
//         } catch (Exception e) {
//             throw new RuntimeException("엑셀 파싱 실패: " + e.getMessage(), e);
//         }
//         return count;
//     }

//     /* ── 이미지 업로드 ── */
//     private static final String IMG_DIR = "D:/save/Inspect";

//     @Override
//     public String uploadItemImage(int itemId, MultipartFile file) throws Exception {
//         File dir = new File(IMG_DIR);
//         if (!dir.exists()) dir.mkdirs();

//         String origName = file.getOriginalFilename();
//         String ext = (origName != null && origName.contains("."))
//                 ? origName.substring(origName.lastIndexOf('.')) : "";
//         String savedName = "item_" + itemId + "_" + System.currentTimeMillis() + ext;

//         File dest = new File(dir, savedName);
//         file.transferTo(dest);

//         inspectDao.updateItemImg(itemId, savedName);
//         return savedName;
//     }

//     private String getCellStr(Cell cell) {
//         if (cell == null) return "";
//         switch (cell.getCellType()) {
//             case STRING:  return cell.getStringCellValue();
//             case NUMERIC: return String.valueOf((int) cell.getNumericCellValue());
//             case BOOLEAN: return cell.getBooleanCellValue() ? "Y" : "N";
//             default:      return "";
//         }
//     }
// }
