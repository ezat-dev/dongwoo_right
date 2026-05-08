<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common_style.jsp" %>
<style>
/* ── 탭 ── */
.sp-tabs { display:flex; gap:6px; margin-bottom:16px; }
.sp-tab  { padding:7px 22px; border-radius:8px; border:1px solid var(--border);
  background:var(--white); font-size:13px; font-weight:600;
  cursor:pointer; transition:all .13s; color:var(--muted); }
.sp-tab.active { background:var(--primary); color:#fff; border-color:var(--primary); }

/* ── KPI 카드 ── */
.kpi-row { display:grid; grid-template-columns:repeat(4,1fr); gap:12px; margin-bottom:16px; }
@media(max-width:640px){ .kpi-row{grid-template-columns:repeat(2,1fr);} }
.kpi-card { background:var(--white); border:1px solid var(--border); border-radius:12px;
  padding:14px 18px; box-shadow:var(--shadow); text-align:center; }
.kpi-lbl { font-size:11px; color:var(--muted); margin-bottom:4px; }
.kpi-val { font-size:26px; font-weight:800; }

/* ── 재고 바 ── */
.stock-bar-bg   { display:inline-block; width:64px; height:7px; background:var(--bg);
  border-radius:4px; overflow:hidden; vertical-align:middle; margin-right:5px; }
.stock-bar-fill { height:100%; border-radius:4px; transition:width .3s; }

/* ── 상태 뱃지 ── */
.badge { display:inline-block; padding:2px 9px; border-radius:20px; font-size:11px; font-weight:700; white-space:nowrap; }
.b-ok     { background:var(--green-l); color:var(--green);  border:1px solid #9AE6B4; }
.b-low    { background:#FFFAF0;        color:var(--orange); border:1px solid #FBD38D; }
.b-none   { background:#FFF5F5;        color:var(--red);    border:1px solid #FEB2B2; }
.b-in     { background:#EBF8FF;        color:var(--primary);border:1px solid #BEE3F8; }
.b-out    { background:#FFF5F5;        color:var(--red);    border:1px solid #FEB2B2; }

/* ── 필터 바 ── */
.ctrl-bar { display:flex; gap:10px; flex-wrap:wrap; align-items:flex-end; margin-bottom:14px; }

/* ── 모달 ── */
.modal-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,.4);
  z-index:300; align-items:center; justify-content:center; }
.modal-overlay.show { display:flex; }
.modal-box { background:var(--white); border-radius:14px; padding:26px 28px;
  width:520px; max-width:96vw; box-shadow:0 8px 40px rgba(0,0,0,.2); max-height:92vh; overflow-y:auto; }
.modal-box.sm { width:420px; }
.modal-title  { font-size:15px; font-weight:700; margin-bottom:18px; }
.modal-grid   { display:grid; grid-template-columns:1fr 1fr; gap:12px 16px; }
.modal-grid .full { grid-column:1/-1; }
.modal-actions { display:flex; justify-content:flex-end; gap:8px; margin-top:20px; }

/* ── 액션 버튼 ── */
.act-btns { display:flex; gap:4px; white-space:nowrap; }
.btn-xs { padding:2px 8px; font-size:11px; border-radius:4px; border:1px solid var(--border); background:none; cursor:pointer; }
.btn-xs-edit:hover { border-color:var(--primary); color:var(--primary); }
.btn-xs-del:hover  { border-color:var(--red); color:var(--red); background:var(--red-l); }
.btn-xs-in  { border-color:var(--primary); color:var(--primary); }
.btn-xs-out { border-color:var(--orange);  color:var(--orange); }

/* ── 테이블 래퍼 ── */
.table-wrap { overflow-x:auto; }

/* ── 모바일 ── */
@media(max-width:640px){
  .modal-grid { grid-template-columns:1fr; }
  .modal-grid .full { grid-column:1; }
  .hide-m { display:none !important; }
}
</style>
<body>
<div class="page-wrap">
  <div class="page-header">
    <div>
      <div class="page-title">스페어파트</div>
      <div class="page-sub">열처리 설비 부품 재고 관리 · 입고/사용 이력 추적</div>
    </div>
    <div style="display:flex;gap:8px;flex-wrap:wrap" id="headerBtns">
      <button class="btn-outline" onclick="openInModal(null)"  id="btnIn"  data-perm="add">📦 입고 등록</button>
      <button class="btn-outline" onclick="openOutModal(null)" id="btnOut" data-perm="add">🔧 사용 등록</button>
      <button class="btn-primary" onclick="openPartsModal(null)" id="btnAdd" data-perm="add">＋ 부품 등록</button>
    </div>
  </div>

  <!-- KPI 요약 -->
  <div class="kpi-row">
    <div class="kpi-card">
      <div class="kpi-lbl">전체 품목</div>
      <div class="kpi-val" id="kTotal" style="color:var(--primary)">0</div>
    </div>
    <div class="kpi-card">
      <div class="kpi-lbl">재고없음</div>
      <div class="kpi-val" id="kNone" style="color:var(--red)">0</div>
    </div>
    <div class="kpi-card">
      <div class="kpi-lbl">재고 부족</div>
      <div class="kpi-val" id="kLow" style="color:var(--orange)">0</div>
    </div>
    <div class="kpi-card">
      <div class="kpi-lbl">정상</div>
      <div class="kpi-val" id="kOk" style="color:var(--green)">0</div>
    </div>
  </div>

  <!-- 탭 -->
  <div class="sp-tabs">
    <button class="sp-tab active" onclick="showTab('stock',this)">재고 현황</button>
    <button class="sp-tab"        onclick="showTab('history',this)">입출고 이력</button>
  </div>

  <!-- ══ 탭1: 재고 현황 ══ -->
  <div id="tab-stock">
    <div class="card">
      <div style="display:flex;align-items:center;gap:10px;margin-bottom:14px;flex-wrap:wrap">
        <div class="card-title" style="margin:0">부품 목록</div>
        <div style="margin-left:auto;display:flex;gap:8px;flex-wrap:wrap">
          <select class="form-select" id="fCategory" style="width:130px" onchange="loadParts()">
            <option value="">전체 카테고리</option>
            <option>히터</option><option>열전대</option><option>O2센서</option>
            <option>팬모터</option><option>밸브</option><option>필터</option><option>기타</option>
          </select>
          <input class="form-input" type="text" id="fKeyword" placeholder="품명·부품번호 검색"
                 style="width:180px" onkeydown="if(event.key==='Enter') loadParts()">
          <button class="btn-primary btn-sm" onclick="loadParts()">조회</button>
        </div>
      </div>
      <div class="table-wrap">
        <table class="data-table" id="partsTable">
          <thead>
            <tr>
              <th>No</th>
              <th>부품번호</th>
              <th>품명</th>
              <th>카테고리</th>
              <th class="hide-m">적용 설비</th>
              <th style="text-align:center">현재재고</th>
              <th style="text-align:center" class="hide-m">최소재고</th>
              <th class="hide-m">재고현황</th>
              <th style="text-align:center">총입고</th>
              <th style="text-align:center">총사용</th>
              <th style="text-align:center">상태</th>
              <th class="hide-m">단위</th>
              <th class="hide-m">교체주기</th>
              <th id="partsActCol">관리</th>
            </tr>
          </thead>
          <tbody id="partsBody">
            <tr><td colspan="14" style="text-align:center;padding:40px;color:var(--muted)">로딩 중…</td></tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- ══ 탭2: 입출고 이력 ══ -->
  <div id="tab-history" style="display:none">
    <div class="card">
      <div class="ctrl-bar">
        <div class="form-field">
          <label class="form-label">구분</label>
          <select class="form-select" id="hType" style="width:100px">
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
        <span id="historyCount" style="margin-top:18px;font-size:11px;color:var(--muted)"></span>
      </div>
      <div class="table-wrap">
        <table class="data-table">
          <thead>
            <tr>
              <th>No</th>
              <th>일시</th>
              <th>구분</th>
              <th>부품번호</th>
              <th>품명</th>
              <th class="hide-m">카테고리</th>
              <th style="text-align:center">수량</th>
              <th class="hide-m">설비</th>
              <th>작업내용</th>
              <th class="hide-m">담당자</th>
              <th id="histActCol">관리</th>
            </tr>
          </thead>
          <tbody id="historyBody">
            <tr><td colspan="11" style="text-align:center;padding:40px;color:var(--muted)">조회 버튼을 눌러 이력을 확인하세요</td></tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<!-- ══ 부품 마스터 추가/수정 모달 ══ -->
<div class="modal-overlay" id="partsModal">
  <div class="modal-box">
    <div class="modal-title">🔩 <span id="partsModalTitle">부품 등록</span></div>
    <div class="modal-grid">
      <div class="form-field">
        <label class="form-label">부품번호 *</label>
        <input class="form-input" type="text" id="mPartNo" placeholder="예) HT-001" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">품명 *</label>
        <input class="form-input" type="text" id="mPartName" placeholder="예) 히터 엘리먼트 3kW" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">카테고리</label>
        <select class="form-select" id="mCategory" style="width:100%">
          <option>히터</option><option>열전대</option><option>O2센서</option>
          <option>팬모터</option><option>밸브</option><option>필터</option><option>기타</option>
        </select>
      </div>
      <div class="form-field">
        <label class="form-label">단위</label>
        <input class="form-input" type="text" id="mUnit" value="EA" style="width:100%">
      </div>
      <div class="form-field full">
        <label class="form-label">적용 설비</label>
        <input class="form-input" type="text" id="mEquipment" placeholder="예) 열처리로 전계열" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">최소재고 (EA)</label>
        <input class="form-input" type="number" id="mMinStock" value="1" min="0" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">교체주기 (개월, 0=없음)</label>
        <input class="form-input" type="number" id="mReplaceCycle" value="0" min="0" style="width:100%">
      </div>
    </div>
    <div class="modal-actions">
      <button class="btn-outline" onclick="closePartsModal()">취소</button>
      <button class="btn-primary" onclick="savePartsModal()">저장</button>
    </div>
  </div>
</div>

<!-- ══ 입고 모달 ══ -->
<div class="modal-overlay" id="inModal">
  <div class="modal-box sm">
    <div class="modal-title">📦 입고 등록</div>
    <div style="display:flex;flex-direction:column;gap:12px">
      <div class="form-field">
        <label class="form-label">부품 *</label>
        <select class="form-select" id="inPartNo" style="width:100%"></select>
      </div>
      <div class="form-field">
        <label class="form-label">입고 수량 *</label>
        <input class="form-input" type="number" id="inQty" min="1" value="1" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">작업내용</label>
        <input class="form-input" type="text" id="inWorkDesc" placeholder="예) 신규 입고, 정기 발주" style="width:100%">
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
        <label class="form-label">부품 *</label>
        <select class="form-select" id="outPartNo" style="width:100%"></select>
      </div>
      <div class="form-field">
        <label class="form-label">사용 수량 *</label>
        <input class="form-input" type="number" id="outQty" min="1" value="1" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">사용 설비</label>
        <input class="form-input" type="text" id="outEquipment" placeholder="예) 열처리로 1호기" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">작업내용</label>
        <input class="form-input" type="text" id="outWorkDesc" placeholder="예) 히터 교체, 정기 교환" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">담당자</label>
        <input class="form-input" type="text" id="outUserName" placeholder="성명" style="width:100%">
      </div>
    </div>
    <div class="modal-actions">
      <button class="btn-outline" onclick="closeOutModal()">취소</button>
      <button class="btn-primary btn-danger" onclick="saveOutModal()" style="background:var(--orange);border-color:var(--orange)">사용 처리</button>
    </div>
  </div>
</div>

<script>
var base      = '${pageContext.request.contextPath}';
var canAdd    = true;
var canEdit   = true;
var canDel    = true;
var partsCache = [];  // 부품 목록 캐시 (모달 select용)

/* ── 권한 로드 ── */
fetch(base + '/perm/my')
  .then(function(r){ return r.json(); })
  .then(function(perms){
    var p = perms['spare/parts'] || {};
    canAdd  = (p.canAdd  !== 'N');
    canEdit = (p.canEdit !== 'N');
    canDel  = (p.canDel  !== 'N');
    if (!canAdd) {
      ['btnIn','btnOut','btnAdd'].forEach(function(id){
        var el = document.getElementById(id);
        if(el) el.style.display = 'none';
      });
    }
    loadParts();
  })
  .catch(function(){ loadParts(); });

/* ══════════════════════════════════════════
   재고 현황
══════════════════════════════════════════ */
function loadParts() {
  var cat = document.getElementById('fCategory').value;
  var kw  = document.getElementById('fKeyword').value.trim();
  var qs  = '?category=' + encodeURIComponent(cat) + '&keyword=' + encodeURIComponent(kw);

  fetch(base + '/parts/list' + qs)
    .then(function(r){ return r.json(); })
    .then(function(d){
      if (!d.success) { alert(d.error || '조회 실패'); return; }
      partsCache = d.data || [];
      renderParts(partsCache);
      updatePartsSelect();
    })
    .catch(function(){ alert('부품 목록 로드 실패'); });
}

function renderParts(list) {
  var none=0, low=0, ok=0;
  var html = '';
  list.forEach(function(r, i){
    var cur = r.currentStock;
    var st  = r.stockStatus;
    var stockCls, barColor, badgeCls;
    if      (st === '재고없음') { stockCls=''; barColor='var(--red)';    badgeCls='b-none'; none++; }
    else if (st === '부족')     { stockCls=''; barColor='var(--orange)'; badgeCls='b-low';  low++;  }
    else                        { stockCls=''; barColor='var(--green)';  badgeCls='b-ok';   ok++;   }

    var pct = r.minStock > 0 ? Math.min(100, Math.round(cur / (r.minStock * 2) * 100)) : (cur > 0 ? 100 : 0);
    var cycle = r.replaceCycle > 0 ? r.replaceCycle + '개월' : '—';

    var actHtml = '<div class="act-btns">';
    if (canAdd)  actHtml += '<button class="btn-xs btn-xs-in"   onclick="openInModal(\'' + esc(r.partNo) + '\')">입고</button>'
                          + '<button class="btn-xs btn-xs-out"  onclick="openOutModal(\'' + esc(r.partNo) + '\')">사용</button>';
    if (canEdit) actHtml += '<button class="btn-xs btn-xs-edit" onclick="openPartsModal(\'' + esc(r.partNo) + '\')">수정</button>';
    if (canDel)  actHtml += '<button class="btn-xs btn-xs-del"  onclick="deleteParts(\'' + esc(r.partNo) + '\')">삭제</button>';
    actHtml += '</div>';

    html += '<tr>'
      + '<td style="text-align:center">' + (i+1) + '</td>'
      + '<td style="font-family:monospace;font-size:12px">' + esc(r.partNo) + '</td>'
      + '<td style="font-weight:600">' + esc(r.partName) + '</td>'
      + '<td><span class="badge b-ok" style="border-color:transparent;background:var(--bg);color:var(--muted)">' + esc(r.category) + '</span></td>'
      + '<td class="hide-m">' + esc(r.equipment || '—') + '</td>'
      + '<td style="text-align:center;font-weight:700;font-size:15px;color:' + barColor + '">' + cur + '</td>'
      + '<td style="text-align:center;color:var(--muted)" class="hide-m">' + r.minStock + '</td>'
      + '<td class="hide-m"><span class="stock-bar-bg"><span class="stock-bar-fill" style="width:' + pct + '%;background:' + barColor + '"></span></span></td>'
      + '<td style="text-align:center;color:var(--primary)">' + r.totalIn + '</td>'
      + '<td style="text-align:center;color:var(--orange)">'  + r.totalOut + '</td>'
      + '<td style="text-align:center"><span class="badge ' + badgeCls + '">' + st + '</span></td>'
      + '<td class="hide-m" style="color:var(--muted)">' + esc(r.unit) + '</td>'
      + '<td class="hide-m" style="color:var(--muted)">' + cycle + '</td>'
      + '<td>' + actHtml + '</td>'
      + '</tr>';
  });

  document.getElementById('partsBody').innerHTML = html ||
    '<tr><td colspan="14" style="text-align:center;padding:40px;color:var(--muted)">등록된 부품이 없습니다. 우상단 <strong>＋ 부품 등록</strong>을 눌러 추가하세요.</td></tr>';

  document.getElementById('kTotal').textContent = list.length;
  document.getElementById('kNone').textContent  = none;
  document.getElementById('kLow').textContent   = low;
  document.getElementById('kOk').textContent    = ok;
}

/* ══════════════════════════════════════════
   입출고 이력
══════════════════════════════════════════ */
function loadHistory() {
  var type   = document.getElementById('hType').value;
  var fromDt = document.getElementById('hFrom').value;
  var toDt   = document.getElementById('hTo').value;
  var qs = '?type=' + encodeURIComponent(type)
         + '&fromDt=' + encodeURIComponent(fromDt)
         + '&toDt='   + encodeURIComponent(toDt);

  fetch(base + '/parts/history/list' + qs)
    .then(function(r){ return r.json(); })
    .then(function(d){
      if (!d.success) { alert(d.error || '조회 실패'); return; }
      renderHistory(d.data || []);
    });
}

function renderHistory(list) {
  document.getElementById('historyCount').textContent = '총 ' + list.length + '건';
  if (!list.length) {
    document.getElementById('historyBody').innerHTML =
      '<tr><td colspan="11" style="text-align:center;padding:40px;color:var(--muted)">이력이 없습니다.</td></tr>';
    return;
  }
  var html = '';
  list.forEach(function(r, i){
    var typeBadge = r.type === 'IN'
      ? '<span class="badge b-in">입고</span>'
      : '<span class="badge b-out">사용</span>';
    var qtyStr = r.type === 'IN'
      ? '<span style="color:var(--primary);font-weight:700">+' + r.qty + '</span>'
      : '<span style="color:var(--red);font-weight:700">-'    + r.qty + '</span>';

    var actHtml = '';
    if (canDel) actHtml = '<button class="btn-xs btn-xs-del" onclick="deleteHistory(' + r.id + ')">삭제</button>';

    html += '<tr>'
      + '<td style="text-align:center">' + (i+1) + '</td>'
      + '<td style="font-size:12px">'    + esc(r.createdAt || '') + '</td>'
      + '<td style="text-align:center">' + typeBadge + '</td>'
      + '<td style="font-family:monospace;font-size:12px">' + esc(r.partNo || '') + '</td>'
      + '<td style="font-weight:600">'   + esc(r.partName || '') + '</td>'
      + '<td class="hide-m" style="color:var(--muted)">' + esc(r.category || '') + '</td>'
      + '<td style="text-align:center">' + qtyStr + '</td>'
      + '<td class="hide-m">'            + esc(r.equipment || '—') + '</td>'
      + '<td>'                           + esc(r.workDesc  || '—') + '</td>'
      + '<td class="hide-m">'            + esc(r.userName  || '—') + '</td>'
      + '<td>'                           + actHtml + '</td>'
      + '</tr>';
  });
  document.getElementById('historyBody').innerHTML = html;
}

/* ══════════════════════════════════════════
   부품 마스터 모달
══════════════════════════════════════════ */
var editingPartNo = null;

function openPartsModal(partNo) {
  editingPartNo = partNo || null;
  document.getElementById('partsModalTitle').textContent = partNo ? '부품 수정' : '부품 등록';

  if (partNo) {
    var r = partsCache.find(function(p){ return p.partNo === partNo; });
    if (r) {
      document.getElementById('mPartNo').value       = r.partNo;
      document.getElementById('mPartNo').readOnly    = true;
      document.getElementById('mPartName').value     = r.partName;
      document.getElementById('mCategory').value     = r.category;
      document.getElementById('mEquipment').value    = r.equipment || '';
      document.getElementById('mUnit').value         = r.unit || 'EA';
      document.getElementById('mMinStock').value     = r.minStock;
      document.getElementById('mReplaceCycle').value = r.replaceCycle;
    }
  } else {
    document.getElementById('mPartNo').value       = '';
    document.getElementById('mPartNo').readOnly    = false;
    document.getElementById('mPartName').value     = '';
    document.getElementById('mCategory').value     = '히터';
    document.getElementById('mEquipment').value    = '';
    document.getElementById('mUnit').value         = 'EA';
    document.getElementById('mMinStock').value     = '1';
    document.getElementById('mReplaceCycle').value = '0';
  }
  document.getElementById('partsModal').classList.add('show');
}
function closePartsModal() { document.getElementById('partsModal').classList.remove('show'); }

function savePartsModal() {
  var partNo = document.getElementById('mPartNo').value.trim();
  var partName = document.getElementById('mPartName').value.trim();
  if (!partNo || !partName) { alert('부품번호와 품명은 필수입니다.'); return; }

  fetch(base + '/parts/save', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      partNo:       partNo,
      partName:     partName,
      category:     document.getElementById('mCategory').value,
      equipment:    document.getElementById('mEquipment').value.trim(),
      unit:         document.getElementById('mUnit').value.trim() || 'EA',
      minStock:     document.getElementById('mMinStock').value,
      replaceCycle: document.getElementById('mReplaceCycle').value
    })
  }).then(function(r){ return r.json(); })
    .then(function(d){
      if (!d.success) { alert(d.error || '저장 실패'); return; }
      closePartsModal();
      loadParts();
    });
}

function deleteParts(partNo) {
  if (!confirm('[' + partNo + '] 부품을 삭제하시겠습니까?\n관련 이력도 함께 삭제됩니다.')) return;
  fetch(base + '/parts/delete', {
    method: 'POST', headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ partNo: partNo })
  }).then(function(r){ return r.json(); })
    .then(function(d){ if (d.success) loadParts(); else alert(d.error || '삭제 실패'); });
}

