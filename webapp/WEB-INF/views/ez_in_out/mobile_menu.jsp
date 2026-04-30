<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>메인 메뉴</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
* { box-sizing: border-box; margin: 0; padding: 0; -webkit-tap-highlight-color: transparent; }
html, body {
  height: 100%;
  font-family: 'DM Sans', 'Malgun Gothic', 'Apple SD Gothic Neo', sans-serif;
  background: #F5F7FA;
  color: #1A202C;
}

.wrap {
  min-height: 100vh;
  display: flex; flex-direction: column;
  padding: 20px 16px 36px;
}

/* ── 헤더 ── */
.header {
  display: flex; flex-direction: column; align-items: center;
  padding: 8px 0 28px;
}

.logo-ring {
  position: relative;
  width: 72px; height: 72px;
  margin-bottom: 16px;
}

.logo-ring svg.spinner {
  position: absolute; top: 0; left: 0;
  width: 72px; height: 72px;
  animation: spin 14s linear infinite;
  opacity: 0.45;
}

@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }

.logo-inner {
  position: absolute; top: 8px; left: 8px;
  width: 56px; height: 56px; border-radius: 16px;
  background: linear-gradient(145deg, #1a1a2e, #16213e);
  display: flex; align-items: center; justify-content: center;
  box-shadow: 0 8px 32px rgba(0,0,0,0.22);
}
.logo-inner svg { width: 26px; height: 26px; }

.header-title {
  font-size: 20px; font-weight: 600;
  color: #1A202C; letter-spacing: -0.5px;
}

.header-sub {
  font-size: 11px; color: #A0AEC0;
  margin-top: 3px; letter-spacing: 1px;
  font-family: 'DM Mono', monospace;
}

.status-bar {
  display: flex; align-items: center; gap: 6px;
  margin-top: 10px; padding: 5px 14px;
  background: #fff; border-radius: 20px;
  border: 0.5px solid #E2E8F0;
  font-size: 11px; color: #718096;
  font-family: 'DM Mono', monospace;
}
.status-dot {
  width: 6px; height: 6px; border-radius: 50%;
  background: #22c55e;
  box-shadow: 0 0 6px rgba(34,197,94,0.5);
  animation: pulse 2s infinite;
}
@keyframes pulse { 0%,100% { opacity: 1; } 50% { opacity: 0.4; } }

/* ── 섹션 레이블 ── */
.section-label {
  font-size: 10px; font-weight: 500;
  color: #A0AEC0; letter-spacing: 2px;
  text-transform: uppercase;
  margin: 0 4px 10px;
  font-family: 'DM Mono', monospace;
}

/* ── 메뉴 그리드 ── */
.menu-grid {
  display: flex; flex-direction: column; gap: 8px;
  margin-bottom: 20px;
}

/* ── 카드 ── */
.menu-card {
  display: flex; align-items: center; gap: 16px;
  background: #fff; border-radius: 14px;
  padding: 16px 18px;
  border: 0.5px solid #E2E8F0;
  text-decoration: none; color: inherit;
  cursor: pointer; position: relative; overflow: hidden;
  transition: border-color .18s, transform .12s;
  -webkit-user-select: none; user-select: none;
}
.menu-card::before {
  content: '';
  position: absolute; left: 0; top: 0; bottom: 0;
  width: 3px; border-radius: 3px 0 0 3px;
  opacity: 0; transition: opacity .18s;
}
.menu-card:hover { border-color: #C3CFE0; }
.menu-card:hover::before { opacity: 1; }
.menu-card:active { transform: scale(0.98); }

.card-blue::before   { background: #3b82f6; }
.card-emerald::before{ background: #10b981; }
.card-amber::before  { background: #f59e0b; }
.card-rose::before   { background: #f43f5e; }
.card-violet::before { background: #8b5cf6; }

/* ── 아이콘 ── */
.menu-icon {
  width: 46px; height: 46px; border-radius: 12px;
  display: flex; align-items: center; justify-content: center;
  flex-shrink: 0;
}
.icon-bg-blue    { background: #eff6ff; }
.icon-bg-emerald { background: #ecfdf5; }
.icon-bg-amber   { background: #fffbeb; }
.icon-bg-rose    { background: #fff1f2; }
.icon-bg-violet  { background: #f5f3ff; }

/* ── 텍스트 ── */
.menu-info { flex: 1; min-width: 0; }
.menu-title { font-size: 14px; font-weight: 600; color: #1A202C; margin-bottom: 2px; letter-spacing: -0.2px; }
.menu-desc  { font-size: 11.5px; color: #A0AEC0; line-height: 1.4; }

/* ── 화살표 ── */
.menu-arrow {
  color: #CBD5E0; flex-shrink: 0;
  transition: transform .18s, color .18s;
}
.menu-card:hover .menu-arrow { transform: translateX(3px); color: #718096; }

/* ── 배지 ── */
.menu-badge {
  font-size: 9px; font-weight: 500;
  padding: 2px 7px; border-radius: 10px;
  background: #fef3c7; color: #92400e;
  border: 0.5px solid #fde68a;
  letter-spacing: 0.5px;
  font-family: 'DM Mono', monospace;
  position: absolute; top: 12px; right: 36px;
}

/* ── 구분선 ── */
.divider {
  height: 0.5px;
  background: #E2E8F0;
  margin: 4px 0 16px;
}

/* ── 푸터 ── */
.footer {
  text-align: center; margin-top: auto; padding-top: 24px;
  font-size: 10px; color: #CBD5E0;
  font-family: 'DM Mono', monospace;
  letter-spacing: 0.5px;
  display: flex; align-items: center; justify-content: center; gap: 8px;
}
</style>
</head>
<body>
<div class="wrap">

  <!-- 헤더 -->
  <div class="header">
    <div class="logo-ring">
      <svg class="spinner" viewBox="0 0 72 72" fill="none" xmlns="http://www.w3.org/2000/svg">
        <circle cx="36" cy="36" r="33" stroke="#CBD5E0" stroke-width="0.5" stroke-dasharray="4 6" stroke-linecap="round"/>
      </svg>
      <div class="logo-inner">
        <svg viewBox="0 0 24 24" fill="none" stroke="#60a5fa" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
          <rect x="3" y="11" width="18" height="11" rx="2"/>
          <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
          <circle cx="12" cy="16" r="1.2" fill="#60a5fa" stroke="none"/>
        </svg>
      </div>
    </div>
    <div class="header-title">EZ 관리 시스템</div>
    <div class="header-sub">EZ ACCESS v1.0</div>
    <div class="status-bar">
      <div class="status-dot"></div>
      시스템 정상 운영 중
    </div>
  </div>

  <!-- 출입 관리 -->
  <div class="section-label">출입 관리</div>
  <div class="menu-grid">

    <a class="menu-card card-blue" href="${pageContext.request.contextPath}/ez_in_out/attend/record-list">
      <div class="menu-icon icon-bg-blue">
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#3b82f6" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
          <path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2"/>
          <rect x="9" y="3" width="6" height="4" rx="1"/>
          <line x1="9" y1="12" x2="15" y2="12"/>
          <line x1="9" y1="16" x2="13" y2="16"/>
        </svg>
      </div>
      <div class="menu-info">
        <div class="menu-title">출퇴근 기록</div>
        <div class="menu-desc">직원별 기록 조회 및 엑셀 다운로드</div>
      </div>
      <div class="menu-arrow">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M9 18l6-6-6-6"/></svg>
      </div>
    </a>

    <a class="menu-card card-emerald" href="${pageContext.request.contextPath}/ez_in_out/pin">
      <div class="menu-icon icon-bg-emerald">
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#10b981" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
          <rect x="3" y="11" width="18" height="11" rx="2"/>
          <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
          <circle cx="12" cy="16" r="1.5"/>
        </svg>
      </div>
      <div class="menu-info">
        <div class="menu-title">직원 출입</div>
        <div class="menu-desc">PIN 입력으로 출근 · 외근 · 퇴근 처리</div>
      </div>
      <div class="menu-arrow">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M9 18l6-6-6-6"/></svg>
      </div>
    </a>

    <a class="menu-card card-amber" href="${pageContext.request.contextPath}/ez_in_out/main">
      <div class="menu-icon icon-bg-amber">
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
          <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
          <path d="M9 12l2 2 4-4"/>
        </svg>
      </div>
      <div class="menu-info">
        <div class="menu-title">방문자 출입</div>
        <div class="menu-desc">방문자 정보 등록 및 출입 처리</div>
      </div>
      <div class="menu-arrow">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M9 18l6-6-6-6"/></svg>
      </div>
    </a>

    <!-- 경비 시스템: CCTV/카메라 아이콘으로 변경 -->
    <a class="menu-card card-rose" href="${pageContext.request.contextPath}/ez_in_out/security">
      <div class="menu-icon icon-bg-rose">
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#f43f5e" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
          <path d="M23 7l-7 5 7 5V7z"/>
          <rect x="1" y="5" width="15" height="14" rx="2"/>
          <circle cx="8" cy="12" r="2.5" stroke-width="1.5"/>
        </svg>
      </div>
      <div class="menu-info">
        <div class="menu-title">경비 시스템</div>
        <div class="menu-desc">구역별 움직임 감지 및 상태 모니터링</div>
      </div>
      <div class="menu-arrow">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M9 18l6-6-6-6"/></svg>
      </div>
    </a>

  </div>

  <div class="divider"></div>

  <!-- 제어 시스템 -->
  <div class="section-label">제어 시스템</div>
  <div class="menu-grid">

    <a class="menu-card card-violet" href="http://192.168.1.19:8080/sample_pro/plc/PlcReadWrite" target="_blank">
      <div class="menu-icon icon-bg-violet">
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#8b5cf6" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="12" r="3"/>
          <path d="M19.07 4.93a10 10 0 0 1 0 14.14"/>
          <path d="M4.93 4.93a10 10 0 0 0 0 14.14"/>
          <path d="M16.24 7.76a6 6 0 0 1 0 8.49"/>
          <path d="M7.76 7.76a6 6 0 0 0 0 8.49"/>
        </svg>
      </div>
      <div class="menu-info">
        <div class="menu-title">PLC 제어</div>
        <div class="menu-desc">실시간 모니터링 · 비트·워드 읽기·쓰기</div>
      </div>
      <span class="menu-badge">사내망</span>
      <div class="menu-arrow">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M9 18l6-6-6-6"/></svg>
      </div>
    </a>

  </div>

  <div class="footer">
    <span>© 2026 EZ Access</span>
    <span>·</span>
    <span>All systems nominal</span>
  </div>

</div>
</body>
</html>
