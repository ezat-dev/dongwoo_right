package com.sample_pro.service.monitor;

import com.sample_pro.domain.NowWorkItem;
import java.util.List;

public interface NowWorkService {
    List<NowWorkItem> getListByPageNo(int pageNo);
}