/* ══════════════════════════════════════════
   입고 모달
══════════════════════════════════════════ */
function updatePartsSelect() {
  var opts = partsCache.map(function(p){
    return '<option value="' + esc(p.partNo) + '">' + esc(p.partNo) + ' — ' + esc(p.partName) + '</option>';
  }).join('');
  ['inPartNo','outPartNo'].forEach(function(id){
    document.getElementById(id).innerHTML = opts;
  });
}

function openInModal(partNo) {
  if (partsCache.length === 0) { alert('먼저 부품을 등록하세요.'); return; }
  document.getElementById('inQty').value      = '1';
  document.getElementById('inWorkDesc').value = '신규 입고';
  document.getElementById('inUserName').value = '';
  if (partNo) document.getElementById('inPartNo').value = partNo;
  document.getElementById('inModal').classList.add('show');
}
function closeInModal() { document.getElementById('inModal').classList.remove('show'); }

function saveInModal() {
  var qty = parseInt(document.getElementById('inQty').value);
  if (qty < 1) { alert('수량을 1 이상 입력하세요.'); return; }
  fetch(base + '/parts/history/save', {
    method: 'POST', headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      partNo:   document.getElementById('inPartNo').value,
      type:     'IN',
      qty:      qty,
      workDesc: document.getElementById('inWorkDesc').value.trim(),
      userName: document.getElementById('inUserName').value.trim()
    })
  }).then(function(r){ return r.json(); })
    .then(function(d){
      if (!d.success) { alert(d.error || '저장 실패'); return; }
      closeInModal();
      loadParts();
    });
}

