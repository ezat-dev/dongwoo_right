// package com.sample_pro.controller.management;

// import java.time.LocalDateTime;
// import java.time.LocalDate;
// import java.time.DayOfWeek;
// import java.time.YearMonth;
// import java.time.format.DateTimeFormatter;
// import java.util.LinkedHashMap;
// import java.util.List;
// import java.util.Map;
// import java.util.regex.Pattern;

// import javax.servlet.http.HttpSession;

// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.http.HttpEntity;
// import org.springframework.http.HttpHeaders;
// import org.springframework.http.HttpMethod;
// import org.springframework.http.MediaType;
// import org.springframework.http.ResponseEntity;
// import org.springframework.stereotype.Controller;
// import org.springframework.web.bind.annotation.RequestBody;
// import org.springframework.web.bind.annotation.RequestMapping;
// import org.springframework.web.bind.annotation.RequestMethod;
// import org.springframework.web.bind.annotation.RequestParam;
// import org.springframework.web.bind.annotation.ResponseBody;
// import org.springframework.web.client.RestTemplate;

// import java.io.IOException;
// import java.util.ArrayList;
// import java.util.HashMap;
// import java.util.LinkedHashSet;

// import javax.servlet.http.HttpServletResponse;

// import org.apache.poi.ss.usermodel.BorderStyle;
// import org.apache.poi.ss.usermodel.Cell;
// import org.apache.poi.ss.usermodel.CellStyle;
// import org.apache.poi.ss.usermodel.FillPatternType;
// import org.apache.poi.ss.usermodel.Font;
// import org.apache.poi.ss.usermodel.HorizontalAlignment;
// import org.apache.poi.ss.usermodel.IndexedColors;
// import org.apache.poi.ss.usermodel.Row;
// import org.apache.poi.ss.usermodel.Sheet;
// import org.apache.poi.ss.usermodel.VerticalAlignment;

// import com.sample_pro.domain.CompanyEmployee;
// import com.sample_pro.domain.EzInOutRecord;
// import com.sample_pro.domain.EzInOutVisit;
// import com.sample_pro.domain.SolapiSendResult;
// import com.sample_pro.service.EzInOutAttendService;
// import com.sample_pro.service.EzInOutService;
// import com.sample_pro.service.SolapiKakaoService;

// @Controller
// @RequestMapping("/ez_in_out")
// public class EzInOutController {

//     private static final Pattern PHONE_PATTERN = Pattern.compile("^0\\d{1,2}-\\d{3,4}-\\d{4}$");

//     // PIN 잠금 관련 상수
//     private static final int  PIN_MAX_ATTEMPTS = 5;
//     private static final long PIN_LOCK_MILLIS  = 5 * 60 * 1000L;

//     // PLC C# API 주소
//     private static final String CSHARP_API            = "http://localhost:5050";

//     // PIN 성공 → 정문 D13000 / 후문 D13002 = 1
//     private static final int    PLC_DOOR_FRONT_ADDRESS = 13000;
//     private static final int    PLC_DOOR_BACK_ADDRESS  = 13002;
//     private static final int    PLC_DOOR_PIN_VALUE     = 1;

//     // 카톡 문열기 버튼 → D13001 = 1
//     private static final int    PLC_DOOR_TAKE_ADDRESS = 13001;
//     private static final int    PLC_DOOR_TAKE_VALUE   = 1;

//     // 세션 키
//     private static final String SESSION_PIN_ATTEMPTS     = "ez_pin_attempts";
//     private static final String SESSION_PIN_LOCKED_UNTIL = "ez_pin_locked_until";
//     private static final String SESSION_EMP_AUTH         = "ez_emp_authenticated";

//     @Autowired
//     private EzInOutService ezInOutService;

//     @Autowired
//     private SolapiKakaoService solapiKakaoService;

//     @Autowired
//     private EzInOutAttendService ezInOutAttendService;

//     private final RestTemplate rest = new RestTemplate();

//     /* =============================================
//        방문록 메인 페이지
//     ============================================= */
//     @RequestMapping(value = "/main", method = RequestMethod.GET)
//     public String mainPage() {
//         return "/ez_in_out/ez_in_out_main.jsp";
//     }

//     /* =============================================
//        PIN 인증 페이지 (GET)
//     ============================================= */
//     @RequestMapping(value = "/pin", method = RequestMethod.GET)
//     public String pinPage() {
//         return "/ez_in_out/ez_pin.jsp";
//     }

//     @RequestMapping(value = "/menu", method = RequestMethod.GET)
//     public String menuPage() {
//         return "/ez_in_out/mobile_menu.jsp";
//     }

//     @RequestMapping(value = "/security", method = RequestMethod.GET)
//     public String securityPage() {
//         return "/ez_in_out/security.jsp";
//     }

//     @RequestMapping(value = "/security/employees", method = RequestMethod.GET,
//                     produces = MediaType.APPLICATION_JSON_VALUE)
//     @ResponseBody
//     public Map<String,Object> securityEmployees() {
//         Map<String,Object> result = new HashMap<>();
//         try {
//             result.put("success", true);
//             result.put("data", ezInOutService.getSecurityEmployeeList());
//         } catch (Exception e) {
//             result.put("success", false);
//             result.put("error", e.getMessage());
//         }
//         return result;
//     }

//     @RequestMapping(value = "/security/notify/save", method = RequestMethod.POST,
//                     produces = MediaType.APPLICATION_JSON_VALUE)
//     @ResponseBody
//     public Map<String,Object> saveSecurityNotify(@RequestBody Map<String,Object> body) {
//         Map<String,Object> result = new HashMap<>();
//         try {
//             @SuppressWarnings("unchecked")
//             List<String> empIds = (List<String>) body.get("empIds");
//             ezInOutService.saveSecurityNotify(empIds);
//             result.put("success", true);
//         } catch (Exception e) {
//             result.put("success", false);
//             result.put("error", e.getMessage());
//         }
//         return result;
//     }

