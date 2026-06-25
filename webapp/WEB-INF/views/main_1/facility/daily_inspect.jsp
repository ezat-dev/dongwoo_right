<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common_style.jsp" %>
<style>
.ctrl-bar { display:flex; gap:10px; flex-wrap:wrap; align-items:flex-end; margin-bottom:16px; }

.signer-row {
  display:flex; gap:16px; flex-wrap:wrap; align-items:center;
  padding:10px 0 12px; border-bottom:1px solid var(--border); margin-bottom:0; font-size:13px;
}
.signer-row label { font-size:11px; color:var(--muted); font-weight:600; margin-right:4px; }

.matrix-wrap { overflow-x:auto; }
.matrix-table {
  border-collapse:collapse; font-size:12px; white-space:nowrap; min-width:100%;
}
.matrix-table th {
  background:var(--bg); padding:6px 4px; text-align:center;
  font-size:11px; font-weight:700; color:var(--muted);
  border:1px solid var(--border); white-space:nowrap;
  position:sticky; top:0; z-index:2;
}
.matrix-table th.item-col { text-align:left; min-width:130px; position:sticky; left:0; z-index:3; }
.matrix-table th.std-col  { text-align:left; min-width:140px; }
.matrix-table th.img-col  { min-width:60px; width:60px; }
.matrix-table th.day-hd   { min-width:96px; font-size:11px; color:var(--primary);
                             background:#EBF8FF; border-bottom:none; }
.matrix-table th.day-hd.today-col { background:#BEE3F8; }
.matrix-table th.sh-hd    { min-width:48px; width:48px; font-size:10px; font-weight:700;
                             background:var(--bg); border-top:none; }
.matrix-table th.sh-hd.today-col { background:#EBF8FF; }

.matrix-table td {
  padding:0; border:1px solid var(--border); vertical-align:middle;
}
.matrix-table td.item-name {
  padding:6px 10px; font-weight:600; font-size:12px;
  position:sticky; left:0; background:var(--white); z-index:1;
}
.matrix-table td.item-std { padding:6px 10px; color:var(--muted); font-size:11px; }
.matrix-table td.img-cell { padding:4px 6px; text-align:center; vertical-align:middle; }
.matrix-table td.sh-cell  { padding:2px !important; }
.matrix-table td.today-col { background:#EBF8FF !important; }
.matrix-table tbody tr:hover td { background:var(--primary-l); }
.matrix-table tbody tr:hover td.item-name { background:var(--primary-l); }

/* 수치 입력 */
.val-input {
  width:100%; height:34px; border:none; background:transparent;
  text-align:center; font-size:12px; font-weight:600;
  color:var(--text); outline:none;
}
.val-input:focus { background:#EBF8FF; border-radius:3px; }
.val-input.has-val { background:#F0FFF4; color:#276749; }
.val-input[data-shift="N"].has-val { background:#FEFCBF; color:#744210; }
.val-input.is-check { font-size:17px !important; font-weight:900 !important;
  color:var(--green) !important; background:#F0FFF4 !important; }

/* 편집 모드 */
.edit-item-btns { display:none; gap:4px; padding:2px 4px; }
.edit-item-btns.show { display:flex; }
.eib { padding:2px 6px; font-size:10px; border-radius:4px; border:1px solid var(--border);
  background:none; cursor:pointer; }
.eib-edit:hover { border-color:var(--primary); color:var(--primary); }
.eib-del:hover  { border-color:var(--red); color:var(--red); background:var(--red-l); }

.action-row { display:flex; gap:8px; flex-wrap:wrap; margin-top:14px; align-items:center; }
.status-badge { font-size:11px; padding:2px 8px; border-radius:10px; font-weight:600; }
.status-DONE { background:var(--green-l); color:var(--green); border:1px solid #9AE6B4; }
.status-TEMP { background:var(--orange-l); color:var(--orange); border:1px solid #FBD38D; }

.legend { display:flex; gap:10px; font-size:11px; color:var(--muted); align-items:center; flex-wrap:wrap; }

/* 모달 */
.modal-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,.4);
  z-index:200; align-items:center; justify-content:center; }
.modal-overlay.show { display:flex; }
.modal-box { background:var(--white); border-radius:14px; padding:24px 28px;
  width:420px; max-width:96vw; box-shadow:0 8px 40px rgba(0,0,0,.18); }
.modal-title { font-size:15px; font-weight:700; margin-bottom:16px; }
.modal-notice { font-size:11px; color:var(--orange); margin-bottom:14px;
  padding:7px 10px; background:var(--orange-l); border-radius:6px; }
.modal-actions { display:flex; justify-content:flex-end; gap:8px; margin-top:20px; }

/* 이미지 */
.img-thumb {
  width:48px; height:36px; object-fit:cover; border-radius:4px;
  cursor:pointer; border:1px solid var(--border); display:block; margin:0 auto 2px;
}
.img-thumb:hover { opacity:.8; }
.img-upload-btn {
  font-size:11px; padding:1px 6px; border:1px dashed var(--border);
  border-radius:4px; background:none; cursor:pointer; color:var(--muted);
  display:none; margin:0 auto;
}
.img-upload-btn:hover { border-color:var(--primary); color:var(--primary); }
.edit-mode .img-upload-btn { display:block; }
#imgPreviewModal .modal-box { width:640px; text-align:center; }
#imgPreviewModal img { max-width:100%; max-height:72vh; border-radius:8px; }

@media (max-width:640px) {
  .hide-mobile { display:none !important; }
  .matrix-table th.std-col,
  .matrix-table td.item-std { display:none; }
  .val-input { height:40px; font-size:13px; }
  .matrix-table th.sh-hd { min-width:42px; width:42px; }
  .page-header { flex-direction:column; gap:10px; }
  .page-header > div:last-child { flex-wrap:wrap; gap:6px; width:100%; }
  .page-header > div:last-child button { flex:1; }
}
</style>
<body>
<div class="page-wrap">
  <div class="page-header">
    <div>
      <div class="page-title">일상점검일지</div>
      <div class="page-sub" id="pageSubTitle">설비를 선택하세요</div>
    </div>
    <div style="display:flex;gap:8px;flex-wrap:wrap">
      <button class="btn-outline" onclick="openTabletMode()">📱 태블릿 모드</button>
      <button class="btn-outline" onclick="toggleEditMode()" id="editModeBtn">✏️ 항목 편집</button>
      <button class="btn-outline" onclick="doExport()">📥 엑셀 출력</button>
      <label class="btn-outline" style="cursor:pointer;margin:0">
        📤 엑셀 가져오기<input type="file" id="importFile" accept=".xlsx" style="display:none" onchange="doImport(this)">
      </label>
      <button class="btn-primary" onclick="saveDone()">✅ 점검완료</button>
    </div>
  </div>

  <div class="card ctrl-bar" style="padding:14px 16px;margin-bottom:16px">
    <div class="form-field">
      <label class="form-label">점검월</label>
      <input class="form-input" type="month" id="selYm" style="width:140px">
    </div>
    <div class="form-field">
      <label class="form-label">설비</label>
      <select class="form-select" id="selEquip" style="width:140px">
        <option>BCF_1</option><option>BCF_2</option><option>BCF_3</option>
        <option>BCF_4</option><option>BCF_5</option><option>BCF_6</option>
        <option>BCF_7</option><option>BCF_8</option><option>BCF_9</option>
        <option>BCF_10</option><option>BCF_11</option><option>BCF_12</option>
      </select>
    </div>
    <button class="btn-primary btn-sm" style="margin-top:18px;height:34px" onclick="loadData()">조회</button>
    <div class="legend hide-mobile" style="margin-left:auto">
      <span style="display:inline-flex;align-items:center;gap:4px">
        <span style="width:12px;height:12px;background:#F0FFF4;border:1px solid #9AE6B4;border-radius:2px;display:inline-block"></span>주간 입력
      </span>
      <span style="display:inline-flex;align-items:center;gap:4px">
        <span style="width:12px;height:12px;background:#FEFCBF;border:1px solid #F6E05E;border-radius:2px;display:inline-block"></span>야간 입력
      </span>
    </div>
  </div>

  <div class="card" id="inspCard">
    <div class="signer-row">
      <div>
        <label>점검자</label>
        <input class="form-input" type="text" id="inspector" readonly style="background:var(--bg);width:100px">
      </div>
      <div>
        <label>확인자</label>
        <input class="form-input" type="text" id="confirmer" placeholder="성명 입력" style="width:110px"
               onchange="autoSaveHeader()">
      </div>
      <span id="statusBadge" class="status-badge status-TEMP" style="margin-left:auto">임시저장</span>
    </div>

    <div class="matrix-wrap" style="margin-top:12px">
      <table class="matrix-table" id="matrixTable">
        <thead id="matrixHead"></thead>
        <tbody id="matrixBody">
          <tr><td colspan="3" style="text-align:center;padding:40px;color:var(--muted)">
            조회 버튼을 눌러 데이터를 불러오세요
          </td></tr>
        </tbody>
      </table>
    </div>

    <div class="action-row">
      <button class="btn-outline btn-sm edit-col" style="display:none" onclick="openItemModal(null)">＋ 항목 추가</button>
      <span style="font-size:11px;color:var(--muted);margin-left:auto" id="savedMsg"></span>
    </div>
  </div>
</div>

<!-- 이미지 미리보기 모달 -->
<div class="modal-overlay" id="imgPreviewModal">
  <div class="modal-box">
    <div class="modal-title" id="imgPreviewTitle">이미지 미리보기</div>
    <img id="imgPreviewSrc" src="" alt="미리보기">
    <div class="modal-actions">
      <button class="btn-outline" onclick="document.getElementById('imgPreviewModal').classList.remove('show')">닫기</button>
    </div>
  </div>
</div>

<!-- 항목 추가/수정 모달 -->
<div class="modal-overlay" id="itemModal">
  <div class="modal-box">
    <div class="modal-title" id="itemModalTitle">항목 추가</div>
    <div class="modal-notice" id="itemModalNotice" style="display:none"></div>
    <input type="hidden" id="mItemId">
    <div class="form-field" style="margin-bottom:12px">
      <label class="form-label">점검 항목 *</label>
      <input class="form-input" type="text" id="mItemName" placeholder="예) 외관 점검" style="width:100%">
    </div>
    <div class="form-field">
      <label class="form-label">점검 기준</label>
      <input class="form-input" type="text" id="mItemStd" placeholder="예) 균열·변형 없음" style="width:100%">
    </div>
    <div class="modal-actions">
      <button class="btn-outline" onclick="closeItemModal()">취소</button>
      <button class="btn-primary" onclick="saveItem()">저장</button>
    </div>
  </div>
</div>

<script>
var base     = '${pageContext.request.contextPath}';
var editMode = false;
var curData  = null;
var selYm    = '';
var selEquip = '';
var today    = new Date();

(function(){
  var d = new Date();
  document.getElementById('selYm').value =
    d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0');
  loadData();
})();

function openTabletMode(){
  selYm    = document.getElementById('selYm').value.replace('-','');
  selEquip = document.getElementById('selEquip').value;
  var q = selEquip ? '?equipId=' + encodeURIComponent(selEquip) + '&ym=' + selYm : '';
  location.href = base + '/main_1/inspect/daily/tablet' + q;
}

function loadData(){
  selYm    = document.getElementById('selYm').value.replace('-','');
  selEquip = document.getElementById('selEquip').value;
  if(!selYm || !selEquip) return;

  fetch(base + '/inspect/load?equipId=' + selEquip + '&ym=' + selYm)
    .then(function(r){ return r.json(); })
    .then(function(d){
      curData = d;
      document.getElementById('inspector').value = d.inspectorName || d.loginName || '';
      document.getElementById('confirmer').value = d.confirmerName || '';
      setStatusBadge(d.status || 'TEMP');
      var ymFmt = selYm.substring(0,4) + '년 ' + parseInt(selYm.substring(4)) + '월';
      document.getElementById('pageSubTitle').textContent = selEquip + ' · ' + ymFmt;
      renderMatrix(d);
    })
    .catch(function(){ alert('데이터 로드 실패'); });
}

function renderMatrix(d){
  var days    = d.daysInMonth || 30;
  var items   = d.items || [];
  var todayYm = String(today.getFullYear()) + String(today.getMonth()+1).padStart(2,'0');
  var todayDay = (selYm === todayYm) ? today.getDate() : -1;

  /* 헤더 1행: 날짜 그룹 */
  var h1 = '<tr>'
    + '<th class="item-col" rowspan="2">점검 항목</th>'
    + '<th class="std-col" rowspan="2">점검 기준</th>'
    + '<th class="img-col" rowspan="2">IMG</th>';
  for(var day=1; day<=days; day++){
    var tc = (day===todayDay) ? ' today-col' : '';
    h1 += '<th class="day-hd' + tc + '" colspan="2">' + day + '일</th>';
  }
  h1 += '</tr>';

  /* 헤더 2행: 주간/야간 */
  var h2 = '<tr>';
  for(var day=1; day<=days; day++){
    var tc = (day===todayDay) ? ' today-col' : '';
    h2 += '<th class="sh-hd' + tc + '">주간</th><th class="sh-hd' + tc + '">야간</th>';
  }
  h2 += '</tr>';
  document.getElementById('matrixHead').innerHTML = h1 + h2;

  if(!items.length){
    document.getElementById('matrixBody').innerHTML =
      '<tr><td colspan="' + (days*2+3) + '" style="text-align:center;padding:40px;color:var(--muted)">'
      + '우상단 <strong>✏️ 항목 편집</strong> → <strong>＋ 항목 추가</strong> 로 항목을 등록하세요.'
      + '</td></tr>';
    return;
  }

  var html = '';
  items.forEach(function(item){
    var results = item.results || {};
    var imgCell = '';
    if(item.imgFile){
      imgCell = '<img src="' + base + '/inspect/item/image/' + esc(item.imgFile) + '" '
              + 'class="img-thumb" onclick="previewImg(\'' + esc(item.imgFile) + '\',\'' + esc(item.itemName) + '\')" '
              + 'title="' + esc(item.itemName) + '" alt="미리보기">';
    }
    imgCell += '<button class="img-upload-btn" onclick="openImgUpload(' + item.itemId + ')">＋</button>';

    html += '<tr>'
      + '<td class="item-name">'
      +   '<span>' + esc(item.itemName) + '</span>'
      +   '<div class="edit-item-btns' + (editMode?' show':'') + '" id="eib_' + item.itemId + '">'
      +     '<button class="eib eib-edit" onclick="openItemModal(' + item.itemId + ')">수정</button>'
      +     '<button class="eib eib-del"  onclick="delItem(' + item.itemId + ')">삭제</button>'
      +   '</div>'
      + '</td>'
      + '<td class="item-std">' + esc(item.itemStd || '') + '</td>'
      + '<td class="img-cell">' + imgCell + '</td>';

    for(var day=1; day<=days; day++){
      var dayRes = results[day] || results[String(day)] || {};
      var dVal   = dayRes.D != null ? dayRes.D : '';
      var nVal   = dayRes.N != null ? dayRes.N : '';
      var tc     = (day===todayDay) ? ' today-col' : '';
      html += mkCell(item.itemId, day, 'D', dVal, tc);
      html += mkCell(item.itemId, day, 'N', nVal, tc);
    }
    html += '</tr>';
  });
  document.getElementById('matrixBody').innerHTML = html;
}

function mkCell(itemId, day, shift, val, extraCls){
  var disp    = (val === 99 || val === '99') ? '√' : (val !== '' && val != null ? String(val) : '');
  var hasCls  = disp !== '' ? ' has-val' : '';
  var chkCls  = disp === '√' ? ' is-check' : '';
  return '<td class="sh-cell' + extraCls + '">'
    + '<input type="text" inputmode="numeric" class="val-input' + hasCls + chkCls + '"'
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
    input.classList.remove('is-check'); /* force repaint */
    input.classList.add('is-check');
  } else {
    input.classList.remove('is-check');
    input.classList.toggle('has-val', v !== '');
  }
}
function saveCell(input){
  /* 포커스 떠날 때 99 → √ 변환 보장 */
  if(input.value === '99'){ input.value='√'; input.classList.add('is-check','has-val'); }
  var rawVal = input.value === '√' ? '99' : input.value;
  fetch(base + '/inspect/result/cell', {
    method:'POST', headers:{'Content-Type':'application/json'},
    body: JSON.stringify({
      equipId: selEquip, ym: selYm,
      day:     parseInt(input.dataset.day),
      itemId:  parseInt(input.dataset.item),
      shift:   input.dataset.shift,
      val:     rawVal
    })
  }).then(function(r){ return r.json(); })
    .then(function(d){ if(d.success){ showSavedMsg(); setStatusBadge('TEMP'); } });
}

function saveDone(){
  if(!confirm('점검 완료로 저장하시겠습니까?')) return;
  fetch(base + '/inspect/header/save', {
    method:'POST', headers:{'Content-Type':'application/json'},
    body: JSON.stringify({
      equipId: selEquip, ym: selYm,
      inspector: document.getElementById('inspector').value,
      confirmer: document.getElementById('confirmer').value,
      status: 'DONE'
    })
  }).then(function(r){ return r.json(); })
    .then(function(d){
      if(d.success){ setStatusBadge('DONE'); alert('점검 완료 저장되었습니다.'); }
      else alert(d.error||'저장 실패');
    });
}

function autoSaveHeader(){
  fetch(base + '/inspect/header/save', {
    method:'POST', headers:{'Content-Type':'application/json'},
    body: JSON.stringify({
      equipId: selEquip, ym: selYm,
      inspector: document.getElementById('inspector').value,
      confirmer: document.getElementById('confirmer').value,
      status: 'TEMP'
    })
  });
}

function toggleEditMode(){
  editMode = !editMode;
  var btn = document.getElementById('editModeBtn');
  btn.textContent       = editMode ? '📋 편집 완료' : '✏️ 항목 편집';
  btn.style.background  = editMode ? 'var(--primary-l)' : '';
  btn.style.borderColor = editMode ? 'var(--primary)'   : '';
  btn.style.color       = editMode ? 'var(--primary)'   : '';
  document.querySelectorAll('.edit-col').forEach(function(el){ el.style.display = editMode?'':'none'; });
  document.querySelectorAll('.edit-item-btns').forEach(function(el){ el.classList.toggle('show', editMode); });
  var wrap = document.querySelector('.matrix-wrap');
  if(wrap) wrap.classList.toggle('edit-mode', editMode);
}

var imgUploadInput = document.createElement('input');
imgUploadInput.type = 'file'; imgUploadInput.accept = 'image/*';
var _imgUploadItemId = 0;
imgUploadInput.addEventListener('change', function(){
  var file = this.files[0];
  if(!file || !_imgUploadItemId) return;
  var fd = new FormData();
  fd.append('file', file); fd.append('itemId', _imgUploadItemId);
  fetch(base + '/inspect/item/image/upload', { method:'POST', body:fd })
    .then(function(r){ return r.json(); })
    .then(function(d){ imgUploadInput.value=''; if(d.success) loadData(); else alert(d.error||'업로드 실패'); })
    .catch(function(){ imgUploadInput.value=''; alert('업로드 실패'); });
});
function openImgUpload(itemId){ _imgUploadItemId = itemId; imgUploadInput.click(); }

function previewImg(filename, itemName){
  document.getElementById('imgPreviewTitle').textContent = itemName;
  document.getElementById('imgPreviewSrc').src = base + '/inspect/item/image/' + filename;
  document.getElementById('imgPreviewModal').classList.add('show');
}

function openItemModal(itemId){
  document.getElementById('mItemId').value = itemId || '';
  var notice = document.getElementById('itemModalNotice');
  if(!itemId){
    document.getElementById('itemModalTitle').textContent = '항목 추가';
    document.getElementById('mItemName').value = '';
    document.getElementById('mItemStd').value  = '';
    notice.textContent = '추가된 항목은 이번 달부터 적용됩니다.';
  } else {
    document.getElementById('itemModalTitle').textContent = '항목 수정';
    var item = curData && curData.items ? curData.items.find(function(i){ return i.itemId==itemId; }) : null;
    document.getElementById('mItemName').value = item ? item.itemName : '';
    document.getElementById('mItemStd').value  = item ? (item.itemStd||'') : '';
    notice.textContent = '수정 내용은 ' + nextYmLabel() + '부터 반영됩니다.';
  }
  notice.style.display = 'block';
  document.getElementById('itemModal').classList.add('show');
}
function closeItemModal(){ document.getElementById('itemModal').classList.remove('show'); }

function saveItem(){
  var itemId   = document.getElementById('mItemId').value;
  var itemName = document.getElementById('mItemName').value.trim();
  var itemStd  = document.getElementById('mItemStd').value.trim();
  if(!itemName){ alert('점검 항목을 입력하세요.'); return; }
  var url  = itemId ? '/inspect/item/edit' : '/inspect/item/add';
  var body = { equipId:selEquip, itemName:itemName, itemStd:itemStd };
  if(itemId) body.itemId = parseInt(itemId);
  fetch(base + url, {
    method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify(body)
  }).then(function(r){ return r.json(); })
    .then(function(d){ if(d.success){ closeItemModal(); loadData(); } else alert(d.error||'저장 실패'); });
}

function delItem(itemId){
  if(!confirm('삭제하시겠습니까?\n수정/삭제는 ' + nextYmLabel() + '부터 반영됩니다.')) return;
  fetch(base + '/inspect/item/delete', {
    method:'POST', headers:{'Content-Type':'application/json'},
    body: JSON.stringify({ itemId:itemId })
  }).then(function(r){ return r.json(); })
    .then(function(d){
      if(d.success) alert('처리되었습니다. ' + nextYmLabel() + '부터 반영됩니다.');
      else alert(d.error||'삭제 실패');
    });
}

function setStatusBadge(st){
  var badge = document.getElementById('statusBadge');
  badge.textContent = st==='DONE' ? '완료' : '임시저장';
  badge.className   = 'status-badge status-' + st;
}
var savedTimer = null;
function showSavedMsg(){
  var el = document.getElementById('savedMsg');
  el.textContent = '✓ 저장됨 ' + new Date().toLocaleTimeString();
  clearTimeout(savedTimer);
  savedTimer = setTimeout(function(){ el.textContent=''; }, 3000);
}
function doExport(){
  if(!selEquip || !selYm){ alert('설비와 점검월을 선택하세요.'); return; }
  location.href = base + '/inspect/excel/export?equipId=' + selEquip + '&ym=' + selYm;
}
function doImport(input){
  var file = input.files[0];
  if(!file) return;
  if(!selEquip || !selYm){ alert('설비와 점검월을 선택하세요.'); input.value=''; return; }
  var fd = new FormData();
  fd.append('file', file); fd.append('equipId', selEquip); fd.append('ym', selYm);
  fetch(base + '/inspect/excel/import', { method:'POST', body:fd })
    .then(function(r){ return r.json(); })
    .then(function(d){ input.value=''; if(d.success){ alert('가져오기 완료 ('+d.count+'셀)'); loadData(); } else alert(d.error||'임포트 실패'); })
    .catch(function(){ input.value=''; alert('임포트 실패'); });
}
function nextYmLabel(){
  var d = new Date(); d.setMonth(d.getMonth()+1);
  return d.getFullYear()+'년 '+(d.getMonth()+1)+'월';
}
function esc(s){
  return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}
</script>
</body>
</html>
