package com.sample_pro.controller.master;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.file.Files;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.sample_pro.domain.PagePermission;
import com.sample_pro.domain.Permission;
import com.sample_pro.domain.UserMenu;
import com.sample_pro.domain.Users;

import com.sample_pro.service.master.PermService;
import com.sample_pro.service.master.UserService;

@Controller
public class UserController {
	
	@Autowired
	private UserService userService;

	@Autowired
	private PermService permService;

	private static final String[] ALL_PAGE_URLS = {
		"main/monitor", "equip/monitor", "equip/detail",
		"work/list", "work/now1", "work/now2",
		"trend", "alarm/history", "alarm/ranking",
		"calib/status", "inspect/daily", "auxiliary/inspection",
		"spare/parts", "facility/backup", "consumable/ledger",
		"inspect/fproof", "inspect/fprooflist",
		"user/manage", "user/permission"
	};

	public static int USER_CODE = 0;
	
	private static final Logger logger = LoggerFactory.getLogger(UserController.class);
	
	
	/* 직원 목록 조회 */
	@RequestMapping(value = "/emp/list", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> empList() {
		Map<String, Object> r = new HashMap<>();
		try { r.put("success", true);  r.put("data", userService.empList()); }
		catch(Exception e) { r.put("success", false); r.put("message", e.getMessage()); }
		return r;
	}

	/* 직원 저장 (INSERT / UPDATE) */
	@RequestMapping(value = "/emp/save", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> empSave(@RequestBody Map<String, Object> body) {
		Map<String, Object> r = new HashMap<>();
		try {
			Object empId = body.get("emp_id");
			if (empId == null || empId.toString().trim().isEmpty()) {
				userService.empInsert(body);
				// 신규 직원 생성 시 전체 페이지 권한 자동 부여
				Object newEmpId = body.get("emp_id");
				if (newEmpId != null) {
					List<PagePermission> perms = new ArrayList<>();
					for (String url : ALL_PAGE_URLS) {
						PagePermission p = new PagePermission();
						p.setPageUrl(url);
						p.setCanView("Y"); p.setCanAdd("Y"); p.setCanEdit("Y"); p.setCanDel("Y");
						perms.add(p);
					}
					permService.savePerms(Integer.parseInt(newEmpId.toString()), perms);
				}
			} else {
				userService.empUpdate(body);
			}
			r.put("success", true);
		} catch(Exception e) { r.put("success", false); r.put("message", e.getMessage()); }
		return r;
	}

	/* 직원 활성/비활성 토글 */
	@RequestMapping(value = "/emp/toggle", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> empToggle(@RequestBody Map<String, Object> body) {
		Map<String, Object> r = new HashMap<>();
		try { userService.empToggle(Integer.parseInt(body.get("emp_id").toString())); r.put("success", true); }
		catch(Exception e) { r.put("success", false); r.put("message", e.getMessage()); }
		return r;
	}

	/* 직원 삭제 */
	@RequestMapping(value = "/emp/delete", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> empDelete(@RequestBody Map<String, Object> body) {
		Map<String, Object> r = new HashMap<>();
		try { userService.empDelete(Integer.parseInt(body.get("emp_id").toString())); r.put("success", true); }
		catch(Exception e) { r.put("success", false); r.put("message", e.getMessage()); }
		return r;
	}

	/* 현재 로그인 직원 정보 */
	@RequestMapping(value = "/emp/me", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> empMe(HttpSession session) {
		Map<String, Object> r = new HashMap<>();
		Object emp = session.getAttribute("loginEmp");
		r.put("success", emp != null);
		if (emp != null) r.put("data", emp);
		return r;
	}

	/* 로그아웃 */
	@RequestMapping(value = "/user/logout", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> logout(HttpSession session) {
		session.invalidate();
		Map<String, Object> r = new HashMap<>();
		r.put("success", true);
		return r;
	}

	@RequestMapping(value = "/user/login", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> empLogin(
			@RequestParam String user_id,
			@RequestParam String user_pw,
			HttpSession session) {
		Map<String, Object> rtnMap = new HashMap<>();
		if (user_id == null || user_id.trim().isEmpty()) {
			rtnMap.put("success", false); rtnMap.put("message", "아이디를 입력하세요."); return rtnMap;
		}
		if (user_pw == null || user_pw.trim().isEmpty()) {
			rtnMap.put("success", false); rtnMap.put("message", "비밀번호를 입력하세요."); return rtnMap;
		}
		Map<String, Object> emp = userService.empLoginCheck(user_id.trim(), user_pw);
		if (emp == null) {
			rtnMap.put("success", false); rtnMap.put("message", "아이디 또는 비밀번호가 올바르지 않습니다."); return rtnMap;
		}
		session.setAttribute("loginEmp", emp);
		rtnMap.put("success", true);
		return rtnMap;
	}

	/*-----인원 및 안전관리-----*/
	//사용자 로그인 관리
	@RequestMapping(value = "/user/login/check", method = RequestMethod.POST) 
	@ResponseBody 
	public Map<String, Object> userLoginCheck(@ModelAttribute Users users, HttpSession session) {
		 Map<String, Object> rtnMap = new HashMap<String, Object>();
		 
		 if("".equals(users.getUser_id())){
			 rtnMap.put("data","ID를 입력해주십시오!");
			 return rtnMap;
		 }
		 
		 if("".equals(users.getUser_pw())){
			 rtnMap.put("data","PW를 입력해주십시오!");
			 return rtnMap;
		 }
		 
		 Users loginUser = userService.userLoginCheck(users);
		 
		 if(loginUser == null) {
			 rtnMap.put("data","등록되지 않은 사용자입니다.");
			 return rtnMap;			 
		 }

		 // 로그인한 대상의 page 정보 세션 저장
		 Permission loginPermission = userService.userLoginPermission(loginUser);

		 // 세션에 저장
		 session.setAttribute("loginUser", loginUser);
		 session.setAttribute("loginUserPage", loginPermission);

		 UserController.USER_CODE = Integer.parseInt(loginUser.getUser_code());

		 // ✅ 로그인 성공 로그 (시간 + 사용자명 + 사용자코드)
		 LocalDateTime now = LocalDateTime.now();
		 DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

		 System.out.println(" 로그인 [" + now.format(formatter) + "]"
				 + " 사용자명 = " + loginUser.getUser_name()
				 + ", 사용자코드 = " + loginUser.getUser_code());

		 // 반환 맵 구성
		 rtnMap.put("data", loginUser);
		 rtnMap.put("loginUserPage", loginPermission);

		 return rtnMap;
	}

	
	 //로그인한 사용자의 메뉴셋팅
	 @RequestMapping(value = "/user/login/menuSetting", method = RequestMethod.POST) 
	 @ResponseBody 
	 public Map<String, Object> userLoginMenuSetting(HttpSession session) {
		 Map<String, Object> rtnMap = new HashMap<String, Object>();
		 
		 Permission pageData = (Permission)session.getAttribute("loginUserPage");
		 
		 rtnMap.put("data",pageData);
		 
		 return rtnMap;
	 }
	 
	 


	 
	 
	 
	 //로그인한 사용자의 메뉴저장
	 @RequestMapping(value = "/user/login/menuSave", method = RequestMethod.POST) 
	 @ResponseBody 
	 public Map<String, Object> userLoginMenuSave(
			 @RequestParam int user_code,
			 @RequestParam String menu_url,
			 @RequestParam String menu_name) {
		 Map<String, Object> rtnMap = new HashMap<String, Object>();
		 
		 UserMenu userMenu = new UserMenu();
		 userMenu.setUser_code(user_code);
		 userMenu.setMenu_url(menu_url);
		 userMenu.setMenu_name(menu_name);
		 
		 userService.userLoginMenuSave(userMenu);
		 
		 rtnMap.put("data","OK");
		 
		 return rtnMap;
	 }
	 
	 //로그인한 사용자의 메뉴저장
	 @RequestMapping(value = "/user/login/menuList", method = RequestMethod.POST) 
	 @ResponseBody 
	 public Map<String, Object> userLoginMenuList(
			 @RequestParam int user_code) {
		 Map<String, Object> rtnMap = new HashMap<String, Object>();
		 
		 UserMenu userMenu = new UserMenu();
		 userMenu.setUser_code(user_code);
		 
		 List<UserMenu> userMenuList = userService.userLoginMenuList(userMenu);
		 
		 rtnMap.put("data",userMenuList);
		 
		 return rtnMap;
	 }
	 
	 
	 
	 
	 
	 //로그인한 사용자의 메뉴삭제
	 @RequestMapping(value = "/user/login/menuRemove", method = RequestMethod.POST) 
	 @ResponseBody 
	 public Map<String, Object> userLoginMenuRemove(
			 @RequestParam int user_code,
			 @RequestParam String menu_url) {
		 
		 
		 	//System.out.println("▶ user_code: " + user_code);
		    //System.out.println("▶ menu_url: " + menu_url);
		 
		 Map<String, Object> rtnMap = new HashMap<String, Object>();
		 
		 UserMenu userMenu = new UserMenu();
		 userMenu.setUser_code(user_code);
		 userMenu.setMenu_url(menu_url);
		 
		 userService.userLoginMenuRemove(userMenu);
		 
		 rtnMap.put("data","OK");
		 
		 return rtnMap;
	 }
	 
	 
	 
	 //사용자 로그
	 @RequestMapping(value = "/user/login_log", method = RequestMethod.GET)
	 public String login_log(Users users) {
		 return "/user/login_log.jsp";	       
	 }
	 
	 
	 
	 
	 
	 
	 
	 //사용자 등록 조회 
	 @RequestMapping(value = "/user/userInsert", method = RequestMethod.GET)
	 public String userInsertList(Users users) {
		 return "/user/userInsert.jsp";	       
	 }
	 
	// 전체 사용자목록 조회
	 @RequestMapping(value = "/user/userInsert/select", method = RequestMethod.POST)
	 @ResponseBody
	 public List<Users> userInsertSelect(Users users) {
	     // //System.out.println("======= [userInsertSelect 호출됨] =======");
	     // //System.out.println("user_name: " + users.getUser_name());
	     // //System.out.println("startDate: " + users.getStartDate());
	     // //System.out.println("=======================================");

	     List<Users> result = userService.userInsertSelect(users);

	     // //System.out.println("======= [반환 데이터 목록] =======");
	     // for (Users u : result) {
	     //     //System.out.println(
	     //         "ID: " + u.getUser_id() +
	     //         ", 이름: " + u.getUser_name() +
	     //         ", 입사일: " + u.getSt_day() +
	     //         ", 부서: " + u.getUser_busu()
	     //     );
	     // }
	     // //System.out.println("총 개수: " + result.size());
	     // //System.out.println("===================================");

	     return result;
	 }

	 @RequestMapping(value = "/user/userInsert/delete", method = RequestMethod.POST)
	 @ResponseBody
	 public String deleteUser(@RequestBody Users user) {
	     //System.out.println("======= [deleteUser 호출됨] =======");
	     //System.out.println("삭제 대상 user_code: " + user.getUser_code());
	     //System.out.println("===================================");

	     try {
	    	 userService.userInsertDel(user); 
	         return "success";
	     } catch (Exception e) {
	         e.printStackTrace();
	         return "fail";
	     }
	 }
	 
	
	 @RequestMapping(value = "/user/userInsert/insert", method = RequestMethod.POST)
	 @ResponseBody
	 public Map<String, Object> userInsertInsert(@ModelAttribute Users users) {
	     Map<String, Object> rtnMap = new HashMap<>();

	     System.out.println("=== [USER INSERT/UPDATE CALL] ===");
	     System.out.println("user_code = " + users.getUser_code());
	     System.out.println("user_id   = " + users.getUser_id());
	     System.out.println("================================");

	     if (users.getUser_id() == null || users.getUser_id().trim().equals("")) {
	         rtnMap.put("data", "아이디를 입력해주십시오!");
	         System.out.println("[ERROR] 아이디 미입력");
	         return rtnMap;
	     }

	     if (users.getUser_pw() == null || users.getUser_pw().trim().equals("")) {
	         rtnMap.put("data", "비밀번호를 입력해주십시오!");
	         System.out.println("[ERROR] 비밀번호 미입력");
	         return rtnMap;
	     }

	     Users duplicateUser = userService.userDuplicateCheck(users);

	     if (duplicateUser != null) {
	         if (users.getUser_code() == null || users.getUser_code().trim().equals("")) {
	             rtnMap.put("data", "이미 등록된 아이디입니다.");
	             System.out.println("[ERROR] 아이디 중복(INSERT)");
	             return rtnMap;
	         } else {
	             if (!duplicateUser.getUser_code().equals(users.getUser_code())) {
	                 rtnMap.put("data", "이미 등록된 아이디입니다.");
	                 System.out.println("[ERROR] 아이디 중복(UPDATE)");
	                 return rtnMap;
	             }
	         }
	     }

	     try {
	         // INSERT vs UPDATE
	         if (users.getUser_code() == null || users.getUser_code().trim().equals("")) {
	             System.out.println("[DB] INSERT 실행 (신규등록)");
	             userService.userInsertInsert(users);
	         } else {
	             System.out.println("[DB] UPDATE 실행 (user_code=" + users.getUser_code() + ")");
	             userService.userUpdate(users);
	         }

	         rtnMap.put("data", "OK");
	         System.out.println("[SUCCESS] 처리 완료");

	     } catch(Exception e) {
	         rtnMap.put("data", "오류 발생");
	         System.out.println("❌ DB 오류: " + e.getMessage());
	         e.printStackTrace();
	     }

	     return rtnMap;
	 }



	 
	 //권한부여
	 @RequestMapping(value = "/user/userPermission", method = RequestMethod.GET)
	 public String userPermission(Users users) {
		 return "/user/userPermission.jsp";	       
	 }
	 
	 //사원별 권한등록 사용자 선택
	 @RequestMapping(value = "/user/userPermission/userSelectPermission", method = RequestMethod.POST)
	 @ResponseBody
	 public Map<String, Object> userPermissionUserSelectPerm(
			 @RequestParam(required = false) String  user_code){
		 Map<String, Object> rtnMap = new HashMap<String, Object>();
		 
		 Users users = new Users();
		 users.setUser_code(user_code);
		 
		 Permission selectPermission = userService.userLoginPermission(users);
		 
		 rtnMap.put("data", selectPermission);

		 return rtnMap;
	 }	 
	 
	 //사용자별 권한등록 사용자 선택 후 수정
	 @RequestMapping(value = "/user/userPermission/update", method = RequestMethod.POST)
	 @ResponseBody
	 public Map<String, Object> userPermissionUpdate(@ModelAttribute Permission permission){
		 Map<String, Object> rtnMap = new HashMap<String, Object>();

		 //System.out.println(permission.getUser_code());
		 /*		 //System.out.println(permission.getA01());
		 //System.out.println(permission.getB01());
*/
		 userService.userPermissionUpdate(permission);
		 
		 return rtnMap;
	 }
	 
	 
	 //전체 사용자목록 조회
	 @RequestMapping(value = "/user/userPermission/userSelect", method = RequestMethod.POST) 
	 @ResponseBody 
	 public Map<String, Object> userPermissionUserSelect() {
		 Map<String, Object> rtnMap = new HashMap<String, Object>();
		 
		 List<Users> userList = userService.userPermissionUserSelect();
		 
		 List<HashMap<String, Object>> rtnList = new ArrayList<HashMap<String, Object>>();
		 for(int i=0; i<userList.size(); i++) {
			 HashMap<String, Object> rowMap = new HashMap<String, Object>();
			 rowMap.put("idx", (i+1));
			 rowMap.put("user_id", userList.get(i).getUser_id());
			 rowMap.put("user_busu", userList.get(i).getUser_busu());
			 rowMap.put("user_code", userList.get(i).getUser_code());
			 rowMap.put("user_jick", userList.get(i).getUser_jick());
			 rowMap.put("user_name", userList.get(i).getUser_name());
			 rtnList.add(rowMap);
		 }
		 
		 rtnMap.put("last_page",1);
		 rtnMap.put("data",rtnList);
		 
		 return rtnMap; 
	 }
	 
	 
	 @RequestMapping(value = "/user/info", method = RequestMethod.POST)
	 @ResponseBody
	 public Map<String, Object> getUserInfo(HttpSession session) {
	     Map<String, Object> result = new HashMap<>();
	     
	     // 세션에서 데이터 가져오기
	     Users loginUser = (Users) session.getAttribute("loginUser");
	     Permission loginPermission = (Permission) session.getAttribute("loginUserPage");

	 
	     if (loginUser != null) {
	         result.put("loginUser", loginUser);
	     }
	     if (loginPermission != null) {
	         result.put("loginUserPage", loginPermission);
	     }
	     
	     return result;
	 }


	 
	 
	//자격인증관리 및 교육계획 및 실적 포함 (안전환경, 실무, 설비)
    @RequestMapping(value= "/user/planManage", method = RequestMethod.GET)
    public String planManage(Model model) {
        return "/user/planManage.jsp"; // 
    }
    
    
    
    @RequestMapping(value = "/user/planManage/list", method = RequestMethod.POST)
    @ResponseBody
    public List<Users> getplanManageList(Users users) {

        return userService.getplanManageList(users);
    }

	
    @RequestMapping(value = "/user/planManage/insert", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> insertplanManage(
            @ModelAttribute Users users,
            @RequestParam(value = "file_url", required = false) MultipartFile[] files) {

        Map<String, Object> rtnMap = new HashMap<>();

        try {
  
            userService.insertplanManage(users);

       
            if (files != null) {
                String uploadDir = "D:/GEOMET양식/자격인증관리";

                File directory = new File(uploadDir);
                if (!directory.exists()) {
                    directory.mkdirs(); 
                }

                for (MultipartFile file : files) {
                    if (!file.isEmpty()) {
                        String originalFilename = file.getOriginalFilename();
                        File destination = new File(uploadDir + "/" + originalFilename);
                        file.transferTo(destination);
                    }
                }
            }

            rtnMap.put("result", "success");

        } catch (Exception e) {
            e.printStackTrace();
            rtnMap.put("result", "fail");
            rtnMap.put("message", e.getMessage());
        }

        return rtnMap;
    }
    
    
    
    @RequestMapping(value = "/user/planManage/delete", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> delplanManage(@RequestBody Users users) {
        Map<String, Object> rtnMap = new HashMap<>();
        //System.out.println("삭제 요청 받은 데이터: " + users);

        if (users.getNo() == null) {
            rtnMap.put("data", "행 선택하세요");
            return rtnMap;
        }

        userService.delplanManage(users);

        rtnMap.put("data", "success");
        return rtnMap;
    }
    
    
    
    
    
    
    
    
    
	
	//작업자 근무현황 및 인수인계 포함
    @RequestMapping(value= "/user/workerManage", method = RequestMethod.GET)
    public String workerManage(Model model) {
        return "/user/workerManage.jsp"; // 
    }	
	//작업자 근무현황 및 인수인계 포함
    @RequestMapping(value= "/user/workerManage2", method = RequestMethod.GET)
    public String workerManage2(Model model) {
        return "/user/workerManage2.jsp"; // 
    }	
	
	//지게차, 청소차 점검일지
    @RequestMapping(value= "/user/carManage", method = RequestMethod.GET)
    public String carManage(Model model) {
        return "/user/carManage.jsp"; // 
    }
	
	//유해화학물질 취급시설 점검일지 및 순회 점검
    @RequestMapping(value= "/user/checkManage", method = RequestMethod.GET)
    public String checkManage(Model model) {
        return "/user/checkManage.jsp"; // 
    }	
	
	/*-----문서관리-----*/
	
	//관리계획서, 작업표준서, 설비점검일지, MSDS
    @RequestMapping(value= "/user/standardDocManage", method = RequestMethod.GET)
    public String standardDocManage(Model model) {
        return "/user/standardDocManage.jsp"; // 
    }	
	
	//사양별 대기통수 (각 공정별) 및 긴급품(로직 후공정 생산계획) 현황
    @RequestMapping(value= "/user/productDocManage", method = RequestMethod.GET)
    public String productDocManage(Model model) {
        return "/user/productDocManage.jsp"; // 
    }	
	
	//점검일정 준수 체크 시트
    @RequestMapping(value= "/user/checkDocManage", method = RequestMethod.GET)
    public String checkDocManage(Model model) {
        return "/user/checkDocManage.jsp"; // 
    }	
    
	
    
    
  
    @RequestMapping(value = "/user/workerManage/list", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getworkDailyReportList(@RequestBody Users users) {
        //System.out.println("받은 s_time 값: " + users.getS_time());

        Map<String, Object> result = new HashMap<>();
        List<?> table1 = userService.getWork_team_select(users);
        List<?> table2 = userService.getWork_schedule_select(users);

     //   //System.out.println("table1 리턴값: " + table1);
     //   //System.out.println("table2 리턴값: " + table2);

        result.put("table1", table1);
        result.put("table2", table2);
        return result;
    }

    @RequestMapping(value = "/user/workerManage/insert", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> work_handover_update(
        @RequestParam("id") Integer id,
        @RequestParam("column") String column,
        @RequestParam("value") String value) {

        Map<String, Object> rtnMap = new HashMap<>();

        //System.out.println("== work_handover_update 요청값 ==");
        //System.out.println("id: " + id);
        //System.out.println("column: " + column);
        //System.out.println("value: " + value);
        //System.out.println("==============================");

        if (id == null) {
            rtnMap.put("error", "ID 입력 필요");
            return rtnMap;
        }

      
        Users users = new Users();
        users.setId(id);
        users.setColumn(column);  
        users.setValue(value);   

      
        userService.work_team_update(users);

        rtnMap.put("result", "success");
        return rtnMap;
    }
    @RequestMapping(
    	    value = "/user/workerManage/insertSchedule", 
    	    method = RequestMethod.POST,
    	    consumes = "application/json" 
    	)
    	@ResponseBody
    	public Map<String, Object> work_schedule_update(@RequestBody Users users) {
    	    Map<String, Object> rtn = new HashMap<>();

    	    //System.out.println("=== updateWorkSchedule 요청값 ===");
    	    //System.out.println("id: "         + users.getId());
    	    //System.out.println("date: "       + users.getDate());
    	    //System.out.println("shift_type: "+ users.getShift_type());
    	
    	    //System.out.println("==============================");

    	    if (users.getId() == null) {
    	        rtn.put("error", "ID 필요");
    	        return rtn;
    	    }

    	
    	    userService.work_schedule_update(users);

    	    rtn.put("result", "success");
    	    return rtn;
    	}

    
    
    
    
    
    @RequestMapping(
    	    value = "/user/work_handover/insert", 
    	    method = RequestMethod.POST,
    	    consumes = "application/json" 
    	)
    	@ResponseBody
    	public Map<String, Object> work_handover_update(@RequestBody Users users) {
    	    Map<String, Object> rtn = new HashMap<>();

    	    //System.out.println("=== 인수인계 요청값 ===");
    	    //System.out.println("id: "         + users.getId());
    	   
    	
    	    //System.out.println("==============================");

    	    if (users.getId() == null) {
    	        rtn.put("error", "ID 필요");
    	        return rtn;
    	    }

    	
    	    userService.work_handover_update(users);

    	    rtn.put("result", "success");
    	    return rtn;
    	}

    @RequestMapping(value = "/user/work_handover/list", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> work_handover_select(@RequestBody Users users) {
        //System.out.println("받은 s_time 값: " + users.getS_time());

        Map<String, Object> result = new HashMap<>();
      
        List<?> table2 = userService.work_handover_select(users);

 
     //   //System.out.println("table2 리턴값: " + table2);

        result.put("table2", table2);
        return result;
    }

    
    @RequestMapping(value = "/user/getCleanCar/List", method = RequestMethod.POST)
    @ResponseBody
    public List<Users> getCleanCar(Users users) {

        return userService.getCleanCar(users);
    }
    @RequestMapping(value = "/user/getForkCar/List", method = RequestMethod.POST)
    @ResponseBody
    public List<Users> getForkCar(Users users) {
        return userService.getForkCar(users);
    }
    
    @RequestMapping(value = "/user/getForkCar/insert", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> insertForkCar(@ModelAttribute Users users) {
        
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        
        if(users.getCar_date() == null) {
        	rtnMap.put("data", "날짜 입력하시오!");
        	return rtnMap;
        }

        userService.insertForkCar(users); 
        
        return rtnMap;
    }
    @RequestMapping(value = "/user/getCleanCar/insert", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> insertCleanCar(@ModelAttribute Users users) {
        
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        
        if(users.getCar_date() == null) {
        	rtnMap.put("data", "날짜 입력하시오!");
        	return rtnMap;
        }

        userService.insertCleanCar(users); 
        
        return rtnMap;
    }
    
    
    //
    @RequestMapping(value = "/user/standardDoc/list", method = RequestMethod.POST)
    @ResponseBody
    public List<Users>standardDocList(Users users) {
        /*
         * //System.out.println(">>> test_mch_name: " + users.getMch_name());
         * //System.out.println(">>> test_t_year: " + users.getT_year());
         */
        return userService.standardDocList(users);
    }

	/*
	 * @RequestMapping(value = "/user/standardDoc/insert", method =
	 * RequestMethod.POST)
	 * 
	 * @ResponseBody public Map<String, Object> standardDocSaves(
	 * 
	 * @RequestParam(value = "idx", required = false) String idx,
	 * 
	 * @RequestParam("cr_date") String cr_date,
	 * 
	 * @RequestParam("mch_name") String mch_name,
	 * 
	 * @RequestParam(value = "memo", required = false) String memo,
	 * 
	 * @RequestParam(value = "box1", required = false) MultipartFile box1,
	 * 
	 * @RequestParam(value = "box2", required = false) MultipartFile box2,
	 * 
	 * @RequestParam(value = "box3", required = false) MultipartFile box3,
	 * 
	 * @RequestParam(value = "box4", required = false) MultipartFile box4 ) {
	 * Map<String, Object> rtnMap = new HashMap<>(); String basePath =
	 * "D:/GEOMET양식/문서관리/";
	 * 
	 * try { Users users = new Users(); users.setIdx(idx);
	 * users.setCr_date(cr_date); users.setMch_name(mch_name); users.setMemo(memo);
	 * 
	 * if (box1 != null && !box1.isEmpty()) { String origName =
	 * box1.getOriginalFilename(); box1.transferTo(new File(basePath + origName));
	 * users.setBox1(origName); } if (box2 != null && !box2.isEmpty()) { String
	 * origName = box2.getOriginalFilename(); box2.transferTo(new File(basePath +
	 * origName)); users.setBox2(origName); } if (box3 != null && !box3.isEmpty()) {
	 * String origName = box3.getOriginalFilename(); box3.transferTo(new
	 * File(basePath + origName)); users.setBox3(origName); } if (box4 != null &&
	 * !box4.isEmpty()) { String origName = box4.getOriginalFilename();
	 * box4.transferTo(new File(basePath + origName)); users.setBox4(origName); }
	 * 
	 * userService.standardDocSaves(users);
	 * 
	 * rtnMap.put("result", "success"); } catch (Exception e) { e.printStackTrace();
	 * rtnMap.put("result", "fail"); rtnMap.put("message", "DB 저장 실패: " +
	 * e.getMessage()); } return rtnMap; }
	 */
    @RequestMapping(value = "/user/standardDoc/del", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> standardDocDel(@RequestBody Users users) {
        Map<String, Object> rtnMap = new HashMap<>();

        if (users.getIdx() == null) {
            rtnMap.put("data", "행 선택하세요");
            return rtnMap;
        }

        userService.standardDocDel(users);

        rtnMap.put("data", "success"); 
        return rtnMap;
    }

    @RequestMapping(value = "/download_standardDoc안씀", method = RequestMethod.GET)
    public void downloadExcel(@RequestParam("filename") String filename,
                              HttpServletResponse response) throws IOException {

        String baseDir = "D:/GEOMET양식/문서관리/";

       
        if (filename.contains("..") || filename.contains("/") || filename.contains("\\")) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        File file = new File(baseDir + filename);
      
        if (!file.exists()) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String mimeType = Files.probeContentType(file.toPath());
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }
        response.setContentType(mimeType);
        response.setContentLengthLong(file.length());


        String encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");


        response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encodedFilename);

        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = response.getOutputStream()) {
            byte[] buffer = new byte[1024];
            int len;
            while ((len = fis.read(buffer)) != -1) {
                os.write(buffer, 0, len);
            }
            os.flush();
        }
    }
    
    
    
    
    
    
    
    
    @RequestMapping(value = "/user/CheckManage/List", method = RequestMethod.POST)
    @ResponseBody
    public List<Users> getCheckManageList(Users users) {
        return userService.getCheckManageList(users);
    }
    
    @RequestMapping(value = "/user/CheckManage/insert", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> updateCheckManage(@ModelAttribute Users users) {
        
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        
        if(users.getCk_date() == null) {
        	rtnMap.put("ck_data", "날짜 입력하시오!");
        	return rtnMap;
        }

        userService.updateCheckManage(users); 
        
        return rtnMap;
    }
    
    @RequestMapping(value = "/user/login/log", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> userLoginLog(
            @RequestParam int user_code,
            @RequestParam(required = false) String memo) {

        Map<String, Object> rtnMap = new HashMap<>();

        try {
            userService.insertLoginLog(user_code, memo);
            rtnMap.put("data", "OK");
        } catch (Exception e) {
            e.printStackTrace();
            rtnMap.put("data", "FAIL");
        }

        return rtnMap;
    }
    @RequestMapping(value = "/user/login/log/list", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> loginLogList() {

        Map<String, Object> rtnMap = new HashMap<>();

        try {
            List<Map<String, Object>> rawList = userService.selectLoginLogList();

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            List<Map<String, Object>> formattedList = new ArrayList<>();

            for (Map<String, Object> log : rawList) {
                Map<String, Object> m = new HashMap<>(log);

                Object loginDtObj = log.get("login_dt");
                if (loginDtObj != null) {
                    if (loginDtObj instanceof java.sql.Timestamp) {
                        java.sql.Timestamp ts = (java.sql.Timestamp) loginDtObj;
                        LocalDateTime dt = ts.toLocalDateTime();
                        m.put("login_dt", dt.format(formatter));
                    } else {
                        m.put("login_dt", loginDtObj.toString());
                    }
                }

                formattedList.add(m);
            }

            rtnMap.put("data", formattedList);
        } catch (Exception e) {
            e.printStackTrace();
            rtnMap.put("data", new ArrayList<>());
        }

        return rtnMap;
    }


}

