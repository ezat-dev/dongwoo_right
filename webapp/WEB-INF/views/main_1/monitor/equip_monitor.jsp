<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common_style.jsp" %>
<style>
.equip-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(270px, 1fr));
  gap: 16px;
}

/* Card */
.equip-card {
  background: var(--white);
  border: 1px solid var(--border);
  border-radius: 14px;
  padding: 20px 20px 16px;
  box-shadow: var(--shadow);
  transition: box-shadow .2s, transform .2s;
  position: relative;
  overflow: hidden;
}
.equip-card:hover { box-shadow: var(--shadow-md); transform: translateY(-2px); }
.equip-card::before {
  content: ''; position: absolute; top: 0; left: 0; bottom: 0; width: 4px;
  border-radius: 14px 0 0 14px;
}
.equip-card.status-ok::before    { background: var(--green); }
.equip-card.status-warn::before  { background: var(--orange); }
.equip-card.status-alarm::before { background: var(--red); }
.equip-card.status-off::before   { background: #CBD5E0; }

/* Card glow on status */
.equip-card.status-ok    { box-shadow: var(--shadow), 0 0 0 1px rgba(56,161,105,.12); }
.equip-card.status-alarm { box-shadow: var(--shadow), 0 0 0 1px rgba(229,62,62,.12); }

/* Header */
.eq-head { display:flex; align-items:center; justify-content:space-between; margin-bottom:14px; }
.eq-title { display:flex; align-items:center; gap:9px; min-width:0; }
.eq-icon  { font-size:20px; flex-shrink:0; }
.eq-name  { font-size:14px; font-weight:700; color:var(--text); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
.eq-type  { font-size:10px; color:var(--muted); font-weight:600; margin-top:2px; letter-spacing:.3px; }

/* Status badge */
.eq-badge {
  display:inline-flex; align-items:center; gap:5px; flex-shrink:0;
  padding:4px 10px; border-radius:20px; font-size:11px; font-weight:700;
}
.eq-badge-ok    { background:rgba(56,161,105,.1);  color:#276749; border:1px solid rgba(56,161,105,.3); }
.eq-badge-warn  { background:rgba(221,107,32,.1);  color:#9C4221; border:1px solid rgba(221,107,32,.3); }
.eq-badge-alarm { background:rgba(229,62,62,.1);   color:#9B2C2C; border:1px solid rgba(229,62,62,.3); }
.eq-badge-off   { background:rgba(160,174,192,.1); color:#4A5568; border:1px solid rgba(160,174,192,.3); }
.bdot { width:6px; height:6px; border-radius:50%; }
.bdot-ok    { background:#38A169; animation:bpulse 1.4s ease-in-out infinite; }
.bdot-alarm { background:#E53E3E; animation:bpulse  .8s ease-in-out infinite; }
.bdot-warn  { background:#DD6B20; animation:bpulse 1.2s ease-in-out infinite; }
.bdot-off   { background:#A0AEC0; }
@keyframes bpulse { 0%,100%{opacity:1;box-shadow:0 0 4px currentColor} 50%{opacity:.3;box-shadow:none} }

/* IP block */
.eq-ip-block {
  display:flex; align-items:center; gap:10px;
  background:var(--bg); border-radius:10px; padding:10px 14px;
  margin-bottom:14px;
}
.eq-ip-signal { font-size:16px; }
.eq-ip-addr { font-size:16px; font-weight:700; color:var(--text); font-family:'Consolas','Courier New',monospace; letter-spacing:.5px; }
.eq-ip-port { font-size:11px; color:var(--muted); margin-top:2px; font-family:monospace; }

/* Gauge row */
.eq-gauge-row { display:flex; align-items:center; gap:14px; margin-bottom:12px; }

/* SVG ring */
.eq-ring-bg { fill:none; stroke:#EDF2F7; stroke-width:7; }
.eq-ring-fg { fill:none; stroke-width:7; stroke-linecap:round;
              transition:stroke-dashoffset 1.3s cubic-bezier(.4,0,.2,1); }

/* RTT + history */
.eq-side { flex:1; min-width:0; display:flex; flex-direction:column; gap:10px; }
.eq-side-lbl { font-size:10px; color:var(--muted); font-weight:600; margin-bottom:4px; }
.eq-rtt-row { display:flex; align-items:center; gap:8px; }
.eq-rtt-bar { flex:1; height:6px; background:#EDF2F7; border-radius:3px; overflow:hidden; }
.eq-rtt-fill { height:100%; border-radius:3px; transition:width 1.1s ease; }
.eq-rtt-val { font-family:monospace; font-size:11px; font-weight:700; min-width:38px; text-align:right; }

/* Poll history dots */
.eq-hist { display:flex; gap:3px; flex-wrap:wrap; }
.eq-hdot { width:8px; height:8px; border-radius:2px; }

/* Footer */
.eq-foot {
  display:flex; align-items:center; justify-content:space-between;
  padding-top:10px; border-top:1px solid var(--border);
  font-size:10px; color:var(--muted);
}

/* Summary */
.summary-bar { display:flex; gap:10px; margin-bottom:20px; flex-wrap:wrap; }
.summary-chip {
  display:flex; align-items:center; gap:8px; padding:8px 18px;
  border-radius:10px; border:1px solid var(--border); background:var(--white);
  font-size:12px; font-weight:600; box-shadow:var(--shadow);
}
.chip-dot { width:9px; height:9px; border-radius:50%; flex-shrink:0; }
.chip-dot-ok    { background:var(--green); }
.chip-dot-warn  { background:var(--orange); }
.chip-dot-alarm { background:var(--red); }
.chip-dot-off   { background:#A0AEC0; }

.err-card { grid-column:1/-1; text-align:center; padding:60px; color:var(--muted); font-size:13px; }
</style>
<body>
<div class="page-wrap">
  <div class="page-header">
    <div>
      <div class="page-title">통신 모니터링</div>
      <div class="page-sub" id="subTitle">PLC 목록 로딩 중…</div>
    </div>
    <div style="display:flex;gap:8px;align-items:center">
      <span style="font-size:11px;color:var(--muted)" id="lastUpdate"></span>
      <button class="btn-primary" onclick="refreshAll()">↺ 새로고침</button>
    </div>
  </div>

  <div class="summary-bar">
    <div class="summary-chip"><div class="chip-dot chip-dot-ok"></div>정상
    
    <strong id="cntOk">0</strong>대</div>
    <div class="summary-chip"><div class="chip-dot chip-dot-warn"></div>경고 <strong id="cntWarn">0</strong>대</div>
    <div class="summary-chip"><div class="chip-dot chip-dot-alarm"></div>오류 <strong id="cntAlarm">0</strong>대</div>
    <div class="summary-chip"><div class="chip-dot chip-dot-off"></div>오프라인 <strong id="cntOff">0</strong>대</div>
  </div>

  <div class="equip-grid" id="equipGrid">
    <div class="err-card">PLC 목록을 불러오는 중…</div>
  </div>
</div>

<script>
var base      = '${pageContext.request.contextPath}';
var plcList   = [];
var plcState  = {};   // { id: {status, lastOk, error, rtt} }
var uptimeBuf = {};   // { id: [1,0,1,…] } 최대 20개
var rttBuf    = {};   // { id: [ms,…] }    최대 20개

var STATUS_LABEL = { ok:'정상', warn:'경고', alarm:'오류', off:'오프라인' };
var STATUS_COLOR = { ok:'#38A169', warn:'#DD6B20', alarm:'#E53E3E', off:'#CBD5E0' };
var TYPE_ICON    = { LS:'🔵', MITSUBISHI:'🔴', MODBUS_TCP:'🟠', MODBUSTCP:'🟠', LSELECTRIC:'🔵' };
var CIRC         = 2 * Math.PI * 36;  // r=36 → ≈226.2

function esc(s){ return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }
function fmtTime(d){ return String(d.getHours()).padStart(2,'0')+':'+String(d.getMinutes()).padStart(2,'0')+':'+String(d.getSeconds()).padStart(2,'0'); }
function safeId(id){ return 'ring_'+String(id).replace(/[^a-zA-Z0-9]/g,'_'); }

/* PLC 목록 */
function fetchList(){
  return fetch(base+'/plc/dblist')
    .then(function(r){ return r.json(); })
    .then(function(d){ if(d && d.data) plcList = d.data; })
    .catch(function(){ plcList = []; });
}

/* 전체 PLC 상태 일괄 조회 — C# API 직접 호출 (새 TCP 연결 없음) */
function pollAll(){
  if(!plcList.length) return Promise.resolve();
  var csBase = 'http://'+location.hostname+':5050';
  var t0 = Date.now();
  return fetch(csBase+'/api/plc/status-all')
    .then(function(r){ return r.json(); })
    .then(function(statuses){
      var rtt = Date.now()-t0;
      var idMap = {};
      (statuses||[]).forEach(function(s){ idMap[s.id]=s; });
      plcList.forEach(function(plc){
        var id = plc.plcId||plc.plc_id||plc.id;
        if(!uptimeBuf[id]) uptimeBuf[id]=[];
        if(!rttBuf[id])    rttBuf[id]=[];
        var s = idMap[id];
        if(s && s.ok){
          uptimeBuf[id].push(1);
          rttBuf[id].push(rtt);
          plcState[id]={status:'ok',lastOk:new Date(),error:'',rtt:rtt};
        } else {
          uptimeBuf[id].push(0);
          plcState[id]={status:'alarm',lastOk:(plcState[id]||{}).lastOk||null,
                        error:(s&&s.message)||'통신 없음',rtt:null};
        }
        if(uptimeBuf[id].length>20) uptimeBuf[id].shift();
        if(rttBuf[id].length>20)    rttBuf[id].shift();
      });
      renderGrid();
    })
    .catch(function(e){
      plcList.forEach(function(plc){
        var id=plc.plcId||plc.plc_id||plc.id;
        if(!uptimeBuf[id]) uptimeBuf[id]=[];
        uptimeBuf[id].push(0);
        if(uptimeBuf[id].length>20) uptimeBuf[id].shift();
        plcState[id]={status:'off',lastOk:(plcState[id]||{}).lastOk||null,
                      error:'C# API 연결 실패',rtt:null};
      });
      renderGrid();
    });
}

/* 렌더링 */
function renderGrid(){
  if(!plcList.length){
    document.getElementById('equipGrid').innerHTML = '<div class="err-card">등록된 PLC가 없습니다.</div>';
    updateSummary({ok:0,warn:0,alarm:0,off:0});
    document.getElementById('subTitle').textContent = 'PLC 0대 등록됨';
    return;
  }

  var cnt  = {ok:0, warn:0, alarm:0, off:0};
  var html = '';

  plcList.forEach(function(plc){
    var id    = plc.plcId || plc.plc_id || plc.id;
    var label = plc.label || id;
    var ip    = plc.ip   || '–';
    var port  = plc.port || '502';
    var ptype = (plc.plcType || '').toUpperCase();
    var ptypeKey = ptype.replace(/[\s\-]/g,'_');
    var icon  = TYPE_ICON[ptypeKey] || '⚙️';
    var ptypeDisplay = ptype.replace(/_/g,' ');

    var st = plcState[id] || { status:'off', error:'폴링 대기', rtt:null };
    var s  = (st.status in cnt) ? st.status : 'off';
    cnt[s]++;

    var color = STATUS_COLOR[s];

    /* 가용률 */
    var ubuf   = uptimeBuf[id] || [];
    var uptime = ubuf.length ? ubuf.reduce(function(a,b){return a+b;},0)/ubuf.length*100 : 0;
    var offset = (CIRC*(1 - uptime/100)).toFixed(1);

    /* 응답시간 */
    var rbuf   = rttBuf[id] || [];
    var rtt    = st.rtt;
    var rttColor = !rtt ? '#CBD5E0' : rtt < 50 ? '#38A169' : rtt < 200 ? '#DD6B20' : '#E53E3E';
    var rttPct   = !rtt ? 0 : Math.min(rtt/300*100, 100).toFixed(1);
    var rttLabel = rtt != null ? rtt+'ms' : '–';

    /* 히스토리 도트 */
    var histHtml = '';
    if(ubuf.length){
      ubuf.forEach(function(v){
        histHtml += '<div class="eq-hdot" style="background:'+(v?'#68D391':'#FC8181')+'" title="'+(v?'성공':'실패')+'"></div>';
      });
    } else {
      histHtml = '<span style="font-size:10px;color:var(--muted)">대기 중…</span>';
    }

    /* 마지막 성공 */
    var lastStr = st.lastOk ? fmtTime(st.lastOk) : '–';

    /* 오류 문구 */
    var errStr  = (s !== 'ok' && st.error) ? esc(st.error) : '';

    var rid = safeId(id);

    html +=
      '<div class="equip-card status-'+s+'">'

      /* 헤더 */
      +'<div class="eq-head">'
      +'  <div class="eq-title">'
      +'    <span class="eq-icon">'+icon+'</span>'
      +'    <div style="min-width:0">'
      +'      <div class="eq-name" title="'+esc(label)+'">'+esc(label)+'</div>'
      +'      <div class="eq-type">'+ptypeDisplay+'</div>'
      +'    </div>'
      +'  </div>'
      +'  <span class="eq-badge eq-badge-'+s+'">'
      +'    <span class="bdot bdot-'+s+'"></span>'+STATUS_LABEL[s]
      +'  </span>'
      +'</div>'

      /* IP */
      +'<div class="eq-ip-block">'
      +'  <span class="eq-ip-signal">📡</span>'
      +'  <div>'
      +'    <div class="eq-ip-addr">'+esc(ip)+'</div>'
      +'    <div class="eq-ip-port">Port '+esc(String(port))+'</div>'
      +'  </div>'
      +'</div>'

      /* 게이지 + 사이드 */
      +'<div class="eq-gauge-row">'
      +'  <svg width="88" height="88" viewBox="0 0 88 88" style="flex-shrink:0">'
      +'    <circle class="eq-ring-bg" cx="44" cy="44" r="36"/>'
      +'    <circle id="'+rid+'" class="eq-ring-fg" cx="44" cy="44" r="36"'
      +'      stroke="'+color+'"'
      +'      stroke-dasharray="'+CIRC.toFixed(1)+'"'
      +'      stroke-dashoffset="'+CIRC.toFixed(1)+'"'   /* JS로 animate */
      +'      transform="rotate(-90 44 44)"/>'
      +'    <text x="44" y="39" text-anchor="middle" dominant-baseline="middle"'
      +'      fill="'+color+'" font-size="15" font-weight="700" font-family="Consolas,monospace">'
      +      (ubuf.length ? uptime.toFixed(1) : '?')+'%</text>'
      +'    <text x="44" y="56" text-anchor="middle" dominant-baseline="middle"'
      +'      fill="#A0AEC0" font-size="9">가용률</text>'
      +'  </svg>'
      +'  <div class="eq-side">'
      /* RTT */
      +'    <div>'
      +'      <div class="eq-side-lbl">응답시간</div>'
      +'      <div class="eq-rtt-row">'
      +'        <div class="eq-rtt-bar"><div class="eq-rtt-fill" style="width:'+rttPct+'%;background:'+rttColor+'"></div></div>'
      +'        <span class="eq-rtt-val" style="color:'+rttColor+'">'+rttLabel+'</span>'
      +'      </div>'
      +'    </div>'
      /* 히스토리 */
      +'    <div>'
      +'      <div class="eq-side-lbl">폴링 이력 (최근 '+ubuf.length+'회)</div>'
      +'      <div class="eq-hist">'+histHtml+'</div>'
      +'    </div>'
      +'  </div>'
      +'</div>'

      /* 오류 메시지 */
      +(errStr ? '<div style="font-size:10px;color:var(--red);background:rgba(229,62,62,.06);border-radius:6px;padding:5px 8px;margin-bottom:8px">'+errStr+'</div>' : '')

      /* 푸터 */
      +'<div class="eq-foot">'
      +'  <span>마지막 성공 '+lastStr+'</span>'
      +'  <span style="font-family:monospace">'+esc(id)+'</span>'
      +'</div>'
      +'</div>';
  });

  document.getElementById('equipGrid').innerHTML = html;
  updateSummary(cnt);
  document.getElementById('subTitle').textContent = '등록된 PLC '+plcList.length+'대 실시간 현황';
  document.getElementById('lastUpdate').textContent = '최종 갱신: '+fmtTime(new Date());

  /* 링 게이지 애니메이션 */
  setTimeout(function(){
    plcList.forEach(function(plc){
      var id   = plc.plcId || plc.plc_id || plc.id;
      var el   = document.getElementById(safeId(id));
      var ubuf = uptimeBuf[id] || [];
      var up   = ubuf.length ? ubuf.reduce(function(a,b){return a+b;},0)/ubuf.length : 0;
      if(el) el.style.strokeDashoffset = (CIRC*(1-up)).toFixed(1);
    });
  }, 60);
}

function updateSummary(cnt){
  document.getElementById('cntOk').textContent    = cnt.ok;
  document.getElementById('cntWarn').textContent  = cnt.warn;
  document.getElementById('cntAlarm').textContent = cnt.alarm;
  document.getElementById('cntOff').textContent   = cnt.off;
}

/* 자동 갱신 */
var refreshTimer = null;
function refreshAll(){
  if(refreshTimer) clearTimeout(refreshTimer);
  pollAll().then(function(){ refreshTimer = setTimeout(refreshAll, 60000); });
}

fetchList().then(function(){
  renderGrid();
  return pollAll();
}).then(function(){
  refreshTimer = setTimeout(refreshAll, 60000);
});
</script>
</body>
</html>