/* ══════════════════════════════════════════
   사용 모달
══════════════════════════════════════════ */
function openOutModal(partNo) {
  if (partsCache.length === 0) { alert('먼저 부품을 등록하세요.'); return; }
  document.getElementById('outQty').value       = '1';
  document.getElementById('outEquipment').value = '';
  document.getElementById('outWorkDesc').value  = '';
  document.getElementById('outUserName').value  = '';
  if (partNo) document.getElementById('outPartNo').value = partNo;
  document.getElementById('outModal').classList.add('show');
}
function closeOutModal() { document.getElementById('outModal').classList.remove('show'); }

function saveOutModal() {
  var qty = parseInt(document.getElementById('outQty').value);
  if (qty < 1) { alert('수량을 1 이상 입력하세요.'); return; }
  var partNo = document.getElementById('outPartNo').value;
  var part   = partsCache.find(function(p){ return p.partNo === partNo; });
  if (part && part.currentStock < qty) {
    if (!confirm('현재 재고(' + part.currentStock + ')보다 많은 수량입니다. 계속 진행하시겠습니까?')) return;
  }
  fetch(base + '/parts/history/save', {
    method: 'POST', headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      partNo:    partNo,
      type:      'OUT',
      qty:       qty,
      equipment: document.getElementById('outEquipment').value.trim(),
      workDesc:  document.getElementById('outWorkDesc').value.trim(),
      userName:  document.getElementById('outUserName').value.trim()
    })
  }).then(function(r){ return r.json(); })
    .then(function(d){
      if (!d.success) { alert(d.error || '저장 실패'); return; }
      closeOutModal();
      loadParts();
    });
}

