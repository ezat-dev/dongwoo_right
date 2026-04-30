<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>경비 시스템</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<style>
:root {
  --bg:        #F0F2F7;
  --surface:   #FFFFFF;
  --surface2:  #F8F9FC;
  --border:    #E4E8F0;
  --border2:   #CDD3E0;

  --text:      #0F172A;
  --text2:     #475569;
  --text3:     #94A3B8;

  --blue:      #2563EB;
  --blue-l:    #EFF6FF;
  --blue-b:    #BFDBFE;
  --blue-glow: rgba(37,99,235,.15);

  --green:     #059669;
  --green-l:   #ECFDF5;
  --green-b:   #A7F3D0;
  --green-glow:rgba(5,150,105,.12);

  --red:       #DC2626;
  --red-l:     #FEF2F2;
  --red-b:     #FECACA;
  --red-glow:  rgba(220,38,38,.10);

  --amber:     #D97706;
  --amber-l:   #FFFBEB;
  --amber-b:   #FDE68A;

  --r-xs: 5px;
  --r-sm: 8px;
  --r:    12px;
  --r-lg: 16px;
  --r-xl: 20px;

  --sh-xs: 0 1px 3px rgba(15,23,42,.06);
  --sh-sm: 0 2px 8px rgba(15,23,42,.08), 0 1px 3px rgba(15,23,42,.05);
  --sh:    0 4px 16px rgba(15,23,42,.10), 0 2px 6px rgba(15,23,42,.06);

  --font: 'Sora', 'Malgun Gothic', 'Apple SD Gothic Neo', sans-serif;
  --mono: 'JetBrains Mono', monospace;
}

*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; -webkit-tap-highlight-color: transparent; }

/* 데스크톱: 고정 높이, 스크롤 없음 */
html, body {
  font-family: var(--font);
  background: var(--bg); color: var(--text);
  font-size: 13px; line-height: 1.5;
  -webkit-font-smoothing: antialiased;
}
@media (min-width: 769px) {
  html, body { height: 100%; overflow: hidden; }
}

::-webkit-scrollbar { width: 3px; height: 3px; }
::-webkit-scrollbar-thumb { background: var(--border2); border-radius: 3px; }

/* ── 앱 ── */
.app {
  display: flex; flex-direction: column;
}
@media (min-width: 769px) {
  .app { height: 100vh; overflow: hidden; }
}

