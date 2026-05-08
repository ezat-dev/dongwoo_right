package com.sample_pro.dao.master;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;


import com.sample_pro.domain.Permission;
import com.sample_pro.domain.UserLog;
import com.sample_pro.domain.UserMenu;
import com.sample_pro.domain.Users;

public interface UserDao {

	List<Map<String, Object>> empList();
	void empInsert(Map<String, Object> params);
	void empUpdate(Map<String, Object> params);
	void empToggle(Map<String, Object> params);
	void empDelete(Map<String, Object> params);

	Map<String, Object> empLoginCheck(Map<String, Object> params);

	Users userLoginCheck(Users users);

	Permission userLoginPermission(Users loginUser);

	void userInsertInsert(Users users);
	void userUpdate(Users users);
	void userPermissionUpdate(Permission permission);

	List<Users> userPermissionUserSelect();

	List<Users> userInsertSelect(Users users);
	void userInsertDel(Users users);
	Users userDuplicateCheck(Users users);

	List<UserMenu> userLoginMenuList(UserMenu userMenu);

	void userLoginMenuSave(UserMenu userMenu);

	void userLoginMenuRemove(UserMenu userMenu);
	//자격인증관리
	List<Users> getplanManageList(Users users);
	void insertplanManage(Users users); 
	void delplanManage(Users users);

	
	List<Users> getWork_team_select(Users users);
	List<Users> getWork_schedule_select(Users users);
	
	List<Users> work_handover_select(Users users);
	void work_handover_update(Users users); 
	
	
	
	void work_team_update(Users users);
	void work_schedule_update(Users users);
	
	List<Users> getUserInfo(); 
	
	List<Users> getCleanCar(Users users);
	List<Users> getForkCar(Users users);
	void insertForkCar(Users users); 
	void insertCleanCar(Users users); 
	

	List<Users> standardDocList(Users users);     
    void standardDocSaves(Users users);   
    void standardDocDel(Users users);
    
 
    
   List<Users> getCheckManageList(Users users);   
    void updateCheckManage(Users users);
    
    void insertUserLog(UserLog userLog);
    
    void insertLoginLog(@Param("userCode") int userCode,
            @Param("memo") String memo);
    
    List<Map<String, Object>> selectLoginLogList();

}
