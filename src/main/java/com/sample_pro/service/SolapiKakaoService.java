package com.sample_pro.service;

import com.sample_pro.domain.EzInOutVisit;
import com.sample_pro.domain.SolapiSendResult;

public interface SolapiKakaoService {
    SolapiSendResult sendVisitNotification(EzInOutVisit visit);

    /** 경비 시스템 센서 감지 알림 */
    SolapiSendResult sendSecurityNotification(String mobileNo, String eventTime, String status);
}
