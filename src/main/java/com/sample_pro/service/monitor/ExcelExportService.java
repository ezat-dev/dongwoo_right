package com.sample_pro.service.monitor;

import com.sample_pro.domain.TempTag;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xddf.usermodel.chart.*;
import org.apache.poi.xssf.usermodel.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.io.*;
import java.nio.file.*;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 매일 오전 11:00에 전날 온도 데이터를 Excel로 저장.
 *  - 설비별: D:\DATA_BACKUP\설비별 온도\설비별온도_YYYY-MM-DD.xlsx (BCF별 시트)
 *  - 로트별: D:\DATA_BACKUP\LOT별 온도\{LOTNO}.xlsx  (로트 START_DTTM 기준)
 */
@Service
public class ExcelExportService {

    private static final Logger log = LoggerFactory.getLogger(ExcelExportService.class);

    private static final String DAILY_DIR = "D:\\DATA_BACKUP\\설비별 온도";
    private static final String LOT_DIR   = "D:\\DATA_BACKUP\\LOT별 온도";

    private static final DateTimeFormatter FMT_DATE = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter FMT_DTTM = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    // EQUT_CD → BCF 라벨 (예: "BCF6")
    private static final Map<String, String> EQUT_TO_BCF = new LinkedHashMap<>();
    static {
        EQUT_TO_BCF.put("2420M001", "BCF1");
        EQUT_TO_BCF.put("2420M002", "BCF2");
        EQUT_TO_BCF.put("2420M003", "BCF3");
        EQUT_TO_BCF.put("2420M004", "BCF4");
        EQUT_TO_BCF.put("2420M005", "BCF5");
        EQUT_TO_BCF.put("2420M011", "BCF6");
        EQUT_TO_BCF.put("2420M006", "BCF7");
        EQUT_TO_BCF.put("2420M007", "BCF8");
        EQUT_TO_BCF.put("2420M008", "BCF9");
        EQUT_TO_BCF.put("2420M009", "BCF10");
        EQUT_TO_BCF.put("2420M010", "BCF11");
        EQUT_TO_BCF.put("2421M002", "BCF12");
    }

    @Autowired
    private TempService tempService;

    @Autowired
    private WorkListService workListService;

    // ─── 매일 오전 11:00 (전날 데이터) ────────────────────────────
    @Scheduled(cron = "0 0 11 * * ?")
    public void exportDailyExcel() {
        exportForDate(LocalDate.now().minusDays(1).format(FMT_DATE));
    }

    /**
     * 특정 날짜의 데이터를 Excel로 저장. 날짜 없으면 전날 기준.
     * @param dateStr "yyyy-MM-dd" 형식 (null이면 어제)
     */
    public void exportForDate(String dateStr) {
        if (dateStr == null || dateStr.isEmpty()) {
            dateStr = LocalDate.now().minusDays(1).format(FMT_DATE);
        }
        String from = dateStr + " 00:00:00";
        String to   = dateStr + " 23:59:59";

        log.info("[ExcelExport] 시작 — 대상 날짜: {}", dateStr);

        Map<String, String> colToLabel = buildColToLabel();

        try {
            exportDailyByEquip(from, to, dateStr, colToLabel);
        } catch (Exception e) {
            log.error("[ExcelExport] 설비별 저장 실패", e);
        }

        try {
            exportDailyByLot(from, to, colToLabel);
        } catch (Exception e) {
            log.error("[ExcelExport] 로트별 저장 실패", e);
        }

        log.info("[ExcelExport] 완료 — {}", dateStr);
    }