/* ── 헤더 ── */
.header {
  flex-shrink: 0; height: 56px;
  display: flex; align-items: center; gap: 12px;
  padding: 0 20px;
  background: var(--surface); border-bottom: 1px solid var(--border);
  box-shadow: var(--sh-xs); z-index: 200;
}
.header-back {
  display: flex; align-items: center; justify-content: center;
  width: 30px; height: 30px; border-radius: var(--r-sm);
  border: 1px solid var(--border); color: var(--text2);
  text-decoration: none; flex-shrink: 0; transition: all .15s;
}
.header-back:hover { border-color: var(--blue); color: var(--blue); }
.header-logo { display: flex; align-items: center; gap: 9px; }
.header-logo-dot {
  width: 26px; height: 26px; border-radius: var(--r-sm); flex-shrink: 0;
  background: linear-gradient(135deg, var(--blue) 0%, #6366F1 100%);
  display: flex; align-items: center; justify-content: center;
  box-shadow: 0 2px 8px rgba(37,99,235,.25);
}
.header-title { font-size: 14px; font-weight: 700; letter-spacing: -.3px; color: var(--text); }
.header-sub   { font-size: 9px; color: var(--text3); font-family: var(--mono); }
.header-right { margin-left: auto; display: flex; align-items: center; gap: 10px; }
.poll-chip {
  display: flex; align-items: center; gap: 5px;
  padding: 4px 10px; border-radius: 20px;
  background: var(--surface2); border: 1px solid var(--border);
  font-size: 10px; color: var(--text3); font-family: var(--mono);
}
.poll-dot {
  width: 5px; height: 5px; border-radius: 50%;
  background: var(--text3); flex-shrink: 0; transition: background .3s;
}
.poll-chip.ok  .poll-dot { background: var(--green); box-shadow: 0 0 5px var(--green-glow); }
.poll-chip.err .poll-dot { background: var(--red);   box-shadow: 0 0 5px var(--red-glow); }
.poll-chip.run .poll-dot { background: var(--blue);  animation: spin .7s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }
.header-clock { font-size: 11px; color: var(--text3); font-family: var(--mono); }

/* ── 메인 (좌우 분할) ── */
.main { flex: 1; display: flex; min-height: 0; }
@media (min-width: 769px) {
  .main { overflow: hidden; }
}

/* ════════════
   왼쪽 패널
════════════ */
.left-panel {
  width: 340px; flex-shrink: 0;
  display: flex; flex-direction: column;
  background: var(--surface); border-right: 1px solid var(--border);
}
@media (min-width: 769px) {
  .left-panel { overflow: hidden; }
}
.left-scroll {
  flex: 1; padding: 18px;
  display: flex; flex-direction: column; gap: 14px;
}
@media (min-width: 769px) {
  .left-scroll { overflow-y: auto; }
}

/* 마스터 카드 */
.master-card {
  border-radius: var(--r-xl); border: 1px solid var(--border);
  padding: 20px; background: var(--surface2);
  position: relative; overflow: hidden; box-shadow: var(--sh-xs);
  transition: border-color .35s, background .35s, box-shadow .35s;
}
.master-card::before {
  content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px;
  background: var(--border2); transition: background .35s;
  border-radius: var(--r-xl) var(--r-xl) 0 0;
}
.master-card.armed    { background: var(--red-l);   border-color: var(--red-b);   box-shadow: 0 0 0 4px var(--red-glow), var(--sh-xs); }
.master-card.armed::before    { background: var(--red); }
.master-card.disarmed { background: var(--green-l); border-color: var(--green-b); box-shadow: 0 0 0 4px var(--green-glow), var(--sh-xs); }
.master-card.disarmed::before { background: var(--green); }

.master-top { display: flex; align-items: center; gap: 14px; margin-bottom: 16px; }
.master-icon-ring {
  width: 50px; height: 50px; border-radius: 50%; flex-shrink: 0;
  display: flex; align-items: center; justify-content: center;
  background: #fff; border: 1.5px solid var(--border2);
  box-shadow: var(--sh-xs); position: relative; transition: all .35s;
}
.master-card.armed    .master-icon-ring { background: var(--red-l);   border-color: var(--red-b); }
.master-card.disarmed .master-icon-ring { background: var(--green-l); border-color: var(--green-b); }
.master-card.armed .master-icon-ring::after {
  content: ''; position: absolute; inset: -5px; border-radius: 50%;
  border: 1.5px solid var(--red); opacity: 0; animation: pulse-ring 2s ease-out infinite;
}
@keyframes pulse-ring { 0%{opacity:.5;transform:scale(.85)} 100%{opacity:0;transform:scale(1.3)} }
.master-svg { width: 21px; height: 21px; display: block; }
.master-card.armed    .master-svg { stroke: var(--red); }
.master-card.disarmed .master-svg { stroke: var(--green); }
.master-card.unknown  .master-svg { stroke: var(--text3); }
.master-info { flex: 1; min-width: 0; }
.master-eyebrow {
  font-size: 9px; font-weight: 600; letter-spacing: 2px; text-transform: uppercase;
  color: var(--text3); font-family: var(--mono); margin-bottom: 3px;
}
.master-label {
  font-size: 22px; font-weight: 800; letter-spacing: -.5px; line-height: 1;
  transition: color .35s;
}
.master-card.armed    .master-label { color: var(--red); }
.master-card.disarmed .master-label { color: var(--green); }
.master-card.unknown  .master-label { color: var(--text3); }
.master-badge-row { display: flex; justify-content: flex-end; margin-bottom: 12px; }
.master-badge {
  padding: 4px 12px; border-radius: 20px;
  font-size: 9px; font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase;
  font-family: var(--mono);
}
.master-card.armed    .master-badge { background: var(--red-b);   color: var(--red);   border: 1px solid rgba(220,38,38,.2); }
.master-card.disarmed .master-badge { background: var(--green-b); color: var(--green); border: 1px solid rgba(5,150,105,.2); }
.master-card.unknown  .master-badge { background: var(--border);  color: var(--text3); border: 1px solid var(--border2); }
.master-hr { border: none; border-top: 1px solid var(--border); margin: 0 0 12px; }
.master-meta-row { display: flex; justify-content: space-between; align-items: center; }
.master-meta-k { font-size: 10px; color: var(--text3); }
.master-meta-v { font-size: 10px; color: var(--text2); font-family: var(--mono); }

/* 센서 */
.section-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px; }
.section-title { font-size: 9px; font-weight: 700; letter-spacing: 2px; text-transform: uppercase; color: var(--text3); }
.section-alert {
  display: none; padding: 2px 8px; border-radius: 20px;
  background: var(--amber-l); color: var(--amber); border: 1px solid var(--amber-b);
  font-size: 9px; font-weight: 700; letter-spacing: 1px; font-family: var(--mono);
}
.section-alert.show { display: inline-block; }

