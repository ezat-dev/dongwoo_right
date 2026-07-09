<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="<%= ctx %>/img/main_monitor_1/vars.css">
  <link rel="stylesheet" href="<%= ctx %>/img/main_monitor_1/style.css">
  
  
  <style>
   a,
   button,
   input,
   select,
   h1,
   h2,
   h3,
   h4,
   h5,
   * {
       box-sizing: border-box;
       margin: 0;
       padding: 0;
       border: none;
       text-decoration: none;
       background: none;
   
       -webkit-font-smoothing: antialiased;
   }
   
   menu, ol, ul {
       list-style-type: none;
       margin: 0;
       padding: 0;
   }
   html, body { height: 100%; overflow: hidden; background: #fff; }
   .ov-tab-group {
     position: fixed; top: 10px; right: 14px; z-index: 9999;
     display: flex; align-items: center;
     background: rgba(255,255,255,0.92); border: 1px solid #CBD5E0;
     border-radius: 8px; overflow: hidden;
     box-shadow: 0 2px 8px rgba(0,0,0,0.12);
     backdrop-filter: blur(4px);
   }
   .ov-tab {
     padding: 6px 16px; font-size: 11px; font-weight: 700;
     letter-spacing: .6px; color: #718096;
     background: none; border: none; cursor: pointer;
     transition: background .13s, color .13s;
     white-space: nowrap; font-family: 'Segoe UI', sans-serif;
   }
   .ov-tab:not(:last-child) { border-right: 1px solid #CBD5E0; }
   .ov-tab:hover { background: #EBF8FF; color: #3182CE; }
   .ov-tab.active { background: #3182CE; color: #fff; }
   .ov-tab-auto { color: #276749; border-left: 1px solid #CBD5E0; }
   .ov-tab-auto:hover:not(.running) { background: #C6F6D5; color: #276749; }
   .ov-tab-auto.running { background: #276749; color: #fff; }

   /* ── BCF 명칭 / 운전모드 라벨 ── */
   .bcf-name-lbl {
     position: absolute;
     width: 183px; height: 26px;
     display: flex; align-items: center; justify-content: center;
     font-size: 13px; font-weight: 900; letter-spacing: .8px;
     background: linear-gradient(160deg, #f8fafc 0%, #eff6ff 100%);
     color: #1d4ed8;
     border: 1px solid #bfdbfe;
     border-radius: 6px 6px 0 0;
     top: 62px; z-index: 200;
     font-family: 'Segoe UI', 'Malgun Gothic', sans-serif;
     box-shadow: 0 1px 4px rgba(59,130,246,.12), inset 0 1px 0 rgba(255,255,255,.85);
     text-shadow: 0 1px 0 rgba(255,255,255,.85);
   }
   .bcf-mode-lbl {
     position: absolute;
     width: 183px; height: 26px;
     display: flex; align-items: center; justify-content: center;
     font-size: 12px; font-weight: 800;
     background: linear-gradient(160deg, #f0fdf4 0%, #dcfce7 100%);
     color: #15803d;
     border: 1px solid #bbf7d0;
     border-top: none;
     border-radius: 0 0 6px 6px;
     top: 88px; z-index: 200;
     font-family: 'Segoe UI', 'Malgun Gothic', sans-serif;
     letter-spacing: .2px;
     transition: background .2s, box-shadow .2s;
     box-shadow: 0 1px 4px rgba(16,185,129,.12), inset 0 1px 0 rgba(255,255,255,.7);
     text-shadow: 0 1px 0 rgba(255,255,255,.7);
   }

   .group-1 [class*="-jogging"],
   .group-1 [class*="-open-"],
   .group-1 [class*="-close-"],
   .group-1 [class$="-stop"],
   .group-1 [class*="-stop "],
   .group-1 [class$="-up"],
   .group-1 [class*="-up "],
   .group-1 [class$="-down"],
   .group-1 [class*="-down "] {
     display: flex;
     align-items: center;
     justify-content: center;
     text-align: center;
     font-family: 'Malgun Gothic', 'Segoe UI', Arial, sans-serif;
     font-size: 12px;
     font-weight: 800;
     line-height: 1;
     letter-spacing: 0;
     white-space: nowrap;
     overflow: hidden;
     color: #111827;
     border-color: rgba(17, 24, 39, .72) !important;
     border-radius: 3px;
     box-shadow: inset 0 1px 0 rgba(255,255,255,.45), 0 1px 3px rgba(15,23,42,.22);
     text-shadow: 0 1px 0 rgba(255,255,255,.45);
   }

   .group-1 [class*="-jogging"] {
     background: linear-gradient(180deg, #e0f2fe 0%, #7dd3fc 100%) !important;
     color: #0c4a6e !important;
     font-weight: 800 !important;
   }
   .group-1 [class*="-close-"] {
     background: linear-gradient(180deg, #bbf7d0 0%, #22c55e 100%) !important;
     font-size: 11px !important;
   }
   .group-1 [class*="-open-"] {
     color: #fff;
     background: linear-gradient(180deg, #fb7185 0%, #dc2626 100%) !important;
     text-shadow: 0 1px 1px rgba(0,0,0,.35);
   }
   .group-1 [class$="-down"],
   .group-1 [class*="-down "] {
     background: linear-gradient(180deg, #fef08a 0%, #facc15 100%) !important;
   }
   .group-1 [class$="-up"],
   .group-1 [class*="-up "],
   .group-1 [class$="-stop"],
   .group-1 [class*="-stop "] {
     background: linear-gradient(180deg, #e0f2fe 0%, #60a5fa 100%) !important;
   }

   @keyframes penSpinRight {
     from { transform: rotate(0deg); }
     to   { transform: rotate(360deg); }
   }
   .group-1 img[class*="-alarm"] {
     top: 114.62px !important;
   }
   .group-1 img[class*="-pen-"] {
     transform-origin: 50% 50%;
     animation: penSpinRight 5.5s linear infinite;
     will-change: transform;
     z-index: 3;
   }
   .group-1 img[class*="-pen-"].pen-rotating {
     animation-play-state: running;
   }
   .group-1 img[class*="-pen-"].pen-stopped {
     animation-play-state: paused;
   }
   .group-1 [class*="-conn"] {
     width: 183px; height: 43px;
     border-radius: 8px;
     border: 1px solid #e2e8f0;
     display: flex; flex-direction: row; align-items: center; justify-content: center; gap: 10px;
     font-family: 'Malgun Gothic', sans-serif;
     font-size: 13px; font-weight: 700; letter-spacing: .5px;
     background: rgba(248,250,252,.95);
     box-shadow: 0 3px 10px rgba(0,0,0,.08);
     overflow: hidden; white-space: nowrap;
   }
   .conn-indicator {
     width: 24px; height: 24px;
     display: inline-flex; align-items: center; justify-content: center;
     flex-shrink: 0;
   }
   @keyframes breathe-ok {
     0%,100% { transform: scale(1)    rotate(0deg);   border-radius: 3px;  background: #16a34a; box-shadow: 0 0 6px rgba(22,163,74,.55); }
     25%      { transform: scale(1.22) rotate(45deg);  border-radius: 1px;  background: #4ade80; box-shadow: 0 0 10px rgba(74,222,128,.4); }
     50%      { transform: scale(0.80) rotate(90deg);  border-radius: 50%; background: #bbf7d0; box-shadow: 0 0 4px rgba(134,239,172,.2); }
     75%      { transform: scale(1.12) rotate(135deg); border-radius: 1px;  background: #4ade80; box-shadow: 0 0 8px rgba(74,222,128,.35); }
   }
   @keyframes breathe-load {
     0%,100% { transform: scale(1)    rotate(0deg);   border-radius: 3px;  background: #d97706; box-shadow: 0 0 6px rgba(217,119,6,.6); }
     25%      { transform: scale(1.22) rotate(45deg);  border-radius: 1px;  background: #fbbf24; box-shadow: 0 0 10px rgba(251,191,36,.45); }
     50%      { transform: scale(0.80) rotate(90deg);  border-radius: 50%; background: #fde68a; box-shadow: 0 0 4px rgba(253,230,138,.25); }
     75%      { transform: scale(1.12) rotate(135deg); border-radius: 1px;  background: #fbbf24; box-shadow: 0 0 8px rgba(251,191,36,.4); }
   }
   .breath-sq { display: block; width: 11px; height: 13px; flex-shrink: 0; border-radius: 3px; }
   .group-1 .conn-ok {
     background: linear-gradient(135deg,rgba(220,252,231,.97) 0%,rgba(187,247,208,.97) 100%) !important;
     border: 1px solid rgba(34,197,94,.45) !important; color: #14532d !important;
     box-shadow: 0 4px 20px rgba(34,197,94,.32), inset 0 1px 0 rgba(255,255,255,.7);
   }
   .group-1 .conn-ok      .breath-sq { animation: breathe-ok   3s ease-in-out infinite; }
   .group-1 .conn-loading {
     background: linear-gradient(135deg,rgba(255,251,235,.97) 0%,rgba(254,249,195,.97) 100%) !important;
     border: 1px solid rgba(245,158,11,.45) !important; color: #78350f !important;
     box-shadow: 0 4px 20px rgba(245,158,11,.28), inset 0 1px 0 rgba(255,255,255,.7);
   }
   .group-1 .conn-loading .breath-sq { animation: breathe-load 1.6s ease-in-out infinite; }

    /* DT 단품 카운터 박스 — main_monitor2 동일 스타일, 박스 확대 */
   .group-1 [class*="-dt"] {
     background: #e8f5e9 !important;
     border: 1px solid #a5d6a7 !important;
     border-radius: 5px;
     width: 66px !important;
     height: 30px !important;
     display: flex !important;
     align-items: center;
     justify-content: center;
     font-family: 'Malgun Gothic', 'Segoe UI', Arial, sans-serif;
     font-size: 13px;
     font-weight: 800;
     color: #2e7d32;
     letter-spacing: .3px;
     box-shadow: 0 1px 3px rgba(46,125,50,.12);
     transform: translate(-3px, -25px);
   }

   .bcf-12-pen-3 { width: 43.72px; height: 43.72px; position: absolute; left: 178px; top: 238px; object-fit: cover; aspect-ratio: 1; }
    .bcf-1-pen-3 { width: 43.72px; height: 43.72px; position: absolute; left: 428px; top: 238px; object-fit: cover; aspect-ratio: 1; }
    .bcf-2-pen-3 { width: 43.72px; height: 43.72px; position: absolute; left: 678px; top: 238px; object-fit: cover; aspect-ratio: 1; }
    .bcf-3-pen-3 { width: 43.72px; height: 43.72px; position: absolute; left: 928px; top: 238px; object-fit: cover; aspect-ratio: 1; }
    .bcf-4-pen-3 { width: 43.72px; height: 43.72px; position: absolute; left: 1177px; top: 238px; object-fit: cover; aspect-ratio: 1; }
    .bcf-10-pen-3 { width: 43.72px; height: 43.72px; position: absolute; left: 1428px; top: 238px; object-fit: cover; aspect-ratio: 1; }
    .bcf-5-pen-3 { width: 43.72px; height: 43.72px; position: absolute; left: 1677px; top: 238px; object-fit: cover; aspect-ratio: 1; }


   .bcf-12-pen-2 { width: 43.72px !important; height: 43.72px !important; left: 244.56px !important; top: 377.33px !important; }
   .bcf-12-pen-1 { width: 43.72px !important; height: 43.72px !important; left: 113.16px !important; top: 377.33px !important; }
   .bcf-1-pen-2  { width: 43.72px !important; height: 43.72px !important; left: 494.41px !important; top: 377.33px !important; }
   .bcf-1-pen-1  { width: 43.72px !important; height: 43.72px !important; left: 363px     !important; top: 377.33px !important; }
   .bcf-2-pen-2  { width: 43.72px !important; height: 43.72px !important; left: 744.25px !important; top: 377.33px !important; }
   .bcf-2-pen-1  { width: 43.72px !important; height: 43.72px !important; left: 612.85px !important; top: 377.33px !important; }
   .bcf-3-pen-2  { width: 43.72px !important; height: 43.72px !important; left: 994.1px  !important; top: 377.33px !important; }
   .bcf-3-pen-1  { width: 43.72px !important; height: 43.72px !important; left: 862.69px !important; top: 377.33px !important; }
   .bcf-4-pen-2  { width: 43.72px !important; height: 43.72px !important; left: 1243.95px !important; top: 377.33px !important; }
   .bcf-4-pen-1  { width: 43.72px !important; height: 43.72px !important; left: 1112.54px !important; top: 377.33px !important; }
   .bcf-10-pen-2 { width: 43.72px !important; height: 43.72px !important; left: 1493.79px !important; top: 377.33px !important; }
   .bcf-10-pen-1 { width: 43.72px !important; height: 43.72px !important; left: 1362.39px !important; top: 377.33px !important; }
   .bcf-5-pen-2  { width: 43.72px !important; height: 43.72px !important; left: 1743.64px !important; top: 377.33px !important; }
   .bcf-5-pen-1  { width: 43.72px !important; height: 43.72px !important; left: 1612.23px !important; top: 377.33px !important; }
   .bcf-1-belt-dt  { position: absolute; left: 420.60px;  top: 595.22px; width: 183px; height: 43px; z-index: 10; }
   .bcf-2-belt-dt  { position: absolute; left: 670.45px;  top: 595.22px; width: 183px; height: 43px; z-index: 10; }
   .bcf-3-belt-dt  { position: absolute; left: 920.29px;  top: 595.22px; width: 183px; height: 43px; z-index: 10; }
   .bcf-4-belt-dt  { position: absolute; left: 1170.14px; top: 595.22px; width: 183px; height: 43px; z-index: 10; }
   .bcf-10-belt-dt { position: absolute; left: 1419.99px; top: 595.22px; width: 183px; height: 43px; z-index: 10; }
   .bcf-5-belt-dt  { position: absolute; left: 1669.83px; top: 595.22px; width: 183px; height: 43px; z-index: 10; }
   </style>
  <title>Document</title>
</head>
<body>
  <div class="ov-tab-group">
    <button class="ov-tab active">OVERVIEW-1</button>
    <button class="ov-tab" onclick="window.parent.goOverview(2)">OVERVIEW-2</button>
    <button class="ov-tab ov-tab-auto" id="btnAuto" onclick="toggleAutoSlideshow()">▶ AUTO</button>
  </div>
  <div class="group-1">

    <!-- BCF 명칭 / 운전모드 라벨 (절대좌표, 각 작화 정중앙 정렬) -->
    <div class="bcf-name-lbl" style="left:107.65px">NO.12</div>
    <div class="bcf-mode-lbl" data-mode-tag="bcf12_Y112H" style="left:107.65px">확인중</div>

    <div class="bcf-name-lbl" style="left:357.49px">NO.1</div>
    <div class="bcf-mode-lbl" data-mode-tag="bcf1_106" style="left:357.49px">확인중</div>

    <div class="bcf-name-lbl" style="left:607.34px">NO.2</div>
    <div class="bcf-mode-lbl" data-mode-tag="bcf2_106" style="left:607.34px">확인중</div>

    <div class="bcf-name-lbl" style="left:857.18px">NO.3</div>
    <div class="bcf-mode-lbl" data-mode-tag="bcf3_106" style="left:857.18px">확인중</div>

    <div class="bcf-name-lbl" style="left:1107.03px">NO.4</div>
    <div class="bcf-mode-lbl" data-mode-tag="bcf4_106" style="left:1107.03px">확인중</div>

    <div class="bcf-name-lbl" style="left:1356.88px">NO.10</div>
    <div class="bcf-mode-lbl" data-mode-tag="bcf10_133" style="left:1356.88px">확인중</div>

    <div class="bcf-name-lbl" style="left:1606.72px">NO.5</div>
    <div class="bcf-mode-lbl" data-mode-tag="bcf5_108" style="left:1606.72px">확인중</div>

    <!-- 통신 상태 표기 -->
    <div class="bcf-12-conn" style="position:absolute;left:107.65px;top:645.22px;"></div>
    <div class="bcf-1-conn"  style="position:absolute;left:357.49px;top:645.22px;"></div>
    <div class="bcf-2-conn"  style="position:absolute;left:607.34px;top:645.22px;"></div>
    <div class="bcf-3-conn"  style="position:absolute;left:857.18px;top:645.22px;"></div>
    <div class="bcf-4-conn"  style="position:absolute;left:1107.03px;top:645.22px;"></div>
    <div class="bcf-10-conn" style="position:absolute;left:1356.88px;top:645.22px;"></div>
    <div class="bcf-5-conn"  style="position:absolute;left:1606.72px;top:645.22px;"></div>
    <!-- tray-2/belt DT(40004) 표시: bcfX_51(또는 53)=1일 때 conn 위에 표시 -->
    <div class="bcf-belt-dt bcf-1-belt-dt  bcf1_s_40004"></div>
    <div class="bcf-belt-dt bcf-2-belt-dt  bcf2_s_40004"></div>
    <div class="bcf-belt-dt bcf-3-belt-dt  bcf3_s_40002"></div>
    <div class="bcf-belt-dt bcf-4-belt-dt  bcf4_s_40004"></div>
    <div class="bcf-belt-dt bcf-10-belt-dt bcf10_s_40004"></div>
    <div class="bcf-belt-dt bcf-5-belt-dt  bcf5_s_40004"></div>

    <div class="over-view-1">
      <div class="hogi-12">
        <img class="bcf-12" src="<%= ctx %>/img/main_monitor_1/bcf-120.png" />
        <img class="bcf-12-alarm bcf12_Y0E4H" src="<%= ctx %>/img/main_monitor_1/bcf-12-alarm0.png" />
        <img class="bcf-12-belt" src="<%= ctx %>/img/main_monitor_1/bcf-12-belt0.png" />
        <img class="bcf-12-box-on-1" src="<%= ctx %>/img/main_monitor_1/bcf-12-box-on-10.png" />
        <img class="bcf-12-box-off-1" src="<%= ctx %>/img/main_monitor_1/bcf-12-box-off-10.png" />
        <img class="bcf-12-box-on-2" src="<%= ctx %>/img/main_monitor_1/bcf-12-box-on-20.png" />
        <img class="bcf-12-box-off-2" src="<%= ctx %>/img/main_monitor_1/bcf-12-box-off-20.png" />
        <img class="bcf-12-box-on-3" src="<%= ctx %>/img/main_monitor_1/bcf-12-box-on-30.png" />
        <img class="bcf-12-box-off-3" src="<%= ctx %>/img/main_monitor_1/bcf-12-box-off-30.png" />
        <img class="bcf-12-box-on-4" src="<%= ctx %>/img/main_monitor_1/bcf-12-box-on-40.png" />
        <img class="bcf-12-box-off-4" src="<%= ctx %>/img/main_monitor_1/bcf-12-box-off-40.png" />
        <img class="bcf-12-tray-2 bcf12_Y119H" src="<%= ctx %>/img/main_monitor_1/bcf-12-tray-20.png" />
        <img class="bcf-12-tray-1 bcf12_M0925" src="<%= ctx %>/img/main_monitor_1/bcf-12-tray-10.png" />
        <div class="back-12"></div>
        <div class="bcf-12-open-1 bcf12_X097H">열림</div>
        <div class="bcf-12-close-1 bcf12_X097H">닫힘</div>
        <div class="bcf-12-open-2 bcf12_X095H">열림</div>
        <div class="bcf-12-close-2 bcf12_X095H">닫힘</div>
        <div class="bcf-12-open-3 bcf12_X090H">열림</div>
        <div class="bcf-12-close-3 bcf12_X090H">닫힘</div>
        <div class="bcf-12-stop">정지</div>
        <div class="bcf-12-down">하강</div>
        <div class="bcf-12-up bcf12_X092H">상승</div>
        <img class="bcf-12-heat-off" src="<%= ctx %>/img/main_monitor_1/bcf-12-heat-off0.png" />
        <img class="bcf-12-heat-on" src="<%= ctx %>/img/main_monitor_1/bcf-12-heat-on0.png" />
        <img class="bcf-12-obj-off" src="<%= ctx %>/img/main_monitor_1/bcf-12-obj-off0.png" />
        <img class="bcf-12-obj-on" src="<%= ctx %>/img/main_monitor_1/bcf-12-obj-on0.png" />
        <img class="bcf-12-pen-2 bcf12_Y0F4H" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-12-pen-1 bcf12_Y0F4H" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-12-pen-3 bcf12_Y0F4H" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <div class="bcf-12-jogging bcf12_M6824">조깅</div>
        <img class="bcf-12-moter-off" src="<%= ctx %>/img/main_monitor_1/bcf-12-moter-off0.png" />
        <img class="bcf-12-moter-on bcf12_Y0F0H bcf12_Y0F1H" src="<%= ctx %>/img/main_monitor_1/bcf-12-moter-on0.png" />
      </div>
      <div class="hogi-1">
        <img class="bcf-1" src="<%= ctx %>/img/main_monitor_1/bcf-10.png" />
        <img class="bcf-1-alarm bcf1_44" src="<%= ctx %>/img/main_monitor_1/bcf-1-alarm0.png" />
        <img class="bcf-1-belt" src="<%= ctx %>/img/main_monitor_1/bcf-1-belt0.png" />
        <img class="bcf-1-box-on-1" src="<%= ctx %>/img/main_monitor_1/bcf-1-box-on-10.png" />
        <img class="bcf-1-box-off-1" src="<%= ctx %>/img/main_monitor_1/bcf-1-box-off-10.png" />
        <img class="bcf-1-box-on-2" src="<%= ctx %>/img/main_monitor_1/bcf-1-box-on-20.png" />
        <img class="bcf-1-box-off-2" src="<%= ctx %>/img/main_monitor_1/bcf-1-box-off-20.png" />
        <img class="bcf-1-box-on-3" src="<%= ctx %>/img/main_monitor_1/bcf-1-box-on-30.png" />
        <img class="bcf-1-box-off-3" src="<%= ctx %>/img/main_monitor_1/bcf-1-box-off-30.png" />
        <img class="bcf-1-box-on-4" src="<%= ctx %>/img/main_monitor_1/bcf-1-box-on-40.png" />
        <img class="bcf-1-box-off-4" src="<%= ctx %>/img/main_monitor_1/bcf-1-box-off-40.png" />
        <img class="bcf-1-tray-2 bcf1_51" src="<%= ctx %>/img/main_monitor_1/bcf-1-tray-20.png" />
        <img class="bcf-1-tray-1 bcf1_50" src="<%= ctx %>/img/main_monitor_1/bcf-1-tray-10.png" />
        <div class="back-1"></div>
        <div class="bcf-1-open-1 bcf1_8">열림</div>
        <div class="bcf-1-close-1">닫힘</div>
        <div class="bcf-1-open-2 bcf1_2">열림</div>
        <div class="bcf-1-close-2">닫힘</div>
        <div class="bcf-1-stop">정지</div>
        <div class="bcf-1-up">상승</div>
        <div class="bcf-1-down bcf1_3">하강</div>
        <div class="bcf-1-dt bcf1_dt_40060" style="position:absolute;left:420.6px;top:185.22px;"></div>
        <img class="bcf-1-heat-off" src="<%= ctx %>/img/main_monitor_1/bcf-1-heat-off0.png" />
        <img class="bcf-1-heat-on" src="<%= ctx %>/img/main_monitor_1/bcf-1-heat-on0.png" />
        <img class="bcf-1-obj-off" src="<%= ctx %>/img/main_monitor_1/bcf-1-obj-off0.png" />
        <img class="bcf-1-obj-on bcf1_46" src="<%= ctx %>/img/main_monitor_1/bcf-1-obj-on0.png" />
        <img class="bcf-1-pen-2 bcf1_60" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-1-pen-1 bcf1_60" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-1-pen-3 bcf1_22" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <div class="bcf-1-jogging bcf1_56">조깅</div>
        <img class="bcf-1-moter-off" src="<%= ctx %>/img/main_monitor_1/bcf-1-moter-off0.png" />
        <img class="bcf-1-moter-on bcf1_39 bcf1_40" src="<%= ctx %>/img/main_monitor_1/bcf-1-moter-on0.png" />
      </div>
      <div class="hogi-2">
        <img class="bcf-2" src="<%= ctx %>/img/main_monitor_1/bcf-20.png" />
        <img class="bcf-2-alarm bcf2_44" src="<%= ctx %>/img/main_monitor_1/bcf-2-alarm0.png" />
        <img class="bcf-2-belt" src="<%= ctx %>/img/main_monitor_1/bcf-2-belt0.png" />
        <img class="bcf-2-box-on-1" src="<%= ctx %>/img/main_monitor_1/bcf-2-box-on-10.png" />
        <img class="bcf-2-box-off-1" src="<%= ctx %>/img/main_monitor_1/bcf-2-box-off-10.png" />
        <img class="bcf-2-box-on-2" src="<%= ctx %>/img/main_monitor_1/bcf-2-box-on-20.png" />
        <img class="bcf-2-box-off-2" src="<%= ctx %>/img/main_monitor_1/bcf-2-box-off-20.png" />
        <img class="bcf-2-box-on-3" src="<%= ctx %>/img/main_monitor_1/bcf-2-box-on-30.png" />
        <img class="bcf-2-box-off-3" src="<%= ctx %>/img/main_monitor_1/bcf-2-box-off-30.png" />
        <img class="bcf-2-box-on-4" src="<%= ctx %>/img/main_monitor_1/bcf-2-box-on-40.png" />
        <img class="bcf-2-box-off-4" src="<%= ctx %>/img/main_monitor_1/bcf-2-box-off-40.png" />
        <img class="bcf-2-tray-2 bcf2_51" src="<%= ctx %>/img/main_monitor_1/bcf-2-tray-20.png" />
        <img class="bcf-2-tray-1 bcf2_50" src="<%= ctx %>/img/main_monitor_1/bcf-2-tray-10.png" />
        <div class="back-2"></div>
        <div class="bcf-2-open-1 bcf2_8">열림</div>
        <div class="bcf-2-close-1">닫힘</div>
        <div class="bcf-2-open-2 bcf2_2">열림</div>
        <div class="bcf-2-close-2">닫힘</div>
        <div class="bcf-2-stop">정지</div>
        <div class="bcf-2-up">상승</div>
        <div class="bcf-2-down bcf2_3">하강</div>
        <div class="bcf-2-dt bcf2_dt_40060"></div>
        <img class="bcf-2-heat-off" src="<%= ctx %>/img/main_monitor_1/bcf-2-heat-off0.png" />
        <img class="bcf-2-heat-on" src="<%= ctx %>/img/main_monitor_1/bcf-2-heat-on0.png" />
        <img class="bcf-2-obj-off" src="<%= ctx %>/img/main_monitor_1/bcf-2-obj-off0.png" />
        <img class="bcf-2-obj-on bcf2_46" src="<%= ctx %>/img/main_monitor_1/bcf-2-obj-on0.png" />
        <img class="bcf-2-pen-2 bcf2_60" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-2-pen-1 bcf2_60" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-2-pen-3 bcf2_22" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <div class="bcf-2-jogging bcf2_56">조깅</div>
        <img class="bcf-2-moter-off" src="<%= ctx %>/img/main_monitor_1/bcf-2-moter-off0.png" />
        <img class="bcf-2-moter-on bcf2_39 bcf2_40" src="<%= ctx %>/img/main_monitor_1/bcf-2-moter-on0.png" />
      </div>
      <div class="hogi-3">
        <img class="bcf-3" src="<%= ctx %>/img/main_monitor_1/bcf-30.png" />
        <img class="bcf-3-alarm bcf3_44" src="<%= ctx %>/img/main_monitor_1/bcf-3-alarm0.png" />
        <img class="bcf-3-belt" src="<%= ctx %>/img/main_monitor_1/bcf-3-belt0.png" />
        <img class="bcf-3-box-on-1" src="<%= ctx %>/img/main_monitor_1/bcf-3-box-on-10.png" />
        <img class="bcf-3-box-off-1" src="<%= ctx %>/img/main_monitor_1/bcf-3-box-off-10.png" />
        <img class="bcf-3-box-on-2" src="<%= ctx %>/img/main_monitor_1/bcf-3-box-on-20.png" />
        <img class="bcf-3-box-off-2" src="<%= ctx %>/img/main_monitor_1/bcf-3-box-off-20.png" />
        <img class="bcf-3-box-on-3" src="<%= ctx %>/img/main_monitor_1/bcf-3-box-on-30.png" />
        <img class="bcf-3-box-off-3" src="<%= ctx %>/img/main_monitor_1/bcf-3-box-off-30.png" />
        <img class="bcf-3-box-on-4" src="<%= ctx %>/img/main_monitor_1/bcf-3-box-on-40.png" />
        <img class="bcf-3-box-off-4" src="<%= ctx %>/img/main_monitor_1/bcf-3-box-off-40.png" />
        <img class="bcf-3-tray-2 bcf3_51" src="<%= ctx %>/img/main_monitor_1/bcf-3-tray-20.png" />
        <img class="bcf-3-tray-1 bcf3_97" src="<%= ctx %>/img/main_monitor_1/bcf-3-tray-10.png" />
        <div class="back-3"></div>
        <div class="bcf-3-open-1 bcf3_8">열림</div>
        <div class="bcf-3-close-1">닫힘</div>
        <div class="bcf-3-open-2 bcf3_2">열림</div>
        <div class="bcf-3-close-2">닫힘</div>
        <div class="bcf-3-stop">정지</div>
        <div class="bcf-3-up">상승</div>
        <div class="bcf-3-down bcf3_3">하강</div>
        <div class="bcf-3-dt bcf3_dt_40060"></div>
        <img class="bcf-3-heat-off" src="<%= ctx %>/img/main_monitor_1/bcf-3-heat-off0.png" />
        <img class="bcf-3-heat-on" src="<%= ctx %>/img/main_monitor_1/bcf-3-heat-on0.png" />
        <img class="bcf-3-obj-off" src="<%= ctx %>/img/main_monitor_1/bcf-3-obj-off0.png" />
        <img class="bcf-3-obj-on bcf3_46" src="<%= ctx %>/img/main_monitor_1/bcf-3-obj-on0.png" />
        <img class="bcf-3-pen-2 bcf3_60" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-3-pen-1 bcf3_60" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-3-pen-3 bcf3_45" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <div class="bcf-3-jogging bcf3_56">조깅</div>
        <img class="bcf-3-moter-off" src="<%= ctx %>/img/main_monitor_1/bcf-3-moter-off0.png" />
        <img class="bcf-3-moter-on bcf3_39 bcf3_40" src="<%= ctx %>/img/main_monitor_1/bcf-3-moter-on0.png" />
      </div>
      <div class="hogi-4">
        <img class="bcf-4" src="<%= ctx %>/img/main_monitor_1/bcf-40.png" />
        <img class="bcf-4-alarm bcf4_44" src="<%= ctx %>/img/main_monitor_1/bcf-4-alarm0.png" />
        <img class="bcf-4-belt" src="<%= ctx %>/img/main_monitor_1/bcf-4-belt0.png" />
        <img class="bcf-4-box-on-1" src="<%= ctx %>/img/main_monitor_1/bcf-4-box-on-10.png" />
        <img class="bcf-4-box-off-1" src="<%= ctx %>/img/main_monitor_1/bcf-4-box-off-10.png" />
        <img class="bcf-4-box-on-2" src="<%= ctx %>/img/main_monitor_1/bcf-4-box-on-20.png" />
        <img class="bcf-4-box-off-2" src="<%= ctx %>/img/main_monitor_1/bcf-4-box-off-20.png" />
        <img class="bcf-4-box-on-3" src="<%= ctx %>/img/main_monitor_1/bcf-4-box-on-30.png" />
        <img class="bcf-4-box-off-3" src="<%= ctx %>/img/main_monitor_1/bcf-4-box-off-30.png" />
        <img class="bcf-4-box-on-4" src="<%= ctx %>/img/main_monitor_1/bcf-4-box-on-40.png" />
        <img class="bcf-4-box-off-4" src="<%= ctx %>/img/main_monitor_1/bcf-4-box-off-40.png" />
        <img class="bcf-4-tray-2 bcf4_51" src="<%= ctx %>/img/main_monitor_1/bcf-4-tray-20.png" />
        <img class="bcf-4-tray-1 bcf4_50" src="<%= ctx %>/img/main_monitor_1/bcf-4-tray-10.png" />
        <div class="back-4"></div>
        <div class="bcf-4-open-1 bcf4_8">열림</div>
        <div class="bcf-4-close-1">닫힘</div>
        <div class="bcf-4-open-2 bcf4_2">열림</div>
        <div class="bcf-4-close-2">닫힘</div>
        <div class="bcf-4-stop">정지</div>
        <div class="bcf-4-up">상승</div>
        <div class="bcf-4-down bcf4_3">하강</div>
        <div class="bcf-4-dt bcf4_dt_40060"></div>
        <img class="bcf-4-heat-off" src="<%= ctx %>/img/main_monitor_1/bcf-4-heat-off0.png" />
        <img class="bcf-4-heat-on" src="<%= ctx %>/img/main_monitor_1/bcf-4-heat-on0.png" />
        <img class="bcf-4-obj-off" src="<%= ctx %>/img/main_monitor_1/bcf-4-obj-off0.png" />
        <img class="bcf-4-obj-on bcf4_46" src="<%= ctx %>/img/main_monitor_1/bcf-4-obj-on0.png" />
        <img class="bcf-4-pen-2 bcf4_60" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-4-pen-1 bcf4_60" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-4-pen-3 bcf4_45" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <div class="bcf-4-jogging bcf4_56">조깅</div>
        <img class="bcf-4-moter-off" src="<%= ctx %>/img/main_monitor_1/bcf-4-moter-off0.png" />
        <img class="bcf-4-moter-on bcf4_85 bcf4_86" src="<%= ctx %>/img/main_monitor_1/bcf-4-moter-on0.png" />
      </div>
      <div class="hogi-10">
        <img class="bcf-10" src="<%= ctx %>/img/main_monitor_1/bcf-100.png" />
        <img class="bcf-10-alarm bcf10_46" src="<%= ctx %>/img/main_monitor_1/bcf-10-alarm0.png" />
        <img class="bcf-10-belt" src="<%= ctx %>/img/main_monitor_1/bcf-10-belt0.png" />
        <img class="bcf-10-box-on-1" src="<%= ctx %>/img/main_monitor_1/bcf-10-box-on-10.png" />
        <img class="bcf-10-box-off-1" src="<%= ctx %>/img/main_monitor_1/bcf-10-box-off-10.png" />
        <img class="bcf-10-box-on-2" src="<%= ctx %>/img/main_monitor_1/bcf-10-box-on-20.png" />
        <img class="bcf-10-box-off-2" src="<%= ctx %>/img/main_monitor_1/bcf-10-box-off-20.png" />
        <img class="bcf-10-box-on-3" src="<%= ctx %>/img/main_monitor_1/bcf-10-box-on-30.png" />
        <img class="bcf-10-box-off-3" src="<%= ctx %>/img/main_monitor_1/bcf-10-box-off-30.png" />
        <img class="bcf-10-box-on-4" src="<%= ctx %>/img/main_monitor_1/bcf-10-box-on-40.png" />
        <img class="bcf-10-box-off-4" src="<%= ctx %>/img/main_monitor_1/bcf-10-box-off-40.png" />
        <img class="bcf-10-tray-2 bcf10_54" src="<%= ctx %>/img/main_monitor_1/bcf-10-tray-20.png" />
        <img class="bcf-10-tray-1 bcf10_53" src="<%= ctx %>/img/main_monitor_1/bcf-10-tray-10.png" />
        <div class="back-10"></div>
        <div class="bcf-10-open-1 bcf10_8">열림</div>
        <div class="bcf-10-close-1">닫힘</div>
        <div class="bcf-10-open-2 bcf10_2">열림</div>
        <div class="bcf-10-close-2">닫힘</div>
        <div class="bcf-10-stop">정지</div>
        <div class="bcf-10-up">상승</div>
        <div class="bcf-10-down bcf10_52">하강</div>
        <div class="bcf-10-dt bcf10_dt_40060" style="top:187.22px;"></div>
        <img class="bcf-10-heat-off" src="<%= ctx %>/img/main_monitor_1/bcf-10-heat-off0.png" />
        <img class="bcf-10-heat-on" src="<%= ctx %>/img/main_monitor_1/bcf-10-heat-on0.png" />
        <img class="bcf-10-obj-off" src="<%= ctx %>/img/main_monitor_1/bcf-10-obj-off0.png" />
        <img class="bcf-10-obj-on bcf10_49" src="<%= ctx %>/img/main_monitor_1/bcf-10-obj-on0.png" />
        <img class="bcf-10-pen-2 bcf10_62" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-10-pen-1 bcf10_62" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-10-pen-3 bcf10_42" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <div class="bcf-10-jogging bcf10_58">조깅</div>
        <img class="bcf-10-moter-off" src="<%= ctx %>/img/main_monitor_1/bcf-10-moter-off0.png" />
        <img class="bcf-10-moter-on bcf10_38 bcf10_39" src="<%= ctx %>/img/main_monitor_1/bcf-10-moter-on0.png" />
      </div>
      <div class="hogi-5">
        <img class="bcf-5" src="<%= ctx %>/img/main_monitor_1/bcf-50.png" />
        <img class="bcf-5-alarm bcf5_46" src="<%= ctx %>/img/main_monitor_1/bcf-5-alarm0.png" />
        <img class="bcf-5-belt" src="<%= ctx %>/img/main_monitor_1/bcf-5-belt0.png" />
        <img class="bcf-5-box-on-1" src="<%= ctx %>/img/main_monitor_1/bcf-5-box-on-10.png" />
        <img class="bcf-5-box-off-1" src="<%= ctx %>/img/main_monitor_1/bcf-5-box-off-10.png" />
        <img class="bcf-5-box-on-2" src="<%= ctx %>/img/main_monitor_1/bcf-5-box-on-20.png" />
        <img class="bcf-5-box-off-2" src="<%= ctx %>/img/main_monitor_1/bcf-5-box-off-20.png" />
        <img class="bcf-5-box-on-3" src="<%= ctx %>/img/main_monitor_1/bcf-5-box-on-30.png" />
        <img class="bcf-5-box-off-3" src="<%= ctx %>/img/main_monitor_1/bcf-5-box-off-30.png" />
        <img class="bcf-5-box-on-4" src="<%= ctx %>/img/main_monitor_1/bcf-5-box-on-40.png" />
        <img class="bcf-5-box-off-4" src="<%= ctx %>/img/main_monitor_1/bcf-5-box-off-40.png" />
        <img class="bcf-5-tray-2 bcf5_54" src="<%= ctx %>/img/main_monitor_1/bcf-5-tray-20.png" />
        <img class="bcf-5-tray-1 bcf5_53" src="<%= ctx %>/img/main_monitor_1/bcf-5-tray-10.png" />
        <div class="back-5"></div>
        <div class="bcf-5-open-1 bcf5_8">열림</div>
        <div class="bcf-5-close-1">닫힘</div>
        <div class="bcf-5-open-2 bcf5_2">열림</div>
        <div class="bcf-5-close-2">닫힘</div>
        <div class="bcf-5-open-3">열림</div>
        <div class="bcf-5-close-3">닫힘</div>
        <div class="bcf-5-stop">정지</div>
        <div class="bcf-5-up">상승</div>
        <div class="bcf-5-down bcf5_52">하강</div>
        <div class="bcf-5-dt bcf5_dt_40060"></div>
        <img class="bcf-5-heat-off" src="<%= ctx %>/img/main_monitor_1/bcf-5-heat-off0.png" />
        <img class="bcf-5-heat-on" src="<%= ctx %>/img/main_monitor_1/bcf-5-heat-on0.png" />
        <img class="bcf-5-obj-off" src="<%= ctx %>/img/main_monitor_1/bcf-5-obj-off0.png" />
        <img class="bcf-5-obj-on bcf5_49" src="<%= ctx %>/img/main_monitor_1/bcf-5-obj-on0.png" />
        <img class="bcf-5-pen-2 bcf5_62" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-5-pen-1 bcf5_62" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-5-pen-3 bcf5_48" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <div class="bcf-5-jogging bcf5_58">조깅</div>
        <img class="bcf-5-moter-off" src="<%= ctx %>/img/main_monitor_1/bcf-5-moter-off0.png" />
        <img class="bcf-5-moter-on bcf5_38 bcf5_39" src="<%= ctx %>/img/main_monitor_1/bcf-5-moter-on0.png" />
      </div>
    </div>
  </div>

  <!-- ══════════════════════════════════════════
       온도 모니터링 패널 (하단 고정)
  ══════════════════════════════════════════ -->
  <style>
  .tm-panel {
    position: fixed;
    bottom: 0; left: 0; right: 0;
    z-index: 1000;
    background: #ffffff;
    border-top: 1px solid #e2e8f0;
    box-shadow: 0 -4px 20px rgba(0,0,0,0.06);
    padding: 10px 14px 14px;
    box-sizing: border-box;
    font-family: 'Segoe UI', 'Malgun Gothic', sans-serif;
  }
  /* 라벨 + 그룹 7개 → 8컬럼 grid, 가로 꽉 채움 */
  .tm-grid {
    display: grid;
    grid-template-columns: 60px repeat(7, 1fr);
    gap: 6px;
    align-items: stretch;
  }

  /* 좌측 라벨 컬럼 */
  .tm-labels {
    display: flex;
    flex-direction: column;
    gap: 4px;
  }
  .tm-label-spacer { height: 26px; flex-shrink: 0; }
  .tm-label-cell {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 7px;
    text-align: center;
    line-height: 1.4;
  }
  .tm-label-cell .lc-title {
    font-size: 10px;
    font-weight: 700;
    color: #64748b;
    letter-spacing: .4px;
  }
  .tm-label-cell .lc-unit {
    font-size: 11px;
    font-weight: 500;
    color: #94a3b8;
  }

  /* 그룹 카드 */
  .tm-group {
    display: flex;
    flex-direction: column;
    gap: 4px;
    border-radius: 10px;
    padding: 6px 5px 5px;
    border: 1px solid;
  }
  .tm-group.tm-green {
    background: linear-gradient(160deg, #f0fdf4 0%, #f7fef9 100%);
    border-color: #bbf7d0;
    box-shadow: 0 1px 4px rgba(16,185,129,.08);
  }
  .tm-group.tm-blue {
    background: linear-gradient(160deg, #eff6ff 0%, #f5f9ff 100%);
    border-color: #bfdbfe;
    box-shadow: 0 1px 4px rgba(59,130,246,.08);
  }

  /* 채널 헤더 */
  .tm-ch-header {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    gap: 3px;
    height: 26px;
  }
  .tm-ch-name {
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 5px;
    font-size: 10px;
    font-weight: 700;
    letter-spacing: .2px;
  }
  .tm-green .tm-ch-name { background: #dcfce7; color: #15803d; }
  .tm-blue  .tm-ch-name { background: #dbeafe; color: #1d4ed8; }

  /* 값 행 */
  .tm-row {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    gap: 3px;
  }
  .tm-cell {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 34px;
    border-radius: 6px;
    font-size: 13px;
    font-weight: 700;
    letter-spacing: .3px;
    border: 1px solid;
    font-variant-numeric: tabular-nums;
  }
  /* 현재온도 */
  .tm-green .tm-cur .tm-cell { background: #fff; color: #059669; border-color: #a7f3d0; }
  .tm-blue  .tm-cur .tm-cell { background: #fff; color: #2563eb; border-color: #93c5fd; }
  /* 설정온도 */
  .tm-green .tm-set .tm-cell { background: #f0fdf4; color: #16a34a; border-color: #bbf7d0; }
  .tm-blue  .tm-set .tm-cell { background: #eff6ff; color: #3b82f6; border-color: #bfdbfe; }

  /* AUTO 모드: 온도 패널 확장 */
  body.auto-mode .tm-panel        { padding: 14px 14px 20px; }
  body.auto-mode .tm-label-spacer { height: 32px; }
  body.auto-mode .tm-label-cell .lc-title { font-size: 12px; }
  body.auto-mode .tm-label-cell .lc-unit  { font-size: 13px; }
  body.auto-mode .tm-ch-header    { height: 32px; }
  body.auto-mode .tm-ch-name      { font-size: 12px; }
  body.auto-mode .tm-cell         { height: 46px; font-size: 15px; }
  </style>

  <div class="tm-panel">
    <div class="tm-grid">

      <!-- 좌측 라벨 -->
      <div class="tm-labels">
        <div class="tm-label-spacer"></div>
        <div class="tm-label-cell">
          <span class="lc-title">현재온도</span>
          <span class="lc-unit">℃</span>
        </div>
        <div class="tm-label-cell">
          <span class="lc-title">설정온도</span>
          <span class="lc-unit">℃</span>
        </div>
      </div>

      <!-- 침탄12 / 유조12 / CP12 -->
      <div class="tm-group tm-green">
        <div class="tm-ch-header">
          <div class="tm-ch-name">침탄12</div>
          <div class="tm-ch-name">유조12</div>
          <div class="tm-ch-name">CP12</div>
        </div>
        <div class="tm-row tm-cur">
          <div class="tm-cell bcf12_s_D1061">DT</div><div class="tm-cell bcf12_s_D1051">DT</div><div class="tm-cell bcf12_s_D1081">DT</div>
        </div>
        <div class="tm-row tm-set">
          <div class="tm-cell bcf12_s_D1083">DT</div><div class="tm-cell bcf12_s_D1085">DT</div><div class="tm-cell bcf12_s_D1087">DT</div>
        </div>
      </div>

      <!-- 침탄1 / 유조1 / CP1 -->
      <div class="tm-group tm-blue">
        <div class="tm-ch-header">
          <div class="tm-ch-name">침탄1</div>
          <div class="tm-ch-name">유조1</div>
          <div class="tm-ch-name">CP1</div>
        </div>
        <div class="tm-row tm-cur">
          <div class="tm-cell bcf1_s_40046">DT</div><div class="tm-cell bcf1_s_40047">DT</div><div class="tm-cell bcf1_s_40052">DT</div>
        </div>
        <div class="tm-row tm-set">
          <div class="tm-cell bcf1_s_40069">DT</div><div class="tm-cell bcf1_s_40070">DT</div><div class="tm-cell bcf1_s_40071">DT</div>
        </div>
      </div>

      <!-- 침탄2 / 유조2 / CP2 -->
      <div class="tm-group tm-green">
        <div class="tm-ch-header">
          <div class="tm-ch-name">침탄2</div>
          <div class="tm-ch-name">유조2</div>
          <div class="tm-ch-name">CP2</div>
        </div>
        <div class="tm-row tm-cur">
          <div class="tm-cell bcf2_s_40046">DT</div><div class="tm-cell bcf2_s_40047">DT</div><div class="tm-cell bcf2_s_40052">DT</div>
        </div>
        <div class="tm-row tm-set">
          <div class="tm-cell bcf2_s_40069">DT</div><div class="tm-cell bcf2_s_40070">DT</div><div class="tm-cell bcf2_s_40071">DT</div>
        </div>
      </div>

      <!-- 침탄3 / 유조3 / CP3 -->
      <div class="tm-group tm-blue">
        <div class="tm-ch-header">
          <div class="tm-ch-name">침탄3</div>
          <div class="tm-ch-name">유조3</div>
          <div class="tm-ch-name">CP3</div>
        </div>
        <div class="tm-row tm-cur">
          <div class="tm-cell bcf3_s_40046">DT</div><div class="tm-cell bcf3_s_40047">DT</div><div class="tm-cell bcf3_s_40052">DT</div>
        </div>
        <div class="tm-row tm-set">
          <div class="tm-cell bcf3_s_40069">DT</div><div class="tm-cell bcf3_s_40070">DT</div><div class="tm-cell bcf3_s_40071">DT</div>
        </div>
      </div>

      <!-- 침탄4 / 유조4 / CP4 -->
      <div class="tm-group tm-green">
        <div class="tm-ch-header">
          <div class="tm-ch-name">침탄4</div>
          <div class="tm-ch-name">유조4</div>
          <div class="tm-ch-name">CP4</div>
        </div>
        <div class="tm-row tm-cur">
          <div class="tm-cell bcf4_s_40046">DT</div><div class="tm-cell bcf4_s_40047">DT</div><div class="tm-cell bcf4_s_40052">DT</div>
        </div>
        <div class="tm-row tm-set">
          <div class="tm-cell bcf4_s_40069">DT</div><div class="tm-cell bcf4_s_40070">DT</div><div class="tm-cell bcf4_s_40071">DT</div>
        </div>
      </div>

      <!-- 침탄10 / 유조10 / CP10 -->
      <div class="tm-group tm-blue">
        <div class="tm-ch-header">
          <div class="tm-ch-name">침탄10</div>
          <div class="tm-ch-name">유조10</div>
          <div class="tm-ch-name">CP10</div>
        </div>
        <div class="tm-row tm-cur">
          <div class="tm-cell bcf10_s_40046">DT</div><div class="tm-cell bcf10_s_40047">DT</div><div class="tm-cell bcf10_s_40052">DT</div>
        </div>
        <div class="tm-row tm-set">
          <div class="tm-cell bcf10_s_40069">DT</div><div class="tm-cell bcf10_s_40070">DT</div><div class="tm-cell bcf10_s_40071">DT</div>
        </div>
      </div>

      <!-- 침탄5 / 유조5 / CP5 -->
      <div class="tm-group tm-green">
        <div class="tm-ch-header">
          <div class="tm-ch-name">침탄5</div>
          <div class="tm-ch-name">유조5</div>
          <div class="tm-ch-name">CP5</div>
        </div>
        <div class="tm-row tm-cur">
          <div class="tm-cell bcf5_s_40046">DT</div><div class="tm-cell bcf5_s_40047">DT</div><div class="tm-cell bcf5_s_40052">DT</div>
        </div>
        <div class="tm-row tm-set">
          <div class="tm-cell bcf5_s_40069">DT</div><div class="tm-cell bcf5_s_40070">DT</div><div class="tm-cell bcf5_s_40071">DT</div>
        </div>
      </div>

    </div><!-- /tm-grid -->
  </div><!-- /tm-panel -->


<script>
(function () {
  'use strict';
  const ctx = '<%= ctx %>';
  var POLL_INTERVAL = 6000;   // 정상 폴링 주기 (ms)
  var FAIL_COOLDOWN = 12000;  // 통신 실패 후 대기 (ms)

  /* ── 1. DOM에서 bcfN_s_ADDR(온도) / bcfN_ADDR(신호) 클래스 수집 ── */
  const wordElMap = {}; // 'bcf1_s_40045' → [el, ...]
  const bitElMap  = {}; // 'bcf1_60'      → [el, ...]

  document.querySelectorAll('[class]').forEach(function (el) {
    el.className.split(/\s+/).forEach(function (cls) {
      if (/^bcf\d+_s_/.test(cls) || /^bcf\d+_dt_/.test(cls)) {
        if (!wordElMap[cls]) wordElMap[cls] = [];
        wordElMap[cls].push(el);
      } else if (/^bcf\d+_\d+$/.test(cls) || /^bcf12_[XYM][0-9A-Fa-fH]+$/.test(cls)) {
        if (!bitElMap[cls]) bitElMap[cls] = [];
        bitElMap[cls].push(el);
      }
    });
  });

  const allTags = Object.keys(wordElMap).concat(Object.keys(bitElMap));

  // 초기 상태: 비트 요소 모두 숨김 (jogging은 항상 표시, bcf12 open 열림은 visible 유지)
  Object.keys(bitElMap).forEach(function(tag) {
    bitElMap[tag].forEach(function(el) {
      if (el.className.indexOf('-jogging') !== -1) return;
      // BCF12 도어: close 닫힘 div는 초기에 visible (신호=0 → 닫힘 상태)
      if (/\bbcf12_X/.test(tag) && el.className.indexOf('-close-') !== -1) return;
      // BCF12 승강: up 상승 div는 초기에 visible (신호=0 → 상승 상태)
      if (tag === 'bcf12_X092H' && el.className.indexOf('bcf-12-up') !== -1) return;
      el.style.visibility = 'hidden';
    });
  });

  const penEls = Array.prototype.slice.call(document.querySelectorAll('img[class*="-pen-"]'));

  // 조깅 요소 초기 상태: 정지(연빨강) — CSS !important 우선순위 극복을 위해 setProperty 사용
  document.querySelectorAll('div[class*="-jogging"]').forEach(function(el) {
    el.textContent = '정지';
    el.style.setProperty('background', 'linear-gradient(180deg,#fca5a5 0%,#f87171 100%)', 'important');
    el.style.setProperty('color', '#7f1d1d', 'important');
    el.style.fontWeight = '800';
  });

  penEls.forEach(function(el) {
    el.classList.add('pen-rotating');
  });

  function isPenElement(el) {
    return /\b\S*-pen-\S*\b/.test(el.className || '');
  }

  function bitTagsOf(el) {
    return (el.className || '').split(/\s+/).filter(function(cls) {
      return /^bcf\d+_\d+$/.test(cls) || /^bcf12_[XYM][0-9A-Fa-fH]+$/.test(cls);
    });
  }

  /* 운전모드 라벨 (data-mode-tag) → allTags 에 추가 */
  const modeLblEls = document.querySelectorAll('[data-mode-tag]');
  modeLblEls.forEach(function(el) {
    var tag = el.getAttribute('data-mode-tag');
    if (allTags.indexOf(tag) < 0) allTags.push(tag);
  });

  if (!allTags.length) return;

  /* ── 2. PLC 값을 DOM에 반영 ── */
  /* CP 태그: 40052·40071 (BCF1~10), D1081·D1087 (BCF12) */
  var CP_TAG = /_(40052|40071|D1081|D1087)$/;

  function applyData(data) {
    // 온도 ×10 / CP ×0.001 / DT 정수
    Object.keys(wordElMap).forEach(function (tag) {
      if (data[tag] == null) return;
      var raw = Number(data[tag]);
      wordElMap[tag].forEach(function (el) {
        var text;
        if (isNaN(raw)) {
          text = data[tag];
        } else if (CP_TAG.test(tag)) {
          text = (raw * 0.001).toFixed(3);
        } else if (/-dt/.test(el.className)) {
          text = String(Math.round(raw));
        } else {
          text = raw >= 1000 ? (raw / 10).toFixed(1) : raw.toFixed(1);
        }
        el.textContent = text;
      });
    });

    // 신호: 1이면 표시(visible), 0이면 숨김(hidden) — jogging은 별도 처리
    Object.keys(bitElMap).forEach(function (tag) {
      if (data[tag] == null) return;
      var show = (data[tag] === 1 || data[tag] === true);
      bitElMap[tag].forEach(function (el) {
        if (isPenElement(el)) return;
        if (el.className.indexOf('-jogging') !== -1) {
          var jogShow = show;
          el.textContent = jogShow ? '조깅' : '정지';
          if (jogShow) {
            el.style.removeProperty('background');
            el.style.removeProperty('color');
          } else {
            el.style.setProperty('background', 'linear-gradient(180deg,#fca5a5 0%,#f87171 100%)', 'important');
            el.style.setProperty('color', '#7f1d1d', 'important');
          }
          el.style.fontWeight = '800';
          el.style.visibility = 'visible';
          return;
        }
        // BCF12 도어 close 닫힘 div: 신호=0(닫힘)이면 표시, 신호=1(열림)이면 숨김 (반전)
        if (/\bbcf12_X/.test(tag) && el.className.indexOf('-close-') !== -1) {
          el.style.visibility = show ? 'hidden' : 'visible';
          return;
        }
        // BCF12 승강 up 상승 div: 신호=0(상승)이면 표시, 신호=1이면 숨김 (반전)
        if (tag === 'bcf12_X092H' && el.className.indexOf('bcf-12-up') !== -1) {
          el.style.visibility = show ? 'hidden' : 'visible';
          return;
        }
        el.style.visibility = show ? 'visible' : 'hidden';
      });
    });

    // BCF12 승강: X092H=0(상승)이면 bcf-12-down을 뒤로 밀어 상승 텍스트가 보이게
    (function() {
      var downEl = document.querySelector('.bcf-12-down');
      if (downEl) downEl.style.zIndex = (data['bcf12_X092H'] !== 1) ? '-1' : '';
    })();

    // BCF5 open-3: bcf10_2=1이면 앞으로, 0이면 뒤로
    (function() {
      var el = document.querySelector('.bcf-5-open-3');
      if (el) el.style.zIndex = (data['bcf10_2'] === 1) ? '' : '-1';
    })();

    // tray-1 신호=1일 때만 DT 박스 표시
    (function() {
      var trayDtMap = [
        { tray: 'bcf1_50',  dt: '.bcf-1-dt'  },
        { tray: 'bcf2_50',  dt: '.bcf-2-dt'  },
        { tray: 'bcf3_97',  dt: '.bcf-3-dt'  },
        { tray: 'bcf4_50',  dt: '.bcf-4-dt'  },
        { tray: 'bcf5_53',  dt: '.bcf-5-dt'  },
        { tray: 'bcf10_53', dt: '.bcf-10-dt' },
        { tray: 'bcf1_51',  dt: '.bcf-1-belt-dt'  },
        { tray: 'bcf2_51',  dt: '.bcf-2-belt-dt'  },
        { tray: 'bcf3_51',  dt: '.bcf-3-belt-dt'  },
        { tray: 'bcf4_51',  dt: '.bcf-4-belt-dt'  },
        { tray: 'bcf5_52',  dt: '.bcf-5-belt-dt'  },
        { tray: 'bcf10_54', dt: '.bcf-10-belt-dt' },
      ];
      trayDtMap.forEach(function(m) {
        var el = document.querySelector(m.dt);
        if (el) el.style.visibility = (data[m.tray] === 1) ? 'visible' : 'hidden';
      });
    })();

    penEls.forEach(function(el) {
      var tags = bitTagsOf(el);
      var known = tags.filter(function(tag) { return data[tag] != null; });
      var rotate = known.length === 0 || known.some(function(tag) {
        return data[tag] === 1 || data[tag] === true;
      });

      el.classList.toggle('pen-rotating', rotate);
      el.classList.toggle('pen-stopped', !rotate);
      el.style.visibility = 'visible';
    });

    // 운전모드 라벨 업데이트
    modeLblEls.forEach(function(el) {
      var tag = el.getAttribute('data-mode-tag');
      if (data[tag] == null) return;
      var inv    = el.getAttribute('data-mode-inv') === 'true';
      var rawOn  = (data[tag] === 1 || data[tag] === true);
      var isAuto = inv ? !rawOn : rawOn;
      el.textContent       = isAuto ? '자동운전' : '수동운전';
      el.style.background  = isAuto ? 'linear-gradient(160deg,#f0fdf4,#bbf7d0)' : 'linear-gradient(160deg,#fff7ed,#fed7aa)';
      el.style.color       = isAuto ? '#166534' : '#9a3412';
      el.style.borderColor = isAuto ? '#86efac' : '#fdba74';
    });

    // 통신 상태 업데이트 (60초 이내 성공 = 연결)
    var now = Date.now();
    [12,1,2,3,4,10,5].forEach(function(n) {
      var el = document.querySelector('.bcf-' + n + '-conn');
      if (!el) return;
      var ts = data['bcf' + n + '_conn'];
      var ok = typeof ts === 'number' && (now - ts) < 60000;
      el.classList.remove('conn-ok', 'conn-loading');
      el.classList.add(ok ? 'conn-ok' : 'conn-loading');
      el.innerHTML = '<span class="conn-indicator"><span class="breath-sq"></span></span>' + (ok ? '연결' : '연결중');
      el.style.background = '';
      el.style.color = '';
      el.style.borderColor = '';
    });
  }

  /* ── 3. 설비별 통신 로그 ── */
  var BCF_IDS = ['bcf1', 'bcf2', 'bcf3', 'bcf4', 'bcf5', 'bcf10', 'bcf12'];
  var pollCount = 0;

  function logByDevice(data) {
    // pollCount++;
    // var now = new Date().toLocaleTimeString('ko-KR', {hour12: false, hour:'2-digit', minute:'2-digit', second:'2-digit'});
    // console.groupCollapsed('[MON-1] 폴링 #' + pollCount + '  ' + now);
    // ... (전체 주석처리 — BCF12 전용 logBcf12Detail 사용)
    // console.groupEnd();
  }

  /* ── 4. 폴링: 응답 완료 후 다음 요청 예약 (중첩·연속 방지) ── */
  function scheduleNext(delay) {
    setTimeout(fetchData, delay);
  }

  // DT 값 확인 로그 — 처음 3회만 출력 후 자동 중단 (주석처리)
  var dtDbgFired = 0;
  function debugDtOnly(data) {
    if (dtDbgFired >= 3) return;
    dtDbgFired++;
    var dtEls = document.querySelectorAll('[class*="-dt"]');
    // console.group('[DT-DBG] 단품 값 확인 (' + dtDbgFired + '/3)');
    dtEls.forEach(function(el) {
      var sTag = (el.className || '').split(/\s+/).find(function(c) { return /^bcf\d+_s_/.test(c) || /^bcf\d+_dt_/.test(c); });
      if (!sTag) return;
      // console.log(el.className.split(/\s+/)[0] + '  →  ' + sTag + ' = ' + data[sTag]);
    });
    // console.groupEnd();
  }

  /* ── BCF12(12호기) 신호 전용 콘솔 로거 ── */
  var BCF12_SIG_INFO = {
    'bcf12_X097H': { lbl: '도어 닫힘1 (Gate1 Closed)', grp: '도어·게이트' },
    'bcf12_X095H': { lbl: '도어 닫힘2 (Gate2 Closed)', grp: '도어·게이트' },
    'bcf12_X090H': { lbl: '도어 닫힘3 (Gate3 Closed)', grp: '도어·게이트' },
    'bcf12_X092H': { lbl: '상승 (Up)',                         grp: '승강' },
    'bcf12_M0925': { lbl: '트레이1 이송 (Tray1)',              grp: '트레이' },
    'bcf12_Y119H': { lbl: '트레이2 이송 (Y119H|X092H OR)',    grp: '트레이',  also: 'bcf12_X092H' },
    'bcf12_Y0F4H': { lbl: '팬 1/2 회전 (Fan1/2)',             grp: '팬' },
    'bcf12_Y0F8H': { lbl: '팬 3 회전 (Fan3)',                  grp: '팬' },
    'bcf12_M6824': { lbl: '조깅 운전 (Jogging)',               grp: '운전' },
    'bcf12_Y0F0H': { lbl: '모터 A 기동 (Motor-A)',             grp: '모터' },
    'bcf12_Y0F1H': { lbl: '모터 B 기동 (Motor-B)',             grp: '모터' },
    'bcf12_Y112H': { lbl: '자동운전 (Auto)',                   grp: '운전모드' }
  };
  var _bcf12Prev  = {};
  var _bcf12PollN = 0;

  function logBcf12Detail(data) {
    _bcf12PollN++;
    var now  = new Date().toLocaleTimeString('ko-KR', {hour12:false});
    var tags = Object.keys(BCF12_SIG_INFO);

    /* 변화 감지 */
    var changed = tags.filter(function(t) {
      return data[t] != null && data[t] !== _bcf12Prev[t];
    });

    /* console.table 용 행 구성 */
    var rows = {};
    tags.forEach(function(t) {
      var info    = BCF12_SIG_INFO[t];
      var v       = data[t];
      var rawOn   = (v === 1 || v === true);
      /* 반전(inv) / OR 조합(also) 처리 */
      var isOn    = info.inv  ? !rawOn
                  : info.also ? (rawOn || (data[info.also] === 1 || data[info.also] === true))
                  : rawOn;
      /* 이전 유효 상태 */
      var prevRaw    = _bcf12Prev[t];
      var prevRawOn  = (prevRaw === 1 || prevRaw === true);
      var prevOn     = info.inv  ? !prevRawOn
                     : info.also ? (prevRawOn || (_bcf12Prev[info.also] === 1 || _bcf12Prev[info.also] === true))
                     : prevRawOn;
      /* 변화 여부 — also 태그 변화도 포함 */
      var isChg = changed.indexOf(t) !== -1 || (info.also && changed.indexOf(info.also) !== -1);
      rows['[' + info.grp + '] ' + t] = {
        '설명'  : info.lbl,
        '현재값': v == null ? '— null' : (isOn ? '● 1  ON' : '○ 0  OFF'),
        '변화'  : isChg
                   ? (prevRaw == null ? '첫응답'
                   : (prevOn === isOn ? '' : (isOn ? 'ON↑' : 'OFF↓')))
                   : ''
      };
      if (v != null) _bcf12Prev[t] = v;
    });

    var hdr = '[12호기 신호] #' + _bcf12PollN + '  ' + now
            + (changed.length ? '  🔄 변화 ' + changed.length + '개' : '  ─ 변화없음');
    var stHdr = changed.length
      ? 'font-weight:800;font-size:12px;color:#c05621'
      : 'font-weight:600;font-size:11px;color:#2b6cb0';

    console.groupCollapsed('%c' + hdr, stHdr);
    console.table(rows);
    if (changed.length) {
      changed.forEach(function(t) {
        var info   = BCF12_SIG_INFO[t];
        var rawOn  = (data[t] === 1 || data[t] === true);
        var isOn   = info.inv  ? !rawOn
                   : info.also ? (rawOn || (data[info.also] === 1 || data[info.also] === true))
                   : rawOn;
        console.log(
          '%c  ' + t + '  ' + info.lbl + '  →  ' + (isOn ? '● ON (1)' : '○ OFF (0)'),
          isOn ? 'color:#276749;font-weight:700' : 'color:#9b2c2c;font-weight:700'
        );
      });
    }
    console.groupEnd();
  }

  /* ── BCF3(3호기) 트레이 신호 전용 로거 ── */
  var BCF3_TRAY_INFO = {
    'bcf3_98': { lbl: '트레이1 이송 (Tray1)', grp: '트레이' },
    'bcf3_51': { lbl: '트레이2 이송 (Tray2)', grp: '트레이' }
  };
  var _bcf3TrayPrev = {};
  var _bcf3TrayPollN = 0;

  function logBcf3Tray(data) {
    var tags = Object.keys(BCF3_TRAY_INFO);
    var hasData = tags.some(function(t) { return data[t] != null; });
    if (!hasData) return;
    _bcf3TrayPollN++;
    var now = new Date().toLocaleTimeString('ko-KR', {hour12:false});
    var changed = tags.filter(function(t) {
      return data[t] != null && data[t] !== _bcf3TrayPrev[t];
    });
    var rows = {};
    tags.forEach(function(t) {
      var info  = BCF3_TRAY_INFO[t];
      var v     = data[t];
      var isOn  = (v === 1 || v === true);
      var prev  = _bcf3TrayPrev[t];
      var isChg = changed.indexOf(t) !== -1;
      rows['[' + info.grp + '] ' + t] = {
        '설명'  : info.lbl,
        '현재값': v == null ? '— null' : (isOn ? '● 1  ON' : '○ 0  OFF'),
        '변화'  : isChg
                   ? (prev == null ? '첫응답'
                   : (isOn ? 'ON↑' : 'OFF↓'))
                   : ''
      };
      if (v != null) _bcf3TrayPrev[t] = v;
    });
    var hdr = '[3호기 트레이] #' + _bcf3TrayPollN + '  ' + now
            + (changed.length ? '  🔄 변화 ' + changed.length + '개' : '  ─ 변화없음');
    var stHdr = changed.length
      ? 'font-weight:800;font-size:12px;color:#6b21a8'
      : 'font-weight:600;font-size:11px;color:#1e40af';
    console.groupCollapsed('%c' + hdr, stHdr);
    console.table(rows);
    if (changed.length) {
      changed.forEach(function(t) {
        var isOn = (data[t] === 1 || data[t] === true);
        console.log(
          '%c  ' + t + '  ' + BCF3_TRAY_INFO[t].lbl + '  →  ' + (isOn ? '● ON (1)' : '○ OFF (0)'),
          isOn ? 'color:#276749;font-weight:700' : 'color:#9b2c2c;font-weight:700'
        );
      });
    }
    console.groupEnd();
  }

  function fetchData() {
    fetch(ctx + '/monitor/snapshot')
    .then(function (r) { return r.ok ? r.json() : Promise.reject(r.status); })
    .then(function (data) {
      applyData(data);
      // logByDevice(data);
      // debugDtOnly(data);
      logBcf12Detail(data);
      logBcf3Tray(data);
      scheduleNext(POLL_INTERVAL);
    })
    .catch(function (err) {
      // console.warn('[MON-1] PLC fetch 실패:', err);
      scheduleNext(FAIL_COOLDOWN);
    });
  }

  // 페이지 로드 즉시 1회 시작
  fetchData();
})();
// 페이지 로드 시 좌측 메뉴 자동 접기
(function() {
  try {
    var p = window.parent;
    if (p && p !== window) {
      var sb = p.document.getElementById('sidebar');
      if (sb && !sb.classList.contains('collapsed')) sb.classList.add('collapsed');
    }
  } catch(e) {}
})();

/* ── AUTO 슬라이드쇼 ── */
(function() {
  function setBtn(running) {
    var btn = document.getElementById('btnAuto');
    if (!btn) return;
    if (running) { btn.textContent = '■ 종료'; btn.classList.add('running'); }
    else         { btn.textContent = '▶ AUTO'; btn.classList.remove('running'); }
  }

  window.toggleAutoSlideshow = function() {
    try {
      var par = window.parent;
      if (!par || par === window) return;
      if (par._autoRunning) {
        par.stopAutoKiosk();
        setBtn(false);
      } else {
        par.startAutoKiosk();
        setBtn(true);
      }
    } catch(e) {}
  };

  /* 페이지 로드 시 AUTO 실행 중이면 버튼 상태 + 온도 패널 확장 */
  try {
    if (window.parent && window.parent !== window && window.parent._autoRunning) {
      setBtn(true);
      document.body.classList.add('auto-mode');
    }
  } catch(e) {}
})();

/* ── 화면 맞춤 스케일 ── */
(function() {
  var W = 1918, H = 878;
  function scaleToFit() {
    var el = document.querySelector('.group-1');
    if (!el) return;
    var s = Math.min(window.innerWidth / W, window.innerHeight / H);
    el.style.transform       = 'scale(' + s + ')';
    el.style.transformOrigin = 'top left';
  }
  window.addEventListener('resize', scaleToFit);
  scaleToFit();
})();
</script>
</body>
</html>
