package com.sample_pro.dao.facility;

import com.sample_pro.domain.InspectHeader;
import com.sample_pro.domain.InspectItem;
import com.sample_pro.domain.InspectResult;

import java.util.List;
import java.util.Map;

public interface InspectDao {
    List<InspectItem>   selectItems(Map<String, Object> params);
    InspectItem         selectItemById(int itemId);
    InspectHeader       selectHeader(Map<String, Object> params);
    List<InspectResult> selectResults(Map<String, Object> params);

    void insertItem(InspectItem item);
    void updateItem(InspectItem item);
    void updateItemDel(InspectItem item);
    void deleteItem(int itemId);

    void upsertHeader(InspectHeader header);
    void upsertCell(InspectResult result);
    void updateItemImg(int itemId, String imgFile);
}
