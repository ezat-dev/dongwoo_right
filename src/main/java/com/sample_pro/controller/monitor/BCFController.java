package com.sample_pro.controller.monitor;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/main_1/BCF")
public class BCFController {

    @RequestMapping(value = "/BCF_1",  method = RequestMethod.GET) public String bcf1()  { return "/main_1/monitor/BCF/BCF_1.jsp";  }
    @RequestMapping(value = "/BCF_2",  method = RequestMethod.GET) public String bcf2()  { return "/main_1/monitor/BCF/BCF_2.jsp";  }
    @RequestMapping(value = "/BCF_3",  method = RequestMethod.GET) public String bcf3()  { return "/main_1/monitor/BCF/BCF_3.jsp";  }
    @RequestMapping(value = "/BCF_4",  method = RequestMethod.GET) public String bcf4()  { return "/main_1/monitor/BCF/BCF_4.jsp";  }
    @RequestMapping(value = "/BCF_5",  method = RequestMethod.GET) public String bcf5()  { return "/main_1/monitor/BCF/BCF_5.jsp";  }
    @RequestMapping(value = "/BCF_6",  method = RequestMethod.GET) public String bcf6()  { return "/main_1/monitor/BCF/BCF_6.jsp";  }
    @RequestMapping(value = "/BCF_7",  method = RequestMethod.GET) public String bcf7()  { return "/main_1/monitor/BCF/BCF_7.jsp";  }
    @RequestMapping(value = "/BCF_8",  method = RequestMethod.GET) public String bcf8()  { return "/main_1/monitor/BCF/BCF_8.jsp";  }
    @RequestMapping(value = "/BCF_9",  method = RequestMethod.GET) public String bcf9()  { return "/main_1/monitor/BCF/BCF_9.jsp";  }
    @RequestMapping(value = "/BCF_10", method = RequestMethod.GET) public String bcf10() { return "/main_1/monitor/BCF/BCF_10.jsp"; }
    @RequestMapping(value = "/BCF_11", method = RequestMethod.GET) public String bcf11() { return "/main_1/monitor/BCF/BCF_11.jsp"; }
    @RequestMapping(value = "/BCF_12", method = RequestMethod.GET) public String bcf12() { return "/main_1/monitor/BCF/BCF_12.jsp"; }
}
