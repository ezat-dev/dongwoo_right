<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common_style.jsp" %>
<style>
/* ── 레이아웃 ── */
.fp-header {
  display: flex; align-items: center; justify-content: space-between;
  margin-bottom: 16px;
}
.fp-title-wrap { display: flex; flex-direction: column; gap: 2px; }
.fp-title { font-size: 18px; font-weight: 900; color: var(--text); }
.fp-sub   { font-size: 12px; color: var(--muted); font-weight: 600; }

.fp-equip-wrap { display: flex; align-items: center; gap: 8px; }
.fp-equip-label { font-size: 12px; font-weight: 700; color: var(--muted); }
.fp-equip-select {
  padding: 7px 14px; border-radius: 9px;
  border: 1px solid var(--border); background: var(--white);
  font-size: 14px; font-weight: 700; color: var(--text);
  cursor: pointer; min-width: 140px;
  font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
}
.fp-equip-select:focus { outline: none; border-color: var(--primary); }

.fp-panels {
  display: flex; gap: 14px;
  height: calc(100vh - 120px);
}

/* ── 패널 공통 ── */
.fp-panel {
  flex: 1; display: flex; flex-direction: column;
  background: var(--white); border: 1px solid var(--border);
  border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,.05);
  overflow: hidden; min-width: 0;
}
.fp-panel-hd {
  padding: 12px 16px; border-bottom: 1px solid var(--border);
  display: flex; align-items: center; justify-content: space-between;
  flex-shrink: 0;
}
.fp-panel-title { font-size: 13px; font-weight: 800; color: var(--text); }
.fp-badge {
  font-size: 11px; font-weight: 700; border-radius: 20px;
  padding: 2px 10px;
}
.badge-avail  { background: var(--bg); color: var(--muted); }
.badge-sel    { background: #C6F6D5; color: #276749; }

.fp-list {
  flex: 1; overflow-y: auto; padding: 8px;
  display: flex; flex-direction: column; gap: 5px;
}
.fp-list::-webkit-scrollbar { width: 4px; }
.fp-list::-webkit-scrollbar-thumb { background: #CBD5E0; border-radius: 2px; }

/* ── 태그 아이템 ── */
.fp-item {
  border-radius: 9px; padding: 10px 14px;
  border: 1.5px solid var(--border);
  cursor: pointer; user-select: none;
  display: flex; align-items: center; gap: 10px;
  transition: border-color .12s, background .12s, box-shadow .12s;
  background: #FAFBFC;
}
.fp-item:hover { border-color: var(--primary); background: #EBF8FF; box-shadow: 0 1px 4px rgba(49,130,206,.1); }

.fp-seq {
  flex-shrink: 0; min-width: 36px; height: 36px;
  display: flex; align-items: center; justify-content: center;
  background: var(--bg); border-radius: 8px;
  font-size: 12px; font-weight: 800; color: var(--muted);
  line-height: 1;
}
.fp-item:hover .fp-seq { background: #D6EAF8; color: var(--primary); }

.fp-item-info { flex: 1; min-width: 0; display: flex; flex-direction: column; gap: 3px; }
.fp-item-row1 { display: flex; align-items: center; gap: 7px; }
.fp-item-name { font-size: 11px; font-weight: 700; color: var(--muted); }
.fp-lv {
  font-size: 10px; font-weight: 800; border-radius: 5px; padding: 1px 7px; flex-shrink: 0;
}
.lv-1 { background: #EBF8FF; color: #2B6CB0; }
.lv-2 { background: #FFFAF0; color: #C05621; }
.lv-3 { background: #FFF5F5; color: #C53030; }

.fp-item-row2 { display: flex; align-items: center; gap: 6px; }
.fp-item-msg  { font-size: 13px; font-weight: 800; color: var(--text); min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }

.fp-item-new { background: #EBF8FF !important; border-color: #90CDF4 !important; }
.fp-item-new .fp-seq { background: #BEE3F8; color: #2B6CB0; }
.fp-save-tag {
  flex-shrink: 0; font-size: 10px; font-weight: 800;
  color: #2B6CB0; background: #BEE3F8;
  border-radius: 4px; padding: 1px 7px; margin-left: 4px;
}

/* 화살표 아이콘 */
.fp-arrow {
  flex-shrink: 0; width: 22px; height: 22px; border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  font-size: 13px; font-weight: 900; transition: background .12s;
}
.fp-panel-left  .fp-arrow { background: #EBF8FF; color: var(--primary); }
.fp-panel-right .fp-arrow { background: #FFF5F5; color: #E53E3E; }
.fp-item:hover .fp-arrow  { filter: brightness(.92); }

/* ── 애니메이션 ── */
@keyframes toRight {
  0%   { transform: translateX(0);    opacity: 1; }
  100% { transform: translateX(48px); opacity: 0; }
}
@keyframes toLeft {
  0%   { transform: translateX(0);     opacity: 1; }
  100% { transform: translateX(-48px); opacity: 0; }
}
@keyframes fadeSlideIn {
  0%   { transform: translateX(-16px); opacity: 0; }
  100% { transform: translateX(0);     opacity: 1; }
}
@keyframes fadeSlideInR {
  0%   { transform: translateX(16px);  opacity: 0; }
  100% { transform: translateX(0);     opacity: 1; }
}

.fp-item.anim-out-r { animation: toRight .18s ease forwards; pointer-events: none; }
.fp-item.anim-out-l { animation: toLeft  .18s ease forwards; pointer-events: none; }
.fp-item.anim-in-r  { animation: fadeSlideIn  .2s ease both; }
.fp-item.anim-in-l  { animation: fadeSlideInR .2s ease both; }

/* 빈 상태 */
.fp-empty {
  flex: 1; display: flex; flex-direction: column;
  align-items: center; justify-content: center; gap: 8px;
  color: var(--muted); pointer-events: none;
}
.fp-empty-icon { font-size: 32px; opacity: .25; }
.fp-empty-txt  { font-size: 12px; font-weight: 600; }

/* ── 중앙 화살표 구분 영역 ── */
.fp-mid {
  display: flex; flex-direction: column; align-items: center;
  justify-content: center; gap: 6px; flex-shrink: 0; width: 32px;
  color: #CBD5E0;
}
.fp-mid-arrow { font-size: 20px; line-height: 1; }
</style>

<body>
<div class="page-wrap">

  <div class="fp-header">
    <div class="fp-title-wrap">
      <div class="fp-title">F/PROOF SAVE</div>
      <div class="fp-sub">설비별 F/PROOF 대상 알람 태그 지정</div>
    </div>
    <div class="fp-equip-wrap">
      <span class="fp-equip-label">설비 선택</span>
      <select class="fp-equip-select" id="equipSelect" onchange="loadList(this.value)">
        <option value="dongwoo_01">침탄 1호기</option>
        <option value="dongwoo_02">침탄 2호기</option>
        <option value="dongwoo_03">침탄 3호기</option>
        <option value="dongwoo_04">침탄 4호기</option>
        <option value="dongwoo_05">침탄 5호기</option>
        <option value="dongwoo_06">침탄 6호기</option>
        <option value="dongwoo_07">침탄 7호기</option>
        <option value="dongwoo_08">침탄 8호기</option>
        <option value="dongwoo_09">침탄 9호기</option>
        <option value="dongwoo_10">침탄 10호기</option>
        <option value="dongwoo_11">침탄 11호기</option>
        <option value="dongwoo_12">침탄 12호기</option>
      </select>
    </div>
  </div>

  <div class="fp-panels">

    <!-- 좌측: 미지정 태그 -->
    <div class="fp-panel fp-panel-left">
      <div class="fp-panel-hd">
        <span class="fp-panel-title" id="availPanelTitle">1호기 등록 가능 알람 태그</span>
        <span class="fp-badge badge-avail" id="availBadge">0건</span>
      </div>
      <div class="fp-list" id="availList">
        <div class="fp-empty"><div class="fp-empty-icon">📋</div><div class="fp-empty-txt">불러오는 중…</div></div>
      </div>
    </div>

    <!-- 중앙 화살표 -->
    <div class="fp-mid">
      <div class="fp-mid-arrow">›</div>
      <div class="fp-mid-arrow">›</div>
    </div>

    <!-- 우측: 지정된 태그 -->
    <div class="fp-panel fp-panel-right">
      <div class="fp-panel-hd">
        <span class="fp-panel-title">F/PROOF 지정 알람</span>
        <span class="fp-badge badge-sel" id="selBadge">0건</span>
      </div>
      <div class="fp-list" id="selList">
        <div class="fp-empty"><div class="fp-empty-icon">🎯</div><div class="fp-empty-txt">지정된 알람이 없습니다</div></div>
      </div>
    </div>

  </div>
</div>

<script>
var ROOT       = '<%=request.getContextPath()%>';
var curPlc     = 'dongwoo_01';
var newlyAdded = {};

/* ─── 목록 로드 ─── */
function loadList(plcId) {
  curPlc = plcId;
  newlyAdded = {};
  var num = parseInt(plcId.replace('dongwoo_', ''), 10);
  document.getElementById('availPanelTitle').textContent = num + '호기 등록 가능 알람 태그';
  setLoading();
  fetch(ROOT + '/fproof/list?plcId=' + encodeURIComponent(plcId))
    .then(function(r) { return r.json(); })
    .then(function(res) {
      var selSet = {};
      (res.selected || []).forEach(function(id) { selSet[id] = true; });
      var avail = [], sel = [];
      (res.all || []).forEach(function(t) {
        selSet[t.tagId] ? sel.push(t) : avail.push(t);
      });
      renderList('availList', avail, 'right');
      renderList('selList',   sel,   'left');
      updateBadges(avail.length, sel.length);
    })
    .catch(function() { setError(); });
}

/* ─── 리스트 렌더링 ─── */
function renderList(listId, tags, dir) {
  var el = document.getElementById(listId);
  if (!tags.length) {
    el.innerHTML = emptyHtml(dir);
    return;
  }
  el.innerHTML = '';
  tags.forEach(function(t) { el.appendChild(buildItem(t, dir)); });
}

function buildItem(t, dir) {
  var div = document.createElement('div');
  div.className = 'fp-item';
  div.dataset.tagId = t.tagId;
  var lvText = t.level === 3 ? 'ERROR' : t.level === 2 ? 'WARN' : 'INFO';
  var arrow  = dir === 'right' ? '›' : '‹';
  var isNew  = (dir === 'left') && newlyAdded[t.tagId];
  if (isNew) div.classList.add('fp-item-new');
  div.innerHTML =
    (dir === 'right' ? '' : '<div class="fp-arrow">' + arrow + '</div>') +
    '<div class="fp-seq">' + t.tagId + '</div>' +
    '<div class="fp-item-info">' +
      '<div class="fp-item-row1">' +
        '<span class="fp-item-name">' + esc(t.tagName) + '</span>' +
        '<span class="fp-lv lv-' + t.level + '">' + lvText + '</span>' +
      '</div>' +
      '<div class="fp-item-row2">' +
        '<span class="fp-item-msg">' + esc(t.alarmMsg) + '</span>' +
        (isNew ? '<span class="fp-save-tag">SAVE</span>' : '') +
      '</div>' +
    '</div>' +
    (dir === 'right' ? '<div class="fp-arrow">' + arrow + '</div>' : '');
  div.addEventListener('click', function() {
    dir === 'right' ? moveToSel(t, div) : moveToAvail(t, div);
  });
  return div;
}

/* ─── 좌→우 (지정) ─── */
function moveToSel(tag, el) {
  el.classList.add('anim-out-r');
  newlyAdded[tag.tagId] = true;
  post('/fproof/select', { tagId: tag.tagId, plcId: curPlc });
  el.addEventListener('animationend', function() {
    el.remove();
    appendItem('selList',   tag, 'left',  'anim-in-r');
    removeItem('availList', tag.tagId);
    updateBadges(
      document.getElementById('availList').querySelectorAll('.fp-item').length,
      document.getElementById('selList').querySelectorAll('.fp-item').length
    );
  }, { once: true });
}

/* ─── 우→좌 (해제) ─── */
function moveToAvail(tag, el) {
  el.style.transition = 'opacity .12s ease';
  el.style.opacity    = '0';
  el.style.pointerEvents = 'none';
  delete newlyAdded[tag.tagId];
  post('/fproof/deselect', { tagId: tag.tagId, plcId: curPlc });
  setTimeout(function() {
    el.remove();
    var selEl = document.getElementById('selList');
    if (!selEl.querySelectorAll('.fp-item').length) {
      selEl.innerHTML = emptyHtml('left');
    }
    appendItem('availList', tag, 'right', 'anim-in-l');
    updateBadges(
      document.getElementById('availList').querySelectorAll('.fp-item').length,
      document.getElementById('selList').querySelectorAll('.fp-item').length
    );
  }, 130);
}

/* ─── 헬퍼 ─── */
function appendItem(listId, tag, dir, animCls) {
  var el   = document.getElementById(listId);
  var item = buildItem(tag, dir);
  item.classList.add(animCls);
  // 빈 상태 제거
  var empty = el.querySelector('.fp-empty');
  if (empty) empty.remove();
  el.appendChild(item);
}

function removeItem(listId, tagId) {
  var el = document.getElementById(listId);
  if (!el.querySelectorAll('.fp-item').length) {
    // 이미 비어있으면 empty 표시
    var dir = listId === 'availList' ? 'right' : 'left';
    el.innerHTML = emptyHtml(dir);
  }
}

function updateBadges(availCnt, selCnt) {
  document.getElementById('availBadge').textContent = availCnt + '건';
  document.getElementById('selBadge').textContent   = selCnt   + '건';
}

function emptyHtml(dir) {
  var icon = dir === 'right' ? '📋' : '🎯';
  var txt  = dir === 'right' ? '등록 가능한 태그가 없습니다' : '지정된 알람이 없습니다';
  return '<div class="fp-empty"><div class="fp-empty-icon">' + icon + '</div><div class="fp-empty-txt">' + txt + '</div></div>';
}

function setLoading() {
  document.getElementById('availList').innerHTML = '<div class="fp-empty"><div class="fp-empty-txt">불러오는 중…</div></div>';
  document.getElementById('selList').innerHTML   = '<div class="fp-empty"><div class="fp-empty-txt">불러오는 중…</div></div>';
}

function setError() {
  document.getElementById('availList').innerHTML = '<div class="fp-empty"><div class="fp-empty-txt">로드 실패</div></div>';
  document.getElementById('selList').innerHTML   = '<div class="fp-empty"><div class="fp-empty-txt">로드 실패</div></div>';
}

function post(url, data) {
  fetch(ROOT + url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data)
  }).catch(function(e) { console.warn('fproof post error', e); });
}

function esc(s) {
  return String(s || '')
    .replace(/&/g,'&amp;').replace(/</g,'&lt;')
    .replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

/* ─── 초기 로드 ─── */
loadList('dongwoo_01');
</script>
</body>
</html>
