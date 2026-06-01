<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common_style.jsp" %>
<style>
.work-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 14px;
}

.machine-card {
  background: var(--white);
  border: 1px solid #C9D9EE;
  border-radius: 12px;
  box-shadow: 0 2px 0 #B8CCE4, 0 4px 12px rgba(49,130,206,.10);
  overflow: hidden;
  transition: transform .12s, box-shadow .12s;
}
.machine-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 0 #B8CCE4, 0 8px 20px rgba(49,130,206,.15);
}

.machine-card-header {
  padding: 7px 12px;
  background: linear-gradient(135deg, #3182CE 0%, #2563EB 100%);
  color: #fff;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid rgba(255,255,255,.15);
}
.machine-name {
  font-size: 15px; font-weight: 800; letter-spacing: .3px;
  white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
}
.item-count {
  font-size: 12px; font-weight: 800;
  background: rgba(255,255,255,.25);
  border-radius: 10px; padding: 2px 9px;
  white-space: nowrap; flex-shrink: 0; margin-left: 8px;
}
.item-count.zero { background: rgba(255,255,255,.1); opacity: .7; }

.work-table { width: 100%; border-collapse: collapse; }
.work-table th {
  background: var(--bg); color: var(--muted);
  font-size: 11px; font-weight: 700;
  padding: 7px 10px; border-bottom: 2px solid var(--border);
  text-align: left; white-space: nowrap;
}
.work-table td {
  font-size: 13px; font-weight: 600;
  padding: 9px 10px; border-bottom: 1px solid var(--border);
  color: var(--text); overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  height: 38px;
}
/* 5행 고정: 빈 행은 내용 없이 높이만 유지 */
.work-table tr.empty-fixed td {
  color: transparent; cursor: default; pointer-events: none;
}
.work-table tr:last-child td { border-bottom: none; }
.work-table tbody tr:not(.empty-fixed) { cursor: pointer; transition: background .1s; }
.work-table tbody tr:not(.empty-fixed):hover { background: var(--primary-l); }
.work-table tbody tr.selected {
  background: var(--primary-m) !important;
  color: var(--primary-d) !important;
}
.work-table .col-num  { width: 10%; text-align: center; }
.work-table .col-lot  { width: 33%; }
.work-table .col-cust { width: 25%; }
.work-table .col-prod { width: 32%; }
.work-table th.col-num { text-align: center; }
.work-table td.col-num { color: var(--muted); font-size: 12px; font-weight: 700; text-align: center; }

/* 헤더 영역 */
.top-bar {
  display: flex; align-items: center; justify-content: flex-end;
  margin-bottom: 14px; gap: 10px;
}
.refresh-info {
  display: flex; align-items: center; gap: 7px;
  font-size: 13px; color: var(--muted); font-weight: 600;
}
.pulse-dot {
  width: 9px; height: 9px; border-radius: 50%;
  background: var(--green); flex-shrink: 0;
  animation: blink 2s ease-in-out infinite;
}
@keyframes blink { 0%,100%{opacity:1} 50%{opacity:.3} }
.update-time {
  font-size: 12px; color: var(--muted);
  background: var(--bg); border: 1px solid var(--border);
  border-radius: 20px; padding: 4px 12px;
}

.machine-card.refreshed { animation: flash .4s ease; }
@keyframes flash { 0%{background:#EBF8FF} 100%{background:var(--white)} }
</style>
<body>
<div class="page-wrap">

  <div class="top-bar">
    <div class="refresh-info">
      <span class="pulse-dot"></span>
      <span>10초 자동 갱신</span>
    </div>
    <div class="update-time" id="updateTime">--:--:--</div>
  </div>

  <div class="work-grid" id="workGrid"></div>

</div>
<script>
var ROOT        = '<%=request.getContextPath()%>';
var selectedKey = null;
var FIXED_ROWS  = 5;

/* ── 데이터 로드 ── */
function loadData() {
  fetch(ROOT + '/work/listData')
    .then(function(r) { return r.json(); })
    .then(function(data) {
      renderAll(data);
      var now = new Date();
      document.getElementById('updateTime').textContent =
        now.toTimeString().slice(0, 8);
    })
    .catch(function(e) { console.error('작업LIST 로드 실패', e); });
}

/* ── 전체 렌더링 ── */
function renderAll(machines) {
  var grid     = document.getElementById('workGrid');
  var existing = grid.querySelectorAll('.machine-card');
  if (existing.length === machines.length) {
    machines.forEach(function(m, i) { updateCard(existing[i], m); });
  } else {
    grid.innerHTML = '';
    machines.forEach(function(m) { grid.appendChild(buildCard(m)); });
  }
}

/* ── 카드 최초 생성 ── */
function buildCard(m) {
  var card = document.createElement('div');
  card.className = 'machine-card';
  card.dataset.machine = m.machineTag;
  card.innerHTML = cardHeaderHtml(m);
  card.appendChild(buildTable(m));
  return card;
}

/* ── 카드 데이터 갱신 ── */
function updateCard(card, m) {
  card.querySelector('.machine-card-header').outerHTML = cardHeaderHtml(m);
  var old = card.querySelector('.tbl-wrap');
  if (old) card.removeChild(old);
  card.appendChild(buildTable(m));
  card.classList.remove('refreshed');
  void card.offsetWidth;
  card.classList.add('refreshed');
}

function cardHeaderHtml(m) {
  var cnt  = m.items ? m.items.length : 0;
  var zero = cnt === 0 ? ' zero' : '';
  return '<div class="machine-card-header">' +
    '<div class="machine-name">' + m.machineTag + '(' + m.equtCd + ')</div>' +
    '<span class="item-count' + zero + '">' + cnt + '건</span>' +
  '</div>';
}

/* ── 테이블 (항상 5행 고정) ── */
function buildTable(m) {
  var wrap  = document.createElement('div');
  wrap.className = 'tbl-wrap';

  var table = document.createElement('table');
  table.className = 'work-table';
  table.innerHTML =
    '<thead><tr>' +
      '<th class="col-num">#</th>' +
      '<th class="col-lot">LOT번호</th>' +
      '<th class="col-prod">제품명</th>' +
    '</tr></thead>';

  var tbody  = document.createElement('tbody');
  var items  = m.items || [];

  // 실제 데이터 행
  for (var i = 0; i < items.length; i++) {
    var item = items[i];
    var key  = m.machineTag + '|' + item.workIndctNum;
    var tr   = document.createElement('tr');
    if (selectedKey === key) tr.classList.add('selected');
    tr.dataset.key = key;
    tr.innerHTML =
      '<td class="col-num">' + (i + 1) + '</td>' +
      '<td class="col-lot"  title="' + esc(item.workIndctNum) + '">' + esc(item.workIndctNum || '') + '</td>' +
      '<td class="col-prod" title="' + esc(item.prodNm)       + '">' + esc(item.prodNm       || '') + '</td>';
    tr.addEventListener('click', (function(t, k){ return function(){ toggleRow(t, k); }; })(tr, key));
    tbody.appendChild(tr);
  }

  // 빈 패딩 행 (5행 고정)
  for (var j = items.length; j < FIXED_ROWS; j++) {
    var pad = document.createElement('tr');
    pad.className = 'empty-fixed';
    pad.innerHTML = '<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>';
    tbody.appendChild(pad);
  }

  table.appendChild(tbody);
  wrap.appendChild(table);
  return wrap;
}

/* ── 행 단일 선택 토글 ── */
function toggleRow(tr, key) {
  var wasSelected = (selectedKey === key);
  document.querySelectorAll('.work-table tbody tr.selected')
    .forEach(function(r) { r.classList.remove('selected'); });
  if (!wasSelected) {
    tr.classList.add('selected');
    selectedKey = key;
  } else {
    selectedKey = null;
  }
}

/* ── HTML 이스케이프 ── */
function esc(s) {
  if (!s) return '';
  return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

setInterval(loadData, 10000);
loadData();
</script>
</body>
</html>
