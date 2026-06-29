<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common_style.jsp" %>
<style>
html, body { touch-action: manipulation; }

/* 상단 네비 */
.tb-nav {
  display:flex; align-items:center; justify-content:space-between;
  padding:12px 18px; background:var(--primary); color:#fff;
  border-radius:12px; margin-bottom:16px;
  box-shadow:0 4px 16px rgba(49,130,206,.25);
}
.tb-nav-title { font-size:20px; font-weight:800; letter-spacing:.3px; }
.tb-nav-sub   { font-size:13px; opacity:.8; margin-top:2px; }
.tb-nav-right { display:flex; gap:10px; align-items:center; }
.tb-btn-back {
  padding:10px 20px; border-radius:10px; border:2px solid rgba(255,255,255,.6);
  background:rgba(255,255,255,.15); color:#fff; font-size:14px; font-weight:700;
  cursor:pointer; transition:background .15s; white-space:nowrap;
}
.tb-btn-back:hover { background:rgba(255,255,255,.3); }
.tb-saved { font-size:14px; font-weight:600; color:#C6F6D5; }

/* 컨트롤 */
.tb-ctrl {
  display:flex; gap:14px; flex-wrap:wrap; align-items:flex-end;
  background:var(--white); border:1px solid var(--border);
  border-radius:12px; padding:16px 20px; margin-bottom:14px;
  box-shadow:var(--shadow);
}
.tb-ctrl label { font-size:13px; color:var(--muted); font-weight:700; display:block; margin-bottom:6px; }
.tb-ctrl select, .tb-ctrl input[type="month"] {
  height:50px; font-size:16px; padding:0 14px; border-radius:10px;
  border:2px solid var(--border); background:var(--white); outline:none;
}
.tb-ctrl select:focus, .tb-ctrl input:focus { border-color:var(--primary); }
.tb-load-btn {
  height:50px; padding:0 24px; border-radius:10px; border:none;
  background:var(--primary); color:#fff; font-size:16px; font-weight:700; cursor:pointer;
}
.tb-load-btn:hover { background:var(--primary-d, #2563EB); }

/* 점검자 */
.tb-signer {
  display:flex; gap:14px; align-items:center; flex-wrap:wrap;
  background:var(--white); border:1px solid var(--border);
  border-radius:12px; padding:14px 20px; margin-bottom:14px;
  box-shadow:var(--shadow);
}
.tb-signer label { font-size:13px; color:var(--muted); font-weight:700; }
.tb-signer input {
  height:50px; font-size:16px; padding:0 14px; border-radius:10px;
  border:2px solid var(--border); width:150px; outline:none;
}
.tb-signer input:focus { border-color:var(--primary); }
.tb-signer input[readonly] { background:var(--bg); }
.status-badge { font-size:13px; padding:5px 14px; border-radius:10px; font-weight:700; }
.status-DONE { background:var(--green-l); color:var(--green); border:1px solid #9AE6B4; }
.status-TEMP { background:var(--orange-l); color:var(--orange); border:1px solid #FBD38D; }

/* 주차 네비 */
.week-nav {
  display:flex; align-items:center; justify-content:center; gap:20px; margin-bottom:14px;
}
.wk-btn {
  width:52px; height:52px; border-radius:12px; border:2px solid var(--border);
  background:var(--white); font-size:24px; cursor:pointer; transition:all .15s;
  display:flex; align-items:center; justify-content:center; font-weight:700;
}
.wk-btn:hover:not(:disabled) { border-color:var(--primary); color:var(--primary); background:var(--primary-l); }
.wk-btn:disabled { opacity:.3; cursor:default; }
.wk-label {
  font-size:18px; font-weight:800; color:var(--text); min-width:200px; text-align:center;
}

/* 매트릭스 */
.tb-wrap { overflow-x:auto; border-radius:12px; }
.tb-table { border-collapse:collapse; width:100%; min-width:500px; }
.tb-table th {
  background:var(--bg); border:1px solid var(--border);
  padding:10px 6px; font-size:13px; font-weight:800;
  color:var(--muted); text-align:center; white-space:nowrap;
}
.tb-table th.t-item  { text-align:left; min-width:180px; position:sticky; left:0; z-index:2; background:var(--bg); }
.tb-table th.t-day   { background:#EBF8FF; color:var(--primary); min-width:110px;
                        font-size:16px; border-bottom:none; }
.tb-table th.t-day.today-col { background:#BEE3F8; }
.tb-table th.t-sh    { font-size:13px; min-width:90px; border-top:none; }
.tb-table th.t-sh.today-col { background:#EBF8FF; }

.tb-table td { border:1px solid var(--border); vertical-align:middle; padding:0; }
.tb-table td.t-name {
  padding:12px 14px; font-size:15px; font-weight:700;
  position:sticky; left:0; background:var(--white); z-index:1;
}
.tb-table td.today-cell { background:#EBF8FF !important; }
.tb-table tbody tr:hover td { background:var(--primary-l); }
.tb-table tbody tr:hover td.t-name { background:var(--primary-l); }

/* 수치 입력 */
.tb-input {
  width:100%; height:56px; border:none; background:transparent;
  text-align:center; font-size:20px; font-weight:700;
  color:var(--text); outline:none;
}
.tb-input:focus { background:#EBF8FF; border-radius:6px; }
.tb-input.has-val { background:#F0FFF4; color:#276749; }
.tb-input[data-shift="N"].has-val { background:#FEFCBF; color:#744210; }
.tb-input.is-check { font-size:28px !important; font-weight:900 !important;
  color:var(--green) !important; background:#F0FFF4 !important; }

/* 하단 */
.tb-footer { display:flex; justify-content:flex-end; margin-top:16px; gap:12px; align-items:center; }
.tb-done-btn {
  height:56px; padding:0 36px; border-radius:12px; border:none;
  background:var(--green); color:#fff; font-size:17px; font-weight:800; cursor:pointer;
}
.tb-done-btn:hover { background:#276749; }

/* ── 사진 컬럼 ── */
.tb-table th.t-photo { min-width:170px; width:170px; }
.tb-table td.t-photo-cell { padding:8px 10px; text-align:center; vertical-align:middle; }
.tb-img {
  width:150px; height:112px; object-fit:cover; border-radius:10px;
  border:2px solid var(--border); display:block; margin:0 auto; background:var(--bg);
  cursor:zoom-in; transition:transform .12s, box-shadow .12s;
}
.tb-img:hover { transform:scale(1.04); box-shadow:0 4px 16px rgba(0,0,0,.18); }
.tb-img-none { color:#CBD5E0; font-size:28px; line-height:112px; }

/* ── 사진 확대 라이트박스 ── */
#imgLightbox {
  display:none; position:fixed; inset:0; background:rgba(0,0,0,.82);
  z-index:9999; align-items:center; justify-content:center;
  cursor:zoom-out;
}
#imgLightbox.show { display:flex; }
#imgLightbox img {
  max-width:92vw; max-height:88vh; border-radius:12px;
  box-shadow:0 8px 48px rgba(0,0,0,.6); object-fit:contain;
  pointer-events:none;
}
#imgLightbox .lb-close {
  position:fixed; top:18px; right:22px; color:#fff; font-size:36px;
  font-weight:300; cursor:zoom-out; line-height:1; user-select:none;
}
#imgLightbox .lb-caption {
  position:fixed; bottom:22px; left:50%; transform:translateX(-50%);
  color:#fff; font-size:14px; background:rgba(0,0,0,.55);
  padding:6px 18px; border-radius:20px; pointer-events:none;
  white-space:nowrap; max-width:80vw; overflow:hidden; text-overflow:ellipsis;
}

@media (max-width:640px) {
  .tb-nav-title { font-size:16px; }
  .tb-ctrl { flex-direction:column; }
  .tb-signer { flex-direction:column; align-items:flex-start; }
  .tb-table th.t-item { min-width:130px; }
  .tb-table th.t-photo { min-width:120px; width:120px; }
  .tb-img { width:104px; height:78px; }
  .tb-img-none { line-height:78px; }
  .tb-input { height:48px; font-size:17px; }
}
</style>
<body>
<div class="page-wrap">

  <!-- 상단 네비 -->
  <div class="tb-nav">
    <div>
      <div class="tb-nav-title">📋 일상점검일지</div>
      <div class="tb-nav-sub" id="tbSubTitle">설비를 선택하세요</div>
    </div>
    <div class="tb-nav-right">
      <span class="tb-saved" id="tbSaved"></span>
      <button class="tb-btn-back" onclick="goBack()">← 일반 모드</button>
    </div>
  </div>

  <!-- 컨트롤 -->
  <div class="tb-ctrl">
    <div>
      <label>점검월</label>
      <input type="month" id="tbYm">
    </div>
    <div>
      <label>설비</label>
      <select id="tbEquip">
        <option>BCF_1</option><option>BCF_2</option><option>BCF_3</option>
        <option>BCF_4</option><option>BCF_5</option><option>BCF_6</option>
        <option>BCF_7</option><option>BCF_8</option><option>BCF_9</option>
        <option>BCF_10</option><option>BCF_11</option><option>BCF_12</option>
      </select>
    </div>
    <button class="tb-load-btn" onclick="loadData()">조회</button>
  </div>

  <!-- 점검자 -->
  <div class="tb-signer">
    <div>
      <label>점검자</label>
      <input type="text" id="tbInspector" readonly>
    </div>
    <div>
      <label>확인자</label>
      <input type="text" id="tbConfirmer" placeholder="성명 입력" onchange="autoSaveHeader()">
    </div>
    <span id="tbStatus" class="status-badge status-TEMP" style="margin-left:auto">임시저장</span>
  </div>

  <!-- 주차 네비 -->
  <div class="week-nav">
    <button class="wk-btn" id="btnPrev" onclick="prevWeek()">‹</button>
    <div class="wk-label" id="wkLabel">-</div>
    <button class="wk-btn" id="btnNext" onclick="nextWeek()">›</button>
  </div>

  <!-- 테이블 -->
  <div class="card" style="padding:14px">
    <div class="tb-wrap">
      <table class="tb-table" id="tbTable">
        <thead id="tbHead"></thead>
        <tbody id="tbBody">
          <tr><td colspan="3" style="text-align:center;padding:70px;color:var(--muted);font-size:16px">
            조회 버튼을 눌러 데이터를 불러오세요
          </td></tr>
        </tbody>
      </table>
    </div>
  </div>

  <!-- 하단 -->
  <div class="tb-footer">
    <button class="tb-done-btn" onclick="saveDone()">✅ 점검완료</button>
  </div>
</div>

<!-- 사진 확대 라이트박스 -->
<div id="imgLightbox" onclick="closeLightbox()">
  <span class="lb-close">✕</span>
  <img id="lbImg" src="" alt="">
  <div class="lb-caption" id="lbCaption"></div>
</div>

<script>
var base        = '${pageContext.request.contextPath}';
var curData     = null;

/* 사이드바 숨김 (부모 프레임) */
(function(){
  try {
    var p = window.parent;
    if (p && p !== window) {
      var sb = p.document.getElementById('sidebar');
      if (sb) { sb.dataset.tbHidden = '1'; sb.style.display = 'none'; }
    }
  } catch(e) {}
})();
window.addEventListener('beforeunload', function(){
  try {
    var p = window.parent;
    if (p && p !== window) {
      var sb = p.document.getElementById('sidebar');
      if (sb && sb.dataset.tbHidden === '1') { sb.style.display = ''; delete sb.dataset.tbHidden; }
    }
  } catch(e) {}
});
var selYm       = '';
var selEquip    = '';
var curWkStart  = 1;
var daysInMonth = 31;
var WEEK        = 7;
var today       = new Date();

/* ── 초기화 ── */
(function(){
  var params = new URLSearchParams(location.search);
  var d = new Date();
  var ym = params.get('ym') || (d.getFullYear() + String(d.getMonth()+1).padStart(2,'0'));
  document.getElementById('tbYm').value = ym.length===6 ? ym.substring(0,4)+'-'+ym.substring(4) : ym;

  var eq = params.get('equipId');
  if(eq){
    var sel = document.getElementById('tbEquip');
    for(var i=0;i<sel.options.length;i++){
      if(sel.options[i].value===eq){ sel.selectedIndex=i; break; }
    }
  }

  var todayYm = String(today.getFullYear()) + String(today.getMonth()+1).padStart(2,'0');
  var qYm = params.get('ym') || todayYm;
  curWkStart = (qYm === todayYm)
    ? Math.floor((today.getDate()-1)/WEEK)*WEEK + 1
    : 1;

  loadData();
})();

function goBack(){
  selYm    = document.getElementById('tbYm').value.replace('-','');
  selEquip = document.getElementById('tbEquip').value;
  var q = selEquip ? '?equipId='+encodeURIComponent(selEquip)+'&ym='+selYm : '';
  location.href = base + '/main_1/inspect/daily' + q;
}

function loadData(){
  selYm    = document.getElementById('tbYm').value.replace('-','');
  selEquip = document.getElementById('tbEquip').value;
  if(!selYm || !selEquip) return;

  fetch(base + '/inspect/load?equipId='+selEquip+'&ym='+selYm)
    .then(function(r){ return r.json(); })
    .then(function(d){
      curData = d;
      daysInMonth = d.daysInMonth || 31;
      document.getElementById('tbInspector').value = d.inspectorName || d.loginName || '';
      document.getElementById('tbConfirmer').value = d.confirmerName || '';
      setStatus(d.status || 'TEMP');
      var ymFmt = selYm.substring(0,4)+'년 '+parseInt(selYm.substring(4))+'월';
      document.getElementById('tbSubTitle').textContent = selEquip + ' · ' + ymFmt;
      if(curWkStart > daysInMonth) curWkStart = 1;
      renderWeek();
    })
    .catch(function(){ alert('데이터 로드 실패'); });
}

function prevWeek(){ curWkStart = Math.max(1, curWkStart-WEEK); renderWeek(); }
function nextWeek(){
  var next = curWkStart + WEEK;
  if(next <= daysInMonth){ curWkStart = next; renderWeek(); }
}

function renderWeek(){
  if(!curData) return;
  var items   = curData.items || [];
  var wkEnd   = Math.min(curWkStart + WEEK - 1, daysInMonth);
  var todayYm = String(today.getFullYear()) + String(today.getMonth()+1).padStart(2,'0');
  var todayDay = (selYm === todayYm) ? today.getDate() : -1;
  var wkNo    = Math.ceil(curWkStart / WEEK);

  document.getElementById('wkLabel').textContent =
    wkNo + '주차  (' + curWkStart + '일 ~ ' + wkEnd + '일)';
  document.getElementById('btnPrev').disabled = (curWkStart <= 1);
  document.getElementById('btnNext').disabled = (wkEnd >= daysInMonth);

  /* 헤더 1행 */
  var h1 = '<tr><th class="t-item" rowspan="2">점검 항목</th>'
         + '<th class="t-photo" rowspan="2">사진</th>';
  for(var day=curWkStart; day<=wkEnd; day++){
    var tc = (day===todayDay) ? ' today-col' : '';
    h1 += '<th class="t-day' + tc + '" colspan="2">' + day + '일</th>';
  }
  h1 += '</tr>';

  /* 헤더 2행 */
  var h2 = '<tr>';
  for(var day=curWkStart; day<=wkEnd; day++){
    var tc = (day===todayDay) ? ' today-col' : '';
    h2 += '<th class="t-sh' + tc + '">주간</th><th class="t-sh' + tc + '">야간</th>';
  }
  h2 += '</tr>';
  document.getElementById('tbHead').innerHTML = h1 + h2;

  /* 바디 */
  if(!items.length){
    var cols = (wkEnd - curWkStart + 1) * 2 + 2;
    document.getElementById('tbBody').innerHTML =
      '<tr><td colspan="'+cols+'" style="text-align:center;padding:70px;color:var(--muted);font-size:16px">점검 항목이 없습니다</td></tr>';
    return;
  }

  var html = '';
  items.forEach(function(item){
    var results = item.results || {};
    var imgHtml = item.imgFile
      ? '<img class="tb-img" src="' + base + '/inspect/item/image/' + esc(item.imgFile) + '" alt="' + esc(item.itemName) + '" onclick="openLightbox(this)">'
      : '<span class="tb-img-none">—</span>';
    html += '<tr><td class="t-name">' + esc(item.itemName) + '</td>'
          + '<td class="t-photo-cell">' + imgHtml + '</td>';
    for(var day=curWkStart; day<=wkEnd; day++){
      var dayRes = results[day] || results[String(day)] || {};
      var dVal   = dayRes.D != null ? dayRes.D : '';
      var nVal   = dayRes.N != null ? dayRes.N : '';
      var tc     = (day===todayDay) ? ' today-cell' : '';
      html += mkCell(item.itemId, day, 'D', dVal, tc);
      html += mkCell(item.itemId, day, 'N', nVal, tc);
    }
    html += '</tr>';
  });
  document.getElementById('tbBody').innerHTML = html;
}

function mkCell(itemId, day, shift, val, extraCls){
  var disp   = (val === 99 || val === '99') ? '√' : (val !== '' && val != null ? String(val) : '');
  var hasCls = disp !== '' ? ' has-val' : '';
  var chkCls = disp === '√' ? ' is-check' : '';
  return '<td class="' + extraCls + '" style="padding:3px">'
    + '<input type="text" inputmode="numeric" class="tb-input' + hasCls + chkCls + '"'
    + ' data-item="' + itemId + '" data-day="' + day + '" data-shift="' + shift + '"'
    + ' value="' + esc(disp) + '" placeholder="—"'
    + ' onfocus="onInspFocus(this)" oninput="onInspInput(this)" onblur="saveCell(this)">'
    + '</td>';
}

function onInspFocus(input){
  if(input.value === '√'){ input.value = '99'; input.select(); }
}
function onInspInput(input){
  var v = input.value;
  if(v === '99'){
    input.value = '√';
    input.classList.add('is-check', 'has-val');
  } else {
    input.classList.remove('is-check');
    input.classList.toggle('has-val', v !== '');
  }
}
function saveCell(input){
  if(input.value === '99'){ input.value='√'; input.classList.add('is-check','has-val'); }
  var rawVal = input.value === '√' ? '99' : input.value;
  fetch(base + '/inspect/result/cell', {
    method:'POST', headers:{'Content-Type':'application/json'},
    body: JSON.stringify({
      equipId: selEquip, ym: selYm,
      day:    parseInt(input.dataset.day),
      itemId: parseInt(input.dataset.item),
      shift:  input.dataset.shift,
      val:    rawVal
    })
  }).then(function(r){ return r.json(); })
    .then(function(d){ if(d.success){ showSaved(); setStatus('TEMP'); } });
}

function saveDone(){
  if(!confirm('점검 완료로 저장하시겠습니까?')) return;
  fetch(base + '/inspect/header/save', {
    method:'POST', headers:{'Content-Type':'application/json'},
    body: JSON.stringify({
      equipId: selEquip, ym: selYm,
      inspector: document.getElementById('tbInspector').value,
      confirmer: document.getElementById('tbConfirmer').value,
      status: 'DONE'
    })
  }).then(function(r){ return r.json(); })
    .then(function(d){
      if(d.success){ setStatus('DONE'); alert('점검 완료 저장되었습니다.'); }
      else alert(d.error||'저장 실패');
    });
}

function autoSaveHeader(){
  fetch(base + '/inspect/header/save', {
    method:'POST', headers:{'Content-Type':'application/json'},
    body: JSON.stringify({
      equipId: selEquip, ym: selYm,
      inspector: document.getElementById('tbInspector').value,
      confirmer: document.getElementById('tbConfirmer').value,
      status: 'TEMP'
    })
  });
}

function setStatus(st){
  var el = document.getElementById('tbStatus');
  el.textContent = st==='DONE' ? '완료' : '임시저장';
  el.className   = 'status-badge status-' + st;
}
var savedTimer = null;
function showSaved(){
  var el = document.getElementById('tbSaved');
  el.textContent = '✓ 저장됨';
  clearTimeout(savedTimer);
  savedTimer = setTimeout(function(){ el.textContent=''; }, 2500);
}
function esc(s){
  return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

/* ── 사진 확대 라이트박스 ── */
function openLightbox(img) {
  document.getElementById('lbImg').src = img.src;
  document.getElementById('lbCaption').textContent = img.alt || '';
  document.getElementById('imgLightbox').classList.add('show');
}
function closeLightbox() {
  document.getElementById('imgLightbox').classList.remove('show');
}
document.addEventListener('keydown', function(e){
  if (e.key === 'Escape') closeLightbox();
});
</script>
</body>
</html>
