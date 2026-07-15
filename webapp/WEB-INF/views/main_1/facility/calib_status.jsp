<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common_style.jsp" %>
<% String ctx = request.getContextPath(); %>
<link rel="stylesheet" href="<%= ctx %>/css/tabulator/tabulator_simple.css">
<script src="<%= ctx %>/js/tabulator/tabulator.js"></script>
<style>
/* ── 필터 바 ── */
.ctrl-bar { display:flex; gap:10px; flex-wrap:wrap; align-items:flex-end; margin-bottom:16px; }

/* ── D-Day 뱃지 ── */
.dday { font-weight:700; font-size:12px; }
.dday.over { color:var(--red); }
.dday.near { color:var(--orange); }
.dday.ok   { color:var(--green); }
.dday.warn { color:#805AD5; }

/* ── 상태 뱃지 ── */
.badge { display:inline-block; padding:2px 9px; border-radius:20px; font-size:11px; font-weight:700; white-space:nowrap; }
.badge-ok     { background:var(--green-l); color:var(--green);  border:1px solid #9AE6B4; }
.badge-warn   { background:#FFFAF0;        color:var(--orange); border:1px solid #FBD38D; }
.badge-purple { background:#FAF5FF;        color:#6B46C1;       border:1px solid #D6BCFA; }

/* ── 첨부 링크 ── */
.attach-link { font-size:11px; color:var(--primary); text-decoration:underline; white-space:nowrap; }
.attach-upload-btn { font-size:11px; padding:1px 7px; border:1px dashed var(--border);
  border-radius:4px; background:none; cursor:pointer; color:var(--muted); }
.attach-upload-btn:hover { border-color:var(--primary); color:var(--primary); }

/* ── Tabulator 오버라이드 ── */
.tabulator { border:none !important; background:transparent !important; }
.tabulator .tabulator-header { background:#EDF2F7 !important; border-bottom:2px solid #E2E8F0 !important; }
.tabulator .tabulator-header .tabulator-col {
  background:transparent !important; font-size:12px !important; font-weight:700 !important;
  color:#4A5568 !important; padding:8px 10px !important; border-right:1px solid #E2E8F0 !important;
}
.tabulator .tabulator-header .tabulator-col:last-child { border-right:none !important; }
.tabulator .tabulator-header .tabulator-col.tabulator-sortable:hover { background:#E2E8F0 !important; }
.tabulator .tabulator-row { font-size:13px !important; border-bottom:1px solid #F0F4F8 !important; }
.tabulator .tabulator-row:hover { background:#EBF8FF !important; }
.tabulator .tabulator-row .tabulator-cell { padding:9px 10px !important; }
.tabulator .tabulator-row.tabulator-row-even { background:#FAFBFC !important; }
.tabulator .tabulator-placeholder { color:var(--muted) !important; font-size:13px !important; padding:48px !important; }
.tabulator .tabulator-footer { background:#F7FAFC !important; border-top:1px solid #E2E8F0 !important;
  font-size:12px !important; }

/* ── 액션 버튼 ── */
.act-btns { display:flex; gap:4px; justify-content:center; }
.btn-xs { padding:2px 8px; font-size:11px; border-radius:4px; border:1px solid var(--border);
  background:none; cursor:pointer; }
.btn-xs-edit:hover { border-color:var(--primary); color:var(--primary); }
.btn-xs-del:hover  { border-color:var(--red); color:var(--red); background:var(--red-l); }

/* ── 모달 ── */
.modal-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,.45);
  z-index:300; align-items:center; justify-content:center; }
.modal-overlay.show { display:flex; }
.modal-box { background:var(--white); border-radius:14px; padding:26px 28px;
  width:640px; max-width:96vw; box-shadow:0 8px 40px rgba(0,0,0,.2); max-height:92vh; overflow-y:auto; }
.modal-title { font-size:15px; font-weight:700; margin-bottom:18px; display:flex; align-items:center; gap:8px; }
.modal-grid  { display:grid; grid-template-columns:1fr 1fr; gap:12px 16px; }
.modal-grid .full { grid-column:1/-1; }
.modal-actions { display:flex; justify-content:flex-end; gap:8px; margin-top:20px; }

/* ── 보전 내용 팝업 ── */
.maint-popup { background:var(--white); border-radius:14px; padding:24px 26px;
  width:480px; max-width:96vw; box-shadow:0 8px 40px rgba(0,0,0,.25);
  animation: popIn .2s ease; }
@keyframes popIn { from{ transform:scale(.92); opacity:0; } to{ transform:scale(1); opacity:1; } }
.maint-popup-title { font-size:15px; font-weight:700; color:var(--orange); margin-bottom:4px; }
.maint-popup-sub   { font-size:12px; color:var(--muted); margin-bottom:14px; }
.maint-popup-list  { border-radius:8px; overflow:hidden; border:1px solid var(--border);
  margin-bottom:16px; max-height:320px; overflow-y:auto; }
.maint-popup-row   { padding:10px 14px; border-bottom:1px solid var(--border); font-size:13px; }
.maint-popup-row:last-child { border-bottom:none; }
.maint-popup-row:hover { background:var(--primary-l); }

/* ── 다음 보전 예정일 ── */
.next-calib-wrap { display:flex; gap:8px; align-items:center; }
.next-calib-wrap .form-select { width:110px; }
.next-calib-wrap .form-input  { flex:1; }

/* ── 이미지 미리보기 모달 ── */
#previewOverlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,.75);
  z-index:500; align-items:center; justify-content:center; cursor:zoom-out; }
#previewOverlay.show { display:flex; }
#previewOverlay img { max-width:90vw; max-height:88vh; border-radius:10px;
  box-shadow:0 8px 40px rgba(0,0,0,.5); object-fit:contain; cursor:default; }
#previewOverlay .prev-close {
  position:absolute; top:16px; right:20px; color:#fff; font-size:28px; cursor:pointer;
  background:rgba(0,0,0,.4); border:none; border-radius:50%; width:38px; height:38px;
  display:flex; align-items:center; justify-content:center; line-height:1;
}
#previewOverlay .prev-close:hover { background:rgba(255,255,255,.2); }

/* ── 첨부 썸네일 ── */
.attach-thumb { width:72px; height:54px; object-fit:cover; display:block;
  cursor:zoom-in; border-radius:5px; border:1px solid var(--border);
  background:var(--bg); transition:opacity .15s; }
.attach-thumb:hover { opacity:.8; }
.attach-none { color:#CBD5E0; font-size:11px; }

/* ── 모바일 ── */
@media(max-width:640px){
  .modal-grid { grid-template-columns:1fr; }
  .modal-grid .full { grid-column:1; }
  .page-header { flex-direction:column; gap:10px; }
}
</style>
<body>
<div class="page-wrap">
  <div class="page-header">
    <div>
      <div class="page-title">설비별 정기보전</div>
      <div class="page-sub">설비 정기보전 이력 관리 · D-Day 추적 · 첨부 파일</div>
    </div>
    <div style="display:flex;gap:8px;flex-wrap:wrap">
      <button class="btn-outline" onclick="loadList()">🔄 새로고침</button>
      <button class="btn-primary" onclick="openModal(null)" id="addBtn" data-perm="add">＋ 보항 추가</button>
    </div>
  </div>

  <!-- 필터 바 -->
  <div class="card ctrl-bar" style="padding:14px 16px;margin-bottom:16px">
    <div class="form-field">
      <label class="form-label">설비구분</label>
      <select class="form-select" id="fEquipType" style="width:120px">
        <option value="">전체</option>
        <option>탬퍼링</option>
        <option>퀜칭</option>
        <option>세정</option>
        <option>기타</option>
      </select>
    </div>
    <div class="form-field">
      <label class="form-label">상태</label>
      <select class="form-select" id="fStatus" style="width:120px">
        <option value="">전체</option>
        <option>보전 예정</option>
        <option>보전 완료</option>
        <option>보전 연기</option>
      </select>
    </div>
    <div class="form-field">
      <label class="form-label">검색</label>
      <input class="form-input" type="text" id="fKeyword" placeholder="설비명 · 담당자" style="width:180px"
             onkeydown="if(event.key==='Enter') loadList()">
    </div>
    <button class="btn-primary btn-sm" style="margin-top:18px;height:34px" onclick="loadList()">조회</button>
    <div style="margin-left:auto;display:flex;gap:6px;margin-top:18px;align-items:center" id="summaryArea"></div>
  </div>

  <!-- Tabulator 테이블 -->
  <div class="card" style="padding:0;overflow:hidden">
    <div style="display:flex;align-items:center;justify-content:space-between;padding:12px 16px;border-bottom:1px solid var(--border)">
      <span class="card-title" style="margin:0">설비별 정기보전 현황
        <span id="totalCnt" style="font-size:11px;font-weight:400;color:var(--muted);margin-left:4px"></span>
      </span>
    </div>
    <div id="calibDiv"></div>
  </div>
</div>

<!-- ===== 이미지 미리보기 ===== -->
<div id="previewOverlay" onclick="closePreview()">
  <button class="prev-close" onclick="closePreview();event.stopPropagation()">✕</button>
  <img id="previewImg" src="" alt="미리보기" onclick="event.stopPropagation()">
</div>

<!-- ===== 추가/수정 모달 ===== -->
<div class="modal-overlay" id="editModal">
  <div class="modal-box">
    <div class="modal-title">🔧 <span id="modalTitleText">설비별 정기 보전</span></div>
    <input type="hidden" id="mCalibId">
    <div class="modal-grid">
      <div class="form-field">
        <label class="form-label">설비구분 *</label>
        <select class="form-select" id="mEquipType" style="width:100%">
          <option>탬퍼링</option><option>퀜칭</option><option>세정</option><option>기타</option>
        </select>
      </div>
      <div class="form-field">
        <label class="form-label">설비명 *</label>
        <input class="form-input" type="text" id="mEquipName" placeholder="예) 열처리로 1호기" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">보전 항목</label>
        <input class="form-input" type="text" id="mZoneLocation" placeholder="예) 예열존, 가열존" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">보전 내용</label>
        <input class="form-input" type="text" id="mMeasLocation" placeholder="예) 상부/중부/하부" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">보전 예정일</label>
        <input class="form-input" type="date" id="mLastCalibDt" style="width:100%" onchange="onLastCalibChange()">
      </div>
      <div class="form-field" style="display:none;">
        <label class="form-label">다음 보전 예정일</label>
        <div class="next-calib-wrap">
          <select class="form-select" id="mNextCalibSel" onchange="onNextCalibSelChange()">
            <option value="1m">1개월</option>
            <option value="3m">3개월</option>
            <option value="6m">6개월</option>
            <option value="1y">1년</option>
            <option value="custom">직접 선택</option>
          </select>
          <input class="form-input" type="date" id="mNextCalibDt" style="width:100%">
        </div>
      </div>
      <div class="form-field">
        <label class="form-label">보전 담당자</label>
        <input class="form-input" type="text" id="mHandler" placeholder="성명 입력" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">상태</label>
        <select class="form-select" id="mStatus" style="width:100%">
          <option>보전 예정</option>
          <option>보전 완료</option>
          <option>보전 연기</option>
        </select>
      </div>
      <div class="form-field full">
        <label class="form-label">연기 사유</label>
        <input class="form-input" type="text" id="mRemark" placeholder="특이사항 또는 연기 사유" style="width:100%">
      </div>
    </div>
    <div id="attachArea" style="display:none;margin-top:12px;padding:10px 12px;background:var(--bg);border-radius:8px;font-size:12px">
      <span style="color:var(--muted)">첨부파일: </span>
      <a id="attachLink" href="#" target="_blank" class="attach-link"></a>
      <label style="margin-left:8px">
        <span class="attach-upload-btn">파일 교체</span>
        <input type="file" id="attachFileInput" style="display:none" onchange="uploadAttach()">
      </label>
    </div>
    <div id="attachAddArea" style="margin-top:12px">
      <label style="font-size:12px;color:var(--muted)">첨부파일 (선택):
        <input type="file" id="attachFileNew" style="margin-left:6px;font-size:12px">
      </label>
    </div>
    <div class="modal-actions">
      <button class="btn-outline" onclick="closeModal()">취소</button>
      <button class="btn-primary" onclick="saveModal()">저장</button>
    </div>
  </div>
</div>

<!-- ===== 보전 예정일 도래 팝업 ===== -->
<div class="modal-overlay" id="maintPopup">
  <div class="maint-popup">
    <div class="maint-popup-title">🔔 보전 예정일 도래 알림</div>
    <div class="maint-popup-sub">보전 예정일이 지났거나 오늘인 항목이 있습니다.</div>
    <div class="maint-popup-list" id="maintList"></div>
    <div style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:8px">
      <label style="font-size:12px;color:var(--muted);cursor:pointer;display:flex;align-items:center;gap:5px">
        <input type="checkbox" id="maintHideToday" style="cursor:pointer">
        오늘 하루 보지 않기
      </label>
      <div style="display:flex;gap:8px">
        <button class="btn-outline btn-sm" onclick="closeMaintPopup()">닫기</button>
        <button class="btn-primary btn-sm" onclick="closeMaintPopup()">확인</button>
      </div>
    </div>
  </div>
</div>

<script>
var base          = '${pageContext.request.contextPath}';
var canAdd        = true;
var canEdit       = true;
var canDel        = true;
var canView       = true;
var curEditCalibId = 0;
var allData       = [];
var calibTable    = null;

/* ══════════════════════════════════════════
   Tabulator 초기화
══════════════════════════════════════════ */
calibTable = new Tabulator('#calibDiv', {
  data: [],
  layout: 'fitColumns',
  responsiveLayout: false,
  placeholder: '조회 버튼을 눌러 데이터를 불러오세요',
  columns: [
    { title: 'No', formatter: 'rownum', width: 48, hozAlign: 'center', headerSort: false },
    { title: '설비구분', field: 'equipType', width: 90, hozAlign: 'center' },
    { title: '설비명', field: 'equipName', minWidth: 110,
      formatter: function(cell){ return '<strong>' + esc(cell.getValue()||'') + '</strong>'; }
    },
    { title: '보전 항목', field: 'zoneLocation', minWidth: 100,
      formatter: function(cell){ return esc(cell.getValue()||'—'); }
    },
    { title: '보전 내용', field: 'measLocation', minWidth: 120,
      formatter: function(cell){ return esc(cell.getValue()||'—'); }
    },
    { title: '보전 예정일', field: 'lastCalibDt', width: 110, hozAlign: 'center' },
    { title: '다음 예정일', field: 'nextCalibDt', width: 110, hozAlign: 'center',
      formatter: function(cell){ return cell.getValue() || '—'; }
    },
    { title: 'D-Day', width: 100, hozAlign: 'center',
      sorter: function(a, b, aRow, bRow){
        var da = calcDday(aRow.getData().lastCalibDt);
        var db = calcDday(bRow.getData().lastCalibDt);
        if (da === null) da = 99999;
        if (db === null) db = 99999;
        return da - db;
      },
      formatter: function(cell){
        return dDayHtml(cell.getRow().getData().lastCalibDt);
      }
    },
    { title: '보전 담당자', field: 'handler', width: 95,
      formatter: function(cell){ return esc(cell.getValue()||'—'); }
    },
    { title: '상태', field: 'status', width: 95, hozAlign: 'center',
      formatter: function(cell){ return statusBadge(cell.getValue() || '보전 예정'); }
    },
    { title: '첨부파일', field: 'attachFile', width: 96, hozAlign: 'center', headerSort: false,
      formatter: function(cell){
        var v = cell.getValue();
        if (!v) return '<span class="attach-none">—</span>';
        var url = base + '/calib/attach/' + encodeURIComponent(v);
        return '<img class="attach-thumb" src="' + url + '" alt="첨부"'
             + ' onerror="this.style.display=\'none\';this.nextSibling.style.display=\'inline\'"'
             + ' onclick="openPreview(\'' + url.replace(/'/g,"\\'") + '\');event.stopPropagation()">'
             + '<span class="attach-link" style="display:none" onclick="openPreview(\'' + url.replace(/'/g,"\\'") + '\');event.stopPropagation()">📎 ' + esc(v) + '</span>';
      }
    },
    { title: '연기 사유', field: 'remark', minWidth: 110,
      formatter: function(cell){
        var v = cell.getValue() || '';
        return v ? '<span title="' + esc(v) + '">' + esc(v) + '</span>' : '—';
      }
    },
    { title: '관리', width: 90, hozAlign: 'center', headerSort: false,
      formatter: function(cell){
        var r = cell.getRow().getData();
        var html = '<div class="act-btns">';
        if (canEdit) html += '<button class="btn-xs btn-xs-edit" onclick="openModal(' + r.calibId + ');event.stopPropagation()">수정</button>';
        if (canDel)  html += '<button class="btn-xs btn-xs-del"  onclick="doDelete(' + r.calibId + ');event.stopPropagation()">삭제</button>';
        html += '</div>';
        return html;
      }
    }
  ]
});

/* ── 권한 로드 ── */
fetch(base + '/perm/my')
  .then(function(r){ return r.json(); })
  .then(function(perms){
    var p = perms['calib/status'] || {};
    canView = (p.canView !== 'N');
    canAdd  = (p.canAdd  !== 'N');
    canEdit = (p.canEdit !== 'N');
    canDel  = (p.canDel  !== 'N');

    if (!canView) {
      calibTable.setData([]);
      calibTable.placeholder = '⛔ 이 페이지에 대한 접근 권한이 없습니다.';
      return;
    }
    if (!canAdd) document.getElementById('addBtn').style.display = 'none';
    loadList();
  })
  .catch(function(){ loadList(); });

/* ── 목록 조회 ── */
function loadList() {
  var equipType = document.getElementById('fEquipType').value;
  var status    = document.getElementById('fStatus').value;
  var keyword   = document.getElementById('fKeyword').value.trim();

  var qs = '?equipType=' + encodeURIComponent(equipType)
         + '&status='    + encodeURIComponent(status)
         + '&keyword='   + encodeURIComponent(keyword);

  fetch(base + '/calib/list' + qs)
    .then(function(r){ return r.json(); })
    .then(function(d){
      if (!d.success) { alert(d.error || '조회 실패'); return; }
      allData = d.data || [];
      updateSummary(allData);
      calibTable.setData(allData);
      document.getElementById('totalCnt').textContent = '총 ' + allData.length + '건';
      checkMaintPopup(allData);
    })
    .catch(function(){ alert('데이터 로드 실패'); });
}

/* ── 요약 뱃지 ── */
function updateSummary(list) {
  var cnt = { '보전 예정':0, '보전 완료':0, '보전 연기':0 };
  list.forEach(function(r){ var s = r.status || '보전 예정'; cnt[s] = (cnt[s]||0)+1; });
  var html = '';
  if (cnt['보전 예정'] > 0) html += '<span class="badge badge-warn">보전 예정 ' + cnt['보전 예정'] + '</span>';
  if (cnt['보전 완료'] > 0) html += '<span class="badge badge-ok">보전 완료 '  + cnt['보전 완료'] + '</span>';
  if (cnt['보전 연기'] > 0) html += '<span class="badge badge-purple">보전 연기 ' + cnt['보전 연기'] + '</span>';
  document.getElementById('summaryArea').innerHTML = html;
}

/* ── 모달 열기 ── */
function openModal(calibId) {
  curEditCalibId = calibId || 0;
  document.getElementById('mCalibId').value = calibId || '';
  document.getElementById('modalTitleText').textContent = '설비별 정기 보전';

  document.getElementById('mEquipName').value    = '';
  document.getElementById('mEquipType').value    = '탬퍼링';
  document.getElementById('mZoneLocation').value = '';
  document.getElementById('mMeasLocation').value = '';
  document.getElementById('mLastCalibDt').value  = '';
  document.getElementById('mNextCalibDt').value  = '';
  document.getElementById('mNextCalibSel').value = '1m';
  document.getElementById('mHandler').value      = '';
  document.getElementById('mStatus').value       = '보전 예정';
  document.getElementById('mRemark').value       = '';
  document.getElementById('attachArea').style.display    = 'none';
  document.getElementById('attachAddArea').style.display = 'block';
  document.getElementById('attachFileNew').value = '';

  if (calibId) {
    fetch(base + '/calib/list?calibId=' + calibId)
      .then(function(r){ return r.json(); })
      .then(function(d){
        var r = (d.data||[]).find(function(x){ return x.calibId == calibId; });
        if (r) fillModal(r);
      });
  } else {
    var today = new Date();
    document.getElementById('mLastCalibDt').value = formatDate(today);
    setNextByOffset('1m', today);
  }
  document.getElementById('editModal').classList.add('show');
}

function fillModal(r) {
  document.getElementById('mEquipType').value    = r.equipType    || '탬퍼링';
  document.getElementById('mEquipName').value    = r.equipName    || '';
  document.getElementById('mZoneLocation').value = r.zoneLocation || '';
  document.getElementById('mMeasLocation').value = r.measLocation || '';
  document.getElementById('mLastCalibDt').value  = r.lastCalibDt  || '';
  document.getElementById('mNextCalibDt').value  = r.nextCalibDt  || '';
  document.getElementById('mNextCalibSel').value = 'custom';
  document.getElementById('mHandler').value      = r.handler  || '';
  document.getElementById('mStatus').value       = r.status   || '보전 예정';
  document.getElementById('mRemark').value       = r.remark   || '';
  if (r.attachFile) {
    document.getElementById('attachLink').textContent = r.attachFile;
    document.getElementById('attachLink').href = base + '/calib/attach/' + encodeURIComponent(r.attachFile);
    document.getElementById('attachArea').style.display    = 'block';
    document.getElementById('attachAddArea').style.display = 'none';
  }
}

function closeModal() { document.getElementById('editModal').classList.remove('show'); }

/* ── 저장 ── */
function saveModal() {
  var equipName = document.getElementById('mEquipName').value.trim();
  if (!equipName) { alert('설비명을 입력하세요.'); return; }
  var body = {
    calibId:      document.getElementById('mCalibId').value,
    equipType:    document.getElementById('mEquipType').value,
    equipName:    equipName,
    zoneLocation: document.getElementById('mZoneLocation').value.trim(),
    measLocation: document.getElementById('mMeasLocation').value.trim(),
    lastCalibDt:  document.getElementById('mLastCalibDt').value,
    nextCalibDt:  '',
    handler:      document.getElementById('mHandler').value.trim(),
    status:       document.getElementById('mStatus').value,
    remark:       document.getElementById('mRemark').value.trim()
  };
  fetch(base + '/calib/save', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body)
  }).then(function(r){ return r.json(); })
    .then(function(d){
      if (!d.success) { alert(d.error || '저장 실패'); return; }
      var newFile = document.getElementById('attachFileNew').files[0];
      if (newFile && !body.calibId) {
        uploadNewAttach(newFile, function(){ closeModal(); loadList(); });
      } else {
        closeModal(); loadList();
      }
    })
    .catch(function(){ alert('저장 실패'); });
}

function uploadNewAttach(file, cb) {
  fetch(base + '/calib/list')
    .then(function(r){ return r.json(); })
    .then(function(d){
      var list = d.data || [];
      if (!list.length) { cb(); return; }
      uploadAttachById(list[0].calibId, file, cb);
    })
    .catch(cb);
}

function uploadAttachById(calibId, file, cb) {
  var fd = new FormData();
  fd.append('calibId', calibId);
  fd.append('file', file);
  fetch(base + '/calib/attach/upload', { method:'POST', body:fd })
    .then(function(){ if(cb) cb(); })
    .catch(function(){ if(cb) cb(); });
}

function uploadAttach() {
  var file = document.getElementById('attachFileInput').files[0];
  if (!file || !curEditCalibId) return;
  uploadAttachById(curEditCalibId, file, function(){
    document.getElementById('attachFileInput').value = '';
    loadList();
  });
}

/* ── 삭제 ── */
function doDelete(calibId) {
  if (!confirm('삭제하시겠습니까?')) return;
  fetch(base + '/calib/delete', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ calibId: calibId })
  }).then(function(r){ return r.json(); })
    .then(function(d){ if (d.success) loadList(); else alert(d.error || '삭제 실패'); });
}

/* ══════════════════════════════════════════
   보전 예정일 도래 팝업
══════════════════════════════════════════ */
function checkMaintPopup(list) {
  var hideKey = 'maint_popup_hide_' + todayStr();
  if (localStorage.getItem(hideKey)) return;
  var due = list.filter(function(r){
    return (r.status || '보전 예정') === '보전 예정' && calcDday(r.lastCalibDt) <= 0;
  });
  if (!due.length) return;
  var html = '';
  due.forEach(function(r){
    var dday = calcDday(r.lastCalibDt);
    var ddayLabel = dday < 0
      ? '<span style="color:var(--red);font-weight:700">D+' + Math.abs(dday) + ' 초과</span>'
      : '<span style="color:var(--red);font-weight:700">D-Day</span>';
    html += '<div class="maint-popup-row">'
          + '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:4px">'
          + '<span style="font-weight:700;font-size:13px">' + esc(r.equipName)
          + ' <span style="font-size:11px;font-weight:400;color:var(--muted)">' + esc(r.equipType||'') + '</span></span>'
          + ddayLabel + '</div>'
          + (r.zoneLocation ? '<div style="font-size:12px;color:var(--muted)">항목: ' + esc(r.zoneLocation) + '</div>' : '')
          + (r.measLocation ? '<div style="font-size:12px;color:var(--text)">내용: <strong>' + esc(r.measLocation) + '</strong></div>' : '')
          + '<div style="font-size:11px;color:var(--muted);margin-top:2px">예정일: ' + (r.lastCalibDt||'—') + '</div>'
          + '</div>';
  });
  document.getElementById('maintList').innerHTML = html;
  document.getElementById('maintPopup').classList.add('show');
}

function closeMaintPopup() {
  if (document.getElementById('maintHideToday').checked)
    localStorage.setItem('maint_popup_hide_' + todayStr(), '1');
  document.getElementById('maintPopup').classList.remove('show');
}

/* ══════════════════════════════════════════
   다음 보전 예정일 드롭다운
══════════════════════════════════════════ */
function onLastCalibChange() {
  var sel = document.getElementById('mNextCalibSel').value;
  if (sel !== 'custom') {
    var baseVal = document.getElementById('mLastCalibDt').value;
    if (baseVal) setNextByOffset(sel, new Date(baseVal));
  }
}

function onNextCalibSelChange() {
  var sel = document.getElementById('mNextCalibSel').value;
  if (sel === 'custom') return;
  var lastDt = document.getElementById('mLastCalibDt').value;
  setNextByOffset(sel, lastDt ? new Date(lastDt) : new Date());
}

function setNextByOffset(sel, from) {
  var d = new Date(from);
  if      (sel === '1m') d.setMonth(d.getMonth() + 1);
  else if (sel === '3m') d.setMonth(d.getMonth() + 3);
  else if (sel === '6m') d.setMonth(d.getMonth() + 6);
  else if (sel === '1y') d.setFullYear(d.getFullYear() + 1);
  document.getElementById('mNextCalibDt').value = formatDate(d);
}

/* ══════════════════════════════════════════
   이미지 미리보기
══════════════════════════════════════════ */
function openPreview(url) {
  var img = document.getElementById('previewImg');
  img.src = url;
  document.getElementById('previewOverlay').classList.add('show');
  document.body.style.overflow = 'hidden';
}

function closePreview() {
  document.getElementById('previewOverlay').classList.remove('show');
  document.getElementById('previewImg').src = '';
  document.body.style.overflow = '';
}

document.addEventListener('keydown', function(e){
  if (e.key === 'Escape') closePreview();
});

/* ══════════════════════════════════════════
   유틸리티
══════════════════════════════════════════ */
function calcDday(targetDate) {
  if (!targetDate) return null;
  var today = new Date(); today.setHours(0,0,0,0);
  return Math.round((new Date(targetDate) - today) / (1000*60*60*24));
}

function dDayHtml(targetDate) {
  if (!targetDate) return '<span style="color:#CBD5E0">—</span>';
  var diff = calcDday(targetDate);
  var cls   = diff < 0 ? 'over' : diff === 0 ? 'near' : diff <= 7 ? 'near' : diff <= 30 ? 'warn' : 'ok';
  var label = diff < 0 ? 'D+' + Math.abs(diff) + ' 초과' : diff === 0 ? 'D-Day' : 'D-' + diff;
  return '<span class="dday ' + cls + '">' + label + '</span>';
}

function statusBadge(status) {
  var map = { '보전 예정':'badge-warn', '보전 완료':'badge-ok', '보전 연기':'badge-purple' };
  return '<span class="badge ' + (map[status]||'badge-warn') + '">' + esc(status) + '</span>';
}

function formatDate(d) {
  return d.getFullYear() + '-'
    + String(d.getMonth()+1).padStart(2,'0') + '-'
    + String(d.getDate()).padStart(2,'0');
}

function todayStr() { return formatDate(new Date()); }

function esc(s) {
  return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}
</script>
</body>
</html>
