package com.sample_pro.dao.monitor;

import com.sample_pro.domain.NowWorkItem;
import java.util.List;

public interface NowWorkDao {
    List<NowWorkItem> selectByPageNo(int pageNo);
}
