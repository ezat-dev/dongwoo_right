<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<%
    String serverTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="theme-color" content="#0D1B3E">
    <title>EZ Automation - 출입 방문록</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&family=DM+Serif+Display&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary:      #C8102E;
            --primary-dark: #9E0B24;
            --navy:         #0D1B3E;
            --navy-mid:     #1A2F5A;
            --navy-light:   #2A4480;
            --accent:       #4A90D9;
            --bg:           #F4F6FB;
            --white:        #FFFFFF;
            --text-main:    #1A1D2E;
            --text-sub:     #5A6380;
            --text-muted:   #9AA3BE;
            --border:       #D8DDED;
            --shadow-sm:    0 2px 8px rgba(13,27,62,0.08);
            --shadow-md:    0 8px 32px rgba(13,27,62,0.13);
            --shadow-lg:    0 20px 60px rgba(13,27,62,0.18);
            --radius-sm:    10px;
            --radius-md:    18px;
            --radius-lg:    28px;
            --transition:   0.28s cubic-bezier(0.4, 0, 0.2, 1);
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; -webkit-tap-highlight-color: transparent; }
        html { scroll-behavior: smooth; }

        body {
            font-family: 'Noto Sans KR', sans-serif;
            background: var(--bg);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
            padding: 0;
            overflow-x: hidden;
        }

        body::before {
            content: '';
            position: fixed;
            top: 0; left: 0; right: 0;
            height: 340px;
            background: linear-gradient(145deg, var(--navy) 0%, var(--navy-mid) 55%, var(--navy-light) 100%);
            z-index: 0;
            clip-path: ellipse(120% 100% at 50% 0%);
        }

        body::after {
            content: '';
            position: fixed;
            top: 0; left: 0; right: 0;
            height: 340px;
            background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.025'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E") repeat;
            z-index: 0;
            clip-path: ellipse(120% 100% at 50% 0%);
        }

        .page-wrapper {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 480px;
            padding: 32px 16px 48px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0;
        }

        /* 헤더 */
        .header {
            width: 100%;
            text-align: center;
            padding: 16px 0 28px;
            color: var(--white);
        }

        .logo-wrap {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 18px;
        }

        .logo-svg-container {
            width: 72px;
            height: 72px;
            background: var(--white);
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 6px 24px rgba(0,0,0,0.22);
            padding: 8px;
            flex-shrink: 0;
        }

        .header-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(255,255,255,0.12);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 100px;
            padding: 5px 14px;
            font-size: 11px;
            font-weight: 500;
            color: rgba(255,255,255,0.85);
            letter-spacing: 0.04em;
            text-transform: uppercase;
            margin-bottom: 10px;
        }

        .header h1 {
            font-size: 26px;
            font-weight: 700;
            color: var(--white);
            letter-spacing: -0.02em;
            line-height: 1.25;
            margin-bottom: 8px;
        }

        .header p {
            font-size: 14px;
            color: rgba(255,255,255,0.68);
            font-weight: 400;
            line-height: 1.55;
        }

        /* 카드 */
        .card {
            width: 100%;
            background: var(--white);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            padding: 32px 28px 36px;
            animation: cardRise 0.55s cubic-bezier(0.22, 1, 0.36, 1) both;
        }

        @keyframes cardRise {
            from { opacity: 0; transform: translateY(28px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* 폼 */
        .form-group { margin-bottom: 20px; }
        .form-group:last-of-type { margin-bottom: 0; }

        .form-label {
            display: flex;
            align-items: center;
            gap: 7px;
            font-size: 13px;
            font-weight: 600;
            color: var(--navy);
            margin-bottom: 9px;
            letter-spacing: 0.01em;
        }

        .form-label .label-icon {
            width: 20px;
            height: 20px;
            background: linear-gradient(135deg, var(--navy-mid), var(--accent));
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .form-label .label-icon svg { width: 11px; height: 11px; }
        .form-label .required { color: var(--primary); font-size: 15px; line-height: 1; margin-left: 1px; }

        .form-input {
            width: 100%;
            height: 56px;
            padding: 0 18px;
            font-family: 'Noto Sans KR', sans-serif;
            font-size: 16px;
            font-weight: 400;
            color: var(--text-main);
            background: #F8F9FD;
            border: 2px solid var(--border);
            border-radius: var(--radius-md);
            outline: none;
            transition: border-color var(--transition), box-shadow var(--transition), background var(--transition);
            -webkit-appearance: none;
            appearance: none;
        }

        .form-input::placeholder { color: var(--text-muted); font-weight: 400; }
        .form-input:focus { border-color: var(--accent); background: var(--white); box-shadow: 0 0 0 4px rgba(74,144,217,0.12); }
        .form-input:disabled, .form-input[readonly] { background: #EEF1FB; color: var(--text-sub); cursor: not-allowed; border-color: var(--border); }
        .form-input.error { border-color: var(--primary); box-shadow: 0 0 0 4px rgba(200,16,46,0.10); }

        .error-msg { display: none; font-size: 12px; color: var(--primary); margin-top: 6px; padding-left: 4px; font-weight: 500; }
        .error-msg.show { display: block; }

        .divider { height: 1px; background: var(--border); margin: 24px 0; border-radius: 1px; }

        /* 동의 */
        .agree-wrap {
            background: linear-gradient(135deg, #F5F7FF 0%, #EEF1FB 100%);
            border: 1.5px solid var(--border);
            border-radius: var(--radius-md);
            padding: 18px 20px;
            transition: border-color var(--transition), background var(--transition);
        }
        .agree-wrap.agreed { border-color: rgba(74,144,217,0.4); background: linear-gradient(135deg, #F0F6FF 0%, #E8F0FF 100%); }
        .agree-label { display: flex; align-items: flex-start; gap: 14px; cursor: pointer; user-select: none; -webkit-user-select: none; }
        .agree-label input[type="checkbox"] { display: none; }
        .checkbox-custom {
            width: 26px; height: 26px; min-width: 26px;
            border: 2px solid var(--border); border-radius: 8px;
            background: var(--white); display: flex; align-items: center; justify-content: center;
            transition: all var(--transition); margin-top: 1px;
        }
        .checkbox-custom svg { opacity: 0; transform: scale(0.5); transition: all var(--transition); }
        .agree-label:has(input:checked) .checkbox-custom { background: linear-gradient(135deg, var(--navy-mid), var(--accent)); border-color: transparent; }
        .agree-label:has(input:checked) .checkbox-custom svg { opacity: 1; transform: scale(1); }
        .agree-text { font-size: 13.5px; line-height: 1.65; color: var(--text-sub); font-weight: 400; }
        .agree-text strong { color: var(--navy); font-weight: 600; }

        /* 제출 버튼 */
        .btn-submit {
            width: 100%;
            height: 62px;
            margin-top: 24px;
            background: linear-gradient(135deg, var(--navy) 0%, var(--navy-light) 100%);
            color: var(--white);
            font-family: 'Noto Sans KR', sans-serif;
            font-size: 17px;
            font-weight: 700;
            border: none;
            border-radius: var(--radius-md);
            cursor: pointer;
            letter-spacing: 0.02em;
            box-shadow: 0 6px 24px rgba(13,27,62,0.28);
            transition: all var(--transition);
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        .btn-submit::before { content: ''; position: absolute; inset: 0; background: linear-gradient(135deg, var(--navy-light), var(--accent)); opacity: 0; transition: opacity var(--transition); }
        .btn-submit:hover:not(:disabled)::before { opacity: 1; }
        .btn-submit:active:not(:disabled) { transform: scale(0.98); box-shadow: 0 3px 12px rgba(13,27,62,0.22); }
        .btn-submit span, .btn-submit svg { position: relative; z-index: 1; }
        .btn-submit:disabled { background: linear-gradient(135deg, #C5CEDD, #D8DDEA); color: rgba(255,255,255,0.55); cursor: not-allowed; box-shadow: none; }
        .btn-submit:disabled::before { display: none; }

        .ripple { position: absolute; border-radius: 50%; background: rgba(255,255,255,0.3); transform: scale(0); animation: ripple 0.5s linear; pointer-events: none; }
        @keyframes ripple { to { transform: scale(4); opacity: 0; } }

        .info-note {
            margin-top: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            font-size: 12px;
            color: var(--text-muted);
            text-align: center;
            line-height: 1.55;
        }
        .info-note svg { flex-shrink: 0; }

        /* ============================================
           직원 전용 버튼 영역 ← 핵심 추가
        ============================================ */
        .employee-zone {
            width: 100%;
            margin-top: 16px;
            animation: cardRise 0.55s 0.1s cubic-bezier(0.22, 1, 0.36, 1) both;
        }

        .employee-divider {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 12px;
        }

        .employee-divider::before,
        .employee-divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: rgba(255,255,255,0.18);
        }

        .employee-divider span {
            font-size: 11px;
            color: rgba(255,255,255,0.45);
            font-weight: 500;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .btn-employee {
            width: 100%;
            height: 58px;
            background: var(--white);
            border: 2px solid var(--border);
            border-radius: var(--radius-md);
            color: var(--navy);
            font-family: 'Noto Sans KR', sans-serif;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            letter-spacing: 0.01em;
            transition: all var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            text-decoration: none;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 16px rgba(13,27,62,0.12);
        }

        .btn-employee::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, var(--primary-dark), var(--primary));
            opacity: 0;
            transition: opacity var(--transition);
        }

        .btn-employee:hover {
            border-color: var(--primary);
            color: var(--white);
            box-shadow: 0 6px 24px rgba(200,16,46,0.30);
            transform: translateY(-2px);
        }

        .btn-employee:hover::before { opacity: 1; }

        .btn-employee:active {
            transform: scale(0.98) translateY(0);
            box-shadow: 0 2px 10px rgba(200,16,46,0.2);
        }

        .btn-employee span,
        .btn-employee svg { position: relative; z-index: 1; transition: color var(--transition); }

        .btn-employee .emp-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: var(--primary);
            border-radius: 6px;
            padding: 3px 8px;
            font-size: 10px;
            font-weight: 800;
            letter-spacing: 0.1em;
            color: var(--white);
            text-transform: uppercase;
            transition: all var(--transition);
            position: relative;
            z-index: 1;
        }

        .btn-employee:hover .emp-badge {
            background: rgba(255,255,255,0.25);
        }

        /* 푸터 */
        .footer {
            margin-top: 28px;
            text-align: center;
            color: rgba(255,255,255,0.42);
            font-size: 11.5px;
            font-weight: 400;
            letter-spacing: 0.02em;
            padding-bottom: 8px;
        }

        /* 성공 화면 */
        .success-screen {
            display: none;
            width: 100%;
            background: var(--white);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            padding: 48px 28px;
            text-align: center;
            animation: cardRise 0.55s cubic-bezier(0.22, 1, 0.36, 1) both;
        }
        .success-screen.show { display: block; }

        .success-icon {
            width: 80px; height: 80px;
            background: linear-gradient(135deg, #22C55E, #16A34A);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 8px 24px rgba(34,197,94,0.3);
            animation: popIn 0.45s 0.2s cubic-bezier(0.22, 1, 0.36, 1) both;
        }
        @keyframes popIn { from { transform: scale(0); opacity: 0; } to { transform: scale(1); opacity: 1; } }

        .success-screen h2 { font-size: 22px; font-weight: 700; color: var(--navy); margin-bottom: 10px; }
        .success-screen p { font-size: 14.5px; color: var(--text-sub); line-height: 1.65; }

        .success-detail { margin-top: 24px; background: #F5F7FF; border-radius: var(--radius-sm); padding: 16px 20px; text-align: left; }
        .success-detail-row { display: flex; justify-content: space-between; align-items: center; padding: 6px 0; border-bottom: 1px solid var(--border); font-size: 13.5px; }
        .success-detail-row:last-child { border-bottom: none; }
        .success-detail-row .label { color: var(--text-muted); font-weight: 500; }
        .success-detail-row .value { color: var(--text-main); font-weight: 600; }

        @media (min-width: 520px) {
            .page-wrapper { padding: 40px 24px 60px; }
            .header h1 { font-size: 30px; }
            .card { padding: 40px 36px 44px; }
        }
        @media (min-width: 768px) {
            body::before, body::after { height: 380px; }
        }
    </style>
</head>
<body>

<div class="page-wrapper">

    <!-- 헤더 -->
    <header class="header">
        <div class="logo-wrap">
            <div class="logo-svg-container">
                <img src="${pageContext.request.contextPath}/img/company_logo.png" alt="Company Logo" style="width:100%;height:100%;object-fit:contain;">
            </div>
        </div>

        <div class="header-badge">
            <svg width="11" height="13" viewBox="0 0 11 13" fill="none">
                <rect x="1" y="5.5" width="9" height="7" rx="1.5" stroke="white" stroke-width="1.3"/>
                <path d="M3 5.5V3.5C3 2.12 4.12 1 5.5 1C6.88 1 8 2.12 8 3.5V5.5" stroke="white" stroke-width="1.3" stroke-linecap="round"/>
                <circle cx="5.5" cy="9" r="1" fill="white"/>
            </svg>
            보안 출입 관리 시스템
        </div>

        <h1>(주)이지오토메이션 출입 방문록</h1>
        <p>방문 정보를 입력 후 확인 버튼을 눌러주세요.</p>
    </header>

    <!-- 폼 카드 -->
    <div class="card" id="formCard">

        <div class="form-group">
            <label class="form-label" for="visitTime">
                <span class="label-icon">
                    <svg viewBox="0 0 12 12" fill="none"><circle cx="6" cy="6" r="4.5" stroke="white" stroke-width="1.2"/><path d="M6 3.5V6L7.5 7.5" stroke="white" stroke-width="1.2" stroke-linecap="round"/></svg>
                </span>
                방문 일시
            </label>
            <input type="text" id="visitTime" class="form-input" readonly placeholder="날짜/시간 자동 입력">
        </div>

        <div class="form-group">
            <label class="form-label" for="visitorName">
                <span class="label-icon">
                    <svg viewBox="0 0 12 12" fill="none"><circle cx="6" cy="4" r="2.2" stroke="white" stroke-width="1.2"/><path d="M1.5 10.5C1.5 8.57 3.57 7 6 7C8.43 7 10.5 8.57 10.5 10.5" stroke="white" stroke-width="1.2" stroke-linecap="round"/></svg>
                </span>
                이름 <span class="required">*</span>
            </label>
            <input type="text" id="visitorName" class="form-input" placeholder="성함을 입력해 주세요" maxlength="30" autocomplete="name">
            <div class="error-msg" id="nameError">이름을 입력해 주세요.</div>
        </div>

        <div class="form-group">
            <label class="form-label" for="visitorPhone">
                <span class="label-icon">
                    <svg viewBox="0 0 12 12" fill="none"><rect x="2.5" y="1" width="7" height="10" rx="1.5" stroke="white" stroke-width="1.2"/><circle cx="6" cy="9.2" r="0.7" fill="white"/></svg>
                </span>
                전화번호 <span class="required">*</span>
            </label>
            <input type="tel" id="visitorPhone" class="form-input" placeholder="010-0000-0000" maxlength="13" autocomplete="tel" inputmode="numeric">
            <div class="error-msg" id="phoneError">올바른 전화번호를 입력해 주세요.</div>
        </div>

        <div class="form-group">
            <label class="form-label" for="targetEmployee">
                <span class="label-icon">
                    <svg viewBox="0 0 12 12" fill="none"><path d="M2 9.5C2 7.84 3.79 6.5 6 6.5C8.21 6.5 10 7.84 10 9.5" stroke="white" stroke-width="1.2" stroke-linecap="round"/><circle cx="6" cy="3.8" r="2" stroke="white" stroke-width="1.2"/></svg>
                </span>
                담당자 선택 <span class="required">*</span>
            </label>
            <select id="targetEmployee" class="form-input">
                <option value="">담당 직원을 선택해 주세요</option>
            </select>
            <div class="error-msg" id="targetEmployeeError">호출할 직원을 선택해 주세요.</div>
        </div>

        <div class="form-group">
            <label class="form-label" for="visitReason">
                <span class="label-icon">
                    <svg viewBox="0 0 12 12" fill="none"><path d="M2.2 3.5H9.8" stroke="white" stroke-width="1.2" stroke-linecap="round"/><path d="M2.2 6H9.8" stroke="white" stroke-width="1.2" stroke-linecap="round"/><path d="M2.2 8.5H6.6" stroke="white" stroke-width="1.2" stroke-linecap="round"/></svg>
                </span>
                방문 사유 <span class="required">*</span>
            </label>
<select id="visitReason" class="form-input">
    <option value="">사유를 선택해 주세요</option>

    <option value="business">1. 업무 협의</option>
    <option value="meeting">2. 미팅 / 회의</option>
    <option value="purchase">3. 구매 / 납품</option>
    <option value="maintenance">4. 장비 점검 / 유지보수</option>
    <option value="delivery">5. 물품 전달 / 택배</option>
    <option value="interview">6. 면접</option>
    <option value="visit">7. 일반 방문</option>

    <option value="other">기타</option>
</select>
            <div class="error-msg" id="visitReasonError">방문 사유를 선택해 주세요.</div>
        </div>

        <div class="form-group" id="visitReasonEtcWrap" style="display:none;">
            <label class="form-label" for="visitReasonEtc">
                <span class="label-icon">
                    <svg viewBox="0 0 12 12" fill="none"><path d="M2.5 2.5H9.5V9.5H2.5V2.5Z" stroke="white" stroke-width="1.2"/><path d="M4 4.2H8" stroke="white" stroke-width="1.2" stroke-linecap="round"/><path d="M4 6H8" stroke="white" stroke-width="1.2" stroke-linecap="round"/><path d="M4 7.8H6.6" stroke="white" stroke-width="1.2" stroke-linecap="round"/></svg>
                </span>
                기타 사유 <span class="required">*</span>
            </label>
            <input type="text" id="visitReasonEtc" class="form-input" maxlength="100" placeholder="기타 사유를 입력해 주세요">
            <div class="error-msg" id="visitReasonEtcError">기타 사유를 입력해 주세요.</div>
        </div>

        <div class="divider"></div>

        <div class="form-group">
            <label class="form-label">
                <span class="label-icon">
                    <svg viewBox="0 0 12 12" fill="none"><path d="M2 6L5 9L10 3" stroke="white" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
                </span>
                개인정보 및 보안 동의 <span class="required">*</span>
            </label>
            <div class="agree-wrap" id="agreeWrap">
                <label class="agree-label">
                    <input type="checkbox" id="agreeCheck" onchange="onAgreeChange()">
                    <div class="checkbox-custom">
                        <svg width="14" height="11" viewBox="0 0 14 11" fill="none">
                            <path d="M1.5 5.5L5.5 9.5L12.5 1.5" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                    </div>
                    <span class="agree-text">
                        <strong>(주)이지오토메이션 내에서 본 내용 및 촬영한 사진은 외부에 유출하거나 공유할 수 없으며,</strong>
                        이를 준수하는 것에 동의합니다.
                    </span>
                </label>
            </div>
        </div>

        <button type="button" class="btn-submit" id="submitBtn" disabled onclick="handleSubmit(event)">
            <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                <rect x="3" y="2" width="14" height="16" rx="2" stroke="white" stroke-width="1.5"/>
                <path d="M7 7H13M7 10H13M7 13H10" stroke="white" stroke-width="1.5" stroke-linecap="round"/>
            </svg>
            <span>방문 등록 확인</span>
        </button>

        <div class="info-note">
            <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
                <circle cx="7" cy="7" r="5.5" stroke="#9AA3BE" stroke-width="1.2"/>
                <path d="M7 6V10M7 4.5V4.6" stroke="#9AA3BE" stroke-width="1.3" stroke-linecap="round"/>
            </svg>
            입력하신 정보는 방문 기록 확인 용도로만 사용됩니다.
        </div>

    </div><!-- /.card -->

    <!-- ========================================
         직원 전용 이동 버튼 (카드 아래)
    ========================================= -->
    <div class="employee-zone" id="employeeZone">
        <div class="employee-divider">
            <span>직원이신가요?</span>
        </div>
        <a href="<%=request.getContextPath()%>/ez_in_out/pin" class="btn-employee" id="btnEmployeePin">
            <svg width="17" height="17" viewBox="0 0 17 17" fill="none">
                <rect x="2.5" y="7.5" width="12" height="8" rx="2" stroke="currentColor" stroke-width="1.5"/>
                <path d="M5 7.5V5C5 3.07 6.57 1.5 8.5 1.5C10.43 1.5 12 3.07 12 5V7.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                <circle cx="8.5" cy="11.5" r="1.2" fill="currentColor"/>
                <path d="M8.5 12.7V14" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/>
            </svg>
            <span>직원 전용 입장</span>
            <span class="emp-badge">PIN</span>
        </a>
    </div>

    <!-- 성공 화면 -->
    <div class="success-screen" id="successScreen">
        <div class="success-icon">
            <svg width="38" height="38" viewBox="0 0 38 38" fill="none">
                <path d="M8 19L15.5 26.5L30 11.5" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
        </div>
        <h2>방문 등록이 완료되었습니다</h2>
        <p>방문해 주셔서 감사합니다.<br>담당자가 곧 안내해 드릴 예정입니다.</p>
        <div class="success-detail" id="successDetail"></div>
        <div class="info-note" style="margin-top:16px;">
            <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
                <circle cx="7" cy="7" r="5.5" stroke="#9AA3BE" stroke-width="1.2"/>
                <path d="M7 6V10M7 4.5V4.6" stroke="#9AA3BE" stroke-width="1.3" stroke-linecap="round"/>
            </svg>
            입력하신 정보는 방문 기록 확인 용도로만 사용됩니다.
        </div>
    </div>

    <footer class="footer">
        &copy; 2026 EZ Automation. All rights reserved.
    </footer>

</div><!-- /.page-wrapper -->

<script>
    var contextPath = '<%=request.getContextPath()%>';
    var employeeList = [];

    (function setVisitTime() {
        var now = new Date();
        var y  = now.getFullYear();
        var mo = String(now.getMonth() + 1).padStart(2, '0');
        var d  = String(now.getDate()).padStart(2, '0');
        var h  = String(now.getHours()).padStart(2, '0');
        var mi = String(now.getMinutes()).padStart(2, '0');
        document.getElementById('visitTime').value = y + '-' + mo + '-' + d + ' ' + h + ':' + mi;
    })();

    loadEmployeeList();
    bindVisitReasonChange();

    document.getElementById('visitorPhone').addEventListener('input', function(e) {
        var val = e.target.value.replace(/\D/g, '');
        var formatted = '';
        if (val.length <= 3) {
            formatted = val;
        } else if (val.length <= 7) {
            formatted = val.slice(0,3) + '-' + val.slice(3);
        } else if (val.length <= 11) {
            formatted = val.slice(0,3) + '-' + val.slice(3, val.length <= 10 ? 6 : 7) + '-' + val.slice(val.length <= 10 ? 6 : 7);
        } else {
            formatted = val.slice(0,3) + '-' + val.slice(3,7) + '-' + val.slice(7,11);
        }
        e.target.value = formatted;
    });

    function loadEmployeeList() {
        fetch(contextPath + '/ez_in_out/employee/list', {
            method: 'GET',
            headers: { 'Accept': 'application/json' }
        })
        .then(function(response) {
            if (!response.ok) throw new Error('직원 목록을 불러오지 못했습니다.');
            return response.json();
        })
        .then(function(result) {
            if (!result || !result.success) throw new Error(result && result.error ? result.error : '직원 목록을 불러오지 못했습니다.');
            employeeList = Array.isArray(result.data) ? result.data : [];
            renderEmployeeOptions(employeeList);
        })
        .catch(function(error) { alert(error.message || '직원 목록을 불러오지 못했습니다.'); });
    }

    function renderEmployeeOptions(list) {
        var select = document.getElementById('targetEmployee');
        select.innerHTML = '<option value="">직원을 선택해 주세요</option>';
        list.forEach(function(employee) {
            var option = document.createElement('option');
            option.value = employee.empId || '';
            option.textContent = formatEmployeeLabel(employee);
            option.dataset.empId      = employee.empId || '';
            option.dataset.deptName   = employee.deptName || '';
            option.dataset.empName    = employee.empName || '';
            option.dataset.titleName  = employee.titleName || '';
            option.dataset.mobileNo   = employee.mobileNo || '';
            option.dataset.directNo   = employee.directNo || '';
            select.appendChild(option);
        });
    }

    function maskPhoneLast4(phone) {
        if (!phone) return '';
        try {
            return phone.replace(/(\d{4})(?!.*\d)/, '****');
        } catch (e) {
            return phone;
        }
    }

    function formatEmployeeLabel(employee) {
        var parts = [];
        if (employee.deptName)  parts.push(employee.deptName);
        if (employee.empName)   parts.push(employee.empName);
        if (employee.titleName) parts.push(employee.titleName);
        var label = parts.join(' / ');
        if (employee.mobileNo)  label += ' (' + maskPhoneLast4(employee.mobileNo) + ')';
        return label;
    }

    function bindVisitReasonChange() {
        var reasonSelect = document.getElementById('visitReason');
        reasonSelect.addEventListener('change', toggleVisitReasonEtc);
        toggleVisitReasonEtc();
    }

    function toggleVisitReasonEtc() {
        var reasonSelect = document.getElementById('visitReason');
        var etcWrap  = document.getElementById('visitReasonEtcWrap');
        var etcInput = document.getElementById('visitReasonEtc');
        var etcError = document.getElementById('visitReasonEtcError');
        var isEtc = reasonSelect.value === 'other';
        etcWrap.style.display = isEtc ? 'block' : 'none';
        if (!isEtc) {
            etcInput.value = '';
            etcInput.classList.remove('error');
            etcError.classList.remove('show');
        }
    }

    function onAgreeChange() {
        var checked = document.getElementById('agreeCheck').checked;
        document.getElementById('submitBtn').disabled = !checked;
        document.getElementById('agreeWrap').classList.toggle('agreed', checked);
    }

    function handleSubmit(event) {
        var btn = document.getElementById('submitBtn');
        var ripple = document.createElement('span');
        ripple.className = 'ripple';
        var rect = btn.getBoundingClientRect();
        var size = Math.max(rect.width, rect.height);
        ripple.style.width = ripple.style.height = size + 'px';
        ripple.style.left = (event.clientX - rect.left - size / 2) + 'px';
        ripple.style.top  = (event.clientY - rect.top  - size / 2) + 'px';
        btn.appendChild(ripple);
        setTimeout(function() { ripple.remove(); }, 600);

        var valid = true;

        var nameInput = document.getElementById('visitorName');
        var name = nameInput.value.trim();
        if (!name) { nameInput.classList.add('error'); document.getElementById('nameError').classList.add('show'); valid = false; }
        else { nameInput.classList.remove('error'); document.getElementById('nameError').classList.remove('show'); }

        var phoneInput = document.getElementById('visitorPhone');
        var phone = phoneInput.value.trim();
        var phoneRegex = /^0\d{1,2}-\d{3,4}-\d{4}$/;
        if (!phone) {
            phoneInput.classList.add('error');
            document.getElementById('phoneError').textContent = '전화번호를 입력해 주세요.';
            document.getElementById('phoneError').classList.add('show'); valid = false;
        } else if (!phoneRegex.test(phone)) {
            phoneInput.classList.add('error');
            document.getElementById('phoneError').textContent = '올바른 형식으로 입력해 주세요. (예: 010-1234-5678)';
            document.getElementById('phoneError').classList.add('show'); valid = false;
        } else { phoneInput.classList.remove('error'); document.getElementById('phoneError').classList.remove('show'); }

        var targetEmployee = document.getElementById('targetEmployee');
        if (!targetEmployee.value) { targetEmployee.classList.add('error'); document.getElementById('targetEmployeeError').classList.add('show'); valid = false; }
        else { targetEmployee.classList.remove('error'); document.getElementById('targetEmployeeError').classList.remove('show'); }

        var visitReason    = document.getElementById('visitReason');
        var visitReasonEtc = document.getElementById('visitReasonEtc');
        var selectedReason = visitReason.value;
        var reasonEtcText  = visitReasonEtc.value.trim();

        if (!selectedReason) { visitReason.classList.add('error'); document.getElementById('visitReasonError').classList.add('show'); valid = false; }
        else { visitReason.classList.remove('error'); document.getElementById('visitReasonError').classList.remove('show'); }

        if (selectedReason === 'other' && !reasonEtcText) { visitReasonEtc.classList.add('error'); document.getElementById('visitReasonEtcError').classList.add('show'); valid = false; }
        else { visitReasonEtc.classList.remove('error'); document.getElementById('visitReasonEtcError').classList.remove('show'); }

        if (!valid) return;

        var visitTime      = document.getElementById('visitTime').value;
        var selectedOption = targetEmployee.options[targetEmployee.selectedIndex];
        console.log('[DEBUG] selected mobileNo=', selectedOption ? selectedOption.dataset.mobileNo : '');
        console.log('[DEBUG] selected empId=', selectedOption ? selectedOption.dataset.empId : '');
        console.log('[DEBUG] selected empName=', selectedOption ? selectedOption.dataset.empName : '');
        btn.disabled = true;

        fetch(contextPath + '/ez_in_out/visit/save', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
            body: JSON.stringify({
                visitTime:       visitTime,
                visitorName:     name,
                visitorPhone:    phone,
                targetEmpId:     selectedOption ? selectedOption.dataset.empId     || '' : '',
                targetDeptName:  selectedOption ? selectedOption.dataset.deptName  || '' : '',
                targetEmpName:   selectedOption ? selectedOption.dataset.empName   || '' : '',
                targetTitleName: selectedOption ? selectedOption.dataset.titleName || '' : '',
                targetMobileNo:  selectedOption ? selectedOption.dataset.mobileNo  || '' : '',
                targetDirectNo:  selectedOption ? selectedOption.dataset.directNo  || '' : '',
                visitReason:     selectedReason,
                visitReasonEtc:  selectedReason === 'other' ? reasonEtcText : ''
            })
        })
        .then(function(response) {
            if (!response.ok) throw new Error('서버 통신 중 오류가 발생했습니다.');
            return response.json();
        })
        .then(function(result) {
            if (!result || !result.success) throw new Error(result && result.error ? result.error : '방문 등록 중 오류가 발생했습니다.');
            var saved = result.data || {};
            var detail = document.getElementById('successDetail');
            detail.innerHTML =
                row('방문 일시', saved.visitTime || visitTime) +
                row('성함',      saved.visitorName || name) +
                row('연락처',    saved.visitorPhone || phone) +
                row('호출 대상', buildTargetSummary(saved, selectedOption)) +
                row('방문 사유', buildReasonSummary(saved, selectedReason, reasonEtcText)) +
                row('등록 번호', '#' + (saved.visitId || ''));

            document.getElementById('formCard').style.display    = 'none';
            document.getElementById('employeeZone').style.display = 'none';
            document.getElementById('successScreen').classList.add('show');
            window.scrollTo({ top: 0, behavior: 'smooth' });
        })
        .catch(function(error) {
            alert(error.message || '방문 등록 중 오류가 발생했습니다.');
            btn.disabled = !document.getElementById('agreeCheck').checked;
        });
    }

    function row(label, value) {
        return '<div class="success-detail-row">' +
               '<span class="label">' + label + '</span>' +
               '<span class="value">' + escapeHtml(String(value || '')) + '</span>' +
               '</div>';
    }

    function escapeHtml(str) {
        return str.replace(/[&<>"']/g, function(c) {
            return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c];
        });
    }

    function buildTargetSummary(saved, selectedOption) {
        var parts = [];
        var d = saved.targetDeptName  || (selectedOption ? selectedOption.dataset.deptName  || '' : '');
        var n = saved.targetEmpName   || (selectedOption ? selectedOption.dataset.empName   || '' : '');
        var t = saved.targetTitleName || (selectedOption ? selectedOption.dataset.titleName || '' : '');
        if (d) parts.push(d);
        if (n) parts.push(n);
        if (t) parts.push(t);
        return parts.join(' / ');
    }

    function buildReasonSummary(saved, selectedReason, reasonEtcText) {
        var reasonMap = { simple_visit: '단순 방문', purchase: '구매', ex1: 'ex1', ex4: 'ex4', other: '기타' };
        var reason = saved.visitReason || reasonMap[selectedReason] || selectedReason || '';
        var etc    = saved.visitReasonEtc || reasonEtcText || '';
        return (reason === '기타' && etc) ? reason + ' - ' + etc : reason;
    }

    ['visitorName','visitorPhone','targetEmployee','visitReason','visitReasonEtc'].forEach(function(id) {
        document.getElementById(id).addEventListener('focus', function() {
            this.classList.remove('error');
            var map = { visitorName: 'nameError', visitorPhone: 'phoneError', targetEmployee: 'targetEmployeeError', visitReason: 'visitReasonError', visitReasonEtc: 'visitReasonEtcError' };
            document.getElementById(map[id]).classList.remove('show');
        });
    });
</script>

</body>
</html>