    // ─── Step 1: 설비별 일간 엑셀 ───────────────────────────────────
    private void exportDailyByEquip(String from, String to, String dateStr,
                                    Map<String, String> colToLabel) throws IOException {
        List<Map<String, Object>> rows = tempService.getTempSnapshotRange(from, to);
        if (rows.isEmpty()) {
            log.warn("[ExcelExport] 설비별: 데이터 없음 ({} ~ {})", from, to);
            return;
        }

        Set<String> allCols = rows.get(0).keySet();

        try (XSSFWorkbook wb = new XSSFWorkbook()) {
            CellStyle hdrStyle = makeHeaderStyle(wb);
            CellStyle numStyle = makeNumStyle(wb);

            for (int bcfNum = 1; bcfNum <= 12; bcfNum++) {
                String prefix = "BCF_" + bcfNum + "_";
                List<String> cols = allCols.stream()
                        .filter(c -> c.toUpperCase().startsWith(prefix))
                        .sorted()
                        .collect(Collectors.toList());
                if (cols.isEmpty()) continue;

                XSSFSheet sheet = wb.createSheet("BCF" + bcfNum);
                int lastDataRow = writeDataRows(sheet, cols, rows, colToLabel, hdrStyle, numStyle, 0);
                addChartToSheet(sheet, cols, colToLabel, 0, lastDataRow);
            }

            if (wb.getNumberOfSheets() == 0) {
                log.warn("[ExcelExport] 설비별: 작성할 시트 없음");
                return;
            }

            Files.createDirectories(Paths.get(DAILY_DIR));
            Path file = Paths.get(DAILY_DIR, "설비별온도_" + dateStr + ".xlsx");
            try (FileOutputStream fos = new FileOutputStream(file.toFile())) {
                wb.write(fos);
            }
            log.info("[ExcelExport] 설비별 저장 완료: {}", file);
        }
    }

    // ─── Step 2: 로트별 엑셀 ────────────────────────────────────────
    private void exportDailyByLot(String from, String to,
                                   Map<String, String> colToLabel) throws IOException {
        List<Map<String, Object>> lots = workListService.getJacupByRange("", from, to);
        if (lots.isEmpty()) {
            log.info("[ExcelExport] 로트별: 어제 로트 없음");
            return;
        }

        Files.createDirectories(Paths.get(LOT_DIR));

        for (Map<String, Object> lot : lots) {
            try {
                exportOneLot(lot, colToLabel);
            } catch (Exception e) {
                log.error("[ExcelExport] 로트 저장 실패: {}", str(lot.get("WORK_INDCT_NUM")), e);
            }
        }
    }

    private void exportOneLot(Map<String, Object> lot, Map<String, String> colToLabel) throws IOException {
        String lotNo  = str(lot.get("WORK_INDCT_NUM"));
        String equtCd = str(lot.get("EQUT_CD"));
        String startS = str(lot.get("START_DTTM"));
        String endS   = str(lot.get("END_DTTM"));

        if (lotNo.isEmpty() || equtCd.isEmpty() || startS.isEmpty()) return;

        String bcfTag = EQUT_TO_BCF.getOrDefault(equtCd, "");
        if (bcfTag.isEmpty()) return;
        String prefix = "BCF_" + bcfTag.replace("BCF", "") + "_";

        String snapTo = endS.isEmpty()
                ? LocalDateTime.now().format(FMT_DTTM)
                : endS;

        List<Map<String, Object>> rows = tempService.getTempSnapshotRange(startS, snapTo);
        if (rows.isEmpty()) {
            log.info("[ExcelExport] 로트 {}: 스냅샷 없음", lotNo);
            return;
        }

        Set<String> allCols = rows.get(0).keySet();
        List<String> cols = allCols.stream()
                .filter(c -> c.toUpperCase().startsWith(prefix))
                .sorted()
                .collect(Collectors.toList());
        if (cols.isEmpty()) return;

        try (XSSFWorkbook wb = new XSSFWorkbook()) {
            CellStyle hdrStyle  = makeHeaderStyle(wb);
            CellStyle numStyle  = makeNumStyle(wb);
            CellStyle infoStyle = makeInfoStyle(wb);

            String sheetName = bcfTag.length() > 31 ? bcfTag.substring(0, 31) : bcfTag;
            XSSFSheet sheet = wb.createSheet(sheetName);

            // 로트 정보 (상단 2행)
            Row r0 = sheet.createRow(0);
            infoCell(r0, 0, "LOT NO: " + lotNo,                                   infoStyle);
            infoCell(r0, 2, "고객사: " + str(lot.get("CUST_NM")),                  infoStyle);
            infoCell(r0, 4, "품명: "  + str(lot.get("PROD_NM")),                   infoStyle);

            Row r1 = sheet.createRow(1);
            infoCell(r1, 0, "설비: " + bcfTag + " (" + equtCd + ")",               infoStyle);
            infoCell(r1, 2, "시작: " + startS,                                     infoStyle);
            infoCell(r1, 4, "종료: " + (endS.isEmpty() ? "진행중" : endS),           infoStyle);

            sheet.createRow(2); // 빈 행

            // 데이터 (행 3부터), 차트 아래 삽입
            int lastDataRow = writeDataRows(sheet, cols, rows, colToLabel, hdrStyle, numStyle, 3);
            addChartToSheet(sheet, cols, colToLabel, 3, lastDataRow);

            String fileName = sanitize(lotNo) + ".xlsx";
            Path file = Paths.get(LOT_DIR, fileName);
            try (FileOutputStream fos = new FileOutputStream(file.toFile())) {
                wb.write(fos);
            }
            log.info("[ExcelExport] 로트 저장: {}", file);
        }
    }

