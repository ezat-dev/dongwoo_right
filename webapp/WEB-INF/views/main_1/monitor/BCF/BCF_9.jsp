
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

/* ═══════════════════════════════════════════════
   [우측] 자동운전 조건 - 2열 그리드 (10행)
   ═══════════════════════════════════════════════ */
.bcf7-auto-panel {
  position: absolute;
  left:   1330px;
  top:    0;
  right:  0;
  height: 360px;
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

/* ═══════════════════════════════════════════════
   [하단] 존구간(좌) + 온도CP/현재경보(우)
   ═══════════════════════════════════════════════ */
.bcf7-bottom-panel {
  position: absolute;
  left:   0;
  top:    570px;
  right:  0;
  height: 210px;
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
  font-size: 11px;
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
  border-top: 1px solid #f0b888;
  overflow: hidden;
  position: relative;
}
.bcf7-alarm-body .tabulator,
.bcf7-alarm-body .tabulator-tableHolder { background: #fff5ee; border: none; }
.bcf7-alarm-body .tabulator-row,
.bcf7-alarm-body .tabulator-row.tabulator-row-even { background: #fff5ee; border-bottom: 1px solid #fce0c8; min-height: 36px; }
.bcf7-alarm-body .tabulator-row:hover { background: #ffe8d6 !important; }
.bcf7-alarm-body .tabulator-cell { border-right: none; padding: 4px 6px; color: #4a1500; font-family: '맑은 고딕','Malgun Gothic',sans-serif; font-size: 12px; font-weight: 700; white-space: normal; word-break: break-word; line-height: 1.35; overflow: hidden; }
.bcf7-alarm-body .tabulator-placeholder span { background: #fff5ee; color: #aa3300; font-family: '맑은 고딕','Malgun Gothic',sans-serif; font-size: 12px; }
.alarm-dot { display: inline-block; width: 10px; height: 10px; border-radius: 50%; background: #ee6600; vertical-align: middle; animation: alarm-pulse 1.2s ease-in-out infinite; }
@keyframes alarm-pulse {
  0%, 100% { opacity: 1;   box-shadow: 0 0 5px #ee6600; }
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
      <img class="bcf-7-tray-1 bcf9_2" src="<%= ctx %>/img/bcf7/bcf-7-tray-10.png" />
      <img class="bcf-7-tray-2 bcf9_1" src="<%= ctx %>/img/bcf7/bcf-7-tray-20.png" />
      <img class="bcf-7-obj-4" src="<%= ctx %>/img/bcf7/bcf-7-obj-40.png" />
      <img class="bcf-7-obj-5" src="<%= ctx %>/img/bcf7/bcf-7-obj-50.png" />
      <img class="bcf-7-obj-6" src="<%= ctx %>/img/bcf7/bcf-7-obj-60.png" />
      <img class="bcf-7-obj-7" src="<%= ctx %>/img/bcf7/bcf-7-obj-70.png" />
      <img class="bcf-7-pipe-off" src="<%= ctx %>/img/bcf7/bcf-7-pipe-off0.png" />
      <img class="bcf-7-pipe-on bcf9_152" src="<%= ctx %>/img/bcf7/bcf-7-pipe-on0.png" />
      <div class="bcf-7-obj-8"></div>
      <img class="bcf-7-pen-off" src="<%= ctx %>/img/bcf7/bcf-7-pen-off0.png" />
      <img class="bcf-7-pen-on bcf9_155" src="<%= ctx %>/img/bcf7/bcf-7-pen-on0.png" />
      <img class="bcf-7-propel-1 bcf9_155" src="<%= ctx %>/img/bcf7/bcf-7-propel-10.png" />
      <img class="bcf-7-door-open-1 bcf9_12" src="<%= ctx %>/img/bcf7/bcf-7-door-open-10.png" />
      <img class="bcf-7-door-close-1 bcf9_12" src="<%= ctx %>/img/bcf7/bcf-7-door-close-10.png" />
      <img class="bcf-7-bong-1" src="<%= ctx %>/img/bcf7/bcf-7-bong-10.png" />
      <img class="bcf-7-bong-2 bcf9_13 bcf9_42" src="<%= ctx %>/img/bcf7/bcf-7-bong-20.png" />
      <img class="bcf-7-bong-3 bcf9_12 bcf9_47" src="<%= ctx %>/img/bcf7/bcf-7-bong-30.png" />
      <img class="bcf-7-door-open-3 bcf9_19" src="<%= ctx %>/img/bcf7/bcf-7-door-open-30.png" />
      <img class="bcf-7-door-close-3 bcf9_19" src="<%= ctx %>/img/bcf7/bcf-7-door-close-30.png" />
      <img class="bcf-7-bong-4" src="<%= ctx %>/img/bcf7/bcf-7-bong-40.png" />
      <img class="bcf-7-bong-5 bcf9_20 bcf9_54" src="<%= ctx %>/img/bcf7/bcf-7-bong-50.png" />
      <img class="bcf-7-bong-6 bcf9_19" src="<%= ctx %>/img/bcf7/bcf-7-bong-60.png" />
      <img class="bcf-7-motor-off-3" src="<%= ctx %>/img/bcf7/bcf-7-motor-off-30.png" />
      <img class="bcf-7-motor-green-3 bcf9_185" src="<%= ctx %>/img/bcf7/bcf-7-motor-green-30.png" />
      <img class="bcf-7-motor-yellow-3 bcf9_160" src="<%= ctx %>/img/bcf7/bcf-7-motor-yellow-30.png" />
      <div class="bcf-7-oil"></div>
      <img class="bcf-7-elv-1" src="<%= ctx %>/img/bcf7/bcf-7-elv-10.png" />
      <img class="bcf-7-tray-7 bcf9_18 bcf9_145" src="<%= ctx %>/img/bcf7/bcf-7-tray-70.png" />
      <img class="bcf-7-air-cycle bcf9_157" src="<%= ctx %>/img/bcf7/bcf-7-air-cycle0.png" />
      <div class="bcf-7-auto-box-2 bcf9_52"></div>
      <div class="bcf-7-straight-box-2 bcf9_51"></div>
      <div class="bcf-7-auto-box-1"></div>
      <div class="bcf-7-straight-box-1 bcf9_160"></div>
      <div class="bcf-7-dt-3 bcf9_18"></div>
      <div class="bcf-7-sw-red-1"></div>
      <div class="bcf-7-sw-green-1 bcf9_38"></div>
      <div class="bcf-7-sw-red-2"></div>
      <div class="bcf-7-sw-green-2 bcf9_44"></div>
      <div class="bcf-7-flame-red-2"></div>
      <div class="bcf-7-flame-green-2 bcf9_117"></div>
      <img class="bcf-7-stick-off-1" src="<%= ctx %>/img/bcf7/bcf-7-stick-off-10.png" />
      <img class="bcf-7-stick-on-1 bcf9_237" src="<%= ctx %>/img/bcf7/bcf-7-stick-on-10.png" />
      <img class="bcf-7-stick-off-2" src="<%= ctx %>/img/bcf7/bcf-7-stick-off-20.png" />
      <img class="bcf-7-stick-on-2 bcf9_237" src="<%= ctx %>/img/bcf7/bcf-7-stick-on-20.png" />
      <img class="bcf-7-point-1" src="<%= ctx %>/img/bcf7/bcf-7-point-10.png" />
      <img class="bcf-7-mini-1 bcf9_47" src="<%= ctx %>/img/bcf7/bcf-7-mini-10.png" />
      <img class="bcf-7-stick-1" src="<%= ctx %>/img/bcf7/bcf-7-stick-10.png" />
      <img class="bcf-7-mini-2 bcf9_11 bcf9_53" src="<%= ctx %>/img/bcf7/bcf-7-mini-20.png" />
      <img class="bcf-7-jog-green-1" src="<%= ctx %>/img/bcf7/bcf-7-jog-green-10.png" />
      <img class="bcf-7-jog-off-1" src="<%= ctx %>/img/bcf7/bcf-7-jog-off-10.png" />
      <img class="bcf-7-jog-yellow-1" src="<%= ctx %>/img/bcf7/bcf-7-jog-yellow-10.png" />
      <img class="bcf-7-jog-green-2" src="<%= ctx %>/img/bcf7/bcf-7-jog-green-20.png" />
      <img class="bcf-7-jog-off-2" src="<%= ctx %>/img/bcf7/bcf-7-jog-off-20.png" />
      <img class="bcf-7-jog-yellow-2" src="<%= ctx %>/img/bcf7/bcf-7-jog-yellow-20.png" />
      <img class="bcf-7-jog-off-3" src="<%= ctx %>/img/bcf7/bcf-7-jog-off-30.png" />
      <img class="bcf-7-motor-green-1 bcf9_74 bcf9_9 bcf9_52" src="<%= ctx %>/img/bcf7/bcf-7-motor-green-10.png" />
      <img class="bcf-7-motor-off-1" src="<%= ctx %>/img/bcf7/bcf-7-motor-off-10.png" />
      <img class="bcf-7-motor-yellow-1 bcf9_76 bcf9_9 bcf9_52" src="<%= ctx %>/img/bcf7/bcf-7-motor-yellow-10.png" />
      <img class="bcf-7-motor-green-2 bcf9_74 bcf9_101 bcf9_341" src="<%= ctx %>/img/bcf7/bcf-7-motor-green-20.png" />
      <img class="bcf-7-motor-off-2" src="<%= ctx %>/img/bcf7/bcf-7-motor-off-20.png" />
      <img class="bcf-7-motor-yellow-2 bcf9_89 bcf9_9 bcf9_45" src="<%= ctx %>/img/bcf7/bcf-7-motor-yellow-20.png" />
      <img class="bcf-7-sensor-off-1" src="<%= ctx %>/img/bcf7/bcf-7-sensor-off-10.png" />
      <img class="bcf-7-sensor-on-1 bcf9_128" src="<%= ctx %>/img/bcf7/bcf-7-sensor-on-10.png" />
      <img class="bcf-7-door-close-2 bcf9_14" src="<%= ctx %>/img/bcf7/bcf-7-door-close-20.png" />
      <img class="bcf-7-door-open-2 bcf9_14" src="<%= ctx %>/img/bcf7/bcf-7-door-open-20.png" />
      <img class="bcf-7-obj-9" src="<%= ctx %>/img/bcf7/bcf-7-obj-90.png" />
      <img class="bcf-7-elv-2" src="<%= ctx %>/img/bcf7/bcf-7-elv-20.png" />
      <img class="bcf-7-tray-3 bcf9_2" src="<%= ctx %>/img/bcf7/bcf-7-tray-30.png" />
      <img class="bcf-7-tray-4 bcf9_1" src="<%= ctx %>/img/bcf7/bcf-7-tray-40.png" />
      <img class="bcf-7-tray-5 bcf9_144" src="<%= ctx %>/img/bcf7/bcf-7-tray-50.png" />
      <img class="bcf-7-tray-6 bcf9_145" src="<%= ctx %>/img/bcf7/bcf-7-tray-60.png" />
      <img class="bcf-7-tray-8 bcf9_22" src="<%= ctx %>/img/bcf7/bcf-7-tray-80.png" />
      <img class="bcf-7-bong-7" src="<%= ctx %>/img/bcf7/bcf-7-bong-70.png" />
      <img class="bcf-7-bong-8 bcf9_18 bcf9_49" src="<%= ctx %>/img/bcf7/bcf-7-bong-80.png" />
      <img class="bcf-7-bong-9 bcf9_18 bcf9_50" src="<%= ctx %>/img/bcf7/bcf-7-bong-90.png" />
      <img class="bcf-7-obj-10" src="<%= ctx %>/img/bcf7/bcf-7-obj-100.png" />
      <img class="bcf-7-obj-11 bcf9_6" src="<%= ctx %>/img/bcf7/bcf-7-obj-110.png" />
      <img class="bcf-7-firepipe-off" src="<%= ctx %>/img/bcf7/bcf-7-firepipe-off0.png" />
      <img class="bcf-7-rotate-1 bcf9_110 bcf9_111 bcf9_341" src="<%= ctx %>/img/bcf7/bcf-7-rotate-10.png" />
      <img class="bcf-7-rotate-2 bcf9_110 bcf9_10 bcf9_46 bcf9_10" src="<%= ctx %>/img/bcf7/bcf-7-rotate-20.png" />
      <img class="bcf-7-rotate-3" src="<%= ctx %>/img/bcf7/bcf-7-rotate-30.png" />
      <img class="bcf-7-arrow-1 bcf9_44 bcf9_49" src="<%= ctx %>/img/bcf7/bcf-7-arrow-10.png" />
      <img class="bcf-7-arrow-2 bcf9_44 bcf9_18 bcf9_50" src="<%= ctx %>/img/bcf7/bcf-7-arrow-20.png" />
      <div class="bcf-7-dt-1 bcf9_144"></div>
      <div class="bcf-7-dt-2 bcf9_145"></div>
    </div>

    <!-- ═══ [우측] 자동운전 조건 - 2열 10행 ═══ -->
    <div class="bcf7-auto-panel">
      <div class="bcf7-auto-title">자동운전 조건</div>
      <div class="bcf7-auto-grid">
        <div class="bcf7-auto-item state-gray" data-tag="bcf9_145" data-gray="true" data-text-0="추출포크 후진"      data-text-1="추출포크 후진"     >추출포크 후진</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf9_140" data-gray="true" data-text-0="입구 커튼 S/W ON"  data-text-1="입구 커튼 S/W ON" >입구 커튼 S/W ON</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf9_144" data-gray="true" data-text-0="포크베이스 하강"    data-text-1="포크베이스 하강"   >포크베이스 하강</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf9_139" data-gray="true" data-text-0="출구 커튼 S/W ON"  data-text-1="출구 커튼 S/W ON" >출구 커튼 S/W ON</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf9_142" data-gray="true" data-text-0="보조롤러 하강"      data-text-1="보조롤러 하강"     >보조롤러 하강</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf9_235" data-gray="true" data-text-0="출구 FLAME ON"     data-text-1="출구 FLAME ON"    >출구 FLAME ON</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf9_143" data-gray="true" data-text-0="입구문 닫힘"        data-text-1="입구문 닫힘"       >입구문 닫힘</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf9_6"   data-gray="true" data-text-0="배기 FLAME ON"     data-text-1="배기 FLAME ON"    >배기 FLAME ON</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf9_141" data-gray="true" data-text-0="중간문 닫힘"        data-text-1="중간문 닫힘"       >중간문 닫힘</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf9_146" data-gray="true" data-text-0="비상정지(판넬)"     data-text-1="비상정지(판넬)"    >비상정지(판넬)</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf9_17"  data-gray="true" data-text-0="E/V 상승"          data-text-1="E/V 상승"         >E/V 상승</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf9_147" data-gray="true" data-text-0="비상정지(입구)"     data-text-1="비상정지(입구)"    >비상정지(입구)</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf9_20"  data-gray="true" data-text-0="출구문 닫힘"        data-text-1="출구문 닫힘"       >출구문 닫힘</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf9_148" data-gray="true" data-text-0="비상정지(출구)"     data-text-1="비상정지(출구)"    >비상정지(출구)</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf9_152" data-gray="true" data-text-0="자동스텝1 준비완료" data-text-1="자동스텝1 준비완료">자동스텝1 준비완료</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf9_149" data-gray="true" data-text-0="자동SS(입구)"       data-text-1="자동SS(입구)"      >자동SS(입구)</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf9_153" data-gray="true" data-text-0="자동스텝2 준비완료" data-text-1="자동스텝2 준비완료">자동스텝2 준비완료</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf9_150" data-gray="true" data-text-0="자동SS(출구)"       data-text-1="자동SS(출구)"      >자동SS(출구)</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf9_151" data-gray="true" data-text-0="PLC 컨트롤 (PC OFF)" data-text-1="PLC 컨트롤 (PC OFF)">PLC 컨트롤 (PC OFF)</div>
        <div class="bcf7-auto-item state-gray" data-tag="bcf9_145" data-gray="true" data-text-0="유조 처리품 없음"   data-text-1="유조 처리품 없음"  >유조 처리품 없음</div>
      </div>
    </div>

    <!-- ═══ [하단] 존구간(좌) + 온도CP(중) + 현재경보(우) ═══ -->
    <div class="bcf7-bottom-panel">

      <!-- 좌: 존구간 테이블 -->
      <div class="bcf7-zone-panel">
        <table class="bcf7-zone-table">
          <thead>
            <tr>
              <th class="th-empty" style="width:72px;"></th>
              <th>승온</th>
              <th class="th-red">침탄</th>
              <th>확산</th>
              <th>강온</th>
              <th>균열</th>
              <th class="th-yellow">강온</th>
              <th>드레이</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td class="row-label">시간 (min) PV</td>
              <td><div class="zbox7 BCF9_13"  >--</div></td>
              <td><div class="zbox7 BCF9_390" >--</div></td>
              <td><div class="zbox7 BCF9_21"  >--</div></td>
              <td><div class="zbox7 BCF9_32"  >--</div></td>
              <td><div class="zbox7 BCF9_130" >--</div></td>
              <td><div class="zbox7 BCF9_145" >--</div></td>
              <td><div class="zbox7 BCF9_193" >--</div></td>
            </tr>
            <tr>
              <td class="row-label">시간 (min) SP</td>
              <td><div class="zbox7 yellow empty"></div></td>
              <td><div class="zbox7 yellow BCF9_19" >--</div></td>
              <td><div class="zbox7 yellow BCF9_23" >--</div></td>
              <td><div class="zbox7 yellow empty"></div></td>
              <td><div class="zbox7 yellow BCF9_115">--</div></td>
              <td><div class="zbox7 yellow BCF9_232">--</div></td>
              <td><div class="zbox7 yellow BCF9_233">--</div></td>
            </tr>
            <tr>
              <td class="row-label">온도 (°C) PV</td>
              <td><div class="zbox7 BCF9_44611">--</div></td>
              <td><div class="zbox7 BCF9_44611">--</div></td>
              <td><div class="zbox7 BCF9_44611">--</div></td>
              <td><div class="zbox7 BCF9_44611">--</div></td>
              <td><div class="zbox7 BCF9_44611">--</div></td>
              <td><div class="zbox7 BCF9_44612">--</div></td>
              <td><div class="zbox7 BCF9_44612">--</div></td>
            </tr>
            <tr>
              <td class="row-label">온도 (°C) SP</td>
              <td><div class="zbox7 yellow BCF9_11">--</div></td>
              <td><div class="zbox7 yellow BCF9_11">--</div></td>
              <td><div class="zbox7 yellow BCF9_25">--</div></td>
              <td><div class="zbox7 yellow BCF9_27">--</div></td>
              <td><div class="zbox7 yellow BCF9_27">--</div></td>
              <td><div class="zbox7 yellow BCF9_29">--</div></td>
              <td><div class="zbox7 yellow BCF9_29">--</div></td>
            </tr>
            <tr>
              <td class="row-label">CP (%) PV</td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 cyan BCF9_44613">--</div></td>
              <td><div class="zbox7 cyan BCF9_44613">--</div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
            </tr>
            <tr>
              <td class="row-label">CP (%) SP</td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 cyan BCF9_15">--</div></td>
              <td><div class="zbox7 cyan BCF9_26">--</div></td>
              <td><div class="zbox7 empty"></div></td>
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
            <div class="bcf7-tpi-val bcf9_44611">--</div>
            <span class="bcf7-tpi-unit">℃</span>
          </div>
          <div class="bcf7-tp-item">
            <span class="bcf7-tpi-lbl">유조</span>
            <div class="bcf7-tpi-val bcf9_44612">--</div>
            <span class="bcf7-tpi-unit">℃</span>
          </div>
          <div class="bcf7-tp-item">
            <span class="bcf7-tpi-lbl blue">CP</span>
            <div class="bcf7-tpi-val blue bcf9_44613">--</div>
            <span class="bcf7-tpi-unit">%</span>
          </div>
          <div class="bcf7-tp-item">
            <span class="bcf7-tpi-lbl blue">침탄SP</span>
            <div class="bcf7-tpi-val blue bcf9_40003">--</div>
            <span class="bcf7-tpi-unit">%</span>
          </div>
          <div class="bcf7-tp-item">
            <span class="bcf7-tpi-lbl blue">유조SP</span>
            <div class="bcf7-tpi-val blue bcf9_40004">--</div>
            <span class="bcf7-tpi-unit">%</span>
          </div>
          <div class="bcf7-tp-item">
            <span class="bcf7-tpi-lbl blue">CPSP</span>
            <div class="bcf7-tpi-val blue bcf9_40007">--</div>
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

  document.querySelectorAll('[class]').forEach(function(el) {
    el.className.split(/\s+/).forEach(function(cls) {
      var mLow = cls.match(/^bcf9_(\d+)$/);
      if (mLow) {
        if (parseInt(mLow[1], 10) >= 40000) {
          var apiTag = 'bcf9_s_' + mLow[1];
          if (!wordElMap[apiTag]) wordElMap[apiTag] = [];
          wordElMap[apiTag].push(el);
        } else {
          if (!bitElMap[cls]) bitElMap[cls] = [];
          bitElMap[cls].push(el);
        }
      } else if (/^BCF9_\d+$/.test(cls)) {
        var apiTag = 'bcf9_s_' + cls.slice(5);
        if (!wordElMap[apiTag]) wordElMap[apiTag] = [];
        wordElMap[apiTag].push(el);
      }
    });
  });

  var statusElMap = {};
  document.querySelectorAll('[data-tag]').forEach(function(el) {
    var tag = el.getAttribute('data-tag');
    if (/^bcf9_\d+$/.test(tag)) {
      if (!statusElMap[tag]) statusElMap[tag] = [];
      statusElMap[tag].push(el);
    }
  });

  var allTags = Object.keys(wordElMap).concat(Object.keys(bitElMap))
    .concat(Object.keys(statusElMap).filter(function(t) { return !bitElMap[t]; }));

  var CP_TAG = /_(44613|40007|15|26)$/;

  function updateStatusItem(el, val) {
    var isOn = (val === 1 || val === true);
    var isGray = el.getAttribute('data-gray') === 'true';
    el.classList.remove('state-red', 'state-green', 'state-gray');
    el.classList.add(isOn ? 'state-green' : (isGray ? 'state-gray' : 'state-red'));
  }

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
    Object.keys(statusElMap).forEach(function(tag) {
      if (data[tag] == null) return;
      statusElMap[tag].forEach(function(el) { updateStatusItem(el, data[tag]); });
    });
  }

  var busy = false;
  function fetchData() {
    if (busy || !allTags.length) return;
    busy = true;
    fetch(ctx + '/monitor/main-data', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(allTags)
    })
    .then(function(r) { return r.ok ? r.json() : Promise.reject(r.status); })
    .then(function(data) { applyData(data); })
    .catch(function(err) { console.warn('[BCF9] PLC fetch 실패:', err); })
    .finally(function() { busy = false; });
  }

  var alarmTable = new Tabulator('.bcf7-alarm-body', {
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
          return a.plcId === 'dongwoo_09';
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