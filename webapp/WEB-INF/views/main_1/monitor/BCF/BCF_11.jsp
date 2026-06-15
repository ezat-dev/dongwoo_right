
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../common_style.jsp" %>
<% String ctx = request.getContextPath(); %>
<link rel="stylesheet" href="<%= ctx %>/css/bcf11/style.css">
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
.bcf11-auto-panel {
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
.bcf11-auto-title {
  background: #3dbdb0;
  color: #fff;
  font-size: 11px;
  font-weight: 700;
  text-align: center;
  padding: 3px 0;
  letter-spacing: 1px;
  flex-shrink: 0;
}
.bcf11-auto-grid {
  flex: 1;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2px;
  padding: 3px;
  overflow-y: hidden;
}
.bcf11-auto-item {
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
.bcf11-auto-item.state-red    { background: #ff2222; color: #fff; border-color: #cc0000; }
.bcf11-auto-item.state-green  { background: #85c25f; color: #fff; border-color: #5a9a30; }
.bcf11-auto-item.state-gray   { background: #d9d9d9; color: #333; border-color: #999; }
.bcf11-auto-item.state-yellow { background: #f5c400; color: #333; border-color: #c8a000; }

/* ═══════════════════════════════════════════════
   [하단] 존구간(좌) + 온도CP/현재경보(우)
   ═══════════════════════════════════════════════ */
.bcf11-bottom-panel {
  position: absolute;
  left:   0;
  top:    430px;
  right:  0;
  bottom: auto;
  height: 340px;
  display: flex;
  flex-direction: row;
  gap: 4px;
  padding: 3px;
  overflow: hidden;
}

/* ── 좌: 존구간 테이블 ── */
.bcf11-zone-panel {
  flex: 0 0 570px;
  border: 1.5px solid #888;
  border-radius: 3px;
  overflow: hidden;
  background: #e8e8e8;
}
.bcf11-zone-table {
  width: 100%;
  height: 100%;
  border-collapse: collapse;
  font-size: 10px;
  table-layout: fixed;
}
.bcf11-zone-table th,
.bcf11-zone-table td {
  border: 1px solid #bbb;
  text-align: center;
  padding: 1px 2px;
  white-space: nowrap;
  overflow: hidden;
}
.bcf11-zone-table thead tr th {
  background: #d0d0d0;
  color: #222;
  font-weight: 700;
  font-size: 10px;
  padding: 3px 1px;
}
.bcf11-zone-table thead tr th.th-empty {
  background: #e8e8e8;
  border: none;
}
/* 특수 헤더 색상 - 사진처럼 침탄은 빨강, 강온은 노랑 */
.bcf11-zone-table thead tr th.th-red    { background: #ffb0b0; color: #880000; }
.bcf11-zone-table thead tr th.th-yellow { background: #fff08a; color: #665000; }

.bcf11-zone-table tbody tr td { background: #fff; }
.bcf11-zone-table tbody tr td.row-label {
  background: #d8d8d8;
  font-weight: 700;
  color: #222;
  text-align: left;
  padding-left: 4px;
  font-size: 9px;
  white-space: nowrap;
}

/* 존 값 박스 */
.zbox7 {
  display: block;
  width: 88%;
  margin: 1px auto;
  height: 15px;
  line-height: 15px;
  border-radius: 2px;
  background: #ffb0b0;
  border: 1px solid #e05050;
  font-size: 9px;
  color: #5a0000;
  text-align: center;
}
.zbox7.yellow { background: #fffaaa; border-color: #c8c000; color: #5a5000; }
.zbox7.cyan   { background: #aaeeff; border-color: #40aacc; color: #003a5c; }
.zbox7.empty  { background: #eeeeee; border-color: #ccc;    color: #aaa; }

/* ── 우: 온도CP(상) + 현재경보(하) ── */
.bcf11-right-col {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

/* 온도 및 CP */
.bcf11-temp-panel {
  flex-shrink: 0;
  border: 1.5px solid #2aada0;
  border-radius: 3px;
  overflow: hidden;
}
.bcf11-panel-title {
  background: #3dbdb0;
  color: #fff;
  font-size: 11px;
  font-weight: 700;
  text-align: center;
  padding: 3px 0;
  letter-spacing: 1px;
}
/* 온도CP 한 줄: 침탄실 DT ℃ | 유조 DT ℃ | CP DT ℃ | 침탄SP DT % | 유조SP DT % | CPSP DT % */
.bcf11-tp-row {
  display: flex;
  align-items: center;
  background: #d0f0ec;
  border-top: 1px solid #2aada0;
  padding: 3px 4px;
  gap: 3px;
  flex-wrap: nowrap;
}
.bcf11-tp-lbl {
  font-size: 9px;
  font-weight: 700;
  color: #cc0000;
  white-space: nowrap;
  flex-shrink: 0;
}
.bcf11-tp-lbl.blue  { color: #003399; }
.bcf11-tp-val {
  flex: 1;
  min-width: 28px;
  height: 17px;
  line-height: 17px;
  border-radius: 2px;
  background: #9ccc8d;
  border: 1px solid #6aaa50;
  font-size: 9px;
  color: #1a4000;
  text-align: center;
}
.bcf11-tp-val.blue { background: #b0d8f8; border-color: #5aadda; color: #003a5c; }
.bcf11-tp-unit {
  font-size: 9px;
  color: #1a5c52;
  font-weight: 700;
  white-space: nowrap;
  flex-shrink: 0;
}
.bcf11-tp-sep {
  width: 1px;
  height: 18px;
  background: #2aada0;
  flex-shrink: 0;
}

/* 현재 경보 */
.bcf11-alarm-panel {
  flex: 1;
  border: 1.5px solid #2aada0;
  border-radius: 3px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  min-height: 0;
}
.bcf11-alarm-body {
  flex: 1;
  background: #b8b8b8;
  border-top: 1px solid #888;
  position: relative;
}
.bcf11-alarm-body::before {
  content: '';
  position: absolute;
  left: 0; top: 0; bottom: 0;
  width: 2px;
  background: #2255cc;
}
@keyframes blink { 50% { opacity: 0; } }
.alarm-dot {
  display: inline-block; width: 8px; height: 8px;
  background: #ff2222; border-radius: 50%; animation: blink 1s infinite;
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
    <div class="bcf-11-detail">
      <img class="bcf-11-obj-1" src="<%= ctx %>/img/bcf11/bcf-11-obj-10.png" />
      <img class="bcf-11-obj-2" src="<%= ctx %>/img/bcf11/bcf-11-obj-20.png" />
      <img class="bcf-11-obj-3" src="<%= ctx %>/img/bcf11/bcf-11-obj-30.png" />
      <img class="bcf-11-obj-4" src="<%= ctx %>/img/bcf11/bcf-11-obj-40.png" />
      <img class="bcf-11-obj-5" src="<%= ctx %>/img/bcf11/bcf-11-obj-50.png" />
      <img class="bcf-11-tray-1 bcf11_40010" src="<%= ctx %>/img/bcf11/bcf-11-tray-10.png" />
      <img class="bcf-11-tray-2 bcf11_40027" src="<%= ctx %>/img/bcf11/bcf-11-tray-20.png" />
      <img class="bcf-11-tray-3 bcf11_40044" src="<%= ctx %>/img/bcf11/bcf-11-tray-30.png" />
      <img class="bcf-11-tray-4 bcf11_40053" src="<%= ctx %>/img/bcf11/bcf-11-tray-40.png" />
      <img class="bcf-11-pen-off-1" src="<%= ctx %>/img/bcf11/bcf-11-pen-off-10.png" />
      <img class="bcf-11-pen-on-1 bcf11_98" src="<%= ctx %>/img/bcf11/bcf-11-pen-on-10.png" />
      <img class="bcf-11-propel-1 bcf11_98" src="<%= ctx %>/img/bcf11/bcf-11-propel-10.png" />
      <img class="bcf-11-pen-off-2" src="<%= ctx %>/img/bcf11/bcf-11-pen-off-20.png" />
      <img class="bcf-11-pen-on-2 bcf11_100" src="<%= ctx %>/img/bcf11/bcf-11-pen-on-20.png" />
      <img class="bcf-11-propel-2 bcf11_100" src="<%= ctx %>/img/bcf11/bcf-11-propel-20.png" />
      <img class="bcf-11-pen-off-3 bcf11_116" src="<%= ctx %>/img/bcf11/bcf-11-pen-off-30.png" />
      <img class="bcf-11-pen-on-3 bcf11_117" src="<%= ctx %>/img/bcf11/bcf-11-pen-on-30.png" />
      <img class="bcf-11-propel-3 bcf11_117" src="<%= ctx %>/img/bcf11/bcf-11-propel-30.png" />
      <img class="bcf-11-obj-6" src="<%= ctx %>/img/bcf11/bcf-11-obj-60.png" />
      <img class="bcf-11-obj-7" src="<%= ctx %>/img/bcf11/bcf-11-obj-70.png" />
      <img class="bcf-11-obj-8" src="<%= ctx %>/img/bcf11/bcf-11-obj-80.png" />
      <img class="bcf-11-door-1 bcf11_3" src="<%= ctx %>/img/bcf11/bcf-11-door-10.png" />
      <img class="bcf-11-door-2 bcf11_5" src="<%= ctx %>/img/bcf11/bcf-11-door-20.png" />
      <img class="bcf-11-door-3" src="<%= ctx %>/img/bcf11/bcf-11-door-30.png" />
      <img class="bcf-11-door-4" src="<%= ctx %>/img/bcf11/bcf-11-door-40.png" />
      <img class="bcf-11-obj-9" src="<%= ctx %>/img/bcf11/bcf-11-obj-90.png" />
      <img class="bcf-11-cycle-1 bcf11_56 bcf11_57" src="<%= ctx %>/img/bcf11/bcf-11-cycle-10.png" />
      <img class="bcf-11-cycle-2 bcf11_79 bcf11_80" src="<%= ctx %>/img/bcf11/bcf-11-cycle-20.png" />
      <img class="bcf-11-cycle-3 bcf11_83 bcf11_84" src="<%= ctx %>/img/bcf11/bcf-11-cycle-30.png" />
      <img class="bcf-11-cycle-4 bcf11_60 bcf11_61" src="<%= ctx %>/img/bcf11/bcf-11-cycle-40.png" />
      <img class="bcf-11-cycle-5 bcf11_62 bcf11_63" src="<%= ctx %>/img/bcf11/bcf-11-cycle-50.png" />
      <img class="bcf-11-jog-gray-1" src="<%= ctx %>/img/bcf11/bcf-11-jog-gray-10.png" />
      <img class="bcf-11-jog-red-1" src="<%= ctx %>/img/bcf11/bcf-11-jog-red-10.png" />
      <img class="bcf-11-jog-green-1" src="<%= ctx %>/img/bcf11/bcf-11-jog-green-10.png" />
      <img class="bcf-11-jog-gray-12" src="<%= ctx %>/img/bcf11/bcf-11-jog-gray-11.png" />
      <img class="bcf-11-jog-red-12" src="<%= ctx %>/img/bcf11/bcf-11-jog-red-11.png" />
      <img class="bcf-11-jog-green-12 bcf11_79 bcf11_80" src="<%= ctx %>/img/bcf11/bcf-11-jog-green-11.png" />
      <img class="bcf-11-jog-gray-13" src="<%= ctx %>/img/bcf11/bcf-11-jog-gray-12.png" />
      <img class="bcf-11-jog-red-13" src="<%= ctx %>/img/bcf11/bcf-11-jog-red-12.png" />
      <img class="bcf-11-jog-green-13 bcf11_83 bcf11_84" src="<%= ctx %>/img/bcf11/bcf-11-jog-green-12.png" />
      <img class="bcf-11-jog-gray-14" src="<%= ctx %>/img/bcf11/bcf-11-jog-gray-13.png" />
      <img class="bcf-11-jog-red-14" src="<%= ctx %>/img/bcf11/bcf-11-jog-red-13.png" />
      <img class="bcf-11-jog-green-14 bcf11_60" src="<%= ctx %>/img/bcf11/bcf-11-jog-green-13.png" />
      <img class="bcf-11-jog-gray-15" src="<%= ctx %>/img/bcf11/bcf-11-jog-gray-14.png" />
      <img class="bcf-11-jog-red-15" src="<%= ctx %>/img/bcf11/bcf-11-jog-red-14.png" />
      <img class="bcf-11-jog-green-15" src="<%= ctx %>/img/bcf11/bcf-11-jog-green-14.png" />
      <img class="bcf-11-obj-10" src="<%= ctx %>/img/bcf11/bcf-11-obj-100.png" />
      <img class="bcf-11-obj-11 bcf11_197" src="<%= ctx %>/img/bcf11/bcf-11-obj-110.png" />
      <img class="bcf-11-firepipe-off-1 bcf11_198" src="<%= ctx %>/img/bcf11/bcf-11-firepipe-off-10.png" />
      <img class="bcf-11-obj-12" src="<%= ctx %>/img/bcf11/bcf-11-obj-120.png" />
      <img class="bcf-11-obj-13" src="<%= ctx %>/img/bcf11/bcf-11-obj-130.png" />
      <img class="bcf-11-firepipe-off-2" src="<%= ctx %>/img/bcf11/bcf-11-firepipe-off-20.png" />
      <img class="bcf-11-sensor-off-1" src="<%= ctx %>/img/bcf11/bcf-11-sensor-off-10.png" />
      <img class="bcf-11-sensor-on-1 bcf11_113" src="<%= ctx %>/img/bcf11/bcf-11-sensor-on-10.png" />
      <img class="bcf-11-sensor-off-2" src="<%= ctx %>/img/bcf11/bcf-11-sensor-off-20.png" />
      <img class="bcf-11-sensor-on-2 bcf11_127" src="<%= ctx %>/img/bcf11/bcf-11-sensor-on-20.png" />
      <img class="bcf-11-sensor-off-3" src="<%= ctx %>/img/bcf11/bcf-11-sensor-off-30.png" />
      <img class="bcf-11-sensor-on-3 bcf11_15" src="<%= ctx %>/img/bcf11/bcf-11-sensor-on-30.png" />
      <img class="bcf-11-enrich-gray-1" src="<%= ctx %>/img/bcf11/bcf-11-enrich-gray-10.png" />
      <img class="bcf-11-enrich-red-1" src="<%= ctx %>/img/bcf11/bcf-11-enrich-red-10.png" />
      <img class="bcf-11-enrich-green-1 bcf11_12" src="<%= ctx %>/img/bcf11/bcf-11-enrich-green-10.png" />
      <div class="bcf-11-enrich-off-box-1"></div>
      <div class="bcf-11-enrich-on-box-1 bcf11_12"></div>
      <img class="bcf-11-amm-gray-1" src="<%= ctx %>/img/bcf11/bcf-11-amm-gray-10.png" />
      <img class="bcf-11-amm-red-1" src="<%= ctx %>/img/bcf11/bcf-11-amm-red-10.png" />
      <img class="bcf-11-amm-green-1 bcf11_107" src="<%= ctx %>/img/bcf11/bcf-11-amm-green-10.png" />
      <div class="bcf-11-amm-off-box-1"></div>
      <div class="bcf-11-amm-on-box-1 bcf11_107"></div>
      <img class="bcf-11-enrich-gray-2" src="<%= ctx %>/img/bcf11/bcf-11-enrich-gray-20.png" />
      <img class="bcf-11-enrich-red-2" src="<%= ctx %>/img/bcf11/bcf-11-enrich-red-20.png" />
      <img class="bcf-11-enrich-green-2 bcf11_69" src="<%= ctx %>/img/bcf11/bcf-11-enrich-green-20.png" />
      <div class="bcf-11-enrich-off-box-2"></div>
      <div class="bcf-11-enrich-on-box-2 bcf11_69"></div>
      <img class="bcf-11-amm-gray-2" src="<%= ctx %>/img/bcf11/bcf-11-amm-gray-20.png" />
      <img class="bcf-11-amm-red-2" src="<%= ctx %>/img/bcf11/bcf-11-amm-red-20.png" />
      <img class="bcf-11-amm-green-2 bcf11_121" src="<%= ctx %>/img/bcf11/bcf-11-amm-green-20.png" />
      <div class="bcf-11-amm-off-box-2"></div>
      <div class="bcf-11-amm-on-box-2 bcf11_121"></div>
      <img class="bcf-11-ngas-gray-1" src="<%= ctx %>/img/bcf11/bcf-11-ngas-gray-10.png" />
      <img class="bcf-11-ngas-red-1" src="<%= ctx %>/img/bcf11/bcf-11-ngas-red-10.png" />
      <img class="bcf-11-ngas-green-1" src="<%= ctx %>/img/bcf11/bcf-11-ngas-green-10.png" />
      <div class="bcf-11-ngas-off-box-1 bcf11_199"></div>
      <div class="bcf-11-ngas-on-box-1"></div>
      <img class="bcf-11-motor-gray-1" src="<%= ctx %>/img/bcf11/bcf-11-motor-gray-10.png" />
      <img class="bcf-11-motor-green-1 bcf11_126 bcf11_68" src="<%= ctx %>/img/bcf11/bcf-11-motor-green-10.png" />
      <img class="bcf-11-rotate-1 bcf11_8 bcf11_195" src="<%= ctx %>/img/bcf11/bcf-11-rotate-10.png" />
      <img class="bcf-11-rotate-2 bcf11_126 bcf11_68" src="<%= ctx %>/img/bcf11/bcf-11-rotate-20.png" />
      <div class="bcf-11-jog-manual-box-1 bcf11_79 bcf11_80"></div>
      <div class="bcf-11-jog-stop-box-1"></div>
      <div class="bcf-11-jog-on-box-1 bcf11_162"></div>
      <div class="bcf-11-jog-manual-box-2 bcf11_83 bcf11_84"></div>
      <div class="bcf-11-jog-stop-box-2"></div>
      <div class="bcf-11-jog-on-box-2 bcf11_163"></div>
      <div class="bcf-11-pump-off-box-1"></div>
      <div class="bcf-11-pump-on-box-1 bcf11_125"></div>
      <div class="bcf-11-cool-off-box-1"></div>
      <div class="bcf-11-cool-on-box-1 bcf11_120"></div>
      <div class="bcf-11-sw-off-box-1"></div>
      <div class="bcf-11-sw-on-box-1 bcf11_56"></div>
      <div class="bcf-11-flame-off-box-1"></div>
      <div class="bcf-11-flame-on-box-1 bcf11_141"></div>
      <div class="bcf-11-fire-off-box-1"></div>
      <div class="bcf-11-fire-on-box-1 bcf11_124"></div>
      <div class="bcf-11-pilot-off-box-1"></div>
      <div class="bcf-11-pilot-on-box-1 bcf11_124"></div>
      <div class="bcf-11-burn-box-1"></div>
      <div class="bcf-11-burn-box-2"></div>
      <div class="bcf-11-burn-box-3"></div>
    </div>

    <!-- ═══ [우측] 자동운전 조건 - 2열 10행 ═══ -->
    <div class="bcf11-auto-panel">
          <div class="bcf11-auto-title">자동운전 조건</div>
        <div class="bcf11-auto-grid">

        <div class="bcf11-auto-item state-gray" data-tag="bcf11_22" data-text-0="제어전원"                   data-text-1="제어전원"                  >제어전원</div>
        <div class="bcf11-auto-item state-gray" data-tag="bcf11_29" data-text-0="입구 조작반 비상정지"        data-text-1="입구 조작반 비상정지"       >입구 조작반 비상정지</div>
        <div class="bcf11-auto-item state-green">1실 온도 750도 이상</div>
        <div class="bcf11-auto-item state-gray" data-tag="bcf11_38" data-text-0="출구 조작반 비상정지"        data-text-1="출구 조작반 비상정지"       >출구 조작반 비상정지</div>
        <div class="bcf11-auto-item state-green">2실 온도 750도 이상</div>
        <div class="bcf11-auto-item state-gray" data-tag="bcf11_34" data-text-0="입구조작반 수동"             data-text-1="입구조작반 수동"            >입구조작반 수동</div>
        <div class="bcf11-auto-item state-green">온도저하 가스차단 경보</div>
        <div class="bcf11-auto-item state-gray" data-tag="bcf11_42" data-text-0="출구 조작반 수동"            data-text-1="출구 조작반 수동"           >출구 조작반 수동</div>
        <div class="bcf11-auto-item state-gray" data-tag="bcf11_37" data-text-0="입구 보조 리프터 상승"       data-text-1="입구 보조 리프터 상승"      >입구 보조 리프터 상승</div>
        <div class="bcf11-auto-item state-gray" data-tag="bcf11_31" data-text-0="1실 입구문 화염감지 S/W"    data-text-1="1실 입구문 화염감지 S/W"   >1실 입구문 화염감지 S/W</div>
        <div class="bcf11-auto-item state-gray" data-tag="bcf11_2"  data-text-0="1실 입구문 닫힘"            data-text-1="1실 입구문 닫힘"           >1실 입구문 닫힘</div>
        <div class="bcf11-auto-item state-gray" data-tag="bcf11_26" data-text-0="냉각실 배기변 화염감지"      data-text-1="냉각실 배기변 화염감지"     >냉각실 배기변 화염감지</div>
        <div class="bcf11-auto-item state-gray" data-tag="bcf11_4"  data-text-0="2실 입구문 닫힘"            data-text-1="2실 입구문 닫힘"           >2실 입구문 닫힘</div>
        <div class="bcf11-auto-item state-gray" data-tag="bcf11_40" data-text-0="냉각실 배기변 화염감지 S/W"  data-text-1="냉각실 배기변 화염감지 S/W" >냉각실 배기변 화염감지 S/W</div>
        <div class="bcf11-auto-item state-gray" data-tag="bcf11_6"  data-text-0="냉각실 입구문 닫힘"         data-text-1="냉각실 입구문 닫힘"        >냉각실 입구문 닫힘</div>
        <div class="bcf11-auto-item state-green">1실 자동 스텝 준비</div>
        <div class="bcf11-auto-item state-gray" data-tag="bcf11_8"  data-text-0="냉각실 출구문 닫힘"         data-text-1="냉각실 출구문 닫힘"        >냉각실 출구문 닫힘</div>
        <div class="bcf11-auto-item state-green">2실 자동 스텝 준비</div>
        <div class="bcf11-auto-item state-green">1실 자동 조깅</div>
        <div class="bcf11-auto-item state-green">냉각실 자동 스텝 준비</div>
        <div class="bcf11-auto-item state-green">2실 자동 조깅</div>
        <div class="bcf11-auto-item state-gray" data-tag="bcf11_33" data-text-0="GOT 자동운전 선택 S/W"      data-text-1="GOT 자동운전 선택 S/W"     >GOT 자동운전 선택 S/W</div>

    </div>
    </div>

    <!-- ═══ [하단] 존구간(좌) + 온도CP/현재경보(우) ═══ -->
    <div class="bcf11-bottom-panel">

      <!-- 좌: 존구간 테이블 - 침탄/승온/침탄/확산/강온/균열/강온/드레인 -->
      <div class="bcf11-zone-panel">
        <table class="bcf11-zone-table">
          <thead>
            <tr>
              <th class="th-empty" style="width:80px;"></th>
              <th class="th-red">침탄</th>
              <th>승온</th>
              <th class="th-red">침탄</th>
              <th>확산</th>
              <th>강온</th>
              <th>균열</th>
              <th class="th-yellow">강온</th>
              <th>드레인</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td class="row-label">시간 (min) PV</td>
              <td><div class="zbox7 bcf11_73">--</div></td>
              <td><div class="zbox7 bcf11_74">--</div></td>
              <td><div class="zbox7 bcf11_75">--</div></td>
              <td><div class="zbox7 bcf11_76">--</div></td>
              <td><div class="zbox7 bcf11_77">--</div></td>
              <td><div class="zbox7 bcf11_78">--</div></td>
              <td><div class="zbox7 bcf11_79">--</div></td>
              <td><div class="zbox7 bcf11_80">--</div></td>
            </tr>
            <tr>
              <td class="row-label">시간 (min) SP</td>
              <td><div class="zbox7 yellow bcf11_81">--</div></td>
              <td><div class="zbox7 yellow bcf11_82">--</div></td>
              <td><div class="zbox7 yellow bcf11_137">--</div></td>
              <td><div class="zbox7 yellow bcf11_2">--</div></td>
              <td><div class="zbox7 yellow bcf11_4">--</div></td>
              <td><div class="zbox7 yellow bcf11_3">--</div></td>
              <td><div class="zbox7 yellow bcf11_19">--</div></td>
              <td><div class="zbox7 yellow bcf11_4">--</div></td>
            </tr>
            <tr>
              <td class="row-label">온도 (°C) PV</td>
              <td><div class="zbox7 bcf11_40077">--</div></td>
              <td><div class="zbox7 bcf11_40077">--</div></td>
              <td><div class="zbox7 bcf11_40077">--</div></td>
              <td><div class="zbox7 bcf11_40077">--</div></td>
              <td><div class="zbox7 bcf11_40078">--</div></td>
              <td><div class="zbox7 bcf11_40078">--</div></td>
              <td><div class="zbox7 bcf11_40078">--</div></td>
              <td><div class="zbox7 bcf11_40079">--</div></td>
            </tr>
            <tr>
              <td class="row-label">온도 (°C) SP</td>
              <td><div class="zbox7 yellow bcf11_6">--</div></td>
              <td><div class="zbox7 yellow bcf11_8">--</div></td>
              <td><div class="zbox7 yellow bcf11_10">--</div></td>
              <td><div class="zbox7 yellow bcf11_101">--</div></td>
              <td><div class="zbox7 yellow bcf11_141">--</div></td>
              <td><div class="zbox7 yellow bcf11_106">--</div></td>
              <td><div class="zbox7 yellow bcf11_145">--</div></td>
              <td><div class="zbox7 yellow bcf11_103">--</div></td>
            </tr>
            <tr>
              <td class="row-label">CP (%) PV</td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 cyan bcf11_40080">--</div></td>
              <td><div class="zbox7 cyan bcf11_40080">--</div></td>
              <td><div class="zbox7 cyan bcf11_40081">--</div></td>
              <td><div class="zbox7 cyan bcf11_40081">--</div></td>
              <td><div class="zbox7 cyan bcf11_40081">--</div></td>
              <td><div class="zbox7 empty"></div></td>
            </tr>
            <tr>
              <td class="row-label">CP (%) SP</td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 cyan bcf11_142">--</div></td>
              <td><div class="zbox7 cyan bcf11_143">--</div></td>
              <td><div class="zbox7 cyan bcf11_1">--</div></td>
              <td><div class="zbox7 cyan bcf11_6">--</div></td>
              <td><div class="zbox7 cyan bcf11_7">--</div></td>
              <td><div class="zbox7 empty"></div></td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- 우: 온도CP(상) + 현재경보(하) -->
      <div class="bcf11-right-col">

        <!-- 온도 및 CP: 침탄실 DT ℃ | 유조 DT ℃ | CP DT ℃ | 침탄SP DT % | 유조SP DT % | CPSP DT % -->
        <div class="bcf11-temp-panel">
          <div class="bcf11-panel-title">온도 및 CP</div>
          <div class="bcf11-tp-row">
            <span class="bcf11-tp-lbl">침탄1</span>
            <div class="bcf11-tp-val bcf11_40077">--</div>
            <span class="bcf11-tp-unit">℃</span>
            <div class="bcf11-tp-sep"></div>
            <span class="bcf11-tp-lbl">침탄2</span>
            <div class="bcf11-tp-val bcf11_40078">--</div>
            <span class="bcf11-tp-unit">℃</span>
            <div class="bcf11-tp-sep"></div>
            <span class="bcf11-tp-lbl">냉각</span>
            <div class="bcf11-tp-val bcf11_40079">--</div>
            <span class="bcf11-tp-unit">℃</span>
            <div class="bcf11-tp-sep"></div>
            <span class="bcf11-tp-lbl blue">CP1</span>
            <div class="bcf11-tp-val blue bcf11_40080">--</div>
            <span class="bcf11-tp-unit">%</span>
            <div class="bcf11-tp-sep"></div>
            <span class="bcf11-tp-lbl blue">CP2</span>
            <div class="bcf11-tp-val blue bcf11_40081">--</div>
            <span class="bcf11-tp-unit">%</span>
          </div>
        </div>

        <!-- 현재 경보 -->
        <div class="bcf11-alarm-panel">
          <div class="bcf11-panel-title">현재 경보</div>
          <div class="bcf11-alarm-body"></div>
        </div>

      </div><!-- /bcf11-right-col -->

    </div><!-- /bcf11-bottom-panel -->

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
    if (el.classList.contains('bcf11-auto-item')) return; /* statusElMap 에서 처리 */
    el.className.split(/\s+/).forEach(function(cls) {
      var mLow = cls.match(/^bcf11_(\d+)$/);
      if (!mLow) return;
      var addr = parseInt(mLow[1], 10);
      /* zbox7 / bcf11-tp-val 은 수치 표시용 → 주소 크기 무관하게 word read */
      var isDisplay = el.classList.contains('zbox7') || el.classList.contains('bcf11-tp-val');
      if (addr >= 40000 || isDisplay) {
        var apiTag = 'bcf11_s_' + mLow[1];
        if (!wordElMap[apiTag]) wordElMap[apiTag] = [];
        wordElMap[apiTag].push(el);
      } else {
        if (!bitElMap[cls]) bitElMap[cls] = [];
        bitElMap[cls].push(el);
      }
    });
  });

  var statusElMap = {};
  document.querySelectorAll('.bcf11-auto-item[data-tag]').forEach(function(el) {
    var tag = el.getAttribute('data-tag');
    if (!statusElMap[tag]) statusElMap[tag] = [];
    statusElMap[tag].push(el);
  });

  var allTags = Object.keys(wordElMap).concat(Object.keys(bitElMap))
    .concat(Object.keys(statusElMap).filter(function(t) { return !bitElMap[t]; }));

  /* CP 스케일링: ×0.001 */
  var CP_TAG = /^bcf11_s_(40080|40081)$/;

  function updateStatusItem(el, val) {
    var isOn = (val === 1 || val === true);
    el.classList.remove('state-red', 'state-green', 'state-gray');
    el.classList.add(isOn ? 'state-green' : 'state-gray');
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
    if (busy) return;
    busy = true;
    fetch(ctx + '/monitor/snapshot')
    .then(function(r) { return r.ok ? r.json() : Promise.reject(r.status); })
    .then(function(data) { applyData(data); })
    .catch(function(err) { console.warn('[BCF11] PLC fetch 실패:', err); })
    .finally(function() { busy = false; });
  }

  var alarmTable = new Tabulator('.bcf11-alarm-body', {
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
          return a.plcId === 'dongwoo_11';
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
