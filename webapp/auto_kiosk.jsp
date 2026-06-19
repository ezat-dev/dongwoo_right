<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>AUTO KIOSK</title>
  <style>
    * { margin:0; padding:0; box-sizing:border-box; }
    html, body { width:100%; height:100%; overflow:hidden; background:#0f1923; display:flex; flex-direction:column;
      font-family:'Malgun Gothic','맑은 고딕','Segoe UI',sans-serif; }

    /* ── 상단 바 ── */
    .kiosk-bar {
      height:66px; flex-shrink:0;
      background: linear-gradient(90deg,#1a2744,#162040);
      border-bottom: 2px solid #2d4a7a;
      display:flex; align-items:center; justify-content:space-between;
      padding:0 22px; position:relative;
    }
    .k-left  { display:flex; align-items:center; gap:12px; }
    .k-right { display:flex; align-items:center; gap:10px; }
    .k-dot {
      width:11px; height:11px; border-radius:50%; background:#38A169; flex-shrink:0;
      animation:kpulse 1.4s ease-in-out infinite;
    }
    @keyframes kpulse { 0%,100%{opacity:1} 50%{opacity:.3} }
    .k-name {
      font-size:19px; font-weight:800; color:#fff;
      letter-spacing:1.4px;
    }
    .k-time {
      font-size:17px; font-weight:700; color:#90CDF4;
      min-width:84px; text-align:right; letter-spacing:.5px;
    }
    .k-divider { width:1px; height:28px; background:rgba(255,255,255,.18); margin:0 2px; }
    .k-btn {
      padding:7px 18px; border-radius:14px;
      background:rgba(255,255,255,.12); color:#fff;
      border:1px solid rgba(255,255,255,.22);
      font-size:13px; font-weight:700; cursor:pointer;
      transition:background .13s; white-space:nowrap;
    }
    .k-btn:hover { background:rgba(255,255,255,.24); }
    .k-btn.stop  { background:rgba(220,38,38,.22); border-color:rgba(220,38,38,.4); }
    .k-btn.stop:hover { background:rgba(220,38,38,.45); }

    /* 진행 바 */
    .k-progress { position:absolute; bottom:0; left:0; right:0; height:3px; background:rgba(255,255,255,.08); }
    .k-progress-fill { height:100%; width:0%; background:#38A169; }

    /* ── 아이프레임 ── */
    #kioskFrame { flex:1; width:100%; border:none; display:block; background:#fff; min-height:0; }
  </style>
</head>
<body>
  <div class="kiosk-bar">
    <div class="k-left">
      <div class="k-dot"></div>
      <div class="k-name" id="kName">로딩중…</div>
    </div>
    <div class="k-right">
      <div class="k-time" id="kTime">--:--:--</div>
      <div class="k-divider"></div>
      <button class="k-btn" onclick="toggleFs()">⛶ 전체화면</button>
      <button class="k-btn stop" onclick="stopKiosk()">■ 종료</button>
    </div>
    <div class="k-progress"><div class="k-progress-fill" id="kBar"></div></div>
  </div>
  <iframe id="kioskFrame" src=""></iframe>

<script>
var ctx = '<%= ctx %>';
var PAGES = [
  { url: ctx + '/main_1/main/monitor',  name: 'OVERVIEW-1' },
  { url: ctx + '/main_1/main/monitor2', name: 'OVERVIEW-2' },
  { url: ctx + '/main_1/work/now1',     name: '현재 작업 1' },
  { url: ctx + '/main_1/work/now2',     name: '현재 작업 2' },
  { url: ctx + '/main_1/work/list',     name: '작업 목록'   }
];
var INTERVAL = 10000;
var idx = 0, timer = null, rafId = null, barStart = null;

/* ── 페이지 전환 ── */
function showPage(i) {
  var p = PAGES[i];
  document.getElementById('kioskFrame').src = p.url;
  document.getElementById('kName').textContent = p.name;
  startBar();
}

/* ── 진행 바 ── */
function startBar() {
  if (rafId) cancelAnimationFrame(rafId);
  barStart = null;
  var fill = document.getElementById('kBar');
  fill.style.transition = 'none';
  fill.style.width = '0%';
  function step(ts) {
    if (!barStart) barStart = ts;
    var pct = Math.min((ts - barStart) / INTERVAL * 100, 100);
    fill.style.width = pct + '%';
    if (pct < 100) rafId = requestAnimationFrame(step);
  }
  rafId = requestAnimationFrame(step);
}

/* ── 시간 ── */
function tick() {
  var d = new Date(), p = function(n){ return String(n).padStart(2,'0'); };
  document.getElementById('kTime').textContent =
    p(d.getHours()) + ':' + p(d.getMinutes()) + ':' + p(d.getSeconds());
}
tick(); setInterval(tick, 1000);

/* ── 전체화면 토글 ── */
function toggleFs() {
  if (!document.fullscreenElement) {
    document.documentElement.requestFullscreen().catch(function(){});
  } else {
    document.exitFullscreen();
  }
}

/* ── 종료 ── */
function stopKiosk() {
  if (timer) clearInterval(timer);
  if (rafId)  cancelAnimationFrame(rafId);
  try { if (document.fullscreenElement) document.exitFullscreen(); } catch(e){}
  window.location.href = ctx + '/main_1/main/monitor';
}

/* ── iframe 로드 시 tm-panel 높이 조정 ── */
document.getElementById('kioskFrame').addEventListener('load', function() {
  try {
    var doc = this.contentDocument;
    if (!doc || !doc.head) return;
    var old = doc.getElementById('__kiosk_tm_fix');
    if (old) old.parentNode.removeChild(old);
    var s = doc.createElement('style');
    s.id = '__kiosk_tm_fix';
    s.textContent = '.tm-panel { padding-top: 14px !important; padding-bottom: 22px !important; }';
    doc.head.appendChild(s);
  } catch(e) {}
});

/* ── 시작 ── */
showPage(0);
timer = setInterval(function() {
  idx = (idx + 1) % PAGES.length;
  showPage(idx);
}, INTERVAL);

/* 전체화면 자동 시도 (AUTO 버튼 클릭 시 제스처 전파로 동작) */
try { document.documentElement.requestFullscreen().catch(function(){}); } catch(e){}
</script>
</body>
</html>
