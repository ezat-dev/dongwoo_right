package com.sample_pro.service.facility;

import com.sample_pro.domain.AlarmTag;

import java.util.List;

public interface FProofService {
    List<AlarmTag> getAllTags(String plcId);
    List<Integer>  getSelectedTagIds(String plcId);
    void           select(int tagId, String plcId);
    void           deselect(int tagId, String plcId);
}