//     @RequestMapping(value = "/security/history", method = RequestMethod.GET,
//                     produces = MediaType.APPLICATION_JSON_VALUE)
//     @ResponseBody
//     public Map<String,Object> getSensorHistory() {
//         Map<String,Object> result = new HashMap<>();
//         try {
//             result.put("success", true);
//             result.put("data", ezInOutService.getSensorHistory(20));  // 최근 20개
//         } catch (Exception e) {
//             result.put("success", false);
//             result.put("error", e.getMessage());
//         }
//         return result;
//     }

//     /* =============================================
//        카카오 알림톡 수신 페이지 (GET)
//        URL: /ez_in_out/take?id={visitId}
//     ============================================= */
//     @RequestMapping(value = "/take", method = RequestMethod.GET)
//     public String takePage() {
//         return "/ez_in_out/take.jsp";
//     }

//     /* =============================================
//        방문 정보 조회 API (카카오 take 페이지용)
//        GET /ez_in_out/take/info?id={visitId}
//     ============================================= */
//     @RequestMapping(
//         value    = "/take/info",
//         method   = RequestMethod.GET,
//         produces = MediaType.APPLICATION_JSON_VALUE
//     )
//     @ResponseBody
//     public ResponseEntity<?> takeInfo(
//             @RequestParam(value = "id", defaultValue = "") String id) {

//         if (id.isEmpty()) {
//             return ResponseEntity.ok(error("방문 ID가 없습니다."));
//         }

//         long visitId;
//         try {
//             visitId = Long.parseLong(id);
//         } catch (NumberFormatException e) {
//             return ResponseEntity.ok(error("유효하지 않은 방문 ID입니다."));
//         }

//         try {
//             EzInOutVisit visit = ezInOutService.getVisitById(visitId);
//             if (visit == null) {
//                 return ResponseEntity.ok(error("방문 정보를 찾을 수 없습니다."));
//             }

//             Map<String, Object> response = new LinkedHashMap<>();
//             response.put("success", true);
//             response.put("data", visit);
//             return ResponseEntity.ok(response);

//         } catch (Exception e) {
//             return ResponseEntity.ok(error("방문 정보 조회 실패: " + detailMessage(e)));
//         }
//     }

//     /* =============================================
//        카톡 문열기 버튼 API
//        POST /ez_in_out/take/open-door
//        Body: { "visitId": "123" }
//        → PLC D13001 <- 1
//     ============================================= */
//     @RequestMapping(
//         value    = "/take/open-door",
//         method   = RequestMethod.POST,
//         produces = MediaType.APPLICATION_JSON_VALUE
//     )
//     @ResponseBody
//     public ResponseEntity<?> takeOpenDoor(@RequestBody Map<String, Object> body) {
//         String visitIdStr = trim(body.get("visitId"));
//         System.out.println(">>> [TAKE OPEN] visitId=" + visitIdStr);

//         // D13001 <- 1
//         String plcResult = writePlc(PLC_DOOR_TAKE_ADDRESS, PLC_DOOR_TAKE_VALUE);
//         boolean plcOk    = !plcResult.startsWith("plc_error");

//         Map<String, Object> response = new LinkedHashMap<>();
//         response.put("success", plcOk);
//         response.put("plc", plcResult);

//         if (!plcOk) {
//             response.put("error", "PLC 통신 오류가 발생했습니다.");
//         }

//         System.out.println(">>> [TAKE OPEN] D" + PLC_DOOR_TAKE_ADDRESS + "=" + PLC_DOOR_TAKE_VALUE + " → " + plcResult);
//         return ResponseEntity.ok(response);
//     }

//     /* =============================================
//        직원 대시보드 (PIN 인증 후 이동)
//     ============================================= */
//     @RequestMapping(value = "/employee/dashboard", method = RequestMethod.GET)
//     public String employeeDashboard(HttpSession session) {
//         Boolean auth = (Boolean) session.getAttribute(SESSION_EMP_AUTH);
//         if (auth == null || !auth) {
//             return "redirect:/ez_in_out/pin";
//         }
//         return "/ez_in_out/ez_employee_dashboard.jsp";
//     }

//     /* =============================================
//        PIN 인증 API
//        성공 시 PLC D13000 <- 1
//     ============================================= */
//     @RequestMapping(
//         value    = "/employee/verify-pin",
//         method   = RequestMethod.POST,
//         produces = MediaType.APPLICATION_JSON_VALUE
//     )
//     @ResponseBody
//     public ResponseEntity<?> verifyPin(
//             @RequestBody Map<String, Object> body,
//             HttpSession session) {

//         Long lockedUntil = (Long) session.getAttribute(SESSION_PIN_LOCKED_UNTIL);
//         if (lockedUntil != null && System.currentTimeMillis() < lockedUntil) {
//             long remainSec = (lockedUntil - System.currentTimeMillis()) / 1000;
//             return ResponseEntity.ok(error("잠금 상태입니다. " + remainSec + "초 후 다시 시도해 주세요."));
//         }

//         String pin  = trim(body.get("pin"));
//         String gate = trim(body.get("gate")); // "front" | "back"
//         boolean isFront = !"back".equals(gate);
//         String visitReason = isFront ? "정문 출입" : "후문 출입";
//         int plcAddress     = isFront ? PLC_DOOR_FRONT_ADDRESS : PLC_DOOR_BACK_ADDRESS;

//         if (pin.isEmpty())          return ResponseEntity.ok(error("PIN을 입력해 주세요."));
//         if (!pin.matches("\\d{6}")) return ResponseEntity.ok(error("PIN은 숫자 6자리입니다."));

//         boolean correct;
//         try {
//             correct = ezInOutService.verifyEmployeePwNo(pin);
//         } catch (Exception e) {
//             return ResponseEntity.ok(error("PIN 검증 오류: " + detailMessage(e)));
//         }

//         if (correct) {
//             session.removeAttribute(SESSION_PIN_ATTEMPTS);
//             session.removeAttribute(SESSION_PIN_LOCKED_UNTIL);
//             session.setAttribute(SESSION_EMP_AUTH, Boolean.TRUE);

//             // 직원 정보 조회
//             CompanyEmployee emp = null;
//             try {
//                 emp = ezInOutService.getEmployeeByPwNo(pin);
//             } catch (Exception e) {
//                 System.out.println(">>> [PIN OK] 직원 정보 조회 오류: " + e.getMessage());
//             }

