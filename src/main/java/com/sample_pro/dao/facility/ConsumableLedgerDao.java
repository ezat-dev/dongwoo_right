package com.sample_pro.dao.facility;

import com.sample_pro.domain.ConsumableLedger;
import com.sample_pro.domain.ConsumableLedgerHistory;
import java.util.List;
import java.util.Map;

public interface ConsumableLedgerDao {
    // 재고 마스터
    List<ConsumableLedger> selectList();
    ConsumableLedger selectById(Long id);
    void insert(ConsumableLedger item);
    void update(ConsumableLedger item);
    void updateStock(Map<String, Object> params);
    void delete(Long id);

    // 입출고 이력
    List<ConsumableLedgerHistory> selectHistoryList(Map<String, Object> params);
    void insertHistory(ConsumableLedgerHistory history);
    void deleteHistory(Long id);
}
