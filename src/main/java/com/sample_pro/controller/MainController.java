package com.sample_pro.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/main_1")
public class MainController {

    @RequestMapping(value = "/main",           method = RequestMethod.GET) public String main()          { return "/main_1/main.jsp"; }
    @RequestMapping(value = "/main/monitor",  method = RequestMethod.GET) public String mainMonitor()  { return "/main_1/main_monitor.jsp"; }
    @RequestMapping(value = "/main/monitor2", method = RequestMethod.GET) public String mainMonitor2() { return "/main_1/main_monitor2.jsp"; }
    @RequestMapping(value = "/login",          method = RequestMethod.GET) public String login()         { return "/main_1/login.jsp"; }

    // ì„¤ë¹„
    @RequestMapping(value = "/equip/monitor",  method = RequestMethod.GET) public String equipMonitor()  { return "/main_1/equip_monitor.jsp"; }
    @RequestMapping(value = "/equip/detail",   method = RequestMethod.GET) public String equipDetail()   { return "/main_1/equip_detail.jsp"; }

    // ì•ŒëžŒ
    @RequestMapping(value = "/alarm/history",  method = RequestMethod.GET) public String alarmHistory()  { return "/main_1/alarm_history.jsp"; }
    @RequestMapping(value = "/alarm/ranking",  method = RequestMethod.GET) public String alarmRanking()  { return "/main_1/alarm_ranking.jsp"; }

    // íŠ¸ë Œë“œ
    @RequestMapping(value = "/trend",          method = RequestMethod.GET) public String trend()         { return "/main_1/trend.jsp"; }

    // ë³´ì •í˜„í™©
    @RequestMapping(value = "/calib/status",   method = RequestMethod.GET) public String calibStatus()   { return "/main_1/calib_status.jsp"; }

    // ì ê²€
    @RequestMapping(value = "/inspect/daily",  method = RequestMethod.GET) public String inspectDaily()  { return "/main_1/daily_inspect.jsp"; }
    @RequestMapping(value = "/inspect/fproof", method = RequestMethod.GET) public String inspectFproof() { return "/main_1/fproof.jsp"; }

    // ìžìž¬
    @RequestMapping(value = "/spare/parts",    method = RequestMethod.GET) public String spareParts()    { return "/main_1/spare_parts.jsp"; }

    // ì‹œìŠ¤í…œ
    @RequestMapping(value = "/user/manage",    method = RequestMethod.GET) public String userManage()    { return "/main_1/user_manage.jsp"; }
    @RequestMapping(value = "/user/permission",method = RequestMethod.GET) public String userPermission(){ return "/main_1/user_permission.jsp"; }
}