.sensor-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(130px,1fr)); gap: 7px; }
.sensor-card {
  background: var(--surface); border: 1px solid var(--border);
  border-radius: var(--r-lg); padding: 13px;
  position: relative; overflow: hidden; box-shadow: var(--sh-xs);
  transition: border-color .2s, background .2s, box-shadow .2s;
}
.sensor-card::after {
  content: ''; position: absolute; bottom: 0; left: 0; right: 0; height: 2.5px;
  background: var(--border); border-radius: 0 0 var(--r-lg) var(--r-lg); transition: background .2s;
}
.sensor-card.alert {
  background: var(--amber-l); border-color: var(--amber-b);
  box-shadow: 0 0 0 3px rgba(217,119,6,.08), var(--sh-xs);
}
.sensor-card.alert::after { background: var(--amber); }
.sensor-top { display: flex; align-items: center; justify-content: space-between; margin-bottom: 9px; }
.sensor-dot {
  width: 7px; height: 7px; border-radius: 50%;
  background: var(--border2); transition: all .25s;
}
.sensor-card.alert .sensor-dot {
  background: var(--amber); box-shadow: 0 0 6px rgba(217,119,6,.4);
  animation: blink .9s ease-in-out infinite;
}
@keyframes blink { 0%,100%{opacity:1} 50%{opacity:.2} }
.sensor-pip {
  padding: 2px 7px; border-radius: 20px;
  font-size: 8px; font-weight: 700; letter-spacing: 1.5px; font-family: var(--mono);
}
.sensor-pip.off { background: var(--surface2); color: var(--text3); border: 1px solid var(--border); }
.sensor-pip.on  { background: var(--amber-l);  color: var(--amber); border: 1px solid var(--amber-b); }
.sensor-name { font-size: 12px; font-weight: 600; color: var(--text); letter-spacing: -.2px; line-height: 1.3; }
.sensor-card.alert .sensor-name { color: var(--amber); }
.sensor-addr { font-size: 9px; color: var(--text3); font-family: var(--mono); margin-top: 2px; }

/* ════════════
   오른쪽 패널
════════════ */
.right-panel { flex: 1; display: flex; flex-direction: column; background: var(--bg); }
@media (min-width: 769px) {
  .right-panel { overflow: hidden; }
}

.tab-nav {
  flex-shrink: 0; display: flex;
  background: var(--surface); border-bottom: 1px solid var(--border);
  padding: 0 20px; box-shadow: var(--sh-xs);
}
.tab-btn {
  padding: 14px 18px; font-size: 12px; font-weight: 500; color: var(--text3);
  border: none; border-bottom: 2px solid transparent; background: transparent;
  cursor: pointer; display: flex; align-items: center; gap: 7px;
  white-space: nowrap; margin-bottom: -1px; font-family: var(--font);
  transition: color .15s, border-color .15s;
}
.tab-btn:hover { color: var(--text2); }
.tab-btn.active { color: var(--blue); border-bottom-color: var(--blue); font-weight: 600; }
.tab-badge {
  display: inline-flex; align-items: center; justify-content: center;
  min-width: 18px; height: 18px; padding: 0 5px; border-radius: 9px;
  font-size: 9px; font-weight: 700; font-family: var(--mono);
  background: var(--bg); color: var(--text3); border: 1px solid var(--border);
}
.tab-btn.active .tab-badge { background: var(--blue-l); color: var(--blue); border-color: var(--blue-b); }

