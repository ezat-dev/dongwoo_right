<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common_style.jsp" %>
<style>
.fl-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px; }
.fl-title-wrap { display: flex; flex-direction: column; gap: 2px; }
.fl-title { font-size: 18px; font-weight: 900; color: var(--text); }
.fl-sub   { font-size: 12px; color: var(--muted); font-weight: 600; }

.fl-filter { display: flex; align-items: center; gap: 8px; }
.fl-date-input {
  padding: 7px 10px; border-radius: 9px;
  border: 1px solid var(--border); background: var(--white);
  font-size: 13px; font-weight: 700; color: var(--text);
  font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
}
.fl-date-input:focus { outline: none; border-color: var(--primary); }
.fl-sep { color: var(--muted); font-weight: 700; }
.fl-btn {
  padding: 7px 18px; border-radius: 9px;
  background: var(--primary); color: #fff;
  border: none; font-size: 13px; font-weight: 700;
  cursor: pointer; font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
}
.fl-btn:hover { filter: brightness(.9); }
.fl-btn-excel { background: #38A169; }
.fl-btn-excel:hover { filter: brightness(.9); }
.fl-btn-excel:disabled { background: #A0AEC0; cursor: not-allowed; filter: none; }

/* panels */
.fl-panels { display: flex; gap: 14px; height: calc(100vh - 120px); }
.fl-panel {
  flex: 1; display: flex; flex-direction: column;
  background: var(--white); border: 1px solid var(--border);
  border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,.05);
  overflow: hidden; min-width: 0;
}
.fl-panel-hd {
  padding: 12px 16px; border-bottom: 1px solid var(--border);
  display: flex; align-items: center; justify-content: space-between;
  flex-shrink: 0;
}
.fl-panel-title { font-size: 13px; font-weight: 800; color: var(--text); }
.fl-badge { font-size: 11px; font-weight: 700; border-radius: 20px; padding: 2px 10px; }
.badge-session { background: var(--bg); color: var(--muted); }
.badge-alarm   { background: #FFF5F5; color: #C53030; }

/* session list */
.fl-list { flex: 1; overflow-y: auto; padding: 8px; display: flex; flex-direction: column; gap: 5px; }
.fl-list::-webkit-scrollbar { width: 4px; }
.fl-list::-webkit-scrollbar-thumb { background: #CBD5E0; border-radius: 2px; }

.fl-session {
  border-radius: 9px; padding: 10px 14px;
  border: 1.5px solid var(--border);
  cursor: pointer; user-select: none;
  background: #FAFBFC;
  transition: border-color .12s, background .12s;
}
.fl-session:hover  { border-color: var(--primary); background: #EBF8FF !important; }
.fl-session.active { border-color: var(--primary); background: #EBF8FF !important; }

/* 날짜별 색 구분 (회색/흰색 교번) */
.fl-date-c0 { background: #F4F4F4; border-color: #DCDCDC; }
.fl-date-c1 { background: #FFFFFF; border-color: var(--border); }

.fl-session-row1 { display: flex; align-items: center; gap: 8px; margin-bottom: 6px; }
.fl-equip-badge  {
  font-size: 12px; font-weight: 900; color: #fff;
  background: var(--primary); border-radius: 6px; padding: 2px 10px; flex-shrink: 0;
}
.fl-alarm-cnt {
  margin-left: auto; font-size: 11px; font-weight: 800;
  color: #C53030; background: #FFF5F5; border-radius: 10px; padding: 1px 8px;
}
.fl-alarm-cnt.zero { color: var(--muted); background: var(--bg); }

.fl-session-row2 { display: flex; align-items: center; gap: 6px; flex-wrap: wrap; }
.fl-time-label { font-size: 10px; font-weight: 700; color: var(--muted); }
.fl-time-val   { font-size: 11px; font-weight: 800; color: var(--text); }
.fl-time-arrow { font-size: 12px; color: #CBD5E0; margin: 0 2px; }
.fl-time-null  { font-size: 11px; font-weight: 700; color: #E53E3E; }

/* detail table */
.fl-detail-wrap { flex: 1; overflow: auto; }
.fl-table { width: 100%; border-collapse: collapse; font-size: 12px; }
.fl-table th {
  position: sticky; top: 0; z-index: 1;
  background: var(--bg); padding: 9px 12px;
  text-align: left; font-size: 11px; font-weight: 800; color: var(--muted);
  border-bottom: 1px solid var(--border);
}
.fl-table td { padding: 9px 12px; border-bottom: 1px solid #F0F0F0; vertical-align: middle; }
.fl-table tr:last-child td { border-bottom: none; }
.fl-table tbody tr:hover td { background: #F7FAFC; }
.fl-tag-name  { font-size: 11px; font-weight: 800; color: var(--primary); }
.fl-alarm-msg { font-size: 12px; font-weight: 800; color: var(--text); }
.fl-time-cell { font-size: 11px; color: var(--muted); white-space: nowrap; }
.fl-no-clear  { font-size: 11px; font-weight: 700; color: #E53E3E; }

/* empty */
.fl-empty {
  flex: 1; display: flex; flex-direction: column;
  align-items: center; justify-content: center; gap: 8px;
  color: var(--muted); padding: 40px 0;
}
.fl-empty-icon { font-size: 32px; opacity: .2; }
.fl-empty-txt  { font-size: 12px; font-weight: 600; }

/* mid divider */
.fl-mid {
  display: flex; flex-direction: column; align-items: center;
  justify-content: center; gap: 6px; flex-shrink: 0; width: 32px; color: #CBD5E0;
}
.fl-mid-arrow { font-size: 20px; line-height: 1; }
</style>

<body>
<div class="page-wrap">

  <div class="fl-header">
    <div class="fl-title-wrap">
      <div class="fl-title">F/PROOF LIST</div>
      <div class="fl-sub">Fool Proof 세션별 F/PROOF 알람 이력</div>
    </div>
    <div class="fl-filter">
      <input type="date" class="fl-date-input" id="fromDate">
      <span class="fl-sep">~</span>
      <input type="date" class="fl-date-input" id="toDate">
      <button class="fl-btn" onclick="loadSessions()">조회</button>
      <button class="fl-btn fl-btn-excel" id="excelBtn" onclick="exportExcel()">엑셀 출력</button>
    </div>
  </div>

  <div class="fl-panels">

    <!-- 좌측: 세션 목록 -->
    <div class="fl-panel">
      <div class="fl-panel-hd">
        <span class="fl-panel-title">Fool Proof 세션</span>
        <span class="fl-badge badge-session" id="sessionBadge">0건</span>
      </div>
      <div class="fl-list" id="sessionList">
        <div class="fl-empty">
          <div class="fl-empty-icon">📅</div>
          <div class="fl-empty-txt">날짜를 선택하고 조회하세요</div>
        </div>
      </div>
    </div>

    <!-- 중앙 화살표 -->
    <div class="fl-mid">
      <div class="fl-mid-arrow">›</div>
      <div class="fl-mid-arrow">›</div>
    </div>

    <!-- 우측: 알람 상세 -->
    <div class="fl-panel">
      <div class="fl-panel-hd">
        <span class="fl-panel-title" id="detailTitle">알람 상세</span>
        <span class="fl-badge badge-alarm" id="alarmBadge">0건</span>
      </div>
      <div class="fl-detail-wrap" id="detailWrap">
        <div class="fl-empty">
          <div class="fl-empty-icon">🛡️</div>
          <div class="fl-empty-txt">세션을 선택하세요</div>
        </div>
      </div>
    </div>

  </div>
</div>

<script src="https://unpkg.com/xlsx/dist/xlsx.full.min.js"></script>
<script>
var ROOT = '<%=request.getContextPath()%>';

/* ─── 오늘 날짜 기본값 ─── */
(function() {
  var d  = new Date();
  var yy = d.getFullYear();
  var mm = String(d.getMonth() + 1).padStart(2, '0');
  var dd = String(d.getDate()).padStart(2, '0');
  var s  = yy + '-' + mm + '-' + dd;
  document.getElementById('fromDate').value = s;
  document.getElementById('toDate').value   = s;
  loadSessions();
})();

/* ─── 세션 조회 ─── */
function loadSessions() {
  var from = document.getElementById('fromDate').value;
  var to   = document.getElementById('toDate').value;
  if (!from || !to) return;

  document.getElementById('sessionList').innerHTML =
    '<div class="fl-empty"><div class="fl-empty-txt">불러오는 중…</div></div>';
  resetDetail();

  fetch(ROOT + '/fprooflist/sessions?from=' + encodeURIComponent(from)
                                  + '&to='   + encodeURIComponent(to))
    .then(function(r) { return r.json(); })
    .then(function(list) {
      var el = document.getElementById('sessionList');
      document.getElementById('sessionBadge').textContent = (Array.isArray(list) ? list.length : 0) + '건';
      if (!Array.isArray(list) || !list.length) {
        el.innerHTML = '<div class="fl-empty"><div class="fl-empty-icon">📅</div>' +
                       '<div class="fl-empty-txt">조회된 세션이 없습니다</div></div>';
        return;
      }
      el.innerHTML = '';
      var colorIdx = 0;
      var lastDate = '';
      list.forEach(function(s) {
        var dateOnly = String(s.startTime).substring(0, 10);
        if (dateOnly !== lastDate) {
          if (lastDate !== '') colorIdx = (colorIdx + 1) % 2;
          lastDate = dateOnly;
        }
        el.appendChild(buildSession(s, colorIdx));
      });
    })
    .catch(function() {
      document.getElementById('sessionList').innerHTML =
        '<div class="fl-empty"><div class="fl-empty-txt">로드 실패</div></div>';
    });
}

/* ─── 세션 아이템 ─── */
function buildSession(s, colorIdx) {
  var div = document.createElement('div');
  div.className = 'fl-session fl-date-c' + (colorIdx || 0);
  var num    = parseInt(String(s.plcId).replace('dongwoo_', ''), 10);
  var cnt    = s.alarmCount || 0;
  var cntCls = cnt > 0 ? 'fl-alarm-cnt' : 'fl-alarm-cnt zero';
  var endHtml = s.endTime
    ? '<span class="fl-time-val">' + fmtDt(s.endTime) + '</span>'
    : '<span class="fl-time-null">미종료</span>';

  div.innerHTML =
    '<div class="fl-session-row1">' +
      '<span class="fl-equip-badge">' + num + '호기</span>' +
      '<span class="' + cntCls + '">알람 ' + cnt + '건</span>' +
    '</div>' +
    '<div class="fl-session-row2">' +
      '<span class="fl-time-label">시작</span>' +
      '<span class="fl-time-val">' + fmtDt(s.startTime) + '</span>' +
      '<span class="fl-time-arrow">→</span>' +
      '<span class="fl-time-label">종료</span>' +
      endHtml +
    '</div>';

  div.addEventListener('click', function() {
    document.querySelectorAll('.fl-session').forEach(function(e) { e.classList.remove('active'); });
    div.classList.add('active');
    loadDetail(s);
  });
  return div;
}

/* ─── 알람 상세 ─── */
function loadDetail(s) {
  var num = parseInt(String(s.plcId).replace('dongwoo_', ''), 10);
  document.getElementById('detailTitle').textContent = num + '호기 F/PROOF 알람';
  document.getElementById('detailWrap').innerHTML =
    '<div class="fl-empty"><div class="fl-empty-txt">불러오는 중…</div></div>';

  var url = ROOT + '/fprooflist/detail'
          + '?plcId=' + encodeURIComponent(s.plcId)
          + '&start=' + encodeURIComponent(s.startTime);
  if (s.endTime) url += '&end=' + encodeURIComponent(s.endTime);

  fetch(url)
    .then(function(r) { return r.json(); })
    .then(function(list) {
      var cnt = Array.isArray(list) ? list.length : 0;
      document.getElementById('alarmBadge').textContent = cnt + '건';
      var activeEl = document.querySelector('.fl-session.active .fl-alarm-cnt');
      if (activeEl) {
        activeEl.textContent = '알람 ' + cnt + '건';
        activeEl.className = cnt > 0 ? 'fl-alarm-cnt' : 'fl-alarm-cnt zero';
      }
      var wrap = document.getElementById('detailWrap');
      if (!Array.isArray(list) || !list.length) {
        wrap.innerHTML = '<div class="fl-empty"><div class="fl-empty-icon">✅</div>' +
                         '<div class="fl-empty-txt">해당 구간 F/PROOF 알람 없음</div></div>';
        return;
      }
      var rows = list.map(function(a) {
        var clearCell = a.clearTime
          ? '<span class="fl-time-cell">' + fmtDt(a.clearTime) + '</span>'
          : '<span class="fl-no-clear">미해제</span>';
        return '<tr>' +
          '<td><span class="fl-tag-name">'  + esc(a.tagName)  + '</span></td>' +
          '<td><span class="fl-alarm-msg">' + esc(a.alarmMsg) + '</span></td>' +
          '<td><span class="fl-time-cell">' + fmtDt(a.occurTime) + '</span></td>' +
          '<td>' + clearCell + '</td>' +
          '</tr>';
      }).join('');

      wrap.innerHTML =
        '<table class="fl-table">' +
          '<thead><tr>' +
            '<th>태그명</th><th>알람 메시지</th><th>발생시각</th><th>해제시각</th>' +
          '</tr></thead>' +
          '<tbody>' + rows + '</tbody>' +
        '</table>';
    })
    .catch(function() {
      document.getElementById('detailWrap').innerHTML =
        '<div class="fl-empty"><div class="fl-empty-txt">로드 실패</div></div>';
    });
}

/* ─── 엑셀 출력 ─── */
async function exportExcel() {
  var from = document.getElementById('fromDate').value;
  var to   = document.getElementById('toDate').value;
  if (!from || !to) { alert('날짜를 선택하세요'); return; }

  var btn = document.getElementById('excelBtn');
  btn.disabled = true;

  try {
    /* 1. 전체 세션 조회 */
    btn.textContent = '조회 중...';
    var sessions = await fetch(
        ROOT + '/fprooflist/sessions?from=' + encodeURIComponent(from)
                                  + '&to='   + encodeURIComponent(to))
      .then(function(r) { return r.json(); });

    if (!Array.isArray(sessions)) throw new Error('세션 조회 실패');

    /* 2. 설비별 그룹핑 (1~12호기) */
    var byPlc = {};
    for (var i = 1; i <= 12; i++) {
      byPlc['dongwoo_' + String(i).padStart(2, '0')] = [];
    }
    sessions.forEach(function(s) {
      if (byPlc[s.plcId]) byPlc[s.plcId].push(s);
    });

    /* 3. 워크북 생성 */
    var wb = XLSX.utils.book_new();
    var plcKeys = Object.keys(byPlc).sort();

    for (var k = 0; k < plcKeys.length; k++) {
      var plcId       = plcKeys[k];
      var num         = parseInt(plcId.replace('dongwoo_', ''), 10);
      var sheetName   = num + '호기';
      var plcSessions = byPlc[plcId];

      btn.textContent = '생성 중 (' + num + '/12)';

      /* 제목 / 조회기간 / 빈줄 / 컬럼헤더 */
      var rows = [
        ['F/PROOF LIST - ' + sheetName, '', '', '', '', '', ''],
        ['조회기간: ' + from + ' ~ ' + to,  '', '', '', '', '', ''],
        [],
        ['호기', '세션 시작', '세션 종료', '태그명', '알람 메시지', '발생 시각', '해제 시각']
      ];

      if (plcSessions.length === 0) {
        rows.push([sheetName, '-', '-', '(세션 없음)', '', '', '']);
      } else {
        for (var j = 0; j < plcSessions.length; j++) {
          var s   = plcSessions[j];
          var url = ROOT + '/fprooflist/detail'
                  + '?plcId=' + encodeURIComponent(s.plcId)
                  + '&start=' + encodeURIComponent(s.startTime);
          if (s.endTime) url += '&end=' + encodeURIComponent(s.endTime);

          var detail = await fetch(url).then(function(r) { return r.json(); });

          if (!Array.isArray(detail) || detail.length === 0) {
            rows.push([sheetName, s.startTime, s.endTime || '미종료', '(알람 없음)', '', '', '']);
          } else {
            detail.forEach(function(a) {
              rows.push([
                sheetName,
                s.startTime,
                s.endTime || '미종료',
                a.tagName  || '',
                a.alarmMsg || '',
                a.occurTime || '',
                a.clearTime || '미해제'
              ]);
            });
          }
        }
      }

      var ws = XLSX.utils.aoa_to_sheet(rows);
      ws['!merges'] = [
        {s:{r:0,c:0}, e:{r:0,c:6}},
        {s:{r:1,c:0}, e:{r:1,c:6}}
      ];
      ws['!cols'] = [
        {wch: 8},   /* 호기 */
        {wch: 21},  /* 세션 시작 */
        {wch: 21},  /* 세션 종료 */
        {wch: 16},  /* 태그명 */
        {wch: 32},  /* 알람 메시지 */
        {wch: 21},  /* 발생 시각 */
        {wch: 21}   /* 해제 시각 */
      ];
      XLSX.utils.book_append_sheet(wb, ws, sheetName);
    }

    /* 4. 다운로드 */
    var filename = 'FPROOF_' + from + '_' + to + '.xlsx';
    XLSX.writeFile(wb, filename);

  } catch (e) {
    alert('엑셀 생성 실패: ' + e.message);
  } finally {
    btn.disabled = false;
    btn.textContent = '엑셀 출력';
  }
}

function resetDetail() {
  document.getElementById('detailTitle').textContent = '알람 상세';
  document.getElementById('alarmBadge').textContent  = '0건';
  document.getElementById('detailWrap').innerHTML =
    '<div class="fl-empty"><div class="fl-empty-icon">🛡️</div>' +
    '<div class="fl-empty-txt">세션을 선택하세요</div></div>';
}

function fmtDt(dt) {
  if (!dt) return '-';
  return String(dt).replace('T', ' ').substring(0, 16);
}
function esc(s) {
  return String(s || '')
    .replace(/&/g,'&amp;').replace(/</g,'&lt;')
    .replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}
</script>
</body>
</html>
