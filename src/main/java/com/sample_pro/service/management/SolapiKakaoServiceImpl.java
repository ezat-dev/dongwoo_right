package com.sample_pro.service.management;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.sample_pro.domain.EzInOutVisit;
import com.sample_pro.domain.SolapiSendResult;

@Service
public class SolapiKakaoServiceImpl implements SolapiKakaoService {

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Value("${solapi.enabled:true}")
    private boolean enabled;

    @Value("${solapi.api-key:}")
    private String apiKey;

    @Value("${solapi.api-secret:}")
    private String apiSecret;

    @Value("${solapi.pf-id:}")
    private String pfId;

    @Value("${solapi.template-id:}")
    private String templateId;

    @Value("${solapi.disable-sms:true}")
    private boolean disableSms;

    @Value("${solapi.from:}")
    private String from;

    @Value("${solapi.endpoint:https://api.solapi.com/messages/v4/send-many/detail}")
    private String endpoint;

    @Value("${solapi.button-name:}")
    private String buttonName;

    @Value("${solapi.button-url-mobile:}")
    private String buttonUrlMobile;

    @Value("${solapi.button-url-pc:}")
    private String buttonUrlPc;

    @Value("${solapi.security-template-id:}")
    private String securityTemplateId;

    private static final String DEFAULT_VISITOR_URL =
        "http://ezat.iptime.org:6695/sample_pro/ez_in_out/take";

