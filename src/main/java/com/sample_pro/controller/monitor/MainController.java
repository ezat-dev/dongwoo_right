package com.sample_pro.controller.monitor;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/main_1")
public class MainController {

    @RequestMapping(value = "/main",           method = RequestMethod.GET) public String main()          { return "/main_1/main.jsp"; }
    @RequestMapping(value = "/main/monitor",  method = RequestMethod.GET) public String mainMonitor()  { return "/main_1/monitor/main_monitor.jsp"; }
    @RequestMapping(value = "/main/monitor2", method = RequestMethod.GET) public String mainMonitor2() { return "/main_1/monitor/main_monitor2.jsp"; }
    @RequestMapping(value = "/login",          method = RequestMethod.GET) public String login()         { return "/main_1/login.jsp"; }

    // 설비
    @RequestMapping(value = "/equip/monitor",  method = RequestMethod.GET) public String equipMonitor()  { return "/main_1/monitor/equip_monitor.jsp"; }
    @RequestMapping(value = "/equip/detail",   method = RequestMethod.GET) public String equipDetail()   { return "/main_1/monitor/equip_detail.jsp"; }
    @RequestMapping(value = "/work/list",      method = RequestMethod.GET) public String workList()      { return "/main_1/monitor/workList.jsp"; }
    @RequestMapping(value = "/work/now1",      method = RequestMethod.GET) public String nowWork1()      { return "/main_1/monitor/now_work_1.jsp"; }
    @RequestMapping(value = "/work/now2",      method = RequestMethod.GET) public String nowWork2()      { return "/main_1/monitor/now_work_2.jsp"; }

    // ì•ŒëžŒ
    @RequestMapping(value = "/alarm/history",  method = RequestMethod.GET) public String alarmHistory()  { return "/main_1/monitor/alarm_history.jsp"; }
    @RequestMapping(value = "/alarm/ranking",  method = RequestMethod.GET) public String alarmRanking()  { return "/main_1/monitor/alarm_ranking.jsp"; }

    // íŠ¸ë Œë“œ
    @RequestMapping(value = "/trend",          method = RequestMethod.GET) public String trend()         { return "/main_1/monitor/trend.jsp"; }

    // ë³´ì •í˜„í™©
    @RequestMapping(value = "/calib/status",   method = RequestMethod.GET) public String calibStatus()   { return "/main_1/facility/calib_status.jsp"; }

    // ì ê²€
    @RequestMapping(value = "/inspect/daily",        method = RequestMethod.GET) public String inspectDaily()       { return "/main_1/facility/daily_inspect.jsp"; }
    @RequestMapping(value = "/inspect/daily/tablet", method = RequestMethod.GET) public String inspectDailyTablet() { return "/main_1/facility/daily_inspect_tablet.jsp"; }
    @RequestMapping(value = "/inspect/fproof",       method = RequestMethod.GET) public String inspectFproof()      { return "/main_1/quality/fproof.jsp"; }

    // ìžìž¬
    @RequestMapping(value = "/spare/parts",    method = RequestMethod.GET) public String spareParts()    { return "/main_1/facility/spare_parts.jsp"; }

    // ì‹œìŠ¤í…œ
    @RequestMapping(value = "/user/manage",    method = RequestMethod.GET) public String userManage()    { return "/main_1/master/user_manage.jsp"; }
    @RequestMapping(value = "/user/permission",method = RequestMethod.GET) public String userPermission(){ return "/main_1/master/user_permission.jsp"; }

    // 설비보존관리 - BACKUP-DATA
    @RequestMapping(value = "/facility/backup", method = RequestMethod.GET) public String facilityBackup() { return "/main_1/facility/backup_data.jsp"; }
}