//             // 입장 기록 저장 (PIN으로 입장한 경우)
//             if (emp != null) {
//                 try {
//                     java.time.LocalDateTime now = java.time.LocalDateTime.now();
//                     java.time.format.DateTimeFormatter fmt = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
//                     String visitTime = now.format(fmt);

//                     EzInOutVisit visit = new EzInOutVisit();
//                     visit.setVisitTime(visitTime);
//                     visit.setVisitorName(emp.getEmpName());
//                     visit.setVisitorPhone(emp.getMobileNo() != null ? emp.getMobileNo() : "");
//                     visit.setTargetEmpId(emp.getEmpId() != null ? emp.getEmpId().toString() : "");
//                     visit.setTargetDeptName(emp.getDeptName());
//                     visit.setTargetEmpName(emp.getEmpName());
//                     visit.setTargetTitleName(emp.getTitleName());
//                     visit.setTargetMobileNo(emp.getMobileNo());
//                     visit.setTargetDirectNo(emp.getDirectNo());
//                     visit.setVisitReason(visitReason);
//                     visit.setVisitReasonEtc("");
//                     visit.setAgreeYn("Y");

//                     ezInOutService.saveVisit(visit);
//                     System.out.println(">>> [PIN OK] 입장 기록 저장 완료: visitId=" + visit.getVisitId());
//                 } catch (Exception e) {
//                     System.out.println(">>> [PIN OK] 입장 기록 저장 오류: " + detailMessage(e));
//                 }
//             }

//             // 정문 D13000 / 후문 D13002 <- 1
//             String plcResult = writePlc(plcAddress, PLC_DOOR_PIN_VALUE);
//             System.out.println(">>> [PIN OK] " + visitReason + " D" + plcAddress + "=1 → " + plcResult);

//             Map<String, Object> response = new LinkedHashMap<>();
//             response.put("success", true);
//             response.put("plc", plcResult);
//             return ResponseEntity.ok(response);

//         } else {
//             int attempts = getAttempts(session) + 1;
//             session.setAttribute(SESSION_PIN_ATTEMPTS, attempts);

//             if (attempts >= PIN_MAX_ATTEMPTS) {
//                 long lockUntil = System.currentTimeMillis() + PIN_LOCK_MILLIS;
//                 session.setAttribute(SESSION_PIN_LOCKED_UNTIL, lockUntil);
//                 session.setAttribute(SESSION_PIN_ATTEMPTS, 0);
//                 return ResponseEntity.ok(error("PIN 입력을 " + PIN_MAX_ATTEMPTS + "회 실패하여 5분간 잠겼습니다."));
//             }

//             return ResponseEntity.ok(error("PIN이 올바르지 않습니다. (" + (PIN_MAX_ATTEMPTS - attempts) + "회 남음)"));
//         }
//     }

//     /* =============================================
//        직원 목록 API
//     ============================================= */
//     @RequestMapping(
//         value    = "/employee/list",
//         method   = RequestMethod.GET,
//         produces = MediaType.APPLICATION_JSON_VALUE
//     )
//     @ResponseBody
//     public ResponseEntity<?> employeeList() {
//         try {
//             List<CompanyEmployee> employees = ezInOutService.getCompanyEmployeeList();
//             Map<String, Object> response = new LinkedHashMap<>();
//             response.put("success", true);
//             response.put("data", employees);
//             return ResponseEntity.ok(response);
//         } catch (Exception e) {
//             return ResponseEntity.ok(error("직원 목록 조회 실패: " + detailMessage(e)));
//         }
//     }

//     /* =============================================
//        방문 저장 API
//     ============================================= */
//     @RequestMapping(
//         value    = "/visit/save",
//         method   = RequestMethod.POST,
//         produces = MediaType.APPLICATION_JSON_VALUE
//     )
//     @ResponseBody
//     public ResponseEntity<?> saveVisit(@RequestBody Map<String, Object> body) {
//         String visitTime       = trim(body.get("visitTime"));
//         String visitorName     = trim(body.get("visitorName"));
//         String visitorPhone    = trim(body.get("visitorPhone"));
//         String targetEmpId     = trim(body.get("targetEmpId"));
//         String targetDeptName  = trim(body.get("targetDeptName"));
//         String targetEmpName   = trim(body.get("targetEmpName"));
//         String targetTitleName = trim(body.get("targetTitleName"));
//         String targetMobileNo  = trim(body.get("targetMobileNo"));
//         String targetDirectNo  = trim(body.get("targetDirectNo"));
//         String visitReason     = normalizeVisitReason(trim(body.get("visitReason")));
//         String visitReasonEtc  = trim(body.get("visitReasonEtc"));

//         if (visitorName.isEmpty())
//             return ResponseEntity.ok(error("이름을 입력해 주세요."));
//         if (visitorPhone.isEmpty())
//             return ResponseEntity.ok(error("전화번호를 입력해 주세요."));
//         if (!PHONE_PATTERN.matcher(visitorPhone).matches())
//             return ResponseEntity.ok(error("전화번호 형식이 올바르지 않습니다."));
//         if (targetEmpId.isEmpty() || targetEmpName.isEmpty())
//             return ResponseEntity.ok(error("호출할 직원을 선택해 주세요."));
//         if (visitReason.isEmpty())
//             return ResponseEntity.ok(error("방문 사유를 선택해 주세요."));
//         if ("기타".equals(visitReason) && visitReasonEtc.isEmpty())
//             return ResponseEntity.ok(error("기타 사유를 입력해 주세요."));
//         if (visitTime.isEmpty())
//             visitTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));

//         EzInOutVisit visit = new EzInOutVisit();
//         visit.setVisitTime(visitTime);
//         visit.setVisitorName(visitorName);
//         visit.setVisitorPhone(visitorPhone);
//         visit.setTargetEmpId(targetEmpId);
//         visit.setTargetDeptName(targetDeptName);
//         visit.setTargetEmpName(targetEmpName);
//         visit.setTargetTitleName(targetTitleName);
//         visit.setTargetMobileNo(targetMobileNo);
//         visit.setTargetDirectNo(targetDirectNo);
//         visit.setVisitReason(visitReason);
//         visit.setVisitReasonEtc(visitReasonEtc);
//         visit.setAgreeYn("Y");

