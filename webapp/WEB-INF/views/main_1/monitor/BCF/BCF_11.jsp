
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../common_style.jsp" %>
<% String ctx = request.getContextPath(); %>
<link rel="stylesheet" href="<%= ctx %>/css/bcf11/style.css">
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
.bcf7-zone-panel {
  flex: 0 0 570px;
  border: 1.5px solid #888;
  border-radius: 3px;
  overflow: hidden;
  background: #e8e8e8;
}
.bcf7-zone-table {
  width: 100%;
  height: 100%;
  border-collapse: collapse;
  font-size: 10px;
  table-layout: fixed;
}
.bcf7-zone-table th,
.bcf7-zone-table td {
  border: 1px solid #bbb;
  text-align: center;
  padding: 1px 2px;
  white-space: nowrap;
  overflow: hidden;
}
.bcf7-zone-table thead tr th {
  background: #d0d0d0;
  color: #222;
  font-weight: 700;
  font-size: 10px;
  padding: 3px 1px;
}
.bcf7-zone-table thead tr th.th-empty {
  background: #e8e8e8;
  border: none;
}
/* 특수 헤더 색상 - 사진처럼 침탄은 빨강, 강온은 노랑 */
.bcf7-zone-table thead tr th.th-red    { background: #ffb0b0; color: #880000; }
.bcf7-zone-table thead tr th.th-yellow { background: #fff08a; color: #665000; }

.bcf7-zone-table tbody tr td { background: #fff; }
.bcf7-zone-table tbody tr td.row-label {
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
.bcf7-right-col {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

/* 온도 및 CP */
.bcf7-temp-panel {
  flex-shrink: 0;
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
/* 온도CP 한 줄: 침탄실 DT ℃ | 유조 DT ℃ | CP DT ℃ | 침탄SP DT % | 유조SP DT % | CPSP DT % */
.bcf7-tp-row {
  display: flex;
  align-items: center;
  background: #d0f0ec;
  border-top: 1px solid #2aada0;
  padding: 3px 4px;
  gap: 3px;
  flex-wrap: nowrap;
}
.bcf7-tp-lbl {
  font-size: 9px;
  font-weight: 700;
  color: #cc0000;
  white-space: nowrap;
  flex-shrink: 0;
}
.bcf7-tp-lbl.blue  { color: #003399; }
.bcf7-tp-val {
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
.bcf7-tp-val.blue { background: #b0d8f8; border-color: #5aadda; color: #003a5c; }
.bcf7-tp-unit {
  font-size: 9px;
  color: #1a5c52;
  font-weight: 700;
  white-space: nowrap;
  flex-shrink: 0;
}
.bcf7-tp-sep {
  width: 1px;
  height: 18px;
  background: #2aada0;
  flex-shrink: 0;
}

/* 현재 경보 */
.bcf7-alarm-panel {
  flex: 1;
  border: 1.5px solid #2aada0;
  border-radius: 3px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  min-height: 0;
}
.bcf7-alarm-body {
  flex: 1;
  background: #b8b8b8;
  border-top: 1px solid #888;
  position: relative;
}
.bcf7-alarm-body::before {
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

  <div class="group-2">

    <!-- 기존 설비 작화 (변경 없음) -->
    <div class="bcf-11-detail">
      <img class="bcf-11-obj-1" src="<%= ctx %>/img/bcf11/bcf-11-obj-10.png" />
      <img class="bcf-11-obj-2" src="<%= ctx %>/img/bcf11/bcf-11-obj-20.png" />
      <img class="bcf-11-obj-3" src="<%= ctx %>/img/bcf11/bcf-11-obj-30.png" />
      <img class="bcf-11-obj-4" src="<%= ctx %>/img/bcf11/bcf-11-obj-40.png" />
      <img class="bcf-11-obj-5" src="<%= ctx %>/img/bcf11/bcf-11-obj-50.png" />
      <img class="bcf-11-tray-1" src="<%= ctx %>/img/bcf11/bcf-11-tray-10.png" />
      <img class="bcf-11-tray-2" src="<%= ctx %>/img/bcf11/bcf-11-tray-20.png" />
      <img class="bcf-11-tray-3" src="<%= ctx %>/img/bcf11/bcf-11-tray-30.png" />
      <img class="bcf-11-tray-4" src="<%= ctx %>/img/bcf11/bcf-11-tray-40.png" />
      <img class="bcf-11-pen-off-1" src="<%= ctx %>/img/bcf11/bcf-11-pen-off-10.png" />
      <img class="bcf-11-pen-on-1" src="<%= ctx %>/img/bcf11/bcf-11-pen-on-10.png" />
      <img class="bcf-11-propel-1" src="<%= ctx %>/img/bcf11/bcf-11-propel-10.png" />
      <img class="bcf-11-pen-off-2" src="<%= ctx %>/img/bcf11/bcf-11-pen-off-20.png" />
      <img class="bcf-11-pen-on-2" src="<%= ctx %>/img/bcf11/bcf-11-pen-on-20.png" />
      <img class="bcf-11-propel-2" src="<%= ctx %>/img/bcf11/bcf-11-propel-20.png" />
      <img class="bcf-11-pen-off-3" src="<%= ctx %>/img/bcf11/bcf-11-pen-off-30.png" />
      <img class="bcf-11-pen-on-3" src="<%= ctx %>/img/bcf11/bcf-11-pen-on-30.png" />
      <img class="bcf-11-propel-3" src="<%= ctx %>/img/bcf11/bcf-11-propel-30.png" />
      <img class="bcf-11-obj-6" src="<%= ctx %>/img/bcf11/bcf-11-obj-60.png" />
      <img class="bcf-11-obj-7" src="<%= ctx %>/img/bcf11/bcf-11-obj-70.png" />
      <img class="bcf-11-obj-8" src="<%= ctx %>/img/bcf11/bcf-11-obj-80.png" />
      <img class="bcf-11-door-1" src="<%= ctx %>/img/bcf11/bcf-11-door-10.png" />
      <img class="bcf-11-door-2" src="<%= ctx %>/img/bcf11/bcf-11-door-20.png" />
      <img class="bcf-11-door-3" src="<%= ctx %>/img/bcf11/bcf-11-door-30.png" />
      <img class="bcf-11-door-4" src="<%= ctx %>/img/bcf11/bcf-11-door-40.png" />
      <img class="bcf-11-obj-9" src="<%= ctx %>/img/bcf11/bcf-11-obj-90.png" />
      <img class="bcf-11-cycle-1" src="<%= ctx %>/img/bcf11/bcf-11-cycle-10.png" />
      <img class="bcf-11-cycle-2" src="<%= ctx %>/img/bcf11/bcf-11-cycle-20.png" />
      <img class="bcf-11-cycle-3" src="<%= ctx %>/img/bcf11/bcf-11-cycle-30.png" />
      <img class="bcf-11-cycle-4" src="<%= ctx %>/img/bcf11/bcf-11-cycle-40.png" />
      <img class="bcf-11-cycle-5" src="<%= ctx %>/img/bcf11/bcf-11-cycle-50.png" />
      <img class="bcf-11-jog-gray-1" src="<%= ctx %>/img/bcf11/bcf-11-jog-gray-10.png" />
      <img class="bcf-11-jog-red-1" src="<%= ctx %>/img/bcf11/bcf-11-jog-red-10.png" />
      <img class="bcf-11-jog-green-1" src="<%= ctx %>/img/bcf11/bcf-11-jog-green-10.png" />
      <img class="bcf-11-jog-gray-12" src="<%= ctx %>/img/bcf11/bcf-11-jog-gray-11.png" />
      <img class="bcf-11-jog-red-12" src="<%= ctx %>/img/bcf11/bcf-11-jog-red-11.png" />
      <img class="bcf-11-jog-green-12" src="<%= ctx %>/img/bcf11/bcf-11-jog-green-11.png" />
      <img class="bcf-11-jog-gray-13" src="<%= ctx %>/img/bcf11/bcf-11-jog-gray-12.png" />
      <img class="bcf-11-jog-red-13" src="<%= ctx %>/img/bcf11/bcf-11-jog-red-12.png" />
      <img class="bcf-11-jog-green-13" src="<%= ctx %>/img/bcf11/bcf-11-jog-green-12.png" />
      <img class="bcf-11-jog-gray-14" src="<%= ctx %>/img/bcf11/bcf-11-jog-gray-13.png" />
      <img class="bcf-11-jog-red-14" src="<%= ctx %>/img/bcf11/bcf-11-jog-red-13.png" />
      <img class="bcf-11-jog-green-14" src="<%= ctx %>/img/bcf11/bcf-11-jog-green-13.png" />
      <img class="bcf-11-jog-gray-15" src="<%= ctx %>/img/bcf11/bcf-11-jog-gray-14.png" />
      <img class="bcf-11-jog-red-15" src="<%= ctx %>/img/bcf11/bcf-11-jog-red-14.png" />
      <img class="bcf-11-jog-green-15" src="<%= ctx %>/img/bcf11/bcf-11-jog-green-14.png" />
      <img class="bcf-11-obj-10" src="<%= ctx %>/img/bcf11/bcf-11-obj-100.png" />
      <img class="bcf-11-obj-11" src="<%= ctx %>/img/bcf11/bcf-11-obj-110.png" />
      <img class="bcf-11-firepipe-off-1" src="<%= ctx %>/img/bcf11/bcf-11-firepipe-off-10.png" />
      <img class="bcf-11-obj-12" src="<%= ctx %>/img/bcf11/bcf-11-obj-120.png" />
      <img class="bcf-11-obj-13" src="<%= ctx %>/img/bcf11/bcf-11-obj-130.png" />
      <img class="bcf-11-firepipe-off-2" src="<%= ctx %>/img/bcf11/bcf-11-firepipe-off-20.png" />
      <img class="bcf-11-sensor-off-1" src="<%= ctx %>/img/bcf11/bcf-11-sensor-off-10.png" />
      <img class="bcf-11-sensor-on-1" src="<%= ctx %>/img/bcf11/bcf-11-sensor-on-10.png" />
      <img class="bcf-11-sensor-off-2" src="<%= ctx %>/img/bcf11/bcf-11-sensor-off-20.png" />
      <img class="bcf-11-sensor-on-2" src="<%= ctx %>/img/bcf11/bcf-11-sensor-on-20.png" />
      <img class="bcf-11-sensor-off-3" src="<%= ctx %>/img/bcf11/bcf-11-sensor-off-30.png" />
      <img class="bcf-11-sensor-on-3" src="<%= ctx %>/img/bcf11/bcf-11-sensor-on-30.png" />
      <img class="bcf-11-enrich-gray-1" src="<%= ctx %>/img/bcf11/bcf-11-enrich-gray-10.png" />
      <img class="bcf-11-enrich-red-1" src="<%= ctx %>/img/bcf11/bcf-11-enrich-red-10.png" />
      <img class="bcf-11-enrich-green-1" src="<%= ctx %>/img/bcf11/bcf-11-enrich-green-10.png" />
      <div class="bcf-11-enrich-off-box-1"></div>
      <div class="bcf-11-enrich-on-box-1"></div>
      <img class="bcf-11-amm-gray-1" src="<%= ctx %>/img/bcf11/bcf-11-amm-gray-10.png" />
      <img class="bcf-11-amm-red-1" src="<%= ctx %>/img/bcf11/bcf-11-amm-red-10.png" />
      <img class="bcf-11-amm-green-1" src="<%= ctx %>/img/bcf11/bcf-11-amm-green-10.png" />
      <div class="bcf-11-amm-off-box-1"></div>
      <div class="bcf-11-amm-on-box-1"></div>
      <img class="bcf-11-enrich-gray-2" src="<%= ctx %>/img/bcf11/bcf-11-enrich-gray-20.png" />
      <img class="bcf-11-enrich-red-2" src="<%= ctx %>/img/bcf11/bcf-11-enrich-red-20.png" />
      <img class="bcf-11-enrich-green-2" src="<%= ctx %>/img/bcf11/bcf-11-enrich-green-20.png" />
      <div class="bcf-11-enrich-off-box-2"></div>
      <div class="bcf-11-enrich-on-box-2"></div>
      <img class="bcf-11-amm-gray-2" src="<%= ctx %>/img/bcf11/bcf-11-amm-gray-20.png" />
      <img class="bcf-11-amm-red-2" src="<%= ctx %>/img/bcf11/bcf-11-amm-red-20.png" />
      <img class="bcf-11-amm-green-2" src="<%= ctx %>/img/bcf11/bcf-11-amm-green-20.png" />
      <div class="bcf-11-amm-off-box-2"></div>
      <div class="bcf-11-amm-on-box-2"></div>
      <img class="bcf-11-ngas-gray-1" src="<%= ctx %>/img/bcf11/bcf-11-ngas-gray-10.png" />
      <img class="bcf-11-ngas-red-1" src="<%= ctx %>/img/bcf11/bcf-11-ngas-red-10.png" />
      <img class="bcf-11-ngas-green-1" src="<%= ctx %>/img/bcf11/bcf-11-ngas-green-10.png" />
      <div class="bcf-11-ngas-off-box-1"></div>
      <div class="bcf-11-ngas-on-box-1"></div>
      <img class="bcf-11-motor-gray-1" src="<%= ctx %>/img/bcf11/bcf-11-motor-gray-10.png" />
      <img class="bcf-11-motor-green-1" src="<%= ctx %>/img/bcf11/bcf-11-motor-green-10.png" />
      <img class="bcf-11-rotate-1" src="<%= ctx %>/img/bcf11/bcf-11-rotate-10.png" />
      <img class="bcf-11-rotate-2" src="<%= ctx %>/img/bcf11/bcf-11-rotate-20.png" />
      <div class="bcf-11-jog-manual-box-1"></div>
      <div class="bcf-11-jog-stop-box-1"></div>
      <div class="bcf-11-jog-on-box-1"></div>
      <div class="bcf-11-jog-manual-box-2"></div>
      <div class="bcf-11-jog-stop-box-2"></div>
      <div class="bcf-11-jog-on-box-2"></div>
      <div class="bcf-11-pump-off-box-1"></div>
      <div class="bcf-11-pump-on-box-1"></div>
      <div class="bcf-11-cool-off-box-1"></div>
      <div class="bcf-11-cool-on-box-1"></div>
      <div class="bcf-11-sw-off-box-1"></div>
      <div class="bcf-11-sw-on-box-1"></div>
      <div class="bcf-11-flame-off-box-1"></div>
      <div class="bcf-11-flame-on-box-1"></div>
      <div class="bcf-11-fire-off-box-1"></div>
      <div class="bcf-11-fire-on-box-1"></div>
      <div class="bcf-11-pilot-off-box-1"></div>
      <div class="bcf-11-pilot-on-box-1"></div>
      <div class="bcf-11-burn-box-1"></div>
      <div class="bcf-11-burn-box-2"></div>
      <div class="bcf-11-burn-box-3"></div>
    </div>

    <!-- ═══ [우측] 자동운전 조건 - 2열 10행 ═══ -->
    <div class="bcf7-auto-panel">
      <div class="bcf7-auto-title">자동운전 조건</div>
      <div class="bcf7-auto-grid">
        <div class="bcf7-auto-item state-green">추출포크 후진</div>
        <div class="bcf7-auto-item state-green">입구 커튼 S/W ON</div>
        <div class="bcf7-auto-item state-green">포크베이스 하강</div>
        <div class="bcf7-auto-item state-green">출구 커튼 S/W ON</div>
        <div class="bcf7-auto-item state-green">보조롤러 하강</div>
        <div class="bcf7-auto-item state-green">출구 FLAME ON</div>
        <div class="bcf7-auto-item state-green">입구문 닫힘</div>
        <div class="bcf7-auto-item state-green">배기 FLAME ON</div>
        <div class="bcf7-auto-item state-green">중간문 닫힘</div>
        <div class="bcf7-auto-item state-green">비상정지(판넬)</div>
        <div class="bcf7-auto-item state-green">E/V 상승</div>
        <div class="bcf7-auto-item state-green">비상정지(입구)</div>
        <div class="bcf7-auto-item state-green">출구문 닫힘</div>
        <div class="bcf7-auto-item state-green">비상정지(출구)</div>
        <div class="bcf7-auto-item state-green">자동스텝1 준비완료</div>
        <div class="bcf7-auto-item state-green">자동SS(입구)</div>
        <div class="bcf7-auto-item state-green">자동스텝2 준비완료</div>
        <div class="bcf7-auto-item state-green">자동SS(출구)</div>
        <div class="bcf7-auto-item state-green">PLC 컨트롤 (PC OFF)</div>
        <div class="bcf7-auto-item state-green">유조 처리품 없음</div>
      </div>
    </div>

    <!-- ═══ [하단] 존구간(좌) + 온도CP/현재경보(우) ═══ -->
    <div class="bcf7-bottom-panel">

      <!-- 좌: 존구간 테이블 - 침탄/승온/침탄/확산/강온/균열/강온/드레인 -->
      <div class="bcf7-zone-panel">
        <table class="bcf7-zone-table">
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
              <td><div class="zbox7">DT</div></td>
              <td><div class="zbox7">DT</div></td>
              <td><div class="zbox7">DT</div></td>
              <td><div class="zbox7">DT</div></td>
              <td><div class="zbox7">DT</div></td>
              <td><div class="zbox7">DT</div></td>
              <td><div class="zbox7">DT</div></td>
              <td><div class="zbox7">DT</div></td>
            </tr>
            <tr>
              <td class="row-label">시간 (min) SP</td>
              <td><div class="zbox7 yellow"></div></td>
              <td><div class="zbox7 yellow">DT</div></td>
              <td><div class="zbox7 yellow">DT</div></td>
              <td><div class="zbox7 yellow"></div></td>
              <td><div class="zbox7 yellow">DT</div></td>
              <td><div class="zbox7 yellow">DT</div></td>
              <td><div class="zbox7 yellow">DT</div></td>
              <td><div class="zbox7 yellow">DT</div></td>
            </tr>
            <tr>
              <td class="row-label">온도 (°C) PV</td>
              <td><div class="zbox7">DT</div></td>
              <td><div class="zbox7">DT</div></td>
              <td><div class="zbox7">DT</div></td>
              <td><div class="zbox7">DT</div></td>
              <td><div class="zbox7">DT</div></td>
              <td><div class="zbox7">DT</div></td>
              <td><div class="zbox7">DT</div></td>
              <td><div class="zbox7">DT</div></td>
            </tr>
            <tr>
              <td class="row-label">온도 (°C) SP</td>
              <td><div class="zbox7 yellow">DT</div></td>
              <td><div class="zbox7 yellow">DT</div></td>
              <td><div class="zbox7 yellow">DT</div></td>
              <td><div class="zbox7 yellow">DT</div></td>
              <td><div class="zbox7 yellow">DT</div></td>
              <td><div class="zbox7 yellow">DT</div></td>
              <td><div class="zbox7 yellow">DT</div></td>
              <td><div class="zbox7 yellow">DT</div></td>
            </tr>
            <tr>
              <td class="row-label">CP (%) PV</td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 cyan">DT</div></td>
              <td><div class="zbox7 cyan">DT</div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
            </tr>
            <tr>
              <td class="row-label">CP (%) SP</td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 cyan">DT</div></td>
              <td><div class="zbox7 cyan">DT</div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
              <td><div class="zbox7 empty"></div></td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- 우: 온도CP(상) + 현재경보(하) -->
      <div class="bcf7-right-col">

        <!-- 온도 및 CP: 침탄실 DT ℃ | 유조 DT ℃ | CP DT ℃ | 침탄SP DT % | 유조SP DT % | CPSP DT % -->
        <div class="bcf7-temp-panel">
          <div class="bcf7-panel-title">온도 및 CP</div>
          <div class="bcf7-tp-row">
            <span class="bcf7-tp-lbl">침탄실</span>
            <div class="bcf7-tp-val"></div>
            <span class="bcf7-tp-unit">DT</span>
            <div class="bcf7-tp-val"></div>
            <span class="bcf7-tp-unit">℃</span>
            <div class="bcf7-tp-sep"></div>
            <span class="bcf7-tp-lbl">유조</span>
            <div class="bcf7-tp-val"></div>
            <span class="bcf7-tp-unit">DT</span>
            <div class="bcf7-tp-val"></div>
            <span class="bcf7-tp-unit">℃</span>
            <div class="bcf7-tp-sep"></div>
            <span class="bcf7-tp-lbl blue">CP</span>
            <div class="bcf7-tp-val blue"></div>
            <span class="bcf7-tp-unit">DT</span>
            <div class="bcf7-tp-val blue"></div>
            <span class="bcf7-tp-unit">℃</span>
            <div class="bcf7-tp-sep"></div>
            <span class="bcf7-tp-lbl">침탄SP</span>
            <div class="bcf7-tp-val"></div>
            <span class="bcf7-tp-unit">DT</span>
            <div class="bcf7-tp-val"></div>
            <span class="bcf7-tp-unit">%</span>
            <div class="bcf7-tp-sep"></div>
            <span class="bcf7-tp-lbl">유조SP</span>
            <div class="bcf7-tp-val"></div>
            <span class="bcf7-tp-unit">DT</span>
            <div class="bcf7-tp-val"></div>
            <span class="bcf7-tp-unit">%</span>
            <div class="bcf7-tp-sep"></div>
            <span class="bcf7-tp-lbl blue">CPSP</span>
            <div class="bcf7-tp-val blue"></div>
            <span class="bcf7-tp-unit">DT</span>
            <div class="bcf7-tp-val blue"></div>
            <span class="bcf7-tp-unit">%</span>
          </div>
        </div>

        <!-- 현재 경보 -->
        <div class="bcf7-alarm-panel">
          <div class="bcf7-panel-title">현재 경보</div>
          <div class="bcf7-alarm-body"></div>
        </div>

      </div><!-- /bcf7-right-col -->

    </div><!-- /bcf7-bottom-panel -->

  </div><!-- /group-2 -->
</div><!-- /page-wrap -->

<script>
var cur = location.pathname.split('/').pop();
document.querySelectorAll('.bcf-tab').forEach(function(a){
  if(a.getAttribute('href').split('/').pop() === cur) a.classList.add('active');
});
</script>
</body>
</html>
