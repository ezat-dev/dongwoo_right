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
   html, body { height: 100%; overflow: hidden; }
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
   </style>
  <title>Document</title>
</head>
<body>
  <div class="ov-tab-group">
    <button class="ov-tab" onclick="window.parent.goOverview(1)">OVERVIEW-1</button>
    <button class="ov-tab active">OVERVIEW-2</button>
  </div>
  <div class="group-3">
  
    <div class="group-2">
      <div class="bcf-11">
        <img class="bcf-112" src="<%= ctx %>/img/main_monitor_2/bcf-111.png" />
        <img class="bcf-11-alarm" src="<%= ctx %>/img/main_monitor_2/bcf-11-alarm0.png" />
        <img class="bcf-11-obj-off" src="<%= ctx %>/img/main_monitor_2/bcf-11-obj-off0.png" />
        <img class="bcf-11-obj-on" src="<%= ctx %>/img/main_monitor_2/bcf-11-obj-on0.png" />
        <img class="bcf-11-moter-off-1" src="<%= ctx %>/img/main_monitor_2/bcf-11-moter-off-10.png" />
        <img class="bcf-11-moter-on-1" src="<%= ctx %>/img/main_monitor_2/bcf-11-moter-on-10.png" />
        <img class="bcf-11-moter-off-12" src="<%= ctx %>/img/main_monitor_2/bcf-11-moter-off-11.png" />
        <img class="bcf-11-moter-on-12" src="<%= ctx %>/img/main_monitor_2/bcf-11-moter-on-11.png" />
        <img class="bcf-11-moter-off-13" src="<%= ctx %>/img/main_monitor_2/bcf-11-moter-off-12.png" />
        <img class="bcf-11-moter-on-13" src="<%= ctx %>/img/main_monitor_2/bcf-11-moter-on-12.png" />
        <img class="bcf-11-moter-off-14" src="<%= ctx %>/img/main_monitor_2/bcf-11-moter-off-13.png" />
        <img class="bcf-11-moter-on-14" src="<%= ctx %>/img/main_monitor_2/bcf-11-moter-on-13.png" />
        <img class="bcf-11-moter-off-15" src="<%= ctx %>/img/main_monitor_2/bcf-11-moter-off-14.png" />
        <img class="bcf-11-moter-on-15" src="<%= ctx %>/img/main_monitor_2/bcf-11-moter-on-14.png" />
        <img class="bcf-11-heat-off-1" src="<%= ctx %>/img/main_monitor_2/bcf-11-heat-off-10.png" />
        <img class="bcf-11-heat-on-1" src="<%= ctx %>/img/main_monitor_2/bcf-11-heat-on-10.png" />
        <img class="bcf-11-heat-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-11-heat-off-20.png" />
        <img class="bcf-11-heat-on-2" src="<%= ctx %>/img/main_monitor_2/bcf-11-heat-on-20.png" />
        <div class="bcf-11-jogging-1"></div>
        <div class="bcf-11-jogging-2"></div>
        <img class="bcf-11-tray-1" src="<%= ctx %>/img/main_monitor_2/bcf-11-tray-10.png" />
        <img class="bcf-11-tray-2" src="<%= ctx %>/img/main_monitor_2/bcf-11-tray-20.png" />
        <img class="bcf-11-tray-3" src="<%= ctx %>/img/main_monitor_2/bcf-11-tray-30.png" />
        <img class="bcf-11-tray-4" src="<%= ctx %>/img/main_monitor_2/bcf-11-tray-40.png" />
        <img class="bcf-11-tray-5" src="<%= ctx %>/img/main_monitor_2/bcf-11-tray-50.png" />
        <div class="bcf-11-dt-1"></div>
        <div class="bcf-11-dt-2"></div>
        <div class="bcf-11-dt-3"></div>
        <div class="bcf-11-dt-4"></div>
        <div class="bcf-11-dt-5"></div>
        <div class="bcf-11-open-1"></div>
        <div class="bcf-11-close-1"></div>
        <div class="bcf-11-open-2"></div>
        <div class="bcf-11-close-2"></div>
        <div class="bcf-11-open-3"></div>
        <div class="bcf-11-close-3"></div>
        <div class="bcf-11-open-4"></div>
        <div class="bcf-11-close-4"></div>
        <img class="bcf-11-pen-1" src="<%= ctx %>/img/main_monitor_2/bcf-11-pen-10.png" />
        <img class="bcf-11-pen-2" src="<%= ctx %>/img/main_monitor_2/bcf-11-pen-20.png" />
        <img class="bcf-11-pen-3" src="<%= ctx %>/img/main_monitor_2/bcf-11-pen-30.png" />
      </div>
      <div class="bcf-8">
        <img class="bcf-82" src="<%= ctx %>/img/main_monitor_2/bcf-81.png" />
        <img class="bcf-8-alarm" src="<%= ctx %>/img/main_monitor_2/bcf-8-alarm0.png" />
        <img class="bcf-8-moter-off-1" src="<%= ctx %>/img/main_monitor_2/bcf-8-moter-off-10.png" />
        <img class="bcf-8-moter-on-1" src="<%= ctx %>/img/main_monitor_2/bcf-8-moter-on-10.png" />
        <img class="bcf-8-moter-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-8-moter-off-20.png" />
        <img class="bcf-8-moter-on-2" src="<%= ctx %>/img/main_monitor_2/bcf-8-moter-on-20.png" />
        <img class="bcf-8-heat-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-8-heat-off-20.png" />
        <img class="bcf-8-heat-on-2" src="<%= ctx %>/img/main_monitor_2/bcf-8-heat-on-20.png" />
        <div class="bcf-8-open-1"></div>
        <div class="bcf-8-close-1"></div>
        <div class="bcf-8-open-2"></div>
        <div class="bcf-8-close-2"></div>
        <div class="bcf-8-open-3"></div>
        <div class="bcf-8-close-3"></div>
        <img class="bcf-8-tray-1" src="<%= ctx %>/img/main_monitor_2/bcf-8-tray-10.png" />
        <img class="bcf-8-tray-2" src="<%= ctx %>/img/main_monitor_2/bcf-8-tray-20.png" />
        <img class="bcf-8-tray-3" src="<%= ctx %>/img/main_monitor_2/bcf-8-tray-30.png" />
        <img class="bcf-8-tray-4" src="<%= ctx %>/img/main_monitor_2/bcf-8-tray-40.png" />
        <img class="bcf-8-tray-5" src="<%= ctx %>/img/main_monitor_2/bcf-8-tray-50.png" />
        <img class="bcf-8-pen-1" src="<%= ctx %>/img/main_monitor_2/bcf-8-pen-10.png" />
        <img class="bcf-8-pen-2" src="<%= ctx %>/img/main_monitor_2/bcf-8-pen-20.png" />
        <div class="bcf-8-dt-1"></div>
        <div class="bcf-8-dt-2"></div>
        <img class="bcf-8-box-on-1" src="<%= ctx %>/img/main_monitor_2/bcf-8-box-on-10.png" />
        <img class="bcf-8-box-off-1" src="<%= ctx %>/img/main_monitor_2/bcf-8-box-off-10.png" />
        <img class="bcf-8-box-on-2" src="<%= ctx %>/img/main_monitor_2/bcf-8-box-on-20.png" />
        <img class="bcf-8-box-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-8-box-off-20.png" />
        <img class="bcf-8-box-on-3" src="<%= ctx %>/img/main_monitor_2/bcf-8-box-on-30.png" />
        <img class="bcf-8-box-off-3" src="<%= ctx %>/img/main_monitor_2/bcf-8-box-off-30.png" />
        <img class="bcf-8-box-on-4" src="<%= ctx %>/img/main_monitor_2/bcf-8-box-on-40.png" />
        <img class="bcf-8-box-off-4" src="<%= ctx %>/img/main_monitor_2/bcf-8-box-off-40.png" />
        <div class="bcf-8-stop"></div>
        <div class="bcf-8-up"></div>
        <div class="bcf-8-down"></div>
      </div>
      <div class="bcf-9">
        <img class="bcf-92" src="<%= ctx %>/img/main_monitor_2/bcf-91.png" />
        <img class="bcf-9-alarm" src="<%= ctx %>/img/main_monitor_2/bcf-9-alarm0.png" />
        <img class="bcf-9-moter-off-1" src="<%= ctx %>/img/main_monitor_2/bcf-9-moter-off-10.png" />
        <img class="bcf-9-moter-on-1" src="<%= ctx %>/img/main_monitor_2/bcf-9-moter-on-10.png" />
        <img class="bcf-9-moter-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-9-moter-off-20.png" />
        <img class="bcf-9-moter-on-2" src="<%= ctx %>/img/main_monitor_2/bcf-9-moter-on-20.png" />
        <img class="bcf-9-heat-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-9-heat-off-20.png" />
        <img class="bcf-9-heat-on-2" src="<%= ctx %>/img/main_monitor_2/bcf-9-heat-on-20.png" />
        <div class="bcf-9-open-1"></div>
        <div class="bcf-9-close-1"></div>
        <div class="bcf-9-open-2"></div>
        <div class="bcf-9-close-2"></div>
        <div class="bcf-9-open-3"></div>
        <div class="bcf-9-close-3"></div>
        <img class="bcf-9-tray-1" src="<%= ctx %>/img/main_monitor_2/bcf-9-tray-10.png" />
        <img class="bcf-9-tray-2" src="<%= ctx %>/img/main_monitor_2/bcf-9-tray-20.png" />
        <img class="bcf-9-tray-3" src="<%= ctx %>/img/main_monitor_2/bcf-9-tray-30.png" />
        <img class="bcf-9-tray-4" src="<%= ctx %>/img/main_monitor_2/bcf-9-tray-40.png" />
        <img class="bcf-9-tray-5" src="<%= ctx %>/img/main_monitor_2/bcf-9-tray-50.png" />
        <img class="bcf-9-pen-1" src="<%= ctx %>/img/main_monitor_2/bcf-9-pen-10.png" />
        <img class="bcf-9-pen-2" src="<%= ctx %>/img/main_monitor_2/bcf-9-pen-20.png" />
        <div class="bcf-9-dt-1"></div>
        <div class="bcf-9-dt-2"></div>
        <img class="bcf-9-box-on-1" src="<%= ctx %>/img/main_monitor_2/bcf-9-box-on-10.png" />
        <img class="bcf-9-box-off-1" src="<%= ctx %>/img/main_monitor_2/bcf-9-box-off-10.png" />
        <img class="bcf-9-box-on-2" src="<%= ctx %>/img/main_monitor_2/bcf-9-box-on-20.png" />
        <img class="bcf-9-box-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-9-box-off-20.png" />
        <img class="bcf-9-box-on-3" src="<%= ctx %>/img/main_monitor_2/bcf-9-box-on-30.png" />
        <img class="bcf-9-box-off-3" src="<%= ctx %>/img/main_monitor_2/bcf-9-box-off-30.png" />
        <img class="bcf-9-box-on-4" src="<%= ctx %>/img/main_monitor_2/bcf-9-box-on-40.png" />
        <img class="bcf-9-box-off-4" src="<%= ctx %>/img/main_monitor_2/bcf-9-box-off-40.png" />
        <div class="bcf-9-stop"></div>
        <div class="bcf-9-up"></div>
        <div class="bcf-9-down"></div>
      </div>
      <div class="bcf-7">
        <img class="bcf-72" src="<%= ctx %>/img/main_monitor_2/bcf-71.png" />
        <img class="bcf-7-alarm" src="<%= ctx %>/img/main_monitor_2/bcf-7-alarm0.png" />
        <img class="bcf-7-moter-off-1" src="<%= ctx %>/img/main_monitor_2/bcf-7-moter-off-10.png" />
        <img class="bcf-7-moter-on-1" src="<%= ctx %>/img/main_monitor_2/bcf-7-moter-on-10.png" />
        <img class="bcf-7-moter-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-7-moter-off-20.png" />
        <img class="bcf-7-moter-on-2" src="<%= ctx %>/img/main_monitor_2/bcf-7-moter-on-20.png" />
        <img class="bcf-7-heat-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-7-heat-off-20.png" />
        <img class="bcf-7-heat-on-2" src="<%= ctx %>/img/main_monitor_2/bcf-7-heat-on-20.png" />
        <div class="bcf-7-open-1"></div>
        <div class="bcf-7-close-1"></div>
        <div class="bcf-7-open-2"></div>
        <div class="bcf-7-close-2"></div>
        <div class="bcf-7-open-3"></div>
        <div class="bcf-7-close-3"></div>
        <img class="bcf-7-tray-1" src="<%= ctx %>/img/main_monitor_2/bcf-7-tray-10.png" />
        <img class="bcf-7-tray-2" src="<%= ctx %>/img/main_monitor_2/bcf-7-tray-20.png" />
        <img class="bcf-7-tray-3" src="<%= ctx %>/img/main_monitor_2/bcf-7-tray-30.png" />
        <img class="bcf-7-tray-4" src="<%= ctx %>/img/main_monitor_2/bcf-7-tray-40.png" />
        <img class="bcf-7-tray-5" src="<%= ctx %>/img/main_monitor_2/bcf-7-tray-50.png" />
        <img class="bcf-7-pen-1" src="<%= ctx %>/img/main_monitor_2/bcf-7-pen-10.png" />
        <img class="bcf-7-pen-2" src="<%= ctx %>/img/main_monitor_2/bcf-7-pen-20.png" />
        <div class="bcf-7-dt-1"></div>
        <div class="bcf-7-dt-2"></div>
        <img class="bcf-7-box-on-1" src="<%= ctx %>/img/main_monitor_2/bcf-7-box-on-10.png" />
        <img class="bcf-7-box-off-1" src="<%= ctx %>/img/main_monitor_2/bcf-7-box-off-10.png" />
        <img class="bcf-7-box-on-2" src="<%= ctx %>/img/main_monitor_2/bcf-7-box-on-20.png" />
        <img class="bcf-7-box-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-7-box-off-20.png" />
        <img class="bcf-7-box-on-3" src="<%= ctx %>/img/main_monitor_2/bcf-7-box-on-30.png" />
        <img class="bcf-7-box-off-3" src="<%= ctx %>/img/main_monitor_2/bcf-7-box-off-30.png" />
        <img class="bcf-7-box-on-4" src="<%= ctx %>/img/main_monitor_2/bcf-7-box-on-40.png" />
        <img class="bcf-7-box-off-4" src="<%= ctx %>/img/main_monitor_2/bcf-7-box-off-40.png" />
        <div class="bcf-7-stop"></div>
        <div class="bcf-7-up"></div>
        <div class="bcf-7-down"></div>
      </div>
      <div class="bcf-6">
        <img class="bcf-62" src="<%= ctx %>/img/main_monitor_2/bcf-61.png" />
        <img class="bcf-6-alarm" src="<%= ctx %>/img/main_monitor_2/bcf-6-alarm0.png" />
        <div class="bcf-6-back-1"></div>
        <div class="bcf-6-back-2"></div>
        <div class="bcf-6-jogging-1"></div>
        <div class="bcf-6-jogging-2"></div>
        <div class="bcf-6-jogging-3"></div>
        <div class="bcf-6-jogging-4"></div>
        <div class="bcf-6-jogging-5"></div>
        <div class="bcf-6-jogging-6"></div>
        <div class="bcf-6-jogging-7"></div>
        <img class="bcf-6-moter-off-1" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-off-10.png" />
        <img class="bcf-6-moter-on-1" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-on-10.png" />
        <img class="bcf-6-moter-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-off-20.png" />
        <img class="bcf-6-moter-on-2" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-on-20.png" />
        <img class="bcf-6-moter-off-3" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-off-30.png" />
        <img class="bcf-6-moter-on-3" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-on-30.png" />
        <img class="bcf-6-moter-off-4" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-off-40.png" />
        <img class="bcf-6-moter-on-4" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-on-40.png" />
        <img class="bcf-6-moter-off-5" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-off-50.png" />
        <img class="bcf-6-moter-on-5" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-on-50.png" />
        <img class="bcf-6-moter-off-6" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-off-60.png" />
        <img class="bcf-6-moter-on-6" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-on-60.png" />
        <img class="bcf-6-moter-off-7" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-off-70.png" />
        <img class="bcf-6-moter-on-7" src="<%= ctx %>/img/main_monitor_2/bcf-6-moter-on-70.png" />
        <img class="bcf-6-tray-1" src="<%= ctx %>/img/main_monitor_2/bcf-6-tray-10.png" />
        <img class="bcf-6-tray-2" src="<%= ctx %>/img/main_monitor_2/bcf-6-tray-20.png" />
        <img class="bcf-6-tray-3" src="<%= ctx %>/img/main_monitor_2/bcf-6-tray-30.png" />
        <img class="bcf-6-tray-4" src="<%= ctx %>/img/main_monitor_2/bcf-6-tray-40.png" />
        <img class="bcf-6-tray-5" src="<%= ctx %>/img/main_monitor_2/bcf-6-tray-50.png" />
        <img class="bcf-6-tray-6" src="<%= ctx %>/img/main_monitor_2/bcf-6-tray-60.png" />
        <img class="bcf-6-tray-7" src="<%= ctx %>/img/main_monitor_2/bcf-6-tray-70.png" />
        <img class="bcf-6-tray-8" src="<%= ctx %>/img/main_monitor_2/bcf-6-tray-80.png" />
        <img class="bcf-6-tray-9" src="<%= ctx %>/img/main_monitor_2/bcf-6-tray-90.png" />
        <img class="bcf-6-tray-10" src="<%= ctx %>/img/main_monitor_2/bcf-6-tray-100.png" />
        <img class="bcf-6-fire-off-1" src="<%= ctx %>/img/main_monitor_2/bcf-6-fire-off-10.png" />
        <img class="bcf-6-fire-on-1" src="<%= ctx %>/img/main_monitor_2/bcf-6-fire-on-10.png" />
        <img class="bcf-6-fire-off-2" src="<%= ctx %>/img/main_monitor_2/bcf-6-fire-off-20.png" />
        <img class="bcf-6-fire-on-2" src="<%= ctx %>/img/main_monitor_2/bcf-6-fire-on-20.png" />
        <img class="bcf-6-circle-off" src="<%= ctx %>/img/main_monitor_2/bcf-6-circle-off0.png" />
        <img class="bcf-6-circle-on" src="<%= ctx %>/img/main_monitor_2/bcf-6-circle-on0.png" />
        <div class="bcf-6-open-1"></div>
        <div class="bcf-6-close-1"></div>
        <div class="bcf-6-open-2"></div>
        <div class="bcf-6-close-2"></div>
        <div class="bcf-6-open-3"></div>
        <div class="bcf-6-close-3"></div>
        <div class="bcf-6-open-4"></div>
        <div class="bcf-6-close-4"></div>
        <div class="bcf-6-open-5"></div>
        <div class="bcf-6-close-5"></div>
        <div class="bcf-6-open-6"></div>
        <div class="bcf-6-close-6"></div>
        <div class="bcf-6-open-7"></div>
        <div class="bcf-6-close-7"></div>
        <img class="bcf-6-pen-1" src="<%= ctx %>/img/main_monitor_2/bcf-6-pen-10.png" />
        <img class="bcf-6-pen-2" src="<%= ctx %>/img/main_monitor_2/bcf-6-pen-20.png" />
        <img class="bcf-6-pen-3" src="<%= ctx %>/img/main_monitor_2/bcf-6-pen-30.png" />
        <img class="bcf-6-pen-4" src="<%= ctx %>/img/main_monitor_2/bcf-6-pen-40.png" />
        <img class="bcf-6-pen-5" src="<%= ctx %>/img/main_monitor_2/bcf-6-pen-50.png" />
        <img class="bcf-6-pen-6" src="<%= ctx %>/img/main_monitor_2/bcf-6-pen-60.png" />
        <div class="bcf-6-stop"></div>
        <div class="bcf-6-up"></div>
        <div class="bcf-6-down"></div>
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
        <div class="tm-cell tm-cur">DT</div>
        <div class="tm-cell tm-set">DT</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">2실11</div>
        <div class="tm-cell tm-cur">DT</div>
        <div class="tm-cell tm-set">DT</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">냉각</div>
        <div class="tm-cell tm-cur">DT</div>
        <div class="tm-cell tm-set">DT</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">1실CP</div>
        <div class="tm-cell tm-cur">0.000</div>
        <div class="tm-cell tm-set">0.000</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">2실CP</div>
        <div class="tm-cell tm-cur">0.000</div>
        <div class="tm-cell tm-set">0.000</div>
      </div>

      <!-- BCF-8 그룹: 파랑 -->
      <div class="tm-item tm-blue">
        <div class="tm-item-name">침탄8</div>
        <div class="tm-cell tm-cur">DT</div>
        <div class="tm-cell tm-set">DT</div>
      </div>
      <div class="tm-item tm-blue">
        <div class="tm-item-name">유조8</div>
        <div class="tm-cell tm-cur">DT</div>
        <div class="tm-cell tm-set">DT</div>
      </div>
      <div class="tm-item tm-blue">
        <div class="tm-item-name">CP8</div>
        <div class="tm-cell tm-cur">0.000</div>
        <div class="tm-cell tm-set">0.000</div>
      </div>

      <!-- BCF-9 그룹: 초록 -->
      <div class="tm-item tm-green">
        <div class="tm-item-name">침탄9</div>
        <div class="tm-cell tm-cur">DT</div>
        <div class="tm-cell tm-set">DT</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">유조9</div>
        <div class="tm-cell tm-cur">DT</div>
        <div class="tm-cell tm-set">DT</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">CP9</div>
        <div class="tm-cell tm-cur">0.000</div>
        <div class="tm-cell tm-set">0.000</div>
      </div>

      <!-- BCF-7 그룹: 파랑 -->
      <div class="tm-item tm-blue">
        <div class="tm-item-name">침탄7</div>
        <div class="tm-cell tm-cur">DT</div>
        <div class="tm-cell tm-set">DT</div>
      </div>
      <div class="tm-item tm-blue">
        <div class="tm-item-name">유조7</div>
        <div class="tm-cell tm-cur">DT</div>
        <div class="tm-cell tm-set">DT</div>
      </div>
      <div class="tm-item tm-blue">
        <div class="tm-item-name">CP7</div>
        <div class="tm-cell tm-cur">0.000</div>
        <div class="tm-cell tm-set">0.000</div>
      </div>

      <!-- BCF-6 그룹: 초록 -->
      <div class="tm-item tm-green">
        <div class="tm-item-name">예열6</div>
        <div class="tm-cell tm-cur">DT</div>
        <div class="tm-cell tm-set">DT</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">가열6</div>
        <div class="tm-cell tm-cur">DT</div>
        <div class="tm-cell tm-set">DT</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">1침탄</div>
        <div class="tm-cell tm-cur">DT</div>
        <div class="tm-cell tm-set">DT</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">2침탄6</div>
        <div class="tm-cell tm-cur">DT</div>
        <div class="tm-cell tm-set">DT</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">강온6</div>
        <div class="tm-cell tm-cur">DT</div>
        <div class="tm-cell tm-set">DT</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">유조</div>
        <div class="tm-cell tm-cur">DT</div>
        <div class="tm-cell tm-set">DT</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">가열CP</div>
        <div class="tm-cell tm-cur">0.000</div>
        <div class="tm-cell tm-set">0.000</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">침탄CP</div>
        <div class="tm-cell tm-cur">0.000</div>
        <div class="tm-cell tm-set">0.000</div>
      </div>
      <div class="tm-item tm-green">
        <div class="tm-item-name">강온CP</div>
        <div class="tm-cell tm-cur">0.000</div>
        <div class="tm-cell tm-set">0.000</div>
      </div>

    </div><!-- /tm-grid -->
  </div><!-- /tm-panel -->

</body>
</html>