.tab-panel { display: none; flex: 1; flex-direction: column; }
@media (min-width: 769px) {
  .tab-panel { overflow: hidden; }
}
.tab-panel.active { display: flex; flex-direction: column; }

/* 이력 탭 */
.history-scroll { flex: 1; padding: 16px 20px; }
@media (min-width: 769px) { .history-scroll { overflow-y: auto; } }

.history-item {
  display: flex; align-items: center; gap: 13px;
  padding: 13px 16px; background: var(--surface); border: 1px solid var(--border);
  border-radius: var(--r-lg); margin-bottom: 6px; box-shadow: var(--sh-xs);
  transition: border-color .12s, box-shadow .12s;
}
.history-item:hover { border-color: var(--border2); box-shadow: var(--sh-sm); }
.history-ico {
  width: 34px; height: 34px; border-radius: var(--r);
  display: flex; align-items: center; justify-content: center; flex-shrink: 0;
}
.history-ico.on  { background: var(--red-l);   border: 1px solid var(--red-b); }
.history-ico.off { background: var(--green-l); border: 1px solid var(--green-b); }
.history-body { flex: 1; min-width: 0; }
.history-name { font-size: 13px; font-weight: 600; color: var(--text); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.history-addr { font-size: 9px; color: var(--text3); font-family: var(--mono); margin-top: 2px; }
.history-right { text-align: right; flex-shrink: 0; }
.history-badge {
  display: inline-block; padding: 3px 9px; border-radius: 20px;
  font-size: 9px; font-weight: 700; letter-spacing: 1px;
  font-family: var(--mono); text-transform: uppercase; margin-bottom: 3px;
}
.history-badge.on  { background: var(--red-l);   color: var(--red);   border: 1px solid var(--red-b); }
.history-badge.off { background: var(--green-l); color: var(--green); border: 1px solid var(--green-b); }
.history-time { font-size: 9px; color: var(--text3); font-family: var(--mono); }

/* 수신자 탭 */
.notify-scroll { flex: 1; padding: 16px 20px; }
@media (min-width: 769px) { .notify-scroll { overflow-y: auto; } }

.dept-block { margin-bottom: 18px; }
.dept-label {
  font-size: 9px; font-weight: 700; letter-spacing: 2px; text-transform: uppercase;
  color: var(--text3); padding-bottom: 9px; border-bottom: 1px solid var(--border); margin-bottom: 9px;
}
.emp-row {
  display: flex; align-items: center; gap: 12px;
  padding: 12px 15px; background: var(--surface); border: 1px solid var(--border);
  border-radius: var(--r-lg); margin-bottom: 5px;
  cursor: pointer; position: relative; overflow: hidden; box-shadow: var(--sh-xs);
  transition: all .15s; -webkit-user-select: none; user-select: none;
}
.emp-row::before {
  content: ''; position: absolute; left: 0; top: 0; bottom: 0; width: 3px;
  background: transparent; border-radius: 3px 0 0 3px; transition: background .2s;
}
.emp-row:hover { border-color: var(--border2); box-shadow: var(--sh-sm); }
.emp-row.checked { background: var(--green-l); border-color: var(--green-b); }
.emp-row.checked::before { background: var(--green); }
.emp-row:active { transform: scale(.99); }
.emp-avatar {
  width: 34px; height: 34px; border-radius: 50%;
  background: var(--blue-l); border: 1.5px solid var(--blue-b);
  display: flex; align-items: center; justify-content: center;
  font-size: 12px; font-weight: 700; color: var(--blue);
  flex-shrink: 0; font-family: var(--mono); transition: all .15s;
}
.emp-row.checked .emp-avatar { background: var(--green-l); border-color: var(--green-b); color: var(--green); }
.emp-info { flex: 1; min-width: 0; }
.emp-name { font-size: 13px; font-weight: 600; color: var(--text); transition: color .15s; }
.emp-row.checked .emp-name { color: var(--green); }
.emp-meta { font-size: 10px; color: var(--text3); margin-top: 2px; display: flex; align-items: center; gap: 5px; }
.emp-tag { padding: 1px 6px; border-radius: 4px; background: var(--bg); border: 1px solid var(--border); font-size: 9px; color: var(--text3); }
.emp-toggle {
  width: 40px; height: 22px; border-radius: 11px;
  background: var(--border2); border: 1px solid var(--border2);
  flex-shrink: 0; position: relative; transition: background .2s, border-color .2s;
}
.emp-toggle::after {
  content: ''; position: absolute; top: 2px; left: 2px;
  width: 16px; height: 16px; border-radius: 50%;
  background: #fff; box-shadow: var(--sh-xs); transition: transform .2s;
}
.emp-row.checked .emp-toggle { background: var(--green); border-color: var(--green); }
.emp-row.checked .emp-toggle::after { transform: translateX(18px); }

/* 수신자 푸터 */
.notify-footer {
  flex-shrink: 0; display: flex; align-items: center; gap: 12px;
  padding: 13px 20px; background: var(--surface); border-top: 1px solid var(--border);
  box-shadow: 0 -4px 12px rgba(15,23,42,.05);
}
.footer-info { flex: 1; }
.footer-count { font-size: 13px; font-weight: 600; color: var(--text); }
.footer-count b { color: var(--blue); font-weight: 700; }
.footer-sub { font-size: 10px; color: var(--text3); margin-top: 1px; }
.save-msg { font-size: 11px; font-weight: 500; }
.save-msg.ok  { color: var(--green); }
.save-msg.err { color: var(--red); }
.btn-save {
  padding: 9px 22px; border-radius: var(--r); border: none; cursor: pointer;
  font-family: var(--font); font-size: 12px; font-weight: 700;
  background: var(--blue); color: #fff;
  box-shadow: 0 2px 8px rgba(37,99,235,.28), 0 1px 3px rgba(37,99,235,.15);
  transition: background .15s, box-shadow .15s, transform .1s;
}
.btn-save:hover { background: #1D4ED8; box-shadow: 0 4px 14px rgba(37,99,235,.35); }
.btn-save:active { transform: scale(.97); }
.btn-save:disabled { background: var(--border2); color: var(--text3); box-shadow: none; cursor: not-allowed; }

/* 빈 상태 */
.empty-state {
  display: flex; flex-direction: column;
  align-items: center; justify-content: center; gap: 10px;
  color: var(--text3); padding: 40px 20px; min-height: 160px;
}
.empty-icon {
  width: 44px; height: 44px; border-radius: var(--r-xl);
  background: var(--surface); border: 1px solid var(--border);
  display: flex; align-items: center; justify-content: center; box-shadow: var(--sh-xs);
}
.empty-text { font-size: 12px; }

/* ════════════════════════════
   모바일 (≤768px)
════════════════════════════ */
@media (max-width: 768px) {
  .main { flex-direction: column; }

  /* 왼쪽 패널: 풀 너비로 */
  .left-panel {
    width: 100%; border-right: none; border-bottom: 1px solid var(--border);
  }
  .left-scroll { padding: 14px; gap: 12px; }

  /* 마스터 카드 살짝 압축 */
  .master-label { font-size: 20px; }
  .master-icon-ring { width: 44px; height: 44px; }
  .master-svg { width: 18px; height: 18px; }

  /* 센서 그리드 → 가로 스크롤 */
  .sensor-grid {
    display: flex; overflow-x: auto; gap: 8px;
    padding-bottom: 6px;
    scroll-snap-type: x mandatory;
    -webkit-overflow-scrolling: touch;
  }
  .sensor-card {
    min-width: 120px; flex-shrink: 0;
    scroll-snap-align: start;
  }

  /* 오른쪽 패널: 풀 너비 */
  .right-panel { flex: none; width: 100%; }

  /* 탭 */
  .tab-nav { padding: 0 14px; }
  .tab-btn { padding: 12px 14px; font-size: 12px; }

  /* 스크롤 패널들 */
  .history-scroll, .notify-scroll { padding: 12px 14px; }
  .notify-footer { padding: 12px 14px; }

  /* 헤더 */
  .header { padding: 0 14px; }
  .header-clock { display: none; }
}

@media (max-width: 400px) {
  .master-label { font-size: 18px; }
  .tab-btn { padding: 12px 10px; font-size: 11px; gap: 5px; }
  .master-badge { display: none; }
}
</style>
</head>
<body>
<div class="app">

  <!-- 헤더 -->
  <div class="header">
    <a class="header-back" href="${pageContext.request.contextPath}/ez_in_out/menu" title="메뉴">
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 12H5M12 5l-7 7 7 7"/></svg>
    </a>
    <div class="header-logo">
      <div class="header-logo-dot">
        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.2" stroke-linecap="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
      </div>
      <div>
        <div class="header-title">경비 시스템</div>
        <div class="header-sub">Security Monitor</div>
      </div>
    </div>
    <div class="header-right">
      <div class="poll-chip" id="pollChip">
        <div class="poll-dot"></div>
        <span id="pollMsg">대기</span>
      </div>
      <span class="header-clock" id="topClock"></span>
    </div>
  </div>

  <!-- 메인 -->
  <div class="main">

    <!-- 왼쪽: 상태 + 센서 -->
    <div class="left-panel">
      <div class="left-scroll">

        <!-- 마스터 상태 -->
        <div class="master-card unknown" id="masterCard">
          <div class="master-top">
            <div class="master-icon-ring">
              <svg class="master-svg" id="masterSvg" viewBox="0 0 24 24" fill="none" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
              </svg>
            </div>
            <div class="master-info">
              <div class="master-eyebrow">D44 · 경비 마스터</div>
              <div class="master-label" id="masterLabel">확인 중...</div>
            </div>
          </div>
          <div class="master-badge-row">
            <span class="master-badge" id="masterBadge">—</span>
          </div>
          <hr class="master-hr">
          <div class="master-meta-row">
            <span class="master-meta-k">레지스터 값</span>
            <span class="master-meta-v" id="masterMeta">—</span>
          </div>
        </div>

        <!-- 센서 -->
        <div>
          <div class="section-head">
            <span class="section-title">움직임 감지 센서</span>
            <span class="section-alert" id="alertBadge"></span>
          </div>
          <div class="sensor-grid" id="sensorGrid"></div>
        </div>

      </div>
    </div>

    <!-- 오른쪽: 탭 -->
    <div class="right-panel">
      <div class="tab-nav">
        <button class="tab-btn active" onclick="switchTab('history',this)">
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
          감지 이력
          <span class="tab-badge" id="historyCount">0</span>
        </button>
        <button class="tab-btn" onclick="switchTab('notify',this)">
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9M13.73 21a2 2 0 0 1-3.46 0"/></svg>
          알림 수신자
          <span class="tab-badge" id="notifyCount">0</span>
        </button>
      </div>

      <!-- 이력 패널 -->
      <div class="tab-panel active" id="panel-history">
        <div class="history-scroll" id="historyScroll">
          <div class="empty-state">
            <div class="empty-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div>
            <span class="empty-text">감지 이력이 없습니다</span>
          </div>
        </div>
      </div>

      <!-- 수신자 패널 -->
      <div class="tab-panel" id="panel-notify">
        <div class="notify-scroll" id="notifyList">
          <div class="empty-state">
            <div class="empty-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg></div>
            <span class="empty-text">로딩 중...</span>
          </div>
        </div>
        <div class="notify-footer">
          <div class="footer-info">
            <div class="footer-count"><b id="checkCount">0</b>명 선택됨</div>
            <div class="footer-sub">경보 발생 시 SMS 알림 전송</div>
          </div>
          <span class="save-msg" id="saveMsg"></span>
          <button class="btn-save" id="btnSave" onclick="saveNotify()">저장하기</button>
        </div>
      </div>

    </div>
  </div>
</div>

<script>
var ctx='${pageContext.request.contextPath}', PLC_ID='default', INTERVAL=1000;
var SENSORS=[
  {id:'A',bit:10,addr:'D0002.A',name:'공장 입구'},
  {id:'B',bit:11,addr:'D0002.B',name:'접견실'},
  {id:'C',bit:12,addr:'D0002.C',name:'현관'},
  {id:'D',bit:13,addr:'D0002.D',name:'회의실 내부'},
  {id:'E',bit:14,addr:'D0002.E',name:'회의실 외부'}
];
var checkedIds={}, empData=[];

(function tick(){ document.getElementById('topClock').textContent=new Date().toLocaleTimeString('ko-KR'); setTimeout(tick,1000); })();

function switchTab(name,btn){
  document.querySelectorAll('.tab-btn').forEach(function(b){b.classList.remove('active');});
  document.querySelectorAll('.tab-panel').forEach(function(p){p.classList.remove('active');});
  btn.classList.add('active');
  document.getElementById('panel-'+name).classList.add('active');
}

function renderSensorGrid(){
  document.getElementById('sensorGrid').innerHTML=SENSORS.map(function(s){
    return '<div class="sensor-card" id="sc_'+s.id+'">'
      +'<div class="sensor-top"><div class="sensor-dot"></div><span class="sensor-pip off" id="sp_'+s.id+'">OFF</span></div>'
      +'<div class="sensor-name">'+esc(s.name)+'</div>'
      +'<div class="sensor-addr">'+esc(s.addr)+'</div></div>';
  }).join('');
}
renderSensorGrid();

function startPolling(){ setInterval(doPoll,INTERVAL); doPoll(); }
function doPoll(){
  setChip('run','폴링');
  fetch(ctx+'/plc/read/'+PLC_ID+'?start=2&count=43')
    .then(function(r){return r.json();})
    .then(function(d){
      if(!d.success) throw new Error();
      var v=d.values||[];
      updateMaster(v[42]!=null?v[42]:0);
      updateSensors(v[0]!=null?v[0]:0);
      setChip('ok','정상');
    }).catch(function(){setChip('err','오류');});
}
function setChip(cls,msg){
  document.getElementById('pollChip').className='poll-chip '+cls;
  document.getElementById('pollMsg').textContent=msg;
}
function updateMaster(val){
  var armed=val!==0, st=armed?'armed':'disarmed';
  document.getElementById('masterCard').className='master-card '+st;
  document.getElementById('masterLabel').textContent=armed?'경비 중':'경비 해제';
  document.getElementById('masterMeta').textContent='D44 = '+val+'  (0x'+val.toString(16).toUpperCase().padStart(4,'0')+')';
  document.getElementById('masterBadge').textContent=armed?'● ARMED':'○ DISARMED';
  document.getElementById('masterSvg').innerHTML=armed
    ?'<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="M12 8v4M12 16h.01" stroke-width="2"/>'
    :'<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="M9 12l2 2 4-4"/>';
}
function updateSensors(val){
  var cnt=0;
  SENSORS.forEach(function(s){
    var on=!!((val>>s.bit)&1);
    var card=document.getElementById('sc_'+s.id);
    var pip=document.getElementById('sp_'+s.id);
    if(!card) return;
    card.className='sensor-card'+(on?' alert':'');
    pip.className='sensor-pip '+(on?'on':'off');
    pip.textContent=on?'ON':'OFF';
    if(on) cnt++;
  });
  var b=document.getElementById('alertBadge');
  cnt>0?(b.textContent=cnt+'개 감지',b.classList.add('show')):b.classList.remove('show');
}

function loadHistory(){
  fetch(ctx+'/ez_in_out/security/history')
    .then(function(r){return r.json();})
    .then(function(d){renderHistory(d.success?(d.data||[]):[]);})
    .catch(function(){renderHistory([]);});
}
function renderHistory(items){
  document.getElementById('historyCount').textContent=items.length;
  var el=document.getElementById('historyScroll');
  if(!items.length){
    el.innerHTML='<div class="empty-state"><div class="empty-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div><span class="empty-text">감지 이력이 없습니다</span></div>';
    return;
  }
  el.innerHTML=items.map(function(item){
    var dt=new Date(item.detected_at);
    var date=dt.toLocaleDateString('ko-KR',{month:'2-digit',day:'2-digit'});
    var time=dt.toLocaleTimeString('ko-KR',{hour:'2-digit',minute:'2-digit',second:'2-digit'});
    var cls=(item.status||'ON').toUpperCase()==='ON'?'on':'off';
    var icon=cls==='on'
      ?'<path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>'
      :'<path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/>';
    return '<div class="history-item">'
      +'<div class="history-ico '+cls+'"><svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="'+(cls==='on'?'var(--red)':'var(--green)')+'" stroke-width="2" stroke-linecap="round">'+icon+'</svg></div>'
      +'<div class="history-body"><div class="history-name">'+esc(item.sensor_name||'알 수 없음')+'</div><div class="history-addr">'+esc(item.sensor_addr||'—')+'</div></div>'
      +'<div class="history-right"><span class="history-badge '+cls+'">'+(cls==='on'?'감지':'해제')+'</span><div class="history-time">'+date+' '+time+'</div></div>'
      +'</div>';
  }).join('');
}

function loadEmployees(){
  fetch(ctx+'/ez_in_out/security/employees')
    .then(function(r){return r.json();})
    .then(function(d){
      if(!d.success){showEmpError();return;}
      empData=d.data||[];
      empData.forEach(function(e){
        if(e.security_yn==='Y'||e.SECURITY_YN==='Y') checkedIds[e.emp_id||e.EMP_ID]=true;
      });
      renderEmployees();
    }).catch(showEmpError);
}
function showEmpError(){
  document.getElementById('notifyList').innerHTML='<div class="empty-state"><span class="empty-text">직원 목록을 불러올 수 없습니다</span></div>';
}
function renderEmployees(){
  if(!empData.length){
    document.getElementById('notifyList').innerHTML='<div class="empty-state"><span class="empty-text">등록된 직원이 없습니다</span></div>';
    return;
  }
  var groups={};
  empData.forEach(function(e){
    var d=e.dept_name||e.DEPT_NAME||'기타';
    if(!groups[d]) groups[d]=[];
    groups[d].push(e);
  });
  document.getElementById('notifyList').innerHTML=Object.keys(groups).map(function(dept){
    return '<div class="dept-block"><div class="dept-label">'+esc(dept)+'</div>'
      +groups[dept].map(function(e){
        var id=e.emp_id||e.EMP_ID||'';
        var name=e.emp_name||e.EMP_NAME||'';
        var title=e.title_name||e.TITLE_NAME||'';
        var phone=e.mobile_no||e.MOBILE_NO||'';
        var chk=!!checkedIds[id];
        return '<div class="emp-row'+(chk?' checked':'')+'" data-id="'+esc(id)+'" onclick="toggleEmp(this)">'
          +'<div class="emp-avatar">'+esc(name?name.charAt(0):'?')+'</div>'
          +'<div class="emp-info"><div class="emp-name">'+esc(name)+'</div>'
          +'<div class="emp-meta">'+(title?'<span class="emp-tag">'+esc(title)+'</span>':'')
          +'<span style="font-family:var(--mono);font-size:9px">'+esc(phone)+'</span></div></div>'
          +'<div class="emp-toggle"></div></div>';
      }).join('')+'</div>';
  }).join('');
  updateCheckCount();
}
function toggleEmp(row){
  var id=row.dataset.id;
  if(checkedIds[id]){delete checkedIds[id];row.classList.remove('checked');}
  else{checkedIds[id]=true;row.classList.add('checked');}
  updateCheckCount();
}
function updateCheckCount(){
  var cnt=Object.keys(checkedIds).length;
  document.getElementById('checkCount').textContent=cnt;
  document.getElementById('notifyCount').textContent=cnt;
}
function saveNotify(){
  var btn=document.getElementById('btnSave'), msg=document.getElementById('saveMsg');
  btn.disabled=true; btn.textContent='저장 중...'; msg.textContent=''; msg.className='save-msg';
  var ids=Object.keys(checkedIds);
  fetch(ctx+'/ez_in_out/security/notify/save',{
    method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({empIds:ids})
  }).then(function(r){return r.json();})
  .then(function(d){
    btn.disabled=false; btn.textContent='저장하기';
    if(d.success){msg.textContent='✓ 저장 완료 ('+ids.length+'명)';msg.className='save-msg ok';}
    else{msg.textContent='저장 실패';msg.className='save-msg err';}
    setTimeout(function(){msg.textContent='';},3000);
  }).catch(function(){
    btn.disabled=false; btn.textContent='저장하기'; msg.textContent='오류 발생'; msg.className='save-msg err';
  });
}
function esc(s){return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');}

loadEmployees(); loadHistory(); setInterval(loadHistory,5000); startPolling();
</script>
</body>
</html>
