package com.sample_pro.service.master;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sample_pro.dao.master.UserDao;

import com.sample_pro.domain.Permission;
import com.sample_pro.domain.UserLog;
import com.sample_pro.domain.UserMenu;
import com.sample_pro.domain.Users;


@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao userDao;

    @Override
    public List<Map<String, Object>> empList() {
        return userDao.empList();
    }
    @Override
    public void empInsert(Map<String, Object> params) {
        userDao.empInsert(params);
    }
    @Override
    public void empUpdate(Map<String, Object> params) {
        userDao.empUpdate(params);
    }
    @Override
    public void empToggle(int empId) {
        Map<String, Object> p = new java.util.HashMap<>();
        p.put("emp_id", empId);
        userDao.empToggle(p);
    }
    @Override
    public void empDelete(int empId) {
        Map<String, Object> p = new java.util.HashMap<>();
        p.put("emp_id", empId);
        userDao.empDelete(p);
    }

    @Override
    public Map<String, Object> empLoginCheck(String id, String pwNo) {
        Map<String, Object> params = new java.util.HashMap<>();
        params.put("id", id);
        params.put("pw_no", pwNo);
        return userDao.empLoginCheck(params);
    }

    @Override
    public Users userLoginCheck(Users users) {
        return userDao.userLoginCheck(users);
    }

    @Override
    public Permission userLoginPermission(Users loginUser) {
        return userDao.userLoginPermission(loginUser);
    }

    @Override
    public void userInsertInsert(Users users) {
        userDao.userInsertInsert(users);
    }
    @Override
    public void userUpdate(Users users) {
        userDao.userUpdate(users);
    }

    @Override
    public void userPermissionUpdate(Permission permission) {
        userDao.userPermissionUpdate(permission);
    }

    @Override
    public List<Users> userPermissionUserSelect() {
        return userDao.userPermissionUserSelect();
    }

    @Override
    public List<Users> userInsertSelect(Users users) {
        return userDao.userInsertSelect(users);
    }

    @Override
    public void userInsertDel(Users users) {
        userDao.userInsertDel(users);
    }

    @Override
    public Users userDuplicateCheck(Users users) {
        return userDao.userDuplicateCheck(users);
    }

    @Override
    public List<UserMenu> userLoginMenuList(UserMenu userMenu) {
        return userDao.userLoginMenuList(userMenu);
    }

    @Override
    public void userLoginMenuSave(UserMenu userMenu) {
        userDao.userLoginMenuSave(userMenu);
    }

   
    @Override
    public void userLoginMenuRemove(UserMenu userMenu) {
        userDao.userLoginMenuRemove(userMenu);
    }

    @Override
    public List<Users> getplanManageList(Users users) {
        return userDao.getplanManageList(users);
    }

    @Override
    public void insertplanManage(Users users) {
        userDao.insertplanManage(users);
    }

    @Override
    public void delplanManage(Users users) {
        userDao.delplanManage(users);
    }

    @Override
    public List<Users> getUserInfo() {
        return userDao.getUserInfo();
    }

    @Override
    public List<Users> getWork_team_select(Users users) {
        return userDao.getWork_team_select(users);
    }

    @Override
    public List<Users> getWork_schedule_select(Users users) {
        return userDao.getWork_schedule_select(users);
    }

    @Override
    public void work_handover_update(Users users) {
        userDao.work_handover_update(users);
    }

    @Override
    public List<Users> work_handover_select(Users users) {
        return userDao.work_handover_select(users);
    }

    @Override
    public void work_team_update(Users users) {
        userDao.work_team_update(users);
    }

    @Override
    public void work_schedule_update(Users users) {
        userDao.work_schedule_update(users);
    }

    @Override
    public List<Users> getCleanCar(Users users) {
        return userDao.getCleanCar(users);
    }

    @Override
    public List<Users> getForkCar(Users users) {
        return userDao.getForkCar(users);
    }

    @Override
    public void insertForkCar(Users users) {
        userDao.insertForkCar(users);
    }

    @Override
    public void insertCleanCar(Users users) {
        userDao.insertCleanCar(users);
    }

    @Override
    public List<Users> standardDocList(Users users) {
        return userDao.standardDocList(users);
    }

    @Override
    public void standardDocSaves(Users users) {
        userDao.standardDocSaves(users);
    }

    @Override
    public void standardDocDel(Users users) {
        userDao.standardDocDel(users);
    }

    @Override
    public List<Users> getCheckManageList(Users users) {
        return userDao.getCheckManageList(users);
    }

    @Override
    public void updateCheckManage(Users users) {
        userDao.updateCheckManage(users);
    }
    
    
    @Override
    public void insertUserLog(UserLog userLog) {
        userDao.insertUserLog(userLog);
    }
    
    @Override
    public void insertLoginLog(int userCode, String memo) {
        userDao.insertLoginLog(userCode, memo);
    }
    
    @Override
    public List<Map<String, Object>> selectLoginLogList() {
        return userDao.selectLoginLogList();
    }

}
