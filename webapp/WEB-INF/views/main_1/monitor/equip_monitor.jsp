<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common_style.jsp" %>
<style>
*{box-sizing:border-box;margin:0;padding:0}
body,button,input,select,textarea{font-family:'Malgun Gothic','맑은 고딕','Noto Sans KR',sans-serif;}

.equip-grid{display:grid;grid-template-columns:repeat(5,1fr);gap:10px;}

/* 카드 */
.equip-card{
  background:var(--white);border:1px solid var(--border);border-radius:10px;
  padding:13px 12px 11px;position:relative;overflow:hidden;
  transition:box-shadow .2s,transform .15s;cursor:default;
  animation:fadeUp .4s ease both;
}
.equip-card:hover{box-shadow:0 4px 16px rgba(0,0,0,.07);transform:translateY(-1px);}

/* 상단 컬러 스트라이프 */
.equip-card::before{
  content:'';position:absolute;top:0;left:0;right:0;height:3px;
  border-radius:10px 10px 0 0;
}
.equip-card.status-ok::before    {background:#16a34a;}
.equip-card.status-warn::before  {background:#d97706;}
.equip-card.status-alarm::before {background:#dc2626;}
.equip-card.status-off::before   {background:#d1d5db;}

/* 카드 진입 애니메이션 */
@keyframes fadeUp{from{opacity:0;transform:translateY(10px)}to{opacity:1;transform:translateY(0)}}
.equip-card:nth-child(1){animation-delay:.03s}.equip-card:nth-child(2){animation-delay:.06s}
.equip-card:nth-child(3){animation-delay:.09s}.equip-card:nth-child(4){animation-delay:.12s}
.equip-card:nth-child(5){animation-delay:.15s}.equip-card:nth-child(6){animation-delay:.18s}
.equip-card:nth-child(7){animation-delay:.21s}.equip-card:nth-child(8){animation-delay:.24s}
.equip-card:nth-child(9){animation-delay:.27s}.equip-card:nth-child(10){animation-delay:.30s}
.equip-card:nth-child(11){animation-delay:.33s}.equip-card:nth-child(12){animation-delay:.36s}
.equip-card:nth-child(13){animation-delay:.39s}

/* 상단 행: ID + 배지 */
.eq-row1{display:flex;align-items:center;justify-content:space-between;margin-bottom:7px;}
.eq-id{font-size:10px;color:#c0c8d8;font-family:monospace;letter-spacing:.8px;}

/* 상태 배지 */
.eq-badge{
  display:inline-flex;align-items:center;gap:3px;flex-shrink:0;
  padding:2px 8px;border-radius:4px;font-size:10px;font-weight:700;border:1px solid;letter-spacing:.3px;
}
.eq-badge-ok    {background:#f0fdf4;color:#15803d;border-color:#bbf7d0;}
.eq-badge-warn  {background:#fffbeb;color:#b45309;border-color:#fde68a;}
.eq-badge-alarm {background:#fef2f2;color:#b91c1c;border-color:#fecaca;}
.eq-badge-off   {background:#f9fafb;color:#9ca3af;border-color:#e5e7eb;}

/* 배지 점 */
.bdot{width:4px;height:4px;border-radius:50%;flex-shrink:0;}
.bdot-ok    {background:#16a34a;animation:pulse-ok    1.5s ease-in-out infinite;}
.bdot-alarm {background:#dc2626;animation:pulse-alarm  .9s ease-in-out infinite;}
.bdot-warn  {background:#d97706;animation:pulse-warn  1.2s ease-in-out infinite;}
.bdot-off   {background:#d1d5db;}
@keyframes pulse-ok   {0%,100%{opacity:1;box-shadow:0 0 0 0 rgba(22,163,74,.5)} 50%{opacity:.5;box-shadow:0 0 0 3px rgba(22,163,74,0)}}
@keyframes pulse-alarm{0%,100%{opacity:1;box-shadow:0 0 0 0 rgba(220,38,38,.6)} 50%{opacity:.3;box-shadow:0 0 0 4px rgba(220,38,38,0)}}
@keyframes pulse-warn {0%,100%{opacity:1;box-shadow:0 0 0 0 rgba(217,119,6,.5)} 50%{opacity:.4;box-shadow:0 0 0 3px rgba(217,119,6,0)}}

/* 장비명 + 타입 */
.eq-name{font-size:14px;font-weight:700;color:var(--text);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;margin-bottom:2px;}
.eq-type{font-size:10px;color:#374151;font-weight:500;margin-bottom:9px;letter-spacing:.3px;}

/* IP 블록 */
.eq-ip-block{
  display:flex;align-items:center;gap:5px;
  background:var(--bg);border-radius:6px;padding:7px 10px;
  margin-bottom:9px;border:1px solid var(--border);
}
.eq-ip-addr{font-size:13px;font-weight:700;color:var(--text);font-family:'Consolas','Courier New',monospace;letter-spacing:.3px;}
.eq-ip-port{font-size:11px;color:#374151;font-family:monospace;font-weight:600;}

/* 미터 2칸 */
.eq-meters{display:grid;grid-template-columns:1fr 1fr;gap:5px;margin-bottom:8px;}
.eq-meter{background:var(--bg);border-radius:6px;padding:7px 8px;border:1px solid var(--border);}
.eq-meter-val{font-size:14px;font-weight:700;font-family:monospace;line-height:1;}
.eq-meter-lbl{font-size:9px;color:#374151;font-weight:600;margin-top:2px;letter-spacing:.3px;text-transform:uppercase;}
.eq-meter-bar{height:3px;background:var(--border);border-radius:2px;margin-top:5px;overflow:hidden;}
.eq-meter-fill{height:100%;border-radius:2px;transition:width 1s ease;}

/* 폴링 히스토리 */
.eq-hist-lbl{font-size:9px;color:#374151;font-weight:600;letter-spacing:.3px;text-transform:uppercase;margin-bottom:4px;}
.eq-hist{display:flex;gap:2px;}
.eq-hb{flex:1;height:6px;border-radius:1px;}

/* 오류 메시지 */
.eq-err{
  font-size:10px;color:#b91c1c;
  background:rgba(220,38,38,.06);border-radius:5px;
  padding:5px 8px;margin-bottom:7px;
  border-left:2px solid rgba(220,38,38,.3);
}

/* 카드 푸터 */
.eq-foot{
  display:flex;align-items:center;justify-content:space-between;
  padding-top:8px;border-top:1px solid var(--border);
  font-size:10px;color:#374151;
}

/* 요약 칩 */
.summary-bar{display:grid;grid-template-columns:repeat(4,1fr);gap:8px;margin-bottom:16px;}
.summary-chip{
  display:flex;align-items:center;gap:10px;padding:10px 14px;
  background:var(--white);border:1px solid var(--border);border-radius:10px;
  transition:transform .2s,box-shadow .2s;cursor:default;
}
.summary-chip:hover{transform:translateY(-1px);box-shadow:0 4px 12px rgba(0,0,0,.06);}
.chip-icon{width:30px;height:30px;border-radius:7px;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:14px;}
.chip-num{font-size:20px;font-weight:800;line-height:1;}
.chip-lbl{font-size:11px;color:#374151;font-weight:500;margin-top:2px;}

/* LIVE 배지 */
.live-badge{
  display:inline-flex;align-items:center;gap:5px;
  padding:4px 10px;background:var(--white);border:1px solid var(--border);border-radius:6px;
}
.live-dot{width:6px;height:6px;border-radius:50%;background:#16a34a;animation:livepulse 1.5s ease-in-out infinite;}
@keyframes livepulse{0%,100%{opacity:1}50%{opacity:.3}}
.live-text{font-size:10px;color:#374151;font-weight:600;letter-spacing:.5px;}

/* 새로고침 버튼 스핀 */
.spin-icon{display:inline-block;}
.btn-spinning .spin-icon{animation:spin360 .7s linear;}
@keyframes spin360{to{transform:rotate(360deg);}}

.err-card{grid-column:1/-1;text-align:center;padding:60px;color:#374151;font-size:13px;}
</style>
<body>
<div class="page-wrap">
  <div class="page-header">
    <div>
      <div class="page-title">통신 모니터링</div>
      <div class="page-sub" id="subTitle">PLC 목록 로딩 중…</div>
    </div>
    <div style="display:flex;gap:8px;align-items:center">
      <div class="live-badge">
        <div class="live-dot"></div>
        <span class="live-text">LIVE</span>
      </div>
      <span style="font-size:11px;color:#374151" id="lastUpdate"></span>
      <button class="btn-primary" id="refreshBtn" onclick="doRefresh()">
        <span class="spin-icon">↺</span> 새로고침
      </button>
    </div>
  </div>

  <div class="summary-bar">
    <div class="summary-chip">
      <div class="chip-icon" style="background:#f0fdf4">✅</div>
      <div><div class="chip-num" style="color:#16a34a" id="cntOk">0</div><div class="chip-lbl">정상</div></div>
    </div>
    <div class="summary-chip">
      <div class="chip-icon" style="background:#fffbeb">⚠️</div>
      <div><div class="chip-num" style="color:#d97706" id="cntWarn">0</div><div class="chip-lbl">경고</div></div>
    </div>
    <div class="summary-chip">
      <div class="chip-icon" style="background:#fef2f2">🚨</div>
      <div><div class="chip-num" style="color:#dc2626" id="cntAlarm">0</div><div class="chip-lbl">오류</div></div>
    </div>
    <div class="summary-chip">
      <div class="chip-icon" style="background:#f9fafb">💤</div>
      <div><div class="chip-num" style="color:#9ca3af" id="cntOff">0</div><div class="chip-lbl">오프라인</div></div>
    </div>
  </div>

  <div class="equip-grid" id="equipGrid">
    <div class="err-card">PLC 목록을 불러오는 중…</div>
  </div>
</div>

<script>
var base      = '${pageContext.request.contextPath}';
var plcList   = [];
var plcState  = {};
var uptimeBuf = {};
var rttBuf    = {};

var STATUS_LABEL = { ok:'정상', warn:'경고', alarm:'오류', off:'오프라인' };
var STATUS_COLOR = { ok:'#16a34a', warn:'#d97706', alarm:'#dc2626', off:'#d1d5db' };
var TYPE_ICON    = { LS:'🔵', MITSUBISHI:'🔴', MODBUS_TCP:'🟠', MODBUSTCP:'🟠', LSELECTRIC:'🔵' };

function esc(s){ return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }
function fmtTime(d){ return [d.getHours(),d.getMinutes(),d.getSeconds()].map(function(n){return String(n).padStart(2,'0');}).join(':'); }
function iconFor(t){ return TYPE_ICON[(t||'').toUpperCase().replace(/[\s\-]/g,'_')] || '⚙️'; }

function fetchList(){
  return fetch(base+'/plc/dblist')
    .then(function(r){ return r.json(); })
    .then(function(d){ if(d && d.data) plcList = d.data; })
    .catch(function(){ plcList = []; });
}

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
        var id = plc.plcId || plc.plc_id || plc.id;
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
    .catch(function(){
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

function renderGrid(){
  if(!plcList.length){
    document.getElementById('equipGrid').innerHTML='<div class="err-card">등록된 PLC가 없습니다.</div>';
    updateSummary({ok:0,warn:0,alarm:0,off:0});
    document.getElementById('subTitle').textContent='PLC 0대 등록됨';
    return;
  }

  var cnt={ok:0,warn:0,alarm:0,off:0}, html='';

  plcList.forEach(function(plc){
    var id    = plc.plcId || plc.plc_id || plc.id;
    var label = plc.label || id;
    var ip    = plc.ip   || '–';
    var port  = plc.port || 502;
    var ptype = (plc.plcType || '').toUpperCase().replace(/[\s\-]/g,'_');
    var icon  = iconFor(ptype);
    var ptypeDisplay = (plc.plcType||'').replace(/_/g,' ');

    var st = plcState[id] || {status:'off',error:'폴링 대기',rtt:null};
    var s  = (st.status in cnt) ? st.status : 'off';
    cnt[s]++;

    var color = STATUS_COLOR[s];

    var ubuf   = uptimeBuf[id] || [];
    var uptime = ubuf.length ? ubuf.reduce(function(a,b){return a+b;},0)/ubuf.length*100 : 0;

    var rtt      = st.rtt;
    var rttColor = !rtt ? '#9ca3af' : rtt<50 ? '#16a34a' : rtt<200 ? '#d97706' : '#dc2626';
    var rttPct   = !rtt ? 0 : Math.min(rtt/300*100,100).toFixed(1);
    var rttLabel = rtt!=null ? rtt+'ms' : '–';

    var histHtml='';
    if(ubuf.length){
      ubuf.forEach(function(v){
        histHtml+='<div class="eq-hb" style="background:'+(v ? color+'55' : '#e5e7eb')+'" title="'+(v?'성공':'실패')+'"></div>';
      });
    } else {
      histHtml='<span style="font-size:9px;color:#374151">대기 중…</span>';
    }

    var lastStr = st.lastOk ? fmtTime(st.lastOk) : '–';
    var errStr  = (s!=='ok' && st.error) ? esc(st.error) : '';

    html +=
      '<div class="equip-card status-'+s+'">'

      /* ID + 배지 */
      +'<div class="eq-row1">'
      +'<span class="eq-id">'+esc(id)+'</span>'
      +'<span class="eq-badge eq-badge-'+s+'">'
      +'<span class="bdot bdot-'+s+'"></span>'+STATUS_LABEL[s]
      +'</span></div>'

      /* 장비명 */
      +'<div class="eq-name" title="'+esc(label)+'">'+icon+' '+esc(label)+'</div>'
      +'<div class="eq-type">'+esc(ptypeDisplay)+'</div>'

      /* IP */
      +'<div class="eq-ip-block">'
      +'<span class="eq-ip-addr">'+esc(ip)+'</span>'
      +'<span class="eq-ip-port">:'+esc(String(port))+'</span>'
      +'</div>'

      /* RTT + 가용률 미터 */
      +'<div class="eq-meters">'
      +'<div class="eq-meter">'
      +'<div class="eq-meter-val" style="color:'+rttColor+'">'+rttLabel+'</div>'
      +'<div class="eq-meter-lbl">응답시간</div>'
      +'<div class="eq-meter-bar"><div class="eq-meter-fill" style="width:'+rttPct+'%;background:'+rttColor+'"></div></div>'
      +'</div>'
      +'<div class="eq-meter">'
      +'<div class="eq-meter-val" style="color:'+color+'">'+(ubuf.length ? uptime.toFixed(1)+'%' : '–')+'</div>'
      +'<div class="eq-meter-lbl">가용률</div>'
      +'<div class="eq-meter-bar"><div class="eq-meter-fill" style="width:'+(ubuf.length?uptime:0)+'%;background:'+color+'"></div></div>'
      +'</div></div>'

      /* 히스토리 */
      +'<div class="eq-hist-lbl">폴링 이력 (최근 '+ubuf.length+'회)</div>'
      +'<div class="eq-hist">'+histHtml+'</div>'

      /* 오류 */
      +(errStr ? '<div class="eq-err" style="margin-top:7px">'+errStr+'</div>' : '')

      /* 푸터 */
      +'<div class="eq-foot" style="margin-top:8px">'
      +'<span>마지막 성공 '+lastStr+'</span>'
      +'</div></div>';
  });

  document.getElementById('equipGrid').innerHTML = html;
  updateSummary(cnt);
  document.getElementById('subTitle').textContent = '등록된 PLC '+plcList.length+'대 실시간 현황';
  document.getElementById('lastUpdate').textContent = '최종 갱신: '+fmtTime(new Date());
}

function updateSummary(cnt){
  document.getElementById('cntOk').textContent    = cnt.ok;
  document.getElementById('cntWarn').textContent  = cnt.warn;
  document.getElementById('cntAlarm').textContent = cnt.alarm;
  document.getElementById('cntOff').textContent   = cnt.off;
}

var refreshTimer = null;
function doRefresh(){
  var btn = document.getElementById('refreshBtn');
  btn.classList.add('btn-spinning');
  setTimeout(function(){ btn.classList.remove('btn-spinning'); }, 700);
  clearTimeout(refreshTimer);
  pollAll().then(function(){ refreshTimer = setTimeout(doRefresh, 60000); });
}

fetchList().then(function(){
  renderGrid();
  return pollAll();
}).then(function(){
  refreshTimer = setTimeout(doRefresh, 60000);
});
</script>
</body>
</html>
