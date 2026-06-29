
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../common_style.jsp" %>
<% String ctx = request.getContextPath(); %>
<link rel="stylesheet" href="<%= ctx %>/css/bcf1/style.css">
<link rel="stylesheet" href="<%= ctx %>/css/tabulator/tabulator.css">
<style>
/* ── 불 이미지 위치 ─────────────────────── */
.bcf-1-fire-1 { left: 155.36px; top: 86.95px; }
.bcf-1-fire-2 { left: 60.04px;  top: 394.47px; }

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

/* 2행 그리드: [구분 | 침탄실 | 유조 | CP] × [헤더, PV행, SP행] */
.tp-grid {
  display: grid;
  grid-template-columns: 28px 1fr 1fr 1fr;
  border-top: 1px solid #2aada0;
}

/* 코너 + 컬럼 헤더 */
.tp-corner {
  background: #1f9086;
  border-right: 1px solid #2aada0;
  border-bottom: 1px solid #2aada0;
}
.tp-ch-cell {
  display: flex; align-items: center; justify-content: center; gap: 3px;
  padding: 5px 3px;
  background: #b8e8e2;
  border-right: 1px solid #2aada0;
  border-bottom: 1px solid #2aada0;
  font-size: 11px; font-weight: 700; color: #0d4a44;
}
.tp-ch-cell:last-child { border-right: none; }

