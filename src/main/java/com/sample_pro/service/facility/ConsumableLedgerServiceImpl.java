package com.sample_pro.service.facility;

import com.sample_pro.dao.facility.ConsumableLedgerDao;
import com.sample_pro.domain.ConsumableLedger;
import com.sample_pro.domain.ConsumableLedgerHistory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ConsumableLedgerServiceImpl implements ConsumableLedgerService {

    @Autowired
    private ConsumableLedgerDao consumableLedgerDao;

    @Override
    public List<ConsumableLedger> getList() {
        return consumableLedgerDao.selectList();
    }

    @Override
    public void save(ConsumableLedger item) {
        if (item.getId() == null || item.getId() == 0) {
            consumableLedgerDao.insert(item);
        } else {
            consumableLedgerDao.update(item);
        }
    }

    @Override
    public void delete(Long id) {
        consumableLedgerDao.delete(id);
    }

    @Override
    public List<ConsumableLedgerHistory> getHistoryList(Map<String, Object> params) {
        return consumableLedgerDao.selectHistoryList(params);
    }

    @Override
    public void saveHistory(Map<String, Object> body) {
        ConsumableLedgerHistory h = new ConsumableLedgerHistory();
        h.setLedgerId(Long.parseLong(body.get("ledgerId").toString()));
        h.setType(str(body.get("type")));
        h.setQty(str(body.get("qty")));
        h.setRemark(str(body.get("remark")));
        h.setUserName(str(body.get("userName")));
        consumableLedgerDao.insertHistory(h);

        // 숫자 수량인 경우 보유재고 자동 업데이트
        tryUpdateStock(h.getLedgerId(), h.getType(), h.getQty());
    }

    @Override
    public void deleteHistory(Long id) {
        consumableLedgerDao.deleteHistory(id);
    }

    /* 보유재고가 숫자인 경우 IN/OUT 반영 (null·빈값은 0으로 처리) */
    private void tryUpdateStock(Long ledgerId, String type, String qty) {
        try {
            ConsumableLedger ledger = consumableLedgerDao.selectById(ledgerId);
            if (ledger == null) return;

            String currentStr = ledger.getStockQty();
            if (currentStr == null || currentStr.trim().isEmpty()) currentStr = "0";

            double current = Double.parseDouble(currentStr.trim());
            double delta   = Double.parseDouble(qty.trim());
            double newVal  = "IN".equals(type) ? current + delta : current - delta;

            String newStr = (newVal == Math.floor(newVal))
                    ? String.valueOf((long) newVal)
                    : String.valueOf(newVal);

            Map<String, Object> p = new HashMap<>();
            p.put("id",       ledgerId);
            p.put("stockQty", newStr);
            consumableLedgerDao.updateStock(p);
        } catch (Exception ignored) {
            // 비숫자 수량 (GAS 등) → 자동 반영 생략
        }
    }

    private String str(Object o) { return o == null ? "" : o.toString().trim(); }
}
