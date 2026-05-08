<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common_style.jsp" %>
<style>
/* ── 필터 바 ── */
.ctrl-bar { display:flex; gap:10px; flex-wrap:wrap; align-items:flex-end; margin-bottom:16px; }

/* ── 테이블 래퍼 ── */
.table-wrap { overflow-x:auto; }

/* ── D-Day 뱃지 ── */
.dday { font-weight:700; font-size:12px; }
.dday.over   { color:var(--red); }
.dday.near   { color:var(--orange); }
.dday.ok     { color:var(--green); }
.dday.warn   { color:#805AD5; }

/* ── 상태 뱃지 ── */
.badge { display:inline-block; padding:2px 9px; border-radius:20px; font-size:11px; font-weight:700; white-space:nowrap; }
.badge-ok       { background:var(--green-l);  color:var(--green);  border:1px solid #9AE6B4; }
.badge-alarm    { background:#FFF5F5;          color:var(--red);    border:1px solid #FEB2B2; }
.badge-warn     { background:#FFFAF0;          color:var(--orange); border:1px solid #FBD38D; }
.badge-over     { background:#FFF5F5;          color:#C53030;       border:1px solid #FC8181; }
.badge-pass     { background:var(--green-l);  color:var(--green);  border:1px solid #9AE6B4; }
.badge-fail     { background:#FFF5F5;          color:var(--red);    border:1px solid #FEB2B2; }
.badge-purple   { background:#FAF5FF;          color:#6B46C1;       border:1px solid #D6BCFA; }

/* ── 첨부파일 링크 ── */
.attach-link { font-size:11px; color:var(--primary); cursor:pointer; text-decoration:underline; white-space:nowrap; }
.attach-upload-btn { font-size:11px; padding:1px 7px; border:1px dashed var(--border);
  border-radius:4px; background:none; cursor:pointer; color:var(--muted); }
.attach-upload-btn:hover { border-color:var(--primary); color:var(--primary); }

/* ── 모달 ── */
.modal-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,.45);
  z-index:300; align-items:center; justify-content:center; }
.modal-overlay.show { display:flex; }
.modal-box { background:var(--white); border-radius:14px; padding:26px 28px;
  width:640px; max-width:96vw; box-shadow:0 8px 40px rgba(0,0,0,.2); max-height:92vh; overflow-y:auto; }
.modal-box.sm { width:420px; }
.modal-title { font-size:15px; font-weight:700; margin-bottom:18px; display:flex; align-items:center; gap:8px; }
.modal-grid  { display:grid; grid-template-columns:1fr 1fr; gap:12px 16px; }
.modal-grid .full { grid-column:1/-1; }
.modal-actions { display:flex; justify-content:flex-end; gap:8px; margin-top:20px; }

/* ── 팝업 (D-Day 경보) ── */
.dday-popup { background:var(--white); border-radius:14px; padding:24px 26px;
  width:460px; max-width:96vw; box-shadow:0 8px 40px rgba(0,0,0,.25);
  animation: popIn .2s ease; }
@keyframes popIn { from{ transform:scale(.92); opacity:0; } to{ transform:scale(1); opacity:1; } }
.dday-popup-title { font-size:15px; font-weight:700; color:var(--red); margin-bottom:4px; }
.dday-popup-sub   { font-size:12px; color:var(--muted); margin-bottom:14px; }
.dday-popup-list  { border-radius:8px; overflow:hidden; border:1px solid var(--border); margin-bottom:16px; }
.dday-popup-row   { display:flex; gap:10px; align-items:center; padding:9px 12px;
  border-bottom:1px solid var(--border); font-size:13px; }
.dday-popup-row:last-child { border-bottom:none; }
.dday-popup-row:hover { background:var(--primary-l); }

/* ── 탭 ── */
.calib-tabs { display:flex; gap:6px; margin-bottom:16px; }
.calib-tab { padding:7px 20px; border-radius:8px; border:1px solid var(--border);
  background:var(--white); font-size:13px; font-weight:600;
  cursor:pointer; transition:all .13s; color:var(--muted); }
.calib-tab.active { background:var(--primary); color:#fff; border-color:var(--primary); }

/* ── 드롭다운 next_calib ── */
.next-calib-wrap { display:flex; gap:8px; align-items:center; }
.next-calib-wrap .form-select { width:110px; }
.next-calib-wrap .form-input  { flex:1; }

/* ── 빈 상태 ── */
.empty-row td { text-align:center; padding:48px; color:var(--muted); font-size:13px; }

/* ── 액션 컬럼 ── */
.act-btns { display:flex; gap:4px; white-space:nowrap; }
.btn-xs { padding:2px 8px; font-size:11px; border-radius:4px; border:1px solid var(--border);
  background:none; cursor:pointer; }
.btn-xs-edit:hover { border-color:var(--primary); color:var(--primary); }
.btn-xs-del:hover  { border-color:var(--red); color:var(--red); background:var(--red-l); }

/* ── 모바일 ── */
@media(max-width:640px){
  .modal-grid { grid-template-columns:1fr; }
  .modal-grid .full { grid-column:1; }
  .hide-mobile { display:none !important; }
  .page-header { flex-direction:column; gap:10px; }
}
</style>
<body>
<div class="page-wrap">
  <div class="page-header">
    <div>
      <div class="page-title">열전대 보정현황</div>
      <div class="page-sub">보정 이력 관리 · D-Day 추적 · 첨부 파일</div>
    </div>
    <div style="display:flex;gap:8px;flex-wrap:wrap">
      <button class="btn-outline" onclick="loadList()">🔄 새로고침</button>
      <button class="btn-primary" onclick="openModal(null)" id="addBtn" data-perm="add">＋ 보정 추가</button>
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
      <select class="form-select" id="fStatus" style="width:110px">
        <option value="">전체</option>
        <option>정상</option>
        <option>보정예정</option>
        <option>보정필요</option>
        <option>초과</option>
      </select>
    </div>
    <div class="form-field">
      <label class="form-label">검색</label>
      <input class="form-input" type="text" id="fKeyword" placeholder="설비명 · 위치 · 담당자" style="width:180px"
             onkeydown="if(event.key==='Enter') loadList()">
    </div>
    <button class="btn-primary btn-sm" style="margin-top:18px;height:34px" onclick="loadList()">조회</button>
    <div style="margin-left:auto;display:flex;gap:6px;margin-top:18px" id="summaryArea"></div>
  </div>

  <!-- 데이터 테이블 -->
  <div class="card">
    <div class="card-title">열전대 보정현황
      <span id="totalCnt" style="font-size:11px;font-weight:400;color:var(--muted);margin-left:4px"></span>
    </div>
    <div class="table-wrap">
      <table class="data-table" id="calibTable">
        <thead>
          <tr>
            <th style="width:40px">No</th>
            <th>설비구분</th>
            <th>설비명</th>
            <th class="hide-mobile">첨부파일</th>
            <th class="hide-mobile">존/위치</th>
            <th class="hide-mobile">측정 위치</th>
            <th>최근 보정일</th>
            <th>다음 보정 예정일</th>
            <th style="width:80px">D-Day</th>
            <th class="hide-mobile">기준온도(°C)</th>
            <th class="hide-mobile">측정온도(°C)</th>
            <th class="hide-mobile">편차(°C)</th>
            <th>판정</th>
            <th>상태</th>
            <th class="hide-mobile">담당자</th>
            <th class="hide-mobile">비고</th>
            <th id="actColHead" style="width:80px">관리</th>
          </tr>
        </thead>
        <tbody id="calibBody">
          <tr class="empty-row"><td colspan="17">조회 버튼을 눌러 데이터를 불러오세요</td></tr>
        </tbody>
      </table>
    </div>
  </div>
</div>

<!-- ===== 추가/수정 모달 ===== -->
<div class="modal-overlay" id="editModal">
  <div class="modal-box">
    <div class="modal-title">🌡️ <span id="modalTitleText">보정 추가</span></div>
    <input type="hidden" id="mCalibId">
    <div class="modal-grid">
      <div class="form-field">
        <label class="form-label">설비구분 *</label>
        <select class="form-select" id="mEquipType" style="width:100%">
          <option>탬퍼링</option>
          <option>퀜칭</option>
          <option>세정</option>
          <option>기타</option>
        </select>
      </div>
      <div class="form-field">
        <label class="form-label">설비명 *</label>
        <input class="form-input" type="text" id="mEquipName" placeholder="예) 열처리로 1호기" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">존/위치</label>
        <input class="form-input" type="text" id="mZoneLocation" placeholder="예) 예열존, 가열존" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">측정 위치</label>
        <input class="form-input" type="text" id="mMeasLocation" placeholder="예) 상부/중부/하부" style="width:100%">
      </div>
      <div class="form-field">
        <label class="form-label">최근 보정일</label>
        <input class="form-input" type="date" id="mLastCalibDt" style="width:100%" onchange="onLastCalibChange()">
      </div>
      <div class="form-field">
        <label class="form-label">다음 보정 예정일</label>
        <div class="next-calib-wrap">
          <select class="form-select" id="mNextCalibSel" onchange="onNextCalibSelChange()">
            <option value="1m">1개월</option>
            <option value="3m">3개월</option>
            <option value="1y">1년</option>
            <option value="custom">직접 선택</option>
          </select>
          <input class="form-input" type="date" id="mNextCalibDt" style="width:100%">
        </div>
      </div>
      <div class="form-field">
        <label class="form-label">기준온도 (°C)</label>
        <input class="form-input" type="number" step="0.1" id="mStdTemp" placeholder="예) 850.0"
               style="width:100%" oninput="calcDeviation()">
      </div>
      <div class="form-field">
        <label class="form-label">측정온도 (°C)</label>
        <input class="form-input" type="number" step="0.1" id="mMeasTemp" placeholder="예) 851.2"
               style="width:100%" oninput="calcDeviation()">
      </div>
      <div class="form-field">
        <label class="form-label">편차 (°C) <span style="font-size:10px;color:var(--muted)">(자동계산)</span></label>
        <input class="form-input" type="number" step="0.01" id="mDeviation" readonly
               style="width:100%;background:var(--bg)">
      </div>
      <div class="form-field">
        <label class="form-label">판정</label>
        <select class="form-select" id="mJudgment" style="width:100%">
          <option>합격</option>
          <option>불합격</option>
        </select>
      </div>
      <div class="form-field">
        <label class="form-label">담당자</label>
        <input class="form-input" type="text" id="mHandler" placeholder="성명 입력" style="width:100%">
      </div>
      <div class="form-field full">
        <label class="form-label">비고</label>
        <input class="form-input" type="text" id="mRemark" placeholder="특이사항" style="width:100%">
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

<!-- ===== D-Day 경보 팝업 ===== -->
<div class="modal-overlay" id="ddayPopup">
  <div class="dday-popup">
    <div class="dday-popup-title">⚠️ 보정 기한 임박 알림</div>
    <div class="dday-popup-sub">다음 보정 예정일이 7일 이내인 항목이 있습니다.</div>
    <div class="dday-popup-list" id="ddayList"></div>
    <div style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:8px">
      <label style="font-size:12px;color:var(--muted);cursor:pointer;display:flex;align-items:center;gap:5px">
        <input type="checkbox" id="ddayHideToday" style="cursor:pointer">
        오늘 하루 보지 않기
      </label>
      <div style="display:flex;gap:8px">
        <button class="btn-outline btn-sm" onclick="closeDdayPopup()">닫기</button>
        <button class="btn-primary btn-sm" onclick="closeDdayPopup();loadList()">목록 보기</button>
      </div>
    </div>
  </div>
</div>

<script>
var base    = '${pageContext.request.contextPath}';
var canAdd  = true;
var canEdit = true;
var canDel  = true;
var canView = true;
var curEditCalibId = 0;   // 현재 편집 중인 ID (첨부 업로드용)

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
      document.getElementById('calibBody').innerHTML =
        '<tr class="empty-row"><td colspan="17" style="color:var(--red)">⛔ 이 페이지에 대한 접근 권한이 없습니다.</td></tr>';
      return;
    }
    if (!canAdd)  document.getElementById('addBtn').style.display = 'none';
    if (!canAdd && !canEdit && !canDel) {
      document.getElementById('actColHead').style.display = 'none';
    }
    loadList();
    checkDdayPopup();
  })
  .catch(function(){
    loadList();
    checkDdayPopup();
  });

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
      renderTable(d.data || []);
    })
    .catch(function(){ alert('데이터 로드 실패'); });
}

/* ── 테이블 렌더링 ── */
function renderTable(list) {
  var total = list.length;
  document.getElementById('totalCnt').textContent = '총 ' + total + '건';

  /* 요약 뱃지 */
  var cnt = { '정상':0, '보정예정':0, '보정필요':0, '초과':0 };
  list.forEach(function(r){
    var s = computeStatus(r.nextCalibDt);
    cnt[s] = (cnt[s] || 0) + 1;
  });
  var sumHtml = '';
  if (cnt['초과']    > 0) sumHtml += '<span class="badge badge-over">초과 ' + cnt['초과'] + '</span>';
  if (cnt['보정필요'] > 0) sumHtml += '<span class="badge badge-alarm">보정필요 ' + cnt['보정필요'] + '</span>';
  if (cnt['보정예정'] > 0) sumHtml += '<span class="badge badge-warn">보정예정 ' + cnt['보정예정'] + '</span>';
  if (cnt['정상']    > 0) sumHtml += '<span class="badge badge-ok">정상 ' + cnt['정상'] + '</span>';
  document.getElementById('summaryArea').innerHTML = sumHtml;

  if (!total) {
    document.getElementById('calibBody').innerHTML =
      '<tr class="empty-row"><td colspan="17">조회된 데이터가 없습니다. 우상단 <strong>＋ 보정 추가</strong>로 등록하세요.</td></tr>';
    return;
  }

  var html = '';
  list.forEach(function(r, i) {
    var dday      = calcDday(r.nextCalibDt);
    var ddayHtml  = dDayHtml(r.nextCalibDt);
    var status    = computeStatus(r.nextCalibDt);
    var statusHtml = statusBadge(status);
    var judgHtml  = r.judgment === '불합격'
                  ? '<span class="badge badge-fail">불합격</span>'
                  : '<span class="badge badge-pass">합격</span>';

    var attachHtml = '';
    if (r.attachFile) {
      attachHtml = '<a class="attach-link" href="' + base + '/calib/attach/' + esc(r.attachFile)
                 + '" target="_blank" title="' + esc(r.attachFile) + '">📎 파일</a>';
    } else {
      attachHtml = '<span style="color:var(--light);font-size:11px">—</span>';
    }

    var devStr = r.deviation != null
      ? (r.deviation >= 0 ? '+' : '') + r.deviation
      : '—';

    var actHtml = '<div class="act-btns">';
    if (canEdit) actHtml += '<button class="btn-xs btn-xs-edit" onclick="openModal(' + r.calibId + ')">수정</button>';
    if (canDel)  actHtml += '<button class="btn-xs btn-xs-del"  onclick="doDelete(' + r.calibId + ')">삭제</button>';
    actHtml += '</div>';

    html += '<tr>'
      + '<td style="text-align:center">' + (i + 1) + '</td>'
      + '<td>' + esc(r.equipType || '') + '</td>'
      + '<td style="font-weight:600">' + esc(r.equipName || '') + '</td>'
      + '<td class="hide-mobile">' + attachHtml + '</td>'
      + '<td class="hide-mobile">' + esc(r.zoneLocation || '—') + '</td>'
      + '<td class="hide-mobile">' + esc(r.measLocation || '—') + '</td>'
      + '<td>' + (r.lastCalibDt || '—') + '</td>'
      + '<td>' + (r.nextCalibDt || '—') + '</td>'
      + '<td style="text-align:center">' + ddayHtml + '</td>'
      + '<td class="hide-mobile" style="text-align:right">' + (r.stdTemp  != null ? r.stdTemp  : '—') + '</td>'
      + '<td class="hide-mobile" style="text-align:right">' + (r.measTemp != null ? r.measTemp : '—') + '</td>'
      + '<td class="hide-mobile" style="text-align:right">' + devStr + '</td>'
      + '<td style="text-align:center">' + judgHtml + '</td>'
      + '<td style="text-align:center">' + statusHtml + '</td>'
      + '<td class="hide-mobile">' + esc(r.handler || '—') + '</td>'
      + '<td class="hide-mobile" style="max-width:120px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap"'
      +   (r.remark ? ' title="' + esc(r.remark) + '"' : '') + '>' + esc(r.remark || '—') + '</td>'
      + '<td>' + actHtml + '</td>'
      + '</tr>';
  });
  document.getElementById('calibBody').innerHTML = html;
}

/* ── 모달 열기 ── */
function openModal(calibId) {
  curEditCalibId = calibId || 0;
  document.getElementById('mCalibId').value = calibId || '';
  document.getElementById('modalTitleText').textContent = calibId ? '보정 수정' : '보정 추가';

  /* 초기화 */
  document.getElementById('mEquipName').value   = '';
  document.getElementById('mEquipType').value   = '탬퍼링';
  document.getElementById('mZoneLocation').value = '';
  document.getElementById('mMeasLocation').value = '';
  document.getElementById('mLastCalibDt').value  = '';
  document.getElementById('mNextCalibDt').value  = '';
  document.getElementById('mNextCalibSel').value = '1m';
  document.getElementById('mStdTemp').value  = '';
  document.getElementById('mMeasTemp').value = '';
  document.getElementById('mDeviation').value = '';
  document.getElementById('mJudgment').value = '합격';
  document.getElementById('mHandler').value  = '';
  document.getElementById('mRemark').value   = '';
  document.getElementById('attachArea').style.display    = 'none';
  document.getElementById('attachAddArea').style.display = 'block';
  document.getElementById('attachFileNew').value = '';

  if (calibId) {
    /* 기존 데이터 조회 후 채우기 */
    fetch(base + '/calib/list?calibId=' + calibId)
      .then(function(r){ return r.json(); })
      .then(function(d){
        var list = d.data || [];
        /* calibId로 단건 찾기 */
        var r = list.find(function(x){ return x.calibId == calibId; });
        if (!r) return;
        fillModal(r);
      });
  } else {
    /* 추가: 오늘 날짜 기본값, 1개월 뒤 자동 세팅 */
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
  document.getElementById('mStdTemp').value   = r.stdTemp  != null ? r.stdTemp  : '';
  document.getElementById('mMeasTemp').value  = r.measTemp != null ? r.measTemp : '';
  document.getElementById('mDeviation').value = r.deviation != null ? r.deviation : '';
  document.getElementById('mJudgment').value  = r.judgment || '합격';
  document.getElementById('mHandler').value   = r.handler  || '';
  document.getElementById('mRemark').value    = r.remark   || '';

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
    nextCalibDt:  document.getElementById('mNextCalibDt').value,
    stdTemp:      document.getElementById('mStdTemp').value,
    measTemp:     document.getElementById('mMeasTemp').value,
    judgment:     document.getElementById('mJudgment').value,
    handler:      document.getElementById('mHandler').value.trim(),
    remark:       document.getElementById('mRemark').value.trim()
  };

  fetch(base + '/calib/save', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body)
  }).then(function(r){ return r.json(); })
    .then(function(d){
      if (!d.success) { alert(d.error || '저장 실패'); return; }

      /* 첨부 파일 업로드 (신규 첨부) */
      var newFile = document.getElementById('attachFileNew').files[0];
      if (newFile && !body.calibId) {
        /* insert 후 마지막 ID를 모르므로 목록 재조회 후 첫 행에 업로드 */
        uploadNewAttach(newFile, function(){
          closeModal();
          loadList();
        });
      } else {
        closeModal();
        loadList();
      }
    })
    .catch(function(){ alert('저장 실패'); });
}

