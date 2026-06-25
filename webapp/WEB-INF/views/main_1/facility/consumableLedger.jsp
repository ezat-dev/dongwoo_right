<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common_style.jsp" %>
<style>
/* ── 탭 ── */
.cl-tabs { display:flex; gap:6px; margin-bottom:16px; }
.cl-tab  { padding:7px 22px; border-radius:8px; border:1px solid var(--border);
  background:var(--white); font-size:13px; font-weight:600;
  cursor:pointer; transition:all .13s; color:var(--muted); }
.cl-tab.active { background:var(--primary); color:#fff; border-color:var(--primary); }

/* ── 안전재고 미만 강조 ── */
.row-low td.qty-cell { color:var(--red) !important; font-weight:700 !important; }
.row-low { background:#FFF5F5 !important; }

/* ── 카테고리 구분선 ── */
.cat-top td { border-top:2px solid #B0BEC5 !important; }
.cat-cell { font-weight:700; background:var(--bg); text-align:center; border-right:2px solid var(--border); }

/* ── 상태 뱃지 ── */
.badge { display:inline-block; padding:2px 9px; border-radius:20px; font-size:11px; font-weight:700; white-space:nowrap; }
.b-in  { background:#EBF8FF; color:var(--primary); border:1px solid #BEE3F8; }
.b-out { background:#FFF5F5; color:var(--red);     border:1px solid #FEB2B2; }

/* ── 모달 ── */
.modal-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,.4);
  z-index:300; align-items:center; justify-content:center; }
.modal-overlay.show { display:flex; }
.modal-box { background:var(--white); border-radius:14px; padding:26px 28px;
  width:540px; max-width:96vw; box-shadow:0 8px 40px rgba(0,0,0,.2); max-height:92vh; overflow-y:auto; }
.modal-box.sm { width:400px; }
.modal-title  { font-size:15px; font-weight:700; margin-bottom:18px; }
.modal-grid   { display:grid; grid-template-columns:1fr 1fr; gap:12px 16px; }
.modal-grid .full { grid-column:1/-1; }
.modal-actions { display:flex; justify-content:flex-end; gap:8px; margin-top:20px; }

/* ── 액션 버튼 ── */
.act-btns { display:flex; gap:3px; flex-wrap:nowrap; }
.btn-xs { padding:2px 7px; font-size:11px; border-radius:4px;
  border:1px solid var(--border); background:none; cursor:pointer; white-space:nowrap; }
.btn-xs-in   { border-color:var(--primary); color:var(--primary); }
.btn-xs-in:hover { background:var(--primary-l); }
.btn-xs-out  { border-color:var(--orange); color:var(--orange); }
.btn-xs-out:hover { background:var(--orange-l); }
.btn-xs-edit:hover { border-color:var(--primary); color:var(--primary); }
.btn-xs-del:hover  { border-color:var(--red); color:var(--red); background:var(--red-l); }

/* ── textarea ── */
.form-textarea { width:100%; border:1px solid var(--border); border-radius:6px;
  padding:6px 10px; font-size:13px; font-family:inherit;
  resize:vertical; outline:none; min-height:56px; color:var(--text); background:var(--white); }
.form-textarea:focus { border-color:var(--primary); }

/* ── 필터 바 ── */
.ctrl-bar { display:flex; gap:10px; flex-wrap:wrap; align-items:flex-end; margin-bottom:14px; }

/* ═══════════════════════════════════════
   태블릿 모드 토글 버튼
═══════════════════════════════════════ */
.btn-tablet-toggle {
  padding:7px 14px; border-radius:8px; border:1px solid var(--border);
  background:var(--white); font-size:13px; font-weight:600;
  cursor:pointer; transition:all .15s; color:var(--text);
  touch-action:manipulation;
}
.btn-tablet-toggle.active {
  background:#2D3748; color:#fff; border-color:#2D3748;
}

/* ═══════════════════════════════════════
   태블릿 모드: 재고 카드 그리드
═══════════════════════════════════════ */
.cl-stock-cards {
  display:grid;
  grid-template-columns:repeat(auto-fill,minmax(300px,1fr));
  gap:14px; padding:4px 0;
}
.cl-stock-card {
  border:1px solid var(--border); border-radius:14px;
  background:var(--white); box-shadow:0 2px 8px rgba(0,0,0,.08);
  overflow:hidden; display:flex; flex-direction:column;
  transition:box-shadow .15s;
}
.cl-stock-card:hover { box-shadow:0 4px 16px rgba(0,0,0,.13); }
.cl-stock-card.row-low { border-color:#FEB2B2; background:#FFF5F5; }
.cl-card-head {
  display:flex; align-items:center; gap:8px;
  padding:14px 16px 11px; border-bottom:1px solid var(--bg);
}
.cl-card-cat {
  background:#EDF2F7; color:#4A5568; border-radius:6px;
  padding:3px 10px; font-size:11px; font-weight:700; white-space:nowrap;
  flex-shrink:0;
}
.cl-card-name {
  font-size:15px; font-weight:700; flex:1;
  overflow:hidden; text-overflow:ellipsis; white-space:nowrap;
}
.cl-card-body {
  padding:12px 16px;
  display:grid; grid-template-columns:1fr 1fr; gap:10px 16px;
  flex:1;
}
.cl-card-field { display:flex; flex-direction:column; gap:3px; }
.cl-card-field-full { grid-column:1/-1; }
.cl-field-lbl {
  font-size:10px; color:var(--muted); font-weight:700;
  text-transform:uppercase; letter-spacing:.6px;
}
.cl-field-val { font-size:14px; font-weight:600; line-height:1.3; }
.cl-field-val.low { color:var(--red); }
.cl-field-val small { font-weight:400; color:var(--muted); font-size:12px; }
.cl-card-remark-row {
  grid-column:1/-1;
  border-top:1px solid var(--bg); padding-top:8px; margin-top:2px;
  font-size:11px; color:var(--muted); white-space:pre-wrap; line-height:1.5;
}
.cl-card-foot {
  display:flex; gap:7px; padding:11px 16px;
  background:var(--bg); border-top:1px solid var(--border);
}
.btn-tab {
  flex:1; padding:10px 4px; border-radius:8px;
  border:1px solid var(--border); background:var(--white);
  font-size:12px; font-weight:700; cursor:pointer;
  touch-action:manipulation; transition:all .12s;
  min-height:42px;
}
.btn-tab-in   { border-color:var(--primary); color:var(--primary); background:#EBF8FF; }
.btn-tab-in:hover  { background:var(--primary); color:#fff; }
.btn-tab-out  { border-color:var(--orange); color:var(--orange); background:#FFFAF0; }
.btn-tab-out:hover { background:var(--orange); color:#fff; }
.btn-tab-edit { border-color:#718096; color:#718096; }
.btn-tab-edit:hover { border-color:var(--primary); color:var(--primary); background:var(--primary-l); }
.btn-tab-del  { border-color:var(--red); color:var(--red); background:#FFF5F5; }
.btn-tab-del:hover { background:var(--red); color:#fff; }

/* ═══════════════════════════════════════
   태블릿 모드: 이력 카드 그리드
═══════════════════════════════════════ */
.cl-hist-cards {
  display:grid;
  grid-template-columns:repeat(auto-fill,minmax(280px,1fr));
  gap:10px;
}
.cl-hist-card {
  border:1px solid var(--border); border-radius:12px;
  padding:14px 16px; background:var(--white);
  box-shadow:0 1px 6px rgba(0,0,0,.07);
  display:flex; flex-direction:column; gap:8px;
}
.cl-hist-card-top {
  display:flex; justify-content:space-between; align-items:center;
}
.cl-hist-card-item {
  display:flex; justify-content:space-between; align-items:flex-end; gap:8px;
}
.cl-hist-card-meta {
  display:flex; gap:14px; font-size:12px; color:var(--muted);
}

/* ═══════════════════════════════════════
   태블릿 모드: 공통 요소 터치 최적화
═══════════════════════════════════════ */
body.tablet-mode .form-input,
body.tablet-mode .form-select {
  font-size:15px !important; padding:10px 14px !important; min-height:46px;
}
body.tablet-mode .btn-primary,
body.tablet-mode .btn-outline {
  font-size:14px !important; padding:10px 20px !important; min-height:46px;
}
body.tablet-mode .btn-sm { min-height:42px !important; font-size:13px !important; padding:0 16px !important; }
body.tablet-mode .cl-tab { padding:10px 28px; font-size:14px; min-height:42px; }
body.tablet-mode .modal-box { width:92vw; max-width:660px; padding:28px 30px; }
body.tablet-mode .modal-box.sm { width:92vw; max-width:520px; }
body.tablet-mode .form-label { font-size:13px; margin-bottom:5px; }
body.tablet-mode .modal-grid { gap:14px 18px; }
body.tablet-mode .modal-title { font-size:17px; margin-bottom:22px; }
body.tablet-mode .page-title { font-size:18px; }
body.tablet-mode .card { padding:18px 20px; }
body.tablet-mode .form-textarea { font-size:15px; min-height:70px; }
body.tablet-mode .ctrl-bar { gap:14px; }
</style>
<body>
<div class="page-wrap">

  <div class="page-header">
    <div>
      <div class="page-title">유류, 소모재 관리대장</div>
      <div class="page-sub">유류·소모재 재고 현황 및 입출고 이력 관리</div>
    </div>
    <div style="display:flex;gap:8px;flex-wrap:wrap" id="headerBtns">
      <button class="btn-tablet-toggle" id="btnTablet" onclick="toggleTabletMode()">📱 태블릿 모드</button>
      <button class="btn-outline" onclick="openInModal(null)"  id="btnIn"  data-perm="add">📦 입고 등록</button>
      <button class="btn-outline" onclick="openOutModal(null)" id="btnOut" data-perm="add">🔧 사용 등록</button>
      <button class="btn-primary" onclick="openEditModal(null)" id="btnAdd" data-perm="add">＋ 항목 추가</button>
      <button class="btn-outline" onclick="doExcel()" id="btnExcel">📥 엑셀 출력</button>
    </div>
  </div>

  <!-- 탭 -->
  <div class="cl-tabs">
    <button class="cl-tab active" onclick="showTab('stock',this)">재고 현황</button>
    <button class="cl-tab"        onclick="showTab('history',this)">입출고 이력</button>
  </div>

  <!-- ══ 탭1: 재고 현황 ══ -->
  <div id="tab-stock">
    <div class="card">
      <div style="display:flex;align-items:center;gap:10px;margin-bottom:14px;flex-wrap:wrap">
        <div class="card-title" style="margin:0">재고 현황</div>
        <div style="margin-left:auto;display:flex;gap:8px;align-items:center">
          <input class="form-input" type="text" id="fKeyword" placeholder="구분·품명 검색"
                 style="width:180px" oninput="filterStock()">
          <span id="stockCount" style="font-size:11px;color:var(--muted)"></span>
        </div>
      </div>
      <!-- 일반 모드: 테이블 -->
      <div style="overflow-x:auto" id="stockTableWrap">
        <table class="data-table" id="stockTable">
          <thead>
            <tr>
              <th style="width:40px;text-align:center">No</th>
              <th style="width:100px;text-align:center">구분</th>
              <th style="width:220px">품명/규격</th>
              <th style="width:110px;text-align:center">포장단위</th>
              <th style="width:90px;text-align:center">보유재고<br><small style="font-weight:400;color:var(--muted)">수량</small></th>
              <th style="width:70px;text-align:center">단위</th>
              <th style="width:90px;text-align:center">안전재고<br><small style="font-weight:400;color:var(--muted)">수량</small></th>
              <th style="width:70px;text-align:center">단위</th>
              <th style="width:160px">비고(특이사항)</th>
              <th style="width:140px" id="actColHd">관리</th>
            </tr>
          </thead>
          <tbody id="stockBody">
            <tr><td colspan="10" style="text-align:center;padding:40px;color:var(--muted)">로딩 중…</td></tr>
          </tbody>
        </table>
      </div>
      <!-- 태블릿 모드: 카드 -->
      <div id="stockCards" style="display:none"></div>
    </div>
  </div>

  <!-- ══ 탭2: 입출고 이력 ══ -->
  <div id="tab-history" style="display:none">
    <div class="card">
      <div class="ctrl-bar">
        <div class="form-field">
          <label class="form-label">유형</label>
          <select class="form-select" id="hType" style="width:90px">
            <option value="">전체</option>
            <option value="IN">입고</option>
            <option value="OUT">사용</option>
          </select>
        </div>
        <div class="form-field">
          <label class="form-label">시작일</label>
          <input class="form-input" type="date" id="hFrom" style="width:140px">
        </div>
        <div class="form-field">
          <label class="form-label">종료일</label>
          <input class="form-input" type="date" id="hTo" style="width:140px">
        </div>
        <button class="btn-primary btn-sm" style="margin-top:18px;height:34px" onclick="loadHistory()">조회</button>
        <span id="histCount" style="margin-top:22px;font-size:11px;color:var(--muted)"></span>
      </div>
      <!-- 일반 모드: 테이블 -->
      <div style="overflow-x:auto" id="histTableWrap">
        <table class="data-table">
          <thead>
            <tr>
              <th style="width:40px;text-align:center">No</th>
              <th style="width:130px">일시</th>
              <th style="width:55px;text-align:center">유형</th>
              <th style="width:100px">구분</th>
              <th style="width:220px">품명/규격</th>
              <th style="width:80px;text-align:center">수량</th>
              <th style="width:160px">비고</th>
              <th style="width:80px">담당자</th>
              <th style="width:60px" id="histActHd">관리</th>
            </tr>
          </thead>
          <tbody id="histBody">
            <tr><td colspan="9" style="text-align:center;padding:40px;color:var(--muted)">조회 버튼을 눌러 이력을 확인하세요</td></tr>
          </tbody>
        </table>
      </div>
      <!-- 태블릿 모드: 카드 -->
      <div id="histCards" style="display:none"></div>
    </div>
  </div>

</div>

<!-- ══ 항목 추가/수정 모달 ══ -->
<div class="modal-overlay" id="editModal">
  <div class="modal-box">
    <div class="modal-title">🛢️ <span id="editModalTitle">항목 추가</span></div>
    <div class="modal-grid">
      <div class="form-field">
        <label class="form-label">구분 *</label>
        <input class="form-input" type="text" id="mCategory" list="categoryList" style="width:100%">
        <datalist id="categoryList"></datalist>
      </div>
      <div class="form-field">
        <label class="form-label">품명/규격 *</label>
        <input class="form-input" type="text" id="mItemName" placeholder="예) BW-2200" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">포장단위</label>
        <input class="form-input" type="text" id="mPackageUnit" placeholder="예) 200L / DRUM" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">표시 순서</label>
        <input class="form-input" type="number" id="mSortOrder" value="0" min="0" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">보유재고 수량</label>
        <input class="form-input" type="text" id="mStockQty" placeholder="예) 5  또는  2.45t : 30" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">보유재고 단위</label>
        <input class="form-input" type="text" id="mStockUnit" placeholder="예) DRUM, kg, 병" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">안전재고 수량</label>
        <input class="form-input" type="text" id="mSafetyQty" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">안전재고 단위</label>
        <input class="form-input" type="text" id="mSafetyUnit" style="width:100%">
      </div>
      <div class="form-field full">
        <label class="form-label">비고(특이사항)</label>
        <textarea class="form-textarea" id="mRemark"></textarea>
      </div>
    </div>
    <div class="modal-actions">
      <button class="btn-outline" onclick="closeEditModal()">취소</button>
      <button class="btn-primary" onclick="saveEditModal()">저장</button>
    </div>
  </div>
</div>

<!-- ══ 입고 모달 ══ -->
<div class="modal-overlay" id="inModal">
  <div class="modal-box sm">
    <div class="modal-title">📦 입고 등록</div>
    <div style="display:flex;flex-direction:column;gap:12px">
      <div class="form-field">
        <label class="form-label">품목 *</label>
        <select class="form-select" id="inLedgerId" style="width:100%"></select>
      </div>
      <div class="form-field">
        <label class="form-label">입고 수량 *</label>
        <input class="form-input" type="text" id="inQty" placeholder="예) 5  또는  2.45t" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">비고</label>
        <input class="form-input" type="text" id="inRemark" placeholder="예) 정기 발주 입고" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">담당자</label>
        <input class="form-input" type="text" id="inUserName" placeholder="성명" style="width:100%">
      </div>
    </div>
    <div class="modal-actions">
      <button class="btn-outline" onclick="closeInModal()">취소</button>
      <button class="btn-primary" onclick="saveInModal()">저장</button>
    </div>
  </div>
</div>

<!-- ══ 사용(OUT) 모달 ══ -->
<div class="modal-overlay" id="outModal">
  <div class="modal-box sm">
    <div class="modal-title">🔧 사용 등록</div>
    <div style="display:flex;flex-direction:column;gap:12px">
      <div class="form-field">
        <label class="form-label">품목 *</label>
        <select class="form-select" id="outLedgerId" style="width:100%"></select>
      </div>
      <div class="form-field">
        <label class="form-label">사용 수량 *</label>
        <input class="form-input" type="text" id="outQty" placeholder="예) 2" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">비고</label>
        <input class="form-input" type="text" id="outRemark" placeholder="예) BCF1 열처리 사용" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">담당자</label>
        <input class="form-input" type="text" id="outUserName" placeholder="성명" style="width:100%">
      </div>
    </div>
    <div class="modal-actions">
      <button class="btn-outline" onclick="closeOutModal()">취소</button>
      <button class="btn-primary" onclick="saveOutModal()"
              style="background:var(--orange);border-color:var(--orange)">사용 처리</button>
    </div>
  </div>
</div>

<script>
var base       = '${pageContext.request.contextPath}';
var canAdd     = true;
var canEdit    = true;
var canDel     = true;
var stockCache = [];
var tabletMode = localStorage.getItem('cl_tablet_mode') === '1';

/* ── 권한 로드 후 재고 조회 ── */
fetch(base + '/perm/my')
  .then(function(r){ return r.json(); })
  .then(function(perms){
    var p = perms['consumable/ledger'] || {};
    canAdd  = (p.canAdd  !== 'N');
    canEdit = (p.canEdit !== 'N');
    canDel  = (p.canDel  !== 'N');
    if (!canAdd) {
      ['btnIn','btnOut','btnAdd'].forEach(function(id){
        var el = document.getElementById(id); if(el) el.style.display='none';
      });
    }
    applyTabletMode();
    loadStock();
  })
  .catch(function(){ applyTabletMode(); loadStock(); });

/* ══════════════════════════════
   태블릿 모드 토글
══════════════════════════════ */
function toggleTabletMode() {
  tabletMode = !tabletMode;
  localStorage.setItem('cl_tablet_mode', tabletMode ? '1' : '0');
  applyTabletMode();
  renderStock(stockCache);
  var histTab = document.getElementById('tab-history');
  if (histTab && histTab.style.display !== 'none') loadHistory();
}

function applyTabletMode() {
  var btn = document.getElementById('btnTablet');
  if (tabletMode) {
    document.body.classList.add('tablet-mode');
    if (btn) { btn.classList.add('active'); btn.innerHTML = '💻 일반 모드'; }
  } else {
    document.body.classList.remove('tablet-mode');
    if (btn) { btn.classList.remove('active'); btn.innerHTML = '📱 태블릿 모드'; }
  }
}

/* ══════════════════════════════
   탭 전환
══════════════════════════════ */
function showTab(id, btn) {
  document.getElementById('tab-stock').style.display   = id === 'stock'   ? '' : 'none';
  document.getElementById('tab-history').style.display = id === 'history' ? '' : 'none';
  document.querySelectorAll('.cl-tab').forEach(function(b){ b.classList.remove('active'); });
  if (btn) btn.classList.add('active');
  if (id === 'history') loadHistory();
}

/* ══════════════════════════════
   재고 현황
══════════════════════════════ */
function loadStock() {
  fetch(base + '/consumable/list')
    .then(function(r){ return r.json(); })
    .then(function(d){
      if (!d.success) { alert(d.error || '조회 실패'); return; }
      stockCache = d.data || [];
      renderStock(stockCache);
      buildSelects();
      buildCategoryDatalist();
    });
}

function filterStock() { renderStock(stockCache); }

function renderStock(list) {
  var kw = document.getElementById('fKeyword').value.trim().toLowerCase();
  var filtered = kw
    ? list.filter(function(r){
        return (r.category||'').toLowerCase().indexOf(kw)>=0
            || (r.itemName||'').toLowerCase().indexOf(kw)>=0;
      })
    : list;

  document.getElementById('stockCount').textContent = '총 ' + filtered.length + '건';

  if (tabletMode) {
    document.getElementById('stockTableWrap').style.display = 'none';
    var sc = document.getElementById('stockCards');
    sc.style.display = '';
    sc.innerHTML = buildStockCards(filtered);
    return;
  }

  document.getElementById('stockTableWrap').style.display = '';
  document.getElementById('stockCards').style.display = 'none';

  if (!filtered.length) {
    document.getElementById('stockBody').innerHTML =
      '<tr><td colspan="10" style="text-align:center;padding:40px;color:var(--muted)">데이터가 없습니다.</td></tr>';
    return;
  }

  var html = '', prevCat = null, no = 0;
  filtered.forEach(function(r) {
    no++;
    var low    = isLowStock(r.stockQty, r.safetyQty);
    var topCls = r.category !== prevCat ? ' cat-top' : '';
    var rowCls = (low ? ' row-low' : '') + topCls;

    var act = '<div class="act-btns">';
    if (canAdd) {
      act += '<button class="btn-xs btn-xs-in"  onclick="openInModal(\''  + r.id + '\')">입고</button>';
      act += '<button class="btn-xs btn-xs-out" onclick="openOutModal(\'' + r.id + '\')">사용</button>';
    }
    if (canEdit) act += '<button class="btn-xs btn-xs-edit" onclick="openEditModal(\'' + r.id + '\')">수정</button>';
    if (canDel)  act += '<button class="btn-xs btn-xs-del"  onclick="deleteItem(\'' + r.id + '\',\'' + esc(r.itemName) + '\')">삭제</button>';
    act += '</div>';

    html += '<tr class="' + rowCls + '">'
      + '<td style="text-align:center;color:var(--muted);font-size:12px">' + no + '</td>'
      + '<td class="cat-cell">' + esc(r.category||'') + '</td>'
      + '<td style="font-weight:600;max-width:220px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap" title="' + esc(r.itemName||'') + '">' + esc(r.itemName||'') + '</td>'
      + '<td style="text-align:center;color:var(--muted)">' + esc(r.packageUnit||'') + '</td>'
      + '<td class="qty-cell" style="text-align:center;font-weight:600">' + esc(r.stockQty||'') + '</td>'
      + '<td style="text-align:center;color:var(--muted)">' + esc(r.stockUnit||'') + '</td>'
      + '<td style="text-align:center">' + esc(r.safetyQty||'') + '</td>'
      + '<td style="text-align:center;color:var(--muted)">' + esc(r.safetyUnit||'') + '</td>'
      + '<td style="color:var(--muted);font-size:12px;white-space:pre-wrap;max-width:180px">' + esc(r.remark||'') + '</td>'
      + '<td>' + act + '</td>'
      + '</tr>';
    prevCat = r.category;
  });
  document.getElementById('stockBody').innerHTML = html;
}

/* ── 태블릿 모드: 재고 카드 HTML 생성 ── */
function buildStockCards(list) {
  if (!list.length) {
    return '<div style="text-align:center;padding:60px;color:var(--muted);font-size:15px">데이터가 없습니다.</div>';
  }
  var html = '<div class="cl-stock-cards">';
  list.forEach(function(r) {
    var low     = isLowStock(r.stockQty, r.safetyQty);
    var cardCls = low ? ' row-low' : '';
    var lowTag  = low ? '<span class="badge b-out" style="font-size:10px;padding:2px 7px">⚠ 재고부족</span>' : '';

    var foot = '<div class="cl-card-foot">';
    if (canAdd) {
      foot += '<button class="btn-tab btn-tab-in"  onclick="openInModal(\''  + r.id + '\')">📦 입고</button>';
      foot += '<button class="btn-tab btn-tab-out" onclick="openOutModal(\'' + r.id + '\')">🔧 사용</button>';
    }
    if (canEdit) foot += '<button class="btn-tab btn-tab-edit" onclick="openEditModal(\'' + r.id + '\')">✏ 수정</button>';
    foot += '</div>';

    html += '<div class="cl-stock-card' + cardCls + '">'
      + '<div class="cl-card-head">'
      +   '<span class="cl-card-cat">' + esc(r.category||'') + '</span>'
      +   '<span class="cl-card-name" title="' + esc(r.itemName||'') + '">' + esc(r.itemName||'') + '</span>'
      +   lowTag
      + '</div>'
      + '<div class="cl-card-body">'
      +   '<div class="cl-card-field">'
      +     '<span class="cl-field-lbl">보유재고</span>'
      +     '<span class="cl-field-val' + (low ? ' low' : '') + '">' + esc(r.stockQty||'—') + ' <small>' + esc(r.stockUnit||'') + '</small></span>'
      +   '</div>'
      +   '<div class="cl-card-field">'
      +     '<span class="cl-field-lbl">안전재고</span>'
      +     '<span class="cl-field-val">' + esc(r.safetyQty||'—') + ' <small>' + esc(r.safetyUnit||'') + '</small></span>'
      +   '</div>'
      +   '<div class="cl-card-field">'
      +     '<span class="cl-field-lbl">포장단위</span>'
      +     '<span class="cl-field-val" style="font-weight:400;color:var(--muted)">' + esc(r.packageUnit||'—') + '</span>'
      +   '</div>';
    if (r.remark) {
      html += '<div class="cl-card-field cl-card-field-full cl-card-remark-row">📝 ' + esc(r.remark) + '</div>';
    }
    html += '</div>' + foot + '</div>';
  });
  html += '</div>';
  return html;
}

function isLowStock(sq, sf) {
  if (!sq || !sf) return false;
  var a = parseFloat(sq), b = parseFloat(sf);
  return !isNaN(a) && !isNaN(b) && a < b;
}

/* ══════════════════════════════
   입출고 이력
══════════════════════════════ */
function loadHistory() {
  var qs = '?type='   + encodeURIComponent(document.getElementById('hType').value)
         + '&fromDt=' + encodeURIComponent(document.getElementById('hFrom').value)
         + '&toDt='   + encodeURIComponent(document.getElementById('hTo').value);
  fetch(base + '/consumable/history/list' + qs)
    .then(function(r){ return r.json(); })
    .then(function(d){
      if (!d.success) { alert(d.error || '조회 실패'); return; }
      renderHistory(d.data || []);
    });
}

function renderHistory(list) {
  document.getElementById('histCount').textContent = '총 ' + list.length + '건';

  if (tabletMode) {
    document.getElementById('histTableWrap').style.display = 'none';
    var hc = document.getElementById('histCards');
    hc.style.display = '';
    hc.innerHTML = buildHistCards(list);
    return;
  }

  document.getElementById('histTableWrap').style.display = '';
  document.getElementById('histCards').style.display = 'none';

  if (!list.length) {
    document.getElementById('histBody').innerHTML =
      '<tr><td colspan="9" style="text-align:center;padding:40px;color:var(--muted)">이력이 없습니다.</td></tr>';
    return;
  }
  var html = '';
  list.forEach(function(r, i) {
    var badge = r.type === 'IN'
      ? '<span class="badge b-in">입고</span>'
      : '<span class="badge b-out">사용</span>';
    var qtyStr = r.type === 'IN'
      ? '<span style="color:var(--primary);font-weight:700">+' + esc(r.qty||'') + '</span>'
      : '<span style="color:var(--red);font-weight:700">'     + esc(r.qty||'') + '</span>';
    var act = '';
    if (canDel) act = '<button class="btn-xs btn-xs-del" onclick="deleteHistory(' + r.id + ')">삭제</button>';

    html += '<tr>'
      + '<td style="text-align:center;color:var(--muted);font-size:12px">' + (i+1) + '</td>'
      + '<td style="font-size:12px">'   + esc(r.regDate||'') + '</td>'
      + '<td style="text-align:center">' + badge + '</td>'
      + '<td style="color:var(--muted)">' + esc(r.category||'') + '</td>'
      + '<td style="font-weight:600">'   + esc(r.itemName||'') + '</td>'
      + '<td style="text-align:center">' + qtyStr + '</td>'
      + '<td style="font-size:12px;color:var(--muted)">' + esc(r.remark||'') + '</td>'
      + '<td>'                           + esc(r.userName||'') + '</td>'
      + '<td>'                           + act + '</td>'
      + '</tr>';
  });
  document.getElementById('histBody').innerHTML = html;
}

/* ── 태블릿 모드: 이력 카드 HTML 생성 ── */
function buildHistCards(list) {
  if (!list.length) {
    return '<div style="text-align:center;padding:60px;color:var(--muted);font-size:15px">이력이 없습니다.</div>';
  }
  var html = '<div class="cl-hist-cards">';
  list.forEach(function(r) {
    var isIn   = r.type === 'IN';
    var badge  = isIn
      ? '<span class="badge b-in" style="font-size:12px;padding:3px 11px">📦 입고</span>'
      : '<span class="badge b-out" style="font-size:12px;padding:3px 11px">🔧 사용</span>';
    var qtyStr = isIn
      ? '<span style="color:var(--primary);font-size:22px;font-weight:700">+' + esc(r.qty||'') + '</span>'
      : '<span style="color:var(--red);font-size:22px;font-weight:700">'     + esc(r.qty||'') + '</span>';
    var delBtn = canDel
      ? '<button class="btn-xs btn-xs-del" onclick="deleteHistory(' + r.id + ')" style="padding:5px 14px;font-size:12px">삭제</button>'
      : '';

    html += '<div class="cl-hist-card">'
      + '<div class="cl-hist-card-top">'
      +   badge
      +   '<span style="font-size:12px;color:var(--muted)">' + esc(r.regDate||'') + '</span>'
      + '</div>'
      + '<div class="cl-hist-card-item">'
      +   '<div>'
      +     '<div style="font-size:11px;color:var(--muted);font-weight:600;margin-bottom:2px">' + esc(r.category||'') + '</div>'
      +     '<div style="font-size:16px;font-weight:700">' + esc(r.itemName||'') + '</div>'
      +   '</div>'
      +   qtyStr
      + '</div>';
    if (r.remark || r.userName) {
      html += '<div class="cl-hist-card-meta">';
      if (r.remark)   html += '<span>📝 ' + esc(r.remark) + '</span>';
      if (r.userName) html += '<span>👤 ' + esc(r.userName) + '</span>';
      html += '</div>';
    }
    if (delBtn) html += '<div style="text-align:right;margin-top:2px">' + delBtn + '</div>';
    html += '</div>';
  });
  html += '</div>';
  return html;
}

function deleteHistory(id) {
  if (!confirm('이 이력을 삭제하시겠습니까?')) return;
  fetch(base + '/consumable/history/delete', {
    method:'POST', headers:{'Content-Type':'application/json'},
    body: JSON.stringify({id: id})
  }).then(function(r){ return r.json(); })
    .then(function(d){
      if (d.success) { loadHistory(); loadStock(); }
      else alert(d.error || '삭제 실패');
    });
}

/* ══════════════════════════════
   항목 추가/수정 모달
══════════════════════════════ */
var editingId = null;

function openEditModal(id) {
  editingId = id ? parseInt(id) : null;
  document.getElementById('editModalTitle').textContent = id ? '항목 수정' : '항목 추가';
  if (id) {
    var r = stockCache.find(function(x){ return x.id == id; });
    if (!r) return;
    document.getElementById('mCategory').value   = r.category   ||'';
    document.getElementById('mItemName').value   = r.itemName   ||'';
    document.getElementById('mPackageUnit').value= r.packageUnit||'';
    document.getElementById('mStockQty').value   = r.stockQty   ||'';
    document.getElementById('mStockUnit').value  = r.stockUnit  ||'';
    document.getElementById('mSafetyQty').value  = r.safetyQty  ||'';
    document.getElementById('mSafetyUnit').value = r.safetyUnit ||'';
    document.getElementById('mRemark').value     = r.remark     ||'';
    document.getElementById('mSortOrder').value  = r.sortOrder  ||0;
  } else {
    ['mCategory','mItemName','mPackageUnit','mStockQty','mStockUnit','mSafetyQty','mSafetyUnit','mRemark']
      .forEach(function(id){ document.getElementById(id).value = ''; });
    document.getElementById('mSortOrder').value = 0;
  }
  document.getElementById('editModal').classList.add('show');
}
function closeEditModal() { document.getElementById('editModal').classList.remove('show'); }

function saveEditModal() {
  var cat  = document.getElementById('mCategory').value.trim();
  var name = document.getElementById('mItemName').value.trim();
  if (!cat)  { alert('구분은 필수입니다.'); return; }
  if (!name) { alert('품명/규격은 필수입니다.'); return; }
  fetch(base + '/consumable/save', {
    method:'POST', headers:{'Content-Type':'application/json'},
    body: JSON.stringify({
      id:          editingId || '',
      category:    cat,
      itemName:    name,
      packageUnit: document.getElementById('mPackageUnit').value.trim(),
      stockQty:    document.getElementById('mStockQty').value.trim(),
      stockUnit:   document.getElementById('mStockUnit').value.trim(),
      safetyQty:   document.getElementById('mSafetyQty').value.trim(),
      safetyUnit:  document.getElementById('mSafetyUnit').value.trim(),
      remark:      document.getElementById('mRemark').value.trim(),
      sortOrder:   parseInt(document.getElementById('mSortOrder').value)||0
    })
  }).then(function(r){ return r.json(); })
    .then(function(d){
      if (!d.success) { alert(d.error||'저장 실패'); return; }
      closeEditModal(); loadStock();
    });
}

function deleteItem(id, name) {
  if (!confirm('['+name+'] 항목을 삭제하시겠습니까?')) return;
  fetch(base + '/consumable/delete', {
    method:'POST', headers:{'Content-Type':'application/json'},
    body: JSON.stringify({id: id})
  }).then(function(r){ return r.json(); })
    .then(function(d){ if(d.success) loadStock(); else alert(d.error||'삭제 실패'); });
}

/* ══════════════════════════════
   입고 모달
══════════════════════════════ */
function openInModal(ledgerId) {
  if (!stockCache.length) { alert('먼저 재고 현황을 조회하세요.'); return; }
  document.getElementById('inQty').value      = '';
  document.getElementById('inRemark').value   = '';
  document.getElementById('inUserName').value = '';
  if (ledgerId) document.getElementById('inLedgerId').value = ledgerId;
  document.getElementById('inModal').classList.add('show');
}
function closeInModal() { document.getElementById('inModal').classList.remove('show'); }

function saveInModal() {
  var qty = document.getElementById('inQty').value.trim();
  if (!qty) { alert('수량을 입력하세요.'); return; }
  fetch(base + '/consumable/history/save', {
    method:'POST', headers:{'Content-Type':'application/json'},
    body: JSON.stringify({
      ledgerId: document.getElementById('inLedgerId').value,
      type:     'IN',
      qty:      qty,
      remark:   document.getElementById('inRemark').value.trim(),
      userName: document.getElementById('inUserName').value.trim()
    })
  }).then(function(r){ return r.json(); })
    .then(function(d){
      if (!d.success) { alert(d.error||'저장 실패'); return; }
      closeInModal(); loadStock();
    });
}

/* ══════════════════════════════
   사용 모달
══════════════════════════════ */
function openOutModal(ledgerId) {
  if (!stockCache.length) { alert('먼저 재고 현황을 조회하세요.'); return; }
  document.getElementById('outQty').value      = '';
  document.getElementById('outRemark').value   = '';
  document.getElementById('outUserName').value = '';
  if (ledgerId) document.getElementById('outLedgerId').value = ledgerId;
  document.getElementById('outModal').classList.add('show');
}
function closeOutModal() { document.getElementById('outModal').classList.remove('show'); }

function saveOutModal() {
  var qty = document.getElementById('outQty').value.trim();
  if (!qty) { alert('수량을 입력하세요.'); return; }
  fetch(base + '/consumable/history/save', {
    method:'POST', headers:{'Content-Type':'application/json'},
    body: JSON.stringify({
      ledgerId: document.getElementById('outLedgerId').value,
      type:     'OUT',
      qty:      qty,
      remark:   document.getElementById('outRemark').value.trim(),
      userName: document.getElementById('outUserName').value.trim()
    })
  }).then(function(r){ return r.json(); })
    .then(function(d){
      if (!d.success) { alert(d.error||'저장 실패'); return; }
      closeOutModal(); loadStock();
    });
}

/* ══════════════════════════════
   공통
══════════════════════════════ */
function buildSelects() {
  var opts = stockCache.map(function(r){
    return '<option value="' + r.id + '">' + esc(r.category) + ' — ' + esc(r.itemName) + '</option>';
  }).join('');
  ['inLedgerId','outLedgerId'].forEach(function(id){ document.getElementById(id).innerHTML = opts; });
}

function buildCategoryDatalist() {
  var cats = [];
  stockCache.forEach(function(r){ if(r.category && cats.indexOf(r.category)<0) cats.push(r.category); });
  document.getElementById('categoryList').innerHTML =
    cats.map(function(c){ return '<option value="'+esc(c)+'">'; }).join('');
}

function doExcel() { location.href = base + '/consumable/excel'; }

function esc(s){ return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }

/* ── 이력 탭 날짜 기본값 ── */
(function(){
  var today = new Date();
  var y = today.getFullYear(), m = String(today.getMonth()+1).padStart(2,'0');
  document.getElementById('hFrom').value = y+'-'+m+'-01';
  document.getElementById('hTo').value   = today.toISOString().slice(0,10);
})();
</script>
</body>
</html>
