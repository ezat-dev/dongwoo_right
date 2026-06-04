<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("loginEmp") == null && session.getAttribute("loginUser") == null) {
        String loginUrl = request.getContextPath() + "/main_1/login";
%>
<!DOCTYPE html><html><head><script>
window.top.location.replace('<%=loginUrl%>');
</script></head><body></body></html>
<%
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MES 사용자 포털</title>
<style>
:root {
  --bg:        #F0F4F8;
  --white:     #FFFFFF;
  --primary:   #3182CE;
  --primary-d: #2B6CB0;
  --primary-l: #EBF8FF;
  --primary-m: #BEE3F8;
  --green:     #38A169;
  --green-l:   #F0FFF4;
  --orange:    #DD6B20;
  --orange-l:  #FFFAF0;
  --red:       #E53E3E;
  --red-l:     #FFF5F5;
  --purple:    #6B46C1;
  --purple-l:  #FAF5FF;
  --text:      #2D3748;
  --muted:     #718096;
  --light:     #A0AEC0;
  --border:    #E2E8F0;
  --shadow:    0 1px 4px rgba(0,0,0,.08);
  --shadow-md: 0 4px 12px rgba(0,0,0,.10);
}
* { box-sizing: border-box; margin: 0; padding: 0; }
html, body { height: 100%; font-family: 'Segoe UI', 'Malgun Gothic', sans-serif; background: var(--bg); color: var(--text); }

/* ══ 레이아웃 ══ */
.layout { display: flex; height: 100vh; overflow: hidden; }

/* ══ 사이드바 ══ */
.sidebar {
  width: 230px; flex-shrink: 0;
  background: var(--white);
  border-right: 1px solid var(--border);
  display: flex; flex-direction: column;
  box-shadow: 2px 0 8px rgba(0,0,0,.05);
  transition: width .22s cubic-bezier(.4,0,.2,1);
  overflow: hidden; position: relative; z-index: 10;
}
.sidebar.collapsed { width: 58px; }

/* 로고 */
.sb-logo {
  display: flex; align-items: center; justify-content: center;
  padding: 12px 14px; border-bottom: 1px solid var(--border);
  min-height: 62px; flex-shrink: 0; overflow: hidden;
  cursor: pointer;
  transition: background .2s, box-shadow .2s;
  border-radius: 0;
}
.sb-logo:hover {
  background: rgba(37,99,235,.07);
  box-shadow: inset 0 -2px 0 var(--primary);
}
.sb-logo:hover img { filter: brightness(1.08) drop-shadow(0 1px 4px rgba(37,99,235,.25)); }
.sb-logo img { height: 34px; max-width: 180px; object-fit: contain; transition: max-width .22s, filter .2s; }
.sidebar.collapsed .sb-logo img { max-width: 32px; }

/* 스크롤 영역 */
.sb-body { flex: 1; overflow-y: auto; overflow-x: hidden; padding: 8px 0; }
.sb-body::-webkit-scrollbar { width: 3px; }
.sb-body::-webkit-scrollbar-thumb { background: var(--border); border-radius: 2px; }

/* 그룹 헤더 */
.sb-group-header {
  display: flex; align-items: center; gap: 7px;
  padding: 7px 10px 4px 12px; cursor: pointer;
  border-radius: 7px; margin: 6px 4px 0;
  transition: background .13s; user-select: none;
}
.sb-group-header:hover { background: var(--bg); }
.sb-group-cat-icon {
  width: 20px; height: 20px; flex-shrink: 0;
  font-size: 13px; display: flex; align-items: center; justify-content: center;
}
.sb-group-name {
  flex: 1; font-size: 12px; font-weight: 700; letter-spacing: .6px;
  color: var(--text); white-space: nowrap; transition: opacity .15s;
}
.sb-group-chevron {
  font-size: 9px; color: var(--light);
  transition: transform .2s, opacity .15s;
}
.sb-group-header.closed .sb-group-chevron { transform: rotate(-90deg); }
.sidebar.collapsed .sb-group-name,
.sidebar.collapsed .sb-group-chevron,
.sidebar.collapsed .sb-group-cat-icon { opacity: 0; pointer-events: none; }

/* 그룹 바디 */
.sb-group-body { overflow: hidden; transition: max-height .25s ease; }
.sb-group-body.open  { max-height: 600px; }
.sb-group-body.closed { max-height: 0; }

/* 준비중 아이템 */
.sb-item.coming-soon {
  cursor: default; pointer-events: none;
  color: var(--text); background: transparent;
}
.sb-item.coming-soon .sb-icon { opacity: .5; }
.sb-item.coming-soon .sb-label {
  font-size: 11px; font-style: italic;
  color: var(--muted);
}
.sb-item.coming-soon .sb-label::after {
  content: '…';
  margin-left: 3px; color: var(--light);
}

/* 메뉴 아이템 */
.sb-item {
  display: flex; align-items: center; gap: 10px;
  padding: 8px 12px; margin: 1px 6px;
  border-radius: 8px; cursor: pointer;
  color: var(--muted); text-decoration: none;
  font-size: 13px; font-weight: 500;
  transition: background .13s, color .13s;
  white-space: nowrap; overflow: hidden;
  position: relative;
}
.sb-item:hover { background: var(--primary-l); color: var(--primary); }
.sb-item.active {
  background: linear-gradient(90deg, var(--primary-l), #D6EAF8);
  color: var(--primary-d); font-weight: 600;
}
.sb-item.active::before {
  content: ''; position: absolute;
  left: 0; top: 18%; bottom: 18%;
  width: 3px; background: var(--primary);
  border-radius: 0 3px 3px 0;
}
.sb-icon {
  width: 30px; height: 30px; flex-shrink: 0;
  display: flex; align-items: center; justify-content: center;
  font-size: 16px; border-radius: 7px;
  background: var(--bg); transition: background .13s;
}
.sb-item:hover .sb-icon,
.sb-item.active .sb-icon { background: var(--primary-m); }
.sb-label { flex: 1; }
.sb-badge {
  font-size: 10px; background: var(--red); color: #fff;
  padding: 1px 5px; border-radius: 10px; font-weight: 700;
}

/* 접기 버튼 */
.sb-footer { border-top: 1px solid var(--border); padding: 8px 6px; flex-shrink: 0; }
.btn-collapse {
  width: 100%; display: flex; align-items: center; gap: 8px;
  padding: 7px 8px; border: none; background: none;
  cursor: pointer; color: var(--muted); font-size: 12px;
  border-radius: 7px; transition: background .13s;
  white-space: nowrap; overflow: hidden;
}
.btn-collapse:hover { background: var(--bg); }
.collapse-icon { font-size: 14px; flex-shrink: 0; width: 30px; text-align: center; transition: transform .22s; }
.sidebar.collapsed .collapse-icon { transform: rotate(180deg); }

/* ══ 메인 영역 ══ */
.main-area { flex: 1; display: flex; flex-direction: column; overflow: hidden; }

/* 상단 헤더 */
.topbar {
  height: 62px; background: var(--white);
  border-bottom: 1px solid var(--border);
  display: flex; align-items: center;
  padding: 0 22px; gap: 14px; flex-shrink: 0;
  box-shadow: var(--shadow);
}
.topbar-breadcrumb { font-size: 11px; color: var(--light); }
.topbar-title { font-size: 17px; font-weight: 700; color: var(--text); flex: 1; }
.topbar-right { display: flex; align-items: center; gap: 10px; }
.topbar-date {
  font-size: 12px; color: var(--muted);
  background: var(--bg); padding: 5px 12px;
  border-radius: 20px; border: 1px solid var(--border);
}
.user-chip {
  display: flex; align-items: center; gap: 7px;
  background: var(--primary-l); border: 1px solid var(--primary-m);
  border-radius: 20px; padding: 4px 12px 4px 5px; cursor: pointer;
}
.user-avatar {
  width: 26px; height: 26px;
  background: linear-gradient(135deg, #4299E1, #2B6CB0);
  border-radius: 50%; display: flex; align-items: center;
  justify-content: center; color: #fff; font-size: 11px; font-weight: 700;
}
.user-name { font-size: 12px; font-weight: 600; color: var(--primary-d); }
.btn-logout {
  padding: 5px 14px; border-radius: 6px;
  border: 1px solid var(--border); background: none;
  color: var(--muted); font-size: 12px; cursor: pointer;
  transition: all .13s;
}
.btn-logout:hover { background: var(--red-l); border-color: var(--red); color: var(--red); }

/* iframe 영역 */
.frame-wrap { flex: 1; overflow: hidden; }
.frame-wrap iframe { width: 100%; height: 100%; border: none; display: block; }
</style>
</head>
<body>
<div class="layout">

  <!-- ══ 사이드바 ══ -->
  <nav class="sidebar" id="sidebar">

    <div class="sb-logo" onclick="go('${pageContext.request.contextPath}/main_1/equip/monitor','통신 모니터링',null)">
      <img src="${pageContext.request.contextPath}/img/동우 로고 디자인.png" alt="로고">
    </div>

    <div class="sb-body">

      <%-- 제품관리
      <div class="sb-group-header closed empty" onclick="toggleGroup(this)">
        <span class="sb-group-cat-icon">📦</span>
        <span class="sb-group-name">제품관리</span>
        <span class="sb-group-chevron">▼</span>
      </div>
      <div class="sb-group-body closed">
      </div>
      --%>

      <%-- 생산관리
      <div class="sb-group-header closed empty" onclick="toggleGroup(this)">
        <span class="sb-group-cat-icon">🏭</span>
        <span class="sb-group-name">생산관리</span>
        <span class="sb-group-chevron">▼</span>
      </div>
      <div class="sb-group-body closed">
      </div>
      --%>

      <%-- 생산공정관리
      <div class="sb-group-header closed empty" onclick="toggleGroup(this)">
        <span class="sb-group-cat-icon">⚙️</span>
        <span class="sb-group-name">생산공정관리</span>
        <span class="sb-group-chevron">▼</span>
      </div>
      <div class="sb-group-body closed">
      </div>
      --%>

      <!-- 모니터링 -->
      <div class="sb-group-header open" onclick="toggleGroup(this)">
        <span class="sb-group-cat-icon">📡</span>
        <span class="sb-group-name">모니터링</span>
        <span class="sb-group-chevron">▼</span>
      </div>
      <div class="sb-group-body open">
        <a class="sb-item" href="#" onclick="go('${pageContext.request.contextPath}/main_1/equip/monitor','통신 모니터링',this);return false;">
          <div class="sb-icon">🖥️</div><span class="sb-label">통신 모니터링</span>
        </a>
        <a class="sb-item" href="#" onclick="go('${pageContext.request.contextPath}/main_1/main/monitor','메인 모니터링',this);return false;">
          <div class="sb-icon">🧭</div><span class="sb-label">메인 모니터링</span>
        </a>
        <a class="sb-item" href="#" onclick="go('${pageContext.request.contextPath}/main_1/equip/detail','설비 상세',this);return false;">
          <div class="sb-icon">🔍</div><span class="sb-label">설비 상세</span>
        </a>
        <a class="sb-item" href="#" onclick="go('${pageContext.request.contextPath}/main_1/work/list','작업LIST',this);return false;">
          <div class="sb-icon">📋</div><span class="sb-label">작업LIST</span>
        </a>
        <a class="sb-item" href="#" onclick="go('${pageContext.request.contextPath}/main_1/work/now1','공정현황-1',this);return false;">
          <div class="sb-icon">🏭</div><span class="sb-label">공정현황-1</span>
        </a>
        <a class="sb-item" href="#" onclick="go('${pageContext.request.contextPath}/main_1/work/now2','공정현황-2',this);return false;">
          <div class="sb-icon">🏭</div><span class="sb-label">공정현황-2</span>
        </a>
        <a class="sb-item" href="#" onclick="go('${pageContext.request.contextPath}/main_1/trend','트렌드',this);return false;">
          <div class="sb-icon">📈</div><span class="sb-label">트렌드</span>
        </a>
        <a class="sb-item" href="#" onclick="go('${pageContext.request.contextPath}/main_1/alarm/history','알람 이력',this);return false;">
          <div class="sb-icon">🔔</div><span class="sb-label">알람 이력</span><span class="sb-badge" id="alarmBadge">0</span>
        </a>
        <a class="sb-item" href="#" onclick="go('${pageContext.request.contextPath}/main_1/alarm/ranking','알람 랭킹',this);return false;">
          <div class="sb-icon">🏆</div><span class="sb-label">알람 랭킹</span>
        </a>
      </div>

      <!-- 설비보존관리 -->
      <div class="sb-group-header open" onclick="toggleGroup(this)">
        <span class="sb-group-cat-icon">🔧</span>
        <span class="sb-group-name">설비보존관리</span>
        <span class="sb-group-chevron">▼</span>
      </div>
      <div class="sb-group-body open">
        <a class="sb-item" href="#" onclick="go('${pageContext.request.contextPath}/main_1/calib/status','보정현황',this);return false;">
          <div class="sb-icon">🌡️</div><span class="sb-label">보정현황</span>
        </a>
        <a class="sb-item" href="#" onclick="go('${pageContext.request.contextPath}/main_1/inspect/daily','일상점검일지',this);return false;">
          <div class="sb-icon">📋</div><span class="sb-label">일상점검일지</span>
        </a>
        <a class="sb-item" href="#" onclick="go('${pageContext.request.contextPath}/main_1/auxiliary/inspection','부대설비 점검표',this);return false;">
          <div class="sb-icon">🏭</div><span class="sb-label">부대설비 점검표</span>
        </a>
        <a class="sb-item" href="#" onclick="go('${pageContext.request.contextPath}/main_1/spare/parts','스페어파트',this);return false;">
          <div class="sb-icon">🔩</div><span class="sb-label">스페어파트</span>
        </a>
        <a class="sb-item" href="#" onclick="go('${pageContext.request.contextPath}/main_1/facility/backup','BACKUP-DATA',this);return false;">
          <div class="sb-icon">💾</div><span class="sb-label">BACKUP-DATA</span>
        </a>
        <a class="sb-item" href="#" onclick="go('${pageContext.request.contextPath}/main_1/consumable/ledger','유류·소모재 관리대장',this);return false;">
          <div class="sb-icon">🛢️</div><span class="sb-label">유류·소모재 관리대장</span>
        </a>
      </div>

      <!-- 품질관리 -->
      <div class="sb-group-header open" onclick="toggleGroup(this)">
        <span class="sb-group-cat-icon">✅</span>
        <span class="sb-group-name">품질관리</span>
        <span class="sb-group-chevron">▼</span>
      </div>
      <div class="sb-group-body open">
        <a class="sb-item" href="#" onclick="go('${pageContext.request.contextPath}/main_1/inspect/fproof','F/PROOF',this);return false;">
          <div class="sb-icon">🛡️</div><span class="sb-label">F/PROOF</span>
        </a>
      </div>

      <!-- 경영정보 -->
      <div class="sb-group-header closed empty" onclick="toggleGroup(this)">
        <span class="sb-group-cat-icon">📊</span>
        <span class="sb-group-name">경영정보</span>
        <span class="sb-group-chevron">▼</span>
      </div>
      <div class="sb-group-body closed">
        <%-- <a class="sb-item coming-soon" href="#"><div class="sb-icon">·</div><span class="sb-label">준비중</span></a> --%>
      </div>

      <!-- 기준정보 -->
      <div class="sb-group-header open" onclick="toggleGroup(this)">
        <span class="sb-group-cat-icon">🗂️</span>
        <span class="sb-group-name">기준정보</span>
        <span class="sb-group-chevron">▼</span>
      </div>
      <div class="sb-group-body open">
        <a class="sb-item" href="#" onclick="go('${pageContext.request.contextPath}/main_1/user/manage','사용자 관리',this);return false;">
          <div class="sb-icon">👤</div><span class="sb-label">사용자 관리</span>
        </a>
        <a class="sb-item" href="#" onclick="go('${pageContext.request.contextPath}/main_1/user/permission','권한 부여',this);return false;">
          <div class="sb-icon">🔐</div><span class="sb-label">권한 부여</span>
        </a>
        <%-- 제품 등록
        <a class="sb-item" href="#" onclick="go('${pageContext.request.contextPath}/main_1/management/productInsert','제품 등록',this);return false;">
          <div class="sb-icon">🔐</div><span class="sb-label">제품 등록</span>
        </a>
        --%>
      </div>

      <%-- 작업지시
      <div class="sb-group-header closed empty" onclick="toggleGroup(this)">
        <span class="sb-group-cat-icon">📝</span>
        <span class="sb-group-name">작업지시</span>
        <span class="sb-group-chevron">▼</span>
      </div>
      <div class="sb-group-body closed">
      </div>
      --%>

    </div>

    <div class="sb-footer">
      <button class="btn-collapse" onclick="toggleSidebar()">
        <span class="collapse-icon">◀</span>
        <span style="font-size:12px;white-space:nowrap">메뉴 접기</span>
      </button>
    </div>
  </nav>

  <!-- ══ 메인 영역 ══ -->
  <div class="main-area">
    <header class="topbar">
      <div>
        <div class="topbar-breadcrumb">MES Portal</div>
        <div class="topbar-title" id="pageTitle">설비 모니터링</div>
      </div>
      <div class="topbar-right">
        <div class="topbar-date" id="topbarDate"></div>
        <div class="user-chip">
          <div class="user-avatar" id="userAvatar">U</div>
          <span class="user-name" id="userName">사용자</span>
        </div>
        <button class="btn-logout" onclick="doLogout()">로그아웃</button>
      </div>
    </header>

    <div class="frame-wrap">
      <iframe id="pageFrame" src="${pageContext.request.contextPath}/main_1/equip/monitor"></iframe>
    </div>
  </div>

</div>
<script>
function go(url, title, el) {
  document.getElementById('pageFrame').src = url;
  document.getElementById('pageTitle').textContent = title;
  document.querySelectorAll('.sb-item').forEach(function(i){ i.classList.remove('active'); });
  if(el) el.classList.add('active');
}
function toggleSidebar() {
  document.getElementById('sidebar').classList.toggle('collapsed');
}
function toggleGroup(header) {
  var isOpen = header.classList.contains('open');
  header.classList.toggle('open', !isOpen);
  header.classList.toggle('closed', isOpen);
  var body = header.nextElementSibling;
  body.classList.toggle('open', !isOpen);
  body.classList.toggle('closed', isOpen);
}
function updateDate() {
  var d = new Date(), days = ['일','월','화','수','목','금','토'];
  var s = d.getFullYear()+'.'+pad(d.getMonth()+1)+'.'+pad(d.getDate())
        +' ('+days[d.getDay()]+')  '+pad(d.getHours())+':'+pad(d.getMinutes());
  document.getElementById('topbarDate').textContent = s;
}
function pad(n){ return String(n).padStart(2,'0'); }
updateDate(); setInterval(updateDate, 10000);
document.querySelector('.sb-item').classList.add('active');

/* 로그인 유저 이름 로드 */
fetch('${pageContext.request.contextPath}/emp/me')
  .then(function(r){ return r.json(); })
  .then(function(d){
    if(d.success && d.data){
      var name = d.data.emp_name || d.data.id || '사용자';
      document.getElementById('userName').textContent = name;
      document.getElementById('userAvatar').textContent = name.charAt(0);
    }
  });

var OV_URLS = {
  1: '${pageContext.request.contextPath}/main_1/main/monitor',
  2: '${pageContext.request.contextPath}/main_1/main/monitor2'
};
function goOverview(num) {
  document.getElementById('pageFrame').src = OV_URLS[num];
  document.getElementById('pageTitle').textContent = 'OVERVIEW-' + num;
  document.querySelectorAll('.sb-item').forEach(function(i){ i.classList.remove('active'); });
  document.querySelectorAll('.ov-tab').forEach(function(b){ b.classList.remove('active'); });
  document.getElementById('ovTab' + num).classList.add('active');
}

function doLogout(){
  fetch('${pageContext.request.contextPath}/user/logout', {method:'POST'})
    .catch(function(){})
    .finally(function(){
      location.href = '${pageContext.request.contextPath}/main_1/login';
    });
}
</script>
</body>
</html>


