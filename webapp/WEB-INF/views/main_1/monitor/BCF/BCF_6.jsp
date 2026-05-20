
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../common_style.jsp" %>
<% String ctx = request.getContextPath(); %>
<link rel="stylesheet" href="<%= ctx %>/css/bcf6/style.css">
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
  left:   1380px;   /* 설비 이미지 우측 끝 이후 */
  top:    0;
  right:  0;
  height: 450px;    /* 존구간/온도CP 영역 위까지 */
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
  border-radius: 3px;
  border: 1px solid #555;
  font-size: 9px;
  font-weight: 700;
  background: #85c25f;   /* 기본 초록 */
  color: #fff;
  text-align: center;
  padding: 2px 3px;
  line-height: 1.2;
}
.bcf6-auto-item.state-red    { background: #ff2222; color: #fff; border-color: #cc0000; }
.bcf6-auto-item.state-green  { background: #85c25f; color: #fff; border-color: #5a9a30; }
.bcf6-auto-item.state-gray   { background: #d9d9d9; color: #333; border-color: #999; }
.bcf6-auto-item.state-yellow { background: #f5c400; color: #333; border-color: #c8a000; }

/* ═══════════════════════════════════════════════
   [하단 전체] 존구간(좌) + [온도CP + 현재경보](우)
   ═══════════════════════════════════════════════ */
.bcf6-bottom-panel {
  position: absolute;
  left:   0;
  top:    590px;   /* 설비 이미지 하단 이후 */
  right:  0;
  bottom: auto;
  height : 180px;
  display: flex;
  flex-direction: row;
  gap: 4px;
  padding: 3px;
  overflow: hidden;
}

/* ── 좌: 존구간 테이블 ── */
.bcf6-zone-panel {
  flex: 0 0 570px;   /* 사진 기준 좌측 너비 */
  border: 1.5px solid #888;
  border-radius: 3px;
  overflow: hidden;
  background: #e8e8e8;
}
.bcf6-zone-table {
  width: 100%;
  height: 100%;
  border-collapse: collapse;
  font-size: 10px;
  table-layout: fixed;
}
.bcf6-zone-table th,
.bcf6-zone-table td {
  border: 1px solid #bbb;
  text-align: center;
  padding: 1px 2px;
  white-space: nowrap;
  overflow: hidden;
}
/* 존 이름 헤더 행 */
.bcf6-zone-table thead tr th {
  background: #d0d0d0;
  color: #222;
  font-weight: 700;
  font-size: 10px;
  padding: 3px 1px;
}
.bcf6-zone-table thead tr th.th-empty {
  background: #e8e8e8;
  border: none;
}
/* 행 레이블 */
.bcf6-zone-table tbody tr td.row-label {
  background: #d8d8d8;
  font-weight: 700;
  color: #222;
  text-align: left;
  padding-left: 4px;
  font-size: 9px;
  white-space: nowrap;
}
.bcf6-zone-table tbody tr td { background: #fff; }

/* 존 값 박스 */
.zbox6 {
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
.zbox6.yellow { background: #fffaaa; border-color: #c8c000; color: #5a5000; }
.zbox6.cyan   { background: #aaeeff; border-color: #40aacc; color: #003a5c; }
.zbox6.empty  { background: #eeeeee; border-color: #ccc;    color: #aaa; }
.zbox6.dt     { background: #ffb0b0; border-color: #cc5050; color: #5a0000; }

/* ── 우: 온도및CP(상) + 현재경보(하) ── */
.bcf6-right-col {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

/* 온도 및 CP */
.bcf6-temp-panel {
  flex-shrink: 0;
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
/* 온도CP 한 줄: 가열 ℃ | 침탄2 ℃ | 가열CP % | 침탄CP % */
.bcf6-tp-row {
  display: flex;
  align-items: center;
  background: #d0f0ec;
  border-top: 1px solid #2aada0;
  padding: 3px 4px;
  gap: 4px;
}
.bcf6-tp-lbl {
  font-size: 10px;
  font-weight: 700;
  color: #cc0000;
  white-space: nowrap;
  flex-shrink: 0;
}
.bcf6-tp-lbl.green { color: #006600; }
.bcf6-tp-lbl.blue  { color: #003399; }
.bcf6-tp-val {
  flex: 1;
  min-width: 40px;
  height: 18px;
  line-height: 18px;
  border-radius: 2px;
  background: #9ccc8d;
  border: 1px solid #6aaa50;
  font-size: 10px;
  color: #1a4000;
  text-align: center;
}
.bcf6-tp-val.blue  { background: #b0d8f8; border-color: #5aadda; color: #003a5c; }
.bcf6-tp-unit {
  font-size: 10px;
  color: #1a5c52;
  font-weight: 700;
  white-space: nowrap;
  flex-shrink: 0;
}
.bcf6-tp-sep {
  width: 1px;
  height: 20px;
  background: #2aada0;
  flex-shrink: 0;
}

/* 현재 경보 */
.bcf6-alarm-panel {
  flex: 1;
  border: 1.5px solid #2aada0;
  border-radius: 3px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  min-height: 0;
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
        <%-- 사진 기준 2열: 좌항목 | 우항목 --%>
        <div class="bcf6-auto-item state-green">입구리프터2 상승+처리품</div>
        <div class="bcf6-auto-item state-red">비상정지</div>
        <div class="bcf6-auto-item state-green">예열입구 보조롤러 하강</div>
        <div class="bcf6-auto-item state-green">예열 자동스탭 준비완료</div>
        <div class="bcf6-auto-item state-green">예열 입구문 닫힘</div>
        <div class="bcf6-auto-item state-green">예열→가열 자동준비완료</div>
        <div class="bcf6-auto-item state-green">예열 출구문 닫힘</div>
        <div class="bcf6-auto-item state-green">가열→침탄1 자동준비완료</div>
        <div class="bcf6-auto-item state-green">예열 수동조건 아님</div>
        <div class="bcf6-auto-item state-green">침탄1→침탄2 자동준비완료</div>
        <div class="bcf6-auto-item state-green">가열입구리프터 처리품X</div>
        <div class="bcf6-auto-item state-green">침탄2→침탄3 자동준비완료</div>
        <div class="bcf6-auto-item state-green">가열 입구문 닫힘</div>
        <div class="bcf6-auto-item state-green">강온→유조 자동준비완료</div>
        <div class="bcf6-auto-item state-green">침탄 입구문 닫힘</div>
        <div class="bcf6-auto-item state-green">유조 자동스탭 준비완료</div>
        <div class="bcf6-auto-item state-green">강온 입구문 닫힘</div>
        <div class="bcf6-auto-item state-green">가열입구 커튼SW ON</div>
        <div class="bcf6-auto-item state-green">유조 입구문 닫힘</div>
        <div class="bcf6-auto-item state-green">가열입구 염검출</div>
        <div class="bcf6-auto-item state-green">유조 E/V 상승</div>
        <div class="bcf6-auto-item state-green">가열배기 염검출</div>
        <div class="bcf6-auto-item state-green">유조 보조체인 하강</div>
        <div class="bcf6-auto-item state-green">유조출구 커튼SW ON</div>
        <div class="bcf6-auto-item state-green">유조 출구문 닫힘</div>
        <div class="bcf6-auto-item state-green">유조출구 염검출</div>
        <div class="bcf6-auto-item state-green">유조출구 리프터 하강</div>
        <div class="bcf6-auto-item state-green">유조배기 염검출</div>
        <div class="bcf6-auto-item state-green">제어반 자동선택(터치)</div>
        <div class="bcf6-auto-item state-green">O2 제어전원 켜짐</div>
        <div class="bcf6-auto-item state-green">예열OP 자동SS</div>
        <div class="bcf6-auto-item state-green">O2 제어정상</div>
        <div class="bcf6-auto-item state-green">침탄입구OP 자동SS</div>
        <div class="bcf6-auto-item state-green">MASSFLOW 전원켜짐</div>
        <div class="bcf6-auto-item state-green">침탄출구OP 자동SS</div>
        <div class="bcf6-auto-item state-green">엔리치가스 ON(터치)</div>
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
            <tr>
              <td class="row-label">시간 (min) PV</td>
              <td><div class="zbox6 dt">DT</div></td>
              <td><div class="zbox6 dt">DT</div></td>
              <td><div class="zbox6 dt">DT</div></td>
              <td><div class="zbox6 dt">DT</div></td>
              <td><div class="zbox6 dt">DT</div></td>
              <td><div class="zbox6 dt">DT</div></td>
              <td><div class="zbox6 dt">DT</div></td>
            </tr>
            <tr>
              <td class="row-label">시간 (min) SP</td>
              <td><div class="zbox6 yellow">DT</div></td>
              <td><div class="zbox6 yellow">DT</div></td>
              <td><div class="zbox6 yellow">DT</div></td>
              <td><div class="zbox6 yellow">DT</div></td>
              <td><div class="zbox6 yellow">DT</div></td>
              <td><div class="zbox6 yellow">DT</div></td>
              <td><div class="zbox6 yellow">DT</div></td>
            </tr>
            <tr>
              <td class="row-label">온도 (°C) PV</td>
              <td><div class="zbox6 dt">DT</div></td>
              <td><div class="zbox6 dt">DT</div></td>
              <td><div class="zbox6 dt">DT</div></td>
              <td><div class="zbox6 dt">DT</div></td>
              <td><div class="zbox6 dt">DT</div></td>
              <td><div class="zbox6 dt">DT</div></td>
              <td><div class="zbox6 dt">DT</div></td>
            </tr>
            <tr>
              <td class="row-label">온도 (°C) SP</td>
              <td><div class="zbox6 yellow">DT</div></td>
              <td><div class="zbox6 yellow">DT</div></td>
              <td><div class="zbox6 yellow"></div></td>
              <td><div class="zbox6 yellow">DT</div></td>
              <td><div class="zbox6 yellow"></div></td>
              <td><div class="zbox6 yellow">DT</div></td>
              <td><div class="zbox6 yellow">DT</div></td>
            </tr>
            <tr>
              <td class="row-label">CP (%) PV</td>
              <td><div class="zbox6 empty"></div></td>
              <td><div class="zbox6 cyan">DT</div></td>
              <td><div class="zbox6 cyan">DT</div></td>
              <td><div class="zbox6 cyan">DT</div></td>
              <td><div class="zbox6 cyan">DT</div></td>
              <td><div class="zbox6 cyan">DT</div></td>
              <td><div class="zbox6 empty"></div></td>
            </tr>
            <tr>
              <td class="row-label">CP (%) SP</td>
              <td><div class="zbox6 empty"></div></td>
              <td><div class="zbox6 cyan">DT</div></td>
              <td><div class="zbox6 cyan">DT</div></td>
              <td><div class="zbox6 cyan">DT</div></td>
              <td><div class="zbox6 cyan">DT</div></td>
              <td><div class="zbox6 cyan">DT</div></td>
              <td><div class="zbox6 empty"></div></td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- 우: 온도CP(상) + 현재경보(하) -->
      <div class="bcf6-right-col">

        <!-- 온도 및 CP: 사진 기준 가열 ℃ | 침탄2 ℃ | 가열CP % | 침탄CP % 한 줄 -->
        <div class="bcf6-temp-panel">
          <div class="bcf6-panel-title">온도 및 CP</div>
          <div class="bcf6-tp-row">
            <span class="bcf6-tp-lbl red">가열</span>
            <div class="bcf6-tp-val"></div>
            <span class="bcf6-tp-unit">℃</span>
            <div class="bcf6-tp-sep"></div>
            <span class="bcf6-tp-lbl red">침탄2</span>
            <div class="bcf6-tp-val"></div>
            <span class="bcf6-tp-unit">℃</span>
            <div class="bcf6-tp-sep"></div>
            <span class="bcf6-tp-lbl blue">가열CP</span>
            <div class="bcf6-tp-val blue"></div>
            <span class="bcf6-tp-unit">%</span>
            <div class="bcf6-tp-sep"></div>
            <span class="bcf6-tp-lbl blue">침탄CP</span>
            <div class="bcf6-tp-val blue"></div>
            <span class="bcf6-tp-unit">%</span>
          </div>
        </div>

        <!-- 현재 경보 -->
        <div class="bcf6-alarm-panel">
          <div class="bcf6-panel-title">현재 경보</div>
          <div class="bcf6-alarm-body"></div>
        </div>

      </div><!-- /bcf6-right-col -->

    </div><!-- /bcf6-bottom-panel -->

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