    // ─── 공통: 헤더 + 데이터 행 쓰기, 마지막 데이터 행 반환 ────────
    private int writeDataRows(XSSFSheet sheet, List<String> cols,
                               List<Map<String, Object>> rows,
                               Map<String, String> colToLabel,
                               CellStyle hdrStyle, CellStyle numStyle,
                               int startRow) {
        // 헤더 행
        Row hdr = sheet.createRow(startRow);
        Cell h0 = hdr.createCell(0);
        h0.setCellValue("시간");
        h0.setCellStyle(hdrStyle);
        for (int i = 0; i < cols.size(); i++) {
            Cell c = hdr.createCell(i + 1);
            c.setCellValue(colToLabel.getOrDefault(cols.get(i), cols.get(i)));
            c.setCellStyle(hdrStyle);
        }

        // 데이터 행
        int rowIdx = startRow + 1;
        for (Map<String, Object> row : rows) {
            Row r = sheet.createRow(rowIdx++);
            r.createCell(0).setCellValue(formatTime(row.get("record_time")));

            for (int i = 0; i < cols.size(); i++) {
                Cell c = r.createCell(i + 1);
                Object val = row.get(cols.get(i));
                if (val == null) { c.setCellValue(""); continue; }
                try {
                    double raw    = Double.parseDouble(val.toString());
                    String label  = colToLabel.getOrDefault(cols.get(i), cols.get(i));
                    double scaled = scaleValue(cols.get(i), label, raw);
                    if (Double.isNaN(scaled)) { c.setCellValue(""); }
                    else { c.setCellValue(scaled); c.setCellStyle(numStyle); }
                } catch (NumberFormatException ex) {
                    c.setCellValue(val.toString());
                }
            }
        }

        // 열 너비
        sheet.setColumnWidth(0, 5500);
        for (int i = 1; i <= cols.size(); i++) sheet.setColumnWidth(i, 4000);

        return rowIdx - 1; // 마지막 데이터 행 인덱스 (0-based)
    }