//         try {
//             EzInOutVisit savedVisit = ezInOutService.saveVisit(visit);
//             SolapiSendResult notification = solapiKakaoService.sendVisitNotification(savedVisit);

//             Map<String, Object> response = new LinkedHashMap<>();
//             response.put("success", true);
//             response.put("data", savedVisit);
//             response.put("notification", notification);
//             return ResponseEntity.ok(response);
//         } catch (Exception e) {
//             return ResponseEntity.ok(error("방문 정보 저장 실패: " + detailMessage(e)));
//         }
//     }

//     /* =============================================
//        공통: PLC 주소에 값 쓰기
//        실패해도 예외를 던지지 않고 문자열로 반환
//     ============================================= */
//     private String writePlc(int address, int value) {
//         try {
//             Map<String, Integer> writeBody = new LinkedHashMap<>();
//             writeBody.put("address", address);
//             writeBody.put("value",   value);

//             HttpHeaders headers = new HttpHeaders();
//             headers.setContentType(MediaType.APPLICATION_JSON);
//             HttpEntity<Map<String, Integer>> entity = new HttpEntity<>(writeBody, headers);

//             Map<?, ?> res = rest.exchange(
//                 CSHARP_API + "/api/plc/write",
//                 HttpMethod.POST,
//                 entity,
//                 Map.class
//             ).getBody();

//             return res != null ? res.toString() : "ok";

//         } catch (Exception e) {
//             System.out.println(">>> [PLC WRITE ERR] D" + address + " : " + e.getMessage());
//             return "plc_error: " + e.getMessage();
//         }
//     }

//     /* =============================================
//        헬퍼 메서드
//     ============================================= */
//     private int getAttempts(HttpSession session) {
//         Object val = session.getAttribute(SESSION_PIN_ATTEMPTS);
//         return (val instanceof Integer) ? (Integer) val : 0;
//     }

//     private Map<String, Object> error(String message) {
//         Map<String, Object> r = new LinkedHashMap<>();
//         r.put("success", false);
//         r.put("error", message);
//         return r;
//     }

//     private String trim(Object value) {
//         return value == null ? "" : String.valueOf(value).trim();
//     }

//     private String detailMessage(Throwable t) {
//         while (t.getCause() != null) t = t.getCause();
//         String m = t.getMessage();
//         return (m == null || m.trim().isEmpty())
//             ? t.getClass().getSimpleName()
//             : t.getClass().getSimpleName() + ": " + m;
//     }

//     /* =============================================
//        출퇴근 PLC 기록 페이지 (GET)
//        URL: /ez_in_out/attend/list
//     ============================================= */
//     @RequestMapping(value = "/attend/list", method = RequestMethod.GET)
//     public String attendListPage() {
//         return "/ez_in_out/ez_in_out_list_page.jsp";
//     }

//     /* =============================================
//        현재 PLC 상태 조회 API (2초 폴링용)
//        GET /ez_in_out/attend/status
//     ============================================= */
//     @RequestMapping(
//         value    = "/attend/status",
//         method   = RequestMethod.GET,
//         produces = MediaType.APPLICATION_JSON_VALUE
//     )
//     @ResponseBody
//     public ResponseEntity<?> attendStatus() {
//         Map<String, Object> result = ezInOutAttendService.readPlcStatus();
//         return ResponseEntity.ok(result);
//     }

//     /* =============================================
//        최근 저장 이력 조회 API
//        GET /ez_in_out/attend/records?limit=20
//     ============================================= */
//     @RequestMapping(
//         value    = "/attend/records",
//         method   = RequestMethod.GET,
//         produces = MediaType.APPLICATION_JSON_VALUE
//     )
//     @ResponseBody
//     public ResponseEntity<?> attendRecords(
//             @RequestParam(value = "limit", defaultValue = "20") int limit) {
//         try {
//             if (limit < 1 || limit > 200) limit = 20;
//             List<EzInOutRecord> list = ezInOutAttendService.getRecentRecords(limit);
//             Map<String, Object> resp = new LinkedHashMap<>();
//             resp.put("success", true);
//             resp.put("data",    list);
//             return ResponseEntity.ok(resp);
//         } catch (Exception e) {
//             return ResponseEntity.ok(error("이력 조회 실패: " + detailMessage(e)));
//         }
//     }

//     /* =============================================
//        스케줄러 로그 조회 API
//        GET /ez_in_out/attend/logs
//     ============================================= */
//     @RequestMapping(
//         value    = "/attend/logs",
//         method   = RequestMethod.GET,
//         produces = MediaType.APPLICATION_JSON_VALUE
//     )
//     @ResponseBody
//     public ResponseEntity<?> attendLogs() {
//         try {
//             List<String> logs = ezInOutAttendService.getRecentLogs();
//             Map<String, Object> resp = new LinkedHashMap<>();
//             resp.put("success", true);
//             resp.put("logs",    logs);
//             return ResponseEntity.ok(resp);
//         } catch (Exception e) {
//             return ResponseEntity.ok(error("로그 조회 실패: " + detailMessage(e)));
//         }
//     }

//     /* =============================================
//        테스트용 D46 write API
//        POST /ez_in_out/attend/trigger
//     ============================================= */
//     @RequestMapping(
//         value    = "/attend/trigger",
//         method   = RequestMethod.POST,
//         produces = MediaType.APPLICATION_JSON_VALUE
//     )
//     @ResponseBody
//     public ResponseEntity<?> attendTrigger() {
//         String plcResult = writePlc(46, 1);
//         boolean ok = !plcResult.startsWith("plc_error");
//         Map<String, Object> resp = new LinkedHashMap<>();
//         resp.put("success", ok);
//         resp.put("plc",     plcResult);
//         if (!ok) resp.put("error", "PLC write 실패");
//         return ResponseEntity.ok(resp);
//     }

