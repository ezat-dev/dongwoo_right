package com.sample_pro.service.facility;

import com.sample_pro.domain.ConsumableLedger;
import com.sample_pro.domain.ConsumableLedgerHistory;
import java.util.List;
import java.util.Map;

public interface ConsumableLedgerService {
    List<ConsumableLedger> getList();
    void save(ConsumableLedger item);
    void delete(Long id);

    List<ConsumableLedgerHistory> getHistoryList(Map<String, Object> params);
    void saveHistory(Map<String, Object> body);
    void deleteHistory(Long id);
}
