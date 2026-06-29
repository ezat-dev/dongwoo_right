<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common_style.jsp" %>
<% String ctx = request.getContextPath(); %>
<link rel="stylesheet" href="<%= ctx %>/css/tabulator/tabulator_simple.css">
<script src="<%= ctx %>/js/highchart/highcharts.js"></script>
<script src="<%= ctx %>/js/tabulator/tabulator.js"></script>
<style>
* { box-sizing: border-box; margin: 0; padding: 0; }
html, body {
  height: 100%; font-family: 'Segoe UI', 'Malgun Gothic', sans-serif;
  background: #F0F4F8; color: #2D3748; overflow: hidden;
}
.bd-wrap { display:flex; flex-direction:column; height:100vh; padding:14px; gap:10px; }

/* ── 탭 바 ── */
.bd-topbar {
  display:flex; align-items:center; gap:8px;
  background:#fff; border:1px solid #E2E8F0; border-radius:10px;
  padding:8px 14px; box-shadow:0 1px 4px rgba(0,0,0,.08); flex-shrink:0;
}
.bd-title { font-size:15px; font-weight:800; letter-spacing:1px; margin-right:6px; }
.bd-divider { width:1px; height:22px; background:#E2E8F0; margin:0 4px; }
.bd-tab {
  display:flex; align-items:center; gap:5px; padding:6px 16px; border-radius:7px;
  border:1px solid #E2E8F0; background:none; cursor:pointer;
  font-size:12px; font-weight:600; color:#718096; transition:all .15s;
}
.bd-tab:hover { background:#F0F4F8; color:#2D3748; }
.bd-tab.active {
  background:linear-gradient(135deg,#3182CE,#2B6CB0); color:#fff;
  border-color:transparent; box-shadow:0 2px 8px rgba(49,130,206,.3);
}
.bd-tab.alarm-tab.active {
  background:linear-gradient(135deg,#E53E3E,#C53030);
  box-shadow:0 2px 8px rgba(229,62,62,.3);
}
.bd-spacer { flex:1; }
.bd-content { flex:1; min-height:0; position:relative; }
.bd-panel { position:absolute; inset:0; display:none; flex-direction:column; gap:10px; }
.bd-panel.active { display:flex; }
.bd-card {
  background:#fff; border:1px solid #E2E8F0; border-radius:10px;
  box-shadow:0 1px 4px rgba(0,0,0,.08); overflow:hidden;
}
.bd-card-header {
  display:flex; align-items:center; gap:8px; padding:9px 14px;
  background:#F0F4F8; border-bottom:1px solid #E2E8F0;
  font-size:12px; font-weight:700; flex-shrink:0;
}

/* ── 필터 행 ── */
.filter-row {
  display:flex; align-items:center; gap:8px; padding:8px 14px;
  border-bottom:1px solid #E2E8F0; background:#fafbfc;
  flex-shrink:0; flex-wrap:wrap;
}
.filter-row label { font-size:11px; font-weight:600; color:#718096; }
.filter-row input[type="datetime-local"],
.filter-row input[type="date"],
.filter-row select {
  height:28px; border:1px solid #E2E8F0; border-radius:5px;
  padding:0 8px; font-size:11px; color:#2D3748; background:#fff; outline:none;
}
.filter-row input:focus, .filter-row select:focus { border-color:#3182CE; }
.filter-row input[readonly] { background:#F0F4F8; color:#718096; cursor:default; }
.btn-primary {
  height:28px; padding:0 14px; background:#3182CE; color:#fff;
  border:none; border-radius:5px; font-size:11px; font-weight:700;
  cursor:pointer; transition:background .13s;
}
.btn-primary:hover { background:#2B6CB0; }
.btn-alarm {
  height:28px; padding:0 14px; background:#E53E3E; color:#fff;
  border:none; border-radius:5px; font-size:11px; font-weight:700;
  cursor:pointer; transition:background .13s;
}
.btn-alarm:hover { background:#C53030; }
.btn-excel {
  height:28px; padding:0 12px; background:#276749; color:#fff;
  border:none; border-radius:5px; font-size:11px; font-weight:700;
  cursor:pointer; transition:background .13s;
}
.btn-excel:hover { background:#1e4d35; }
.result-count { margin-left:auto; font-size:11px; color:#718096; font-weight:600; }

/* ── 트렌드 바디 ── */
.trend-body {
  display:grid; grid-template-columns:160px 1fr;
  flex:1; min-height:0; overflow:hidden;
}
.series-panel {
  border-right:1px solid #E2E8F0; background:#fafbfc;
  display:flex; flex-direction:column; overflow:hidden;
}
.series-panel-hd {
  padding:7px 10px; font-size:11px; font-weight:700;
  color:#2D3748; border-bottom:1px solid #E2E8F0;
  background:#EDF2F7; flex-shrink:0;
  display:flex; align-items:center; justify-content:space-between;
}
.series-panel-hd button {
  font-size:10px; font-weight:600; color:#3182CE;
  background:none; border:none; cursor:pointer; padding:0;
}
.series-list { flex:1; overflow-y:auto; padding:6px 0; }
.series-item {
  display:flex; align-items:center; gap:6px;
  padding:4px 10px; cursor:pointer; font-size:11px; color:#2D3748;
  transition:background .1s;
}
.series-item:hover { background:#EBF8FF; }
.series-item input[type="checkbox"] { cursor:pointer; accent-color:#3182CE; }
.series-dot { width:10px; height:10px; border-radius:50%; flex-shrink:0; }
.chart-wrap { flex:1; min-width:0; }
#trendChart { width:100%; height:100%; }

/* ── 알람 테이블 ── */
.table-area { flex:1; min-height:0; display:block; overflow:hidden; background:#fafbfc; }
#alarm-table { height:100%; }
.tabulator { border:none !important; background:#fafbfc !important; }
.tabulator .tabulator-header { background:#EDF2F7 !important; border-bottom:2px solid #E2E8F0 !important; }
.tabulator .tabulator-header .tabulator-col {
  background:#EDF2F7 !important; font-size:11px !important;
  font-weight:700 !important; color:#2D3748 !important;
  border-right:1px solid #E2E8F0 !important;
}
.tabulator .tabulator-row { font-size:11px !important; border-bottom:1px solid #F0F4F8 !important; }
.tabulator .tabulator-row:hover { background:#EBF8FF !important; }
.tabulator .tabulator-row .tabulator-cell { padding:5px 8px !important; }
.tabulator .tabulator-row.tabulator-row-even { background:#FAFBFC !important; }
.cell-bcf { font-weight:700; color:#2B6CB0; }

/* ── 로딩 오버레이 ── */
.loading-overlay {
  position:absolute; inset:0; background:rgba(247,250,252,.82);
  display:none; align-items:center; justify-content:center;
  z-index:99; border-radius:10px; flex-direction:column; gap:12px;
}
.loading-overlay.show { display:flex; }
.spinner {
  width:34px; height:34px; border:3px solid #BEE3F8;
  border-top-color:#3182CE; border-radius:50%;
  animation:spin .7s linear infinite;
}
@keyframes spin { to { transform:rotate(360deg); } }
.loading-overlay span { font-size:12px; font-weight:600; color:#3182CE; }
</style>
</head>

<body>
<div class="bd-wrap">

  <!-- ── 탭 바 ── -->
  <div class="bd-topbar">
    <span class="bd-title">&#128190; BACKUP-DATA</span>
    <div class="bd-divider"></div>
    <button class="bd-tab active" id="tab-trend" onclick="switchTab('trend')">
      <span>&#128200;</span> 트렌드
    </button>
    <button class="bd-tab alarm-tab" id="tab-alarm" onclick="switchTab('alarm')">
      <span>&#128276;</span> 과거 알람
    </button>
    <div class="bd-spacer"></div>
  </div>

  <div class="bd-content">

    <!-- ────── 트렌드 패널 ────── -->
    <div class="bd-panel active" id="panel-trend">
      <div class="bd-card" style="display:flex;flex-direction:column;flex:1;min-height:0;position:relative;">
        <div class="bd-card-header"><span>&#128200;</span> 트렌드 조회 (htms DB)</div>
        <div class="filter-row">
          <label>설비</label>
          <select id="trend-equip">
            <option value="1">BCF1</option>
            <option value="2">BCF2</option>
            <option value="3">BCF3</option>
            <option value="4">BCF4</option>
            <option value="5">BCF5</option>
            <option value="6">BCF6</option>
            <option value="7">BCF7</option>
            <option value="8">BCF8</option>
            <option value="9">BCF9</option>
            <option value="10">BCF10</option>
            <option value="11">BCF11</option>
            <option value="12">BCF12</option>
          </select>
          <label>시작</label>
          <input type="datetime-local" id="trend-start" value="2026-05-29T11:30">
          <label>종료</label>
          <input type="datetime-local" id="trend-end"   value="2026-06-01T11:30">
          <button class="btn-primary" onclick="loadTrend()">조회</button>
          <button class="btn-excel" id="btn-png" onclick="downloadChartPng()" style="display:none">&#128247; PNG</button>
          <span class="result-count" id="trend-count"></span>
        </div>
        <!-- 로딩 오버레이 (트렌드) -->
        <div class="loading-overlay" id="trend-loading">
          <div class="spinner"></div>
          <span id="trend-loading-msg">조회 중...</span>
        </div>
        <div class="trend-body">
          <!-- 좌: 시리즈 선택 -->
          <div class="series-panel">
            <div class="series-panel-hd">
              표시 항목
              <button onclick="toggleAllSeries(true)">전체</button>
            </div>
            <div class="series-list" id="series-list">
              <div style="padding:20px 10px;font-size:11px;color:#A0AEC0;">조회 후 표시</div>
            </div>
          </div>
          <!-- 우: 차트 -->
          <div class="chart-wrap">
            <div id="trendChart"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- ────── 과거 알람 패널 ────── -->
    <div class="bd-panel" id="panel-alarm">
      <div class="bd-card" style="display:flex;flex-direction:column;flex:1;min-height:0;">
        <div class="bd-card-header"><span>&#128276;</span> 과거 알람 이력 (htms DB)</div>
        <div class="filter-row">
          <label>설비</label>
          <select id="alarm-equip">
            <option value="0">-- 전체 --</option>
            <option value="1"    selected>BCF1</option>
            <option value="2">BCF2</option>
            <option value="4">BCF3</option>
            <option value="8">BCF4</option>
            <option value="16">BCF5</option>
            <option value="32">BCF6</option>
            <option value="64">BCF7</option>
            <option value="128">BCF8</option>
            <option value="256">BCF9</option>
            <option value="512">BCF10</option>
            <option value="1024">BCF11</option>
            <option value="2048">BCF12</option>
          </select>
          <label>시작일</label>
          <input type="date" id="alarm-start" value="2026-01-01">
          <label>종료일</label>
          <input type="date" id="alarm-end"   value="2026-06-01">
          <button class="btn-alarm" onclick="loadAlarms()">조회</button>
          <button class="btn-excel" onclick="exportExcel()">&#128190; 엑셀</button>
          <span class="result-count" id="alarm-count"></span>
        </div>
        <div class="table-area">
          <div id="alarm-table"></div>
        </div>
      </div>
    </div>

  </div>
</div>

<script>
var CTX = '<%= ctx %>';

/* ════════════════════════════
   공통
════════════════════════════ */
function switchTab(tab) {
  ['trend','alarm'].forEach(function(t) {
    document.getElementById('tab-'   + t).classList.toggle('active', t === tab);
    document.getElementById('panel-' + t).classList.toggle('active', t === tab);
  });
}

/* ════════════════════════════
   트렌드 (htms bcfN_)
════════════════════════════ */
var COLORS = [
  '#3182CE','#E53E3E','#38A169','#D69E2E','#805AD5',
  '#2B6CB0','#C53030','#276749','#B7791F','#6B46C1',
  '#0BC5EA','#F6AD55','#68D391','#FC8181','#B794F4','#F687B3'
];

var trendChart   = null;
var trendRawData = [];
var seriesMeta   = []; /* [{col, label, color, active}] */

/* BCF별 컬럼 한글명 매핑 (미정의 컬럼은 Data번호로 fallback) */
var BCF_COMMON_1_5 = {
  Data1:'침탄온도PV', Data2:'침탄온도SP', Data3:'CP PV',    Data4:'CP SP',
  Data5:'유조온도PV', Data6:'유조온도SP', Data7:'C3H8 유량'
};
var BCF_COMMON_7_10_12 = {
  Data1:'침탄온도PV', Data2:'침탄온도SP', Data3:'CP PV',    Data4:'CP SP',
  Data5:'유조온도PV', Data6:'유조온도SP', Data7:'C3H8 유량', Data8:'NH3 유량'
};
var BCF_LABEL_MAP = {
  '1':  BCF_COMMON_1_5,
  '2':  BCF_COMMON_1_5,
  '3':  BCF_COMMON_1_5,
  '4':  BCF_COMMON_1_5,
  '5':  BCF_COMMON_1_5,
  '6':  {
    Data1:'예열온도PV',      Data2:'예열온도SP',
    Data3:'가열온도PV',      Data4:'가열온도SP',
    Data5:'침탄1온도PV',     Data6:'침탄1온도SP',
    Data7:'침탄2온도PV',     Data8:'침탄2온도SP',
    Data9:'강온온도PV',      Data10:'강온온도SP',
    Data11:'가열 CP PV',     Data12:'가열 CP SP',
    Data13:'침탄 CP PV',     Data14:'침탄 CP SP',
    Data15:'가열 C3H8 유량', Data16:'침탄 C3H8 유량'
  },
  '7':  BCF_COMMON_7_10_12,
  '8':  BCF_COMMON_7_10_12,
  '9':  BCF_COMMON_7_10_12,
  '10': BCF_COMMON_7_10_12,
  '11': {
    Data1:'1실온도PV',  Data2:'1실온도SP',
    Data3:'2실온도PV',  Data4:'2실온도SP',
    Data5:'냉각실온도PV', Data6:'냉각실온도SP',
    Data7:'1실 CP PV', Data8:'1실 CP SP',
    Data9:'2실 CP PV', Data10:'2실 CP SP',
    Data11:'1실 C3H8', Data12:'2실 C3H8'
  },
  '12': BCF_COMMON_7_10_12
};

Highcharts.setOptions({
  lang: { months:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
          shortMonths:['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],
          weekdays:['일','월','화','수','목','금','토'] }
});

function fmtDt(d) {
  return d.getFullYear() + '-'
    + String(d.getMonth()+1).padStart(2,'0') + '-'
    + String(d.getDate()).padStart(2,'0') + 'T'
    + String(d.getHours()).padStart(2,'0') + ':'
    + String(d.getMinutes()).padStart(2,'0');
}

function setTrendLoading(on, msg) {
  var ov = document.getElementById('trend-loading');
  ov.classList.toggle('show', on);
  if (msg) document.getElementById('trend-loading-msg').textContent = msg;
}

function loadTrend() {
  var bcf  = document.getElementById('trend-equip').value;
  var from = document.getElementById('trend-start').value.replace('T',' ') + ':00';
  var to   = document.getElementById('trend-end').value.replace('T',' ')   + ':00';
  var bcfLabel = 'BCF' + bcf;
  var cnt  = document.getElementById('trend-count');

  console.log('[BACKUP-TREND] 조회 시작', { 설비: bcfLabel, from: from, to: to });
  setTrendLoading(true, bcfLabel + ' 조회 중...');
  cnt.textContent = '';

  var url = CTX + '/backup/trend/data?bcf=' + bcf
          + '&from=' + encodeURIComponent(from)
          + '&to='   + encodeURIComponent(to);

  fetch(url)
    .then(function(r){
      console.log('[BACKUP-TREND] HTTP 응답', r.status, r.url);
      if (!r.ok) throw new Error('HTTP ' + r.status);
      return r.json();
    })
    .then(function(rows){
      setTrendLoading(false);
      if (!Array.isArray(rows)){
        console.error('[BACKUP-TREND] 실패 응답', rows);
        cnt.textContent = '오류';
        alert('조회 실패: ' + (rows.error || JSON.stringify(rows)));
        return;
      }
      trendRawData = rows;
      cnt.textContent = '총 ' + rows.length.toLocaleString() + '행';
      console.log('[BACKUP-TREND] 성공', { 설비: bcfLabel, 행수: rows.length, 샘플: rows[0] || null });
      buildSeriesPanel(rows);
      renderTrendChart();
      document.getElementById('btn-png').style.display = '';
    })
    .catch(function(e){
      setTrendLoading(false);
      cnt.textContent = '오류';
      console.error('[BACKUP-TREND] 통신 오류', e);
      alert('통신 오류: ' + e.message);
    });
}

/* 데이터에서 유효 컬럼(비제로 존재) 검출 */
function buildSeriesPanel(rows) {
  if (!rows.length) return;

  var bcf      = document.getElementById('trend-equip').value;
  var labelMap = BCF_LABEL_MAP[bcf] || {};

  /* 컬럼 키 탐지 (Data1~Data16, 대소문자 무관) */
  var firstRow = rows[0];
  var allKeys  = Object.keys(firstRow);
  var dataCols = allKeys.filter(function(k){ return /^[Dd]ata\d+$/.test(k); })
                        .sort(function(a,b){
                          return parseInt(a.replace(/\D/g,'')) - parseInt(b.replace(/\D/g,''));
                        });

  /* 비제로 컬럼 필터 */
  var activeCols = dataCols.filter(function(col){
    return rows.some(function(row){ return parseFloat(row[col]) !== 0; });
  });

  /* 컬럼 키를 정규화 (DB 반환 키 대소문자 무관하게 labelMap 조회) */
  function getLabel(col) {
    var normalized = col.charAt(0).toUpperCase() + col.slice(1).toLowerCase()
                       .replace(/(\d+)$/, function(m){ return m; });
    /* "data1" → "Data1" 형태로 */
    var key = 'Data' + col.replace(/\D/g,'');
    return labelMap[key] || col;
  }

  seriesMeta = dataCols.map(function(col, i){
    return { col: col, label: getLabel(col), color: COLORS[i % COLORS.length], active: activeCols.indexOf(col) !== -1 };
  });

  /* 체크박스 렌더 */
  var html = '';
  seriesMeta.forEach(function(s, i){
    html += '<label class="series-item">'
          + '<input type="checkbox" ' + (s.active ? 'checked' : '') + ' data-idx="' + i + '" onchange="onSeriesToggle(this)">'
          + '<span class="series-dot" style="background:' + s.color + '"></span>'
          + s.label
          + '</label>';
  });
  document.getElementById('series-list').innerHTML = html;
}

function onSeriesToggle(chk) {
  var idx = parseInt(chk.getAttribute('data-idx'));
  seriesMeta[idx].active = chk.checked;
  if (trendChart) {
    var series = trendChart.series[idx];
    if (series) series.setVisible(chk.checked, true);
  }
}

function toggleAllSeries(show) {
  document.querySelectorAll('#series-list input[type=checkbox]').forEach(function(chk){
    chk.checked = show;
    var idx = parseInt(chk.getAttribute('data-idx'));
    seriesMeta[idx].active = show;
    if (trendChart) {
      var s = trendChart.series[idx];
      if (s) s.setVisible(show, false);
    }
  });
  if (trendChart) trendChart.redraw();
}

/* ── 유량/가스 태그 판별 ── */
function isFlowLabel(label) {
  return /c3h8|nh3|유량/i.test(label);
}
function isCpLabel(label) {
  return /\bcp\b/i.test(label);
}
function scaleFlow(v) {
  if (v > 30000) return null;
  return v >= 1000 ? v / 1000 : v / 100;
}

function renderTrendChart() {
  if (!trendRawData.length || !seriesMeta.length) return;

  /* X축 타임스탬프 배열 */
  var times = trendRawData.map(function(row){
    var key = Object.keys(row).find(function(k){ return k.toLowerCase() === 'datadate'; });
    return new Date(row[key]).getTime();
  });

  /* 시리즈 빌드 (스케일 적용) */
  var series = seriesMeta.map(function(s){
    var isFlow = isFlowLabel(s.label);
    var isCp   = !isFlow && isCpLabel(s.label);
    var data = trendRawData.map(function(row, i){
      var v = parseFloat(row[s.col]);
      if (isNaN(v)) return [times[i], null];
      if (isFlow) {
        var sv = scaleFlow(v);
        return [times[i], sv];
      }
      return [times[i], v];
    });
    return {
      name:      s.label,
      data:      data,
      color:     s.color,
      lineWidth: 1.5,
      visible:   s.active,
      marker:    { enabled: false },
      yAxis:     isFlow ? 2 : (isCp ? 1 : 0)
    };
  });

  var container = document.getElementById('trendChart');

  if (trendChart) {
    trendChart.destroy();
    trendChart = null;
  }

  trendChart = Highcharts.chart(container, {
    chart: {
      type: 'spline', animation: false,
      zoomType: 'x',
      backgroundColor: '#0F1923',
      plotBackgroundColor: '#0A1220',
      panning: { enabled: true, type: 'x' }, panKey: 'shift',
      style: { fontFamily: "'Segoe UI','Malgun Gothic',sans-serif" },
      height: null,
      resetZoomButton: { position: { align: 'right', x: -10, y: 10 } }
    },
    title:  { text: null },
    legend: { enabled: false },
    xAxis: {
      type: 'datetime',
      lineColor: '#2D3748', tickColor: '#2D3748', gridLineColor: '#1E2A3A',
      labels: { format: '{value:%m/%d %H:%M}', style: { fontSize:'10px', color:'#A0AEC0' } },
      crosshair: { color: 'rgba(99,179,237,.25)' }
    },
    yAxis: [
      { /* 온도 */
        title: { text: null },
        gridLineColor: '#1E2A3A',
        labels: { style: { fontSize:'10px', color:'#A0AEC0' } }
      },
      { /* CP */
        title: { text: null }, opposite: true,
        gridLineColor: 'transparent',
        labels: { format: '{value:.2f}', style: { fontSize:'10px', color:'#68D391' } },
        min: 0, softMax: 2.0
      },
      { /* 유량/가스 */
        title: { text: null }, opposite: true,
        gridLineColor: 'transparent',
        labels: { format: '{value:.1f}', style: { fontSize:'10px', color:'#63B3ED' } },
        min: 0, max: 20
      }
    ],
    tooltip: {
      shared: true,
      backgroundColor: '#2D3748',
      borderColor: '#4A5568',
      borderRadius: 8,
      style: { color: '#F7FAFC', fontSize: '11px' },
      xDateFormat: '%Y-%m-%d %H:%M:%S',
      pointFormatter: function() {
        if (!this.series.visible || this.y === null) return '';
        var v = this.y;
        var dec = isFlowLabel(this.series.name) ? 2 : (isCpLabel(this.series.name) ? 3 : 1);
        return '<span style="color:' + this.series.color + '">&#9679;</span> '
             + this.series.name + ': <b>' + v.toFixed(dec) + '</b><br/>';
      }
    },
    plotOptions: { spline: { states: { hover: { lineWidth: 2 } } } },
    credits: { enabled: false },
    series: series
  });
}

/* ── PNG 다운로드 ── */
function downloadChartPng() {
  if (!trendChart) { alert('먼저 차트를 조회하세요'); return; }
  var svg = trendChart.getSVG({ width: trendChart.chartWidth, height: trendChart.chartHeight });
  var blob = new Blob([svg], { type: 'image/svg+xml;charset=utf-8' });
  var url  = URL.createObjectURL(blob);
  var img  = new Image();
  img.onload = function() {
    var canvas = document.createElement('canvas');
    canvas.width  = trendChart.chartWidth;
    canvas.height = trendChart.chartHeight;
    var c2d = canvas.getContext('2d');
    c2d.fillStyle = '#0F1923';
    c2d.fillRect(0, 0, canvas.width, canvas.height);
    c2d.drawImage(img, 0, 0);
    URL.revokeObjectURL(url);
    var bcf  = 'BCF' + document.getElementById('trend-equip').value;
    var from = document.getElementById('trend-start').value.slice(0,13).replace('T','_');
    var a = document.createElement('a');
    a.download = 'trend_' + bcf + '_' + from + '.png';
    a.href = canvas.toDataURL('image/png');
    a.click();
  };
  img.src = url;
}

/* ════════════════════════════
   과거 알람 (htms se)
════════════════════════════ */
var alarmTable = null;

function getBcf(source) {
  if (!source) return '-';
  var m = source.match(/^(BCF\d+)\./i);
  return m ? m[1] : source;
}

function initAlarmTable() {
  if (alarmTable) return;
  alarmTable = new Tabulator('#alarm-table', {
    data: [],
    layout: 'fitColumns',
    height: '100%',
    placeholder: '조건을 선택 후 조회하세요',
    columns: [
      { title: '#',      formatter: 'rownum', width: 45,  hozAlign: 'center', headerSort: false },
      { title: '설비',   field: 'source',     width: 65,  hozAlign: 'center',
        formatter: function(cell){ return '<span class="cell-bcf">' + getBcf(cell.getValue()) + '</span>'; }
      },
    
      { title: 'PV',     field: 'pv',         width: 160,  hozAlign: 'center' },
      { title: '설정값', field: 'tripValue',   width: 160,  hozAlign: 'center' },
      { title: '발생시간', field: 'timeAct',   minWidth: 140 },
        { title: '알람내용', field: 'descString', width: 550 }
    ]
  });
}

function loadAlarms() {
  var from = document.getElementById('alarm-start').value;
  var to   = document.getElementById('alarm-end').value;
  var mask = document.getElementById('alarm-equip').value || '0';
  if (!from || !to) { alert('기간을 선택하세요'); return; }
  initAlarmTable();
  var cnt = document.getElementById('alarm-count');
  cnt.textContent = '조회 중...';
  var url = CTX + '/backup/alarm/list?from=' + from + '&to=' + to + '&areaMask=' + mask;
  console.log('[BACKUP-ALARM] 조회 시작', { from: from, to: to, areaMask: mask });
  fetch(url)
    .then(function(r){
      console.log('[BACKUP-ALARM] HTTP 응답', r.status);
      if (!r.ok) throw new Error('HTTP ' + r.status);
      return r.json();
    })
    .then(function(data){
      if (!Array.isArray(data)){
        cnt.textContent = '오류';
        console.error('[BACKUP-ALARM] 실패 응답', data);
        alert('조회 실패: ' + (data.error || '오류'));
        return;
      }
      alarmTable.setData(data);
      cnt.textContent = '총 ' + data.length.toLocaleString() + '건';
      console.log('[BACKUP-ALARM] 성공', { 건수: data.length, 샘플: data[0] || null });
    })
    .catch(function(e){
      cnt.textContent = '오류';
      console.error('[BACKUP-ALARM] 통신 오류', e);
      alert('통신 오류: ' + e.message);
    });
}

function exportExcel() {
  var from = document.getElementById('alarm-start').value;
  var to   = document.getElementById('alarm-end').value;
  var mask = document.getElementById('alarm-equip').value || '0';
  if (!from || !to) { alert('기간을 선택하세요'); return; }
  location.href = CTX + '/backup/alarm/excel?from=' + from + '&to=' + to + '&areaMask=' + mask;
}

/* ════════════════════════════
   페이지 로드 시 자동 조회
════════════════════════════ */
document.addEventListener('DOMContentLoaded', function() {
  var now  = new Date();
  var past = new Date(now.getTime() - 3 * 24 * 60 * 60 * 1000);

  document.getElementById('trend-end').value   = fmtDt(now);
  document.getElementById('trend-start').value = fmtDt(past);

  var ymd = now.getFullYear() + '-'
          + String(now.getMonth()+1).padStart(2,'0') + '-'
          + String(now.getDate()).padStart(2,'0');
  document.getElementById('alarm-end').value = ymd;

  loadTrend();
});
</script>
</body>
</html>
