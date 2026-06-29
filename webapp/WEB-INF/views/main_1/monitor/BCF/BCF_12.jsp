
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../common_style.jsp" %>
<% String ctx = request.getContextPath(); %>
<link rel="stylesheet" href="<%= ctx %>/css/bcf12/style.css">
<link rel="stylesheet" href="<%= ctx %>/css/tabulator/tabulator.css">
<style>
/* ── BCF 탭 네비 ─────────────────────────── */
.bcf-nav {
  display: flex; gap: 6px;
  background: var(--white); border: 1px solid var(--border);
  border-radius: 12px; padding: 8px; margin-bottom: 16px;
  overflow-x: auto; box-shadow: var(--shadow);
}
.bcf-nav::-webkit-scrollbar { height: 0; }
.bcf-tab {
  flex: 1; display: flex; flex-direction: column; align-items: center; gap: 3px;
  padding: 10px 4px; border-radius: 8px;
  font-size: 11px; font-weight: 700; color: var(--muted);
  text-decoration: none; white-space: nowrap; min-width: 58px;
  border: 1px solid transparent; transition: all .15s;
}
.bcf-tab .tab-num { font-size: 15px; font-weight: 800; line-height: 1; }
.bcf-tab .tab-lbl { font-size: 9px; letter-spacing: .4px; }
.bcf-tab:hover    { background: var(--bg); color: var(--text); border-color: var(--border); }
.bcf-tab.active   {
  background: linear-gradient(135deg, var(--primary), var(--primary-d, #1a56db));
  color: #fff; border-color: transparent;
  box-shadow: 0 2px 8px rgba(37,99,235,.35);
}

/* ═══ 가로스크롤 완전 차단 ═══ */
.page-wrap { overflow-x: hidden; width: 100%; }
.group-1, .group-1 * {
  box-sizing: border-box;
  font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
}
.group-1 {
  position: relative;
  width: 100%;
  height: 878px;
  overflow: hidden;
}

/* ═══════════════════════════════════════
   오른쪽 패널
   left: 설비 끝(760px), right: 0 → 자동 채움
   ═══════════════════════════════════════ */
.bcf-right-panel {
  position: absolute;
  left:    1070px;
  top:     10px;
  right:   0;
  bottom:  0;
  display: flex;
  flex-direction: column;
  gap: 4px;
  padding: 4px 3px 4px 5px;
  overflow: hidden;
}

/* ─── 상단 행: [온도CP+경보] + [자동운전] ─── */
.bcf-top-row {
  display: flex;
  gap: 4px;
  flex: 0 0 420px;
  min-height: 0;
}

/* ─── 온도CP + 현재경보 묶음 ─── */
.bcf-left-col {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

/* ══════════════════════════════
   온도 및 CP 패널
   ══════════════════════════════ */
.bcf-temp-panel {
  border: 1.5px solid #2aada0;
  border-radius: 3px;
  overflow: hidden;
  flex-shrink: 0;
}

/* 타이틀 행 */
.tp-title {
  background: #3dbdb0;
  color: #fff;
  font-size: 11px;
  font-weight: 700;
  text-align: center;
  padding: 2px 0;
  letter-spacing: 1px;
}

/* 헤더 행: 침탄실 DT ℃ | 유조 DT ℃ | CP DT % | 침탄SP DT ℃ | 유조SP DT ℃ | CP SP DT % */
.tp-header {
  display: flex;
  align-items: stretch;
  background: #d0f0ec;
  border-top: 1px solid #2aada0;
}

/* 각 그룹 (레이블 + DT박스 + ℃박스) */
.tp-group {
  display: flex;
  align-items: center;
  gap: 2px;
  padding: 2px 3px;
  border-right: 1.5px solid #2aada0;
  flex: 1;
}
.tp-group:last-child { border-right: none; }

/* 레이블 칩 */
.tp-lbl {
  font-size: 9px;
  font-weight: 700;
  padding: 1px 3px;
  border-radius: 2px;
  white-space: nowrap;
  flex-shrink: 0;
}
.tp-lbl.red   { background: #ffcccc; color: #cc0000; border: 1px solid #cc0000; }
.tp-lbl.green { background: #cceecc; color: #006600; border: 1px solid #006600; }
.tp-lbl.blue  { background: #cce4ff; color: #003399; border: 1px solid #003399; }

/* 단위 텍스트 (DT, ℃, %) */
.tp-unit {
  font-size: 9px;
  color: #1a5c52;
  font-weight: 700;
  white-space: nowrap;
  flex-shrink: 0;
}

/* 값 박스 */
.tp-val {
  flex: 1;
  min-width: 22px;
  height: 15px;
  line-height: 15px;
  border-radius: 2px;
  background: #9ccc8d;
  border: 1px solid #6aaa50;
  font-size: 9px;
  color: #1a4000;
  text-align: center;
}
.tp-val.blue  { background: #b0d8f8; border-color: #5aadda; color: #003a5c; }
.tp-val.empty { background: #f0f0f0; border-color: #ccc; color: #aaa; }

/* ══════════════════════════════
   현재 경보
   ══════════════════════════════ */
.bcf-alarm-panel {
  flex: 1;
  border: 1.5px solid #2aada0;
  border-radius: 3px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  min-height: 0;
}
.alarm-title {
  background: #3dbdb0;
  color: #fff;
  font-size: 11px;
  font-weight: 700;
  text-align: center;
  padding: 2px 0;
  letter-spacing: 1px;
  flex-shrink: 0;
}
.alarm-body {
  flex: 1;
  background: #b8b8b8;
  border-top: 1px solid #888;
  position: relative;
}
.alarm-body::before {
  content: '';
  position: absolute;
  left: 0; top: 0; bottom: 0;
  width: 2px;
  background: #2255cc;
}

/* ══════════════════════════════
   자동운전 준비조건
   ══════════════════════════════ */
.bcf-auto-panel {
  flex: 0 0 250px;       /* ← 여기서 너비 조정 */
  display: flex;
  flex-direction: column;
  border: 1.5px solid #2aada0;
  border-radius: 3px;
  overflow: hidden;
}
.auto-title {
  background: #3dbdb0;
  color: #fff;
  font-size: 11px;
  font-weight: 700;
  text-align: center;
  padding: 2px 0;
  letter-spacing: 1px;
  flex-shrink: 0;
}
.auto-list {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 2px;
  padding: 3px;
  overflow-y: hidden;  /* 14개 꽉 채우기 */
}
.auto-item {
  flex: 1;             /* 균등 분배 → 전체 높이에 맞게 */
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 3px;
  border: 1px solid #555;
  font-size: 10px;
  font-weight: 700;
  background: #d9d9d9;
  color: #333;
  text-align: center;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  padding: 0 3px;
}
.auto-item.state-red   { background: #ff2222; color: #fff; border-color: #cc0000; }
.auto-item.state-green { background: #85c25f; color: #fff; border-color: #5a9a30; }

/* ══════════════════════════════
   존별 구간 데이터 테이블
   ══════════════════════════════ */
.bcf-zone-panel {
  border: 1.5px solid #7a9ab0;
  border-radius: 3px;
  overflow: hidden;
  flex-shrink: 0;
  height: 250px;  /* ← 원하는 높이로 조정 */
}
.bcf-zone-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 10px;
  font-family: 'Malgun Gothic', sans-serif;
  table-layout: fixed;   /* 균등 분배 */
      height: 250px;
}
.bcf-zone-table th,
.bcf-zone-table td {
  border: 1px solid #aac4d8;
  text-align: center;
  padding: 1px 1px;
  white-space: nowrap;
  overflow: hidden;
}
.bcf-zone-table thead tr:first-child th {
  background: #3dbdb0;
  color: #fff;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 1px;
  padding: 3px 0;
}
.bcf-zone-table thead tr:nth-child(2) th {
  background: #b8dde8;
  color: #1a3a5c;
  font-weight: 700;
  font-size: 10px;
  padding: 2px 0;
}
.bcf-zone-table tbody tr td { background: #fff; }
.bcf-zone-table tbody tr td.row-label {
  background: #d0e6f0;
  font-weight: 700;
  color: #1a3a5c;
  text-align: left;
  padding-left: 4px;
  width: 72px;
  font-size: 10px;
}
/* 존 값 박스 */
.zbox {
  display: block;
  width: 90%;
  margin: 0 auto;
  height: 16px;
  line-height: 16px;
  border-radius: 2px;
  background: #ffaaaa;
  border: 1px solid #e05050;
  font-size: 9px;
  color: #5a0000;
  text-align: center;
}
.zbox.yellow { background: #fffaaa; border-color: #c8c000; color: #5a5000; }
.zbox.cyan   { background: #aaeeff; border-color: #40aacc; color: #003a5c; }
.zbox.empty  { background: #f0f0f0; border-color: #ccc;    color: #aaa; }

/* ══════════════════════════════
   bcf12 존구간 테이블
   ══════════════════════════════ */
.bcf12-zone-panel {
  flex: 1;
  min-height: 0;
  border: 1.5px solid #7a9ab0;
  border-radius: 3px;
  overflow: hidden;
}
.bcf12-zone-table {
  width: 100%;
  height: 100%;
  border-collapse: collapse;
  font-size: 10px;
  font-family: 'Malgun Gothic', sans-serif;
  table-layout: fixed;
}
.bcf12-zone-table th,
.bcf12-zone-table td {
  border: 1px solid #aac4d8;
  text-align: center;
  padding: 1px;
  white-space: nowrap;
  overflow: hidden;
}
.bcf12-zone-table thead tr th {
  background: #b8dde8;
  color: #1a3a5c;
  font-weight: 700;
  font-size: 10px;
  padding: 2px 0;
}
.bcf12-zone-table thead tr th.th-empty {
  background: #e0e8f0;
  border: none;
}
.bcf12-zone-table tbody tr td { background: #fff; }
.bcf12-zone-table tbody tr td.row-label {
  background: #d0e6f0;
  font-weight: 700;
  color: #1a3a5c;
  text-align: left;
  padding-left: 4px;
  font-size: 10px;
  white-space: nowrap;
}

/* 존 값 박스 (bcf12) */
.zbox12 {
  display: block;
  width: 90%;
  margin: 1px auto;
  height: 14px;
  line-height: 14px;
  border-radius: 2px;
  background: #ffb0b0;
  border: 1px solid #e05050;
  font-size: 8px;
  color: #5a0000;
  text-align: center;
}
.zbox12.yellow      { background: #fffaaa; border-color: #c8c000; color: #5a5000; }
.zbox12.cyan        { background: #aaeeff; border-color: #40aacc; color: #003a5c; }
.zbox12.empty       { background: #eeeeee; border-color: #ccc;    color: #aaa; }
.zbox12.gas.c3h8    { background: #ffe4b0; border-color: #cc8800; color: #5a3000; }
.zbox12.gas.c3h8-sp { background: #ffd070; border-color: #b07000; color: #4a2000; }
.zbox12.gas.nh3     { background: #e8d0ff; border-color: #9060c0; color: #3a0060; }
.zbox12.gas.nh3-sp  { background: #d0b0f0; border-color: #7040a0; color: #2a0050; }
.zbox12.gas.air     { background: #c8eeff; border-color: #4090c0; color: #002850; }
.zbox12.gas.air-sp  { background: #a8d8ff; border-color: #2070a0; color: #001840; }

@keyframes blink { 50% { opacity: 0; } }
.alarm-dot {
  display: inline-block; width: 8px; height: 8px;
  background: #ff2222; border-radius: 50%; animation: blink 1s infinite;
}
</style>

<body>
<div class="page-wrap">

  <!-- BCF 탭 네비 -->
  <nav class="bcf-nav">
    <a class="bcf-tab" href="${pageContext.request.contextPath}/main_1/BCF/BCF_1" ><span class="tab-num">01</span><span class="tab-lbl">BCF</span></a>
    <a class="bcf-tab" href="${pageContext.request.contextPath}/main_1/BCF/BCF_2" ><span class="tab-num">02</span><span class="tab-lbl">BCF</span></a>
    <a class="bcf-tab" href="${pageContext.request.contextPath}/main_1/BCF/BCF_3" ><span class="tab-num">03</span><span class="tab-lbl">BCF</span></a>
    <a class="bcf-tab" href="${pageContext.request.contextPath}/main_1/BCF/BCF_4" ><span class="tab-num">04</span><span class="tab-lbl">BCF</span></a>
    <a class="bcf-tab" href="${pageContext.request.contextPath}/main_1/BCF/BCF_5" ><span class="tab-num">05</span><span class="tab-lbl">BCF</span></a>
    <a class="bcf-tab" href="${pageContext.request.contextPath}/main_1/BCF/BCF_6" ><span class="tab-num">06</span><span class="tab-lbl">BCF</span></a>
    <a class="bcf-tab" href="${pageContext.request.contextPath}/main_1/BCF/BCF_7" ><span class="tab-num">07</span><span class="tab-lbl">BCF</span></a>
    <a class="bcf-tab" href="${pageContext.request.contextPath}/main_1/BCF/BCF_8" ><span class="tab-num">08</span><span class="tab-lbl">BCF</span></a>
    <a class="bcf-tab" href="${pageContext.request.contextPath}/main_1/BCF/BCF_9" ><span class="tab-num">09</span><span class="tab-lbl">BCF</span></a>
    <a class="bcf-tab" href="${pageContext.request.contextPath}/main_1/BCF/BCF_10"><span class="tab-num">10</span><span class="tab-lbl">BCF</span></a>
    <a class="bcf-tab" href="${pageContext.request.contextPath}/main_1/BCF/BCF_11"><span class="tab-num">11</span><span class="tab-lbl">BCF</span></a>
    <a class="bcf-tab" href="${pageContext.request.contextPath}/main_1/BCF/BCF_12"><span class="tab-num">12</span><span class="tab-lbl">BCF</span></a>
  </nav>

  <div class="group-1">

    <!-- ═══ 기존 설비 작화 (변경 없음) ═══ -->
      <img class="bcf-12-1" src="<%= ctx %>/img/bcf12/bcf-12-10.png" />
      <img class="bcf-12-2" src="<%= ctx %>/img/bcf12/bcf-12-20.png" />
      <div class="bcf-12-red-1"></div>
      <img class="bcf-12-obj-1" src="<%= ctx %>/img/bcf12/bcf-12-obj-10.png" />
      <img class="bcf-12-pipe-off" src="<%= ctx %>/img/bcf12/bcf-12-pipe-off0.png" />
      <img class="bcf-12-pipe-on" src="<%= ctx %>/img/bcf12/bcf-12-pipe-on0.png" />
      <div class="bcf-12-oil"></div>
      <img class="bcf-12-elv-2" src="<%= ctx %>/img/bcf12/bcf-12-elv-20.png" />
      <img class="bcf-12-elv-1" src="<%= ctx %>/img/bcf12/bcf-12-elv-10.png" />
      <img class="bcf-12-propel-1" src="<%= ctx %>/img/bcf12/bcf-12-propel-10.png" />
      <img class="bcf-12-arrow-1" src="<%= ctx %>/img/bcf12/bcf-12-arrow-10.png" />
      <img class="bcf-12-arrow-2" src="<%= ctx %>/img/bcf12/bcf-12-arrow-20.png" />
      <img class="bcf-12-obj-2" src="<%= ctx %>/img/bcf12/bcf-12-obj-20.png" />
      <img class="bcf-12-obj-3" src="<%= ctx %>/img/bcf12/bcf-12-obj-30.png" />
      <img class="bcf-12-firepipe-off" src="<%= ctx %>/img/bcf12/bcf-12-firepipe-off0.png" />
      <img class="bcf-12-firepipe-on" src="<%= ctx %>/img/bcf12/bcf-12-firepipe-on0.png" />
      <img class="bcf-12-fire-1" src="<%= ctx %>/img/bcf12/bcf-12-fire-10.png" />
      <img class="bcf-12-phone-off-2" src="<%= ctx %>/img/bcf12/bcf-12-phone-off-20.png" />
      <img class="bcf-12-phone-on-2" src="<%= ctx %>/img/bcf12/bcf-12-phone-on-20.png" />
      <img class="bcf-12-phone-off-1" src="<%= ctx %>/img/bcf12/bcf-12-phone-off-10.png" />
      <img class="bcf-12-phone-on-1" src="<%= ctx %>/img/bcf12/bcf-12-phone-on-10.png" />
      <img class="bcf-12-obj-4" src="<%= ctx %>/img/bcf12/bcf-12-obj-40.png" />
      <img class="bcf-12-jog-gray" src="<%= ctx %>/img/bcf12/bcf-12-jog-gray0.png" />
      <img class="bcf-12-jog-red" src="<%= ctx %>/img/bcf12/bcf-12-jog-red0.png" />
      <img class="bcf-12-jog-green" src="<%= ctx %>/img/bcf12/bcf-12-jog-green0.png" />
      <img class="bcf-12-obj-5" src="<%= ctx %>/img/bcf12/bcf-12-obj-50.png" />
      <img class="bcf-12-stick-off-1" src="<%= ctx %>/img/bcf12/bcf-12-stick-off-10.png" />
      <img class="bcf-12-stick-on-1" src="<%= ctx %>/img/bcf12/bcf-12-stick-on-10.png" />
      <img class="bcf-12-stick-off-2" src="<%= ctx %>/img/bcf12/bcf-12-stick-off-20.png" />
      <img class="bcf-12-stick-on-2" src="<%= ctx %>/img/bcf12/bcf-12-stick-on-20.png" />
      <img class="bcf-12-obj-6" src="<%= ctx %>/img/bcf12/bcf-12-obj-60.png" />
      <img class="bcf-12-obj-7" src="<%= ctx %>/img/bcf12/bcf-12-obj-70.png" />
      <img class="bcf-12-obj-8" src="<%= ctx %>/img/bcf12/bcf-12-obj-80.png" />
      <img class="bcf-12-obj-9" src="<%= ctx %>/img/bcf12/bcf-12-obj-90.png" />
      <img class="bcf-12-obj-10" src="<%= ctx %>/img/bcf12/bcf-12-obj-100.png" />
      <img class="bcf-12-pen-off" src="<%= ctx %>/img/bcf12/bcf-12-pen-off0.png" />
      <img class="bcf-12-pen-on" src="<%= ctx %>/img/bcf12/bcf-12-pen-on0.png" />
      <img class="bcf-12-tray-1" src="<%= ctx %>/img/bcf12/bcf-12-tray-10.png" />
      <img class="bcf-12-tray-2" src="<%= ctx %>/img/bcf12/bcf-12-tray-20.png" />
      <img class="bcf-12-tray-3" src="<%= ctx %>/img/bcf12/bcf-12-tray-30.png" />
      <img class="bcf-12-bong-1" src="<%= ctx %>/img/bcf12/bcf-12-bong-10.png" />
      <img class="bcf-12-bong-2" src="<%= ctx %>/img/bcf12/bcf-12-bong-20.png" />
      <img class="bcf-12-bong-3" src="<%= ctx %>/img/bcf12/bcf-12-bong-30.png" />
      <img class="bcf-12-door-open-1" src="<%= ctx %>/img/bcf12/bcf-12-door-open-10.png" />
      <img class="bcf-12-door-close-1" src="<%= ctx %>/img/bcf12/bcf-12-door-close-10.png" />
      <img class="bcf-12-bong-4" src="<%= ctx %>/img/bcf12/bcf-12-bong-40.png" />
      <img class="bcf-12-bong-5" src="<%= ctx %>/img/bcf12/bcf-12-bong-50.png" />
      <img class="bcf-12-bong-6" src="<%= ctx %>/img/bcf12/bcf-12-bong-60.png" />
      <img class="bcf-12-door-close-2" src="<%= ctx %>/img/bcf12/bcf-12-door-close-20.png" />
      <img class="bcf-12-door-open-2" src="<%= ctx %>/img/bcf12/bcf-12-door-open-20.png" />
      <img class="bcf-12-door-close-3" src="<%= ctx %>/img/bcf12/bcf-12-door-close-30.png" />
      <img class="bcf-12-door-open-3" src="<%= ctx %>/img/bcf12/bcf-12-door-open-30.png" />
      <img class="bcf-12-air-cycle" src="<%= ctx %>/img/bcf12/bcf-12-air-cycle0.png" />
      <img class="bcf-12-sensor-off-1" src="<%= ctx %>/img/bcf12/bcf-12-sensor-off-10.png" />
      <img class="bcf-12-sensor-on-1" src="<%= ctx %>/img/bcf12/bcf-12-sensor-on-10.png" />
      <img class="bcf-12-sensor-off-2" src="<%= ctx %>/img/bcf12/bcf-12-sensor-off-20.png" />
      <img class="bcf-12-sensor-on-2" src="<%= ctx %>/img/bcf12/bcf-12-sensor-on-20.png" />
      <img class="bcf-12-cycle-1" src="<%= ctx %>/img/bcf12/bcf-12-cycle-10.png" />
      <img class="bcf-12-rotate-1" src="<%= ctx %>/img/bcf12/bcf-12-rotate-10.png" />
      <div class="bcf-12-jog-stop-box"></div>
      <div class="bcf-12-jog-manual-box"></div>
      <div class="bcf-12-jog-on-box"></div>
      <div class="bcf-12-1-sok-box"></div>
      <div class="bcf-12-2-sok-box"></div>
      <div class="bcf-12-3-sok-box"></div>
      <img class="bcf-12-motor-off-1" src="<%= ctx %>/img/bcf12/bcf-12-motor-off-10.png" />
      <img class="bcf-12-motor-green-1" src="<%= ctx %>/img/bcf12/bcf-12-motor-green-10.png" />
      <img class="bcf-12-motor-yellow-1" src="<%= ctx %>/img/bcf12/bcf-12-motor-yellow-10.png" />
      <img class="bcf-12-motor-off-2" src="<%= ctx %>/img/bcf12/bcf-12-motor-off-20.png" />
      <img class="bcf-12-motor-green-2" src="<%= ctx %>/img/bcf12/bcf-12-motor-green-20.png" />
      <img class="bcf-12-motor-yellow-2" src="<%= ctx %>/img/bcf12/bcf-12-motor-yellow-20.png" />
      <img class="bcf-12-alarm-1" src="<%= ctx %>/img/bcf12/bcf-12-alarm-10.png" />
      <img class="bcf-12-alarm-2" src="<%= ctx %>/img/bcf12/bcf-12-alarm-20.png" />
      <img class="bcf-12-alarm-3" src="<%= ctx %>/img/bcf12/bcf-12-alarm-30.png" />
      <img class="bcf-12-alarm-4" src="<%= ctx %>/img/bcf12/bcf-12-alarm-40.png" />
      <img class="bcf-12-alarm-5" src="<%= ctx %>/img/bcf12/bcf-12-alarm-50.png" />
      <img class="bcf-12-alarm-6" src="<%= ctx %>/img/bcf12/bcf-12-alarm-60.png" />
      <img class="bcf-12-alarm-7" src="<%= ctx %>/img/bcf12/bcf-12-alarm-70.png" />
      <img class="bcf-12-alarm-8" src="<%= ctx %>/img/bcf12/bcf-12-alarm-80.png" />
      <img class="bcf-12-alarm-9" src="<%= ctx %>/img/bcf12/bcf-12-alarm-90.png" />
      <img class="bcf-12-sensor-off-22" src="<%= ctx %>/img/bcf12/bcf-12-sensor-off-21.png" />
      <img class="bcf-12-sensor-on-22" src="<%= ctx %>/img/bcf12/bcf-12-sensor-on-21.png" />

    <!-- ═══════════════════════════════════════
         오른쪽 패널 (신규)
         ═══════════════════════════════════════ -->
    <div class="bcf-right-panel">

      <!-- 상단: [온도CP + 현재경보] + [자동운전 준비조건] -->
      <div class="bcf-top-row">

        <!-- 왼쪽: 온도CP 한줄 + 현재경보 -->
        <div class="bcf-left-col">

          <!-- 온도 및 CP: 타이틀 1행 + 헤더/값 1행 -->
          <div class="bcf-temp-panel">
            <div class="tp-title">온도 및 CP</div>
            <div class="tp-header">

              <!-- 침탄 DT ℃ -->
              <div class="tp-group">
                <span class="tp-lbl red">침탄</span>
                <span class="tp-unit">DT</span>
                <div class="tp-val" data-tag="bcf12_d1061">--</div>
                <span class="tp-unit">℃</span>
              </div>

              <!-- 유조 DT ℃ -->
              <div class="tp-group">
                <span class="tp-lbl green">유조</span>
                <span class="tp-unit">DT</span>
                <div class="tp-val" data-tag="bcf12_d1051">--</div>
                <span class="tp-unit">℃</span>
              </div>

              <!-- CP DT % -->
              <div class="tp-group">
                <span class="tp-lbl blue">CP</span>
                <span class="tp-unit">DT</span>
                <div class="tp-val blue" data-tag="bcf12_d1081">--</div>
                <span class="tp-unit">%</span>
              </div>

            </div><!-- /tp-header -->
          </div><!-- /bcf-temp-panel -->

          <!-- 현재 경보 -->
          <div class="bcf-alarm-panel">
            <div class="alarm-title">현재 경보</div>
            <div class="alarm-body"></div>
          </div>

        </div><!-- /bcf-left-col -->

        <!-- 자동운전 준비조건 (14항목) -->
        <!-- <div class="bcf-auto-panel">
          <div class="auto-title">자동운전 준비조건</div>
          <div class="auto-list">
            <div class="auto-item state-red">수동 SS</div>
            <div class="auto-item">DC POWER OFF</div>
            <div class="auto-item state-red">비상정지</div>
            <div class="auto-item state-red">베기 파이로트 OFF</div>
            <div class="auto-item state-red">입구문 커튼SW OFF</div>
            <div class="auto-item state-red">팬 정지</div>
            <div class="auto-item state-red">입구문 열림</div>
            <div class="auto-item state-red">E/V 하강</div>
            <div class="auto-item state-red">중간문 닫힘</div>
            <div class="auto-item state-red">로내롤러 자동조깅</div>
            <div class="auto-item state-red">장입 자동스탭 준비</div>
            <div class="auto-item state-red">본체 자동스탭 준비</div>
            <div class="auto-item state-red">추출 자동스탭 준비</div>
            <div class="auto-item">— 예비 —</div>
          </div>
        </div> -->

      </div><!-- /bcf-top-row -->

      <!-- BCF12 존구간 테이블 -->
      <div class="bcf12-zone-panel">
        <table class="bcf12-zone-table">
          <thead>
            <tr>
              <th class="th-empty" style="width:80px;"></th>
              <th>승온1</th>
              <th>침탄1</th>
              <th>침탄2</th>
              <th>확산1</th>
              <th>확산2</th>
              <th>강온</th>
              <th>소인</th>
              <th>냉각</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td class="row-label">시간 (min) PV</td>
              <td><div class="zbox12 bcf12_x084">--</div></td>
              <td><div class="zbox12 bcf12_x085">--</div></td>
              <td><div class="zbox12 bcf12_y135h">--</div></td>
              <td><div class="zbox12 bcf12_y0deh">--</div></td>
              <td><div class="zbox12 bcf12_y0dfh">--</div></td>
              <td><div class="zbox12 bcf12_y10dh">--</div></td>
              <td><div class="zbox12 bcf12_y130h">--</div></td>
              <td><div class="zbox12 bcf12_x08b">--</div></td>
            </tr>
            <tr>
              <td class="row-label">시간 (min) SP</td>
              <td><div class="zbox12 yellow bcf12_40024">--</div></td>
              <td><div class="zbox12 yellow bcf12_x09d">--</div></td>
              <td><div class="zbox12 yellow bcf12_x09e">--</div></td>
              <td><div class="zbox12 yellow bcf12_x080">--</div></td>
              <td><div class="zbox12 yellow bcf12_x081">--</div></td>
              <td><div class="zbox12 yellow bcf12_y100h">--</div></td>
              <td><div class="zbox12 yellow bcf12_y0d0h">--</div></td>
              <td><div class="zbox12 yellow bcf12_y0d1h">--</div></td>
            </tr>
            <tr>
              <td class="row-label">온도 (℃) PV</td>
              <td><div class="zbox12 bcf12_d1081">--</div></td>
              <td><div class="zbox12 bcf12_d1061">--</div></td>
              <td><div class="zbox12 bcf12_d1081">--</div></td>
              <td><div class="zbox12 bcf12_d1061">--</div></td>
              <td><div class="zbox12 bcf12_d1061">--</div></td>
              <td><div class="zbox12 bcf12_d1061">--</div></td>
              <td><div class="zbox12 bcf12_d1051">--</div></td>
              <td><div class="zbox12 empty"></div></td>
            </tr>
            <tr>
              <td class="row-label">온도 (℃) SP</td>
              <td><div class="zbox12 yellow bcf12_y0f5h">--</div></td>
              <td><div class="zbox12 yellow bcf12_x02b">--</div></td>
              <td><div class="zbox12 yellow bcf12_x0b7">--</div></td>
              <td><div class="zbox12 yellow bcf12_x07a">--</div></td>
              <td><div class="zbox12 yellow bcf12_x079">--</div></td>
              <td><div class="zbox12 yellow bcf12_y0f7h">--</div></td>
              <td><div class="zbox12 yellow bcf12_y0f6h">--</div></td>
              <td><div class="zbox12 empty"></div></td>
            </tr>
            <tr>
              <td class="row-label">CP (%) PV</td>
              <td><div class="zbox12 cyan bcf12_d1081">--</div></td>
              <td><div class="zbox12 cyan bcf12_d1081">--</div></td>
              <td><div class="zbox12 cyan bcf12_d1081">--</div></td>
              <td><div class="zbox12 cyan bcf12_d1081">--</div></td>
              <td><div class="zbox12 cyan bcf12_d1081">--</div></td>
              <td><div class="zbox12 cyan bcf12_d1081">--</div></td>
              <td><div class="zbox12 empty"></div></td>
              <td><div class="zbox12 empty"></div></td>
            </tr>
            <tr>
              <td class="row-label">CP (%) SP</td>
              <td><div class="zbox12 cyan bcf12_y0f5h">--</div></td>
              <td><div class="zbox12 cyan bcf12_x0b7">--</div></td>
              <td><div class="zbox12 cyan bcf12_y0d3h">--</div></td>
              <td><div class="zbox12 cyan bcf12_y0d8h">--</div></td>
              <td><div class="zbox12 cyan bcf12_x082">--</div></td>
              <td><div class="zbox12 cyan bcf12_x083">--</div></td>
              <td><div class="zbox12 empty"></div></td>
              <td><div class="zbox12 empty"></div></td>
            </tr>
            <tr>
              <td class="row-label">C3H8(%) PV</td>
              <td><div class="zbox12 gas c3h8 bcf12_d1010">--</div></td>
              <td><div class="zbox12 gas c3h8 bcf12_d1010">--</div></td>
              <td><div class="zbox12 gas c3h8 bcf12_d1010">--</div></td>
              <td><div class="zbox12 gas c3h8 bcf12_d1010">--</div></td>
              <td><div class="zbox12 gas c3h8 bcf12_d1010">--</div></td>
              <td><div class="zbox12 gas c3h8 bcf12_d1010">--</div></td>
              <td><div class="zbox12 empty"></div></td>
              <td><div class="zbox12 empty"></div></td>
            </tr>
            <tr>
              <td class="row-label">C3H8(%) SP</td>
              <td><div class="zbox12 gas c3h8-sp bcf12_y0dch">--</div></td>
              <td><div class="zbox12 gas c3h8-sp bcf12_y0d9h">--</div></td>
              <td><div class="zbox12 gas c3h8-sp bcf12_y0dah">--</div></td>
              <td><div class="zbox12 gas c3h8-sp bcf12_y0dbh">--</div></td>
              <td><div class="zbox12 gas c3h8-sp bcf12_y0ddh">--</div></td>
              <td><div class="zbox12 gas c3h8-sp bcf12_y132h">--</div></td>
              <td><div class="zbox12 empty"></div></td>
              <td><div class="zbox12 empty"></div></td>
            </tr>
            <tr>
              <td class="row-label">NH3(%) PV</td>
              <td><div class="zbox12 gas nh3 bcf12_d1020">--</div></td>
              <td><div class="zbox12 gas nh3 bcf12_d1020">--</div></td>
              <td><div class="zbox12 gas nh3 bcf12_d1020">--</div></td>
              <td><div class="zbox12 gas nh3 bcf12_d1020">--</div></td>
              <td><div class="zbox12 gas nh3 bcf12_d1020">--</div></td>
              <td><div class="zbox12 gas nh3 bcf12_d1020">--</div></td>
              <td><div class="zbox12 empty"></div></td>
              <td><div class="zbox12 empty"></div></td>
            </tr>
            <tr>
              <td class="row-label">NH3(%) SP</td>
              <td><div class="zbox12 gas nh3-sp bcf12_x07c">--</div></td>
              <td><div class="zbox12 gas nh3-sp bcf12_y10bh">--</div></td>
              <td><div class="zbox12 gas nh3-sp bcf12_x09b">--</div></td>
              <td><div class="zbox12 gas nh3-sp bcf12_x09c">--</div></td>
              <td><div class="zbox12 gas nh3-sp bcf12_x07d">--</div></td>
              <td><div class="zbox12 gas nh3-sp bcf12_y131h">--</div></td>
              <td><div class="zbox12 empty"></div></td>
              <td><div class="zbox12 empty"></div></td>
            </tr>
            <tr>
              <td class="row-label">AIR(%) PV</td>
              <td><div class="zbox12 gas air bcf12_y0d6h">--</div></td>
              <td><div class="zbox12 gas air bcf12_y0d6h">--</div></td>
              <td><div class="zbox12 gas air bcf12_y0d6h">--</div></td>
              <td><div class="zbox12 gas air bcf12_y0d6h">--</div></td>
              <td><div class="zbox12 gas air bcf12_y0d6h">--</div></td>
              <td><div class="zbox12 gas air bcf12_y0d6h">--</div></td>
              <td><div class="zbox12 empty"></div></td>
              <td><div class="zbox12 empty"></div></td>
            </tr>
            <tr>
              <td class="row-label">AIR(%) SP</td>
              <td><div class="zbox12 gas air-sp bcf12_x086">--</div></td>
              <td><div class="zbox12 gas air-sp bcf12_y134h">--</div></td>
              <td><div class="zbox12 gas air-sp bcf12_x089">--</div></td>
              <td><div class="zbox12 gas air-sp bcf12_y133h">--</div></td>
              <td><div class="zbox12 gas air-sp bcf12_x087h">--</div></td>
              <td><div class="zbox12 gas air-sp bcf12_y0d4h">--</div></td>
              <td><div class="zbox12 empty"></div></td>
              <td><div class="zbox12 empty"></div></td>
            </tr>
          </tbody>
        </table>
      </div>

    </div><!-- /bcf-right-panel -->

  </div><!-- /group-1 -->
</div><!-- /page-wrap -->

<script src="<%= ctx %>/js/tabulator/tabulator.js"></script>
<script>
(function() {
  var cur = location.pathname.split('/').pop();
  document.querySelectorAll('.bcf-tab').forEach(function(a) {
    if (a.getAttribute('href').split('/').pop() === cur) a.classList.add('active');
  });
})();

(function() {
  'use strict';
  var ctx = '<%= ctx %>';
  var INTERVAL = 3000;
  var wordElMap = {};

  document.querySelectorAll('.zbox12').forEach(function(el) {
    el.className.split(/\s+/).forEach(function(cls) {
      if (!/^bcf12_/.test(cls)) return;
      if (!wordElMap[cls]) wordElMap[cls] = [];
      wordElMap[cls].push(el);
    });
  });

  var tpElMap = {};
  document.querySelectorAll('.tp-val[data-tag]').forEach(function(el) {
    var tag = el.getAttribute('data-tag');
    if (!tpElMap[tag]) tpElMap[tag] = [];
    tpElMap[tag].push(el);
  });

  var allTags = Object.keys(wordElMap).concat(
    Object.keys(tpElMap).filter(function(t) { return !wordElMap[t]; })
  );

  function applyData(data) {
    Object.keys(wordElMap).forEach(function(tag) {
      var key = tag.replace(/^bcf12_d(\d+)$/i, 'bcf12_s_D$1');
      var val = data[key] != null ? data[key] : data[tag];
      if (val == null) return;
      var raw = Number(val);
      var text = isNaN(raw) ? val : raw.toFixed(0);
      wordElMap[tag].forEach(function(el) { el.textContent = text; });
    });
    Object.keys(tpElMap).forEach(function(tag) {
      var key = tag.replace(/^bcf12_d(\d+)$/i, 'bcf12_s_D$1');
      var val = data[key] != null ? data[key] : data[tag];
      if (val == null) return;
      var raw = Number(val);
      var text;
      if (isNaN(raw)) {
        text = val;
      } else if (tag === 'bcf12_d1081') {
        text = (raw * 0.001).toFixed(3);
      } else {
        text = raw.toFixed(0);
      }
      tpElMap[tag].forEach(function(el) { el.textContent = text; });
    });
  }

  var busy = false;
  function fetchData() {
    if (busy) return;
    busy = true;
    fetch(ctx + '/monitor/snapshot')
    .then(function(r) { return r.ok ? r.json() : Promise.reject(r.status); })
    .then(function(data) { applyData(data); })
    .catch(function(err) { console.warn('[BCF12] PLC fetch 실패:', err); })
    .finally(function() { busy = false; });
  }

  var alarmTable = new Tabulator('.alarm-body', {
    height: '100%', layout: 'fitColumns', headerVisible: false,
    placeholder: '현재 경보 없음', rowHeight: 36, data: [],
    columns: [
      { title: '', field: 'dot', width: 22, resizable: false, headerSort: false,
        formatter: function() { return '<span class="alarm-dot"></span>'; } },
      { title: '경보', field: 'alarmMsg', headerSort: false,
        formatter: function(cell) { return cell.getValue() || '알람'; } }
    ]
  });

  function fetchAlarms() {
    fetch(ctx + '/alarm/active/list?limit=200')
      .then(function(r) { return r.ok ? r.json() : []; })
      .then(function(list) {
        alarmTable.setData((Array.isArray(list) ? list : []).filter(function(a) {
          return a.plcId === 'dongwoo_12';
        }));
      })
      .catch(function() {});
  }

  fetchData(); fetchAlarms();
  setInterval(fetchData,   INTERVAL);
  setInterval(fetchAlarms, INTERVAL);
})();
</script>
</body>
</html>
