<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="theme-color" content="#0D1B3E">
    <title>EZ Automation - 직원 전용 인증</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">

    <style>
        /* ============================================
           CSS 변수 & 리셋
        ============================================ */
        :root {
            --primary:       #C8102E;
            --primary-dark:  #9E0B24;
            --navy:          #0D1B3E;
            --navy-mid:      #1A2F5A;
            --navy-light:    #2A4480;
            --accent:        #4A90D9;
            --accent-glow:   rgba(74,144,217,0.25);
            --bg:            #F4F6FB;
            --white:         #FFFFFF;
            --text-main:     #1A1D2E;
            --text-sub:      #5A6380;
            --text-muted:    #9AA3BE;
            --border:        #D8DDED;
            --shadow-sm:     0 2px 8px rgba(13,27,62,0.08);
            --shadow-md:     0 8px 32px rgba(13,27,62,0.13);
            --shadow-lg:     0 20px 60px rgba(13,27,62,0.18);
            --radius-sm:     10px;
            --radius-md:     18px;
            --radius-lg:     28px;
            --transition:    0.28s cubic-bezier(0.4, 0, 0.2, 1);
        }

        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            -webkit-tap-highlight-color: transparent;
        }

        html { scroll-behavior: smooth; }

        body {
            font-family: 'Noto Sans KR', sans-serif;
            background: var(--bg);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 20px 16px;
            overflow-x: hidden;
        }

        /* 배경 장식 */
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

        /* ============================================
           페이지 래퍼
        ============================================ */
        .page-wrapper {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 400px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0;
        }

        /* ============================================
           헤더
        ============================================ */
        .header {
            width: 100%;
            text-align: center;
            padding: 0 0 28px;
            color: var(--white);
        }

        .logo-wrap {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 18px;
        }

        .logo-svg-container {
            width: 68px;
            height: 68px;
            background: var(--white);
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 6px 24px rgba(0,0,0,0.22);
            padding: 8px;
        }

        .header-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(200,16,46,0.22);
            border: 1px solid rgba(200,16,46,0.4);
            border-radius: 100px;
            padding: 5px 14px;
            font-size: 11px;
            font-weight: 600;
            color: rgba(255,255,255,0.9);
            letter-spacing: 0.06em;
            text-transform: uppercase;
            margin-bottom: 12px;
        }

        .header h1 {
            font-size: 22px;
            font-weight: 700;
            color: var(--white);
            letter-spacing: -0.02em;
            margin-bottom: 6px;
        }

        .header p {
            font-size: 13.5px;
            color: rgba(255,255,255,0.6);
            font-weight: 400;
        }

        /* ============================================
           PIN 카드
        ============================================ */
        .pin-card {
            width: 100%;
            background: var(--white);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            padding: 36px 28px 40px;
            animation: cardRise 0.55s cubic-bezier(0.22, 1, 0.36, 1) both;
        }

        @keyframes cardRise {
            from { opacity: 0; transform: translateY(28px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ============================================
           아이콘 & 타이틀
        ============================================ */
        .pin-icon-wrap {
            display: flex;
            justify-content: center;
            margin-bottom: 8px;
        }

        .pin-icon {
            width: 62px;
            height: 62px;
            background: linear-gradient(135deg, var(--navy-mid) 0%, var(--navy-light) 100%);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 8px 24px rgba(13,27,62,0.28);
            position: relative;
        }

        .pin-icon::after {
            content: '';
            position: absolute;
            inset: 0;
            border-radius: 20px;
            border: 1.5px solid rgba(74,144,217,0.3);
        }

        .pin-title {
            text-align: center;
            margin-bottom: 28px;
        }

        .pin-title h2 {
            font-size: 18px;
            font-weight: 700;
            color: var(--navy);
            letter-spacing: -0.01em;
            margin-bottom: 5px;
        }

        .pin-title p {
            font-size: 13px;
            color: var(--text-muted);
            font-weight: 400;
        }

        /* ============================================
           PIN 인풋 박스 (4자리 점)
        ============================================ */
        .pin-display {
            display: flex;
            justify-content: center;
            gap: 16px;
            margin-bottom: 10px;
        }

        .pin-dot {
            width: 52px;
            height: 60px;
            background: #F4F6FB;
            border: 2px solid var(--border);
            border-radius: var(--radius-sm);
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all var(--transition);
            position: relative;
            overflow: hidden;
        }

        .pin-dot.active {
            border-color: var(--accent);
            background: var(--white);
            box-shadow: 0 0 0 4px var(--accent-glow);
        }

        .pin-dot.filled {
            border-color: var(--navy-mid);
            background: var(--white);
        }

        .pin-dot.filled::after {
            content: '';
            width: 16px;
            height: 16px;
            background: linear-gradient(135deg, var(--navy-mid), var(--accent));
            border-radius: 50%;
            animation: dotPop 0.2s cubic-bezier(0.34, 1.56, 0.64, 1) both;
        }

        @keyframes dotPop {
            from { transform: scale(0); opacity: 0; }
            to   { transform: scale(1); opacity: 1; }
        }

        .pin-dot.error-shake {
            border-color: var(--primary);
            background: rgba(200,16,46,0.04);
            animation: shake 0.4s cubic-bezier(0.36, 0.07, 0.19, 0.97) both;
        }

        @keyframes shake {
            10%, 90%  { transform: translateX(-2px); }
            20%, 80%  { transform: translateX(3px); }
            30%, 50%, 70% { transform: translateX(-4px); }
            40%, 60%  { transform: translateX(4px); }
        }

        /* 숨겨진 실제 input */
        .pin-input-hidden {
            position: absolute;
            opacity: 0;
            pointer-events: none;
            width: 1px;
            height: 1px;
        }

        /* 오류 메시지 */
        .error-msg {
            text-align: center;
            font-size: 12.5px;
            color: var(--primary);
            font-weight: 600;
            min-height: 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
            opacity: 0;
            transform: translateY(-4px);
            transition: all 0.2s ease;
        }

        .error-msg.show {
            opacity: 1;
            transform: translateY(0);
        }

        .attempt-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 18px;
            height: 18px;
            background: var(--primary);
            color: white;
            border-radius: 50%;
            font-size: 10px;
            font-weight: 700;
        }

        /* ============================================
           숫자 키패드
        ============================================ */
        .keypad {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
        }

        .key {
            height: 62px;
            background: #F4F6FB;
            border: 1.5px solid var(--border);
            border-radius: var(--radius-sm);
            font-family: 'DM Mono', monospace;
            font-size: 20px;
            font-weight: 500;
            color: var(--navy);
            cursor: pointer;
            transition: all 0.15s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            user-select: none;
            -webkit-user-select: none;
            position: relative;
            overflow: hidden;
        }

        .key:hover {
            background: var(--white);
            border-color: var(--accent);
            color: var(--accent);
            box-shadow: 0 4px 12px rgba(74,144,217,0.15);
            transform: translateY(-1px);
        }

        .key:active {
            transform: scale(0.94) translateY(0);
            background: linear-gradient(135deg, var(--navy-mid), var(--accent));
            border-color: transparent;
            color: var(--white);
            box-shadow: 0 2px 8px rgba(13,27,62,0.2);
        }

        /* 0 키 - 중앙 */
        .key.key-zero {
            grid-column: 2;
        }

        /* 빈 공간 */
        .key-spacer {
            visibility: hidden;
        }

        /* 백스페이스 키 */
        .key.key-back {
            background: #FFF0F3;
            border-color: rgba(200,16,46,0.18);
            color: var(--primary);
        }

        .key.key-back:hover {
            background: #FFE0E5;
            border-color: rgba(200,16,46,0.35);
            color: var(--primary-dark);
            box-shadow: 0 4px 12px rgba(200,16,46,0.12);
        }

        .key.key-back:active {
            background: var(--primary);
            border-color: transparent;
            color: var(--white);
        }

        /* ============================================
           확인 버튼
        ============================================ */
        .btn-confirm {
            width: 100%;
            height: 58px;
            margin-top: 16px;
            background: linear-gradient(135deg, var(--navy) 0%, var(--navy-light) 100%);
            color: var(--white);
            font-family: 'Noto Sans KR', sans-serif;
            font-size: 16px;
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
            gap: 8px;
        }

        .btn-confirm::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, var(--navy-light), var(--accent));
            opacity: 0;
            transition: opacity var(--transition);
        }

        .btn-confirm:hover:not(:disabled)::before { opacity: 1; }
        .btn-confirm:active:not(:disabled) {
            transform: scale(0.98);
        }

        .btn-confirm span,
        .btn-confirm svg { position: relative; z-index: 1; }

        .btn-confirm:disabled {
            background: linear-gradient(135deg, #C5CEDD, #D8DDEA);
            color: rgba(255,255,255,0.5);
            cursor: not-allowed;
            box-shadow: none;
        }

        /* ============================================
           구분선
        ============================================ */
        .divider-or {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 20px 0 16px;
        }

        .divider-or::before,
        .divider-or::after {
            content: '';
            flex: 1;
            height: 1px;
            background: var(--border);
        }

        .divider-or span {
            font-size: 11.5px;
            color: var(--text-muted);
            font-weight: 500;
            white-space: nowrap;
        }

        /* ============================================
           돌아가기 링크
        ============================================ */
        .btn-back {
            width: 100%;
            height: 48px;
            background: transparent;
            border: 1.5px solid var(--border);
            border-radius: var(--radius-md);
            font-family: 'Noto Sans KR', sans-serif;
            font-size: 14px;
            font-weight: 500;
            color: var(--text-sub);
            cursor: pointer;
            transition: all var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            text-decoration: none;
        }

        .btn-back:hover {
            border-color: var(--accent);
            color: var(--accent);
            background: rgba(74,144,217,0.04);
        }

        /* ============================================
           잠김 화면
        ============================================ */
        .locked-screen {
            display: none;
            text-align: center;
            padding: 12px 0 4px;
        }

        .locked-screen.show { display: block; }

        .lock-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, var(--primary-dark), var(--primary));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 16px;
            box-shadow: 0 8px 24px rgba(200,16,46,0.3);
        }

        .locked-screen h3 {
            font-size: 17px;
            font-weight: 700;
            color: var(--navy);
            margin-bottom: 8px;
        }

        .locked-screen p {
            font-size: 13px;
            color: var(--text-sub);
            line-height: 1.6;
        }

        .countdown {
            font-family: 'DM Mono', monospace;
            font-size: 28px;
            font-weight: 500;
            color: var(--primary);
            margin: 16px 0;
        }

        /* ============================================
           성공 화면
        ============================================ */
        .success-view {
            display: none;
            text-align: center;
            padding: 8px 0;
        }

        .success-view.show { display: block; }

        .success-anim {
            width: 72px;
            height: 72px;
            background: linear-gradient(135deg, #22C55E, #16A34A);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 18px;
            box-shadow: 0 8px 24px rgba(34,197,94,0.3);
            animation: popIn 0.45s cubic-bezier(0.22,1,0.36,1) both;
        }

        @keyframes popIn {
            from { transform: scale(0); opacity: 0; }
            to   { transform: scale(1); opacity: 1; }
        }

        .success-view h2 {
            font-size: 19px;
            font-weight: 700;
            color: var(--navy);
            margin-bottom: 8px;
        }

        .success-view p {
            font-size: 13.5px;
            color: var(--text-sub);
            line-height: 1.65;
        }

        /* ============================================
           푸터
        ============================================ */
        /* ============================================
           정문/후문 슬라이드 토글
        ============================================ */
        .gate-toggle {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 24px;
        }
        .gate-switch {
            position: relative;
            display: flex;
            background: #eef1f7;
            border: 1.5px solid var(--border);
            border-radius: 999px;
            padding: 4px;
            gap: 0;
            width: 220px;
        }
        .gate-switch-thumb {
            position: absolute;
            top: 4px;
            left: 4px;
            width: calc(50% - 4px);
            height: calc(100% - 8px);
            background: linear-gradient(135deg, var(--navy-mid), var(--navy-light));
            border-radius: 999px;
            transition: transform 0.28s cubic-bezier(0.4,0,0.2,1);
            box-shadow: 0 2px 8px rgba(13,27,62,0.22);
        }
        .gate-switch.back .gate-switch-thumb {
            transform: translateX(calc(100% + 0px));
        }
        .gate-option {
            flex: 1;
            text-align: center;
            padding: 8px 0;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            position: relative;
            z-index: 1;
            border-radius: 999px;
            transition: color 0.2s;
            color: var(--text-muted);
            user-select: none;
        }
        .gate-switch.front .gate-option.opt-front,
        .gate-switch.back  .gate-option.opt-back {
            color: #fff;
        }

        .footer {
            margin-top: 28px;
            text-align: center;
            color: rgba(255,255,255,0.38);
            font-size: 11px;
            letter-spacing: 0.02em;
        }

        /* ============================================
           반응형
        ============================================ */
        @media (min-width: 440px) {
            .pin-card { padding: 40px 36px 44px; }
            .key { height: 66px; font-size: 22px; }
            .pin-dot { width: 58px; height: 66px; }
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
            <svg width="9" height="11" viewBox="0 0 9 11" fill="none">
                <rect x="0.5" y="4.5" width="8" height="6" rx="1.2" stroke="white" stroke-width="1.2"/>
                <path d="M2 4.5V3C2 1.9 3.12 1 4.5 1C5.88 1 7 1.9 7 3V4.5" stroke="white" stroke-width="1.2" stroke-linecap="round"/>
            </svg>
            직원 전용 구역
        </div>
        <h1>직원 인증</h1>
        <p>6자리 PIN을 입력해 주세요</p>
    </header>

    <!-- PIN 카드 -->
    <div class="pin-card">

        <!-- 아이콘 + 타이틀 -->
        <div class="pin-icon-wrap">
            <div class="pin-icon">
                <svg width="28" height="28" viewBox="0 0 28 28" fill="none">
                    <rect x="4" y="12" width="20" height="14" rx="3" stroke="white" stroke-width="1.8"/>
                    <path d="M9 12V8.5C9 5.46 11.46 3 14.5 3C17.54 3 20 5.46 20 8.5V12" stroke="white" stroke-width="1.8" stroke-linecap="round"/>
                    <circle cx="14.5" cy="19" r="2" fill="white"/>
                    <path d="M14.5 21V23" stroke="white" stroke-width="1.6" stroke-linecap="round"/>
                </svg>
            </div>
        </div>

        <div class="pin-title">
            <h2>보안 PIN 인증</h2>
            <p>등록된 6자리 PIN을 입력하세요</p>
        </div>

        <!-- 정문/후문 슬라이드 토글 -->
        <div class="gate-toggle">
            <div class="gate-switch front" id="gateSwitch">
                <div class="gate-switch-thumb"></div>
                <div class="gate-option opt-front" onclick="setGate('front')">🚪 정문</div>
                <div class="gate-option opt-back"  onclick="setGate('back')">🚗 후문</div>
            </div>
        </div>

        <!-- PIN 상태 뷰 (정상 / 잠김 / 성공) -->
        <div id="pinMainView">

            <!-- PIN 6자리 표시 박스 -->
            <div class="pin-display" id="pinDisplay">
                <div class="pin-dot" id="dot0"></div>
                <div class="pin-dot" id="dot1"></div>
                <div class="pin-dot" id="dot2"></div>
                <div class="pin-dot" id="dot3"></div>
                <div class="pin-dot" id="dot4"></div>
                <div class="pin-dot" id="dot5"></div>
            </div>

            <!-- 오류 메시지 -->
            <div class="error-msg" id="errorMsg">
                <span id="errorText"></span>
            </div>

            <!-- 숫자 키패드 -->
            <div class="keypad">
                <button class="key" onclick="pressKey('1')">1</button>
                <button class="key" onclick="pressKey('2')">2</button>
                <button class="key" onclick="pressKey('3')">3</button>
                <button class="key" onclick="pressKey('4')">4</button>
                <button class="key" onclick="pressKey('5')">5</button>
                <button class="key" onclick="pressKey('6')">6</button>
                <button class="key" onclick="pressKey('7')">7</button>
                <button class="key" onclick="pressKey('8')">8</button>
                <button class="key" onclick="pressKey('9')">9</button>
                <div class="key key-spacer"></div>
                <button class="key key-zero" onclick="pressKey('0')">0</button>
                <button class="key key-back" onclick="pressBackspace()" aria-label="지우기">
                    <svg width="22" height="16" viewBox="0 0 22 16" fill="none">
                        <path d="M8 1L1 8L8 15" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
                        <path d="M1 8H21" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
                        <path d="M14 5L18 11M18 5L14 11" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>
                    </svg>
                </button>
            </div>

            <!-- 확인 버튼 -->
            <button class="btn-confirm" id="confirmBtn" onclick="confirmPin()" disabled>
                <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
                    <circle cx="9" cy="9" r="7.5" stroke="white" stroke-width="1.5"/>
                    <path d="M5.5 9L8 11.5L12.5 6.5" stroke="white" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                <span>인증 확인</span>
            </button>

        </div><!-- /#pinMainView -->

        <!-- 잠김 화면 -->
        <div class="locked-screen" id="lockedScreen">
            <div class="lock-icon">
                <svg width="28" height="28" viewBox="0 0 28 28" fill="none">
                    <rect x="4" y="12" width="20" height="14" rx="3" stroke="white" stroke-width="1.8"/>
                    <path d="M9 12V8.5C9 5.46 11.46 3 14.5 3C17.54 3 20 5.46 20 8.5V12" stroke="white" stroke-width="1.8" stroke-linecap="round"/>
                </svg>
            </div>
            <h3>인증이 잠겼습니다</h3>
            <p>PIN 입력을 5회 이상 실패하여<br>일시적으로 잠겼습니다.</p>
            <div class="countdown" id="countdown">05:00</div>
            <p style="font-size:12px; color:var(--text-muted);">잠금 해제까지 남은 시간</p>
        </div>

        <!-- 성공 화면 -->
        <div class="success-view" id="successView">
            <div class="success-anim">
                <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                    <path d="M6 16L13 23L26 9" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
            </div>
            <h2>인증 완료</h2>
            <p>직원 인증이 확인되었습니다.<br>잠시 후 이동합니다.</p>
        </div>

        <!-- 구분선 + 돌아가기 -->
        <div class="divider-or" id="dividerOr">
            <span>또는</span>
        </div>
        <a href="<%=request.getContextPath()%>/ez_in_out/main" class="btn-back" id="backBtn">
            <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                <path d="M10 3L5 8L10 13" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            방문록으로 돌아가기
        </a>

    </div><!-- /.pin-card -->

    <footer class="footer">
        &copy; 2026 EZ Automation. All rights reserved.
    </footer>

</div><!-- /.page-wrapper -->

<input type="password" class="pin-input-hidden" id="pinHidden" maxlength="6" inputmode="numeric" pattern="[0-9]*">

<script>
    var contextPath = '<%=request.getContextPath()%>';

    // ── 상태 ──────────────────────────────────────────
    var PIN_LENGTH   = 6;
    var MAX_ATTEMPTS = 5;
    var LOCK_SECONDS = 300; // 5분

    var currentGate = 'front'; // 'front' | 'back'

    function setGate(gate) {
        currentGate = gate;
        var sw = document.getElementById('gateSwitch');
        sw.className = 'gate-switch ' + gate;
    }

    var pinValue    = '';
    var attempts    = parseInt(sessionStorage.getItem('pin_attempts') || '0', 10);
    var lockedUntil = parseInt(sessionStorage.getItem('pin_locked_until') || '0', 10);
    var lockTimer   = null;

    // ── 초기화 ────────────────────────────────────────
    (function init() {
        checkLockStatus();

        // 물리 키보드 지원
        document.addEventListener('keydown', function(e) {
            if (e.key >= '0' && e.key <= '9') {
                pressKey(e.key);
            } else if (e.key === 'Backspace') {
                pressBackspace();
            } else if (e.key === 'Enter') {
                confirmPin();
            }
        });
    })();

    // ── 잠금 상태 확인 ────────────────────────────────
    function checkLockStatus() {
        var now = Date.now();
        if (lockedUntil > now) {
            showLocked(lockedUntil - now);
        }
    }

    // ── 키 입력 ───────────────────────────────────────
    function pressKey(digit) {
        if (pinValue.length >= PIN_LENGTH) return;
        if (document.getElementById('lockedScreen').classList.contains('show')) return;

        pinValue += digit;
        updateDisplay();
        updateConfirmBtn();

        // 4자리 입력 완료 시 자동 인증
        if (pinValue.length === PIN_LENGTH) {
            setTimeout(function() {
                confirmPin();
            }, 200); // 약간 딜레이로 UX 개선
        }

        // 진동 피드백 (모바일)
        if (navigator.vibrate) navigator.vibrate(10);
    }

    // ── 백스페이스 ────────────────────────────────────
    function pressBackspace() {
        if (!pinValue.length) return;
        pinValue = pinValue.slice(0, -1);
        updateDisplay();
        updateConfirmBtn();
        clearError();
    }

    // ── 디스플레이 업데이트 ───────────────────────────
    function updateDisplay() {
        for (var i = 0; i < PIN_LENGTH; i++) {
            var dot = document.getElementById('dot' + i);
            dot.classList.remove('error-shake');

            if (i < pinValue.length) {
                dot.classList.remove('active');
                dot.classList.add('filled');
            } else if (i === pinValue.length) {
                dot.classList.remove('filled');
                dot.classList.add('active');
            } else {
                dot.classList.remove('filled', 'active');
            }
        }
    }

    // ── 확인 버튼 활성화 ──────────────────────────────
    function updateConfirmBtn() {
        document.getElementById('confirmBtn').disabled = pinValue.length < PIN_LENGTH;
    }

    // ── 오류 표시 ─────────────────────────────────────
    function showError(msg) {
        var el = document.getElementById('errorMsg');
        document.getElementById('errorText').textContent = msg;
        el.classList.add('show');

        // 입력칸 흔들기
        for (var i = 0; i < PIN_LENGTH; i++) {
            var dot = document.getElementById('dot' + i);
            dot.classList.add('error-shake');
        }

        // 진동
        if (navigator.vibrate) navigator.vibrate([60, 40, 60]);
    }

    function clearError() {
        document.getElementById('errorMsg').classList.remove('show');
    }

    // ── PIN 초기화 ─────────────────────────────────────
    function resetPin() {
        pinValue = '';
        updateDisplay();
        updateConfirmBtn();
    }

    function confirmPin() {
        if (pinValue.length < PIN_LENGTH) return;

        var btn = document.getElementById('confirmBtn');
        btn.disabled = true;

        fetch(contextPath + '/ez_in_out/employee/verify-pin', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify({ pin: pinValue, gate: currentGate })
        })
        .then(function(res) {
            if (!res.ok) throw new Error('서버 오류');
            return res.json();
        })
        .then(function(result) {
            if (result && result.success) {
                alert('PIN 인증 성공: 등록된 PIN과 일치합니다.');
                onSuccess();
            } else {
                onFail(result && result.error ? result.error : 'PIN이 올바르지 않습니다.');
            }
        })
        .catch(function() {
            onFail('서버 통신 오류가 발생했습니다.');
        });
    }

    // ── 성공 처리 ─────────────────────────────────────
    function onSuccess() {
        attempts = 0;
        sessionStorage.removeItem('pin_attempts');
        sessionStorage.removeItem('pin_locked_until');

        document.getElementById('pinMainView').style.display  = 'none';
        document.getElementById('dividerOr').style.display    = 'none';
        document.getElementById('backBtn').style.display      = 'none';
        document.getElementById('successView').classList.add('show');

 
       
    }

    // ── 실패 처리 ─────────────────────────────────────
    function onFail(serverMsg) {
        attempts += 1;
        sessionStorage.setItem('pin_attempts', attempts);

        var remaining = MAX_ATTEMPTS - attempts;

        if (attempts >= MAX_ATTEMPTS) {
            // 잠금
            var until = Date.now() + LOCK_SECONDS * 1000;
            sessionStorage.setItem('pin_locked_until', until);
            lockedUntil = until;
            attempts = 0;
            sessionStorage.setItem('pin_attempts', 0);
            resetPin();
            showLocked(LOCK_SECONDS * 1000);
            return;
        }

        var msg = serverMsg || ('PIN이 올바르지 않습니다. (' + remaining + '회 남음)');
        showError(msg);

        setTimeout(function() {
            resetPin();
            clearError();
            document.getElementById('confirmBtn').disabled = true;
        }, 700);
    }

    // ── 잠금 화면 표시 ────────────────────────────────
    function showLocked(msRemaining) {
        document.getElementById('pinMainView').style.display = 'none';
        document.getElementById('lockedScreen').classList.add('show');
        startCountdown(Math.ceil(msRemaining / 1000));
    }

    function startCountdown(seconds) {
        var cd = document.getElementById('countdown');
        if (lockTimer) clearInterval(lockTimer);

        function tick() {
            var m = String(Math.floor(seconds / 60)).padStart(2, '0');
            var s = String(seconds % 60).padStart(2, '0');
            cd.textContent = m + ':' + s;

            if (seconds <= 0) {
                clearInterval(lockTimer);
                sessionStorage.removeItem('pin_locked_until');
                lockedUntil = 0;
                // 잠금 해제 → 입력 화면 복귀
                document.getElementById('lockedScreen').classList.remove('show');
                document.getElementById('pinMainView').style.display = 'block';
                resetPin();
            }
            seconds--;
        }

        tick();
        lockTimer = setInterval(tick, 1000);
    }
</script>

</body>
</html>
