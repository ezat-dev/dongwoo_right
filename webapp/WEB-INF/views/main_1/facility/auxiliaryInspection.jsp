<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common_style.jsp" %>
<style>
/* ── 탭 ── */
.ax-tabs { display:flex; gap:6px; margin-bottom:14px; }
.ax-tab  { padding:7px 20px; border-radius:8px; border:1px solid var(--border);
  background:var(--white); font-size:13px; font-weight:600;
  cursor:pointer; transition:all .13s; color:var(--muted); }
.ax-tab.active { background:var(--primary); color:#fff; border-color:var(--primary); }

/* ── 3단 그리드 (1:1:1 균등) ── */
.ax-grid { display:grid; grid-template-columns:1fr 1fr 1fr; gap:12px; align-items:start; }
@media(max-width:900px){  .ax-grid{ grid-template-columns:1fr 1fr; } }
@media(max-width:620px){  .ax-grid{ grid-template-columns:1fr; } }

/* ── 콤프레샤 + 유의사항 묶음 컬럼 ── */
#col2Wrap { display:flex; flex-direction:column; gap:12px; }

/* ── 점검 테이블 공통 ── */
.ax-table { width:100%; border-collapse:collapse; font-size:12px; table-layout:fixed; }
.ax-table th {
  background:#EDF2F7; padding:5px 4px; text-align:center;
  font-size:11px; font-weight:700; color:#4A5568;
  border:1px solid #CBD5E0; white-space:nowrap;
}
.ax-table td {
  padding:4px; border:1px solid #CBD5E0;
  vertical-align:middle; text-align:center;
}
.ax-table td.left { text-align:left; font-size:11px; word-break:keep-all; }
.ax-table td.group-cell {
  background:#EDF2F7; font-weight:700; font-size:11px;
  writing-mode:vertical-lr; text-orientation:upright;
  letter-spacing:2px; width:22px; padding:2px 1px;
}
.section-title {
  font-size:12px; font-weight:700; color:#2D3748;
  padding:5px 8px; background:#EDF2F7;
  border-radius:6px; margin-bottom:8px;
}
.section-note { font-size:10px; color:var(--muted); margin-bottom:6px; }

/* ── O/X 토글 셀 ── */
.ox-cell {
  min-width:28px; height:26px; cursor:pointer;
  border-radius:4px; font-size:13px; font-weight:700;
  display:flex; align-items:center; justify-content:center;
  margin:0 auto; transition:all .12s; user-select:none;
  touch-action:manipulation;
}
.ox-cell.val-O { background:#C6F6D5; color:#276749; }
.ox-cell.val-X { background:#FED7D7; color:#9B2C2C; }

/* ── ○/△/⊙ 토글 셀 ── */
.tri-cell {
  min-width:28px; height:26px; cursor:pointer;
  border-radius:4px; font-size:14px; font-weight:700;
  display:flex; align-items:center; justify-content:center;
  margin:0 auto; transition:all .12s; user-select:none;
  touch-action:manipulation;
}
.tri-cell.val-ok   { background:#C6F6D5; color:#276749; }
.tri-cell.val-warn { background:#FEFCBF; color:#744210; }
.tri-cell.val-done { background:#BEE3F8; color:#1A365D; }

/* ── 텍스트 입력 셀 ── */
.ax-input {
  width:100%; border:none; background:transparent;
  font-size:12px; text-align:center; outline:none; padding:0;
}
.ax-input:focus { background:#EBF8FF; border-radius:3px; }

/* ── 노트 영역 ── */
/* 일반: col2Wrap 안에서 세로 배치 */
#notesArea { display:flex; flex-direction:column; gap:10px; }
/* 태블릿: mainLayout 우측 패널로 이동 — CSS는 동일, gap만 조정 */
body.tablet-mode #notesArea { gap:12px; }
.ax-textarea {
  width:100%; min-height:90px; border:1px solid var(--border);
  border-radius:6px; padding:8px 10px; font-size:12px;
  font-family:inherit; resize:vertical; outline:none;
  color:var(--text); background:var(--white); box-sizing:border-box;
}
.ax-textarea:focus { border-color:var(--primary); }

/* ── 태블릿 모드 버튼 ── */
.btn-tablet-toggle {
  padding:7px 14px; border-radius:8px; border:1px solid var(--border);
  background:var(--white); font-size:13px; font-weight:600;
  cursor:pointer; transition:all .15s; color:var(--text);
  touch-action:manipulation;
}
.btn-tablet-toggle.active { background:#2D3748; color:#fff; border-color:#2D3748; }

/* ── 태블릿 모드: 공통 크기 조정 ── */
body.tablet-mode .ax-table th { font-size:13px; padding:8px 6px; }
body.tablet-mode .ax-table td { padding:6px 4px; }
body.tablet-mode .ax-table td.left { font-size:12px; }
body.tablet-mode .ox-cell  { min-width:42px; height:42px; font-size:16px; }
body.tablet-mode .tri-cell { min-width:42px; height:42px; font-size:18px; }
body.tablet-mode .ax-input { font-size:14px; }
body.tablet-mode .ax-textarea { font-size:13px; min-height:140px; }
body.tablet-mode .btn-primary, body.tablet-mode .btn-outline { min-height:44px; font-size:14px; padding:10px 18px; }
body.tablet-mode .form-input { min-height:44px; font-size:14px; }
body.tablet-mode .ax-tab { padding:10px 24px; font-size:14px; }

/* ── 태블릿: 테이블 자동 확장 ── */
body.tablet-mode .ax-table { table-layout:auto !important; }
/* 태블릿에서 axGrid는 단일 열 (탭으로 하나만 보임) */
body.tablet-mode .ax-grid  { grid-template-columns:1fr !important; }

/* ── 태블릿: 구분 셀 가로 텍스트 ── */
body.tablet-mode .ax-table td.group-cell {
  writing-mode:horizontal-tb !important;
  text-orientation:mixed !important;
  letter-spacing:0 !important;
  width:auto !important;
  min-width:54px !important;
  padding:4px 6px !important;
  white-space:nowrap;
}

/* ── 레이아웃 ── */
#mainLayout       { display:contents; }
#tabletViewArea   { display:contents; }  /* 일반: 투명 래퍼 */

/* ── 태블릿: 4:1:1 그리드 (섹션 탭 | 유의사항 | 특기사항) ── */
body.tablet-mode #tabletViewArea {
  display:grid;
  grid-template-columns:4fr 1fr 1fr;
  gap:12px;
  align-items:stretch;  /* 세 열 높이 동일하게 */
}
/* notesArea의 두 카드를 그리드 직접 자식으로 올림 */
body.tablet-mode #tabletViewArea > #notesArea {
  display:contents;
}
/* 노트 카드: 그리드 셀 높이 100% 채우기 */
body.tablet-mode #tabletViewArea > #notesArea > .card {
  height:100%;
  box-sizing:border-box;
  display:flex;
  flex-direction:column;
}
/* 텍스트에어리어: 카드 내 남은 공간 전부 채우기 */
body.tablet-mode #tabletViewArea > #notesArea > .card .ax-textarea {
  flex:1;
  min-height:0;
  resize:none;
  font-size:13px;
}
</style>
<body>
<div class="page-wrap">

  <!-- 페이지 헤더 -->
  <div class="page-header">
    <div>
      <div class="page-title">부대설비 점검표</div>
      <div class="page-sub">옥외부대설비 · 콤프레샤 · N₂ GAS 일일 점검</div>
    </div>
    <div style="display:flex;gap:8px;flex-wrap:wrap;align-items:center">
      <button class="btn-tablet-toggle" id="btnTablet" onclick="toggleTabletMode()">📱 태블릿 모드</button>
      <input class="form-input" type="date" id="inspectDate" style="width:150px">
      <button class="btn-outline" onclick="loadData()">🔍 조회</button>
      <button class="btn-primary" id="btnSave" onclick="saveData()" data-perm="edit">💾 저장</button>
      <button class="btn-outline" onclick="doExcel()">📥 엑셀</button>
    </div>
  </div>

  <!-- 점검자 -->
  <div class="card" style="margin-bottom:12px;padding:12px 16px">
    <div style="display:flex;gap:20px;flex-wrap:wrap;align-items:center">
      <div class="form-field" style="margin:0;display:flex;align-items:center;gap:8px">
        <label class="form-label" style="margin:0;white-space:nowrap;font-weight:700">주간 점검자</label>
        <input class="form-input" type="text" id="dayInspector" placeholder="조 입력" style="width:120px">
      </div>
      <div class="form-field" style="margin:0;display:flex;align-items:center;gap:8px">
        <label class="form-label" style="margin:0;white-space:nowrap;font-weight:700">야간 점검자</label>
        <input class="form-input" type="text" id="nightInspector" placeholder="조 입력" style="width:120px">
      </div>
      <span id="saveStatus" style="font-size:12px;color:var(--muted)"></span>
    </div>
  </div>

  <div id="mainLayout">

    <!-- 좌: 탭 네비 + 점검 섹션들 -->
    <div id="sectionsWrap">

      <!-- 태블릿 탭 -->
      <div class="ax-tabs" id="axTabs" style="display:none">
        <button class="ax-tab active" onclick="showAxTab('outdoor',this)">옥외부대설비</button>
        <button class="ax-tab"       onclick="showAxTab('comp',this)">콤프레샤</button>
        <button class="ax-tab"       onclick="showAxTab('n2gas',this)">N₂ GAS</button>
      </div>

      <!-- 태블릿: 4:1:1 래퍼 (일반 모드에서는 display:contents로 투명) -->
      <div id="tabletViewArea">
      <!-- 3단 그리드 / 탭 콘텐츠 -->
      <div class="ax-grid" id="axGrid">

        <!-- ① 옥외부대설비 점검표 -->
        <div class="card ax-section" id="sec-outdoor">
          <div class="section-title">옥외부대설비 점검표</div>
          <div style="overflow-x:auto">
            <table class="ax-table" id="outdoorTable"></table>
          </div>
        </div>

        <!-- ② 콤프레샤 + 유의사항/특기사항 묶음 (일반 모드: 같은 열) -->
        <div id="col2Wrap">
          <div class="card ax-section" id="sec-comp">
            <div class="section-title">콤프레샤 점검표</div>
            <div class="section-note">(점검이상무 ○, 점검이상 △, 이상조치완료 ⊙)</div>
            <div style="overflow-x:auto">
              <table class="ax-table" id="compTable"></table>
            </div>
          </div>
          <!-- 유의사항/특기사항: 일반=여기(col2 하단), 태블릿=우측 패널(JS로 이동) -->
          <div id="notesArea">
            <div class="card" style="padding:12px 14px">
              <div style="font-size:12px;font-weight:700;margin-bottom:6px">※ 점검시 유의사항
                <small style="font-weight:400;color:var(--muted);margin-left:6px">(저장 시 다음 날 자동 인계)</small>
              </div>
              <textarea class="ax-textarea" id="notes" placeholder="유의사항을 입력하세요"></textarea>
            </div>
            <div class="card" style="padding:12px 14px">
              <div style="font-size:12px;font-weight:700;margin-bottom:6px">※ 특기사항
                <small style="font-weight:400;color:var(--muted);margin-left:6px">(저장 시 다음 날 자동 인계)</small>
              </div>
              <textarea class="ax-textarea" id="specialNotes" placeholder="특기사항을 입력하세요"></textarea>
            </div>
          </div><!-- /notesArea -->
        </div><!-- /col2Wrap -->

        <!-- ③ N2 GAS 일일 점검일지 -->
        <div class="card ax-section" id="sec-n2gas">
          <div class="section-title">N₂ GAS 일일 점검일지</div>
          <div class="section-note">(점검이상무 ○, 점검이상 △, 이상조치완료 ⊙)</div>
          <div style="overflow-x:auto">
            <table class="ax-table" id="n2gasTable"></table>
          </div>
        </div>

      </div><!-- /ax-grid -->
      <!-- notesArea가 JS로 여기(tabletViewArea)로 이동됨 (태블릿 모드) -->
      </div><!-- /tabletViewArea -->
    </div><!-- /sectionsWrap -->

  </div><!-- /mainLayout -->

</div>

<script>
var base = '${pageContext.request.contextPath}';
var canEdit = true;
var tabletMode = localStorage.getItem('ax_tablet_mode') === '1';

/* ══════════════════════════════════════════
   형식 정의
══════════════════════════════════════════ */
/* 옥외부대설비: gs=구분rowspan, ns=항목rowspan */
var OUTDOOR_ROWS = [
  /* 보일러단 9행 */
  {key:'1_1', no:1,  name:'온수온도',      std:'기화기내 50~70℃',                 sub:'1호',   group:'보일러단', gs:9, ns:2},
  {key:'1_2', no:1,  name:null,             std:null,                               sub:'2호',   group:null,       gs:0, ns:0},
  {key:'2_1', no:2,  name:'온수량',         std:'수위표시등 꺼짐보충<br>점등:물보충',sub:'1호',  group:null,       gs:0, ns:2},
  {key:'2_2', no:2,  name:null,             std:null,                               sub:'2호',   group:null,       gs:0, ns:0},
  {key:'3_1', no:3,  name:'Tank내 압력',    std:'1~13kgf/cm²',                     sub:'TANK.1',group:null,       gs:0, ns:2},
  {key:'3_2', no:3,  name:null,             std:null,                               sub:'TANK.2',group:null,       gs:0, ns:0},
  {key:'4_1', no:4,  name:'가스량 레벨',    std:'30%이상',                         sub:'TANK.1',group:null,       gs:0, ns:2},
  {key:'4_2', no:4,  name:null,             std:null,                               sub:'TANK.2',group:null,       gs:0, ns:0},
  {key:'5_0', no:5,  name:'공급압력',       std:'0.5~0.9kgf/cm²',                 sub:null,    group:null,       gs:0, ns:1},
  /* 암모니아 8행 */
  {key:'6_1', no:6,  name:'온수온도',       std:'기화기내 50~70℃',                sub:'1호',   group:'암모니아', gs:8, ns:2},
  {key:'6_2', no:6,  name:null,             std:null,                               sub:'2호',   group:null,       gs:0, ns:0},
  {key:'7_1', no:7,  name:'온수량',         std:'80%이상 유지',                    sub:'1호',   group:null,       gs:0, ns:2},
  {key:'7_2', no:7,  name:null,             std:null,                               sub:'2호',   group:null,       gs:0, ns:0},
  {key:'8_0', no:8,  name:'일차압력',       std:'3~13 kgf/cm²',                   sub:null,    group:null,       gs:0, ns:1},
  {key:'9_0', no:9,  name:'이차압력',       std:'3~13 kgf/cm²',                   sub:null,    group:null,       gs:0, ns:1},
  {key:'10_0',no:10, name:'공급압력',       std:'0.5~1.5kgf/cm²',                sub:null,    group:null,       gs:0, ns:1},
  {key:'11_0',no:11, name:'미사용 봄베수',  std:'갯수',                            sub:null,    group:null,       gs:0, ns:1},
  /* 냉각수 5행 */
  {key:'12_0',no:12, name:'가동PUMP호수',   std:'1호,2호',                        sub:null,    group:'냉각수',   gs:5, ns:1},
  {key:'13_0',no:13, name:'PUMP토출압력',   std:'2.5~4.5kgf/cm²',               sub:null,    group:null,       gs:0, ns:1},
  {key:'14_0',no:14, name:'PUMP 진동음',    std:'정상,이상',                      sub:null,    group:null,       gs:0, ns:1},
  {key:'15_0',no:15, name:'Tank 수위',      std:'2.7~3.7 m',                     sub:null,    group:null,       gs:0, ns:1},
  {key:'16_0',no:16, name:'냉각Tower(1,2)', std:'작동상태(정상,이상)',           sub:null,    group:null,       gs:0, ns:1}
];

var COMP_ITEMS = [
  {no:1, name:'모타의 소음상태 및<br>진동상태 유무',      std:'이상음 발생'},
  {no:2, name:'차압의 압력차를<br>확인한다',             std:'0.8 BAR 이하'},
  {no:3, name:'온도를 점검<br>기록한다',                 std:'90℃ 이하'},
  {no:4, name:'AIR DRYER의<br>이상상태를 확인한다',      std:'정등'},
  {no:5, name:'①의 OIL LEVEL<br>게이지 확인',           std:'투시창'}
];
var COMP_MACHINES = [1,3,4];

var N2GAS_ITEMS = [
  '저장실 주위에 인화 물질, 화기 방치여부(육안확인)',
  '설비장치의 작동여부(압력계 미작동시 고장으로 판단)',
  'GAS 차단장치의 작동여부(밸브확인)',
  '기화기 이상유무(성에 제거)',
  '안전장치작동유무(긴급차단밸브 확인)',
  'TANK내 압력계(10kgf/cm²이하)',
  '탱크, 배관 누설여부(육안, 소리로 확인)',
  'N₂ GAS량(1000이상 유지)',
  'N₂ GAS의 압력(7kgf/cm²이하)',
  '안전변의 원변은 열려있는가(안전밸브 open 여부 확인)'
];

/* ── 사이클 값 ── */
var OX_VALS   = ['','O','X'];
var TRI_VALS  = ['','○','△','⊙'];

/* ── 데이터 저장소 ── */
var outdoorData = {};
var compData    = {};
var n2gasData   = {};

/* ══════════════════════════════════════════
   초기화
══════════════════════════════════════════ */
fetch(base + '/perm/my')
  .then(function(r){ return r.json(); })
  .then(function(perms){
    var p = perms['auxiliary/inspection'] || {};
    canEdit = (p.canEdit !== 'N');
    if (!canEdit) {
      var btn = document.getElementById('btnSave');
      if (btn) btn.style.display = 'none';
    }
    initPage();
  })
  .catch(function(){ initPage(); });

function initPage() {
  var today = new Date().toISOString().slice(0,10);
  document.getElementById('inspectDate').value = today;
  applyTabletMode();
  buildTables();
  loadData();
}

/* ══════════════════════════════════════════
   태블릿 모드
══════════════════════════════════════════ */
function toggleTabletMode() {
  tabletMode = !tabletMode;
  localStorage.setItem('ax_tablet_mode', tabletMode ? '1' : '0');
  applyTabletMode();
}

function applyTabletMode() {
  var btn       = document.getElementById('btnTablet');
  var tabs      = document.getElementById('axTabs');
  var notesEl   = document.getElementById('notesArea');
  var tabletVA  = document.getElementById('tabletViewArea');
  var col2      = document.getElementById('col2Wrap');

  if (tabletMode) {
    document.body.classList.add('tablet-mode');
    if (btn)  { btn.classList.add('active'); btn.innerHTML = '💻 일반 모드'; }
    if (tabs) tabs.style.display = 'flex';  // 탭 표시
    // notesArea를 tabletViewArea 끝으로 이동 → display:contents로 두 카드가 4:1:1 그리드 3번째 자식이 됨
    if (notesEl && tabletVA && notesEl.parentElement !== tabletVA) tabletVA.appendChild(notesEl);
    // 탭 초기: outdoor 표시, 나머지 숨김
    ['sec-outdoor','col2Wrap','sec-n2gas'].forEach(function(id, i) {
      var el = document.getElementById(id);
      if (el) el.style.display = i === 0 ? '' : 'none';
    });
    // 탭 버튼 첫 번째 활성화
    var tabBtns = document.querySelectorAll('.ax-tab');
    tabBtns.forEach(function(b){ b.classList.remove('active'); });
    if (tabBtns[0]) tabBtns[0].classList.add('active');
  } else {
    document.body.classList.remove('tablet-mode');
    if (btn)  { btn.classList.remove('active'); btn.innerHTML = '📱 태블릿 모드'; }
    if (tabs) tabs.style.display = 'none';
    // notesArea를 col2Wrap으로 복귀
    if (notesEl && col2 && notesEl.parentElement !== col2) col2.appendChild(notesEl);
    // 3개 섹션 모두 표시
    ['sec-outdoor','col2Wrap','sec-n2gas'].forEach(function(id) {
      var el = document.getElementById(id);
      if (el) el.style.display = '';
    });
  }
}

function showAxTab(id, btn) {
  // comp 탭은 sec-comp가 아닌 col2Wrap을 show/hide
  var idMap = {outdoor:'sec-outdoor', comp:'col2Wrap', n2gas:'sec-n2gas'};
  ['outdoor','comp','n2gas'].forEach(function(s) {
    var el = document.getElementById(idMap[s]);
    if (el) el.style.display = s === id ? '' : 'none';
  });
  document.querySelectorAll('.ax-tab').forEach(function(b){ b.classList.remove('active'); });
  if (btn) btn.classList.add('active');
}

/* ══════════════════════════════════════════
   테이블 렌더링
══════════════════════════════════════════ */
function buildTables() {
  buildOutdoorTable();
  buildCompTable();
  buildN2GasTable();
}

/* ── 옥외부대설비 ── */
function buildOutdoorTable() {
  var h = '<thead><tr>'
    + '<th style="width:22px">구분</th>'
    + '<th style="width:22px">No</th>'
    + '<th style="width:68px">점검항목</th>'
    + '<th style="width:80px">관리기준</th>'
    + '<th style="width:36px">서브</th>'
    + '<th style="width:36px">주</th>'
    + '<th style="width:36px">야</th>'
    + '</tr></thead><tbody>';

  OUTDOOR_ROWS.forEach(function(row) {
    h += '<tr>';
    /* 구분 셀 */
    if (row.gs > 0) {
      h += '<td class="group-cell" rowspan="'+row.gs+'">'+row.group+'</td>';
    } else if (row.gs === 0 && row.group !== null) {
      h += '<td class="group-cell">'+row.group+'</td>';
    }
    /* No / 항목 / 기준 */
    if (row.ns > 0) {
      var rs = row.ns > 1 ? ' rowspan="'+row.ns+'"' : '';
      h += '<td'+rs+' style="text-align:center;font-weight:700">'+row.no+'</td>';
      h += '<td'+rs+' class="left">'+row.name+'</td>';
      h += '<td'+rs+' class="left" style="font-size:10px">'+row.std+'</td>';
    }
    /* 서브 */
    h += '<td style="font-size:10px;color:#718096">'+(row.sub||'')+'</td>';
    /* 주/야 입력 */
    h += '<td>'+makeOxCell(row.key,'day')+'</td>';
    h += '<td>'+makeOxCell(row.key,'night')+'</td>';
    h += '</tr>';
  });
  h += '</tbody>';
  document.getElementById('outdoorTable').innerHTML = h;
}

function makeOxCell(key, shift) {
  var id = 'od_'+key+'_'+shift;
  return '<div class="ox-cell" id="'+id+'" data-key="'+key+'" data-shift="'+shift+'" onclick="cycleOx(this)"></div>';
}

function cycleOx(el) {
  if (!canEdit) return;
  var key     = el.dataset.key;
  var shift   = el.dataset.shift;
  var flatKey = key + '_' + shift;
  var cur     = outdoorData[flatKey] || '';
  var idx     = OX_VALS.indexOf(cur);
  var next    = OX_VALS[(idx+1) % OX_VALS.length];
  outdoorData[flatKey] = next;
  el.textContent = next;
  el.className = 'ox-cell' + (next==='O'?' val-O':next==='X'?' val-X':'');
}

/* ── 콤프레샤 ── */
function buildCompTable() {
  var h = '<thead><tr>'
    + '<th style="width:22px">NO</th>'
    + '<th style="width:90px">점검사항</th>'
    + '<th style="width:46px">기준</th>';
  COMP_MACHINES.forEach(function(m){
    h += '<th style="width:44px">'+m+'호<br>주</th><th style="width:44px">'+m+'호<br>야</th>';
  });
  h += '</tr></thead><tbody>';

  COMP_ITEMS.forEach(function(item) {
    h += '<tr>';
    h += '<td style="font-weight:700">'+item.no+'</td>';
    h += '<td class="left">'+item.name+'</td>';
    h += '<td style="font-size:10px">'+item.std+'</td>';
    COMP_MACHINES.forEach(function(m) {
      h += '<td>'+makeTriCell('comp',item.no,m,'day')+'</td>';
      h += '<td>'+makeTriCell('comp',item.no,m,'night')+'</td>';
    });
    h += '</tr>';
  });
  h += '</tbody>';
  document.getElementById('compTable').innerHTML = h;
}

function makeTriCell(sect, no, machine, shift) {
  var id = sect+'_'+no+'_'+machine+'_'+shift;
  return '<div class="tri-cell" id="'+id+'" data-no="'+no+'" data-m="'+machine+'" data-shift="'+shift+'" onclick="cycleTri(this,\''+sect+'\')"></div>';
}

function cycleTri(el, sect) {
  if (!canEdit) return;
  var no      = el.dataset.no;
  var m       = el.dataset.m;
  var shift   = el.dataset.shift;
  var store   = sect === 'comp' ? compData : n2gasData;
  var baseKey = sect === 'comp' ? (no+'_'+m) : (''+no);
  var flatKey = baseKey + '_' + shift;
  var cur     = store[flatKey] || '';
  var idx     = TRI_VALS.indexOf(cur);
  var next    = TRI_VALS[(idx+1) % TRI_VALS.length];
  store[flatKey] = next;
  el.textContent = next;
  el.className = 'tri-cell' + (next==='○'?' val-ok':next==='△'?' val-warn':next==='⊙'?' val-done':'');
}

/* ── N2 GAS ── */
function buildN2GasTable() {
  var h = '<thead><tr>'
    + '<th style="width:22px">No</th>'
    + '<th>점검사항</th>'
    + '<th style="width:34px">주</th>'
    + '<th style="width:34px">야</th>'
    + '</tr></thead><tbody>';
  N2GAS_ITEMS.forEach(function(name, i) {
    var no = i + 1;
    h += '<tr>';
    h += '<td style="font-weight:700">'+no+'</td>';
    h += '<td class="left">'+name+'</td>';
    h += '<td>'+makeTriCell('n2',no,null,'day')+'</td>';
    h += '<td>'+makeTriCell('n2',no,null,'night')+'</td>';
    h += '</tr>';
  });
  h += '</tbody>';
  document.getElementById('n2gasTable').innerHTML = h;
}

/* ── N2 GAS 별칭 수정 ── */
// makeTriCell 에서 n2는 machine=null이므로 id 조정
// 이미 data-m="null"로 저장되나, 키 계산을 no만으로 맞춰야 함
// → cycleTri에서 sect==='n2'이면 mapKey=no 처리 (위에 구현됨)

/* ══════════════════════════════════════════
   데이터 로드
══════════════════════════════════════════ */
function loadData() {
  var date = document.getElementById('inspectDate').value;
  if (!date) return;
  fetch(base + '/auxiliary/inspection/data?date=' + date)
    .then(function(r){ return r.json(); })
    .then(function(res){
      if (!res.success) { alert(res.error || '조회 실패'); return; }
      var d = res.data || {};
      document.getElementById('dayInspector').value   = d.day_inspector   || '';
      document.getElementById('nightInspector').value = d.night_inspector || '';
      document.getElementById('notes').value          = d.notes           || '';
      document.getElementById('specialNotes').value   = d.special_notes   || '';

      outdoorData = safeJson(d.outdoor_data);
      compData    = safeJson(d.comp_data);
      n2gasData   = safeJson(d.n2gas_data);

      applyOutdoor();
      applyComp();
      applyN2Gas();

      var status = res.isNew ? '📄 새 기록 (유의사항/특기사항은 이전 기록에서 인계됨)' : '✅ 저장된 기록';
      document.getElementById('saveStatus').textContent = status;
    });
}

function safeJson(s) {
  if (!s) return {};
  try { return JSON.parse(s); } catch(e) { return {}; }
}

function applyOutdoor() {
  OUTDOOR_ROWS.forEach(function(row) {
    ['day','night'].forEach(function(shift) {
      var el = document.getElementById('od_'+row.key+'_'+shift);
      if (!el) return;
      var val = outdoorData[row.key+'_'+shift] || '';
      el.textContent = val;
      el.className = 'ox-cell' + (val==='O'?' val-O':val==='X'?' val-X':'');
    });
  });
}

function applyComp() {
  COMP_ITEMS.forEach(function(item) {
    COMP_MACHINES.forEach(function(m) {
      ['day','night'].forEach(function(shift) {
        var el = document.getElementById('comp_'+item.no+'_'+m+'_'+shift);
        if (!el) return;
        var val = compData[item.no+'_'+m+'_'+shift] || '';
        el.textContent = val;
        el.className = 'tri-cell' + (val==='○'?' val-ok':val==='△'?' val-warn':val==='⊙'?' val-done':'');
      });
    });
  });
}

function applyN2Gas() {
  N2GAS_ITEMS.forEach(function(name, i) {
    var no = i + 1;
    ['day','night'].forEach(function(shift) {
      var el = document.getElementById('n2_'+no+'_null_'+shift);
      if (!el) return;
      var val = n2gasData[no+'_'+shift] || '';
      el.textContent = val;
      el.className = 'tri-cell' + (val==='○'?' val-ok':val==='△'?' val-warn':val==='⊙'?' val-done':'');
    });
  });
}

/* ══════════════════════════════════════════
   저장
══════════════════════════════════════════ */
function saveData() {
  var date = document.getElementById('inspectDate').value;
  if (!date) { alert('날짜를 선택하세요.'); return; }

  var payload = {
    inspect_date:    date,
    day_inspector:   document.getElementById('dayInspector').value.trim(),
    night_inspector: document.getElementById('nightInspector').value.trim(),
    outdoor_data:    JSON.stringify(outdoorData),
    comp_data:       JSON.stringify(compData),
    n2gas_data:      JSON.stringify(n2gasData),
    notes:           document.getElementById('notes').value,
    special_notes:   document.getElementById('specialNotes').value
  };

  fetch(base + '/auxiliary/inspection/save', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify(payload)
  }).then(function(r){ return r.json(); })
    .then(function(res){
      if (!res.success) { alert(res.error || '저장 실패'); return; }
      document.getElementById('saveStatus').textContent = '✅ 저장 완료';
    });
}

/* ══════════════════════════════════════════
   엑셀
══════════════════════════════════════════ */
function doExcel() {
  var date = document.getElementById('inspectDate').value;
  if (!date) { alert('날짜를 선택하세요.'); return; }
  location.href = base + '/auxiliary/inspection/excel?date=' + date;
}
</script>
</body>
</html>
