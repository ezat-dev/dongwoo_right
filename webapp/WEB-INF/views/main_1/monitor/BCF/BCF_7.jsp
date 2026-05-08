
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../common_style.jsp" %>
<% String ctx = request.getContextPath(); %>
<link rel="stylesheet" href="<%= ctx %>/css/bcf7/style.css">
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
  bottom: auto;
  height: 200px;
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
    <div class="bcf-7-deatil">
      <img class="bcf-7-obj-1" src="<%= ctx %>/img/bcf7/bcf-7-obj-10.png" />
      <img class="bcf-7-obj-2" src="<%= ctx %>/img/bcf7/bcf-7-obj-20.png" />
      <img class="bcf-7-obj-3" src="<%= ctx %>/img/bcf7/bcf-7-obj-30.png" />
      <img class="bcf-7-tray-1" src="<%= ctx %>/img/bcf7/bcf-7-tray-10.png" />
      <img class="bcf-7-tray-2" src="<%= ctx %>/img/bcf7/bcf-7-tray-20.png" />
      <img class="bcf-7-obj-4" src="<%= ctx %>/img/bcf7/bcf-7-obj-40.png" />
      <img class="bcf-7-obj-5" src="<%= ctx %>/img/bcf7/bcf-7-obj-50.png" />
      <img class="bcf-7-obj-6" src="<%= ctx %>/img/bcf7/bcf-7-obj-60.png" />
      <img class="bcf-7-obj-7" src="<%= ctx %>/img/bcf7/bcf-7-obj-70.png" />
      <img class="bcf-7-pipe-off" src="<%= ctx %>/img/bcf7/bcf-7-pipe-off0.png" />
      <img class="bcf-7-pipe-on" src="<%= ctx %>/img/bcf7/bcf-7-pipe-on0.png" />
      <div class="bcf-7-obj-8"></div>
      <img class="bcf-7-pen-off" src="<%= ctx %>/img/bcf7/bcf-7-pen-off0.png" />
      <img class="bcf-7-pen-on" src="<%= ctx %>/img/bcf7/bcf-7-pen-on0.png" />
      <img class="bcf-7-propel-1" src="<%= ctx %>/img/bcf7/bcf-7-propel-10.png" />
      <img class="bcf-7-door-open-1" src="<%= ctx %>/img/bcf7/bcf-7-door-open-10.png" />
      <img class="bcf-7-door-close-1" src="<%= ctx %>/img/bcf7/bcf-7-door-close-10.png" />
      <img class="bcf-7-bong-1" src="<%= ctx %>/img/bcf7/bcf-7-bong-10.png" />
      <img class="bcf-7-bong-2" src="<%= ctx %>/img/bcf7/bcf-7-bong-20.png" />
      <img class="bcf-7-bong-3" src="<%= ctx %>/img/bcf7/bcf-7-bong-30.png" />
      <img class="bcf-7-door-open-3" src="<%= ctx %>/img/bcf7/bcf-7-door-open-30.png" />
      <img class="bcf-7-door-close-3" src="<%= ctx %>/img/bcf7/bcf-7-door-close-30.png" />
      <img class="bcf-7-bong-4" src="<%= ctx %>/img/bcf7/bcf-7-bong-40.png" />
      <img class="bcf-7-bong-5" src="<%= ctx %>/img/bcf7/bcf-7-bong-50.png" />
      <img class="bcf-7-bong-6" src="<%= ctx %>/img/bcf7/bcf-7-bong-60.png" />
      <img class="bcf-7-motor-off-3" src="<%= ctx %>/img/bcf7/bcf-7-motor-off-30.png" />
      <img class="bcf-7-motor-green-3" src="<%= ctx %>/img/bcf7/bcf-7-motor-green-30.png" />
      <img class="bcf-7-motor-yellow-3" src="<%= ctx %>/img/bcf7/bcf-7-motor-yellow-30.png" />
      <div class="bcf-7-oil"></div>
      <img class="bcf-7-elv-1" src="<%= ctx %>/img/bcf7/bcf-7-elv-10.png" />
      <img class="bcf-7-tray-7" src="<%= ctx %>/img/bcf7/bcf-7-tray-70.png" />
      <img class="bcf-7-air-cycle" src="<%= ctx %>/img/bcf7/bcf-7-air-cycle0.png" />
      <div class="bcf-7-auto-box-2"></div>
      <div class="bcf-7-straight-box-2"></div>
      <div class="bcf-7-auto-box-1"></div>
      <div class="bcf-7-straight-box-1"></div>
      <div class="bcf-7-dt-3"></div>
      <div class="bcf-7-sw-red-1"></div>
      <div class="bcf-7-sw-green-1"></div>
      <div class="bcf-7-sw-red-2"></div>
      <div class="bcf-7-sw-green-2"></div>
      <div class="bcf-7-flame-red-2"></div>
      <div class="bcf-7-flame-green-2"></div>
      <img class="bcf-7-stick-off-1" src="<%= ctx %>/img/bcf7/bcf-7-stick-off-10.png" />
      <img class="bcf-7-stick-on-1" src="<%= ctx %>/img/bcf7/bcf-7-stick-on-10.png" />
      <img class="bcf-7-stick-off-2" src="<%= ctx %>/img/bcf7/bcf-7-stick-off-20.png" />
      <img class="bcf-7-stick-on-2" src="<%= ctx %>/img/bcf7/bcf-7-stick-on-20.png" />
      <img class="bcf-7-point-1" src="<%= ctx %>/img/bcf7/bcf-7-point-10.png" />
      <img class="bcf-7-mini-1" src="<%= ctx %>/img/bcf7/bcf-7-mini-10.png" />
      <img class="bcf-7-stick-1" src="<%= ctx %>/img/bcf7/bcf-7-stick-10.png" />
      <img class="bcf-7-mini-2" src="<%= ctx %>/img/bcf7/bcf-7-mini-20.png" />
      <img class="bcf-7-jog-green-1" src="<%= ctx %>/img/bcf7/bcf-7-jog-green-10.png" />
      <img class="bcf-7-jog-off-1" src="<%= ctx %>/img/bcf7/bcf-7-jog-off-10.png" />
      <img class="bcf-7-jog-yellow-1" src="<%= ctx %>/img/bcf7/bcf-7-jog-yellow-10.png" />
      <img class="bcf-7-jog-green-2" src="<%= ctx %>/img/bcf7/bcf-7-jog-green-20.png" />
      <img class="bcf-7-jog-off-2" src="<%= ctx %>/img/bcf7/bcf-7-jog-off-20.png" />
      <img class="bcf-7-jog-yellow-2" src="<%= ctx %>/img/bcf7/bcf-7-jog-yellow-20.png" />
      <img class="bcf-7-jog-off-3" src="<%= ctx %>/img/bcf7/bcf-7-jog-off-30.png" />
      <img class="bcf-7-motor-green-1" src="<%= ctx %>/img/bcf7/bcf-7-motor-green-10.png" />
      <img class="bcf-7-motor-off-1" src="<%= ctx %>/img/bcf7/bcf-7-motor-off-10.png" />
      <img class="bcf-7-motor-yellow-1" src="<%= ctx %>/img/bcf7/bcf-7-motor-yellow-10.png" />
      <img class="bcf-7-motor-green-2" src="<%= ctx %>/img/bcf7/bcf-7-motor-green-20.png" />
      <img class="bcf-7-motor-off-2" src="<%= ctx %>/img/bcf7/bcf-7-motor-off-20.png" />
      <img class="bcf-7-motor-yellow-2" src="<%= ctx %>/img/bcf7/bcf-7-motor-yellow-20.png" />
      <img class="bcf-7-sensor-off-1" src="<%= ctx %>/img/bcf7/bcf-7-sensor-off-10.png" />
      <img class="bcf-7-sensor-on-1" src="<%= ctx %>/img/bcf7/bcf-7-sensor-on-10.png" />
      <img class="bcf-7-door-close-2" src="<%= ctx %>/img/bcf7/bcf-7-door-close-20.png" />
      <img class="bcf-7-door-open-2" src="<%= ctx %>/img/bcf7/bcf-7-door-open-20.png" />
      <img class="bcf-7-obj-9" src="<%= ctx %>/img/bcf7/bcf-7-obj-90.png" />
      <img class="bcf-7-elv-2" src="<%= ctx %>/img/bcf7/bcf-7-elv-20.png" />
      <img class="bcf-7-tray-3" src="<%= ctx %>/img/bcf7/bcf-7-tray-30.png" />
      <img class="bcf-7-tray-4" src="<%= ctx %>/img/bcf7/bcf-7-tray-40.png" />
      <img class="bcf-7-tray-5" src="<%= ctx %>/img/bcf7/bcf-7-tray-50.png" />
      <img class="bcf-7-tray-6" src="<%= ctx %>/img/bcf7/bcf-7-tray-60.png" />
      <img class="bcf-7-tray-8" src="<%= ctx %>/img/bcf7/bcf-7-tray-80.png" />
      <img class="bcf-7-bong-7" src="<%= ctx %>/img/bcf7/bcf-7-bong-70.png" />
      <img class="bcf-7-bong-8" src="<%= ctx %>/img/bcf7/bcf-7-bong-80.png" />
      <img class="bcf-7-bong-9" src="<%= ctx %>/img/bcf7/bcf-7-bong-90.png" />
      <img class="bcf-7-obj-10" src="<%= ctx %>/img/bcf7/bcf-7-obj-100.png" />
      <img class="bcf-7-obj-11" src="<%= ctx %>/img/bcf7/bcf-7-obj-110.png" />
      <img class="bcf-7-firepipe-off" src="<%= ctx %>/img/bcf7/bcf-7-firepipe-off0.png" />
      <img class="bcf-7-rotate-1" src="<%= ctx %>/img/bcf7/bcf-7-rotate-10.png" />
      <img class="bcf-7-rotate-2" src="<%= ctx %>/img/bcf7/bcf-7-rotate-20.png" />
      <img class="bcf-7-rotate-3" src="<%= ctx %>/img/bcf7/bcf-7-rotate-30.png" />
      <img class="bcf-7-arrow-1" src="<%= ctx %>/img/bcf7/bcf-7-arrow-10.png" />
      <img class="bcf-7-arrow-2" src="<%= ctx %>/img/bcf7/bcf-7-arrow-20.png" />
      <div class="bcf-7-dt-1"></div>
      <div class="bcf-7-dt-2"></div>
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
