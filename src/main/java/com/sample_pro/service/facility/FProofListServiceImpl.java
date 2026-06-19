package com.sample_pro.service.facility;

import com.sample_pro.dao.facility.FProofListDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("fProofListService")
public class FProofListServiceImpl implements FProofListService {

    @Autowired
    private FProofListDao fProofListDao;

    @Override
    public List<Map<String, Object>> getSessions(String from, String to) {
        Map<String, Object> params = new HashMap<>();
        params.put("from", from);
        params.put("to",   to);
        return fProofListDao.selectSessions(params);
    }

    @Override
    public List<Map<String, Object>> getDetail(String plcId, String start, String end) {
        Map<String, Object> params = new HashMap<>();
        params.put("plcId", plcId);
        params.put("start", start);
        params.put("end",   end);
        return fProofListDao.selectDetail(params);
    }
}