//     /* =============================================
//        출퇴근 기록 리스트 페이지 (GET)
//        URL: /ez_in_out/attend/record-list
//     ============================================= */
//     @RequestMapping(value = "/attend/record-list", method = RequestMethod.GET)
//     public String attendRecordListPage() {
//         return "/ez_in_out/ez_in_out_attend_list.jsp";
//     }

//     /* =============================================
//        기간+사원 조건 기록 조회 API (하루 1줄 반환)
//        GET /ez_in_out/attend/search
//            ?fromDt=2026-04-01&toDt=2026-04-30&empName=홍길동(optional)
//     ============================================= */
//     @RequestMapping(
//         value    = "/attend/search",
//         method   = RequestMethod.GET,
//         produces = MediaType.APPLICATION_JSON_VALUE
//     )
//     @ResponseBody
//     public ResponseEntity<?> attendSearch(
//             @RequestParam(required = false) String fromDt,
//             @RequestParam(required = false) String toDt,
//             @RequestParam(required = false) String empName) {
//         try {
//             Map<String, Object> params = new LinkedHashMap<>();
//             if (fromDt  != null && !fromDt.isEmpty())  params.put("fromDt",  fromDt);
//             if (toDt    != null && !toDt.isEmpty())     params.put("toDt",    toDt);
//             if (empName != null && !empName.isEmpty())  params.put("empName", empName);

//             // 하루 1줄 그룹핑 데이터
//             List<Map<String, Object>> daily   = ezInOutAttendService.getDailyRecords(params);
//             // 좌측 명단용 (empName 없이 전체 기간 조회)
//             Map<String, Object> empParams = new LinkedHashMap<>(params);
//             empParams.remove("empName");
//             List<Map<String, Object>> empList = ezInOutAttendService.getEmpListInPeriod(empParams);

//             Map<String, Object> resp = new LinkedHashMap<>();
//             resp.put("success", true);
//             resp.put("data",    daily);
//             resp.put("empList", empList);
//             return ResponseEntity.ok(resp);
//         } catch (Exception e) {
//             return ResponseEntity.ok(error("조회 실패: " + detailMessage(e)));
//         }
//     }

//     /* =============================================
//        전체 엑셀 다운로드 (전체요약 + 사원별 시트)
//        GET /ez_in_out/attend/excel/all?fromDt=&toDt=
//     ============================================= */
//     @RequestMapping(value = "/attend/excel/all", method = RequestMethod.GET)
//     public void excelDownloadAll(
//             @RequestParam(required = false) String fromDt,
//             @RequestParam(required = false) String toDt,
//             HttpServletResponse response) throws IOException {

//         Map<String, Object> params = new LinkedHashMap<>();
//         if (fromDt != null && !fromDt.isEmpty()) params.put("fromDt", fromDt);
//         if (toDt   != null && !toDt.isEmpty())   params.put("toDt",   toDt);
//         params.put("orderBy", "emp");  // 사원명·날짜 정렬

//         List<Map<String, Object>> all = ezInOutAttendService.getDailyRecords(params);

//         // 사원별 그룹핑
//         Map<String, List<Map<String, Object>>> grouped = new java.util.LinkedHashMap<>();
//         for (Map<String, Object> r : all) {
//             String name = str(r.get("empName"));
//             grouped.computeIfAbsent(name, k -> new ArrayList<>()).add(r);
//         }

//         String period   = (fromDt != null ? fromDt : "전체") + " ~ " + (toDt != null ? toDt : "전체");
//         String fileName = java.net.URLEncoder.encode("출퇴근기록_전체_" + period + ".xlsx", "UTF-8");

//         response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
//         response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + fileName);

//         try (org.apache.poi.xssf.usermodel.XSSFWorkbook wb = new org.apache.poi.xssf.usermodel.XSSFWorkbook()) {
//             ExcelStyles es = new ExcelStyles(wb);

//             // 전체 요약 시트 (사원명 컬럼 포함)
//             Sheet summary = wb.createSheet("전체요약");
//             writeDailySheet(wb, es, summary, all, "출퇴근 전체 기록 · " + period, true, fromDt, toDt);

//             // 사원별 시트
//             for (Map.Entry<String, List<Map<String, Object>>> entry : grouped.entrySet()) {
//                 String sn = entry.getKey();
//                 if (sn.length() > 31) sn = sn.substring(0, 31);
//                 Sheet sheet = wb.createSheet(sn);
//                 writeDailySheet(wb, es, sheet, entry.getValue(), entry.getKey() + " · " + period, false, fromDt, toDt);
//             }
//             wb.write(response.getOutputStream());
//         }
//     }

//     /* =============================================
//        개별 엑셀 다운로드
//        GET /ez_in_out/attend/excel/emp?empName=홍길동&fromDt=&toDt=
//     ============================================= */
//     @RequestMapping(value = "/attend/excel/emp", method = RequestMethod.GET)
//     public void excelDownloadEmp(
//             @RequestParam String empName,
//             @RequestParam(required = false) String fromDt,
//             @RequestParam(required = false) String toDt,
//             HttpServletResponse response) throws IOException {

//         Map<String, Object> params = new LinkedHashMap<>();
//         params.put("empName", empName);
//         if (fromDt != null && !fromDt.isEmpty()) params.put("fromDt", fromDt);
//         if (toDt   != null && !toDt.isEmpty())   params.put("toDt",   toDt);

//         List<Map<String, Object>> list = ezInOutAttendService.getDailyRecords(params);
//         String period   = (fromDt != null ? fromDt : "전체") + " ~ " + (toDt != null ? toDt : "전체");
//         String fileName = java.net.URLEncoder.encode("출퇴근기록_" + empName + "_" + period + ".xlsx", "UTF-8");

//         response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
//         response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + fileName);

//         try (org.apache.poi.xssf.usermodel.XSSFWorkbook wb = new org.apache.poi.xssf.usermodel.XSSFWorkbook()) {
//             ExcelStyles es = new ExcelStyles(wb);
//             String sn = empName.length() > 31 ? empName.substring(0, 31) : empName;
//             Sheet sheet = wb.createSheet(sn);
//             writeDailySheet(wb, es, sheet, list, empName + " · " + period, false, fromDt, toDt);
//             wb.write(response.getOutputStream());
//         }
//     }

