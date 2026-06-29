
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../common_style.jsp" %>
<% String ctx = request.getContextPath(); %>
<link rel="stylesheet" href="<%= ctx %>/css/bcf6/style.css">
<link rel="stylesheet" href="<%= ctx %>/css/tabulator/tabulator.css">
<style>
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
.bcf-tab .tab-num  { font-size: 15px; font-weight: 800; line-height: 1; }
.bcf-tab .tab-lbl  { font-size: 9px;  letter-spacing: .4px; }
.bcf-tab:hover     { background: var(--bg); color: var(--text); border-color: var(--border); }
.bcf-tab.active    {
  background: linear-gradient(135deg, var(--primary), var(--primary-d, #1a56db));
  color: #fff; border-color: transparent;
  box-shadow: 0 2px 8px rgba(37,99,235,.35);
}

.page-wrap { overflow-x: hidden; width: 100%; }
.group-1, .group-1 * {
  box-sizing: border-box;
  font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
}
.group-1 {
  position: relative;
  width: 100%;
  height: 894px;
  overflow: hidden;
}

/* ═══════════════════════════════════════════════
   [우측] 자동운전 조건
   사진 기준: 2열 그리드, 항목 다수
   ═══════════════════════════════════════════════ */
.bcf6-auto-panel {
  position: absolute;
  left:   1340px;
  top:    0;
  right:  0;
  height: 498px;
  display: flex;
  flex-direction: column;
  border: 1.5px solid #2aada0;
  border-radius: 3px;
  overflow: hidden;
}
.bcf6-auto-title {
  background: #3dbdb0;
  color: #fff;
  font-size: 11px;
  font-weight: 700;
  text-align: center;
  padding: 3px 0;
  letter-spacing: 1px;
  flex-shrink: 0;
}
/* 2열 그리드 */
.bcf6-auto-grid {
  flex: 1;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2px;
  padding: 3px;
  overflow-y: hidden;
}
.bcf6-auto-item {
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
  border: 1.5px solid #555;
  font-family: '맑은 고딕', 'Malgun Gothic', sans-serif;
  font-size: 12px;
  font-weight: 800;
  background: #d9d9d9;
  color: #333;
  text-align: center;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  padding: 0 3px;
  letter-spacing: .2px;
  text-shadow: 0 1px 2px rgba(0,0,0,.20);
}
.bcf6-auto-item.state-red    { background: #FF3333; color: #fff; border-color: #CC0000; box-shadow: inset 0 -2px 0 rgba(0,0,0,.2); }
.bcf6-auto-item.state-green  { background: #66CC33; color: #fff; border-color: #44AA11; box-shadow: inset 0 -2px 0 rgba(0,0,0,.2); }
.bcf6-auto-item.state-gray   { background: #B0B0B0; color: #fff; border-color: #888;    box-shadow: inset 0 -2px 0 rgba(0,0,0,.15); }
.bcf6-auto-item.state-yellow { background: #f5c400; color: #333; border-color: #c8a000; box-shadow: inset 0 -2px 0 rgba(0,0,0,.15); }

/* ═══════════════════════════════════════════════
   [하단 전체] 존구간(좌) + [온도CP + 현재경보](우)
   ═══════════════════════════════════════════════ */
.bcf6-bottom-panel {
  position: absolute;
  left:   0;
  top:    565px;
  right:  0;
  bottom: auto;
  height: 210px;
  display: flex;
  flex-direction: row;
  gap: 4px;
  padding: 3px;
  overflow: hidden;
}

/* ── 가변 컬럼: 존구간(최대) | 온도CP(고정 좁음) | 경보(고정 중간) ── */
.bcf6-zone-panel {
  flex: 3;          /* 온도(고정130) + 경보(flex2) 대비 넓게 */
  min-width: 0;
  border: 1.5px solid #888;
  border-radius: 3px;
  overflow: hidden;
  background: #e8e8e8;
}
.bcf6-zone-table {
  width: 100%;
  height: 100%;
  border-collapse: collapse;
  font-size: 12px;
  font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
  table-layout: fixed;
}
.bcf6-zone-table th,
.bcf6-zone-table td {
  border: 1px solid #90b8d0;
  text-align: center;
  padding: 1px 2px;
  white-space: nowrap;
  overflow: hidden;
}
/* 존 이름 헤더 행 */
.bcf6-zone-table thead tr th {
  background: #2a9d91;
  color: #fff;
  font-weight: 700;
  font-size: 12px;
  letter-spacing: .6px;
  padding: 5px 0;
}
.bcf6-zone-table thead tr th.th-empty {
  background: #1f9086;
  border: none;
}
/* 행 레이블 */
.bcf6-zone-table tbody tr td.row-label {
  background: #c0d8ec;
  font-weight: 700;
  color: #0d2a42;
  text-align: left;
  padding-left: 5px;
  font-size: 10px;
  white-space: nowrap;
}
.bcf6-zone-table tbody tr td { background: #fff; }

/* 존 값 박스 */
.zbox6 {
  display: block;
  width: 90%;
  margin: 1px auto;
  height: 20px;
  line-height: 20px;
  border-radius: 3px;
  background: #ffbbbb;
  border: 1.5px solid #d04040;
  font-size: 11px;
  font-weight: 700;
  color: #4a0000;
  text-align: center;
}
.zbox6.yellow { background: #fffcc0; border-color: #b0a000; color: #3a3000; }
.zbox6.cyan   { background: #b8eeff; border-color: #30a0cc; color: #002a44; }
.zbox6.empty  { background: #f4f4f4; border-color: #ccc;    color: #aaa; font-weight: 400; }
.zbox6.dt     { background: #ffbbbb; border-color: #cc5050; color: #4a0000; }

/* ── 중: 온도 및 CP (고정 좁은 폭) ── */
.bcf6-temp-panel {
  flex: 0 0 130px;  /* 고정 폭 130px */
  display: flex;
  flex-direction: column;
  border: 1.5px solid #2aada0;
  border-radius: 3px;
  overflow: hidden;
}
.bcf6-panel-title {
  background: #3dbdb0;
  color: #fff;
  font-size: 11px;
  font-weight: 700;
  text-align: center;
  padding: 3px 0;
  letter-spacing: 1px;
}
/* 온도 및 CP 세로 목록 */
.bcf6-tp-list {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 4px;
  gap: 3px;
  background: #eafaf8;
  border-top: 1px solid #2aada0;
}
.bcf6-tp-item {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 3px;
  padding: 0 4px;
  border-radius: 3px;
  border: 1px solid #b8e8e2;
  background: #fff;
}
.bcf6-tpi-lbl {
  flex: 0 0 38px;
  font-size: 10px;
  font-weight: 700;
  color: #b91c1c;
  white-space: nowrap;
  overflow: hidden;
}
.bcf6-tpi-lbl.blue { color: #1d4ed8; }
.bcf6-tpi-val {
  flex: 1;
  height: 22px;
  line-height: 22px;
  border-radius: 2px;
  background: #9ccc8d;
  border: 1px solid #6aaa50;
  font-size: 12px;
  font-weight: 700;
  color: #1a4000;
  text-align: center;
  font-variant-numeric: tabular-nums;
  min-width: 0;
}
.bcf6-tpi-val.blue { background: #bfdbfe; border-color: #3b82f6; color: #1e3a8a; }
.bcf6-tpi-unit {
  flex: 0 0 14px;
  font-size: 10px;
  font-weight: 700;
  color: #1a5c52;
  text-align: right;
}

/* ── 우: 현재 경보 (flex로 남은 공간 채움) ── */
.bcf6-alarm-panel {
  flex: 2;          /* zone(3) 대비 비율 조정 */
  min-width: 0;
  border: 1.5px solid #2aada0;
  border-radius: 3px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}
.alarm-body {
  flex: 1;
  min-height: 0;
  border-top: 1px solid #f0b888;
  overflow: hidden;
  position: relative;
}
.alarm-body .tabulator,
.alarm-body .tabulator-tableHolder { background: #fff5ee; border: none; }
.alarm-body .tabulator-row,
.alarm-body .tabulator-row.tabulator-row-even { background: #fff5ee; border-bottom: 1px solid #fce0c8; min-height: 48px; }
.alarm-body .tabulator-row:hover { background: #ffe8d6 !important; }
.alarm-body .tabulator-cell { border-right: none; padding: 4px 6px; color: #4a1500; font-family: '맑은 고딕','Malgun Gothic',sans-serif; font-size: 13px; font-weight: 700; white-space: normal; word-break: break-word; line-height: 1.35; overflow: hidden; }
.alarm-body .tabulator-placeholder span { background: #fff5ee; color: #aa3300; font-family: '맑은 고딕','Malgun Gothic',sans-serif; font-size: 13px; }
.alarm-dot { display: inline-block; width: 10px; height: 10px; border-radius: 50%; background: #ee6600; vertical-align: middle; animation: alarm-pulse 1.2s ease-in-out infinite; }
.alarm-time-val { color: #aa3300; font-size: 13px; font-weight: 700; letter-spacing: .3px; font-variant-numeric: tabular-nums; }
@keyframes alarm-pulse {
  0%, 100% { opacity: 1;   box-shadow: 0 0 5px #ee6600; }
  50%       { opacity: 0.25; box-shadow: none; }
}
.bcf6-alarm-body {
  flex: 1;
  background: #b8b8b8;
  border-top: 1px solid #888;
  position: relative;
}
.bcf6-alarm-body::before {
  content: '';
  position: absolute;
  left: 0; top: 0; bottom: 0;
  width: 2px;
  background: #2255cc;
}
</style>

<body>
<div class="page-wrap">

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

    <!-- 기존 설비 작화 -->
    <div class="bcf-6-detail">
      <img class="bcf-6" src="<%= ctx %>/img/bcf6/bcf-60.png" />
      <img class="bcf-6-1" src="<%= ctx %>/img/bcf6/bcf-6-10.png" />
      <img class="bcf-6-2" src="<%= ctx %>/img/bcf6/bcf-6-20.png" />
      <img class="bcf-6-3" src="<%= ctx %>/img/bcf6/bcf-6-30.png" />
      <img class="bcf-6-obj-1" src="<%= ctx %>/img/bcf6/bcf-6-obj-10.png" />
      <img class="bcf-6-fire-1 bcf6_138" src="<%= ctx %>/img/bcf6/bcf-6-fire-10.png" />
      <img class="bcf-6-fire-2 bcf6_138" src="<%= ctx %>/img/bcf6/bcf-6-fire-20.png" />
      <img class="bcf-6-fire-3 bcf6_125" src="<%= ctx %>/img/bcf6/bcf-6-fire-30.png" />
      <img class="bcf-6-fire-4 bcf6_125" src="<%= ctx %>/img/bcf6/bcf-6-fire-40.png" />
      <div class="bcf-6-obj-2"></div>
      <img class="bcf-6-elv-1" src="<%= ctx %>/img/bcf6/bcf-6-elv-10.png" />
      <img class="bcf-6-elv-2" src="<%= ctx %>/img/bcf6/bcf-6-elv-20.png" />
      <img class="bcf-6-obj-3" src="<%= ctx %>/img/bcf6/bcf-6-obj-30.png" />
      <img class="bcf-6-obj-4" src="<%= ctx %>/img/bcf6/bcf-6-obj-40.png" />
      <img class="bcf-6-bong-13" src="<%= ctx %>/img/bcf6/bcf-6-bong-130.png" />
      <img class="bcf-6-bong-14 bcf6_40" src="<%= ctx %>/img/bcf6/bcf-6-bong-140.png" />
      <img class="bcf-6-bong-15 bcf6_22" src="<%= ctx %>/img/bcf6/bcf-6-bong-150.png" />
      <img class="bcf-6-obj-5" src="<%= ctx %>/img/bcf6/bcf-6-obj-50.png" />
      <img class="bcf-6-obj-6" src="<%= ctx %>/img/bcf6/bcf-6-obj-60.png" />
      <img class="bcf-6-bong-16" src="<%= ctx %>/img/bcf6/bcf-6-bong-160.png" />
      <img class="bcf-6-bong-17" src="<%= ctx %>/img/bcf6/bcf-6-bong-170.png" />
      <img class="bcf-6-bong-18" src="<%= ctx %>/img/bcf6/bcf-6-bong-180.png" />
      <img class="bcf-6-door-open-7" src="<%= ctx %>/img/bcf6/bcf-6-door-open-70.png" />
      <img class="bcf-6-door-close-7" src="<%= ctx %>/img/bcf6/bcf-6-door-close-70.png" />
      <img class="bcf-6-bong-19" src="<%= ctx %>/img/bcf6/bcf-6-bong-190.png" />
      <img class="bcf-6-bong-20" src="<%= ctx %>/img/bcf6/bcf-6-bong-200.png" />
      <img class="bcf-6-bong-21" src="<%= ctx %>/img/bcf6/bcf-6-bong-210.png" />
      <img class="bcf-6-oil" src="<%= ctx %>/img/bcf6/bcf-6-oil0.png" />
      <img class="bcf-6-elv-3" src="<%= ctx %>/img/bcf6/bcf-6-elv-30.png" />
      <img class="bcf-6-elv-4" src="<%= ctx %>/img/bcf6/bcf-6-elv-40.png" />
      <img class="bcf-6-down-1" src="<%= ctx %>/img/bcf6/bcf-6-down-10.png" />
      <img class="bcf-6-down-2" src="<%= ctx %>/img/bcf6/bcf-6-down-20.png" />
      <img class="bcf-6-down-3 bcf6_137" src="<%= ctx %>/img/bcf6/bcf-6-down-30.png" />
      <img class="bcf-1-cycle bcf6_234" src="<%= ctx %>/img/bcf6/bcf-1-cycle0.png" />
      <img class="bcf-6-tray-1 bcf6_8" src="<%= ctx %>/img/bcf6/bcf-6-tray-10.png" />
      <img class="bcf-6-tray-2 bcf6_291" src="<%= ctx %>/img/bcf6/bcf-6-tray-20.png" />
      <img class="bcf-6-tray-3 bcf6_39" src="<%= ctx %>/img/bcf6/bcf-6-tray-30.png" />
      <img class="bcf-6-tray-4 bcf6_293" src="<%= ctx %>/img/bcf6/bcf-6-tray-40.png" />
      <img class="bcf-6-tray-5 bcf6_294" src="<%= ctx %>/img/bcf6/bcf-6-tray-50.png" />
      <img class="bcf-6-tray-6 bcf6_295" src="<%= ctx %>/img/bcf6/bcf-6-tray-60.png" />
      <img class="bcf-6-tray-7 bcf6_296" src="<%= ctx %>/img/bcf6/bcf-6-tray-70.png" />
      <img class="bcf-6-tray-8" src="<%= ctx %>/img/bcf6/bcf-6-tray-80.png" />
      <img class="bcf-6-tray-9 bcf6_298" src="<%= ctx %>/img/bcf6/bcf-6-tray-90.png" />
      <img class="bcf-6-tray-10 bcf6_37" src="<%= ctx %>/img/bcf6/bcf-6-tray-100.png" />
      <img class="bcf-6-tray-11 bcf6_43" src="<%= ctx %>/img/bcf6/bcf-6-tray-110.png" />
      <img class="bcf-6-tray-12 bcf6_131" src="<%= ctx %>/img/bcf6/bcf-6-tray-120.png" />
      <img class="bcf-6-jog-gray-1  bcf6_303" src="<%= ctx %>/img/bcf6/bcf-6-jog-gray-10.png" />
      <img class="bcf-6-jog-red-1" src="<%= ctx %>/img/bcf6/bcf-6-jog-red-10.png" />
      <img class="bcf-6-jog-green-1" src="<%= ctx %>/img/bcf6/bcf-6-jog-green-10.png" />
      <img class="bcf-6-jog-gray-2 bcf6_305" src="<%= ctx %>/img/bcf6/bcf-6-jog-gray-20.png" />
      <img class="bcf-6-jog-red-2" src="<%= ctx %>/img/bcf6/bcf-6-jog-red-20.png" />
      <img class="bcf-6-jog-green-2 bcf6_248 bcf6_249" src="<%= ctx %>/img/bcf6/bcf-6-jog-green-20.png" />
      <img class="bcf-6-jog-gray-3 bcf6_307" src="<%= ctx %>/img/bcf6/bcf-6-jog-gray-30.png" />
      <img class="bcf-6-jog-red-3" src="<%= ctx %>/img/bcf6/bcf-6-jog-red-30.png" />
      <img class="bcf-6-jog-green-3 bcf6_252 bcf6_253" src="<%= ctx %>/img/bcf6/bcf-6-jog-green-30.png" />
      <img class="bcf-6-jog-gray-4 bcf6_309" src="<%= ctx %>/img/bcf6/bcf-6-jog-gray-40.png" />
      <img class="bcf-6-jog-red-4" src="<%= ctx %>/img/bcf6/bcf-6-jog-red-40.png" />
      <img class="bcf-6-jog-green-4 bcf6_256 bcf6_257" src="<%= ctx %>/img/bcf6/bcf-6-jog-green-40.png" />
      <img class="bcf-6-jog-gray-5 bcf6_311" src="<%= ctx %>/img/bcf6/bcf-6-jog-gray-50.png" />
      <img class="bcf-6-jog-red-5" src="<%= ctx %>/img/bcf6/bcf-6-jog-red-50.png" />
      <img class="bcf-6-jog-green-5 bcf6_260 bcf6_261" src="<%= ctx %>/img/bcf6/bcf-6-jog-green-50.png" />
      <img class="bcf-6-jog-gray-6 bcf6_313" src="<%= ctx %>/img/bcf6/bcf-6-jog-gray-60.png" />
      <img class="bcf-6-jog-red-6" src="<%= ctx %>/img/bcf6/bcf-6-jog-red-60.png" />
      <img class="bcf-6-jog-green-6 bcf6_264 bcf6_265" src="<%= ctx %>/img/bcf6/bcf-6-jog-green-60.png" />
      <img class="bcf-6-propel-1 bcf6_224" src="<%= ctx %>/img/bcf6/bcf-6-propel-10.png" />
      <img class="bcf-6-propel-2 bcf6_225" src="<%= ctx %>/img/bcf6/bcf-6-propel-20.png" />
      <img class="bcf-6-propel-3 bcf6_84" src="<%= ctx %>/img/bcf6/bcf-6-propel-30.png" />
      <img class="bcf-6-propel-4" src="<%= ctx %>/img/bcf6/bcf-6-propel-40.png" />
      <img class="bcf-6-pen-off-1" src="<%= ctx %>/img/bcf6/bcf-6-pen-off-10.png" />
      <img class="bcf-6-pen-on-1 bcf6_224" src="<%= ctx %>/img/bcf6/bcf-6-pen-on-10.png" />
      <img class="bcf-6-pen-off-2 bcf6_113" src="<%= ctx %>/img/bcf6/bcf-6-pen-off-20.png" />
      <img class="bcf-6-pen-on-2 bcf6_225" src="<%= ctx %>/img/bcf6/bcf-6-pen-on-20.png" />
      <img class="bcf-6-pen-off-3" src="<%= ctx %>/img/bcf6/bcf-6-pen-off-30.png" />
      <img class="bcf-6-pen-on-3 bcf6_84" src="<%= ctx %>/img/bcf6/bcf-6-pen-on-30.png" />
      <img class="bcf-6-pen-off-4" src="<%= ctx %>/img/bcf6/bcf-6-pen-off-40.png" />
      <img class="bcf-6-pen-on" src="<%= ctx %>/img/bcf6/bcf-6-pen-on0.png" />
      <img class="bcf-6-circle-1" src="<%= ctx %>/img/bcf6/bcf-6-circle-10.png" />
      <img class="bcf-6-circle-2 bcf6_244 bcf6_245" src="<%= ctx %>/img/bcf6/bcf-6-circle-20.png" />
      <img class="bcf-6-circle-3 bcf6_188 bcf6_122" src="<%= ctx %>/img/bcf6/bcf-6-circle-30.png" />
      <img class="bcf-6- bcf6_248 bcf6_249" src="<%= ctx %>/img/bcf6/bcf-6-circle-40.png" />
      <img class="bcf-6-circle-5 bcf6_252 bcf6_253" src="<%= ctx %>/img/bcf6/bcf-6-circle-50.png" />
      <img class="bcf-6-circle-6 bcf6_260 bcf6_261" src="<%= ctx %>/img/bcf6/bcf-6-circle-60.png" />
      <img class="bcf-6-circle-7" src="<%= ctx %>/img/bcf6/bcf-6-circle-70.png" />
      <img class="bcf-6-circle-8 bcf6_128 bcf6_39" src="<%= ctx %>/img/bcf6/bcf-6-circle-80.png" />
      <img class="bcf-6-circle-9 bcf6_128 bcf6_37" src="<%= ctx %>/img/bcf6/bcf-6-circle-90.png" />
      <img class="bcf-6-circle-10 bcf6_132" src="<%= ctx %>/img/bcf6/bcf-6-circle-100.png" />
      <img class="bcf-6-pan-on-1 bcf6_55" src="<%= ctx %>/img/bcf6/bcf-6-pan-on-10.png" />
      <img class="bcf-6-pan-off-1 bcf6_54" src="<%= ctx %>/img/bcf6/bcf-6-pan-off-10.png" />
      <img class="bcf-6-door-close-3 bcf6_20" src="<%= ctx %>/img/bcf6/bcf-6-door-close-30.png" />
      <img class="bcf-6-door-open-3 bcf6_20" src="<%= ctx %>/img/bcf6/bcf-6-door-open-30.png" />
      <img class="bcf-6-door-close-4 bcf6_22" src="<%= ctx %>/img/bcf6/bcf-6-door-close-40.png" />
      <img class="bcf-6-door-open-4 bcf6_22" src="<%= ctx %>/img/bcf6/bcf-6-door-open-40.png" />
      <img class="bcf-6-door-close-5" src="<%= ctx %>/img/bcf6/bcf-6-door-close-50.png" />
      <img class="bcf-6-door-open-5" src="<%= ctx %>/img/bcf6/bcf-6-door-open-50.png" />
      <img class="bcf-6-point-1" src="<%= ctx %>/img/bcf6/bcf-6-point-10.png" />
      <img class="bcf-6-point-2 bcf6_124" src="<%= ctx %>/img/bcf6/bcf-6-point-20.png" />
      <img class="bcf-6-point-3" src="<%= ctx %>/img/bcf6/bcf-6-point-30.png" />
      <img class="bcf-6-point-4 bcf6_124" src="<%= ctx %>/img/bcf6/bcf-6-point-40.png" />
      <img class="bcf-6-pan-on-2 bcf6_57" src="<%= ctx %>/img/bcf6/bcf-6-pan-on-20.png" />
      <img class="bcf-6-pan-off-2 bcf6_133" src="<%= ctx %>/img/bcf6/bcf-6-pan-off-20.png" />
      <img class="bcf-6-door-close-1 bcf6_14" src="<%= ctx %>/img/bcf6/bcf-6-door-close-10.png" />
      <img class="bcf-6-door-open-1 bcf6_14" src="<%= ctx %>/img/bcf6/bcf-6-door-open-10.png" />
      <img class="bcf-6-door-close-2 bcf6_16" src="<%= ctx %>/img/bcf6/bcf-6-door-close-20.png" />
      <img class="bcf-6-door-open-2 bcf6_16" src="<%= ctx %>/img/bcf6/bcf-6-door-open-20.png" />
      <img class="bcf-6-door-close-6 bcf6_26" src="<%= ctx %>/img/bcf6/bcf-6-door-close-60.png" />
      <img class="bcf-6-door-open-6 bcf6_26" src="<%= ctx %>/img/bcf6/bcf-6-door-open-60.png" />
      <img class="bcf-6-bong-1" src="<%= ctx %>/img/bcf6/bcf-6-bong-10.png" />
      <img class="bcf-6-bong-2 bcf6_14 bcf6_15" src="<%= ctx %>/img/bcf6/bcf-6-bong-20.png" />
      <img class="bcf-6-bong-3 bcf6_19 bcf6_59" src="<%= ctx %>/img/bcf6/bcf-6-bong-30.png" />
      <img class="bcf-6-bong-4" src="<%= ctx %>/img/bcf6/bcf-6-bong-40.png" />
      <img class="bcf-6-bong-5 bcf6_4 bcf6_16" src="<%= ctx %>/img/bcf6/bcf-6-bong-50.png" />
      <img class="bcf-6-bong-6 bcf6_1 bcf6_53" src="<%= ctx %>/img/bcf6/bcf-6-bong-60.png" />
      <img class="bcf-6-bong-7" src="<%= ctx %>/img/bcf6/bcf-6-bong-70.png" />
      <img class="bcf-6-bong-8 bcf6_39" src="<%= ctx %>/img/bcf6/bcf-6-bong-80.png" />
      <img class="bcf-6-bong-9 bcf6_37" src="<%= ctx %>/img/bcf6/bcf-6-bong-90.png" />
      <img class="bcf-6-bong-10" src="<%= ctx %>/img/bcf6/bcf-6-bong-100.png" />
      <img class="bcf-6-bong-11 bcf6_26" src="<%= ctx %>/img/bcf6/bcf-6-bong-110.png" />
      <img class="bcf-6-bong-12 bcf6_44" src="<%= ctx %>/img/bcf6/bcf-6-bong-120.png" />
      <img class="bcf-6-photo-off-1" src="<%= ctx %>/img/bcf6/bcf-6-photo-off-10.png" />
      <img class="bcf-6-photo-on-1  bcf6_123" src="<%= ctx %>/img/bcf6/bcf-6-photo-on-10.png" />
      <img class="bcf-6-photo-off-2" src="<%= ctx %>/img/bcf6/bcf-6-photo-off-20.png" />
      <img class="bcf-6-photo-on-2 bcf6_128" src="<%= ctx %>/img/bcf6/bcf-6-photo-on-20.png" />
      <img class="bcf-6-photo-off-3" src="<%= ctx %>/img/bcf6/bcf-6-photo-off-30.png" />
      <img class="bcf-6-photo-on-3 bcf6_110" src="<%= ctx %>/img/bcf6/bcf-6-photo-on-30.png" />
      <img class="bcf-6-photo-off-4" src="<%= ctx %>/img/bcf6/bcf-6-photo-off-40.png" />
      <img class="bcf-6-photo-on-4" src="<%= ctx %>/img/bcf6/bcf-6-photo-on-40.png" />
      <img class="bcf-6-photo-off-5" src="<%= ctx %>/img/bcf6/bcf-6-photo-off-50.png" />
      <img class="bcf-6-photo-on-5 bcf6_110" src="<%= ctx %>/img/bcf6/bcf-6-photo-on-50.png" />
      <img class="bcf-6-photo-off-6" src="<%= ctx %>/img/bcf6/bcf-6-photo-off-60.png" />
      <img class="bcf-6-photo-on-6 bcf6_109" src="<%= ctx %>/img/bcf6/bcf-6-photo-on-60.png" />
      <img class="bcf-6-photo-off-7" src="<%= ctx %>/img/bcf6/bcf-6-photo-off-70.png" />
      <img class="bcf-6-photo-on-7 bcf6_118" src="<%= ctx %>/img/bcf6/bcf-6-photo-on-70.png" />
      <img class="bcf-6-photo-off-8" src="<%= ctx %>/img/bcf6/bcf-6-photo-off-80.png" />
      <img class="bcf-6-photo-on-8 bcf6_115" src="<%= ctx %>/img/bcf6/bcf-6-photo-on-80.png" />
      <img class="bcf-6-photo-off-9" src="<%= ctx %>/img/bcf6/bcf-6-photo-off-90.png" />
      <img class="bcf-6-photo-on-9 bcf6_119" src="<%= ctx %>/img/bcf6/bcf-6-photo-on-90.png" />
      <img class="bcf-6-photo-off-10" src="<%= ctx %>/img/bcf6/bcf-6-photo-off-100.png" />
      <img class="bcf-6-photo-on-10 bcf6_116" src="<%= ctx %>/img/bcf6/bcf-6-photo-on-100.png" />
      <img class="bcf-6-photo-off-11" src="<%= ctx %>/img/bcf6/bcf-6-photo-off-110.png" />
      <img class="bcf-6-photo-on-11" src="<%= ctx %>/img/bcf6/bcf-6-photo-on-110.png" />
      <img class="bcf-6-photo-off-12" src="<%= ctx %>/img/bcf6/bcf-6-photo-off-120.png" />
      <img class="bcf-6-photo-on-12" src="<%= ctx %>/img/bcf6/bcf-6-photo-on-120.png" />
      <img class="bcf-6-sensor-off-1" src="<%= ctx %>/img/bcf6/bcf-6-sensor-off-10.png" />
      <img class="bcf-6-sensor-on-1" src="<%= ctx %>/img/bcf6/bcf-6-sensor-on-10.png" />
      <img class="bcf-6-sensor-off-2" src="<%= ctx %>/img/bcf6/bcf-6-sensor-off-20.png" />
      <img class="bcf-6-sensor-on-2 bcf6_109" src="<%= ctx %>/img/bcf6/bcf-6-sensor-on-20.png" />
      <img class="bcf-6-sensor-off-3" src="<%= ctx %>/img/bcf6/bcf-6-sensor-off-30.png" />
      <img class="bcf-6-sensor-on-3 bcf6_136" src="<%= ctx %>/img/bcf6/bcf-6-sensor-on-30.png" />
      <img class="bcf-6-sensor-off-4" src="<%= ctx %>/img/bcf6/bcf-6-sensor-off-40.png" />
      <img class="bcf-6-sensor-on-4 bcf6_137" src="<%= ctx %>/img/bcf6/bcf-6-sensor-on-40.png" />
      <img class="bcf-6-sensor-off-5" src="<%= ctx %>/img/bcf6/bcf-6-sensor-off-50.png" />
      <img class="bcf-6-sensor-on-5 bcf6_107" src="<%= ctx %>/img/bcf6/bcf-6-sensor-on-50.png" />
      <img class="bcf-6-sensor-off-6" src="<%= ctx %>/img/bcf6/bcf-6-sensor-off-60.png" />
      <img class="bcf-6-sensor-on-6" src="<%= ctx %>/img/bcf6/bcf-6-sensor-on-60.png" />
      <img class="bcf-6-rotate-1 bcf6_244 bcf6_245" src="<%= ctx %>/img/bcf6/bcf-6-rotate-10.png" />
      <img class="bcf-6-rotate-2 bcf6_248 bcf6_249" src="<%= ctx %>/img/bcf6/bcf-6-rotate-20.png" />
      <img class="bcf-6-rotate-3 bcf6_252 bcf6_253" src="<%= ctx %>/img/bcf6/bcf-6-rotate-30.png" />
      <img class="bcf-6-rotate-4 bcf6_256 bcf6_257" src="<%= ctx %>/img/bcf6/bcf-6-rotate-40.png" />
      <img class="bcf-6-rotate-5 bcf6_260 bcf6_261" src="<%= ctx %>/img/bcf6/bcf-6-rotate-50.png" />
      <img class="bcf-6-rotate-6 bcf6_264 bcf6_265" src="<%= ctx %>/img/bcf6/bcf-6-rotate-60.png" />
      <img class="bcf-6-rotate-7 bcf6_118 bcf6_119" src="<%= ctx %>/img/bcf6/bcf-6-rotate-70.png" />
      <img class="bcf-6-fsensor-off-1" src="<%= ctx %>/img/bcf6/bcf-6-fsensor-off-10.png" />
      <img class="bcf-6-fsensor-on-1 bcf6_20" src="<%= ctx %>/img/bcf6/bcf-6-fsensor-on-10.png" />
      <img class="bcf-6-fsensor-off-2" src="<%= ctx %>/img/bcf6/bcf-6-fsensor-off-20.png" />
      <img class="bcf-6-fsensor-on-2 bcf6_20" src="<%= ctx %>/img/bcf6/bcf-6-fsensor-on-20.png" />
      <img class="bcf-6-sensor-off-7" src="<%= ctx %>/img/bcf6/bcf-6-sensor-off-70.png" />
      <img class="bcf-6-sensor-on-7 bcf6_108" src="<%= ctx %>/img/bcf6/bcf-6-sensor-on-70.png" />
      <img class="bcf-6-sensor-off-8" src="<%= ctx %>/img/bcf6/bcf-6-sensor-off-80.png" />
      <img class="bcf-6-sensor-on-8 bcf6_134" src="<%= ctx %>/img/bcf6/bcf-6-sensor-on-80.png" />
      <img class="bcf-6-sensor-off-9" src="<%= ctx %>/img/bcf6/bcf-6-sensor-off-90.png" />
      <img class="bcf-6-sensor-on-9 bcf6_113" src="<%= ctx %>/img/bcf6/bcf-6-sensor-on-90.png" />
      <img class="bcf-6-sensor-off-10" src="<%= ctx %>/img/bcf6/bcf-6-sensor-off-100.png" />
      <img class="bcf-6-sensor-on-10" src="<%= ctx %>/img/bcf6/bcf-6-sensor-on-100.png" />
      <img class="bcf-6-firepipe-off-1" src="<%= ctx %>/img/bcf6/bcf-6-firepipe-off-10.png" />
      <img class="bcf-6-firepipe-on-1 bcf6_124" src="<%= ctx %>/img/bcf6/bcf-6-firepipe-on-10.png" />
      <img class="bcf-6-firepipe-off-2" src="<%= ctx %>/img/bcf6/bcf-6-firepipe-off-20.png" />
      <img class="bcf-6-firepipe-on-2 bcf6_124" src="<%= ctx %>/img/bcf6/bcf-6-firepipe-on-20.png" />
      <img class="bcf-6-point-32" src="<%= ctx %>/img/bcf6/bcf-6-point-31.png" />
      <img class="bcf-6-mini-1 bcf6_127 bcf6_57" src="<%= ctx %>/img/bcf6/bcf-6-mini-10.png" />
      <img class="bcf-6-stick-1" src="<%= ctx %>/img/bcf6/bcf-6-stick-10.png" />
      <img class="bcf-6-mini-2 bcf6_127" src="<%= ctx %>/img/bcf6/bcf-6-mini-20.png" />
      <img class="bcf-6-mini-3" src="<%= ctx %>/img/bcf6/bcf-6-mini-30.png" />
      <img class="bcf-6-mini-4 bcf6_120" src="<%= ctx %>/img/bcf6/bcf-6-mini-40.png" />
      <img class="bcf-6-mini-5 bcf6_121" src="<%= ctx %>/img/bcf6/bcf-6-mini-50.png" />
      <img class="bcf-6-alarm-1 bcf6_357" src="<%= ctx %>/img/bcf6/bcf-6-alarm-10.png" />
      <img class="bcf-6-alarm-2 bcf6_321" src="<%= ctx %>/img/bcf6/bcf-6-alarm-20.png" />
      <img class="bcf-6-alarm-3 bcf6_359" src="<%= ctx %>/img/bcf6/bcf-6-alarm-30.png" />
      <img class="bcf-6-alarm-4 bcf6_331" src="<%= ctx %>/img/bcf6/bcf-6-alarm-40.png" />
      <img class="bcf-6-alarm-5 bcf6_358" src="<%= ctx %>/img/bcf6/bcf-6-alarm-50.png" />
      <img class="bcf-6-alarm-6 bcf6_359" src="<%= ctx %>/img/bcf6/bcf-6-alarm-60.png" />
      <img class="bcf-6-alarm-7 bcf6_358" src="<%= ctx %>/img/bcf6/bcf-6-alarm-70.png" />
      <img class="bcf-6-alarm-8 bcf6_369" src="<%= ctx %>/img/bcf6/bcf-6-alarm-80.png" />
      <img class="bcf-6-alarm-9 bcf6_331" src="<%= ctx %>/img/bcf6/bcf-6-alarm-90.png" />
      <img class="bcf-6-alarm-10 bcf6_322" src="<%= ctx %>/img/bcf6/bcf-6-alarm-100.png" />
      <img class="bcf-6-alarm-11 bcf6_360" src="<%= ctx %>/img/bcf6/bcf-6-alarm-110.png" />
      <img class="bcf-6-alarm-12  bcf6_322" src="<%= ctx %>/img/bcf6/bcf-6-alarm-120.png" />
      <img class="bcf-6-alarm-13 bcf6_331" src="<%= ctx %>/img/bcf6/bcf-6-alarm-130.png" />
      <img class="bcf-6-alarm-14 bcf6_331" src="<%= ctx %>/img/bcf6/bcf-6-alarm-140.png" />
      <img class="bcf-6-alarm-15 bcf6_331" src="<%= ctx %>/img/bcf6/bcf-6-alarm-150.png" />
      <img class="bcf-6-alarm-16 bcf6_370" src="<%= ctx %>/img/bcf6/bcf-6-alarm-160.png" />
      <img class="bcf-6-alarm-17 bcf6_371" src="<%= ctx %>/img/bcf6/bcf-6-alarm-170.png" />
      <img class="bcf-6-alarm-18 bcf6_372" src="<%= ctx %>/img/bcf6/bcf-6-alarm-180.png" />
      <img class="bcf-6-alarm-19 bcf6_135" src="<%= ctx %>/img/bcf6/bcf-6-alarm-190.png" />
      <img class="bcf-6-alarm-20 bcf6_361" src="<%= ctx %>/img/bcf6/bcf-6-alarm-200.png" />
      <img class="bcf-6-alarm-21 bcf6_331" src="<%= ctx %>/img/bcf6/bcf-6-alarm-210.png" />
      <img class="bcf-6-alarm-22 bcf6_322" src="<%= ctx %>/img/bcf6/bcf-6-alarm-220.png" />
      <img class="bcf-6-alarm-23 bcf6_374" src="<%= ctx %>/img/bcf6/bcf-6-alarm-230.png" />
      <img class="bcf-6-alarm-24 bcf6_364" src="<%= ctx %>/img/bcf6/bcf-6-alarm-240.png" />
      <div class="bcf-1-flamesw-box bcf6_140"></div>
      <div class="bcf-1-flamesw-box2 bcf6_139"></div>
      <div class="bcf-1-flamesw-box3 bcf6_303 bcf6_304"></div>
      <div class="bcf-1-flamesw-box4 bcf6_33"></div>
      <div class="bcf-1-flamesw-box5 bcf6_38"></div>
      <div class="bcf-1-flamesw-box6" bcf6_305 bcf6_306></div>
      <div class="bcf-1-flamesw-box7 bcf6_307 bcf6_308"></div>
      <div class="bcf-1-flamesw-box8 bcf6_309 bcf6_310"></div>
      <div class="bcf-1-flamesw-box9 bcf6_311 bcf6_312"></div>
      <div class="bcf-1-flamesw-box10 bcf6_313 bcf6_314"></div>
      <div class="bcf-1-flamesw-box11 bcf6_135"></div>
      <div class="bcf-1-flamesw-box12 bcf6_134"></div>
      <div class="bcf-1-flamesw-box13 bcf6_27"></div>
      <div class="bcf-1-flamesw-box14 bcf6_26"></div>
      <div class="bcf-1-flamesw-box15 bcf6_111"></div>
      <div class="bcf-1-flamesw-box16"></div>
      <div class="bcf-1-flamesw-box17 bcf6_129"></div>
      <div class="bcf-1-flamesw-box18 bcf6_130"></div>
      <div class="bcf-1-flamesw-box19 bcf6_129"></div>
      <div class="bcf-6-alrblow-off-box"></div>
      <div class="bcf-6-alrblow-on-box bcf6_81"></div>
      <div class="bcf-6-mainair-off-box"></div>
      <div class="bcf-6-mainair-on-box bcf6_7"></div>
      <div class="bcf-6-bypas-off-box"></div>
      <div class="bcf-6-bypas-on-box bcf6_26"></div>
      <div class="bcf-6-pilot-1-off-box"></div>
      <div class="bcf-6-pilot-1-on-box bcf6_132"></div>
      <div class="bcf-6-pilot-2-off-box"></div>
      <div class="bcf-6-pilot-2-on-box bcf6_133"></div>
      <img class="bcf-6-arrow-left-1 bcf6_245" src="<%= ctx %>/img/bcf6/bcf-6-arrow-left-10.png" />
      <img class="bcf-6-arrow-right-1 bcf6_244" src="<%= ctx %>/img/bcf6/bcf-6-arrow-right-10.png" />
      <img class="bcf-6-arrow-left-2 bcf6_249" src="<%= ctx %>/img/bcf6/bcf-6-arrow-left-20.png" />
      <img class="bcf-6-arrow-right-2 bcf6_248" src="<%= ctx %>/img/bcf6/bcf-6-arrow-right-20.png" />
      <img class="bcf-6-arrow-left-3 bcf6_253" src="<%= ctx %>/img/bcf6/bcf-6-arrow-left-30.png" />
      <img class="bcf-6-arrow-right-3 bcf6_252" src="<%= ctx %>/img/bcf6/bcf-6-arrow-right-30.png" />
      <img class="bcf-6-arrow-left-4 bcf6_257" src="<%= ctx %>/img/bcf6/bcf-6-arrow-left-40.png" />
      <img class="bcf-6-arrow-left-5 bcf6_261" src="<%= ctx %>/img/bcf6/bcf-6-arrow-left-50.png" />
      <img class="bcf-6-arrow-right-4 bcf6_256" src="<%= ctx %>/img/bcf6/bcf-6-arrow-right-40.png" />
      <img class="bcf-6-arrow-right-5 bcf6_260" src="<%= ctx %>/img/bcf6/bcf-6-arrow-right-50.png" />
      <img class="bcf-6-arrow-left-6 bcf6_265" src="<%= ctx %>/img/bcf6/bcf-6-arrow-left-60.png" />
      <img class="bcf-6-arrow-right-6 bcf6_264" src="<%= ctx %>/img/bcf6/bcf-6-arrow-right-60.png" />
      <img class="bcf-6-arrow-right-7 bcf6_128 bcf6_37" src="<%= ctx %>/img/bcf6/bcf-6-arrow-right-70.png" />
      <img class="bcf-6-arrow-right-8 bcf6_128 bcf6_39" src="<%= ctx %>/img/bcf6/bcf-6-arrow-right-80.png" />
      <img class="bcf-6-arrow-left-7 bcf6_122" src="<%= ctx %>/img/bcf6/bcf-6-arrow-left-70.png" />
      <img class="bcf-6-arrow-right-9 bcf6_188" src="<%= ctx %>/img/bcf6/bcf-6-arrow-right-90.png" />
      <img class="bcf-6-obj-7" src="<%= ctx %>/img/bcf6/bcf-6-obj-70.png" />
      <img class="_31-2" src="<%= ctx %>/img/bcf6/_31-20.png" />
      <img class="bcf-6-enrich-red-1" src="<%= ctx %>/img/bcf6/bcf-6-enrich-red-10.png" />
      <img class="bcf-6-enrich-green-1 bcf6_115" src="<%= ctx %>/img/bcf6/bcf-6-enrich-green-10.png" />
      <img class="bcf-6-enrich-red-2" src="<%= ctx %>/img/bcf6/bcf-6-enrich-red-20.png" />
      <img class="bcf-6-enrich-green-2 bcf6_121" src="<%= ctx %>/img/bcf6/bcf-6-enrich-green-20.png" />
      <img class="bcf-6-enrich-red-3" src="<%= ctx %>/img/bcf6/bcf-6-enrich-red-30.png" />
      <img class="bcf-6-enrich-green-3" src="<%= ctx %>/img/bcf6/bcf-6-enrich-green-30.png" />
    </div>

    <!-- ═══ [우측] 자동운전 조건 - 2열 그리드 ═══ -->
    <div class="bcf6-auto-panel">
      <div class="bcf6-auto-title">자동운전 조건</div>
      <div class="bcf6-auto-grid">
        <div class="bcf6-auto-item state-red"  data-tag="bcf6_8"   data-text-0="입구리프터2 상승+처리품" data-text-1="입구리프터2 상승+처리품">입구리프터2 상승+처리품</div>
        <div class="bcf6-auto-item state-green">비상정지</div>

        <div class="bcf6-auto-item state-red"  data-tag="bcf6_11"  data-text-0="예열입구 보조롤러 하강"  data-text-1="예열입구 보조롤러 하강">예열입구 보조롤러 하강</div>
        <div class="bcf6-auto-item state-green">예열 자동스탭 준비완료</div>

        <div class="bcf6-auto-item state-red"  data-tag="bcf6_13"  data-text-0="예열 입구문 닫힘"        data-text-1="예열 입구문 닫힘">예열 입구문 닫힘</div>
        <div class="bcf6-auto-item state-green">예열→가열 자동준비완료</div>

        <div class="bcf6-auto-item state-red"  data-tag="bcf6_15"  data-text-0="예열 출구문 닫힘"        data-text-1="예열 출구문 닫힘">예열 출구문 닫힘</div>
        <div class="bcf6-auto-item state-green">가열→침탄1 자동준비완료</div>

        <div class="bcf6-auto-item state-green">예열 수동조깅 아님</div>
        <div class="bcf6-auto-item state-green">침탄1→침탄2 자동준비완료</div>

        <div class="bcf6-auto-item state-red"  data-tag="bcf6_39"  data-text-0="가열입구리프터 처리품X"  data-text-1="가열입구리프터 처리품X">가열입구리프터 처리품X</div>
        <div class="bcf6-auto-item state-green">침탄2→침탄3 자동준비완료</div>

        <div class="bcf6-auto-item state-red"  data-tag="bcf6_19"  data-text-0="가열 입구문 닫힘"        data-text-1="가열 입구문 닫힘">가열 입구문 닫힘</div>
        <div class="bcf6-auto-item state-green">강온→유조 자동준비완료</div>

        <div class="bcf6-auto-item state-red"  data-tag="bcf6_21"  data-text-0="침탄 입구문 닫힘"        data-text-1="침탄 입구문 닫힘">침탄 입구문 닫힘</div>
        <div class="bcf6-auto-item state-green">유조 자동스탭 준비완료</div>

        <div class="bcf6-auto-item state-red"  data-tag="bcf6_23"  data-text-0="강온 입구문 닫힘"        data-text-1="강온 입구문 닫힘">강온 입구문 닫힘</div>
        <div class="bcf6-auto-item state-red"  data-tag="bcf6_97"  data-text-0="가열입구 커튼SW ON"      data-text-1="가열입구 커튼SW ON">가열입구 커튼SW ON</div>

        <div class="bcf6-auto-item state-red"  data-tag="bcf6_25"  data-text-0="유조 입구문 닫힘"        data-text-1="유조 입구문 닫힘">유조 입구문 닫힘</div>
        <div class="bcf6-auto-item state-green">가열입구 열검출</div>

        <div class="bcf6-auto-item state-red"  data-tag="bcf6_38"  data-text-0="유조 E/V 상승"           data-text-1="유조 E/V 상승">유조 E/V 상승</div>
        <div class="bcf6-auto-item state-green">가열배기 열검출</div>

        <div class="bcf6-auto-item state-red"  data-tag="bcf6_27"  data-text-0="유조 보조체인 하강"      data-text-1="유조 보조체인 하강">유조 보조체인 하강</div>
        <div class="bcf6-auto-item state-red"  data-tag="bcf6_98"  data-text-0="유조출구 커튼SW ON"      data-text-1="유조출구 커튼SW ON">유조출구 커튼SW ON</div>

        <div class="bcf6-auto-item state-red"  data-tag="bcf6_29"  data-text-0="유조 출구문 닫힘"        data-text-1="유조 출구문 닫힘">유조 출구문 닫힘</div>
        <div class="bcf6-auto-item state-green">유조출구 열검출</div>

        <div class="bcf6-auto-item state-red"  data-tag="bcf6_32"  data-text-0="유조출구 리프터 하강"    data-text-1="유조출구 리프터 하강">유조출구 리프터 하강</div>
        <div class="bcf6-auto-item state-green">유조배기 열검출</div>

        <div class="bcf6-auto-item state-green">제어반 자동선택(터치)</div>
        <div class="bcf6-auto-item state-red"  data-tag="bcf6_116" data-text-0="O2 제어전원 켜짐"        data-text-1="O2 제어전원 켜짐">O2 제어전원 켜짐</div>

        <div class="bcf6-auto-item state-red"  data-tag="bcf6_145" data-text-0="예열OP 자동SS"           data-text-1="예열OP 자동SS">예열OP 자동SS</div>
        <div class="bcf6-auto-item state-red"  data-tag="bcf6_117" data-text-0="O2 제어정상"             data-text-1="O2 제어정상">O2 제어정상</div>

        <div class="bcf6-auto-item state-red"  data-tag="bcf6_146" data-text-0="침탄입구OP 자동SS"       data-text-1="침탄입구OP 자동SS">침탄입구OP 자동SS</div>
        <div class="bcf6-auto-item state-red"  data-tag="bcf6_120" data-text-0="MASSFLOW 전원켜짐"        data-text-1="MASSFLOW 전원켜짐">MASSFLOW 전원켜짐</div>

        <div class="bcf6-auto-item state-red"  data-tag="bcf6_147" data-text-0="침탄출구OP 자동SS"       data-text-1="침탄출구OP 자동SS">침탄출구OP 자동SS</div>
        <div class="bcf6-auto-item state-red"  data-tag="bcf6_137" data-text-0="앤리치가스 ON(터치)"     data-text-1="앤리치가스 ON(터치)">앤리치가스 ON(터치)</div>
      </div>
    </div>

    <!-- ═══ [하단] 존구간(좌) + 온도CP/현재경보(우) ═══ -->
    <div class="bcf6-bottom-panel">

      <!-- 좌: 존구간 테이블 - 사진과 동일하게 예열로/가열실/침탄1/침탄2/침탄3/강온/유조 -->
      <div class="bcf6-zone-panel">
        <table class="bcf6-zone-table">
          <thead>
            <tr>
              <th class="th-empty" style="width:80px;"></th>
              <th>예열로</th>
              <th>가열실</th>
              <th>침탄1</th>
              <th>침탄2</th>
              <th>침탄3</th>
              <th>강온</th>
              <th>유조</th>
            </tr>
          </thead>
          <tbody>
            <!-- 시간(min) PV -->
            <tr>
              <td class="row-label">시간 (min) PV</td>
              <td><div class="zbox6 dt BCF6_41" >--</div></td>
              <td><div class="zbox6 dt BCF6_21" >--</div></td>
              <td><div class="zbox6 dt BCF6_8"  >--</div></td>
              <td><div class="zbox6 dt BCF6_3"  >--</div></td>
              <td><div class="zbox6 dt BCF6_12" >--</div></td>
              <td><div class="zbox6 dt BCF6_14" >--</div></td>
              <td><div class="zbox6 dt BCF6_17" >--</div></td>
            </tr>
            <!-- 시간(min) SP -->
            <tr>
              <td class="row-label">시간 (min) SP</td>
              <td><div class="zbox6 yellow BCF6_48">--</div></td>
              <td><div class="zbox6 yellow BCF6_22">--</div></td>
              <td><div class="zbox6 yellow BCF6_2" >--</div></td>
              <td><div class="zbox6 yellow BCF6_9" >--</div></td>
              <td><div class="zbox6 yellow BCF6_13">--</div></td>
              <td><div class="zbox6 yellow BCF6_10">--</div></td>
              <td><div class="zbox6 yellow BCF6_16">--</div></td>
            </tr>
            <!-- 온도(℃) PV : 침탄3 없음 -->
            <tr>
              <td class="row-label">온도 (°C) PV</td>
              <td><div class="zbox6 dt BCF6_40033">--</div></td>
              <td><div class="zbox6 dt BCF6_40034">--</div></td>
              <td><div class="zbox6 dt BCF6_40035">--</div></td>
              <td><div class="zbox6 dt BCF6_40036">--</div></td>
              <td><div class="zbox6 dt BCF6_40036">--</div></td>
              <td><div class="zbox6 dt BCF6_40037">--</div></td>
              <td><div class="zbox6 dt BCF6_40038">--</div></td>
            </tr>
            <!-- 온도(℃) SP : 유조 없음 -->
            <tr>
              <td class="row-label">온도 (°C) SP</td>
              <td><div class="zbox6 yellow BCF6_40039">--</div></td>
              <td><div class="zbox6 yellow BCF6_40040">--</div></td>
              <td><div class="zbox6 yellow BCF6_40041">--</div></td>
              <td><div class="zbox6 yellow BCF6_40042">--</div></td>
              <td><div class="zbox6 yellow BCF6_40042">--</div></td>
              <td><div class="zbox6 yellow BCF6_40043">--</div></td>
              <td><div class="zbox6 yellow BCF6_40044"></div></td>
            </tr>
            <!-- CP(%) PV : 예열로·유조 없음, 가열실 별도, 침탄1~3 공유 BCF6_40046 -->
            <tr>
              <td class="row-label">CP (%) PV</td>
              <td><div class="zbox6 empty"></div></td>
              <td><div class="zbox6 cyan BCF6_40045">--</div></td>
              <td><div class="zbox6 cyan BCF6_40046">--</div></td>
              <td><div class="zbox6 cyan BCF6_40046">--</div></td>
              <td><div class="zbox6 cyan BCF6_40046">--</div></td>
              <td><div class="zbox6 cyan BCF6_40018">--</div></td>
              <td><div class="zbox6 empty"></div></td>
            </tr>
            <!-- CP(%) SP : 예열로·유조 없음, 침탄1~3 공유 BCF6_40049 -->
            <tr>
              <td class="row-label">CP (%) SP</td>
              <td><div class="zbox6 empty"></div></td>
              <td><div class="zbox6 cyan BCF6_40048">--</div></td>
              <td><div class="zbox6 cyan BCF6_40049">--</div></td>
              <td><div class="zbox6 cyan BCF6_40049">--</div></td>
              <td><div class="zbox6 cyan BCF6_40049">--</div></td>
              <td><div class="zbox6 cyan BCF6_40025">--</div></td>
              <td><div class="zbox6 empty"></div></td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- 중: 온도 및 CP (세로 목록) -->
      <div class="bcf6-temp-panel">
        <div class="bcf6-panel-title">온도 및 CP</div>
        <div class="bcf6-tp-list">

          <div class="bcf6-tp-item">
            <span class="bcf6-tpi-lbl">가열</span>
            <div class="bcf6-tpi-val BCF6_40034">--</div>
            <span class="bcf6-tpi-unit">℃</span>
          </div>

          <div class="bcf6-tp-item">
            <span class="bcf6-tpi-lbl">침탄2</span>
            <div class="bcf6-tpi-val BCF6_40036">--</div>
            <span class="bcf6-tpi-unit">℃</span>
          </div>

          <div class="bcf6-tp-item">
            <span class="bcf6-tpi-lbl blue">가열CP</span>
            <div class="bcf6-tpi-val blue BCF6_40045">--</div>
            <span class="bcf6-tpi-unit">%</span>
          </div>

          <div class="bcf6-tp-item">
            <span class="bcf6-tpi-lbl blue">침탄CP</span>
            <div class="bcf6-tpi-val blue BCF6_40046">--</div>
            <span class="bcf6-tpi-unit">%</span>
          </div>

        </div><!-- /bcf6-tp-list -->
      </div><!-- /bcf6-temp-panel -->

      <!-- 우: 현재 경보 -->
      <div class="bcf6-alarm-panel">
        <div class="bcf6-panel-title">현재 경보</div>
        <div class="alarm-body"></div>
      </div><!-- /bcf6-alarm-panel -->

    </div><!-- /bcf6-bottom-panel -->

  </div><!-- /group-1 -->
</div><!-- /page-wrap -->

<style>
@keyframes bcf6-spin { to { transform: rotate(360deg); } }
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
     bcf6_숫자(소문자 class) → 비트(show/hide)
     BCF6_숫자(대문자 class) → 아날로그(→ bcf6_s_숫자 API 키)
     data-tag="bcf6_숫자"   → 자동운전 조건 상태(색+텍스트) */
  var bitElMap    = {};  // 'bcf6_12'      → [el, ...]
  var wordElMap   = {};  // 'bcf6_s_40034' → [el, ...]
  var statusElMap = {};  // 'bcf6_8'       → [el, ...]

  /* 클래스 스캔: 비트(소문자) + 아날로그(대문자) */
  document.querySelectorAll('[class]').forEach(function(el) {
    el.className.split(/\s+/).forEach(function(cls) {
      if (/^bcf6_\d+$/.test(cls)) {
        if (!bitElMap[cls]) bitElMap[cls] = [];
        bitElMap[cls].push(el);
      } else if (/^BCF6_\d+$/.test(cls)) {
        var apiTag = 'bcf6_s_' + cls.slice(5);
        if (!wordElMap[apiTag]) wordElMap[apiTag] = [];
        wordElMap[apiTag].push(el);
      }
    });
  });

  /* data-tag 스캔: 자동운전 조건 상태 아이템만 */
  document.querySelectorAll('[data-tag]').forEach(function(el) {
    var tag = el.getAttribute('data-tag');
    if (/^bcf6_\d+$/.test(tag)) {
      if (!statusElMap[tag]) statusElMap[tag] = [];
      statusElMap[tag].push(el);
    }
  });

  var allTags = Object.keys(wordElMap)
    .concat(Object.keys(bitElMap))
    .concat(Object.keys(statusElMap).filter(function(t) {
      return !bitElMap[t];
    }));

  /* 자동운전 항목 색+텍스트 갱신 */
  function updateStatusItem(el, val) {
    var isOn   = (val === 1 || val === true);
    var invert = el.getAttribute('data-invert') === 'true';
    var isGray = el.getAttribute('data-gray')   === 'true';
    var active = invert ? !isOn : isOn;

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
  var CP_TAG = /_(40045|40046|40048|40049|40018|40025)$/;
  function applyData(data) {
    /* 아날로그: 온도는 그대로, CP는 ×0.001 */
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

    /* 비트: 1→보임, 0→숨김 */
    Object.keys(bitElMap).forEach(function(tag) {
      if (data[tag] == null) return;
      var isOn = (data[tag] === 1 || data[tag] === true);
      bitElMap[tag].forEach(function(el) {
        el.style.visibility = isOn ? 'visible' : 'hidden';
      });
    });

    /* 자동운전 상태 아이템 */
    Object.keys(statusElMap).forEach(function(tag) {
      if (data[tag] == null) return;
      statusElMap[tag].forEach(function(el) {
        updateStatusItem(el, data[tag]);
      });
    });
  }

  /* 초기 태그 스캔 결과 확인 */
  console.log('[BCF6] wordElMap 태그 수:', Object.keys(wordElMap).length, Object.keys(wordElMap).slice(0,5));
  console.log('[BCF6] bitElMap 태그 수:', Object.keys(bitElMap).length);
  console.log('[BCF6] allTags 수:', allTags.length);

  /* PLC 폴링 (중첩 방지) */
  var busy = false;
  var pollCount6 = 0;
  function fetchData() {
    if (busy) return;
    busy = true;
    pollCount6++;
    fetch(ctx + '/monitor/snapshot')
    .then(function(r) { return r.ok ? r.json() : Promise.reject(r.status); })
    .then(function(data) {
      if (pollCount6 <= 3) {
        var wordKeys = Object.keys(wordElMap);
        var nullKeys = wordKeys.filter(function(k){ return data[k] == null; });
        console.log('[BCF6] 폴링#' + pollCount6 + ' 응답 키수:' + Object.keys(data).length +
          ' | word태그:' + wordKeys.length + ' | null:' + nullKeys.length);
        if (nullKeys.length) console.warn('[BCF6] null 응답 태그:', nullKeys.slice(0,5));
        if (Object.keys(data).length === 0) console.warn('[BCF6] 응답 데이터 전부 비어있음 - 서버/PLC 확인 필요');
      }
      applyData(data);
    })
    .catch(function(err) { console.warn('[BCF6] PLC fetch 실패:', err); })
    .finally(function() { busy = false; });
  }

  /* 현재 경보 Tabulator (BCF6 = plcId: 'dongwoo_06') */
  var alarmTable = new Tabulator('.alarm-body', {
    height:        '100%',
    layout:        'fitColumns',
    headerVisible: false,
    placeholder:   '현재 경보 없음',
    rowHeight:     36,
    data:          [],
    columns: [
      {
        title: '', field: 'dot', width: 22, resizable: false, headerSort: false,
        formatter: function() { return '<span class="alarm-dot"></span>'; }
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
          return a.plcId === 'dongwoo_06';  /* ← 서버 PLC ID 확인 후 수정 */
        });
        alarmTable.setData(items);
      })
      .catch(function() {});
  }

  /* 시작 */
  fetchData();
  fetchAlarms();
  setInterval(fetchData,   INTERVAL);
  setInterval(fetchAlarms, INTERVAL);
})();
</script>
</body>
</html>