/* ══════════════════════════════════════════
   이력 삭제
══════════════════════════════════════════ */
function deleteHistory(id) {
  if (!confirm('이 이력을 삭제하시겠습니까?\n재고 수량이 자동으로 재계산됩니다.')) return;
  fetch(base + '/parts/history/delete', {
    method: 'POST', headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ id: id })
  }).then(function(r){ return r.json(); })
    .then(function(d){
      if (d.success) { loadHistory(); loadParts(); }
      else alert(d.error || '삭제 실패');
    });
}

/* ══════════════════════════════════════════
   탭 전환
══════════════════════════════════════════ */
function showTab(id, btn) {
  document.getElementById('tab-stock').style.display   = id === 'stock'   ? '' : 'none';
  document.getElementById('tab-history').style.display = id === 'history' ? '' : 'none';
  document.querySelectorAll('.sp-tab').forEach(function(b){ b.classList.remove('active'); });
  if (btn) btn.classList.add('active');
  if (id === 'history') loadHistory();
}

/* ══════════════════════════════════════════
   초기화
══════════════════════════════════════════ */
(function(){
  var today = new Date();
  var y = today.getFullYear(), m = String(today.getMonth()+1).padStart(2,'0');
  document.getElementById('hFrom').value = y + '-' + m + '-01';
  document.getElementById('hTo').value   = today.toISOString().slice(0,10);
})();

function esc(s){ return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }
</script>
</body>
</html>