//     /* =============================================
//        엑셀 시트 작성 (하루 1줄: 날짜·사원명·출근·외근·퇴근)
//     ============================================= */
//     private void writeDailySheet(org.apache.poi.xssf.usermodel.XSSFWorkbook wb,
//                                  ExcelStyles es, Sheet sheet,
//                                  List<Map<String, Object>> list,
//                                  String title, boolean showEmp,
//                                  String fromDt, String toDt) {
//         int COLS = showEmp ? 6 : 5;
//         int rowIdx = 0;

//         // ── 타이틀 행 ──
//         Row titleRow = sheet.createRow(rowIdx++);
//         titleRow.setHeightInPoints(34);
//         Cell tc = titleRow.createCell(0);
//         tc.setCellValue(title);
//         tc.setCellStyle(es.title);
//         sheet.addMergedRegion(new org.apache.poi.ss.util.CellRangeAddress(0, 0, 0, COLS - 1));

//         // ── 헤더 행 ──
//         Row hRow = sheet.createRow(rowIdx++);
//         hRow.setHeightInPoints(24);
//         String[] hdrs = showEmp
//             ? new String[]{"No", "날짜", "사원명", "출근", "외근", "퇴근"}
//             : new String[]{"No", "날짜", "출근", "외근", "퇴근"};
//         for (int i = 0; i < hdrs.length; i++) {
//             Cell c = hRow.createCell(i);
//             c.setCellValue(hdrs[i]);
//             c.setCellStyle(es.header);
//         }

//         // ── 월 범위 계산 (선택 기간이 하루여도 해당 월 1일~말일 출력) ──
//         LocalDate[] range = resolveMonthRange(fromDt, toDt, list);
//         LocalDate startDate = range[0];
//         LocalDate endDate = range[1];

//         // 데이터 lookup
//         Map<String, Map<String, Object>> rowByEmpDate = new HashMap<>();
//         LinkedHashSet<String> empOrder = new LinkedHashSet<>();
//         for (Map<String, Object> r : list) {
//             String emp = str(r.get("empName"));
//             String date = str(r.get("workDate"));
//             rowByEmpDate.put(emp + "|" + date, r);
//             if (!emp.isEmpty()) empOrder.add(emp);
//         }

//         int no = 1;
//         int inCnt = 0, extCnt = 0, outCnt = 0;

//         if (showEmp) {
//             for (String emp : empOrder) {
//                 for (LocalDate d = startDate; !d.isAfter(endDate); d = d.plusDays(1)) {
//                     String workDate = d.toString();
//                     Map<String, Object> r = rowByEmpDate.get(emp + "|" + workDate);
//                     String inT  = formatHm(r != null ? r.get("inTime") : null);
//                     String extT = formatHm(r != null ? r.get("extTime") : null);
//                     String outT = formatHm(r != null ? r.get("outTime") : null);
//                     boolean weekend = isHoliday(d);

//                     Row row = sheet.createRow(rowIdx++);
//                     row.setHeightInPoints(20);
//                     CellStyle base = (no % 2 == 0) ? es.alt : es.data;
//                     int col = 0;
//                     setCell(row, col++, String.valueOf(no++), es.noStyle(wb, base));
//                     setCell(row, col++, workDate, weekend ? ((base == es.alt) ? es.weekendDateAlt : es.weekendDate) : base);
//                     setCell(row, col++, emp, es.bold(wb, base));
//                     setCell(row, col++, inT,  "—".equals(inT)  ? base : es.inTime);
//                     setCell(row, col++, extT, "—".equals(extT) ? base : es.extTime);
//                     setCell(row, col++, outT, "—".equals(outT) ? base : es.outTime);

//                     if (!"—".equals(inT)) inCnt++;
//                     if (!"—".equals(extT)) extCnt++;
//                     if (!"—".equals(outT)) outCnt++;
//                 }
//             }
//         } else {
//             String emp = list.isEmpty() ? "" : str(list.get(0).get("empName"));
//             for (LocalDate d = startDate; !d.isAfter(endDate); d = d.plusDays(1)) {
//                 String workDate = d.toString();
//                 Map<String, Object> r = rowByEmpDate.get(emp + "|" + workDate);
//                 String inT  = formatHm(r != null ? r.get("inTime") : null);
//                 String extT = formatHm(r != null ? r.get("extTime") : null);
//                 String outT = formatHm(r != null ? r.get("outTime") : null);
//                 boolean weekend = isHoliday(d);

//                 Row row = sheet.createRow(rowIdx++);
//                 row.setHeightInPoints(20);
//                 CellStyle base = (no % 2 == 0) ? es.alt : es.data;
//                 int col = 0;
//                 setCell(row, col++, String.valueOf(no++), es.noStyle(wb, base));
//                 setCell(row, col++, workDate, weekend ? ((base == es.alt) ? es.weekendDateAlt : es.weekendDate) : base);
//                 setCell(row, col++, inT,  "—".equals(inT)  ? base : es.inTime);
//                 setCell(row, col++, extT, "—".equals(extT) ? base : es.extTime);
//                 setCell(row, col++, outT, "—".equals(outT) ? base : es.outTime);

//                 if (!"—".equals(inT)) inCnt++;
//                 if (!"—".equals(extT)) extCnt++;
//                 if (!"—".equals(outT)) outCnt++;
//             }
//         }

//         // ── 합계 행 ──
//         Row sumRow = sheet.createRow(rowIdx);
//         sumRow.setHeightInPoints(20);
//         setCell(sumRow, 0,              "합계",          es.sumLabel);
//         sheet.addMergedRegion(new org.apache.poi.ss.util.CellRangeAddress(rowIdx, rowIdx, 0, showEmp ? 2 : 1));
//         int sc = showEmp ? 3 : 2;
//         setCell(sumRow, sc++, "출근 " + inCnt  + "회", es.sumIn);
//         setCell(sumRow, sc++, "외근 " + extCnt + "회", es.sumExt);
//         setCell(sumRow, sc,   "퇴근 " + outCnt + "회", es.sumOut);

