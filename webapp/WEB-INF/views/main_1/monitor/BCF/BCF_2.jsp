
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../common_style.jsp" %>
<% String ctx = request.getContextPath(); %>
<link rel="stylesheet" href="<%= ctx %>/css/bcf1/style.css">
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
      <img class="bcf-1-rotate-1 bcf2_" src="<%= ctx %>/img/bcf1/bcf-1-rotate-10.png" />
      <img class="bcf-1-rotate-2 bcf2_" src="<%= ctx %>/img/bcf1/bcf-1-rotate-20.png" />
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
      <img class="bcf-1-fire-1 bcf2_30" src="<%= ctx %>/img/bcf1/bcf-1-fire-10.png" />
      <img class="bcf-1-fire-2  bcf2_16" src="<%= ctx %>/img/bcf1/bcf-1-fire-20.png" />
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

              <!-- 침탄실 DT ℃ -->
              <div class="tp-group">
                <span class="tp-lbl red">침탄실</span>
                <span class="tp-unit">DT</span>
                <div class="tp-val"></div>
                <span class="tp-unit">℃</span>
              </div>

              <!-- 유조 DT ℃ -->
              <div class="tp-group">
                <span class="tp-lbl green">유조</span>
                <span class="tp-unit">DT</span>
                <div class="tp-val"></div>
                <span class="tp-unit">℃</span>
              </div>

              <!-- CP DT % -->
              <div class="tp-group">
                <span class="tp-lbl blue">CP</span>
                <span class="tp-unit">DT</span>
                <div class="tp-val blue"></div>
                <span class="tp-unit">%</span>
              </div>

              <!-- 침탄SP DT ℃ -->
              <div class="tp-group">
                <span class="tp-lbl red">침탄SP</span>
                <span class="tp-unit">DT</span>
                <div class="tp-val"></div>
                <span class="tp-unit">℃</span>
              </div>

              <!-- 유조SP DT ℃ -->
              <div class="tp-group">
                <span class="tp-lbl green">유조SP</span>
                <span class="tp-unit">DT</span>
                <div class="tp-val"></div>
                <span class="tp-unit">℃</span>
              </div>

              <!-- CP SP DT % -->
              <div class="tp-group">
                <span class="tp-lbl blue">CP SP</span>
                <span class="tp-unit">DT</span>
                <div class="tp-val blue"></div>
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
              <td colspan="2"><div class="zbox"></div></td>
              <td colspan="2"><div class="zbox"></div></td>
              <td colspan="2"><div class="zbox"></div></td>
              <td colspan="2"><div class="zbox"></div></td>
              <td colspan="2"><div class="zbox"></div></td>
              <td colspan="2"><div class="zbox"></div></td>
              <td colspan="2"><div class="zbox"></div></td>
              <td colspan="2"><div class="zbox"></div></td>
              <td colspan="2"><div class="zbox"></div></td>
            </tr>
            <tr>
              <td class="row-label">시간(min) SP</td>
              <td colspan="2"><div class="zbox yellow"></div></td>
              <td colspan="2"><div class="zbox yellow"></div></td>
              <td colspan="2"><div class="zbox yellow"></div></td>
              <td colspan="2"><div class="zbox yellow"></div></td>
              <td colspan="2"><div class="zbox yellow"></div></td>
              <td colspan="2"><div class="zbox yellow"></div></td>
              <td colspan="2"><div class="zbox yellow"></div></td>
              <td colspan="2"><div class="zbox yellow"></div></td>
              <td colspan="2"><div class="zbox yellow"></div></td>
            </tr>
            <tr>
              <td class="row-label">온도(℃) PV</td>
              <td colspan="2"><div class="zbox"></div></td>
              <td colspan="2"><div class="zbox"></div></td>
              <td colspan="2"><div class="zbox"></div></td>
              <td colspan="2"><div class="zbox"></div></td>
              <td colspan="2"><div class="zbox"></div></td>
              <td colspan="2"><div class="zbox"></div></td>
              <td colspan="2"><div class="zbox"></div></td>
              <td colspan="2"><div class="zbox"></div></td>
              <td colspan="2"><div class="zbox empty"></div></td>
            </tr>
            <tr>
              <td class="row-label">온도(℃) SP</td>
              <td colspan="2"><div class="zbox yellow"></div></td>
              <td colspan="2"><div class="zbox yellow"></div></td>
              <td colspan="2"><div class="zbox yellow"></div></td>
              <td colspan="2"><div class="zbox yellow"></div></td>
              <td colspan="2"><div class="zbox yellow"></div></td>
              <td colspan="2"><div class="zbox yellow"></div></td>
              <td colspan="2"><div class="zbox yellow"></div></td>
              <td colspan="2"><div class="zbox yellow"></div></td>
              <td colspan="2"><div class="zbox empty"></div></td>
            </tr>
            <tr>
              <td class="row-label">CP(%) PV</td>
              <td colspan="2"><div class="zbox empty"></div></td>
              <td colspan="2"><div class="zbox empty"></div></td>
              <td colspan="2"><div class="zbox cyan"></div></td>
              <td colspan="2"><div class="zbox cyan"></div></td>
              <td colspan="2"><div class="zbox cyan"></div></td>
              <td colspan="2"><div class="zbox cyan"></div></td>
              <td colspan="2"><div class="zbox empty"></div></td>
              <td colspan="2"><div class="zbox empty"></div></td>
              <td colspan="2"><div class="zbox empty"></div></td>
            </tr>
            <tr>
              <td class="row-label">CP(%) SP</td>
              <td colspan="2"><div class="zbox empty"></div></td>
              <td colspan="2"><div class="zbox empty"></div></td>
              <td colspan="2"><div class="zbox cyan"></div></td>
              <td colspan="2"><div class="zbox cyan"></div></td>
              <td colspan="2"><div class="zbox cyan"></div></td>
              <td colspan="2"><div class="zbox cyan"></div></td>
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

<script>
var cur = location.pathname.split('/').pop();
document.querySelectorAll('.bcf-tab').forEach(function(a){
  if(a.getAttribute('href').split('/').pop() === cur) a.classList.add('active');
});
</script>
</body>
</html>