    @Override
    public SolapiSendResult sendVisitNotification(EzInOutVisit visit) {
        SolapiSendResult result = new SolapiSendResult();
        System.out.println(">>> [KAKAO] ===============================================");
        System.out.println(">>> [KAKAO] Send notification start. visitId=" + visit.getVisitId());
        System.out.println(">>> [KAKAO] enabled=" + enabled);

        if (!enabled) {
            result.setSkipped(true);
            result.setMessage("SOLAPI disabled");
            System.out.println(">>> [KAKAO] SKIPPED: SOLAPI disabled");
            return result;
        }

        System.out.println(">>> [KAKAO] apiKey=" + (isBlank(apiKey) ? "EMPTY" : "***"));
        System.out.println(">>> [KAKAO] apiSecret=" + (isBlank(apiSecret) ? "EMPTY" : "***"));
        if (isBlank(apiKey) || isBlank(apiSecret)) {
            result.setSkipped(true);
            result.setMessage("SOLAPI api-key/api-secret missing");
            System.out.println(">>> [KAKAO] SKIPPED: api-key or api-secret missing");
            return result;
        }

        System.out.println(">>> [KAKAO] pfId=" + (isBlank(pfId) ? "EMPTY" : pfId));
        System.out.println(">>> [KAKAO] templateId=" + (isBlank(templateId) ? "EMPTY" : templateId));
        if (isBlank(pfId) || isBlank(templateId)) {
            result.setSkipped(true);
            result.setMessage("SOLAPI pfId/templateId missing");
            System.out.println(">>> [KAKAO] SKIPPED: pfId or templateId missing");
            return result;
        }

        String to = normalizePhone(visit.getTargetMobileNo());
        System.out.println(">>> [KAKAO] targetMobileNo=" + nvl(visit.getTargetMobileNo()));
        System.out.println(">>> [KAKAO] to (normalized)=" + to);
        if (isBlank(to)) {
            result.setSkipped(true);
            result.setMessage("recipient mobile_no missing");
            System.out.println(">>> [KAKAO] SKIPPED: recipient mobile_no missing");
            return result;
        }

        HttpURLConnection connection = null;
        try {
            String payload = objectMapper.writeValueAsString(buildRequestBody(visit, to));
            System.out.println(">>> [KAKAO] endpoint=" + endpoint);
            System.out.println(">>> [KAKAO] payload=" + payload);

            connection = (HttpURLConnection) new URL(endpoint).openConnection();
            connection.setRequestMethod("POST");
            connection.setConnectTimeout(10000);
            connection.setReadTimeout(10000);
            connection.setDoOutput(true);
            connection.setRequestProperty("Authorization", createAuthHeader(apiKey, apiSecret));
            connection.setRequestProperty("Content-Type", "application/json; charset=UTF-8");

            OutputStream outputStream = connection.getOutputStream();
            outputStream.write(payload.getBytes(StandardCharsets.UTF_8));
            outputStream.flush();
            outputStream.close();

            int statusCode = connection.getResponseCode();
            String responseBody = readBody(
                statusCode >= 200 && statusCode < 300
                    ? connection.getInputStream()
                    : connection.getErrorStream()
            );

            System.out.println(">>> [KAKAO] statusCode=" + statusCode);
            System.out.println(">>> [KAKAO] responseBody=" + responseBody);

            result.setStatusCode(statusCode);
            result.setResponseBody(responseBody);
            result.setSuccess(statusCode >= 200 && statusCode < 300);
            result.setMessage(result.isSuccess() ? "SOLAPI request success" : "SOLAPI request failed");
            System.out.println(">>> [KAKAO] result: success=" + result.isSuccess() + ", message=" + result.getMessage());
            System.out.println(">>> [KAKAO] ===============================================");
            return result;
        } catch (Exception e) {
            result.setSuccess(false);
            result.setMessage(e.getClass().getSimpleName() + ": " + e.getMessage());
            System.out.println(">>> [KAKAO] EXCEPTION: " + e.getClass().getSimpleName() + " - " + e.getMessage());
            e.printStackTrace();
            System.out.println(">>> [KAKAO] ===============================================");
            return result;
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }

    @Override
    public SolapiSendResult sendSecurityNotification(String mobileNo, String eventTime, String status) {
        SolapiSendResult result = new SolapiSendResult();
        System.out.println(">>> [SECURITY-KAKAO] 경비 알림 발송 시작. to=" + mobileNo);

        if (!enabled) {
            result.setSkipped(true);
            result.setMessage("SOLAPI disabled");
            return result;
        }
        if (isBlank(apiKey) || isBlank(apiSecret)) {
            result.setSkipped(true);
            result.setMessage("SOLAPI api-key/api-secret missing");
            return result;
        }
        if (isBlank(pfId) || isBlank(securityTemplateId)) {
            result.setSkipped(true);
            result.setMessage("SOLAPI pfId/securityTemplateId missing");
            System.out.println(">>> [SECURITY-KAKAO] pfId=" + pfId + ", securityTemplateId=" + securityTemplateId);
            return result;
        }

        String to = normalizePhone(mobileNo);
        if (isBlank(to)) {
            result.setSkipped(true);
            result.setMessage("recipient mobile_no missing");
            return result;
        }

        HttpURLConnection connection = null;
        try {
            Map<String, Object> variables = new LinkedHashMap<>();
            variables.put("#{eventTime}", nvl(eventTime));
            variables.put("#{status}",    nvl(status));

            Map<String, Object> kakaoOptions = new LinkedHashMap<>();
            kakaoOptions.put("pfId",       pfId);
            kakaoOptions.put("templateId", securityTemplateId);
            kakaoOptions.put("variables",  variables);
            kakaoOptions.put("disableSms", disableSms);

            Map<String, Object> message = new LinkedHashMap<>();
            message.put("to",           to);
            message.put("type",         "ATA");
            if (!isBlank(from)) {
                message.put("from", normalizePhone(from));
            }
            message.put("kakaoOptions", kakaoOptions);

            Map<String, Object> requestBody = new LinkedHashMap<>();
            requestBody.put("messages", new Object[]{ message });

            String payload = objectMapper.writeValueAsString(requestBody);
            System.out.println(">>> [SECURITY-KAKAO] payload=" + payload);

            connection = (HttpURLConnection) new URL(endpoint).openConnection();
            connection.setRequestMethod("POST");
            connection.setConnectTimeout(10000);
            connection.setReadTimeout(10000);
            connection.setDoOutput(true);
            connection.setRequestProperty("Authorization", createAuthHeader(apiKey, apiSecret));
            connection.setRequestProperty("Content-Type", "application/json; charset=UTF-8");

            OutputStream outputStream = connection.getOutputStream();
            outputStream.write(payload.getBytes(StandardCharsets.UTF_8));
            outputStream.flush();
            outputStream.close();

            int statusCode = connection.getResponseCode();
            String responseBody = readBody(
                statusCode >= 200 && statusCode < 300
                    ? connection.getInputStream()
                    : connection.getErrorStream()
            );

            System.out.println(">>> [SECURITY-KAKAO] statusCode=" + statusCode + ", response=" + responseBody);

            result.setStatusCode(statusCode);
            result.setResponseBody(responseBody);
            result.setSuccess(statusCode >= 200 && statusCode < 300);
            result.setMessage(result.isSuccess() ? "성공" : "실패");
            return result;
        } catch (Exception e) {
            result.setSuccess(false);
            result.setMessage(e.getClass().getSimpleName() + ": " + e.getMessage());
            System.err.println(">>> [SECURITY-KAKAO] 오류: " + e.getMessage());
            return result;
        } finally {
            if (connection != null) connection.disconnect();
        }
    }

    private Map<String, Object> buildRequestBody(EzInOutVisit visit, String to) {
        Map<String, Object> variables = new LinkedHashMap<>();
        variables.put("#{host_name}", nvl(visit.getTargetEmpName()));
        variables.put("#{visitor_name}", nvl(visit.getVisitorName()));
        variables.put("#{visitor_phone}", nvl(visit.getVisitorPhone()));
        variables.put("#{visit_reason}", buildVisitReasonText(visit));
        String visitorUrl = DEFAULT_VISITOR_URL + "?id=" + visit.getVisitId();
        variables.put("#{visitor_url}", visitorUrl);

        Map<String, Object> kakaoOptions = new LinkedHashMap<>();
        kakaoOptions.put("pfId", pfId);
        kakaoOptions.put("templateId", templateId);
        kakaoOptions.put("variables", variables);
        kakaoOptions.put("disableSms", disableSms);

        // 버튼은 템플릿과 불일치하므로 제거 (URL은 메시지 내용에 포함됨)
        // appendButtons(kakaoOptions, visit.getVisitId());

        Map<String, Object> message = new LinkedHashMap<>();
        message.put("to", to);
        message.put("type", "ATA");

        if (!isBlank(from)) {
            message.put("from", normalizePhone(from));
        }

        message.put("kakaoOptions", kakaoOptions);

        Map<String, Object> requestBody = new LinkedHashMap<>();
        requestBody.put("messages", new Object[] { message });
        return requestBody;
    }

    private String buildVisitReasonText(EzInOutVisit visit) {
        String reason = nvl(visit.getVisitReason());
        String etc = nvl(visit.getVisitReasonEtc());

        if ("기타".equals(reason) && !etc.isEmpty()) {
            return reason + " - " + etc;
        }
        return reason;
    }

    private void appendButtons(Map<String, Object> kakaoOptions, long visitId) {
        if (isBlank(buttonUrlMobile) && isBlank(buttonUrlPc)) {
            return;
        }

        Map<String, Object> button = new LinkedHashMap<>();
        button.put("buttonType", "WL");
        button.put("buttonName", "방문 페이지 열기");  // 고정값 사용

        String urlWithId = DEFAULT_VISITOR_URL + "?id=" + visitId;
        if (!isBlank(buttonUrlMobile)) {
            button.put("linkMo", urlWithId);
        }
        if (!isBlank(buttonUrlPc)) {
            button.put("linkPc", urlWithId);
        } else if (!isBlank(buttonUrlMobile)) {
            button.put("linkPc", urlWithId);
        }

        kakaoOptions.put("buttons", new Object[] { button });
    }

    private String createAuthHeader(String key, String secret) throws Exception {
        String dateTime = Instant.now().toString();
        String salt = UUID.randomUUID().toString().replace("-", "");
        String signature = generateSignature(secret, dateTime, salt);
        return "HMAC-SHA256 apiKey=" + key + ", date=" + dateTime + ", salt=" + salt + ", signature=" + signature;
    }

    private String generateSignature(String secret, String dateTime, String salt) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
        byte[] hash = mac.doFinal((dateTime + salt).getBytes(StandardCharsets.UTF_8));
        return toHex(hash);
    }

    private String toHex(byte[] bytes) {
        StringBuilder builder = new StringBuilder(bytes.length * 2);
        for (byte value : bytes) {
            builder.append(String.format("%02x", value));
        }
        return builder.toString();
    }

    private String readBody(InputStream inputStream) throws Exception {
        if (inputStream == null) {
            return "";
        }

        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        byte[] buffer = new byte[1024];
        int read;
        while ((read = inputStream.read(buffer)) != -1) {
            outputStream.write(buffer, 0, read);
        }
        inputStream.close();
        return new String(outputStream.toByteArray(), StandardCharsets.UTF_8);
    }

    private String normalizePhone(String phone) {
        return nvl(phone).replaceAll("[^0-9]", "");
    }

    private String nvl(String value) {
        return value == null ? "" : value.trim();
    }

    private boolean isBlank(String value) {
        return nvl(value).isEmpty();
    }
}