//         // ── 열 너비 ──
//         int[] widths = showEmp
//             ? new int[]{6, 14, 12, 10, 10, 10}
//             : new int[]{6, 14, 10, 10, 10};
//         for (int i = 0; i < widths.length; i++) {
//             sheet.setColumnWidth(i, widths[i] * 256);
//         }

//         // 헤더 고정
//         sheet.createFreezePane(0, 2);
//     }

//     private LocalDate[] resolveMonthRange(String fromDt, String toDt, List<Map<String, Object>> list) {
//         LocalDate from = parseDateOrNull(fromDt);
//         LocalDate to = parseDateOrNull(toDt);

//         if (from == null && !list.isEmpty()) {
//             from = parseDateOrNull(str(list.get(0).get("workDate")));
//             for (Map<String, Object> r : list) {
//                 LocalDate d = parseDateOrNull(str(r.get("workDate")));
//                 if (d != null && (from == null || d.isBefore(from))) from = d;
//                 if (d != null && (to == null || d.isAfter(to))) to = d;
//             }
//         }
//         if (to == null) to = from;
//         if (from == null) from = LocalDate.now();
//         if (to == null) to = from;

//         LocalDate start = YearMonth.from(from).atDay(1);
//         LocalDate end = YearMonth.from(to).atEndOfMonth();
//         return new LocalDate[]{start, end};
//     }

//     private LocalDate parseDateOrNull(String v) {
//         if (v == null || v.trim().isEmpty()) return null;
//         try {
//             return LocalDate.parse(v.trim().substring(0, 10));
//         } catch (Exception e) {
//             return null;
//         }
//     }

//     private String formatHm(Object v) {
//         String s = str(v);
//         if (s.isEmpty()) return "—";
//         if (s.length() >= 5 && s.charAt(2) == ':') return s.substring(0, 5);
//         return s;
//     }

//     private boolean isHoliday(LocalDate d) {
//         DayOfWeek w = d.getDayOfWeek();
//         return w == DayOfWeek.SATURDAY || w == DayOfWeek.SUNDAY;
//     }

//     /* ── 엑셀 스타일 묶음 ── */
//     private static class ExcelStyles {
//         final CellStyle title, header, data, alt;
//         final CellStyle inTime, extTime, outTime;
//         final CellStyle sumLabel, sumIn, sumExt, sumOut;
//         final CellStyle weekendDate, weekendDateAlt;

//         ExcelStyles(org.apache.poi.xssf.usermodel.XSSFWorkbook wb) {
//             // 공통 폰트
//             Font bodyFont = wb.createFont();
//             bodyFont.setFontName("맑은 고딕");
//             bodyFont.setFontHeightInPoints((short) 10);

//             // 타이틀
//             org.apache.poi.xssf.usermodel.XSSFCellStyle xTitle =
//                 (org.apache.poi.xssf.usermodel.XSSFCellStyle) wb.createCellStyle();
//             Font tf = wb.createFont(); tf.setFontName("맑은 고딕");
//             tf.setBold(true); tf.setFontHeightInPoints((short) 15);
//             tf.setColor(IndexedColors.WHITE.getIndex());
//             xTitle.setFont(tf);
//             xTitle.setFillForegroundColor(xColor(0x1B, 0x4F, 0x72));
//             xTitle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
//             xTitle.setAlignment(HorizontalAlignment.CENTER);
//             xTitle.setVerticalAlignment(VerticalAlignment.CENTER);
//             title = xTitle;

//             // 헤더
//             org.apache.poi.xssf.usermodel.XSSFCellStyle xHeader =
//                 (org.apache.poi.xssf.usermodel.XSSFCellStyle) wb.createCellStyle();
//             Font hf = wb.createFont(); hf.setFontName("맑은 고딕");
//             hf.setBold(true); hf.setFontHeightInPoints((short) 10);
//             hf.setColor(IndexedColors.WHITE.getIndex());
//             xHeader.setFont(hf);
//             xHeader.setFillForegroundColor(xColor(0x2E, 0x75, 0xB6));
//             xHeader.setFillPattern(FillPatternType.SOLID_FOREGROUND);
//             xHeader.setAlignment(HorizontalAlignment.CENTER);
//             xHeader.setVerticalAlignment(VerticalAlignment.CENTER);
//             border(xHeader);
//             header = xHeader;

//             // 일반 데이터
//             data = wb.createCellStyle();
//             data.setFont(bodyFont);
//             data.setAlignment(HorizontalAlignment.CENTER);
//             data.setVerticalAlignment(VerticalAlignment.CENTER);
//             border(data);

//             // 짝수행 (연회색)
//             org.apache.poi.xssf.usermodel.XSSFCellStyle xAlt =
//                 (org.apache.poi.xssf.usermodel.XSSFCellStyle) wb.createCellStyle();
//             xAlt.setFont(bodyFont);
//             xAlt.setFillForegroundColor(xColor(0xF2, 0xF2, 0xF2));
//             xAlt.setFillPattern(FillPatternType.SOLID_FOREGROUND);
//             xAlt.setAlignment(HorizontalAlignment.CENTER);
//             xAlt.setVerticalAlignment(VerticalAlignment.CENTER);
//             border(xAlt);
//             alt = xAlt;

//             weekendDate = weekendStyle(wb, data);
//             weekendDateAlt = weekendStyle(wb, alt);

//             // 출근 (연파랑)
//             inTime  = timeStyle(wb, bodyFont, 0xDB, 0xE9, 0xF7);
//             // 외근 (연주황)
//             extTime = timeStyle(wb, bodyFont, 0xFF, 0xF0, 0xD0);
//             // 퇴근 (연초록)
//             outTime = timeStyle(wb, bodyFont, 0xD9, 0xF0, 0xE3);

//             // 합계 행
//             Font sf = wb.createFont(); sf.setFontName("맑은 고딕");
//             sf.setBold(true); sf.setFontHeightInPoints((short) 10);
//             org.apache.poi.xssf.usermodel.XSSFCellStyle xSumLabel =
//                 (org.apache.poi.xssf.usermodel.XSSFCellStyle) wb.createCellStyle();
//             xSumLabel.setFont(sf);
//             xSumLabel.setFillForegroundColor(xColor(0xBF, 0xBF, 0xBF));
//             xSumLabel.setFillPattern(FillPatternType.SOLID_FOREGROUND);
//             xSumLabel.setAlignment(HorizontalAlignment.CENTER);
//             border(xSumLabel);
//             sumLabel = xSumLabel;

