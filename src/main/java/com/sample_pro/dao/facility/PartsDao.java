package com.sample_pro.dao.facility;

import com.sample_pro.domain.Parts;
import com.sample_pro.domain.StockHistory;
import java.util.List;
import java.util.Map;

public interface PartsDao {
    // 부품 마스터
    List<Parts> selectPartsList(Map<String, Object> params);
    Parts       selectPartsByNo(String partNo);
    void        insertParts(Parts p);
    void        updateParts(Parts p);
    void        deleteParts(String partNo);

    // 재고 이력
    List<StockHistory> selectHistoryList(Map<String, Object> params);
    void               insertHistory(StockHistory h);
    void               deleteHistory(int id);
}
