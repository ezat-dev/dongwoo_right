package com.sample_pro.controller.monitor;

import com.sample_pro.domain.NowWorkItem;
import com.sample_pro.service.monitor.NowWorkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/monitor/nowWork")
public class NowWorkController {

    @Autowired
    private NowWorkService nowWorkService;

    @RequestMapping(value = "/list", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public ResponseEntity<List<NowWorkItem>> list(
            @RequestParam(value = "pageNo", defaultValue = "1") int pageNo) {
        List<NowWorkItem> items = nowWorkService.getListByPageNo(pageNo);
        return ResponseEntity.ok(items);
    }
}
