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
    <button class="ov-tab active">OVERVIEW-1</button>
    <button class="ov-tab" onclick="window.parent.goOverview(2)">OVERVIEW-2</button>
  </div>
  <div class="group-1">

    <div class="over-view-1">
      <div class="hogi-12">
        <img class="bcf-12" src="<%= ctx %>/img/main_monitor_1/bcf-120.png" />
        <img class="bcf-12-alarm" src="<%= ctx %>/img/main_monitor_1/bcf-12-alarm0.png" />
        <img class="bcf-12-belt" src="<%= ctx %>/img/main_monitor_1/bcf-12-belt0.png" />
        <img class="bcf-12-box-on-1" src="<%= ctx %>/img/main_monitor_1/bcf-12-box-on-10.png" />
        <img class="bcf-12-box-off-1" src="<%= ctx %>/img/main_monitor_1/bcf-12-box-off-10.png" />
        <img class="bcf-12-box-on-2" src="<%= ctx %>/img/main_monitor_1/bcf-12-box-on-20.png" />
        <img class="bcf-12-box-off-2" src="<%= ctx %>/img/main_monitor_1/bcf-12-box-off-20.png" />
        <img class="bcf-12-box-on-3" src="<%= ctx %>/img/main_monitor_1/bcf-12-box-on-30.png" />
        <img class="bcf-12-box-off-3" src="<%= ctx %>/img/main_monitor_1/bcf-12-box-off-30.png" />
        <img class="bcf-12-box-on-4" src="<%= ctx %>/img/main_monitor_1/bcf-12-box-on-40.png" />
        <img class="bcf-12-box-off-4" src="<%= ctx %>/img/main_monitor_1/bcf-12-box-off-40.png" />
        <img class="bcf-12-tray-2" src="<%= ctx %>/img/main_monitor_1/bcf-12-tray-20.png" />
        <img class="bcf-12-tray-1" src="<%= ctx %>/img/main_monitor_1/bcf-12-tray-10.png" />
        <div class="back-12"></div>
        <div class="bcf-12-open-1"></div>
        <div class="bcf-12-close-1"></div>
        <div class="bcf-12-open-2"></div>
        <div class="bcf-12-close-2"></div>
        <div class="bcf-12-open-3"></div>
        <div class="bcf-12-close-3"></div>
        <div class="bcf-12-stop"></div>
        <div class="bcf-12-up"></div>
        <div class="bcf-12-down"></div>
        <img class="bcf-12-heat-off" src="<%= ctx %>/img/main_monitor_1/bcf-12-heat-off0.png" />
        <img class="bcf-12-heat-on" src="<%= ctx %>/img/main_monitor_1/bcf-12-heat-on0.png" />
        <img class="bcf-12-obj-off" src="<%= ctx %>/img/main_monitor_1/bcf-12-obj-off0.png" />
        <img class="bcf-12-obj-on" src="<%= ctx %>/img/main_monitor_1/bcf-12-obj-on0.png" />
        <img class="bcf-12-pen-2" src="<%= ctx %>/img/main_monitor_1/bcf-12-pen-20.png" />
        <img class="bcf-12-pen-1" src="<%= ctx %>/img/main_monitor_1/bcf-12-pen-10.png" />
        <div class="bcf-12-jogging"></div>
        <img class="bcf-12-moter-off" src="<%= ctx %>/img/main_monitor_1/bcf-12-moter-off0.png" />
        <img class="bcf-12-moter-on" src="<%= ctx %>/img/main_monitor_1/bcf-12-moter-on0.png" />
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
        <div class="bcf-1-open-1 bcf1_8"></div>
        <div class="bcf-1-close-1"></div>
        <div class="bcf-1-open-2 bcf1_2"></div>
        <div class="bcf-1-close-2"></div>
        <div class="bcf-1-stop"></div>
        <div class="bcf-1-up"></div>
        <div class="bcf-1-down bcf1_3"></div>
        <div class="bcf-1-dt-ez-50 bcf1_50"></div>
        <img class="bcf-1-heat-off" src="<%= ctx %>/img/main_monitor_1/bcf-1-heat-off0.png" />
        <img class="bcf-1-heat-on" src="<%= ctx %>/img/main_monitor_1/bcf-1-heat-on0.png" />
        <img class="bcf-1-obj-off" src="<%= ctx %>/img/main_monitor_1/bcf-1-obj-off0.png" />
        <img class="bcf-1-obj-on bcf1_46" src="<%= ctx %>/img/main_monitor_1/bcf-1-obj-on0.png" />
        <img class="bcf-1-pen-2 bcf1_60" src="<%= ctx %>/img/main_monitor_1/bcf-1-pen-20.png" />
        <img class="bcf-1-pen-1 bcf1_60" src="<%= ctx %>/img/main_monitor_1/bcf-1-pen-10.png" />
        <div class="bcf-1-jogging bcf1_56"></div>
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
        <div class="bcf-2-open-1 bcf2_8"></div>
        <div class="bcf-2-close-1"></div>
        <div class="bcf-2-open-2 bcf2_2"></div>
        <div class="bcf-2-close-2"></div>
        <div class="bcf-2-stop"></div>
        <div class="bcf-2-up"></div>
        <div class="bcf-2-down bcf2_3"></div>
        <div class="bcf-2-dt bcf2_50"></div>
        <img class="bcf-2-heat-off" src="<%= ctx %>/img/main_monitor_1/bcf-2-heat-off0.png" />
        <img class="bcf-2-heat-on" src="<%= ctx %>/img/main_monitor_1/bcf-2-heat-on0.png" />
        <img class="bcf-2-obj-off" src="<%= ctx %>/img/main_monitor_1/bcf-2-obj-off0.png" />
        <img class="bcf-2-obj-on bcf2_46" src="<%= ctx %>/img/main_monitor_1/bcf-2-obj-on0.png" />
        <img class="bcf-2-pen-2 bcf2_60" src="<%= ctx %>/img/main_monitor_1/bcf-2-pen-20.png" />
        <img class="bcf-2-pen-1 bcf2_60" src="<%= ctx %>/img/main_monitor_1/bcf-2-pen-10.png" />
        <div class="bcf-2-jogging bcf2_56"></div>
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
        <img class="bcf-3-tray-1 bcf3_98" src="<%= ctx %>/img/main_monitor_1/bcf-3-tray-10.png" />
        <div class="back-3"></div>
        <div class="bcf-3-open-1 bcf3_8"></div>
        <div class="bcf-3-close-1"></div>
        <div class="bcf-3-open-2 bcf3_2"></div>
        <div class="bcf-3-close-2"></div>
        <div class="bcf-3-stop"></div>
        <div class="bcf-3-up"></div>
        <div class="bcf-3-down bcf3_3"></div>
        <div class="bcf-3-dt bcf3_96 bcf3_97 bcf3_98"></div>
        <img class="bcf-3-heat-off" src="<%= ctx %>/img/main_monitor_1/bcf-3-heat-off0.png" />
        <img class="bcf-3-heat-on" src="<%= ctx %>/img/main_monitor_1/bcf-3-heat-on0.png" />
        <img class="bcf-3-obj-off" src="<%= ctx %>/img/main_monitor_1/bcf-3-obj-off0.png" />
        <img class="bcf-3-obj-on bcf3_46" src="<%= ctx %>/img/main_monitor_1/bcf-3-obj-on0.png" />
        <img class="bcf-3-pen-2 bcf3_60" src="<%= ctx %>/img/main_monitor_1/bcf-3-pen-20.png" />
        <img class="bcf-3-pen-1 bcf3_60" src="<%= ctx %>/img/main_monitor_1/bcf-3-pen-10.png" />
        <div class="bcf-3-jogging bcf3_56"></div>
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
        <div class="bcf-4-open-1 bcf4_8"></div>
        <div class="bcf-4-close-1"></div>
        <div class="bcf-4-open-2 bcf4_2"></div>
        <div class="bcf-4-close-2"></div>
        <div class="bcf-4-stop"></div>
        <div class="bcf-4-up"></div>
        <div class="bcf-4-down bcf4_3"></div>
        <div class="bcf-4-dt bcf4_50"></div>
        <img class="bcf-4-heat-off" src="<%= ctx %>/img/main_monitor_1/bcf-4-heat-off0.png" />
        <img class="bcf-4-heat-on" src="<%= ctx %>/img/main_monitor_1/bcf-4-heat-on0.png" />
        <img class="bcf-4-obj-off" src="<%= ctx %>/img/main_monitor_1/bcf-4-obj-off0.png" />
        <img class="bcf-4-obj-on bcf4_46" src="<%= ctx %>/img/main_monitor_1/bcf-4-obj-on0.png" />
        <img class="bcf-4-pen-2 bcf4_60" src="<%= ctx %>/img/main_monitor_1/bcf-4-pen-20.png" />
        <img class="bcf-4-pen-1 bcf4_60" src="<%= ctx %>/img/main_monitor_1/bcf-4-pen-10.png" />
        <div class="bcf-4-jogging bcf4_56"></div>
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
        <div class="bcf-10-open-1 bcf10_8"></div>
        <div class="bcf-10-close-1"></div>
        <div class="bcf-10-open-2 bcf10_2"></div>
        <div class="bcf-10-close-2"></div>
        <div class="bcf-10-stop"></div>
        <div class="bcf-10-up"></div>
        <div class="bcf-10-down bcf10_52"></div>
        <div class="bcf-10-dt bcf10_53"></div>
        <img class="bcf-10-heat-off" src="<%= ctx %>/img/main_monitor_1/bcf-10-heat-off0.png" />
        <img class="bcf-10-heat-on" src="<%= ctx %>/img/main_monitor_1/bcf-10-heat-on0.png" />
        <img class="bcf-10-obj-off" src="<%= ctx %>/img/main_monitor_1/bcf-10-obj-off0.png" />
        <img class="bcf-10-obj-on bcf10_49" src="<%= ctx %>/img/main_monitor_1/bcf-10-obj-on0.png" />
        <img class="bcf-10-pen-2 bcf10_62" src="<%= ctx %>/img/main_monitor_1/bcf-10-pen-20.png" />
        <img class="bcf-10-pen-1 bcf10_62" src="<%= ctx %>/img/main_monitor_1/bcf-10-pen-10.png" />
        <div class="bcf-10-jogging bcf10_58"></div>
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
        <div class="bcf-5-open-1 bcf5_8"></div>
        <div class="bcf-5-close-1"></div>
        <div class="bcf-5-open-2 bcf5_2"></div>
        <div class="bcf-5-close-2"></div>
        <div class="bcf-5-open-3"></div>
        <div class="bcf-5-close-3"></div>
        <div class="bcf-5-stop"></div>
        <div class="bcf-5-up"></div>
        <div class="bcf-5-down bcf5_52"></div>
        <div class="bcf-5-dt bcf5_53"></div>
        <img class="bcf-5-heat-off" src="<%= ctx %>/img/main_monitor_1/bcf-5-heat-off0.png" />
        <img class="bcf-5-heat-on" src="<%= ctx %>/img/main_monitor_1/bcf-5-heat-on0.png" />
        <img class="bcf-5-obj-off" src="<%= ctx %>/img/main_monitor_1/bcf-5-obj-off0.png" />
        <img class="bcf-5-obj-on bcf5_49" src="<%= ctx %>/img/main_monitor_1/bcf-5-obj-on0.png" />
        <img class="bcf-5-pen-2 bcf5_62" src="<%= ctx %>/img/main_monitor_1/bcf-5-pen-20.png" />
        <img class="bcf-5-pen-1 bcf5_62" src="<%= ctx %>/img/main_monitor_1/bcf-5-pen-10.png" />
        <div class="bcf-5-jogging bcf5_58"></div>
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
          <div class="tm-cell bcf1_s_40046">DT</div><div class="tm-cell bcf1_s_40047">DT</div><div class="tm-cell bcf1_s_40048">DT</div>
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
  const INTERVAL = 1500; // ms

  /* ── 1. DOM에서 bcfN_s_ADDR(온도) / bcfN_ADDR(신호) 클래스 수집 ── */
  const wordElMap = {}; // 'bcf1_s_40045' → [el, ...]
  const bitElMap  = {}; // 'bcf1_60'      → [el, ...]

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
  if (!allTags.length) return;

  /* ── 2. PLC 값을 DOM에 반영 ── */
  function applyData(data) {
    // 온도: 텍스트 업데이트
    Object.keys(wordElMap).forEach(function (tag) {
      if (data[tag] == null) return;
      var raw  = Number(data[tag]);
      // PLC 값이 0.1°C 단위인 경우 /10, 아닌 경우 그대로 표시
      var text = isNaN(raw) ? data[tag] : (raw / 10).toFixed(1);
      wordElMap[tag].forEach(function (el) { el.textContent = text; });
    });

    // 신호: 1이면 표시(visible), 0이면 숨김(hidden)
    Object.keys(bitElMap).forEach(function (tag) {
      if (data[tag] == null) return;
      var show = (data[tag] === 1 || data[tag] === true);
      bitElMap[tag].forEach(function (el) {
        el.style.visibility = show ? 'visible' : 'hidden';
      });
    });
  }

  /* ── 3. 폴링: 직전 요청이 끝나야 다음 요청 시작 (중첩 방지) ── */
  var busy = false;

  function fetchData() {
    if (busy) return;
    busy = true;
    fetch(ctx + '/monitor/main-data', {
      method:  'POST',
      headers: { 'Content-Type': 'application/json' },
      body:    JSON.stringify(allTags)
    })
    .then(function (r) { return r.ok ? r.json() : Promise.reject(r.status); })
    .then(function (data) { applyData(data); })
    .catch(function (err) { console.warn('[monitor] PLC fetch 실패:', err); })
    .finally(function () { busy = false; });
  }

  // 페이지 로드 즉시 1회 + 이후 주기 폴링
  fetchData();
  setInterval(fetchData, INTERVAL);
})();
</script>
</body>
</html>