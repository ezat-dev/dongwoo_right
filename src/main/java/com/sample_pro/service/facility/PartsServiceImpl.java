package com.sample_pro.service.facility;

import com.sample_pro.dao.facility.PartsDao;
import com.sample_pro.domain.Parts;
import com.sample_pro.domain.StockHistory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class PartsServiceImpl implements PartsService {

    @Autowired
    private PartsDao partsDao;

    @Override
    public List<Parts> getPartsList(Map<String, Object> params) {
        return partsDao.selectPartsList(params);
    }

    @Override
    public void saveParts(Map<String, Object> body) {
        Parts p = new Parts();
        p.setPartNo(str(body.get("partNo")));
        p.setPartName(str(body.get("partName")));
        p.setCategory(str(body.get("category")));
        p.setEquipment(str(body.get("equipment")));
        p.setUnit(str(body.get("unit")));
        try { p.setMinStock(Integer.parseInt(body.get("minStock").toString())); } catch (Exception ignored) {}
        try { p.setReplaceCycle(Integer.parseInt(body.get("replaceCycle").toString())); } catch (Exception ignored) {}

        boolean isNew = (partsDao.selectPartsByNo(p.getPartNo()) == null);
        if (isNew) partsDao.insertParts(p);
        else       partsDao.updateParts(p);
    }

    @Override
    public void deleteParts(String partNo) {
        partsDao.deleteParts(partNo);
    }

    @Override
    public List<StockHistory> getHistoryList(Map<String, Object> params) {
        return partsDao.selectHistoryList(params);
    }

    @Override
    public void saveHistory(Map<String, Object> body) {
        StockHistory h = new StockHistory();
        h.setPartNo(str(body.get("partNo")));
        h.setType(str(body.get("type")));
        h.setEquipment(str(body.get("equipment")));
        h.setWorkDesc(str(body.get("workDesc")));
        h.setUserName(str(body.get("userName")));
        try { h.setQty(Integer.parseInt(body.get("qty").toString())); } catch (Exception ignored) {}
        partsDao.insertHistory(h);
    }

    @Override
    public void deleteHistory(int id) {
        partsDao.deleteHistory(id);
    }

    private String str(Object o) { return o == null ? "" : o.toString().trim(); }
}