    // ─── 차트 삽입: 데이터 시트 아래, 이중 y축 ──────────────────────
    // 좌축: 온도 0-1000 / 우축: 유량·CP 0-10  (trend.jsp 기준)
    private void addChartToSheet(XSSFSheet sheet, List<String> cols,
                                  Map<String, String> colToLabel,
                                  int hdrRow, int lastDataRow) {
        if (lastDataRow <= hdrRow) return;

        int chartStartRow = lastDataRow + 2;
        int chartEndRow   = chartStartRow + 28;
        int chartEndCol   = Math.min(cols.size() + 1, 16);

        XSSFDrawing drawing = sheet.createDrawingPatriarch();
        XSSFClientAnchor anchor = drawing.createAnchor(0, 0, 0, 0,
                0, chartStartRow, chartEndCol, chartEndRow);

        XSSFChart chart = drawing.createChart(anchor);
        chart.setTitleText(sheet.getSheetName() + " 추이");
        chart.setTitleOverlay(false);

        // X축 (시간 — 카테고리)
        XDDFCategoryAxis timeAxis = chart.createCategoryAxis(AxisPosition.BOTTOM);

        // 좌측 y축: 온도 0-1000
        XDDFValueAxis leftAxis = chart.createValueAxis(AxisPosition.LEFT);
        leftAxis.setMinimum(0.0);
        leftAxis.setMaximum(1000.0);
        leftAxis.setCrosses(AxisCrosses.AUTO_ZERO);

        // 우측 y축: 유량/CP 0-10
        XDDFValueAxis rightAxis = chart.createValueAxis(AxisPosition.RIGHT);
        rightAxis.setMinimum(0.0);
        rightAxis.setMaximum(10.0);
        rightAxis.setCrosses(AxisCrosses.MAX);

        XDDFLineChartData tempData = (XDDFLineChartData) chart.createData(ChartTypes.LINE, timeAxis, leftAxis);
        XDDFLineChartData flowData = (XDDFLineChartData) chart.createData(ChartTypes.LINE, timeAxis, rightAxis);

        // 시간 데이터 소스 (열 0)
        XDDFCategoryDataSource timeSource = XDDFDataSourcesFactory.fromStringCellRange(
                sheet, new CellRangeAddress(hdrRow + 1, lastDataRow, 0, 0));

        boolean hasTemp = false, hasFlow = false;
        for (int i = 0; i < cols.size(); i++) {
            String cn    = cols.get(i);
            String label = colToLabel.getOrDefault(cn, cn);

            XDDFNumericalDataSource<Double> valSource = XDDFDataSourcesFactory.fromNumericCellRange(
                    sheet, new CellRangeAddress(hdrRow + 1, lastDataRow, i + 1, i + 1));

            if (isFlowColumn(cn, label)) {
                XDDFLineChartData.Series s = (XDDFLineChartData.Series) flowData.addSeries(timeSource, valSource);
                s.setTitle(label, null);
                s.setSmooth(false);
                s.setMarkerStyle(MarkerStyle.NONE);
                hasFlow = true;
            } else {
                XDDFLineChartData.Series s = (XDDFLineChartData.Series) tempData.addSeries(timeSource, valSource);
                s.setTitle(label, null);
                s.setSmooth(false);
                s.setMarkerStyle(MarkerStyle.NONE);
                hasTemp = true;
            }
        }

        if (hasTemp) chart.plot(tempData);
        if (hasFlow) chart.plot(flowData);
    }

    // ─── 스케일 변환 (trend.jsp 로직과 동일) ────────────────────────
    static double scaleValue(String colName, String label, double raw) {
        if (Double.isNaN(raw)) return Double.NaN;

        String lo = label.toLowerCase();
        String cn = colName.toLowerCase();

        boolean b2  = isBcf(cn, 2);
        boolean b5  = isBcf(cn, 5);
        boolean b6  = isBcf(cn, 6);
        boolean b7  = isBcf(cn, 7);
        boolean b8  = isBcf(cn, 8);
        boolean b9  = isBcf(cn, 9);
        boolean b10 = isBcf(cn, 10);
        boolean b11 = isBcf(cn, 11);
        boolean b12 = isBcf(cn, 12);

        boolean isC3h8 = lo.contains("c3h8") || cn.contains("c3h8");
        boolean isNh3  = lo.contains("nh3")  || cn.contains("nh3");

        boolean isFlow = lo.matches(".*(flow|gas|유량|n2|nh3|rx|flw|air|c3h8).*")
                      || cn.matches(".*(flow|gas|n2|nh3|rx|flw|air|c3h8).*");

        if (isFlow) {
            if (raw > 30000) return Double.NaN;

            if (isC3h8) {
                if (b7)                      return raw / 200.0;
                if (b5 || b8 || b10 || b11)  return raw * 0.00125;
                if (b9)                      return raw * 0.0049;
                if (b12)                     return raw * 0.1;
                if (b2)                      return raw * 0.00152;
                if (b6)                      return raw * 0.01;
                return (raw / 1000.0) * 3.1;
            }

            raw = raw >= 1000 ? raw / 1000.0 : raw / 100.0;
            if (isNh3 && b9)  raw = raw / 100.0;
            if (isNh3 && b10) raw = raw / 10.0;
            return raw;
        }

        boolean isCpPv = lo.matches(".*cp.*pv.*") || lo.matches(".*pv.*cp.*")
                      || cn.contains("_cp_pv");
        if (isCpPv) {
            if (b7 || b9) raw = raw * 2.0;
            else if (b6)  raw = raw * 0.001;
        }

        if (b7) {
            boolean isUjTemp = lo.matches(".*(유조.*온도|온도.*유조).*")
                            || cn.contains("_uj_pv");
            if (isUjTemp) raw = raw + 8.0;
        }

        if (b8) {
            boolean isUjCtPv = lo.matches(".*(유조.*pv|pv.*유조|침탄.*pv|pv.*침탄).*")
                             || cn.contains("_uj_pv") || cn.contains("_ct_pv");
            boolean isUjCtSp = lo.matches(".*(유조.*sp|sp.*유조|침탄.*sp|sp.*침탄).*")
                             || cn.contains("_uj_sp") || cn.contains("_ct_sp");
            if (isUjCtPv || isUjCtSp) raw = raw / 10.0;
        }

        if (isCpPv && b9 && raw >= 60) return 0.0;

        if (b9) {
            boolean isUjPv = lo.matches(".*(유조.*온도|온도.*유조).*")
                          || cn.contains("_uj_pv");
            if (isUjPv) raw = raw - 9.0;

            boolean isUjSp = lo.matches(".*(유조.*sp|sp.*유조).*")
                          || cn.contains("_uj_sp");
            if (isUjSp) raw = raw + 9.0;
        }

        return raw;
    }