/* 레이블 칩 */
.tp-lbl {
  font-size: 10px; font-weight: 700;
  padding: 1px 4px; border-radius: 2px; white-space: nowrap;
}
.tp-lbl.red   { background: #ffcccc; color: #cc0000; border: 1px solid #cc0000; }
.tp-lbl.green { background: #cceecc; color: #006600; border: 1px solid #006600; }
.tp-lbl.blue  { background: #cce4ff; color: #003399; border: 1px solid #003399; }

/* 단위 텍스트 */
.tp-unit { font-size: 10px; color: #1a5c52; font-weight: 700; }

/* 행 레이블 (PV / SP) */
.tp-row-label {
  background: #2aada0; color: #fff;
  font-size: 10px; font-weight: 700;
  display: flex; align-items: center; justify-content: center;
  border-right: 1px solid #2aada0; border-bottom: 1px solid #2aada0;
}
.tp-row-label.tp-last-row { border-bottom: none; }

/* 데이터 셀 */
.tp-dc {
  display: flex; align-items: center; justify-content: center;
  padding: 4px 5px;
  background: #e8f8f5;
  border-right: 1px solid #2aada0; border-bottom: 1px solid #2aada0;
}
.tp-dc.tp-last-col  { border-right: none; }
.tp-dc.tp-last-row  { border-bottom: none; background: #d8f0ed; }

/* 값 박스 */
.tp-val {
  width: 100%; height: 22px; line-height: 22px;
  border-radius: 3px; text-align: center;
  font-size: 13px; font-weight: 700;
  background: #9ccc8d; border: 1.5px solid #6aaa50; color: #1a4000;
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
  min-height: 0;
  border-top: 1px solid #a0bce8;
  overflow: hidden;
  position: relative;
}
.alarm-body .tabulator,
.alarm-body .tabulator-tableHolder { background: #eef5ff; border: none; }
.alarm-body .tabulator-row,
.alarm-body .tabulator-row.tabulator-row-even { background: #eef5ff; border-bottom: 1px solid #d5e5fc; min-height: 52px; }
.alarm-body .tabulator-row:hover { background: #dde9ff !important; }
.alarm-body .tabulator-cell { border-right: none; padding: 5px 6px; color: #001040; font-family: '맑은 고딕','Malgun Gothic',sans-serif; font-size: 15px; font-weight: 700; white-space: normal; word-break: break-word; line-height: 1.35; align-items: flex-start; overflow: hidden; }
.alarm-body .tabulator-placeholder span { background: #eef5ff; color: #0033aa; font-family: '맑은 고딕','Malgun Gothic',sans-serif; font-size: 13px; }
.alarm-dot { display: inline-block; width: 10px; height: 10px; border-radius: 50%; background: #2255cc; vertical-align: middle; animation: alarm-pulse 1.2s ease-in-out infinite; }
.alarm-time-val { color: #0033aa; font-size: 14px; font-weight: 700; letter-spacing: .3px; font-variant-numeric: tabular-nums; }
@keyframes alarm-pulse {
  0%, 100% { opacity: 1;   box-shadow: 0 0 5px #2255cc; }
  50%       { opacity: 0.25; box-shadow: none; }
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
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
  border: 1.5px solid #555;
  font-family: '맑은 고딕', 'Malgun Gothic', sans-serif;
  font-size: 13px;
  font-weight: 900;
  background: #d9d9d9;
  color: #333;
  text-align: center;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  padding: 0 4px;
  letter-spacing: .3px;
  text-shadow: 0 1px 2px rgba(0,0,0,.22);
}
.auto-item.state-red   { background: #FF3333; color: #fff; border-color: #CC0000; box-shadow: inset 0 -2px 0 rgba(0,0,0,.2); }
.auto-item.state-green { background: #66CC33; color: #fff; border-color: #44AA11; box-shadow: inset 0 -2px 0 rgba(0,0,0,.2); }
.auto-item.state-gray  { background: #B0B0B0; color: #fff; border-color: #888;    box-shadow: inset 0 -2px 0 rgba(0,0,0,.15); }

/* ══════════════════════════════
   존별 구간 데이터 테이블
   ══════════════════════════════ */
.bcf-zone-panel {
  border: 1.5px solid #7a9ab0;
  border-radius: 4px;
  overflow: hidden;
  flex-shrink: 0;
  height: 250px;
}
.bcf-zone-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 12px;
  font-family: 'Malgun Gothic', sans-serif;
  table-layout: fixed;
  height: 250px;
}
.bcf-zone-table th,
.bcf-zone-table td {
  border: 1px solid #90b8d0;
  text-align: center;
  padding: 2px 2px;
  white-space: nowrap;
  overflow: hidden;
}
.bcf-zone-table thead tr:first-child th {
  background: #2a9d91;
  color: #fff;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: .8px;
  padding: 5px 0;
}
.bcf-zone-table thead tr:nth-child(2) th {
  background: #a0cfdf;
  color: #0d2a42;
  font-weight: 700;
  font-size: 11px;
  padding: 3px 0;
}
.bcf-zone-table tbody tr td { background: #fff; }
.bcf-zone-table tbody tr td.row-label {
  background: #c0d8ec;
  font-weight: 700;
  color: #0d2a42;
  text-align: left;
  padding-left: 6px;
  width: 80px;
  font-size: 10px;
}
/* 존 값 박스 */
.zbox {
  display: block;
  width: 92%;
  margin: 1px auto;
  height: 24px;
  line-height: 24px;
  border-radius: 3px;
  background: #ffbbbb;
  border: 1.5px solid #d04040;
  font-size: 12px;
  font-weight: 700;
  color: #4a0000;
  text-align: center;
}
.zbox.yellow { background: #fffcc0; border-color: #b0a000; color: #3a3000; }
.zbox.cyan   { background: #b8eeff; border-color: #30a0cc; color: #002a44; }
.zbox.empty  { background: #f4f4f4; border-color: #ccc;    color: #aaa;    font-weight: 400; }
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
      <img class="bcf-1-pipe-on bcf2_131" src="<%= ctx %>/img/bcf1/bcf-1-pipe-on0.png" />
      <div class="bcf-oil bcf2_12"></div>
      <img class="bcf-1-elv-2" src="<%= ctx %>/img/bcf1/bcf-1-elv-20.png" />
      <img class="bcf-1-elv-1" src="<%= ctx %>/img/bcf1/bcf-1-elv-10.png" />
      <img class="bcf-1-propel-1" src="<%= ctx %>/img/bcf1/bcf-1-propel-10.png" />
      <img class="bcf-1-arrow bcf2_38 bcf2_4" src="<%= ctx %>/img/bcf1/bcf-1-arrow0.png" />
      <img class="bcf-1-obj-2" src="<%= ctx %>/img/bcf1/bcf-1-obj-20.png" />
      <img class="bcf-1-obj-3" src="<%= ctx %>/img/bcf1/bcf-1-obj-30.png" />
      <img class="bcf-1-firepipe-off bcf2_29" src="<%= ctx %>/img/bcf1/bcf-1-firepipe-off0.png" />
      <img class="bcf-1-firepipe-on  bcf2_29" src="<%= ctx %>/img/bcf1/bcf-1-firepipe-on0.png" />
      <img class="bcf-1-phone-off-2" src="<%= ctx %>/img/bcf1/bcf-1-phone-off-20.png" />
      <img class="bcf-1-phone-on-2 bcf2_14" src="<%= ctx %>/img/bcf1/bcf-1-phone-on-20.png" />
      <img class="bcf-1-phone-off-1" src="<%= ctx %>/img/bcf1/bcf-1-phone-off-10.png" />
      <img class="bcf-1-phone-on-1 bcf2_13" src="<%= ctx %>/img/bcf1/bcf-1-phone-on-10.png" />
      <img class="bcf-1-obj-4" src="<%= ctx %>/img/bcf1/bcf-1-obj-40.png" />
      <img class="bcf-1-jog-gray" src="<%= ctx %>/img/bcf1/bcf-1-jog-gray0.png" />
      <img class="bcf-1-jog-red" src="<%= ctx %>/img/bcf1/bcf-1-jog-red0.png" />
      <img class="bcf-1-jog-green" src="<%= ctx %>/img/bcf1/bcf-1-jog-green0.png" />
      <img class="bcf-1-obj-5" src="<%= ctx %>/img/bcf1/bcf-1-obj-50.png" />
      <img class="bcf-1-stick-off-1 bcf2_132" src="<%= ctx %>/img/bcf1/bcf-1-stick-off-10.png" />
      <img class="bcf-1-stick-on-1 bcf2_132" src="<%= ctx %>/img/bcf1/bcf-1-stick-on-10.png" />
      <img class="bcf-1-stick-off-2 bcf2_132" src="<%= ctx %>/img/bcf1/bcf-1-stick-off-20.png" />
      <img class="bcf-1-stick-on-2 bcf2_132" src="<%= ctx %>/img/bcf1/bcf-1-stick-on-20.png" />
      <img class="bcf-1-obj-6" src="<%= ctx %>/img/bcf1/bcf-1-obj-60.png" />
      <img class="bcf-1-obj-7" src="<%= ctx %>/img/bcf1/bcf-1-obj-70.png" />
      <img class="bcf-1-motor-off" src="<%= ctx %>/img/bcf1/bcf-1-motor-off0.png" />
      <img class="bcf-1-motor-on bcf2_46" src="<%= ctx %>/img/bcf1/bcf-1-motor-on0.png" />
      <img class="bcf-1-pen-off" src="<%= ctx %>/img/bcf1/bcf-1-pen-off0.png" />
      <img class="bcf-1-pen-on bcf2_22" src="<%= ctx %>/img/bcf1/bcf-1-pen-on0.png" />
      <img class="bcf-1-tray-1 bcf2_51" src="<%= ctx %>/img/bcf1/bcf-1-tray-10.png" />
      <img class="bcf-1-tray-2 bcf2_3" src="<%= ctx %>/img/bcf1/bcf-1-tray-20.png" />
      <img class="bcf-1-tray-3" src="<%= ctx %>/img/bcf1/bcf-1-tray-30.png" />
      <img class="bcf-1-bong-1" src="<%= ctx %>/img/bcf1/bcf-1-bong-10.png" />
      <img class="bcf-1-bong-2 bcf2_34" src="<%= ctx %>/img/bcf1/bcf-1-bong-20.png" />
      <img class="bcf-1-bong-3 bcf2_33" src="<%= ctx %>/img/bcf1/bcf-1-bong-30.png" />
      <img class="bcf-1-door-open-1  bcf2_2" src="<%= ctx %>/img/bcf1/bcf-1-door-open-10.png" />
      <img class="bcf-1-door-close-1  bcf2_2" src="<%= ctx %>/img/bcf1/bcf-1-door-close-10.png" />
      <img class="bcf-1-bong-4" src="<%= ctx %>/img/bcf1/bcf-1-bong-40.png" />
      <img class="bcf-1-bong-5 bcf2_2" src="<%= ctx %>/img/bcf1/bcf-1-bong-50.png" />
      <img class="bcf-1-bong-6 bcf2_2" src="<%= ctx %>/img/bcf1/bcf-1-bong-60.png" />
      <img class="bcf-1-door-close-2" src="<%= ctx %>/img/bcf1/bcf-1-door-close-20.png" />
      <img class="bcf-1-door-open-2" src="<%= ctx %>/img/bcf1/bcf-1-door-open-20.png" />
      <img class="bcf-1-air-cycle bcf2_60" src="<%= ctx %>/img/bcf1/bcf-1-air-cycle0.png" />
      <img class="bcf-1-sensor-off-1" src="<%= ctx %>/img/bcf1/bcf-1-sensor-off-10.png" />
      <img class="bcf-1-sensor-on-1 bcf2_9" src="<%= ctx %>/img/bcf1/bcf-1-sensor-on-10.png" />
      <img class="bcf-1-sensor-off-2" src="<%= ctx %>/img/bcf1/bcf-1-sensor-off-20.png" />
      <img class="bcf-1-sensor-on-2" src="<%= ctx %>/img/bcf1/bcf-1-sensor-on-20.png" />
      <img class="bcf-1-cycle bcf2_39 bcf2_40" src="<%= ctx %>/img/bcf1/bcf-1-cycle0.png" />
      <img class="bcf-1-rotate-1 bcf2_59" src="<%= ctx %>/img/bcf1/bcf-1-rotate-10.png" />
      <img class="bcf-1-rotate-2 bcf2_59" src="<%= ctx %>/img/bcf1/bcf-1-rotate-20.png" />
      <img class="bcf-1-rotate-3 bcf2_39 bcf2_40" src="<%= ctx %>/img/bcf1/bcf-1-rotate-30.png" />
      <img class="bcf-1-alarm-1 bcf2_74" src="<%= ctx %>/img/bcf1/bcf-1-alarm-10.png" />
      <img class="bcf-1-alarm-2 bcf2_85" src="<%= ctx %>/img/bcf1/bcf-1-alarm-20.png" />
      <img class="bcf-1-alarm-3 bcf2_76" src="<%= ctx %>/img/bcf1/bcf-1-alarm-30.png" />
      <img class="bcf-1-alarm-4 bcf2_90" src="<%= ctx %>/img/bcf1/bcf-1-alarm-40.png" />
      <img class="bcf-1-alarm-5 bcf2_88" src="<%= ctx %>/img/bcf1/bcf-1-alarm-50.png" />
      <img class="bcf-1-alarm-6 bcf2_66" src="<%= ctx %>/img/bcf1/bcf-1-alarm-60.png" />
      <img class="bcf-1-alarm-7 bcf2_67" src="<%= ctx %>/img/bcf1/bcf-1-alarm-70.png" />
      <img class="bcf-1-alarm-8 bcf2_79" src="<%= ctx %>/img/bcf1/bcf-1-alarm-80.png" />
      <img class="bcf-1-alarm-9 bcf2_69" src="<%= ctx %>/img/bcf1/bcf-1-alarm-90.png" />
      <img class="bcf-1-alarm-10 bcf2_81" src="<%= ctx %>/img/bcf1/bcf-1-alarm-100.png" />
      <img class="bcf-1-alarm-11 bcf2_80" src="<%= ctx %>/img/bcf1/bcf-1-alarm-110.png" />
      <img class="bcf-1-alarm-12 bcf2_72" src="<%= ctx %>/img/bcf1/bcf-1-alarm-120.png" />
      <img class="bcf-1-alarm-13 bcf2_83" src="<%= ctx %>/img/bcf1/bcf-1-alarm-130.png" />
      <img class="bcf-1-alarm-14 bcf2_71" src="<%= ctx %>/img/bcf1/bcf-1-alarm-140.png" />
      <img class="bcf-1-enrich-gray bcf2_139" src="<%= ctx %>/img/bcf1/bcf-1-enrich-gray0.png" />
      <img class="bcf-1-enrich-red" src="<%= ctx %>/img/bcf1/bcf-1-enrich-red0.png" />
      <img class="bcf-1-enrich-green bcf2_27" src="<%= ctx %>/img/bcf1/bcf-1-enrich-green0.png" />
      <img class="bcf-1-amm-gray bcf2_141" src="<%= ctx %>/img/bcf1/bcf-1-amm-gray0.png" />
      <img class="bcf-1-amm-red" src="<%= ctx %>/img/bcf1/bcf-1-amm-red0.png" />
      <img class="bcf-1-amm-green bcf2_28" src="<%= ctx %>/img/bcf1/bcf-1-amm-green0.png" />
      <div class="bcf-1-enrich-off-box bcf2_138"></div>
      <div class="bcf-1-enrich-on-box bcf2_139"></div>
      <div class="bcf-1-amm-off-box  bcf2_140"></div>
      <div class="bcf-1-amm-on-box bcf2_141"></div>
      <div class="bcf-1-jog-stop-box"></div>
      <div class="bcf-1-jog-manual-box bcf2_57 bcf2_59"></div>
      <div class="bcf-1-jog-on-box bcf2_56 bcf2_58"></div>
      <div class="bcf-1-stop-box-1"></div>
      <div class="bcf-1-manual-box-1 bcf2_136"></div>
      <div class="bcf-1-auto-box-1 bcf2_137"></div>
      <div class="bcf-1-stop-box-2"></div>
      <div class="bcf-1-manual-box-2 bcf2_134"></div>
      <div class="bcf-1-auto-box-2"></div>
      <div class="bcf-1-1-sok-box bcf2_41"></div>
      <div class="bcf-1-2-sok-box bcf2_48"></div>
      <div class="bcf-1-3-sok-box bcf2_49"></div>
      <div class="bcf-1-dt-2 bcf2_3"></div>
      <div class="bcf-1-dt-1 bcf2_51"></div>
      <div class="bcf-1-ro-on bcf2_52"></div>
      <div class="bcf-1-ro-off"></div>
      <div class="bcf-1-dt-3"></div>
      <div class="bcf-1-flamesw-box bcf2_17"></div>
      <div class="bcf-1-flame-box bcf2_18"></div>
      <div class="bcf-1-fire-box bcf2_16"></div>
      <img class="bcf-1-fire-1 bcf2_30" src="<%= ctx %>/img/fireggg.gif" />
      <img class="bcf-1-fire-2  bcf2_16" src="<%= ctx %>/img/fireggg.gif" />
    </div>

    <!-- ═══════════════════════════════════════
         오른쪽 패널 (신규)
         ═══════════════════════════════════════ -->
    <div class="bcf-right-panel">

      <!-- 상단: [온도CP + 현재경보] + [자동운전 준비조건] -->
      <div class="bcf-top-row">

        <!-- 왼쪽: 온도CP 한줄 + 현재경보 -->
        <div class="bcf-left-col">

          <!-- 온도 및 CP: 2행 그리드 (PV / SP) -->
          <div class="bcf-temp-panel">
            <div class="tp-title">온도 및 CP</div>
            <div class="tp-grid">

              <!-- 헤더행 -->
              <div class="tp-corner"></div>
              <div class="tp-ch-cell"><span class="tp-lbl red">침탄실</span><span class="tp-unit">℃</span></div>
              <div class="tp-ch-cell"><span class="tp-lbl green">유조</span><span class="tp-unit">℃</span></div>
              <div class="tp-ch-cell"><span class="tp-lbl blue">CP</span><span class="tp-unit">%</span></div>

              <!-- PV 행 (현재값) -->
              <div class="tp-row-label">PV</div>
              <div class="tp-dc"><div class="tp-val BCF2_40046">--</div></div>
              <div class="tp-dc"><div class="tp-val BCF2_40047">--</div></div>
              <div class="tp-dc tp-last-col"><div class="tp-val blue BCF2_40052">--</div></div>

              <!-- SP 행 (설정값) -->
              <div class="tp-row-label tp-last-row">SP</div>
              <div class="tp-dc tp-last-row"><div class="tp-val BCF2_40069">--</div></div>
              <div class="tp-dc tp-last-row"><div class="tp-val BCF2_40070">--</div></div>
              <div class="tp-dc tp-last-col tp-last-row"><div class="tp-val blue BCF2_40071">--</div></div>

            </div><!-- /tp-grid -->
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
            <div class="auto-item state-red" data-tag="bcf2_25"  data-text-0="수동 SS"            data-text-1="자동 SS">수동 SS</div>
            <div class="auto-item state-gray" data-tag="bcf2_20" data-text-0="DC POWER OFF"       data-text-1="DC POWER ON"  data-gray="true">DC POWER OFF</div>
            <div class="auto-item state-red" data-tag="bcf2_19"  data-text-0="비상정지"            data-text-1="비상정지">비상정지</div>
            <div class="auto-item state-red" data-tag="bcf2_15"  data-text-0="배기 파이로트 OFF"   data-text-1="배기 파이로트 ON">배기 파이로트 OFF</div>
            <div class="auto-item state-green" data-tag="bcf2_18" data-text-0="입구문 파이로트 OFF" data-text-1="입구문 파이로트 ON" data-invert="true">입구문 파이로트 OFF</div>
            <div class="auto-item state-red" data-tag="bcf2_17"  data-text-0="입구문 커튼SW OFF"   data-text-1="입구문 커튼SW ON">입구문 커튼SW OFF</div>
            <div class="auto-item state-red" data-tag="bcf2_22"  data-text-0="팬 정지"             data-text-1="팬 구동">팬 정지</div>
            <div class="auto-item state-red" data-tag="bcf2_1"   data-text-0="입구문 열림"         data-text-1="입구문 닫힘">입구문 열림</div>
            <div class="auto-item state-red" data-tag="bcf2_4"   data-text-0="E/V 하강"            data-text-1="E/V 상승">E/V 하강</div>
            <div class="auto-item state-red" data-tag="bcf2_7"   data-text-0="중간문 닫힘"         data-text-1="중간문 닫힘">중간문 닫힘</div>
            <div class="auto-item state-red" data-tag="bcf2_107" data-text-0="로내롤러 자동조강"    data-text-1="로내롤러 자동조강">로내롤러 자동조강</div>
            <div class="auto-item state-red" data-tag="bcf2_53"  data-text-0="장입 자동스탭 준비"  data-text-1="장입 자동스탭 준비">장입 자동스탭 준비</div>
            <div class="auto-item state-red" data-tag="bcf2_54"  data-text-0="본체 자동스탭 준비"  data-text-1="본체 자동스탭 준비">본체 자동스탭 준비</div>
            <div class="auto-item state-red" data-tag="bcf2_55"  data-text-0="추출 자동스탭 준비"  data-text-1="추출 자동스탭 준비">추출 자동스탭 준비</div>
          </div>
        </div>

      </div><!-- /bcf-top-row -->

      <!-- 존별 구간 데이터 테이블 -->
      <div class="bcf-zone-panel">
        <table class="bcf-zone-table">
          <thead>
      <tr>
        <th rowspan="2" style="width:72px;">구분</th>
        <th colspan="2">승온1</th>
        <th colspan="2">승온2</th>
        <th colspan="2">침탄1</th>
        <th colspan="2">침탄2</th>
        <th colspan="2">확산1</th>
        <th colspan="2">확산2</th>
        <th colspan="2">강온</th>
        <th colspan="2" class="roneng">로냉</th>
        <th colspan="2">드레인</th>
      </tr>
    </thead>
    <tbody>
 
      <!-- 시간(min) PV -->
      <tr>
        <td class="row-label">시간(min) PV</td>
        <!-- 승온1 → BCF2_40015 -->
        <td colspan="2"><div class="zbox red BCF2_40015">BCF2_40015</div></td>
        <!-- 승온2 → BCF2_40016 -->
        <td colspan="2"><div class="zbox red BCF2_40016">BCF2_40016</div></td>
        <!-- 침탄1 → BCF2_40017 -->
        <td colspan="2"><div class="zbox red BCF2_40017">BCF2_40017</div></td>
        <!-- 침탄2 → BCF2_40018 -->
        <td colspan="2"><div class="zbox red BCF2_40018">BCF2_40018</div></td>
        <!-- 확산1 → BCF2_40019 -->
        <td colspan="2"><div class="zbox red BCF2_40019">BCF2_40019</div></td>
        <!-- 확산2 → BCF2_40020 -->
        <td colspan="2"><div class="zbox red BCF2_40020">BCF2_40020</div></td>
        <!-- 강온 → BCF2_40021 -->
        <td colspan="2"><div class="zbox red BCF2_40021">BCF2_40021</div></td>
        <!-- 로냉 → BCF2_40023 -->
        <td colspan="2"><div class="zbox red BCF2_40023">BCF2_40023</div></td>
        <!-- 드레인 → BCF2_40025 -->
        <td colspan="2"><div class="zbox red BCF2_40025">BCF2_40025</div></td>
      </tr>
 
      <!-- 시간(min) SP -->
      <tr>
        <td class="row-label">시간(min) SP</td>
        <!-- 승온1 → BCF2_40028 -->
        <td colspan="2"><div class="zbox yellow BCF2_40028">BCF2_40028</div></td>
        <!-- 승온2 → BCF2_40029 -->
        <td colspan="2"><div class="zbox yellow BCF2_40029">BCF2_40029</div></td>
        <!-- 침탄1 → BCF2_40030 -->
        <td colspan="2"><div class="zbox yellow BCF2_40030">BCF2_40030</div></td>
        <!-- 침탄2 → BCF2_40031 -->
        <td colspan="2"><div class="zbox yellow BCF2_40031">BCF2_40031</div></td>
        <!-- 확산1 → BCF2_40032 -->
        <td colspan="2"><div class="zbox yellow BCF2_40032">BCF2_40032</div></td>
        <!-- 확산2 → BCF2_40033 -->
        <td colspan="2"><div class="zbox yellow BCF2_40033">BCF2_40033</div></td>
        <!-- 강온 → BCF2_40034 -->
        <td colspan="2"><div class="zbox yellow BCF2_40034">BCF2_40034</div></td>
        <!-- 로냉 → BCF2_40035 -->
        <td colspan="2"><div class="zbox yellow BCF2_40035">BCF2_40035</div></td>
        <!-- 드레인 → BCF2_40036 -->
        <td colspan="2"><div class="zbox yellow BCF2_40036">BCF2_40036</div></td>
      </tr>
 
      <!-- 온도(℃) PV -->
      <tr>
        <td class="row-label">온도(℃) PV</td>
        <!-- 승온1 → BCF2_40046 (공유) -->
        <td colspan="2"><div class="zbox BCF2_40046">BCF2_40046</div></td>
        <!-- 승온2 → BCF2_40046 -->
        <td colspan="2"><div class="zbox BCF2_40046">BCF2_40046</div></td>
        <!-- 침탄1 → BCF2_40046 -->
        <td colspan="2"><div class="zbox BCF2_40046">BCF2_40046</div></td>
        <!-- 침탄2 → BCF2_40046 -->
        <td colspan="2"><div class="zbox BCF2_40046">BCF2_40046</div></td>
        <!-- 확산1 → BCF2_40046 -->
        <td colspan="2"><div class="zbox BCF2_40046">BCF2_40046</div></td>
        <!-- 확산2 → BCF2_40046 -->
        <td colspan="2"><div class="zbox BCF2_40046">BCF2_40046</div></td>
        <!-- 강온 → BCF2_40046 -->
        <td colspan="2"><div class="zbox BCF2_40046">BCF2_40046</div></td>
        <!-- 로냉 → BCF2_40047 -->
        <td colspan="2"><div class="zbox BCF2_40047">BCF2_40047</div></td>
        <!-- 드레인 → BCF2_40047 -->
        <td colspan="2"><div class="zbox BCF2_40047">BCF2_40047</div></td>
      </tr>
 
      <!-- 온도(℃) SP -->
      <tr>
        <td class="row-label">온도(℃) SP</td>
        <!-- 승온1 → BCF2_40038 -->
        <td colspan="2"><div class="zbox yellow BCF2_40038">BCF2_40038</div></td>
        <!-- 승온2 → BCF2_40039 -->
        <td colspan="2"><div class="zbox yellow BCF2_40039">BCF2_40039</div></td>
        <!-- 침탄1 → BCF2_40040 -->
        <td colspan="2"><div class="zbox yellow BCF2_40040">BCF2_40040</div></td>
        <!-- 침탄2 → BCF2_40041 -->
        <td colspan="2"><div class="zbox yellow BCF2_40041">BCF2_40041</div></td>
        <!-- 확산1 → BCF2_40042 -->
        <td colspan="2"><div class="zbox yellow BCF2_40042">BCF2_40042</div></td>
        <!-- 확산2 → BCF2_40043 -->
        <td colspan="2"><div class="zbox yellow BCF2_40043">BCF2_40043</div></td>
        <!-- 강온 → BCF2_40044 -->
        <td colspan="2"><div class="zbox yellow BCF2_40044">BCF2_40044</div></td>
        <!-- 로냉 → BCF2_40070 -->
        <td colspan="2"><div class="zbox yellow BCF2_40070">BCF2_40070</div></td>
        <!-- 드레인 → BCF2_40070 -->
        <td colspan="2"><div class="zbox yellow BCF2_40070">BCF2_40070</div></td>
      </tr>
 
      <!-- CP(%) PV -->
      <tr>
        <td class="row-label">CP(%) PV</td>
        <!-- 승온1 → empty -->
        <td colspan="2"><div class="zbox empty"></div></td>
        <!-- 승온2 → empty -->
        <td colspan="2"><div class="zbox empty"></div></td>
        <!-- 침탄1 → BCF2_40052 -->
        <td colspan="2"><div class="zbox cyan BCF2_40052">BCF2_40052</div></td>
        <!-- 침탄2 → BCF2_40052 -->
        <td colspan="2"><div class="zbox cyan BCF2_40052">BCF2_40052</div></td>
        <!-- 확산1 → BCF2_40052 -->
        <td colspan="2"><div class="zbox cyan BCF2_40052">BCF2_40052</div></td>
        <!-- 확산2 → BCF2_40052 -->
        <td colspan="2"><div class="zbox cyan BCF2_40052">BCF2_40052</div></td>
        <!-- 강온 → empty -->
        <td colspan="2"><div class="zbox empty"></div></td>
        <!-- 로냉 → empty -->
        <td colspan="2"><div class="zbox empty"></div></td>
        <!-- 드레인 → empty -->
        <td colspan="2"><div class="zbox empty"></div></td>
      </tr>
 
      <!-- CP(%) SP -->
      <tr>
        <td class="row-label">CP(%) SP</td>
        <!-- 승온1 → empty -->
        <td colspan="2"><div class="zbox empty"></div></td>
        <!-- 승온2 → empty -->
        <td colspan="2"><div class="zbox empty"></div></td>
        <!-- 침탄1 → BCF2_40048 -->
        <td colspan="2"><div class="zbox cyan BCF2_40048">BCF2_40048</div></td>
        <!-- 침탄2 → BCF2_40049 -->
        <td colspan="2"><div class="zbox cyan BCF2_40049">BCF2_40049</div></td>
        <!-- 확산1 → BCF2_40050 -->
        <td colspan="2"><div class="zbox cyan BCF2_40050">BCF2_40050</div></td>
        <!-- 확산2 → BCF2_40051 -->
        <td colspan="2"><div class="zbox cyan BCF2_40051">BCF2_40051</div></td>
        <!-- 강온 → empty -->
        <td colspan="2"><div class="zbox empty"></div></td>
        <!-- 로냉 → empty -->
        <td colspan="2"><div class="zbox empty"></div></td>
        <!-- 드레인 → empty -->
        <td colspan="2"><div class="zbox empty"></div></td>
      </tr>
          </tbody>
        </table>
      </div>

    </div><!-- /bcf-right-panel -->

  </div><!-- /group-1 -->
</div><!-- /page-wrap -->

<style>
@keyframes bcf2-spin { to { transform: rotate(360deg); } }
</style>
<script src="<%= ctx %>/js/tabulator/tabulator.js"></script>
<script>
/* ── BCF 탭 활성화 ── */
(function() {
  var cur = location.pathname.split('/').pop();
  document.querySelectorAll('.bcf-tab').forEach(function(a) {
    if (a.getAttribute('href').split('/').pop() === cur) a.classList.add('active');
  });
})();

/* ── PLC 폴링 ── */
(function() {
  'use strict';
  var ctx = '<%= ctx %>';
  var INTERVAL = 3000;

  /* DOM 스캔
     bcf2_숫자    → 비트(show/hide)
     BCF2_숫자    → 아날로그(→ bcf2_s_숫자 키)
     [data-tag]   → 자동운전 상태 아이템 (색+텍스트 갱신) */
  var bitElMap    = {};  // 'bcf2_12'      → [el, ...]
  var wordElMap   = {};  // 'bcf2_s_40046' → [el, ...]
  var statusElMap = {};  // 'bcf2_25'      → [el, ...]

  document.querySelectorAll('[class]').forEach(function(el) {
    el.className.split(/\s+/).forEach(function(cls) {
      if (/^bcf2_\d+$/.test(cls)) {
        if (!bitElMap[cls]) bitElMap[cls] = [];
        bitElMap[cls].push(el);
      } else if (/^BCF2_\d+$/.test(cls)) {
        var apiTag = 'bcf2_s_' + cls.slice(5);
        if (!wordElMap[apiTag]) wordElMap[apiTag] = [];
        wordElMap[apiTag].push(el);
      }
    });
  });

  document.querySelectorAll('[data-tag]').forEach(function(el) {
    var tag = el.getAttribute('data-tag');  // e.g. 'bcf2_25'
    if (!statusElMap[tag]) statusElMap[tag] = [];
    statusElMap[tag].push(el);
  });

  var allTags = Object.keys(wordElMap)
    .concat(Object.keys(bitElMap))
    .concat(Object.keys(statusElMap).filter(function(t) {
      return !bitElMap[t];  // 중복 방지
    }));

  /* 자동운전 항목 색+텍스트 갱신 */
  function updateStatusItem(el, val) {
    var isOn    = (val === 1 || val === true);
    var invert  = el.getAttribute('data-invert') === 'true';
    var isGray  = el.getAttribute('data-gray')   === 'true';
    var active  = invert ? !isOn : isOn;

    el.textContent = isOn
      ? (el.getAttribute('data-text-1') || el.getAttribute('data-text-0') || '')
      : (el.getAttribute('data-text-0') || '');

    el.classList.remove('state-red', 'state-green', 'state-gray');
    if (active) {
      el.classList.add('state-green');
    } else if (isGray && !isOn) {
      el.classList.add('state-gray');
    } else {
      el.classList.add('state-red');
    }
  }

  /* 데이터 반영 */
  var CP_TAG = /_(40052|40071)$/;
  function applyData(data) {
    /* 온도: raw 그대로, CP: ×0.001 (소수 3자리) */
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

    /* 비트: 1→보임, 0→숨김 / bcf2_59 예외: 1→회전, 0→정지 */
    Object.keys(bitElMap).forEach(function(tag) {
      if (data[tag] == null) return;
      var isOn = (data[tag] === 1 || data[tag] === true);
      bitElMap[tag].forEach(function(el) {
        if (tag === 'bcf2_59') {
          el.style.visibility = 'visible';
          el.style.animation  = isOn ? 'bcf2-spin 1s linear infinite' : 'none';
        } else {
          el.style.visibility = isOn ? 'visible' : 'hidden';
        }
      });
    });

    /* 자동운전 상태 아이템: 색+텍스트 */
    Object.keys(statusElMap).forEach(function(tag) {
      if (data[tag] == null) return;
      statusElMap[tag].forEach(function(el) {
        updateStatusItem(el, data[tag]);
      });
    });
  }

  /* PLC 폴링 (중첩 방지) */
  var busy = false;
  function fetchData() {
    if (busy) return;
    busy = true;
    fetch(ctx + '/monitor/snapshot')
    .then(function(r) { return r.ok ? r.json() : Promise.reject(r.status); })
    .then(function(data) { applyData(data); })
    .catch(function(err) { console.warn('[BCF2] PLC fetch 실패:', err); })
    .finally(function() { busy = false; });
  }

  /* 현재 경보 Tabulator (1호기 = plcId: 'dongwoo_02') */
  var alarmTable = new Tabulator('.alarm-body', {
    height:        '100%',
    layout:        'fitColumns',
    headerVisible: false,
    placeholder:   '현재 경보 없음',
    rowHeight:     52,
    data:          [],
    columns: [
      {
        title: '', field: 'dot', width: 22, resizable: false, headerSort: false,
        formatter: function() { return '<span class="alarm-dot"></span>'; }
      },
      {
        title: '시간', field: 'occurTime', width: 152, resizable: false, headerSort: false,
        formatter: function(cell) {
          var v = cell.getValue() || '';
          return '<span class="alarm-time-val">' + (v.length >= 16 ? v.substring(0, 16) : v) + '</span>';
        }
      },
      {
        title: '경보 내용', field: 'alarmMsg', headerSort: false,
        formatter: function(cell) { return cell.getValue() || '알람'; }
      }
    ]
  });

  function fetchAlarms() {
    fetch(ctx + '/alarm/active/list?limit=200')
      .then(function(r) { return r.ok ? r.json() : []; })
      .then(function(list) {
        var items = (Array.isArray(list) ? list : []).filter(function(a) {
          return a.plcId === 'dongwoo_02';
        });
        alarmTable.setData(items);
      })
      .catch(function() {});
  }

  /* 시작 */
  fetchData();
  fetchAlarms();
  setInterval(fetchData,  INTERVAL);
  setInterval(fetchAlarms, INTERVAL);
})();
</script>
</body>
</html>
