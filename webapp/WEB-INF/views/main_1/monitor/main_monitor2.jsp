<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="<%= ctx %>/img/main_monitor_2/vars.css">
  <link rel="stylesheet" href="<%= ctx %>/img/main_monitor_2/style.css">
  
  
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
     height: 26px;
     display: flex; align-items: center; justify-content: center;
     font-size: 13px; font-weight: 900; letter-spacing: .8px;
     background: linear-gradient(160deg, #f8fafc 0%, #eff6ff 100%);
     color: #1d4ed8;
     border: 1px solid #bfdbfe;
     border-radius: 6px 6px 0 0;
     top: 18px; z-index: 200;
     font-family: 'Segoe UI', 'Malgun Gothic', sans-serif;
     box-shadow: 0 1px 4px rgba(59,130,246,.12), inset 0 1px 0 rgba(255,255,255,.85);
     text-shadow: 0 1px 0 rgba(255,255,255,.85);
   }
   .bcf-mode-lbl {
     position: absolute;
     height: 26px;
     display: flex; align-items: center; justify-content: center;
     font-size: 12px; font-weight: 800;
     background: linear-gradient(160deg, #f0fdf4 0%, #dcfce7 100%);
     color: #15803d;
     border: 1px solid #bbf7d0;
     border-top: none;
     border-radius: 0 0 6px 6px;
     top: 44px; z-index: 200;
     font-family: 'Segoe UI', 'Malgun Gothic', sans-serif;
     letter-spacing: .2px;
     transition: background .2s, box-shadow .2s;
     box-shadow: 0 1px 4px rgba(16,185,129,.12), inset 0 1px 0 rgba(255,255,255,.7);
     text-shadow: 0 1px 0 rgba(255,255,255,.7);
   }

   .group-3 [class*="-jogging-"],
   .group-3 [class*="-open-"],
   .group-3 [class*="-close-"],
   .group-3 [class$="-stop"],
   .group-3 [class*="-stop "],
   .group-3 [class$="-up"],
   .group-3 [class*="-up "],
   .group-3 [class$="-down"],
   .group-3 [class*="-down "] {
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

   .group-3 [class*="-jogging-"] {
     background: linear-gradient(180deg, #d9f99d 0%, #86efac 100%) !important;
     color: #14532d !important;
     font-weight: 800 !important;
   }
   .group-3 [class*="-close-"] {
     background: linear-gradient(180deg, #bbf7d0 0%, #22c55e 100%) !important;
     font-size: 11px !important;
   }
   .group-3 [class*="-open-"] {
     color: #fff;
     background: linear-gradient(180deg, #fb7185 0%, #dc2626 100%) !important;
     text-shadow: 0 1px 1px rgba(0,0,0,.35);
   }
   .group-3 [class$="-down"],
   .group-3 [class*="-down "] {
     background: linear-gradient(180deg, #fef08a 0%, #facc15 100%) !important;
   }
   .group-3 [class$="-up"],
   .group-3 [class*="-up "],
   .group-3 [class$="-stop"],
   .group-3 [class*="-stop "] {
     background: linear-gradient(180deg, #e0f2fe 0%, #60a5fa 100%) !important;
   }

   @keyframes penSpinRight {
     from { transform: rotate(0deg); }
     to   { transform: rotate(360deg); }
   }
   .group-3 img[class*="-pen-"] {
     transform-origin: 50% 50%;
     animation: penSpinRight 5.5s linear infinite;
     will-change: transform;
   }
   .group-3 img[class*="-pen-"].pen-rotating {
     animation-play-state: running;
   }
   .group-3 img[class*="-pen-"].pen-stopped {
     animation-play-state: paused;
   }

   .bcf-8-pen-3 { width: 33px; height: 33px; position: absolute; left: 622px; top: 402px; object-fit: cover; aspect-ratio: 1; }
  .bcf-9-pen-3 { width: 33px; height: 33px; position: absolute; left: 868px; top: 402px; object-fit: cover; aspect-ratio: 1; }
  .bcf-7-pen-3 { width: 33px; height: 33px; position: absolute; left: 1114px; top: 402px; object-fit: cover; aspect-ratio: 1; }


  .bcf-7-dt-2 {
    background: #99dfa6;
    border-style: solid;
    border-color: #000000;
    border-width: 1px;
    width: 38px;
    height: 23px;
    position: absolute;
    left: 1112px;
    top: 480px;
}


.bcf-8-dt-2 {
    background: #99dfa6;
    border-style: solid;
    border-color: #000000;
    border-width: 1px;
    width: 38px;
    height: 23px;
    position: absolute;
    left: 620px;
    top: 480px;
}

.bcf-9-dt-2 {
    background: #99dfa6;
    border-style: solid;
    border-color: #000000;
    border-width: 1px;
    width: 38px;
    height: 23px;
    position: absolute;
    left: 866px;
    top: 480px;
}
  /* DT 요소 공통 스타일 */
   .group-2 [class*="-dt-"] {
     background: #e8f5e9 !important;
     border: 1px solid #a5d6a7 !important;
     border-radius: 5px;
     display: flex !important;
     align-items: center;
     justify-content: center;
     font-family: 'Malgun Gothic', 'Segoe UI', Arial, sans-serif;
     font-size: 13px;
     font-weight: 800;
     color: #2e7d32;
     letter-spacing: .3px;
     box-shadow: 0 1px 3px rgba(46,125,50,.12);
   }

   .group-3 img[class*="-alarm"] {
     top: 82px !important;
   }

   /* bcf-8-dt-2 : 이미지 뒤에 가려지는 문제 해결 */
   .group-2 .bcf-8-dt-2 { z-index: 200; }

   .group-3 [class*="-conn"] {
     height: 43px;
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
   .group-3 .conn-ok {
     background: linear-gradient(135deg,rgba(220,252,231,.97) 0%,rgba(187,247,208,.97) 100%) !important;
     border: 1px solid rgba(34,197,94,.45) !important; color: #14532d !important;
     box-shadow: 0 4px 20px rgba(34,197,94,.32), inset 0 1px 0 rgba(255,255,255,.7);
   }
   .group-3 .conn-ok      .breath-sq { animation: breathe-ok   3s ease-in-out infinite; }
   .group-3 .conn-loading {
     background: linear-gradient(135deg,rgba(255,251,235,.97) 0%,rgba(254,249,195,.97) 100%) !important;
     border: 1px solid rgba(245,158,11,.45) !important; color: #78350f !important;
     box-shadow: 0 4px 20px rgba(245,158,11,.28), inset 0 1px 0 rgba(255,255,255,.7);
   }
   .group-3 .conn-loading .breath-sq { animation: breathe-load 1.6s ease-in-out infinite; }
   </style>
  <title>Document</title>
</head>
<body>
  <div class="ov-tab-group">
    <button class="ov-tab" onclick="window.parent.goOverview(1)">OVERVIEW-1</button>
    <button class="ov-tab active">OVERVIEW-2</button>
    <button class="ov-tab ov-tab-auto" id="btnAuto" onclick="toggleAutoSlideshow()">▶ AUTO</button>
  </div>
  <div class="group-3">

    <!-- BCF 명칭 / 운전모드 라벨 -->
    <div class="bcf-name-lbl" style="left:325px;width:152px">NO.11</div>
    <div class="bcf-mode-lbl" data-mode-tag="bcf11_133" style="left:325px;width:152px">확인중</div>

    <div class="bcf-name-lbl" style="left:563px;width:152px">NO.8</div>
    <div class="bcf-mode-lbl" data-mode-tag="bcf8_174" style="left:563px;width:152px">확인중</div>

    <div class="bcf-name-lbl" style="left:809px;width:152px">NO.9</div>
    <div class="bcf-mode-lbl" data-mode-tag="bcf9_264" style="left:809px;width:152px">확인중</div>

    <div class="bcf-name-lbl" style="left:1055px;width:152px">NO.7</div>
    <div class="bcf-mode-lbl" data-mode-tag="bcf7_264" style="left:1055px;width:152px">확인중</div>

    <div class="bcf-name-lbl" style="left:1364px;width:152px">NO.6</div>
    <div class="bcf-mode-lbl" data-mode-tag="bcf6_386" style="left:1364px;width:152px">확인중</div>

    <!-- 통신 상태 표기 -->
    <div class="bcf-11-conn" style="position:absolute;left:325px;top:656px;width:152px;"></div>
    <div class="bcf-8-conn"  style="position:absolute;left:563px;top:656px;width:152px;"></div>
    <div class="bcf-9-conn"  style="position:absolute;left:809px;top:656px;width:152px;"></div>
    <div class="bcf-7-conn"  style="position:absolute;left:1055px;top:656px;width:152px;"></div>
    <div class="bcf-6-conn"  style="position:absolute;left:1568px;top:637px;width:152px;"></div>

    <div class="group-2">
      <div class="bcf-11">
        <img class="bcf-112" src="<%= ctx %>/img/main_monitor_2/bcf-111.png" />
        <img class="bcf-11-alarm bcf11_65" src="<%= ctx %>/img/main_monitor_2/bcf-11-alarm0.png" />
        <img class="bcf-11-obj-off" src="<%= ctx %>/img/main_monitor_2/bcf-11-obj-off0.png" />
        <img class="bcf-11-obj-on" src="<%= ctx %>/img/main_monitor_2/bcf-11-obj-on0.png" />
        <img class="bcf-11-moter-off-1" src="<%= ctx %>/img/main_monitor_2/bcf-11-moter-off-10.png" />
        <img class="bcf-11-moter-on-1 bcf11_56 bcf11_57" src="<%= ctx %>/img/main_monitor_2/bcf-11-moter-on-10.png" />
        <img class="bcf-11-moter-off-12" src="<%= ctx %>/img/main_monitor_2/bcf-11-moter-off-11.png" />
        <img class="bcf-11-moter-on-12 bcf11_79 bcf11_80" src="<%= ctx %>/img/main_monitor_2/bcf-11-moter-on-11.png" />
        <img class="bcf-11-moter-off-13" src="<%= ctx %>/img/main_monitor_2/bcf-11-moter-off-12.png" />
        <img class="bcf-11-moter-on-13 bcf11_83 bcf11_84" src="<%= ctx %>/img/main_monitor_2/bcf-11-moter-on-12.png" />
        <img class="bcf-11-moter-off-14" src="<%= ctx %>/img/main_monitor_2/bcf-11-moter-off-13.png" />
        <img class="bcf-11-moter-on-14 bcf11_60" src="<%= ctx %>/img/main_monitor_2/bcf-11-moter-on-13.png" />
        <img class="bcf-11-moter-off-15" src="<%= ctx %>/img/main_monitor_2/bcf-11-moter-off-14.png" />
        <img class="bcf-11-moter-on-15 bcf11_62" src="<%= ctx %>/img/main_monitor_2/bcf-11-moter-on-14.png" />
        <img class="bcf-11-heat-off-1" src="<%= ctx %>/img/main_monitor_2/bcf-11-heat-off-10.png" />
        <img class="bcf-11-heat-on-1" src="<%= ctx %>/img/main_monitor_2/bcf-11-heat-on-10.png" />
        <img class="bcf-11-heat-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-11-heat-off-20.png" />
        <img class="bcf-11-heat-on-2 bcf11_97" src="<%= ctx %>/img/main_monitor_2/bcf-11-heat-on-20.png" />
        <div class="bcf-11-jogging-1 bcf11_163">조깅</div>
        <div class="bcf-11-jogging-2 bcf11_162">조깅</div>
        <img class="bcf-11-tray-1 bcf11_40008" src="<%= ctx %>/img/main_monitor_2/bcf-11-tray-10.png" />
        <img class="bcf-11-tray-2 bcf11_40010" src="<%= ctx %>/img/main_monitor_2/bcf-11-tray-20.png" />
        <img class="bcf-11-tray-3 bcf11_40027" src="<%= ctx %>/img/main_monitor_2/bcf-11-tray-30.png" />
        <img class="bcf-11-tray-4 bcf11_40044" src="<%= ctx %>/img/main_monitor_2/bcf-11-tray-40.png" />
        <img class="bcf-11-tray-5 bcf11_40053" src="<%= ctx %>/img/main_monitor_2/bcf-11-tray-50.png" />
        <div class="bcf-11-dt-1 bcf11_s_40007"></div>
        <div class="bcf-11-dt-2 bcf11_s_40009"></div>
        <div class="bcf-11-dt-3 bcf11_s_40026"></div>
        <div class="bcf-11-dt-4 bcf11_s_40043"></div>
        <div class="bcf-11-dt-5 bcf11_s_40052"></div>
        <div class="bcf-11-open-1 bcf11_3">열림</div>
        <div class="bcf-11-close-1">닫힘</div>
        <div class="bcf-11-open-2 bcf11_5">열림</div>
        <div class="bcf-11-close-2">닫힘</div>
        <div class="bcf-11-open-3 bcf11_7">열림</div>
        <div class="bcf-11-close-3">닫힘</div>
        <div class="bcf-11-open-4 bcf11_9">열림</div>
        <div class="bcf-11-close-4">닫힘</div>
        <img class="bcf-11-pen-1 bcf11_98" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-11-pen-2 bcf11_100" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-11-pen-3 bcf11_117" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
      </div>
      <div class="bcf-8">
        <img class="bcf-82" src="<%= ctx %>/img/main_monitor_2/bcf-81.png" />
        <img class="bcf-8-alarm bcf8_93" src="<%= ctx %>/img/main_monitor_2/bcf-8-alarm0.png" />
        <img class="bcf-8-moter-off-1" src="<%= ctx %>/img/main_monitor_2/bcf-8-moter-off-10.png" />
        <img class="bcf-8-moter-on-1 bcf8_87 bcf8_88" src="<%= ctx %>/img/main_monitor_2/bcf-8-moter-on-10.png" />
        <img class="bcf-8-moter-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-8-moter-off-20.png" />
        <img class="bcf-8-moter-on-2 bcf8_85 bcf8_86" src="<%= ctx %>/img/main_monitor_2/bcf-8-moter-on-20.png" />
        <img class="bcf-8-heat-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-8-heat-off-20.png" />
        <img class="bcf-8-heat-on-2" src="<%= ctx %>/img/main_monitor_2/bcf-8-heat-on-20.png" />
        <div class="bcf-8-open-1 bcf8_11">열림</div>
        <div class="bcf-8-close-1">닫힘</div>
        <div class="bcf-8-open-2 bcf8_13">열림</div>
        <div class="bcf-8-close-2">닫힘</div>
        <div class="bcf-8-open-3 bcf8_18">열림</div>
        <div class="bcf-8-close-3">닫힘</div>
        <img class="bcf-8-tray-1 bcf8_23" src="<%= ctx %>/img/main_monitor_2/bcf-8-tray-10.png" />
        <img class="bcf-8-tray-2 bcf8_7" src="<%= ctx %>/img/main_monitor_2/bcf-8-tray-20.png" />
        <img class="bcf-8-tray-3 bcf8_116" src="<%= ctx %>/img/main_monitor_2/bcf-8-tray-30.png" />
        <img class="bcf-8-tray-4 bcf8_117" src="<%= ctx %>/img/main_monitor_2/bcf-8-tray-40.png" />
        <img class="bcf-8-tray-5 bcf8_19" src="<%= ctx %>/img/main_monitor_2/bcf-8-tray-50.png" />
        <img class="bcf-8-pen-1 bcf8_113" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-8-pen-2 bcf8_113" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-8-pen-3 bcf8_96" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <div class="bcf-8-dt-1 bcf8_s_40063"></div>
        <div class="bcf-8-dt-2 bcf8_s_40005"></div>
        <img class="bcf-8-box-on-1" src="<%= ctx %>/img/main_monitor_2/bcf-8-box-on-10.png" />
        <img class="bcf-8-box-off-1" src="<%= ctx %>/img/main_monitor_2/bcf-8-box-off-10.png" />
        <img class="bcf-8-box-on-2" src="<%= ctx %>/img/main_monitor_2/bcf-8-box-on-20.png" />
        <img class="bcf-8-box-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-8-box-off-20.png" />
        <img class="bcf-8-box-on-3" src="<%= ctx %>/img/main_monitor_2/bcf-8-box-on-30.png" />
        <img class="bcf-8-box-off-3" src="<%= ctx %>/img/main_monitor_2/bcf-8-box-off-30.png" />
        <img class="bcf-8-box-on-4" src="<%= ctx %>/img/main_monitor_2/bcf-8-box-on-40.png" />
        <img class="bcf-8-box-off-4" src="<%= ctx %>/img/main_monitor_2/bcf-8-box-off-40.png" />
        <div class="bcf-8-stop">정지</div>
        <div class="bcf-8-up bcf8_14">상승</div>
        <div class="bcf-8-down bcf8_15">하강</div>
      </div>
      <div class="bcf-9">
        <img class="bcf-92" src="<%= ctx %>/img/main_monitor_2/bcf-91.png" />
        <img class="bcf-9-alarm bcf9_134" src="<%= ctx %>/img/main_monitor_2/bcf-9-alarm0.png" />
        <img class="bcf-9-moter-off-1" src="<%= ctx %>/img/main_monitor_2/bcf-9-moter-off-10.png" />
        <img class="bcf-9-moter-on-1 bcf9_110 bcf9_111" src="<%= ctx %>/img/main_monitor_2/bcf-9-moter-on-10.png" />
        <img class="bcf-9-moter-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-9-moter-off-20.png" />
        <img class="bcf-9-moter-on-2" src="<%= ctx %>/img/main_monitor_2/bcf-9-moter-on-20.png" />
        <img class="bcf-9-heat-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-9-heat-off-20.png" />
        <img class="bcf-9-heat-on-2" src="<%= ctx %>/img/main_monitor_2/bcf-9-heat-on-20.png" />
        <div class="bcf-9-open-1 bcf9_12">열림</div>
        <div class="bcf-9-close-1">닫힘</div>
        <div class="bcf-9-open-2 bcf9_14">열림</div>
        <div class="bcf-9-close-2">닫힘</div>
        <div class="bcf-9-open-3 bcf9_19">열림</div>
        <div class="bcf-9-close-3">닫힘</div>
        <img class="bcf-9-tray-1 bcf9_2" src="<%= ctx %>/img/main_monitor_2/bcf-9-tray-10.png" />
        <img class="bcf-9-tray-2 bcf9_1" src="<%= ctx %>/img/main_monitor_2/bcf-9-tray-20.png" />
        <img class="bcf-9-tray-3 bcf9_144" src="<%= ctx %>/img/main_monitor_2/bcf-9-tray-30.png" />
        <img class="bcf-9-tray-4 bcf9_145" src="<%= ctx %>/img/main_monitor_2/bcf-9-tray-40.png" />
        <img class="bcf-9-tray-5 bcf9_22" src="<%= ctx %>/img/main_monitor_2/bcf-9-tray-50.png" />
        <img class="bcf-9-pen-1 bcf9_157" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-9-pen-2 bcf9_157" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-9-pen-3 bcf9_155" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <div class="bcf-9-dt-1 bcf9_s_44610"></div>
        <div class="bcf-9-dt-2 bcf9_s_44610"></div>
        <img class="bcf-9-box-on-1" src="<%= ctx %>/img/main_monitor_2/bcf-9-box-on-10.png" />
        <img class="bcf-9-box-off-1" src="<%= ctx %>/img/main_monitor_2/bcf-9-box-off-10.png" />
        <img class="bcf-9-box-on-2" src="<%= ctx %>/img/main_monitor_2/bcf-9-box-on-20.png" />
        <img class="bcf-9-box-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-9-box-off-20.png" />
        <img class="bcf-9-box-on-3" src="<%= ctx %>/img/main_monitor_2/bcf-9-box-on-30.png" />
        <img class="bcf-9-box-off-3" src="<%= ctx %>/img/main_monitor_2/bcf-9-box-off-30.png" />
        <img class="bcf-9-box-on-4" src="<%= ctx %>/img/main_monitor_2/bcf-9-box-on-40.png" />
        <img class="bcf-9-box-off-4" src="<%= ctx %>/img/main_monitor_2/bcf-9-box-off-40.png" />
        <div class="bcf-9-stop">정지</div>
        <div class="bcf-9-up">상승</div>
        <div class="bcf-9-down bcf9_18">하강</div>
      </div>
      <div class="bcf-7">
        <img class="bcf-72" src="<%= ctx %>/img/main_monitor_2/bcf-71.png" />
        <img class="bcf-7-alarm bcf7_40038" src="<%= ctx %>/img/main_monitor_2/bcf-7-alarm0.png" />
        <img class="bcf-7-moter-off-1" src="<%= ctx %>/img/main_monitor_2/bcf-7-moter-off-10.png" />
        <img class="bcf-7-moter-on-1 bcf7_110 bcf7_111" src="<%= ctx %>/img/main_monitor_2/bcf-7-moter-on-10.png" />
        <img class="bcf-7-moter-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-7-moter-off-20.png" />
        <img class="bcf-7-moter-on-2 bcf7_88 bcf7_89" src="<%= ctx %>/img/main_monitor_2/bcf-7-moter-on-20.png" />
        <img class="bcf-7-heat-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-7-heat-off-20.png" />
        <img class="bcf-7-heat-on-2" src="<%= ctx %>/img/main_monitor_2/bcf-7-heat-on-20.png" />
        <div class="bcf-7-open-1 bcf7_12">열림</div>
        <div class="bcf-7-close-1">닫힘</div>
        <div class="bcf-7-open-2 bcf7_14">열림</div>
        <div class="bcf-7-close-2">닫힘</div>
        <div class="bcf-7-open-3 bcf7_19">열림</div>
        <div class="bcf-7-close-3">닫힘</div>
        <img class="bcf-7-tray-1 bcf7_2" src="<%= ctx %>/img/main_monitor_2/bcf-7-tray-10.png" />
        <img class="bcf-7-tray-2 bcf7_1" src="<%= ctx %>/img/main_monitor_2/bcf-7-tray-20.png" />
        <img class="bcf-7-tray-3 bcf7_144" src="<%= ctx %>/img/main_monitor_2/bcf-7-tray-30.png" />
        <img class="bcf-7-tray-4 bcf7_145" src="<%= ctx %>/img/main_monitor_2/bcf-7-tray-40.png" />
        <img class="bcf-7-tray-5 bcf7_22" src="<%= ctx %>/img/main_monitor_2/bcf-7-tray-50.png" />
        <img class="bcf-7-pen-1 bcf7_157" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-7-pen-2 bcf7_157" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-7-pen-3 bcf7_155" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <div class="bcf-7-dt-1 bcf7_s_44610"></div>
        <div class="bcf-7-dt-2 bcf7_s_44610"></div>
        <img class="bcf-7-box-on-1" src="<%= ctx %>/img/main_monitor_2/bcf-7-box-on-10.png" />
        <img class="bcf-7-box-off-1" src="<%= ctx %>/img/main_monitor_2/bcf-7-box-off-10.png" />
        <img class="bcf-7-box-on-2" src="<%= ctx %>/img/main_monitor_2/bcf-7-box-on-20.png" />
        <img class="bcf-7-box-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-7-box-off-20.png" />
        <img class="bcf-7-box-on-3" src="<%= ctx %>/img/main_monitor_2/bcf-7-box-on-30.png" />
        <img class="bcf-7-box-off-3" src="<%= ctx %>/img/main_monitor_2/bcf-7-box-off-30.png" />
        <img class="bcf-7-box-on-4" src="<%= ctx %>/img/main_monitor_2/bcf-7-box-on-40.png" />
        <img class="bcf-7-box-off-4" src="<%= ctx %>/img/main_monitor_2/bcf-7-box-off-40.png" />
        <div class="bcf-7-stop">정지</div>
        <div class="bcf-7-up bcf7_17">상승</div>
        <div class="bcf-7-down bcf7_18">하강</div>
      </div>
      <div class="bcf-6">
        <img class="bcf-62" src="<%= ctx %>/img/main_monitor_2/bcf-61.png" />
        <img class="bcf-6-alarm bcf6_40038" src="<%= ctx %>/img/main_monitor_2/bcf-6-alarm0.png" />
        <div class="bcf-6-back-1"></div>
        <div class="bcf-6-back-2"></div>
        <div class="bcf-6-jogging-1 bcf6_303 bcf6_304">조깅</div>
        <!-- <div class="bcf-6-jogging-2">조깅</div> -->
        <!-- <div class="bcf-6-jogging-3 bcf6_305 bcf6_306">조깅</div> -->
        <div class="bcf-6-jogging-3 bcf6_305 bcf6_306">조깅</div>
        <div class="bcf-6-jogging-4 bcf6_307 bcf6_308">조깅</div>
        <div class="bcf-6-jogging-5 bcf6_309 bcf6_310">조깅</div>
        <div class="bcf-6-jogging-6 bcf6_311 bcf6_312">조깅</div>
        <div class="bcf-6-jogging-7 bcf6_313 bcf6_314">조깅</div>
        <img class="bcf-6-moter-off-1" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-off-10.png" />
        <img class="bcf-6-moter-on-1 bcf6_244 bcf6_245" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-on-10.png" />
        <img class="bcf-6-moter-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-off-20.png" />
        <img class="bcf-6-moter-on-2 bcf6_188" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-on-20.png" />
        <img class="bcf-6-moter-off-3" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-off-30.png" />
        <img class="bcf-6-moter-on-3 bcf6_248 bcf6_249" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-on-30.png" />
        <img class="bcf-6-moter-off-4" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-off-40.png" />
        <img class="bcf-6-moter-on-4 bcf6_252 bcf6_253" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-on-40.png" />
        <img class="bcf-6-moter-off-5" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-off-50.png" />
        <img class="bcf-6-moter-on-5 bcf6_256 bcf6_257" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-on-50.png" />
        <img class="bcf-6-moter-off-6" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-off-60.png" />
        <img class="bcf-6-moter-on-6 bcf6_260 bcf6_261" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-on-60.png" />
        <img class="bcf-6-moter-off-7" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-off-70.png" />
        <img class="bcf-6-moter-on-7 bcf6_264 bcf6_265" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-on-70.png" />
        <img class="bcf-6-tray-1 bcf6_8" src="<%= ctx %>/img/main_monitor_2/bcf-6-tray-10.png" />
        <img class="bcf-6-tray-2 bcf6_291" src="<%= ctx %>/img/main_monitor_2/bcf-6-tray-20.png" />
        <img class="bcf-6-tray-3 bcf6_39" src="<%= ctx %>/img/main_monitor_2/bcf-6-tray-30.png" />
        <img class="bcf-6-tray-4 bcf6_293" src="<%= ctx %>/img/main_monitor_2/bcf-6-tray-40.png" />
        <img class="bcf-6-tray-5 bcf6_294" src="<%= ctx %>/img/main_monitor_2/bcf-6-tray-50.png" />
        <img class="bcf-6-tray-6 bcf6_295" src="<%= ctx %>/img/main_monitor_2/bcf-6-tray-60.png" />
        <img class="bcf-6-tray-7 bcf6_296" src="<%= ctx %>/img/main_monitor_2/bcf-6-tray-70.png" />
        <img class="bcf-6-tray-8 bcf6_297" src="<%= ctx %>/img/main_monitor_2/bcf-6-tray-80.png" />
        <img class="bcf-6-tray-9 bcf6_298" src="<%= ctx %>/img/main_monitor_2/bcf-6-tray-90.png" />
        <img class="bcf-6-tray-10 bcf6_43" src="<%= ctx %>/img/main_monitor_2/bcf-6-tray-100.png" />
        <img class="bcf-6-fire-off-1" src="<%= ctx %>/img/main_monitor_2/bcf-6-fire-off-10.png" />
        <img class="bcf-6-fire-on-1" src="<%= ctx %>/img/main_monitor_2/bcf-6-fire-on-10.png" />
        <img class="bcf-6-fire-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-6-fire-off-20.png" />
        <img class="bcf-6-fire-on-2" src="<%= ctx %>/img/main_monitor_2/bcf-6-fire-on-20.png" />
        <img class="bcf-6-circle-off" src="<%= ctx %>/img/main_monitor_2/bcf-6-circle-off0.png" />
        <img class="bcf-6-circle-on" src="<%= ctx %>/img/main_monitor_2/bcf-6-circle-on0.png" />
        <div class="bcf-6-open-1 bcf6_14">열림</div>
        <div class="bcf-6-close-1">닫힘</div>
        <div class="bcf-6-open-2 bcf6_16">열림</div>
        <div class="bcf-6-close-2">닫힘</div>
        <div class="bcf-6-open-3 bcf6_20">열림</div>
        <div class="bcf-6-close-3">닫힘</div>
        <div class="bcf-6-open-4 bcf6_22">열림</div>
        <div class="bcf-6-close-4">닫힘</div>
        <div class="bcf-6-open-5 bcf6_24">열림</div>
        <div class="bcf-6-close-5">닫힘</div>
        <div class="bcf-6-open-6 bcf6_26">열림</div>
        <div class="bcf-6-close-6">닫힘</div>
        <div class="bcf-6-open-7 bcf6_30">열림</div>
        <div class="bcf-6-close-7">닫힘</div>
        <img class="bcf-6-pen-1 bcf6_224" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-6-pen-2 bcf6_225" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-6-pen-3 bcf6_84" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-6-pen-4 bcf6_226" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-6-pen-5 bcf6_234" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <img class="bcf-6-pen-6 bcf6_234" src="<%= ctx %>/img/main_monitor_1/ffeenn.png" />
        <div class="bcf-6-stop">정지</div>
        <div class="bcf-6-up">상승</div>
        <div class="bcf-6-down bcf6_37">하강</div>
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
  /* 라벨 1개 + 항목 23개 = 24컬럼, 가로 꽉 채움 */
  .tm-grid {
    display: grid;
    grid-template-columns: 60px repeat(23, 1fr);
    gap: 5px;
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

  /* 개별 항목 카드 */
  .tm-item {
    display: flex;
    flex-direction: column;
    gap: 4px;
    border-radius: 10px;
    padding: 5px 4px 5px;
    border: 1px solid;
  }
  .tm-item.tm-green {
    background: linear-gradient(160deg, #f0fdf4 0%, #f7fef9 100%);
    border-color: #bbf7d0;
    box-shadow: 0 1px 4px rgba(16,185,129,.08);
  }
  .tm-item.tm-blue {
    background: linear-gradient(160deg, #eff6ff 0%, #f5f9ff 100%);
    border-color: #bfdbfe;
    box-shadow: 0 1px 4px rgba(59,130,246,.08);
  }

  /* 항목 이름 헤더 */
  .tm-item-name {
    height: 26px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 5px;
    font-size: 10px;
    font-weight: 700;
    letter-spacing: .2px;
    white-space: nowrap;
  }
  .tm-green .tm-item-name { background: #dcfce7; color: #15803d; }
  .tm-blue  .tm-item-name { background: #dbeafe; color: #1d4ed8; }

  /* 값 셀 */
  .tm-cell {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 34px;
    border-radius: 6px;
    font-size: 12px;
    font-weight: 700;
    letter-spacing: .2px;
    border: 1px solid;
    font-variant-numeric: tabular-nums;
  }
  /* 현재온도 */
  .tm-green .tm-cur { background: #fff;     color: #059669; border-color: #a7f3d0; }
  .tm-blue  .tm-cur { background: #fff;     color: #2563eb; border-color: #93c5fd; }
  /* 설정온도 */
  .tm-green .tm-set { background: #f0fdf4;  color: #16a34a; border-color: #bbf7d0; }
  .tm-blue  .tm-set { background: #eff6ff;  color: #3b82f6; border-color: #bfdbfe; }

  /* AUTO 모드: 온도 패널 확장 */
  body.auto-mode .tm-panel        { padding: 14px 14px 20px; }
  body.auto-mode .tm-label-spacer { height: 32px; }
  body.auto-mode .tm-label-cell .lc-title { font-size: 12px; }
  body.auto-mode .tm-label-cell .lc-unit  { font-size: 13px; }
  body.auto-mode .tm-item-name    { height: 32px; font-size: 12px; }
  body.auto-mode .tm-cell         { height: 46px; font-size: 14px; }
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

      <!-- BCF-11 그룹: 초록 -->
      <div class="tm-item tm-green">
        <div class="tm-item-name">1실11</div>
        <div class="tm-cell tm-cur bcf11_s_40077">DT</div>
        <div class="tm-cell tm-set bcf11_s_40001">DT</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">2실11</div>
        <div class="tm-cell tm-cur bcf11_s_40078">DT</div>
        <div class="tm-cell tm-set bcf11_s_40002">DT</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">냉각</div>
        <div class="tm-cell tm-cur bcf11_s_40079">DT</div>
        <div class="tm-cell tm-set bcf11_s_40003">DT</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">1실CP</div>
        <div class="tm-cell tm-cur bcf11_s_40080">0.000</div>
        <div class="tm-cell tm-set bcf11_s_40004">0.000</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">2실CP</div>
        <div class="tm-cell tm-cur bcf11_s_40081">0.000</div>
        <div class="tm-cell tm-set bcf11_s_40005">0.000</div>
      </div>

      <!-- BCF-8 그룹: 파랑 -->
      <div class="tm-item tm-blue">
        <div class="tm-item-name">침탄8</div>
        <div class="tm-cell tm-cur bcf8_s_40049">DT</div>
        <div class="tm-cell tm-set bcf8_s_40072">DT</div>
      </div>
      <div class="tm-item tm-blue">
        <div class="tm-item-name">유조8</div>
        <div class="tm-cell tm-cur bcf8_s_40050">DT</div>
        <div class="tm-cell tm-set bcf8_s_40073">DT</div>
      </div>
      <div class="tm-item tm-blue">
        <div class="tm-item-name">CP8</div>
        <div class="tm-cell tm-cur bcf8_s_40055">0.000</div>
        <div class="tm-cell tm-set bcf8_s_40074">0.000</div>
      </div>

      <!-- BCF-9 그룹: 초록 -->
      <div class="tm-item tm-green">
        <div class="tm-item-name">침탄9</div>
        <div class="tm-cell tm-cur bcf9_s_44611">DT</div>
        <div class="tm-cell tm-set bcf9_s_40003">DT</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">유조9</div>
        <div class="tm-cell tm-cur bcf9_s_44612">DT</div>
        <div class="tm-cell tm-set bcf9_s_40004">DT</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">CP9</div>
        <div class="tm-cell tm-cur bcf9_s_44613">0.000</div>
        <div class="tm-cell tm-set bcf9_s_40007">0.000</div>
      </div>

      <!-- BCF-7 그룹: 파랑 -->
      <div class="tm-item tm-blue">
        <div class="tm-item-name">침탄7</div>
        <div class="tm-cell tm-cur bcf7_s_44611">DT</div>
        <div class="tm-cell tm-set bcf7_s_40003">DT</div>
      </div>
      <div class="tm-item tm-blue">
        <div class="tm-item-name">유조7</div>
        <div class="tm-cell tm-cur bcf7_s_44612">DT</div>
        <div class="tm-cell tm-set bcf7_s_40004">DT</div>
      </div>
      <div class="tm-item tm-blue">
        <div class="tm-item-name">CP7</div>
        <div class="tm-cell tm-cur bcf7_s_44613">0.000</div>
        <div class="tm-cell tm-set bcf7_s_40007">0.000</div>
      </div>


      <!-- BCF-6 그룹: 초록 -->
      <div class="tm-item tm-green">
        <div class="tm-item-name">예열6</div>
        <div class="tm-cell tm-cur bcf6_s_40033">DT</div>
        <div class="tm-cell tm-set bcf6_s_40039">DT</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">가열6</div>
        <div class="tm-cell tm-cur bcf6_s_40034">DT</div>
        <div class="tm-cell tm-set bcf6_s_40040">DT</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">1침탄</div>
        <div class="tm-cell tm-cur bcf6_s_40035">DT</div>
        <div class="tm-cell tm-set bcf6_s_40041">DT</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">2침탄6</div>
        <div class="tm-cell tm-cur bcf6_s_40036">DT</div>
        <div class="tm-cell tm-set bcf6_s_40042">DT</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">강온6</div>
        <div class="tm-cell tm-cur bcf6_s_40037">DT</div>
        <div class="tm-cell tm-set bcf6_s_40043">DT</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">유조</div>
        <div class="tm-cell tm-cur bcf6_s_40038">DT</div>
        <div class="tm-cell tm-set bcf6_s_40044">DT</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">가열CP</div>
        <div class="tm-cell tm-cur bcf6_s_40045">0.000</div>
        <div class="tm-cell tm-set bcf6_s_40048">0.000</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">침탄CP</div>
        <div class="tm-cell tm-cur bcf6_s_40046">0.000</div>
        <div class="tm-cell tm-set bcf6_s_40049">0.000</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">강온CP</div>
        <div class="tm-cell tm-cur">0.000</div>
        <div class="tm-cell tm-set">0.000</div>
      </div>

    </div><!-- /tm-grid -->
  </div><!-- /tm-panel -->


<script>
(function () {
  'use strict';
  const ctx = '<%= ctx %>';
  var POLL_INTERVAL = 6000;   // 정상 폴링 주기 (ms)
  var FAIL_COOLDOWN = 12000;  // 통신 실패 후 대기 (ms)

  const wordElMap = {};
  const bitElMap  = {};

  document.querySelectorAll('[class]').forEach(function (el) {
    el.className.split(/\s+/).forEach(function (cls) {
      if (/^bcf\d+_s_/.test(cls)) {
        if (!wordElMap[cls]) wordElMap[cls] = [];
        wordElMap[cls].push(el);
      } else if (/^bcf\d+_\d+$/.test(cls)) {
        if (!bitElMap[cls]) bitElMap[cls] = [];
        bitElMap[cls].push(el);
      }
    });
  });

  const allTags = Object.keys(wordElMap).concat(Object.keys(bitElMap));

  // 초기 상태: 비트 요소 모두 숨김 (jogging은 항상 표시)
  Object.keys(bitElMap).forEach(function(tag) {
    bitElMap[tag].forEach(function(el) {
      if (el.className.indexOf('-jogging') !== -1) return;
      el.style.visibility = 'hidden';
    });
  });

  // 조깅 요소 초기 상태: 정지(연빨강) — CSS !important 우선순위 극복을 위해 setProperty 사용
  document.querySelectorAll('div[class*="-jogging"]').forEach(function(el) {
    el.textContent = '정지';
    el.style.setProperty('background', 'linear-gradient(180deg,#fca5a5 0%,#f87171 100%)', 'important');
    el.style.setProperty('color', '#7f1d1d', 'important');
    el.style.fontWeight = '800';
  });

  const penEls = Array.prototype.slice.call(document.querySelectorAll('img[class*="-pen-"]'));

  penEls.forEach(function(el) {
    el.classList.add('pen-rotating');
  });

  function isPenElement(el) {
    return /\b\S*-pen-\S*\b/.test(el.className || '');
  }

  function bitTagsOf(el) {
    return (el.className || '').split(/\s+/).filter(function(cls) {
      return /^bcf\d+_\d+$/.test(cls);
    });
  }

  /* 운전모드 라벨 (data-mode-tag) → allTags 에 추가 */
  const modeLblEls = document.querySelectorAll('[data-mode-tag]');
  modeLblEls.forEach(function(el) {
    var tag = el.getAttribute('data-mode-tag');
    if (allTags.indexOf(tag) < 0) allTags.push(tag);
  });

  /* bcf7_143 : HTML 요소 없이 DT 가시성 제어에만 필요 */
  if (allTags.indexOf('bcf7_143') < 0) allTags.push('bcf7_143');

  /* DT 박스 초기 숨김 */
  document.querySelectorAll('.group-2 [class*="-dt-"]').forEach(function(el) {
    el.style.visibility = 'hidden';
  });

  if (!allTags.length) return;

  var CP_TAG  = /_(40052|40071|D1081|D1087)$|bcf6_s_4004[5689]|bcf11_s_(4008[01]|4000[45])|bcf8_s_(40055|40074)|bcf[79]_s_(44613|40007)/;
  // BCF7·BCF9 44613 레지스터: PLC가 실제값의 절반을 저장 → 화면에서 ×2 보정 (×0.001×2 = ×0.002)
  var CP2_TAG = /bcf[79]_s_44613/;

  function applyData(data) {
    // 온도 ×10 / CP ×0.001 / DT 정수
    // CP2_TAG(bcf7·bcf9 _44613): raw×0.002 — PLC 저장값이 실제의 절반이므로 화면에서 ×2 보정
    Object.keys(wordElMap).forEach(function (tag) {
      if (data[tag] == null) return;
      var raw = Number(data[tag]);
      wordElMap[tag].forEach(function (el) {
        var text;
        if (isNaN(raw)) {
          text = data[tag];
        } else if (CP2_TAG.test(tag)) {
          text = (raw * 0.002).toFixed(3);   // ×2 보정: bcf7_s_44613, bcf9_s_44613 전용
        } else if (el.className.indexOf('-dt-') !== -1) {
          text = String(Math.round(raw));
        } else if (CP_TAG.test(tag)) {
          text = (raw * 0.001).toFixed(3);
        } else if (tag === 'bcf7_s_44612') {
          text = ((raw >= 1000 ? raw / 10 : raw) + 8).toFixed(1);
        } else {
          text = raw >= 1000 ? (raw / 10).toFixed(1) : raw.toFixed(1);
        }
        el.textContent = text;
      });
    });

    Object.keys(bitElMap).forEach(function (tag) {
      if (data[tag] == null) return;
      var show = (data[tag] === 1 || data[tag] === true);
      bitElMap[tag].forEach(function (el) {
        if (isPenElement(el)) return;
        if (el.className.indexOf('-jogging') !== -1) {
          var jogTags = bitTagsOf(el);
          var jogShow = jogTags.some(function(t) { return data[t] === 1 || data[t] === true; });
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
        // moter-on 요소: 여러 태그 중 하나라도 1이면 표시 (OR 조건)
        if (el.className.indexOf('-moter-on') !== -1) {
          var motorTags = bitTagsOf(el);
          var motorShow = motorTags.some(function(t) { return data[t] === 1 || data[t] === true; });
          el.style.visibility = motorShow ? 'visible' : 'hidden';
          return;
        }
        el.style.visibility = show ? 'visible' : 'hidden';
      });
    });

    // 코일 신호=1일 때만 해당 DT 박스 표시
    (function() {
      var trayDtMap = [
        /* BCF-11 */
        { tray: 'bcf11_40008', dt: '.bcf-11-dt-1' },
        { tray: 'bcf11_40010', dt: '.bcf-11-dt-2' },
        { tray: 'bcf11_40027', dt: '.bcf-11-dt-3' },
        { tray: 'bcf11_40044', dt: '.bcf-11-dt-4' },
        { tray: 'bcf11_40053', dt: '.bcf-11-dt-5' },
        /* BCF-8 */
        { tray: 'bcf8_116',   dt: '.bcf-8-dt-1' },
        { tray: 'bcf8_15',    dt: '.bcf-8-dt-2' },
        /* BCF-9 */
        { tray: 'bcf9_144',   dt: '.bcf-9-dt-1' },
        { tray: 'bcf9_145',   dt: '.bcf-9-dt-2' },
        /* BCF-7 */
        { tray: 'bcf7_144',   dt: '.bcf-7-dt-1' },
        { tray: 'bcf7_145',   dt: '.bcf-7-dt-2' },
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
      var isAuto = (data[tag] === 1 || data[tag] === true);
      el.textContent       = isAuto ? '자동운전' : '수동운전';
      el.style.background  = isAuto ? 'linear-gradient(160deg,#f0fdf4,#bbf7d0)' : 'linear-gradient(160deg,#fff7ed,#fed7aa)';
      el.style.color       = isAuto ? '#166534' : '#9a3412';
      el.style.borderColor = isAuto ? '#86efac' : '#fdba74';
    });

    // 통신 상태 업데이트 (60초 이내 성공 = 연결)
    var now = Date.now();
    [11,8,9,7,6].forEach(function(n) {
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

  /* ── 설비별 통신 로그 ── */
  var BCF_IDS2 = ['bcf6', 'bcf7', 'bcf8', 'bcf9', 'bcf11'];
  var pollCount2 = 0;

  function logByDevice2(data) {
    pollCount2++;
    var now = new Date().toLocaleTimeString('ko-KR', {hour12: false, hour:'2-digit', minute:'2-digit', second:'2-digit'});
    console.groupCollapsed('[MON-2] 폴링 #' + pollCount2 + '  ' + now);

    BCF_IDS2.forEach(function(id) {
      var prefix = id + '_';
      var wordTags = Object.keys(wordElMap).filter(function(t){ return t.indexOf(prefix) === 0; });
      var bitTags  = Object.keys(bitElMap ).filter(function(t){ return t.indexOf(prefix) === 0; });
      var modeTags = allTags.filter(function(t){
        return t.indexOf(prefix) === 0 && !wordElMap[t] && !bitElMap[t];
      });

      var nullWord = wordTags.filter(function(t){ return data[t] == null; });
      var nullBit  = bitTags .filter(function(t){ return data[t] == null; });
      var hasNull  = nullWord.length + nullBit.length > 0;

      var style = hasNull ? 'color:#e53e3e;font-weight:700' : 'color:#38a169;font-weight:700';
      console.groupCollapsed('%c' + id.toUpperCase()
        + '  워드:' + wordTags.length + '  비트:' + bitTags.length
        + (hasNull ? '  ⚠ 미응답:' + (nullWord.length + nullBit.length) : '  ✓'), style);

      if (wordTags.length) {
        console.group('▶ 워드(온도/CP)');
        wordTags.forEach(function(t) {
          var v = data[t];
          if (v == null) { console.warn('  ' + t + ' → null (미응답)'); }
          else {
            var nv = Number(v);
            var disp = CP2_TAG.test(t) ? (nv*0.002).toFixed(3)+' %' : CP_TAG.test(t) ? (nv*0.001).toFixed(3)+' %' : (nv >= 1000 ? (nv/10).toFixed(1) : nv.toFixed(1))+' ℃';
            console.log('  ' + t + ' → ' + v + '  (' + disp + ')');
          }
        });
        console.groupEnd();
      }

      if (bitTags.length) {
        var onBits      = bitTags.filter(function(t){ return data[t] === 1 || data[t] === true; });
        var nullBitList = bitTags.filter(function(t){ return data[t] == null; });
        console.group('▶ 비트  ON:' + onBits.length + '  OFF:' + (bitTags.length - onBits.length - nullBitList.length) + (nullBitList.length ? '  NULL:'+nullBitList.length : ''));
        if (onBits.length)      console.log('  ON  →', onBits.join(', '));
        if (nullBitList.length) console.warn('  NULL→', nullBitList.join(', '));
        console.groupEnd();
      }

      // 팬(pen) 요소: 태그 값 + 현재 회전/정지 상태
      var bcfPenEls = penEls.filter(function(el) {
        return bitTagsOf(el).some(function(t){ return t.indexOf(prefix) === 0; });
      });
      if (bcfPenEls.length) {
        console.group('▶ 팬  (' + bcfPenEls.length + '개)');
        bcfPenEls.forEach(function(el) {
          var tags = bitTagsOf(el).filter(function(t){ return t.indexOf(prefix) === 0; });
          var rotating = el.classList.contains('pen-rotating');
          var state = rotating ? '▶ 회전중' : '■ 정지';
          tags.forEach(function(t) {
            var v = data[t];
            var vStr = v == null ? '❌ null' : String(v);
            console.log('  ' + t + ' = ' + vStr + '  [' + state + ']');
          });
        });
        console.groupEnd();
      }

      if (modeTags.length) {
        modeTags.forEach(function(t) {
          var v = data[t];
          console.log('  운전모드 ' + t + ' →', v == null ? '❌ null' : (v ? '자동운전' : '수동운전'));
        });
      }

      // BCF6 moter-on 전용 OR 로그
      if (id === 'bcf6') {
        var motorDefs = [
          { name: 'moter-on-1', tags: ['bcf6_244','bcf6_245'] },
          { name: 'moter-on-2', tags: ['bcf6_188'] },
          { name: 'moter-on-3', tags: ['bcf6_248','bcf6_249'] },
          { name: 'moter-on-4', tags: ['bcf6_252','bcf6_253'] },
          { name: 'moter-on-5', tags: ['bcf6_256','bcf6_257'] },
          { name: 'moter-on-6', tags: ['bcf6_260','bcf6_261'] },
          { name: 'moter-on-7', tags: ['bcf6_264','bcf6_265'] },
        ];
        console.group('▶ BCF6 모터 ON/OFF (OR 조건)');
        motorDefs.forEach(function(m) {
          var vals = m.tags.map(function(t){ return t + '=' + (data[t] == null ? '❌null' : data[t]); });
          var orResult = m.tags.some(function(t){ return data[t] === 1 || data[t] === true; });
          console.log('  ' + m.name + '  [' + vals.join(' | ') + ']  → ' + (orResult ? '🟢 ON' : '⚫ OFF'));
        });
        console.groupEnd();
      }

      console.groupEnd();
    });

    console.groupEnd();
  }

  function scheduleNext(delay) {
    setTimeout(fetchData, delay);
  }

  function fetchData() {
    fetch(ctx + '/monitor/snapshot')
    .then(function (r) { return r.ok ? r.json() : Promise.reject(r.status); })
    .then(function (data) {
      applyData(data);
      logByDevice2(data);
      scheduleNext(POLL_INTERVAL);
    })
    .catch(function (err) {
      console.warn('[MON-2] PLC fetch 실패:', err);
      scheduleNext(FAIL_COOLDOWN);
    });
  }

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

  /* 페이지 로드 시 AUTO 실행 중이면 버튼 상태 반영 */
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
    var el = document.querySelector('.group-3');
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
