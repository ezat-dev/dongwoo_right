package com.sample_pro.controller.facility;

import org.apache.ibatis.session.SqlSession;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.util.*;

@Controller
@RequestMapping("/auxiliary/inspection")
public class AuxiliaryInspectionController {

    @Resource(name = "session")
    private SqlSession sqlSession;

    /* ── 날짜별 데이터 조회 ── */
    @RequestMapping(value = "/data", method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> loadData(@RequestParam String date) {
        try {
            Map<String, Object> record = sqlSession.selectOne(
                    "AuxiliaryInspectionMapper.selectByDate", date);
            Map<String, Object> res = ok();
            if (record != null) {
                res.put("data",  record);
                res.put("isNew", false);
            } else {
                // 새 날짜 → 유의사항/특기사항은 템플릿에서 가져오기
                Map<String, Object> tmpl = sqlSession.selectOne(
                        "AuxiliaryInspectionMapper.selectTemplate");
                Map<String, Object> empty = new HashMap<>();
                empty.put("inspect_date", date);
                if (tmpl != null) {
                    empty.put("notes",         tmpl.get("notes"));
                    empty.put("special_notes", tmpl.get("special_notes"));
                }
                res.put("data",  empty);
                res.put("isNew", true);
            }
            return ResponseEntity.ok(res);
        } catch (Exception e) {
            return ResponseEntity.ok(err("조회 실패: " + e.getMessage()));
        }
    }

    /* ── 저장 (신규/수정 자동 판별) ── */
    @RequestMapping(value = "/save", method = RequestMethod.POST,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> save(@RequestBody Map<String, Object> body) {
        try {
            String date = str(body.get("inspect_date"));
            Map<String, Object> existing = sqlSession.selectOne(
                    "AuxiliaryInspectionMapper.selectByDate", date);
            if (existing != null) {
                body.put("id", existing.get("id"));
                sqlSession.update("AuxiliaryInspectionMapper.update", body);
            } else {
                sqlSession.insert("AuxiliaryInspectionMapper.insert", body);
            }
            // 유의사항/특기사항 템플릿 업데이트 (다음날 인계)
            sqlSession.update("AuxiliaryInspectionMapper.upsertTemplate", body);
            return ResponseEntity.ok(ok());
        } catch (Exception e) {
            return ResponseEntity.ok(err("저장 실패: " + e.getMessage()));
        }
    }

    /* ── 엑셀 다운로드 (A3 가로, 3단 나란히) ── */
    @RequestMapping(value = "/excel", method = RequestMethod.GET)
    public void excel(@RequestParam String date, HttpServletResponse response) throws Exception {
        Map<String, Object> rec = sqlSession.selectOne("AuxiliaryInspectionMapper.selectByDate", date);

        String dayI    = rec != null ? nvl(rec.get("day_inspector"))   : "";
        String nightI  = rec != null ? nvl(rec.get("night_inspector")) : "";
        String notes   = rec != null ? nvl(rec.get("notes"))           : "";
        String spNotes = rec != null ? nvl(rec.get("special_notes"))   : "";
        Map<String,String> od = parseJson(rec, "outdoor_data");
        Map<String,String> cd = parseJson(rec, "comp_data");
        Map<String,String> nd = parseJson(rec, "n2gas_data");

        try (Workbook wb = new XSSFWorkbook()) {
            Sheet sh = wb.createSheet("부대설비점검표");

            /* A3 가로 인쇄 설정 */
            sh.getPrintSetup().setPaperSize((short)8);  // A3
            sh.getPrintSetup().setLandscape(true);
            sh.setFitToPage(true);
            sh.getPrintSetup().setFitWidth((short)1);
            sh.getPrintSetup().setFitHeight((short)1);
            sh.setDisplayGridlines(false);
            sh.setMargin(Sheet.LeftMargin,   0.35);
            sh.setMargin(Sheet.RightMargin,  0.35);
            sh.setMargin(Sheet.TopMargin,    0.4);
            sh.setMargin(Sheet.BottomMargin, 0.4);

            /* 열 너비 (* 256): 22열 총합 */
            int[] cw = {7,4,13,16,7,6,6,  1,  4,20,9,6,6,6,6,6,6,  1,  4,32,6,6};
            for (int i = 0; i < cw.length; i++) sh.setColumnWidth(i, cw[i]*256);

            /* 스타일 */
            CellStyle titleSt = mkSt(wb,true, 13,HorizontalAlignment.CENTER,VerticalAlignment.CENTER,IndexedColors.CORNFLOWER_BLUE, BorderStyle.MEDIUM);
            CellStyle secSt   = mkSt(wb,true, 10,HorizontalAlignment.CENTER,VerticalAlignment.CENTER,IndexedColors.LIGHT_TURQUOISE,  BorderStyle.MEDIUM);
            CellStyle subSt   = mkSt(wb,false, 8,HorizontalAlignment.CENTER,VerticalAlignment.CENTER,IndexedColors.LIGHT_TURQUOISE,  BorderStyle.THIN);
            CellStyle hdrSt   = mkSt(wb,true,  9,HorizontalAlignment.CENTER,VerticalAlignment.CENTER,IndexedColors.LIGHT_YELLOW,     BorderStyle.THIN);
            CellStyle grpSt   = mkSt(wb,true,  9,HorizontalAlignment.CENTER,VerticalAlignment.CENTER,IndexedColors.GREY_25_PERCENT,  BorderStyle.THIN);
            CellStyle numSt   = mkSt(wb,true,  9,HorizontalAlignment.CENTER,VerticalAlignment.CENTER,IndexedColors.WHITE,            BorderStyle.THIN);
            CellStyle dataSt  = mkSt(wb,false, 9,HorizontalAlignment.CENTER,VerticalAlignment.CENTER,IndexedColors.WHITE,            BorderStyle.THIN);
            CellStyle dataLSt = mkSt(wb,false, 9,HorizontalAlignment.LEFT,  VerticalAlignment.CENTER,IndexedColors.WHITE,            BorderStyle.THIN);
            CellStyle ntlSt   = mkSt(wb,true,  9,HorizontalAlignment.LEFT,  VerticalAlignment.CENTER,IndexedColors.LIGHT_CORNFLOWER_BLUE,BorderStyle.THIN);
            CellStyle noteSt  = mkSt(wb,false, 9,HorizontalAlignment.LEFT,  VerticalAlignment.TOP,   IndexedColors.WHITE,            BorderStyle.THIN);
            noteSt.setWrapText(true);
            CellStyle infoSt  = mkSt(wb,false, 9,HorizontalAlignment.LEFT,  VerticalAlignment.CENTER,IndexedColors.WHITE,            BorderStyle.NONE);
            CellStyle blankSt = mkSt(wb,false, 9,HorizontalAlignment.CENTER,VerticalAlignment.CENTER,IndexedColors.WHITE,            BorderStyle.THIN);
            CellStyle sepSt   = mkSt(wb,false, 9,HorizontalAlignment.CENTER,VerticalAlignment.CENTER,IndexedColors.WHITE,            BorderStyle.NONE);

            /* 행 인덱스 */
            final int RT=0, RI=1, RS=2, RC=3, RD=4;
            final int OD_N=22, CP_N=5, N2_N=10, TOTAL=RD+OD_N;

            Row[] rows = new Row[TOTAL];
            for (int i=0;i<TOTAL;i++) { rows[i]=sh.createRow(i); rows[i].setHeightInPoints(16f); }
            rows[RT].setHeightInPoints(30f); rows[RI].setHeightInPoints(18f);
            rows[RS].setHeightInPoints(22f); rows[RC].setHeightInPoints(18f);

            /* 구분선 열 */
            for (int r=0;r<TOTAL;r++) { bc(rows[r],7,sepSt); bc(rows[r],17,sepSt); }

            /* ── Row 0: 제목 ── */
            mc(sh,rows[RT],RT,RT,0,21,"부대설비  점검표     ( "+date+" )",titleSt);

            /* ── Row 1: 정보 ── */
            mc(sh,rows[RI],RI,RI,0,6,"  점검일자: "+date.replace("-",".")
               +"     주간 점검자: "+dayI+"     야간 점검자: "+nightI, infoSt);
            mc(sh,rows[RI],RI,RI, 8,16,"(점검이상무 ○, 점검이상 △, 이상조치완료 ⊙)",subSt);
            mc(sh,rows[RI],RI,RI,18,21,"(점검이상무 ○, 점검이상 △, 이상조치완료 ⊙)",subSt);

            /* ── Row 2: 섹션 헤더 ── */
            mc(sh,rows[RS],RS,RS, 0, 6,"옥 외 부 대 설 비 점 검 표",secSt);
            mc(sh,rows[RS],RS,RS, 8,16,"콤 프 레 샤  점 검 표",secSt);
            mc(sh,rows[RS],RS,RS,18,21,"N₂ GAS  일일 점검일지",secSt);

            /* ── Row 3: 컬럼 헤더 ── */
            for (int i=0;i<new String[]{"구분","No","점검항목","관리기준","호기","주","야"}.length;i++)
                hc(rows[RC],i,new String[]{"구분","No","점검항목","관리기준","호기","주","야"}[i],hdrSt);
            hc(rows[RC],8,"No",hdrSt); hc(rows[RC],9,"점검사항",hdrSt); hc(rows[RC],10,"기준",hdrSt);
            for (int i=0;i<new String[]{"1호(주)","1호(야)","3호(주)","3호(야)","4호(주)","4호(야)"}.length;i++)
                hc(rows[RC],11+i,new String[]{"1호(주)","1호(야)","3호(주)","3호(야)","4호(주)","4호(야)"}[i],hdrSt);
            for (int i=0;i<new String[]{"No","점검사항","주","야"}.length;i++)
                hc(rows[RC],18+i,new String[]{"No","점검사항","주","야"}[i],hdrSt);

            /* ── 옥외부대설비 데이터 ── */
            Object[][] OD = {
                {"보일러단",9,1,2,"온수온도",      "기화기내 50~70℃",               "1호",   "1_1"},
                {null,0,         1,0,null,null,    "2호",   "1_2"},
                {null,0,         2,2,"온수량",      "수위표시등 꺼짐보충 점등:물보충","1호",  "2_1"},
                {null,0,         2,0,null,null,    "2호",   "2_2"},
                {null,0,         3,2,"Tank내 압력", "1~13kgf/cm²",                   "TANK.1","3_1"},
                {null,0,         3,0,null,null,    "TANK.2","3_2"},
                {null,0,         4,2,"가스량 레벨", "30%이상",                        "TANK.1","4_1"},
                {null,0,         4,0,null,null,    "TANK.2","4_2"},
                {null,0,         5,1,"공급압력",    "0.5~0.9kgf/cm²",                null,    "5_0"},
                {"암모니아",8,   6,2,"온수온도",    "기화기내 50~70℃",               "1호",   "6_1"},
                {null,0,         6,0,null,null,    "2호",   "6_2"},
                {null,0,         7,2,"온수량",      "80%이상 유지",                   "1호",   "7_1"},
                {null,0,         7,0,null,null,    "2호",   "7_2"},
                {null,0,         8,1,"일차압력",    "3~13 kgf/cm²",                  null,    "8_0"},
                {null,0,         9,1,"이차압력",    "3~13 kgf/cm²",                  null,    "9_0"},
                {null,0,        10,1,"공급압력",    "0.5~1.5kgf/cm²",               null,    "10_0"},
                {null,0,        11,1,"미사용 봄베수","갯수",                          null,    "11_0"},
                {"냉각수",5,    12,1,"가동PUMP호수","1호,2호",                       null,    "12_0"},
                {null,0,        13,1,"PUMP토출압력","2.5~4.5kgf/cm²",               null,    "13_0"},
                {null,0,        14,1,"PUMP 진동음", "정상,이상",                     null,    "14_0"},
                {null,0,        15,1,"Tank 수위",   "2.7~3.7 m",                    null,    "15_0"},
                {null,0,        16,1,"냉각Tower(1,2)","작동상태(정상,이상)",        null,    "16_0"},
            };
            for (int i=0;i<OD.length;i++) {
                Object[] o  = OD[i];
                String grp  = (String)o[0]; int gs=(int)o[1];
                int no=(int)o[2]; int ns=(int)o[3];
                String name=(String)o[4], std=(String)o[5];
                String sub=(String)o[6], key=(String)o[7];
                int ri = RD+i; Row row = rows[ri];
                if (grp!=null) mc(sh,row,ri,ri+(gs>1?gs-1:0),0,0,grp,grpSt); else bc(row,0,grpSt);
                if (ns>0) {
                    mc(sh,row,ri,ri+(ns>1?ns-1:0),1,1,String.valueOf(no),numSt);
                    mc(sh,row,ri,ri+(ns>1?ns-1:0),2,2,nvl(name),dataLSt);
                    mc(sh,row,ri,ri+(ns>1?ns-1:0),3,3,nvl(std), dataLSt);
                } else { bc(row,1,numSt); bc(row,2,dataLSt); bc(row,3,dataLSt); }
                hc(row,4,sub!=null?sub:"",dataSt);
                hc(row,5,od.getOrDefault(key+"_day",  ""),dataSt);
                hc(row,6,od.getOrDefault(key+"_night",""),dataSt);
            }

            /* ── 콤프레샤 데이터 ── */
            String[][] CP = {
                {"1","모타의 소음상태 및 진동상태 유무","이상음 발생"},
                {"2","차압의 압력차를 확인한다",        "0.8 BAR 이하"},
                {"3","온도를 점검 기록한다",             "90℃ 이하"},
                {"4","AIR DRYER의 이상상태를 확인한다", "정등"},
                {"5","①의 OIL LEVEL게이지 확인",        "투시창"},
            };
            int[] MACH = {1,3,4};
            for (int i=0;i<CP_N;i++) {
                Row row = rows[RD+i];
                hc(row,8,CP[i][0],numSt); hc(row,9,CP[i][1],dataLSt); hc(row,10,CP[i][2],dataSt);
                int col=11;
                for (int m:MACH) {
                    hc(row,col++,cd.getOrDefault(CP[i][0]+"_"+m+"_day",  ""),dataSt);
                    hc(row,col++,cd.getOrDefault(CP[i][0]+"_"+m+"_night",""),dataSt);
                }
            }
            int cpNT=RD+CP_N, cpNE=RD+OD_N-1;
            mc(sh,rows[cpNT],cpNT,cpNT,8,16,"※ 점검시 유의사항",ntlSt);
            rows[cpNT].setHeightInPoints(18f);
            if (cpNE>cpNT) mc(sh,rows[cpNT+1],cpNT+1,cpNE,8,16,notes,noteSt);

            /* ── N2 GAS 데이터 ── */
            String[] N2 = {
                "저장실 주위에 인화 물질, 화기 방치여부(육안확인)",
                "설비장치의 작동여부(압력계 미작동시 고장으로 판단)",
                "GAS 차단장치의 작동여부(밸브확인)",
                "기화기 이상유무(성에 제거)",
                "안전장치작동유무(긴급차단밸브 확인)",
                "TANK내 압력계(10kgf/cm²이하)",
                "탱크, 배관 누설여부(육안, 소리로 확인)",
                "N2 GAS량(1000이상 유지)",
                "N2 GAS의 압력(7kgf/cm²이하)",
                "안전변의 원변은 열려있는가(안전밸브 open 여부 확인)"
            };
            for (int i=0;i<N2_N;i++) {
                Row row = rows[RD+i];
                hc(row,18,String.valueOf(i+1),numSt); hc(row,19,N2[i],dataLSt);
                hc(row,20,nd.getOrDefault((i+1)+"_day",  ""),dataSt);
                hc(row,21,nd.getOrDefault((i+1)+"_night",""),dataSt);
            }
            int n2NT=RD+N2_N, n2NE=RD+OD_N-1;
            mc(sh,rows[n2NT],n2NT,n2NT,18,21,"※ 특기사항",ntlSt);
            rows[n2NT].setHeightInPoints(18f);
            if (n2NE>n2NT) mc(sh,rows[n2NT+1],n2NT+1,n2NE,18,21,spNotes,noteSt);

            /* 나머지 빈 셀 처리 */
            for (int i=CP_N;i<OD_N;i++) {
                Row r=rows[RD+i];
                for (int c=8;c<=16;c++) { if (r.getCell(c)==null) bc(r,c,blankSt); }
            }
            for (int i=N2_N;i<OD_N;i++) {
                Row r=rows[RD+i];
                for (int c=18;c<=21;c++) { if (r.getCell(c)==null) bc(r,c,blankSt); }
            }

            /* 응답 */
            String fname = URLEncoder.encode("부대설비점검표_"+date+".xlsx","UTF-8");
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition","attachment; filename*=UTF-8''"+fname);
            wb.write(response.getOutputStream());
        }
    }

    /* ── 엑셀 헬퍼 ── */
    private void hc(Row row, int col, String val, CellStyle st) {
        Cell c = row.createCell(col); c.setCellValue(val); c.setCellStyle(st);
    }
    private void bc(Row row, int col, CellStyle st) {
        Cell c = row.getCell(col); if (c==null) c=row.createCell(col); c.setCellStyle(st);
    }
    private void mc(Sheet sh, Row firstRow, int r1, int r2, int c1, int c2, String val, CellStyle st) {
        Cell c = firstRow.createCell(c1); c.setCellValue(val); c.setCellStyle(st);
        if (r2>r1 || c2>c1) {
            sh.addMergedRegion(new CellRangeAddress(r1,r2,c1,c2));
            for (int ri=r1;ri<=r2;ri++) {
                Row rr=sh.getRow(ri); if (rr==null) rr=sh.createRow(ri);
                for (int ci=c1;ci<=c2;ci++) {
                    if (ri==r1&&ci==c1) continue;
                    Cell fc=rr.getCell(ci); if (fc==null) fc=rr.createCell(ci);
                    fc.setCellStyle(st);
                }
            }
        }
    }
    private CellStyle mkSt(Workbook wb, boolean bold, int size,
                            HorizontalAlignment ha, VerticalAlignment va,
                            IndexedColors bg, BorderStyle bs) {
        CellStyle s = wb.createCellStyle();
        Font f = wb.createFont(); f.setBold(bold); f.setFontHeightInPoints((short)size);
        s.setFont(f); s.setAlignment(ha); s.setVerticalAlignment(va);
        if (bg!=IndexedColors.WHITE) {
            s.setFillForegroundColor(bg.getIndex()); s.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        }
        s.setBorderTop(bs); s.setBorderBottom(bs); s.setBorderLeft(bs); s.setBorderRight(bs);
        return s;
    }

    /* ══ 유틸 ══ */

    private Map<String, String> parseJson(Map<String, Object> record, String key) {
        if (record == null) return new HashMap<>();
        String json = nvl(record.get(key));
        if (json.isEmpty()) return new HashMap<>();
        try {
            // 간단한 JSON 파싱: {"key":"val","key2":"val2"} 형태
            Map<String, String> m = new HashMap<>();
            json = json.trim();
            if (json.startsWith("{")) json = json.substring(1);
            if (json.endsWith("}")) json = json.substring(0, json.length() - 1);
            for (String entry : json.split(",")) {
                entry = entry.trim();
                if (entry.isEmpty()) continue;
                int ci = entry.indexOf(':');
                if (ci < 0) continue;
                String k = entry.substring(0, ci).trim().replaceAll("\"", "");
                String v = entry.substring(ci+1).trim().replaceAll("\"", "");
                m.put(k, v);
            }
            return m;
        } catch (Exception e) {
            return new HashMap<>();
        }
    }

    private String str(Object o)  { return o == null ? "" : o.toString().trim(); }
    private String nvl(Object o)  { return o == null ? "" : o.toString(); }

    private Map<String, Object> ok() {
        Map<String, Object> m = new HashMap<>(); m.put("success", true); return m;
    }
    private Map<String, Object> err(String msg) {
        Map<String, Object> m = new HashMap<>(); m.put("success", false); m.put("error", msg); return m;
    }
}
