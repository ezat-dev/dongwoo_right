
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../common_style.jsp" %>
<% String ctx = request.getContextPath(); %>
<link rel="stylesheet" href="<%= ctx %>/css/bcf7/style.css">
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
.group-2, .group-2 * {
  box-sizing: border-box;
  font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
}
.group-2 {
  position: relative;
  width: 100%;
  height: 894px;
  overflow: hidden;
}

.bcf7-auto-panel {
  position: absolute;
  left:   1330px;
  top:    0;
  right:  0;
  height: 395px;
  display: flex;
  flex-direction: column;
  border: 1.5px solid #2aada0;
  border-radius: 3px;
  overflow: hidden;
}
.bcf7-auto-title {
  background: #3dbdb0;
  color: #fff;
  font-size: 11px;
  font-weight: 700;
  text-align: center;
  padding: 3px 0;
  letter-spacing: 1px;
  flex-shrink: 0;
}
.bcf7-auto-grid {
  flex: 1;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2px;
  padding: 3px;
  overflow-y: hidden;
}
.bcf7-auto-item {
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 3px;
  border: 1px solid #5a9a30;
  font-size: 9px;
  font-weight: 700;
  background: #85c25f;
  color: #fff;
  text-align: center;
  padding: 2px 3px;
  line-height: 1.2;
}
.bcf7-auto-item.state-red    { background: #ff2222; color: #fff; border-color: #cc0000; }
.bcf7-auto-item.state-green  { background: #85c25f; color: #fff; border-color: #5a9a30; }
.bcf7-auto-item.state-gray   { background: #d9d9d9; color: #333; border-color: #999; }
.bcf7-auto-item.state-yellow { background: #f5c400; color: #333; border-color: #c8a000; }

.bcf7-bottom-panel {
  position: absolute;
  left:   0;
  top:    570px;
  right:  0;
  height: 270px;
  display: flex;
  flex-direction: row;
  gap: 4px;
  padding: 3px;
  overflow: hidden;
}

.bcf7-zone-panel {
  flex: 3;
  min-width: 0;
  border: 1.5px solid #888;
  border-radius: 3px;
  overflow: hidden;
  background: #e8e8e8;
}
.bcf7-zone-table {
  width: 100%;
  height: 100%;
  border-collapse: collapse;
  font-size: 12px;
  font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
  table-layout: fixed;
}
.bcf7-zone-table th,
.bcf7-zone-table td {
  border: 1px solid #90b8d0;
  text-align: center;
  padding: 1px 2px;
  white-space: nowrap;
  overflow: hidden;
}
.bcf7-zone-table thead tr th {
  background: #2a9d91;
  color: #fff;
  font-weight: 700;
  font-size: 12px;
  letter-spacing: .6px;
  padding: 5px 0;
}
.bcf7-zone-table thead tr th.th-empty {
  background: #1f9086;
  border: none;
}
.bcf7-zone-table thead tr th.th-red    { background: #c84040; color: #fff; }
.bcf7-zone-table thead tr th.th-yellow { background: #a08000; color: #fff; }
.bcf7-zone-table tbody tr td { background: #fff; }
.bcf7-zone-table tbody tr td.row-label {
  background: #c0d8ec;
  font-weight: 700;
  color: #0d2a42;
  text-align: left;
  padding-left: 5px;
  font-size: 10px;
  white-space: nowrap;
}

.zbox7 {
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
.zbox7.yellow { background: #fffcc0; border-color: #b0a000; color: #3a3000; }
.zbox7.cyan   { background: #b8eeff; border-color: #30a0cc; color: #002a44; }
.zbox7.empty  { background: #f4f4f4; border-color: #ccc;    color: #aaa; font-weight: 400; }

.bcf7-temp-panel {
  flex: 0 0 130px;
  display: flex;
  flex-direction: column;
  border: 1.5px solid #2aada0;
  border-radius: 3px;
  overflow: hidden;
}
.bcf7-panel-title {
  background: #3dbdb0;
  color: #fff;
  font-size: 11px;
  font-weight: 700;
  text-align: center;
  padding: 3px 0;
  letter-spacing: 1px;
}
.bcf7-tp-list {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 4px;
  gap: 3px;
  background: #eafaf8;
  border-top: 1px solid #2aada0;
}
.bcf7-tp-item {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 3px;
  padding: 0 4px;
  border-radius: 3px;
  border: 1px solid #b8e8e2;
  background: #fff;
}
.bcf7-tpi-lbl {
  flex: 0 0 38px;
  font-size: 10px;
  font-weight: 700;
  color: #b91c1c;
  white-space: nowrap;
  overflow: hidden;
}
.bcf7-tpi-lbl.blue { color: #1d4ed8; }
.bcf7-tpi-val {
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
.bcf7-tpi-val.blue { background: #bfdbfe; border-color: #3b82f6; color: #1e3a8a; }
.bcf7-tpi-unit {
  flex: 0 0 14px;
  font-size: 10px;
  font-weight: 700;
  color: #1a5c52;
  text-align: right;
}

.bcf7-alarm-panel {
  flex: 2;
  min-width: 0;
  border: 1.5px solid #2aada0;
  border-radius: 3px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}
.bcf7-alarm-body {
  flex: 1;
  min-height: 0;
  border-top: 1px solid #e8b0c0;
  overflow: hidden;
  position: relative;
}
.bcf7-alarm-body .tabulator,
.bcf7-alarm-body .tabulator-tableHolder { background: #fff0f3; border: none; }
.bcf7-alarm-body .tabulator-row,
.bcf7-alarm-body .tabulator-row.tabulator-row-even { background: #fff0f3; border-bottom: 1px solid #f8d5de; min-height: 52px; }
.bcf7-alarm-body .tabulator-row:hover { background: #fce0e6 !important; }
.bcf7-alarm-body .tabulator-cell { border-right: none; padding: 5px 6px; color: #3a0012; font-family: '맑은 고딕','Malgun Gothic',sans-serif; font-size: 15px; font-weight: 700; white-space: normal; word-break: break-word; line-height: 1.35; align-items: flex-start; overflow: hidden; }
.bcf7-alarm-body .tabulator-placeholder span { background: #fff0f3; color: #990022; font-family: '맑은 고딕','Malgun Gothic',sans-serif; font-size: 13px; }
.alarm-dot { display: inline-block; width: 10px; height: 10px; border-radius: 50%; background: #dd2244; vertical-align: middle; animation: alarm-pulse 1.2s ease-in-out infinite; }
.alarm-time-val { color: #990022; font-size: 14px; font-weight: 700; letter-spacing: .3px; font-variant-numeric: tabular-nums; }
@keyframes alarm-pulse {
  0%, 100% { opacity: 1;   box-shadow: 0 0 5px #dd2244; }
  50%       { opacity: 0.25; box-shadow: none; }
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

  <div class="group-2">

    <!-- 기존 설비 작화 (변경 없음) -->
    <div class="bcf-7-deatil">
      <img class="bcf-7-obj-1" src="<%= ctx %>/img/bcf7/bcf-7-obj-10.png" />
      <img class="bcf-7-obj-2" src="<%= ctx %>/img/bcf7/bcf-7-obj-20.png" />
      <img class="bcf-7-obj-3" src="<%= ctx %>/img/bcf7/bcf-7-obj-30.png" />
      <img class="bcf-7-tray-1 bcf8_23" src="<%= ctx %>/img/bcf7/bcf-7-tray-10.png" />
      <img class="bcf-7-tray-2 bcf8_7" src="<%= ctx %>/img/bcf7/bcf-7-tray-20.png" />
      <img class="bcf-7-obj-4" src="<%= ctx %>/img/bcf7/bcf-7-obj-40.png" />
      <img class="bcf-7-obj-5" src="<%= ctx %>/img/bcf7/bcf-7-obj-50.png" />
      <img class="bcf-7-obj-6" src="<%= ctx %>/img/bcf7/bcf-7-obj-60.png" />
      <img class="bcf-7-obj-7" src="<%= ctx %>/img/bcf7/bcf-7-obj-70.png" />
      <img class="bcf-7-pipe-off" src="<%= ctx %>/img/bcf7/bcf-7-pipe-off0.png" />
      <img class="bcf-7-pipe-on bcf8_218" src="<%= ctx %>/img/bcf7/bcf-7-pipe-on0.png" />
      <div class="bcf-7-obj-8"></div>
      <img class="bcf-7-pen-off" src="<%= ctx %>/img/bcf7/bcf-7-pen-off0.png" />
      <img class="bcf-7-pen-on bcf8_96" src="<%= ctx %>/img/bcf7/bcf-7-pen-on0.png" />
      <img class="bcf-7-propel-1 bcf8_96" src="<%= ctx %>/img/bcf7/bcf-7-propel-10.png" />
      <img class="bcf-7-door-open-1 bcf8_11" src="<%= ctx %>/img/bcf7/bcf-7-door-open-10.png" />
      <img class="bcf-7-door-close-1 bcf8_11" src="<%= ctx %>/img/bcf7/bcf-7-door-close-10.png" />
      <img class="bcf-7-bong-1" src="<%= ctx %>/img/bcf7/bcf-7-bong-10.png" />
      <img class="bcf-7-bong-2 bcf8_18" src="<%= ctx %>/img/bcf7/bcf-7-bong-20.png" />
      <img class="bcf-7-bong-3 bcf8_11" src="<%= ctx %>/img/bcf7/bcf-7-bong-30.png" />
      <img class="bcf-7-door-open-3 bcf8_17" src="<%= ctx %>/img/bcf7/bcf-7-door-open-30.png" />
      <img class="bcf-7-door-close-3 bcf8_17" src="<%= ctx %>/img/bcf7/bcf-7-door-close-30.png" />
      <img class="bcf-7-bong-4" src="<%= ctx %>/img/bcf7/bcf-7-bong-40.png" />
      <img class="bcf-7-bong-5 bcf8_35" src="<%= ctx %>/img/bcf7/bcf-7-bong-50.png" />
      <img class="bcf-7-bong-6 bcf8_18" src="<%= ctx %>/img/bcf7/bcf-7-bong-60.png" />
      <img class="bcf-7-motor-off-3" src="<%= ctx %>/img/bcf7/bcf-7-motor-off-30.png" />
      <img class="bcf-7-motor-green-3 bcf8_224" src="<%= ctx %>/img/bcf7/bcf-7-motor-green-30.png" />
      <img class="bcf-7-motor-yellow-3 bcf8_223" src="<%= ctx %>/img/bcf7/bcf-7-motor-yellow-30.png" />
      <div class="bcf-7-oil"></div>
      <img class="bcf-7-elv-1" src="<%= ctx %>/img/bcf7/bcf-7-elv-10.png" />
      <img class="bcf-7-tray-7 bcf8_15" src="<%= ctx %>/img/bcf7/bcf-7-tray-70.png" />
      <img class="bcf-7-air-cycle bcf8_33" src="<%= ctx %>/img/bcf7/bcf-7-air-cycle0.png" />
      <div class="bcf-7-auto-box-2 bcf8_269"></div>
      <div class="bcf-7-straight-box-2 bcf8_33"></div>
      <div class="bcf-7-auto-box-1 bcf8_224"></div>
      <div class="bcf-7-straight-box-1 bcf8_223"></div>
      <div class="bcf-7-dt-3 bcf8_15"></div>
      <div class="bcf-7-sw-red-1"></div>
      <div class="bcf-7-sw-green-1 bcf8_140"></div>
      <div class="bcf-7-sw-red-2"></div>
      <div class="bcf-7-sw-green-2 bcf8_38"></div>
      <div class="bcf-7-flame-red-2"></div>
      <div class="bcf-7-flame-green-2 bcf8_39"></div>
      <img class="bcf-7-stick-off-1" src="<%= ctx %>/img/bcf7/bcf-7-stick-off-10.png" />
      <img class="bcf-7-stick-on-1 bcf8_1" src="<%= ctx %>/img/bcf7/bcf-7-stick-on-10.png" />
      <img class="bcf-7-stick-off-2" src="<%= ctx %>/img/bcf7/bcf-7-stick-off-20.png" />
      <img class="bcf-7-stick-on-2 bcf8_1" src="<%= ctx %>/img/bcf7/bcf-7-stick-on-20.png" />
      <img class="bcf-7-point-1" src="<%= ctx %>/img/bcf7/bcf-7-point-10.png" />
      <img class="bcf-7-mini-1 bcf8_20" src="<%= ctx %>/img/bcf7/bcf-7-mini-10.png" />
      <img class="bcf-7-stick-1" src="<%= ctx %>/img/bcf7/bcf-7-stick-10.png" />
      <img class="bcf-7-mini-2 bcf8_19" src="<%= ctx %>/img/bcf7/bcf-7-mini-20.png" />
      <img class="bcf-7-jog-green-1" src="<%= ctx %>/img/bcf7/bcf-7-jog-green-10.png" />
      <img class="bcf-7-jog-off-1" src="<%= ctx %>/img/bcf7/bcf-7-jog-off-10.png" />
      <img class="bcf-7-jog-yellow-1 bcf8_86 bcf8_7" src="<%= ctx %>/img/bcf7/bcf-7-jog-yellow-10.png" />
      <img class="bcf-7-jog-green-2" src="<%= ctx %>/img/bcf7/bcf-7-jog-green-20.png" />
      <img class="bcf-7-jog-off-2" src="<%= ctx %>/img/bcf7/bcf-7-jog-off-20.png" />
      <img class="bcf-7-jog-yellow-2" src="<%= ctx %>/img/bcf7/bcf-7-jog-yellow-20.png" />
      <img class="bcf-7-jog-off-3" src="<%= ctx %>/img/bcf7/bcf-7-jog-off-30.png" />
      <img class="bcf-7-motor-green-1 bcf8_85 bcf8_7" src="<%= ctx %>/img/bcf7/bcf-7-motor-green-10.png" />
      <img class="bcf-7-motor-off-1 bcf8_9" src="<%= ctx %>/img/bcf7/bcf-7-motor-off-10.png" />
      <img class="bcf-7-motor-yellow-1 bcf8_89 bcf8_10 bcf8_46" src="<%= ctx %>/img/bcf7/bcf-7-motor-yellow-10.png" />
      <img class="bcf-7-motor-green-2 bcf8_85 bcf8_101" src="<%= ctx %>/img/bcf7/bcf-7-motor-green-20.png" />
      <img class="bcf-7-motor-off-2 bcf8_6" src="<%= ctx %>/img/bcf7/bcf-7-motor-off-20.png" />
      <img class="bcf-7-motor-yellow-2 bcf8_86 bcf8_6" src="<%= ctx %>/img/bcf7/bcf-7-motor-yellow-20.png" />
      <img class="bcf-7-sensor-off-1" src="<%= ctx %>/img/bcf7/bcf-7-sensor-off-10.png" />
      <img class="bcf-7-sensor-on-1 bcf8_26" src="<%= ctx %>/img/bcf7/bcf-7-sensor-on-10.png" />
      <img class="bcf-7-door-close-2 bcf8_13" src="<%= ctx %>/img/bcf7/bcf-7-door-close-20.png" />
      <img class="bcf-7-door-open-2 bcf8_13" src="<%= ctx %>/img/bcf7/bcf-7-door-open-20.png" />
      <img class="bcf-7-obj-9" src="<%= ctx %>/img/bcf7/bcf-7-obj-90.png" />
      <img class="bcf-7-elv-2" src="<%= ctx %>/img/bcf7/bcf-7-elv-20.png" />
      <img class="bcf-7-tray-3 bcf8_23" src="<%= ctx %>/img/bcf7/bcf-7-tray-30.png" />
      <img class="bcf-7-tray-4 bcf8_7" src="<%= ctx %>/img/bcf7/bcf-7-tray-40.png" />
      <img class="bcf-7-tray-5 bcf8_116" src="<%= ctx %>/img/bcf7/bcf-7-tray-50.png" />
      <img class="bcf-7-tray-6 bcf8_117" src="<%= ctx %>/img/bcf7/bcf-7-tray-60.png" />
      <img class="bcf-7-tray-8 bcf8_22" src="<%= ctx %>/img/bcf7/bcf-7-tray-80.png" />
      <img class="bcf-7-bong-7" src="<%= ctx %>/img/bcf7/bcf-7-bong-70.png" />
      <img class="bcf-7-bong-8 bcf8_14" src="<%= ctx %>/img/bcf7/bcf-7-bong-80.png" />
      <img class="bcf-7-bong-9 bcf8_15 bcf8_51" src="<%= ctx %>/img/bcf7/bcf-7-bong-90.png" />
      <img class="bcf-7-obj-10" src="<%= ctx %>/img/bcf7/bcf-7-obj-100.png" />
      <img class="bcf-7-obj-11 bcf8_27" src="<%= ctx %>/img/bcf7/bcf-7-obj-110.png" />
      <img class="bcf-7-firepipe-off bcf8_342" src="<%= ctx %>/img/bcf7/bcf-7-firepipe-off0.png" />
      <img class="bcf-7-rotate-1 bcf8_110 bcf8_111" src="<%= ctx %>/img/bcf7/bcf-7-rotate-10.png" />
      <img class="bcf-7-rotate-2 bcf8_110 bcf8_111 bcf8_46 bcf8_10" src="<%= ctx %>/img/bcf7/bcf-7-rotate-20.png" />
      <img class="bcf-7-rotate-3" src="<%= ctx %>/img/bcf7/bcf-7-rotate-30.png" />
      <img class="bcf-7-arrow-1 bcf8_30 bcf8_14" src="<%= ctx %>/img/bcf7/bcf-7-arrow-10.png" />
      <img class="bcf-7-arrow-2 bcf8_30 bcf8_15" src="<%= ctx %>/img/bcf7/bcf-7-arrow-20.png" />
      <div class="bcf-7-dt-1 bcf8_116"></div>
      <div class="bcf-7-dt-2 bcf8_117"></div>
    </div>

    <!-- ═══ [우측] 자동운전 조건 - 2열 10행 ═══ -->
    <div class="bcf7-auto-panel">
      <div class="bcf7-auto-title">자동운전 조건</div>
      <div class="bcf7-auto-grid">
        <div class="bcf7-auto-item state-gray" data-tag="bcf8_210" data-gray="true">출구문열림SV</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf8_212" data-gray="true">출구문닫힘SV</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf8_215" data-gray="true">본실 처리품 유무</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf8_217" data-gray="true">유조 처리품 유무</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf8_230" data-gray="true">본처리실 히터 ON</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf8_231" data-gray="true">본처리실 히터 OFF</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf8_232" data-gray="true">유조 히터 ON</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf8_233" data-gray="true">유조 히터 OFF</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf8_234" data-gray="true">본처리실 FAN ON</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf8_235" data-gray="true">본처리실 FAN OFF</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf8_236" data-gray="true">아지테이터 수동</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf8_237" data-gray="true">아지테이터 자동</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf8_238" data-gray="true">아지테이터 OFF</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf8_239" data-gray="true">열교환기 펌프 수동</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf8_240" data-gray="true">열교환기 펌프 자동</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf8_241" data-gray="true">열교환기 펌프 OFF</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf8_242" data-gray="true">ENRICH GAS 수동</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf8_243" data-gray="true">ENRICH GAS 자동</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf8_244" data-gray="true">ENRICH GAS OFF</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf8_245" data-gray="true">NH3 GAS 수동</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf8_246" data-gray="true">NH3 GAS 자동</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf8_247" data-gray="true">NH3 GAS OFF</div>
      </div>
    </div>

    <!-- ═══ [하단] 존구간(좌) + 온도CP(중) + 현재경보(우) ═══ -->
    <div class="bcf7-bottom-panel">

      <!-- 좌: 존구간 테이블 -->
      <div class="bcf7-zone-panel">
        <table class="bcf7-zone-table">
          <thead>
            <tr>
              <th class="th-empty" style="width:70px;"></th>
              <th>승온1</th>
              <th>승온2</th>
              <th class="th-red">침탄1</th>
              <th class="th-red">침탄2</th>
              <th>확산1</th>
              <th>확산2</th>
              <th>강온</th>
              <th>유조</th>
              <th>드랍</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td class="row-label">시간(min) PV</td>
              <td><div class="zbox7 BCF6_16">--</div></td>
              <td><div class="zbox7 BCF6_17">--</div></td>
              <td><div class="zbox7 BCF6_18">--</div></td>
              <td><div class="zbox7 BCF6_19">--</div></td>
              <td><div class="zbox7 BCF6_20">--</div></td>
              <td><div class="zbox7 BCF6_21">--</div></td>
              <td><div class="zbox7 BCF6_22">--</div></td>
              <td><div class="zbox7 BCF6_24">--</div></td>
              <td><div class="zbox7 BCF6_26">--</div></td>
            </tr>
            <tr>
              <td class="row-label">시간(min) SP</td>
              <td><div class="zbox7 yellow BCF6_31">--</div></td>
              <td><div class="zbox7 yellow BCF6_32">--</div></td>
              <td><div class="zbox7 yellow BCF6_33">--</div></td>
              <td><div class="zbox7 yellow BCF6_34">--</div></td>
              <td><div class="zbox7 yellow BCF6_35">--</div></td>
              <td><div class="zbox7 yellow BCF6_36">--</div></td>
              <td><div class="zbox7 yellow BCF6_37">--</div></td>
              <td><div class="zbox7 yellow BCF6_38">--</div></td>
              <td><div class="zbox7 yellow BCF6_39">--</div></td>
            </tr>
            <tr>
              <td class="row-label">온도(°C) SP</td>
              <td><div class="zbox7 yellow BCF6_41">--</div></td>
              <td><div class="zbox7 yellow BCF6_42">--</div></td>
              <td><div class="zbox7 yellow BCF6_43">--</div></td>
              <td><div class="zbox7 yellow BCF6_44">--</div></td>
              <td><div class="zbox7 yellow BCF6_45">--</div></td>
              <td><div class="zbox7 yellow BCF6_46">--</div></td>
              <td><div class="zbox7 yellow BCF6_47">--</div></td>
              <td><div class="zbox7 yellow BCF6_48">--</div></td>
              <td><div class="zbox7 empty"></div></td>
            </tr>
            <tr>
              <td class="row-label">온도(°C) PV</td>
              <td><div class="zbox7 BCF6_49">--</div></td>
              <td><div class="zbox7 BCF6_49">--</div></td>
              <td><div class="zbox7 BCF6_49">--</div></td>
              <td><div class="zbox7 BCF6_49">--</div></td>
              <td><div class="zbox7 BCF6_49">--</div></td>
              <td><div class="zbox7 BCF6_49">--</div></td>
              <td><div class="zbox7 BCF6_49">--</div></td>
              <td><div class="zbox7 BCF6_50">--</div></td>
              <td><div class="zbox7 empty"></div></td>
            </tr>
            <tr>
              <td class="row-label">CP(%) SP</td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 yellow BCF6_51">--</div></td>
              <td><div class="zbox7 yellow BCF6_52">--</div></td>
              <td><div class="zbox7 yellow BCF6_53">--</div></td>
              <td><div class="zbox7 yellow BCF6_54">--</div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
            </tr>
            <tr>
              <td class="row-label">CP(%) PV</td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 cyan BCF6_55">--</div></td>
              <td><div class="zbox7 cyan BCF6_55">--</div></td>
              <td><div class="zbox7 cyan BCF6_55">--</div></td>
              <td><div class="zbox7 cyan BCF6_55">--</div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
            </tr>
            <tr>
              <td class="row-label">NH3(%) SP</td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 yellow BCF6_56">--</div></td>
              <td><div class="zbox7 yellow BCF6_57">--</div></td>
              <td><div class="zbox7 yellow BCF6_58">--</div></td>
              <td><div class="zbox7 yellow BCF6_59">--</div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
            </tr>
            <tr>
              <td class="row-label">NH3(%) PV</td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 cyan BCF6_60">--</div></td>
              <td><div class="zbox7 cyan BCF6_60">--</div></td>
              <td><div class="zbox7 cyan BCF6_60">--</div></td>
              <td><div class="zbox7 cyan BCF6_60">--</div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- 중: 온도 및 CP (세로 목록) -->
      <div class="bcf7-temp-panel">
        <div class="bcf7-panel-title">온도 및 CP</div>
        <div class="bcf7-tp-list">
          <div class="bcf7-tp-item">
            <span class="bcf7-tpi-lbl">침탄실</span>
            <div class="bcf7-tpi-val bcf8_44611">--</div>
            <span class="bcf7-tpi-unit">℃</span>
          </div>
          <div class="bcf7-tp-item">
            <span class="bcf7-tpi-lbl">유조</span>
            <div class="bcf7-tpi-val bcf8_44612">--</div>
            <span class="bcf7-tpi-unit">℃</span>
          </div>
          <div class="bcf7-tp-item">
            <span class="bcf7-tpi-lbl blue">CP</span>
            <div class="bcf7-tpi-val blue bcf8_44613">--</div>
            <span class="bcf7-tpi-unit">%</span>
          </div>
          <div class="bcf7-tp-item">
            <span class="bcf7-tpi-lbl blue">침탄SP</span>
            <div class="bcf7-tpi-val blue bcf8_40003">--</div>
            <span class="bcf7-tpi-unit">%</span>
          </div>
          <div class="bcf7-tp-item">
            <span class="bcf7-tpi-lbl blue">유조SP</span>
            <div class="bcf7-tpi-val blue bcf8_40004">--</div>
            <span class="bcf7-tpi-unit">%</span>
          </div>
          <div class="bcf7-tp-item">
            <span class="bcf7-tpi-lbl blue">CPSP</span>
            <div class="bcf7-tpi-val blue bcf8_40007">--</div>
            <span class="bcf7-tpi-unit">%</span>
          </div>
        </div>
      </div>

      <!-- 우: 현재 경보 -->
      <div class="bcf7-alarm-panel">
        <div class="bcf7-panel-title">현재 경보</div>
        <div class="bcf7-alarm-body"></div>
      </div>

    </div><!-- /bcf7-bottom-panel -->

  </div><!-- /group-2 -->
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

  // 알람 이미지 초기 숨김 (PLC 수신 전 노출 방지)
  document.querySelectorAll('[class*="-alarm-"]:not([class*="-alarm-panel"]):not([class*="-alarm-body"])').forEach(function(el) { el.style.visibility = 'hidden'; });

  document.querySelectorAll('[class]').forEach(function(el) {
    el.className.split(/\s+/).forEach(function(cls) {
      var mLow = cls.match(/^bcf8_(\d+)$/);
      if (mLow) {
        if (parseInt(mLow[1], 10) >= 40000) {
          var apiTag = 'bcf8_s_' + mLow[1];
          if (!wordElMap[apiTag]) wordElMap[apiTag] = [];
          wordElMap[apiTag].push(el);
        } else {
          if (!bitElMap[cls]) bitElMap[cls] = [];
          bitElMap[cls].push(el);
        }
      } else if (/^BCF8_\d+$/.test(cls)) {
        var apiTag = 'bcf8_s_' + cls.slice(5);
        if (!wordElMap[apiTag]) wordElMap[apiTag] = [];
        wordElMap[apiTag].push(el);
      } else if (/^BCF6_\d+$/.test(cls)) {
        var apiTag = 'bcf8_s_' + cls.slice(5);
        if (!wordElMap[apiTag]) wordElMap[apiTag] = [];
        wordElMap[apiTag].push(el);
      }
    });
  });

  var statusElMap = {};
  document.querySelectorAll('[data-tag]').forEach(function(el) {
    var tag = el.getAttribute('data-tag');
    if (/^bcf8_\d+$/.test(tag)) {
      if (!statusElMap[tag]) statusElMap[tag] = [];
      statusElMap[tag].push(el);
    }
  });

  var allTags = Object.keys(wordElMap).concat(Object.keys(bitElMap))
    .concat(Object.keys(statusElMap).filter(function(t) { return !bitElMap[t]; }));

  var CP_TAG = /_(44613|40003|40004|40007|15|26)$/;

  function updateStatusItem(el, val) {
    var isOn = (val === 1 || val === true);
    var isGray = el.getAttribute('data-gray') === 'true';
    el.classList.remove('state-red', 'state-green', 'state-gray');
    el.classList.add(isOn ? 'state-green' : (isGray ? 'state-gray' : 'state-red'));
  }

  function applyData(data) {
    /* zone table 값 확인 로그 */
    var z = function(n) { return data['bcf8_s_' + n]; };
    console.log('[BCF8 시간PV]  승온1:%o 승온2:%o 침탄1:%o 침탄2:%o 확산1:%o 확산2:%o 강온:%o 유조:%o 드랍:%o', z(16),z(17),z(18),z(19),z(20),z(21),z(22),z(24),z(26));
    console.log('[BCF8 시간SP]  승온1:%o 승온2:%o 침탄1:%o 침탄2:%o 확산1:%o 확산2:%o 강온:%o 유조:%o 드랍:%o', z(31),z(32),z(33),z(34),z(35),z(36),z(37),z(38),z(39));
    console.log('[BCF8 온도SP]  승온1:%o 승온2:%o 침탄1:%o 침탄2:%o 확산1:%o 확산2:%o 강온:%o 유조:%o',       z(41),z(42),z(43),z(44),z(45),z(46),z(47),z(48));
    console.log('[BCF8 온도PV]  본체(49):%o 유조(50):%o', z(49),z(50));
    console.log('[BCF8 CP/NH3]  cpSP침탄1:%o 침탄2:%o 확산1:%o 확산2:%o | cpPV:%o | nh3SP침탄1:%o 침탄2:%o 확산1:%o 확산2:%o | nh3PV:%o', z(51),z(52),z(53),z(54),z(55),z(56),z(57),z(58),z(59),z(60));

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
    Object.keys(statusElMap).forEach(function(tag) {
      if (data[tag] == null) return;
      statusElMap[tag].forEach(function(el) { updateStatusItem(el, data[tag]); });
    });
  }

  var busy = false;
  function fetchData() {
    if (busy) return;
    busy = true;
    fetch(ctx + '/monitor/snapshot')
    .then(function(r) { return r.ok ? r.json() : Promise.reject(r.status); })
    .then(function(data) { applyData(data); })
    .catch(function(err) { console.warn('[BCF8] PLC fetch 실패:', err); })
    .finally(function() { busy = false; });
  }

  var alarmTable = new Tabulator('.bcf7-alarm-body', {
    height: '100%', layout: 'fitColumns', headerVisible: false,
    placeholder: '현재 경보 없음', rowHeight: 52, data: [],
    columns: [
      { title: '', field: 'dot', width: 22, resizable: false, headerSort: false,
        formatter: function() { return '<span class="alarm-dot"></span>'; } },
      { title: '시간', field: 'occurTime', width: 152, resizable: false, headerSort: false,
        formatter: function(cell) {
          var v = cell.getValue() || '';
          return '<span class="alarm-time-val">' + (v.length >= 16 ? v.substring(0, 16) : v) + '</span>';
        } },
      { title: '경보 내용', field: 'alarmMsg', headerSort: false,
        formatter: function(cell) { return cell.getValue() || '알람'; } }
    ]
  });

  function fetchAlarms() {
    fetch(ctx + '/alarm/active/list?limit=200')
      .then(function(r) { return r.ok ? r.json() : []; })
      .then(function(list) {
        alarmTable.setData((Array.isArray(list) ? list : []).filter(function(a) {
          return a.plcId === 'dongwoo_08';
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