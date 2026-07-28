package com.sample_pro.service.facility;

import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.util.Map;

public interface InspectService {
    Map<String, Object> loadData(String equipId, String ym, HttpSession session);
    void addItem(Map<String, Object> params);
    void editItem(Map<String, Object> params);
    void updateItemInputType(int itemId, String inputType);
    void deleteItem(int itemId);
    void saveHeader(Map<String, Object> body);
    void saveCell(Map<String, Object> body);
    Workbook exportExcel(String equipId, String ym, HttpSession session);
    Workbook exportAllExcel(String ym, HttpSession session);
    int importExcel(String equipId, String ym, MultipartFile file);
    String uploadItemImage(int itemId, MultipartFile file) throws Exception;

    java.util.List<java.util.Map<String, Object>> getInspectorList();
    void addInspector(String name);
    void removeInspector(int idx);
}