/* 신규 추가 시 첨부 업로드 (저장 직후 목록 재조회해 calibId 획득) */
function uploadNewAttach(file, cb) {
  /* 목록에서 방금 추가된 가장 최신 항목 ID를 찾음 */
  fetch(base + '/calib/list')
    .then(function(r){ return r.json(); })
    .then(function(d){
      var list = d.data || [];
      if (!list.length) { cb(); return; }
      var latestId = list[0].calibId; /* ORDER BY calib_id DESC 이므로 첫 항목 */
      uploadAttachById(latestId, file, cb);
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

/* 수정 모달의 파일 교체 */
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
    .then(function(d){
      if (d.success) loadList();
      else alert(d.error || '삭제 실패');
    });
}

/* ══════════════════════════════════════════
   D-Day 경보 팝업
══════════════════════════════════════════ */
function checkDdayPopup() {
  var hideKey = 'calib_dday_hide_' + todayStr();
  if (localStorage.getItem(hideKey)) return;

  fetch(base + '/calib/dday/alert')
    .then(function(r){ return r.json(); })
    .then(function(d){
      var list = (d.data || []);
      if (!list.length) return;

      var html = '';
      list.forEach(function(r){
        var dday = calcDday(r.nextCalibDt);
        var label = dday < 0  ? 'D+' + Math.abs(dday) + ' <span style="color:var(--red);font-weight:700">초과</span>'
                  : dday === 0 ? '<span style="color:var(--red);font-weight:700">D-Day</span>'
                  : 'D-<strong>' + dday + '</strong>';
        html += '<div class="dday-popup-row">'
              + '<span style="font-weight:600;min-width:100px">' + esc(r.equipName) + '</span>'
              + '<span style="color:var(--muted);font-size:12px;flex:1">' + esc(r.zoneLocation || '') + '</span>'
              + '<span style="font-size:12px">' + (r.nextCalibDt || '') + '</span>'
              + '<span style="margin-left:10px;font-size:12px">' + label + '</span>'
              + '</div>';
      });
      document.getElementById('ddayList').innerHTML = html;
      document.getElementById('ddayPopup').classList.add('show');
    })
    .catch(function(){});
}

function closeDdayPopup() {
  if (document.getElementById('ddayHideToday').checked) {
    localStorage.setItem('calib_dday_hide_' + todayStr(), '1');
  }
  document.getElementById('ddayPopup').classList.remove('show');
}

/* ══════════════════════════════════════════
   다음 보정 예정일 드롭다운
══════════════════════════════════════════ */
function onLastCalibChange() {
  var sel = document.getElementById('mNextCalibSel').value;
  if (sel !== 'custom') {
    var base = document.getElementById('mLastCalibDt').value;
    if (base) setNextByOffset(sel, new Date(base));
  }
}

function onNextCalibSelChange() {
  var sel = document.getElementById('mNextCalibSel').value;
  if (sel === 'custom') return;
  var lastDt = document.getElementById('mLastCalibDt').value;
  var from   = lastDt ? new Date(lastDt) : new Date();
  setNextByOffset(sel, from);
}

function setNextByOffset(sel, from) {
  var d = new Date(from);
  if      (sel === '1m') d.setMonth(d.getMonth() + 1);
  else if (sel === '3m') d.setMonth(d.getMonth() + 3);
  else if (sel === '1y') d.setFullYear(d.getFullYear() + 1);
  document.getElementById('mNextCalibDt').value = formatDate(d);
}

/* ══════════════════════════════════════════
   편차 자동 계산
══════════════════════════════════════════ */
function calcDeviation() {
  var std  = parseFloat(document.getElementById('mStdTemp').value);
  var meas = parseFloat(document.getElementById('mMeasTemp').value);
  if (!isNaN(std) && !isNaN(meas)) {
    var dev = Math.round((meas - std) * 100) / 100;
    document.getElementById('mDeviation').value = dev;
    /* 편차 ±2°C 초과 시 판정 자동 불합격 권유 */
    document.getElementById('mJudgment').value = Math.abs(dev) > 2 ? '불합격' : '합격';
  } else {
    document.getElementById('mDeviation').value = '';
  }
}

/* ══════════════════════════════════════════
   유틸리티
══════════════════════════════════════════ */
function calcDday(nextDate) {
  if (!nextDate) return null;
  var today = new Date(); today.setHours(0,0,0,0);
  var nd = new Date(nextDate);
  return Math.round((nd - today) / (1000*60*60*24));
}

function dDayHtml(nextDate) {
  if (!nextDate) return '<span style="color:var(--light)">—</span>';
  var diff = calcDday(nextDate);
  var cls   = diff < 0 ? 'over' : diff <= 7 ? 'near' : diff <= 30 ? 'warn' : 'ok';
  var label = diff < 0 ? 'D+' + Math.abs(diff) + ' 초과'
            : diff === 0 ? 'D-Day'
            : 'D-' + diff;
  return '<span class="dday ' + cls + '">' + label + '</span>';
}

function computeStatus(nextCalibDt) {
  var diff = calcDday(nextCalibDt);
  if (diff === null) return '정상';
  if (diff < 0)     return '초과';
  if (diff <= 7)    return '보정필요';
  if (diff <= 30)   return '보정예정';
  return '정상';
}

function statusBadge(status) {
  var map = {
    '정상':   'badge-ok',
    '보정예정': 'badge-warn',
    '보정필요': 'badge-alarm',
    '초과':    'badge-over'
  };
  return '<span class="badge ' + (map[status] || 'badge-ok') + '">' + status + '</span>';
}

function formatDate(d) {
  var y = d.getFullYear();
  var m = String(d.getMonth() + 1).padStart(2, '0');
  var day = String(d.getDate()).padStart(2, '0');
  return y + '-' + m + '-' + day;
}

function todayStr() {
  return formatDate(new Date());
}

function esc(s) {
  return String(s || '').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}
</script>
</body>
</html>