    /** flow/gas 계열 컬럼 여부 — 우측 y축(0-10) 대상 */
    private static boolean isFlowColumn(String cn, String label) {
        String lo = label.toLowerCase();
        String c  = cn.toLowerCase();
        return lo.matches(".*(flow|gas|유량|n2|nh3|rx|flw|air|c3h8).*")
            || c.matches(".*(flow|gas|n2|nh3|rx|flw|air|c3h8).*");
    }

    /** cn에 BCF 번호 num이 포함되는지 (bcf_6_, bcf_11_, ...) */
    private static boolean isBcf(String cn, int num) {
        String n = String.valueOf(num);
        return cn.contains("_" + n + "_") || cn.endsWith("_" + n);
    }

    // ─── colName → label(trendName) 매핑 빌드 ───────────────────────
    private Map<String, String> buildColToLabel() {
        try {
            return tempService.getTempTagList().stream()
                    .filter(t -> t.getColName() != null && !t.getColName().isEmpty())
                    .collect(Collectors.toMap(
                            TempTag::getColName,
                            t -> {
                                if (t.getTrendName() != null && !t.getTrendName().isEmpty()) return t.getTrendName();
                                if (t.getTagName()   != null && !t.getTagName().isEmpty())   return t.getTagName();
                                return t.getColName();
                            },
                            (a, b) -> a,
                            LinkedHashMap::new));
        } catch (Exception e) {
            log.warn("[ExcelExport] TempTag 로드 실패 — colName 그대로 사용", e);
            return new LinkedHashMap<>();
        }
    }

    // ─── POI 스타일 ────────────────────────────────────────────────
    private CellStyle makeHeaderStyle(XSSFWorkbook wb) {
        XSSFCellStyle s = wb.createCellStyle();
        XSSFFont f = wb.createFont();
        f.setBold(true);
        f.setFontHeightInPoints((short) 10);
        f.setColor(IndexedColors.WHITE.getIndex());
        s.setFont(f);
        s.setFillForegroundColor(new XSSFColor(new byte[]{(byte) 68, (byte) 114, (byte) 196}, null));
        s.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        s.setAlignment(HorizontalAlignment.CENTER);
        s.setBorderBottom(BorderStyle.THIN);
        s.setBorderRight(BorderStyle.THIN);
        return s;
    }

    private CellStyle makeNumStyle(XSSFWorkbook wb) {
        CellStyle s = wb.createCellStyle();
        s.setDataFormat(wb.createDataFormat().getFormat("0.00"));
        s.setAlignment(HorizontalAlignment.RIGHT);
        return s;
    }

    private CellStyle makeInfoStyle(XSSFWorkbook wb) {
        XSSFCellStyle s = wb.createCellStyle();
        XSSFFont f = wb.createFont();
        f.setBold(true);
        f.setFontHeightInPoints((short) 10);
        s.setFont(f);
        return s;
    }

    private void infoCell(Row row, int col, String val, CellStyle style) {
        Cell c = row.createCell(col);
        c.setCellValue(val);
        c.setCellStyle(style);
    }

    // ─── 유틸 ──────────────────────────────────────────────────────
    private static String formatTime(Object rt) {
        if (rt == null) return "";
        String s = rt.toString();
        return s.length() > 19 ? s.substring(0, 19) : s;
    }

    private static String str(Object o) {
        return o == null ? "" : o.toString().trim();
    }

    private static String sanitize(String name) {
        return name.replaceAll("[\\\\/:*?\"<>|]", "_");
    }
}
