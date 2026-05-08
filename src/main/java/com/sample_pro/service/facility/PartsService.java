package com.sample_pro.service.facility;

import com.sample_pro.domain.Parts;
import com.sample_pro.domain.StockHistory;
import java.util.List;
import java.util.Map;

public interface PartsService {
    List<Parts>        getPartsList(Map<String, Object> params);
    void               saveParts(Map<String, Object> body);
    void               deleteParts(String partNo);

    List<StockHistory> getHistoryList(Map<String, Object> params);
    void               saveHistory(Map<String, Object> body);
    void               deleteHistory(int id);
}