//             sumIn  = timeStyle(wb, sf, 0xDB, 0xE9, 0xF7);
//             sumExt = timeStyle(wb, sf, 0xFF, 0xF0, 0xD0);
//             sumOut = timeStyle(wb, sf, 0xD9, 0xF0, 0xE3);
//         }

//         private CellStyle weekendStyle(org.apache.poi.xssf.usermodel.XSSFWorkbook wb, CellStyle base) {
//             CellStyle s = wb.createCellStyle();
//             s.cloneStyleFrom(base);
//             Font f = wb.createFont();
//             f.setFontName("맑은 고딕");
//             f.setFontHeightInPoints((short) 10);
//             f.setColor(IndexedColors.RED.getIndex());
//             s.setFont(f);
//             return s;
//         }

//         private CellStyle timeStyle(org.apache.poi.xssf.usermodel.XSSFWorkbook wb, Font f, int r, int g, int b) {
//             org.apache.poi.xssf.usermodel.XSSFCellStyle s =
//                 (org.apache.poi.xssf.usermodel.XSSFCellStyle) wb.createCellStyle();
//             s.setFont(f);
//             s.setFillForegroundColor(xColor(r, g, b));
//             s.setFillPattern(FillPatternType.SOLID_FOREGROUND);
//             s.setAlignment(HorizontalAlignment.CENTER);
//             s.setVerticalAlignment(VerticalAlignment.CENTER);
//             border(s);
//             return s;
//         }

//         CellStyle noStyle(org.apache.poi.xssf.usermodel.XSSFWorkbook wb, CellStyle base) {
//             CellStyle s = wb.createCellStyle(); s.cloneStyleFrom(base);
//             Font f = wb.createFont(); f.setFontName("맑은 고딕");
//             f.setFontHeightInPoints((short) 9); f.setColor(IndexedColors.GREY_50_PERCENT.getIndex());
//             s.setFont(f); return s;
//         }

//         CellStyle bold(org.apache.poi.xssf.usermodel.XSSFWorkbook wb, CellStyle base) {
//             CellStyle s = wb.createCellStyle(); s.cloneStyleFrom(base);
//             Font f = wb.createFont(); f.setFontName("맑은 고딕");
//             f.setFontHeightInPoints((short) 10); f.setBold(true);
//             s.setFont(f); return s;
//         }

//         CellStyle mono(org.apache.poi.xssf.usermodel.XSSFWorkbook wb, CellStyle base) {
//             CellStyle s = wb.createCellStyle(); s.cloneStyleFrom(base);
//             Font f = wb.createFont(); f.setFontName("Courier New");
//             f.setFontHeightInPoints((short) 9); f.setColor(IndexedColors.GREY_50_PERCENT.getIndex());
//             s.setFont(f); return s;
//         }

//         static org.apache.poi.xssf.usermodel.XSSFColor xColor(int r, int g, int b) {
//             return new org.apache.poi.xssf.usermodel.XSSFColor(
//                 new byte[]{(byte) r, (byte) g, (byte) b}, null);
//         }

//         private static void border(CellStyle s) {
//             s.setBorderTop(BorderStyle.THIN);
//             s.setBorderBottom(BorderStyle.THIN);
//             s.setBorderLeft(BorderStyle.THIN);
//             s.setBorderRight(BorderStyle.THIN);
//         }
//     }

//     private void setCell(Row row, int col, String value, CellStyle style) {
//         Cell c = row.createCell(col);
//         c.setCellValue(value != null ? value : "");
//         c.setCellStyle(style);
//     }

//     private String str(Object v) { return v != null ? String.valueOf(v) : ""; }

//     /* =============================================
//        카드 마스터 목록 API (테스트 화면 select용)
//        GET /ez_in_out/attend/cards
//     ============================================= */
//     @RequestMapping(
//         value    = "/attend/cards",
//         method   = RequestMethod.GET,
//         produces = MediaType.APPLICATION_JSON_VALUE
//     )
//     @ResponseBody
//     public ResponseEntity<?> attendCards() {
//         try {
//             Map<String, Object> resp = new LinkedHashMap<>();
//             resp.put("success", true);
//             resp.put("data",    ezInOutAttendService.getCardMasterList());
//             return ResponseEntity.ok(resp);
//         } catch (Exception e) {
//             return ResponseEntity.ok(error("카드 목록 조회 실패: " + detailMessage(e)));
//         }
//     }

//     /* =============================================
//        테스트용 PLC D45 + D61~D64 쓰기
//        POST /ez_in_out/attend/write-test
//        Body: { "d45": 1, "cardCode": "73054C46" }
//     ============================================= */
//     @RequestMapping(
//         value    = "/attend/write-test",
//         method   = RequestMethod.POST,
//         produces = MediaType.APPLICATION_JSON_VALUE
//     )
//     @ResponseBody
//     public ResponseEntity<?> attendWriteTest(@RequestBody Map<String, Object> body) {
//         try {
//             int    d45      = Integer.parseInt(trim(body.get("d45")));
//             String cardCode = trim(body.get("cardCode")).toUpperCase();
//             ezInOutAttendService.writePlcTest(d45, cardCode);
//             Map<String, Object> resp = new LinkedHashMap<>();
//             resp.put("success", true);
//             return ResponseEntity.ok(resp);
//         } catch (Exception e) {
//             return ResponseEntity.ok(error("PLC 쓰기 실패: " + detailMessage(e)));
//         }
//     }

//     private String normalizeVisitReason(String r) {
//         if ("simple_visit".equals(r)) return "단순 방문";
//         if ("purchase".equals(r))     return "구매";
//         if ("ex1".equals(r))          return "ex1";
//         if ("ex4".equals(r))          return "ex4";
//         if ("other".equals(r))        return "기타";
//         return r;
//     }
// }
