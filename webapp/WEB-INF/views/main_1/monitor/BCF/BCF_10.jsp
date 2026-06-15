
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../common_style.jsp" %>
<% String ctx = request.getContextPath(); %>
<link rel="stylesheet" href="<%= ctx %>/css/bcf1/style.css">
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
  left:    800px;
  top:     0;
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
  flex: 0 0 500px;
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
.auto-row               { flex: 1; display: flex; gap: 2px; }
.auto-item.left.active  { background: #ff0000; color: #fff; border-color: #cc0000; }
.auto-item.right.active { background: #99cc00; color: #000; border-color: #669900; }
.auto-item:not(.active) { opacity: 0.4; }

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
  font-size: 9px;
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
    <div class="bcf-1-detail">
      <div class="bcf-1">
        <img class="bcf-2-1" src="<%= ctx %>/img/bcf1/bcf-2-10.png" />
        <img class="bcf-2-2" src="<%= ctx %>/img/bcf1/bcf-2-20.png" />
      </div>
      <div class="bcf-1-red-1"></div>
      <img class="bcf-1-obj-1" src="<%= ctx %>/img/bcf1/bcf-1-obj-10.png" />
      <img class="bcf-1-pipe-off" src="<%= ctx %>/img/bcf1/bcf-1-pipe-off0.png" />
      <img class="bcf-1-pipe-on bcf10_131" src="<%= ctx %>/img/bcf1/bcf-1-pipe-on0.png" />
      <div class="bcf-oil bcf10_12"></div>
      <img class="bcf-1-elv-2" src="<%= ctx %>/img/bcf1/bcf-1-elv-20.png" />
      <img class="bcf-1-elv-1" src="<%= ctx %>/img/bcf1/bcf-1-elv-10.png" />
      <img class="bcf-1-propel-1" src="<%= ctx %>/img/bcf1/bcf-1-propel-10.png" />
      <img class="bcf-1-arrow bcf10_38 bcf10_4" src="<%= ctx %>/img/bcf1/bcf-1-arrow0.png" />
      <img class="bcf-1-obj-2" src="<%= ctx %>/img/bcf1/bcf-1-obj-20.png" />
      <img class="bcf-1-obj-3" src="<%= ctx %>/img/bcf1/bcf-1-obj-30.png" />
      <img class="bcf-1-firepipe-off bcf10_29" src="<%= ctx %>/img/bcf1/bcf-1-firepipe-off0.png" />
      <img class="bcf-1-firepipe-on  bcf10_29" src="<%= ctx %>/img/bcf1/bcf-1-firepipe-on0.png" />
      <img class="bcf-1-phone-off-2" src="<%= ctx %>/img/bcf1/bcf-1-phone-off-20.png" />
      <img class="bcf-1-phone-on-2 bcf10_14" src="<%= ctx %>/img/bcf1/bcf-1-phone-on-20.png" />
      <img class="bcf-1-phone-off-1" src="<%= ctx %>/img/bcf1/bcf-1-phone-off-10.png" />
      <img class="bcf-1-phone-on-1 bcf10_13" src="<%= ctx %>/img/bcf1/bcf-1-phone-on-10.png" />
      <img class="bcf-1-obj-4" src="<%= ctx %>/img/bcf1/bcf-1-obj-40.png" />
      <img class="bcf-1-jog-gray" src="<%= ctx %>/img/bcf1/bcf-1-jog-gray0.png" />
      <img class="bcf-1-jog-red" src="<%= ctx %>/img/bcf1/bcf-1-jog-red0.png" />
      <img class="bcf-1-jog-green" src="<%= ctx %>/img/bcf1/bcf-1-jog-green0.png" />
      <img class="bcf-1-obj-5" src="<%= ctx %>/img/bcf1/bcf-1-obj-50.png" />
      <img class="bcf-1-stick-off-1 bcf10_132" src="<%= ctx %>/img/bcf1/bcf-1-stick-off-10.png" />
      <img class="bcf-1-stick-on-1 bcf10_132" src="<%= ctx %>/img/bcf1/bcf-1-stick-on-10.png" />
      <img class="bcf-1-stick-off-2 bcf10_132" src="<%= ctx %>/img/bcf1/bcf-1-stick-off-20.png" />
      <img class="bcf-1-stick-on-2 bcf10_132" src="<%= ctx %>/img/bcf1/bcf-1-stick-on-20.png" />
      <img class="bcf-1-obj-6" src="<%= ctx %>/img/bcf1/bcf-1-obj-60.png" />
      <img class="bcf-1-obj-7" src="<%= ctx %>/img/bcf1/bcf-1-obj-70.png" />
      <img class="bcf-1-motor-off" src="<%= ctx %>/img/bcf1/bcf-1-motor-off0.png" />
      <img class="bcf-1-motor-on bcf10_46" src="<%= ctx %>/img/bcf1/bcf-1-motor-on0.png" />
      <img class="bcf-1-pen-off" src="<%= ctx %>/img/bcf1/bcf-1-pen-off0.png" />
      <img class="bcf-1-pen-on bcf10_22" src="<%= ctx %>/img/bcf1/bcf-1-pen-on0.png" />
      <img class="bcf-1-tray-1 bcf10_51" src="<%= ctx %>/img/bcf1/bcf-1-tray-10.png" />
      <img class="bcf-1-tray-2 bcf10_3" src="<%= ctx %>/img/bcf1/bcf-1-tray-20.png" />
      <img class="bcf-1-tray-3" src="<%= ctx %>/img/bcf1/bcf-1-tray-30.png" />
      <img class="bcf-1-bong-1" src="<%= ctx %>/img/bcf1/bcf-1-bong-10.png" />
      <img class="bcf-1-bong-2 bcf10_34" src="<%= ctx %>/img/bcf1/bcf-1-bong-20.png" />
      <img class="bcf-1-bong-3 bcf10_33" src="<%= ctx %>/img/bcf1/bcf-1-bong-30.png" />
      <img class="bcf-1-door-open-1  bcf10_2" src="<%= ctx %>/img/bcf1/bcf-1-door-open-10.png" />
      <img class="bcf-1-door-close-1  bcf10_2" src="<%= ctx %>/img/bcf1/bcf-1-door-close-10.png" />
      <img class="bcf-1-bong-4" src="<%= ctx %>/img/bcf1/bcf-1-bong-40.png" />
      <img class="bcf-1-bong-5 bcf10_2" src="<%= ctx %>/img/bcf1/bcf-1-bong-50.png" />
      <img class="bcf-1-bong-6 bcf10_2" src="<%= ctx %>/img/bcf1/bcf-1-bong-60.png" />
      <img class="bcf-1-door-close-2" src="<%= ctx %>/img/bcf1/bcf-1-door-close-20.png" />
      <img class="bcf-1-door-open-2" src="<%= ctx %>/img/bcf1/bcf-1-door-open-20.png" />
      <img class="bcf-1-air-cycle bcf10_60" src="<%= ctx %>/img/bcf1/bcf-1-air-cycle0.png" />
      <img class="bcf-1-sensor-off-1" src="<%= ctx %>/img/bcf1/bcf-1-sensor-off-10.png" />
      <img class="bcf-1-sensor-on-1 bcf10_9" src="<%= ctx %>/img/bcf1/bcf-1-sensor-on-10.png" />
      <img class="bcf-1-sensor-off-2" src="<%= ctx %>/img/bcf1/bcf-1-sensor-off-20.png" />
      <img class="bcf-1-sensor-on-2" src="<%= ctx %>/img/bcf1/bcf-1-sensor-on-20.png" />
      <img class="bcf-1-cycle bcf10_39 bcf10_40" src="<%= ctx %>/img/bcf1/bcf-1-cycle0.png" />
      <img class="bcf-1-rotate-1 bcf10_" src="<%= ctx %>/img/bcf1/bcf-1-rotate-10.png" />
      <img class="bcf-1-rotate-2 bcf10_" src="<%= ctx %>/img/bcf1/bcf-1-rotate-20.png" />
      <img class="bcf-1-rotate-3 bcf10_39 bcf10_40" src="<%= ctx %>/img/bcf1/bcf-1-rotate-30.png" />
      <img class="bcf-1-alarm-1 bcf10_74" src="<%= ctx %>/img/bcf1/bcf-1-alarm-10.png" />
      <img class="bcf-1-alarm-2 bcf10_85" src="<%= ctx %>/img/bcf1/bcf-1-alarm-20.png" />
      <img class="bcf-1-alarm-3 bcf10_76" src="<%= ctx %>/img/bcf1/bcf-1-alarm-30.png" />
      <img class="bcf-1-alarm-4 bcf10_90" src="<%= ctx %>/img/bcf1/bcf-1-alarm-40.png" />
      <img class="bcf-1-alarm-5 bcf10_88" src="<%= ctx %>/img/bcf1/bcf-1-alarm-50.png" />
      <img class="bcf-1-alarm-6 bcf10_66" src="<%= ctx %>/img/bcf1/bcf-1-alarm-60.png" />
      <img class="bcf-1-alarm-7 bcf10_67" src="<%= ctx %>/img/bcf1/bcf-1-alarm-70.png" />
      <img class="bcf-1-alarm-8 bcf10_79" src="<%= ctx %>/img/bcf1/bcf-1-alarm-80.png" />
      <img class="bcf-1-alarm-9 bcf10_69" src="<%= ctx %>/img/bcf1/bcf-1-alarm-90.png" />
      <img class="bcf-1-alarm-10 bcf10_81" src="<%= ctx %>/img/bcf1/bcf-1-alarm-100.png" />
      <img class="bcf-1-alarm-11 bcf10_80" src="<%= ctx %>/img/bcf1/bcf-1-alarm-110.png" />
      <img class="bcf-1-alarm-12 bcf10_72" src="<%= ctx %>/img/bcf1/bcf-1-alarm-120.png" />
      <img class="bcf-1-alarm-13 bcf10_83" src="<%= ctx %>/img/bcf1/bcf-1-alarm-130.png" />
      <img class="bcf-1-alarm-14 bcf10_71" src="<%= ctx %>/img/bcf1/bcf-1-alarm-140.png" />
      <img class="bcf-1-enrich-gray bcf10_139" src="<%= ctx %>/img/bcf1/bcf-1-enrich-gray0.png" />
      <img class="bcf-1-enrich-red" src="<%= ctx %>/img/bcf1/bcf-1-enrich-red0.png" />
      <img class="bcf-1-enrich-green bcf10_27" src="<%= ctx %>/img/bcf1/bcf-1-enrich-green0.png" />
      <img class="bcf-1-amm-gray bcf10_141" src="<%= ctx %>/img/bcf1/bcf-1-amm-gray0.png" />
      <img class="bcf-1-amm-red" src="<%= ctx %>/img/bcf1/bcf-1-amm-red0.png" />
      <img class="bcf-1-amm-green bcf10_28" src="<%= ctx %>/img/bcf1/bcf-1-amm-green0.png" />
      <div class="bcf-1-enrich-off-box bcf10_138"></div>
      <div class="bcf-1-enrich-on-box bcf10_139"></div>
      <div class="bcf-1-amm-off-box  bcf10_140"></div>
      <div class="bcf-1-amm-on-box bcf10_141"></div>
      <div class="bcf-1-jog-stop-box"></div>
      <div class="bcf-1-jog-manual-box bcf10_57 bcf10_59"></div>
      <div class="bcf-1-jog-on-box bcf10_56 bcf10_58"></div>
      <div class="bcf-1-stop-box-1"></div>
      <div class="bcf-1-manual-box-1 bcf10_136"></div>
      <div class="bcf-1-auto-box-1 bcf10_137"></div>
      <div class="bcf-1-stop-box-2"></div>
      <div class="bcf-1-manual-box-2 bcf10_134"></div>
      <div class="bcf-1-auto-box-2"></div>
      <div class="bcf-1-1-sok-box bcf10_41"></div>
      <div class="bcf-1-2-sok-box bcf10_48"></div>
      <div class="bcf-1-3-sok-box bcf10_49"></div>
      <div class="bcf-1-dt-2 bcf10_3"></div>
      <div class="bcf-1-dt-1 bcf10_51"></div>
      <div class="bcf-1-ro-on bcf10_52"></div>
      <div class="bcf-1-ro-off"></div>
      <div class="bcf-1-dt-3"></div>
      <div class="bcf-1-flamesw-box bcf10_17"></div>
      <div class="bcf-1-flame-box bcf10_18"></div>
      <div class="bcf-1-fire-box bcf10_16"></div>
      <img class="bcf-1-fire-1 bcf10_30" src="<%= ctx %>/img/bcf1/bcf-1-fire-10.png" />
      <img class="bcf-1-fire-2  bcf10_16" src="<%= ctx %>/img/bcf1/bcf-1-fire-20.png" />
    </div>

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

              <!-- 침탄실 ℃ -->
              <div class="tp-group">
                <span class="tp-lbl red">침탄실</span>
                <div class="tp-val bcf10_40046">--</div>
                <span class="tp-unit">℃</span>
              </div>

              <!-- 유조 ℃ -->
              <div class="tp-group">
                <span class="tp-lbl green">유조</span>
                <div class="tp-val bcf10_40047">--</div>
                <span class="tp-unit">℃</span>
              </div>

              <!-- CP % -->
              <div class="tp-group">
                <span class="tp-lbl blue">CP</span>
                <div class="tp-val blue bcf10_40052">--</div>
                <span class="tp-unit">%</span>
              </div>

              <!-- 침탄SP ℃ -->
              <div class="tp-group">
                <span class="tp-lbl red">침탄SP</span>
                <div class="tp-val bcf10_40069">--</div>
                <span class="tp-unit">℃</span>
              </div>

              <!-- 유조SP ℃ -->
              <div class="tp-group">
                <span class="tp-lbl green">유조SP</span>
                <div class="tp-val bcf10_40070">--</div>
                <span class="tp-unit">℃</span>
              </div>

              <!-- CPSP % -->
              <div class="tp-group">
                <span class="tp-lbl blue">CP SP</span>
                <div class="tp-val blue bcf10_40071">--</div>
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
        <div class="bcf-auto-panel">
          <div class="auto-title">자동운전 준비조건</div>
          <div class="auto-list">
            <div class="auto-row">
              <div class="auto-item left active" data-tag="bcf10_25" data-side="left">수동 SS</div>
              <div class="auto-item right"        data-tag="bcf10_25" data-side="right">자동 SS</div>
            </div>
            <div class="auto-row">
              <div class="auto-item left active" data-tag="bcf10_20" data-side="left">DC POWER OFF</div>
              <div class="auto-item right"        data-tag="bcf10_20" data-side="right">DC POWER ON</div>
            </div>
            <div class="auto-row">
              <div class="auto-item left active" data-tag="bcf10_19" data-side="left">비상정지</div>
              <div class="auto-item right"        data-tag="bcf10_19" data-side="right">비상정지 해제</div>
            </div>
            <div class="auto-row">
              <div class="auto-item left active" data-tag="bcf10_15" data-side="left">배기 파이로트 OFF</div>
              <div class="auto-item right"        data-tag="bcf10_15" data-side="right">배기 파이로트 ON</div>
            </div>
            <div class="auto-row">
              <div class="auto-item left active" data-tag="bcf10_18" data-side="left">입구문 파이로트 OFF</div>
              <div class="auto-item right"        data-tag="bcf10_18" data-side="right">입구문 파이로트 ON</div>
            </div>
            <div class="auto-row">
              <div class="auto-item left active" data-tag="bcf10_17" data-side="left">입구문 커튼SW OFF</div>
              <div class="auto-item right"        data-tag="bcf10_17" data-side="right">입구문 커튼SW ON</div>
            </div>
            <div class="auto-row">
              <div class="auto-item left active" data-tag="bcf10_22" data-side="left">팬 정지</div>
              <div class="auto-item right"        data-tag="bcf10_22" data-side="right">팬 가동</div>
            </div>
            <div class="auto-row">
              <div class="auto-item left active" data-tag="bcf10_1" data-side="left">입구문 열림</div>
              <div class="auto-item right"        data-tag="bcf10_1" data-side="right">입구문 닫힘</div>
            </div>
            <div class="auto-row">
              <div class="auto-item left active" data-tag="bcf10_4" data-side="left">E/V 하강</div>
              <div class="auto-item right"        data-tag="bcf10_4" data-side="right">E/V 상승</div>
            </div>
            <div class="auto-row">
              <div class="auto-item left active" data-tag="bcf10_7" data-side="left">중간문 열림</div>
              <div class="auto-item right"        data-tag="bcf10_7" data-side="right">중간문 닫힘</div>
            </div>
            <div class="auto-row">
              <div class="auto-item left active" data-tag="bcf10_10" data-side="left">로내롤러 자동조깅 OFF</div>
              <div class="auto-item right"        data-tag="bcf10_10" data-side="right">로내롤러 자동조깅 ON</div>
            </div>
            <div class="auto-row">
              <div class="auto-item left active" data-tag="bcf10_53" data-side="left">장입 자동스텝 미준비</div>
              <div class="auto-item right"        data-tag="bcf10_53" data-side="right">장입 자동스텝 준비</div>
            </div>
            <div class="auto-row">
              <div class="auto-item left active" data-tag="bcf10_54" data-side="left">본체 자동스텝 미준비</div>
              <div class="auto-item right"        data-tag="bcf10_54" data-side="right">본체 자동스텝 준비</div>
            </div>
            <div class="auto-row">
              <div class="auto-item left active" data-tag="bcf10_55" data-side="left">추출 자동스텝 미준비</div>
              <div class="auto-item right"        data-tag="bcf10_55" data-side="right">추출 자동스텝 준비</div>
            </div>
          </div>
        </div>

      </div><!-- /bcf-top-row -->

      <!-- 존별 구간 데이터 테이블 -->
      <div class="bcf-zone-panel">
        <table class="bcf-zone-table">
          <thead>
            <tr>
              <th rowspan="2" style="width:72px; font-size:10px;">구분</th>
              <th colspan="2">승온1</th>
              <th colspan="2">승온2</th>
              <th colspan="2">침탄1</th>
              <th colspan="2">침탄2</th>
              <th colspan="2">확산1</th>
              <th colspan="2">확산2</th>
              <th colspan="2">강온</th>
              <th colspan="2">로냉</th>
              <th colspan="2">드레인</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td class="row-label">시간(min) PV</td>
              <td colspan="2"><div class="zbox bcf10_40015">--</div></td>
              <td colspan="2"><div class="zbox bcf10_40016">--</div></td>
              <td colspan="2"><div class="zbox bcf10_40017">--</div></td>
              <td colspan="2"><div class="zbox bcf10_40018">--</div></td>
              <td colspan="2"><div class="zbox bcf10_40019">--</div></td>
              <td colspan="2"><div class="zbox bcf10_40020">--</div></td>
              <td colspan="2"><div class="zbox bcf10_40021">--</div></td>
              <td colspan="2"><div class="zbox bcf10_40023">--</div></td>
              <td colspan="2"><div class="zbox bcf10_40025">--</div></td>
            </tr>
            <tr>
              <td class="row-label">시간(min) SP</td>
              <td colspan="2"><div class="zbox yellow bcf10_40028">--</div></td>
              <td colspan="2"><div class="zbox yellow bcf10_40029">--</div></td>
              <td colspan="2"><div class="zbox yellow bcf10_40030">--</div></td>
              <td colspan="2"><div class="zbox yellow bcf10_40031">--</div></td>
              <td colspan="2"><div class="zbox yellow bcf10_40032">--</div></td>
              <td colspan="2"><div class="zbox yellow bcf10_40033">--</div></td>
              <td colspan="2"><div class="zbox yellow bcf10_40034">--</div></td>
              <td colspan="2"><div class="zbox yellow bcf10_40035">--</div></td>
              <td colspan="2"><div class="zbox yellow bcf10_40036">--</div></td>
            </tr>
            <tr>
              <td class="row-label">온도(℃) PV</td>
              <td colspan="2"><div class="zbox bcf10_40046">--</div></td>
              <td colspan="2"><div class="zbox bcf10_40046">--</div></td>
              <td colspan="2"><div class="zbox bcf10_40046">--</div></td>
              <td colspan="2"><div class="zbox bcf10_40046">--</div></td>
              <td colspan="2"><div class="zbox bcf10_40046">--</div></td>
              <td colspan="2"><div class="zbox bcf10_40046">--</div></td>
              <td colspan="2"><div class="zbox bcf10_40046">--</div></td>
              <td colspan="2"><div class="zbox bcf10_40047">--</div></td>
              <td colspan="2"><div class="zbox bcf10_40047">--</div></td>
            </tr>
            <tr>
              <td class="row-label">온도(℃) SP</td>
              <td colspan="2"><div class="zbox yellow bcf10_40038">--</div></td>
              <td colspan="2"><div class="zbox yellow bcf10_40039">--</div></td>
              <td colspan="2"><div class="zbox yellow bcf10_40040">--</div></td>
              <td colspan="2"><div class="zbox yellow bcf10_40041">--</div></td>
              <td colspan="2"><div class="zbox yellow bcf10_40042">--</div></td>
              <td colspan="2"><div class="zbox yellow bcf10_40043">--</div></td>
              <td colspan="2"><div class="zbox yellow bcf10_40044">--</div></td>
              <td colspan="2"><div class="zbox yellow bcf10_40070">--</div></td>
              <td colspan="2"><div class="zbox yellow bcf10_40070">--</div></td>
            </tr>
            <tr>
              <td class="row-label">CP(%) PV</td>
              <td colspan="2"><div class="zbox empty"></div></td>
              <td colspan="2"><div class="zbox empty"></div></td>
              <td colspan="2"><div class="zbox cyan bcf10_40052">--</div></td>
              <td colspan="2"><div class="zbox cyan bcf10_40052">--</div></td>
              <td colspan="2"><div class="zbox cyan bcf10_40052">--</div></td>
              <td colspan="2"><div class="zbox cyan bcf10_40052">--</div></td>
              <td colspan="2"><div class="zbox empty"></div></td>
              <td colspan="2"><div class="zbox empty"></div></td>
              <td colspan="2"><div class="zbox empty"></div></td>
            </tr>
            <tr>
              <td class="row-label">CP(%) SP</td>
              <td colspan="2"><div class="zbox empty"></div></td>
              <td colspan="2"><div class="zbox empty"></div></td>
              <td colspan="2"><div class="zbox cyan bcf10_40048">--</div></td>
              <td colspan="2"><div class="zbox cyan bcf10_40049">--</div></td>
              <td colspan="2"><div class="zbox cyan bcf10_40050">--</div></td>
              <td colspan="2"><div class="zbox cyan bcf10_40051">--</div></td>
              <td colspan="2"><div class="zbox empty"></div></td>
              <td colspan="2"><div class="zbox empty"></div></td>
              <td colspan="2"><div class="zbox empty"></div></td>
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
  var bitElMap = {}, wordElMap = {};

  document.querySelectorAll('[class]').forEach(function(el) {
    el.className.split(/\s+/).forEach(function(cls) {
      var mLow = cls.match(/^bcf10_(\d+)$/);
      if (mLow) {
        if (parseInt(mLow[1], 10) >= 40000) {
          var apiTag = 'bcf10_s_' + mLow[1];
          if (!wordElMap[apiTag]) wordElMap[apiTag] = [];
          wordElMap[apiTag].push(el);
        } else {
          if (!bitElMap[cls]) bitElMap[cls] = [];
          bitElMap[cls].push(el);
        }
      }
    });
  });

  /* 자동운전 준비조건 left/right 쌍 */
  var autoElMap = {};
  document.querySelectorAll('[data-tag][data-side]').forEach(function(el) {
    var tag  = el.getAttribute('data-tag');
    var side = el.getAttribute('data-side');
    if (!autoElMap[tag]) autoElMap[tag] = {};
    autoElMap[tag][side] = el;
  });

  var allTags = Object.keys(wordElMap).concat(Object.keys(bitElMap));
  Object.keys(autoElMap).forEach(function(tag) {
    if (allTags.indexOf(tag) === -1) allTags.push(tag);
  });

  /* CP 값: ×0.001 스케일링 */
  var CP_TAG = /_(40048|40049|40050|40051|40052|40071)$/;

  function applyData(data) {
    Object.keys(wordElMap).forEach(function(tag) {
      if (data[tag] == null) return;
      var raw = Number(data[tag]);
      var text;
      if (isNaN(raw)) {
        text = data[tag];
      } else if (CP_TAG.test(tag)) {
        text = (raw * 0.001).toFixed(3);
      } else {
        text = raw.toFixed(0);
      }
      wordElMap[tag].forEach(function(el) { el.textContent = text; });
    });
    Object.keys(bitElMap).forEach(function(tag) {
      if (data[tag] == null) return;
      var isOn = (data[tag] === 1 || data[tag] === true);
      bitElMap[tag].forEach(function(el) { el.style.visibility = isOn ? 'visible' : 'hidden'; });
    });
    Object.keys(autoElMap).forEach(function(tag) {
      if (data[tag] == null) return;
      var isOn = (data[tag] === 1 || data[tag] === true);
      var pair = autoElMap[tag];
      if (pair.left)  pair.left.classList.toggle('active',  !isOn);
      if (pair.right) pair.right.classList.toggle('active',  isOn);
    });
  }

  var busy = false;
  function fetchData() {
    if (busy) return;
    busy = true;
    fetch(ctx + '/monitor/snapshot')
    .then(function(r) { return r.ok ? r.json() : Promise.reject(r.status); })
    .then(function(data) { applyData(data); })
    .catch(function(err) { console.warn('[BCF10] PLC fetch 실패:', err); })
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
          return a.plcId === 'dongwoo_10';
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
