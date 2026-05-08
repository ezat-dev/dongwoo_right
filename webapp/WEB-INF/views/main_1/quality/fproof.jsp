<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common_style.jsp" %>
<style>
.fp-category-tab { display:flex; gap:6px; margin-bottom:16px; flex-wrap:wrap; }
.fp-tab {
  padding:6px 18px; border-radius:8px; border:1px solid var(--border);
  background:var(--white); font-size:12px; font-weight:600;
  cursor:pointer; transition:all .13s; color:var(--muted);
}
.fp-tab.active { background:var(--primary); color:#fff; border-color:var(--primary); }
.risk-high   { color:var(--red);    font-weight:700; }
.risk-mid    { color:var(--orange); font-weight:700; }
.risk-low    { color:var(--green);  font-weight:700; }
.score-bar-bg { display:inline-block; width:80px; height:8px; background:var(--bg); border-radius:4px; overflow:hidden; vertical-align:middle; margin-right:6px; }
.score-bar-fill { height:100%; border-radius:4px; }
</style>
<body>
<div class="page-wrap">
  <div class="page-header">
    <div>
      <div class="page-title">F/PROOF (방호등급)</div>
      <div class="page-sub">Fool Proof — 설비별 안전 방호 등급 및 이행 현황</div>
    </div>
    <button class="btn-primary">📥 엑셀 다운로드</button>
  </div>

  <div class="fp-category-tab">
    <button class="fp-tab active" onclick="showFp('all',this)">전체</button>
    <button class="fp-tab" onclick="showFp('A',this)">A등급 (위험)</button>
    <button class="fp-tab" onclick="showFp('B',this)">B등급 (주의)</button>
    <button class="fp-tab" onclick="showFp('C',this)">C등급 (관리)</button>
  </div>

  <!-- 요약 카드 -->
  <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-bottom:16px" id="fpSummary"></div>

  <div class="card">
    <div class="card-title">F/PROOF 현황 목록</div>
    <table class="data-table" id="fpTable">
      <thead>
        <tr>
          <th>No</th><th>설비명</th><th>방호항목</th><th>등급</th>
          <th>위험요소</th><th>방호수단</th><th>이행점수</th><th>최근 점검일</th><th>상태</th>
        </tr>
      </thead>
      <tbody id="fpBody"></tbody>
    </table>
  </div>
</div>

<script>
var fpData = [
  {equip:'열처리로 1호기',item:'고온 표면 접촉',grade:'A',risk:'화상',measure:'인터록·경고등',score:95,lastChk:'2026-03-28',ok:true},
  {equip:'열처리로 1호기',item:'분위기 가스 누출',grade:'A',risk:'폭발·질식',measure:'가스감지기',score:88,lastChk:'2026-03-28',ok:true},
  {equip:'열처리로 2호기',item:'도어 오작동',grade:'A',risk:'끼임',measure:'안전 센서',score:72,lastChk:'2026-03-15',ok:false},
  {equip:'열처리로 3호기',item:'전기 감전',grade:'A',risk:'감전',measure:'차단기·접지',score:91,lastChk:'2026-03-28',ok:true},
  {equip:'냉각장치 2호기',item:'과압 방출',grade:'B',risk:'누수·파열',measure:'안전밸브',score:65,lastChk:'2026-02-20',ok:false},
  {equip:'냉각장치 1호기',item:'냉각수 부족',grade:'B',risk:'설비 손상',measure:'수위 경보',score:82,lastChk:'2026-03-10',ok:true},
  {equip:'컨베이어 1호기',item:'협착 방지',grade:'A',risk:'끼임',measure:'비상정지·가드',score:90,lastChk:'2026-03-25',ok:true},
  {equip:'세척기 2호기',  item:'약품 비산',grade:'B',risk:'화학 화상',measure:'방호덮개·보호구',score:78,lastChk:'2026-03-01',ok:false},
  {equip:'프레스 1호기',  item:'금형 끼임',grade:'A',risk:'절단',measure:'양수조작·광전센서',score:97,lastChk:'2026-03-28',ok:true},
  {equip:'세척기 1호기',  item:'온도 이상',grade:'C',risk:'화상',measure:'온도센서 경보',score:85,lastChk:'2026-03-20',ok:true},
];

function renderFp(filter){
  var data = filter==='all' ? fpData : fpData.filter(function(r){ return r.grade===filter; });
  var cntA=0,cntB=0,cntC=0,cntNg=0;
  fpData.forEach(function(r){ if(r.grade==='A')cntA++; if(r.grade==='B')cntB++; if(r.grade==='C')cntC++; if(!r.ok)cntNg++; });

  document.getElementById('fpSummary').innerHTML =
    sumCard('A등급 (위험)', cntA, 'var(--red)', '#FFF5F5') +
    sumCard('B등급 (주의)', cntB, 'var(--orange)', '#FFFAF0') +
    sumCard('C등급 (관리)', cntC, 'var(--green)', '#F0FFF4') +
    sumCard('미이행 항목', cntNg, 'var(--purple)', '#FAF5FF');

  var html='';
  data.forEach(function(r,i){
    var rCls = r.grade==='A'?'risk-high':r.grade==='B'?'risk-mid':'risk-low';
    var pct = r.score;
    var barColor = pct>=90?'var(--green)':pct>=70?'var(--orange)':'var(--red)';
    html+='<tr>'
        +'<td>'+(i+1)+'</td><td>'+r.equip+'</td><td style="font-weight:600">'+r.item+'</td>'
        +'<td><span class="'+rCls+'">'+r.grade+'등급</span></td>'
        +'<td>'+r.risk+'</td><td>'+r.measure+'</td>'
        +'<td><span class="score-bar-bg"><span class="score-bar-fill" style="width:'+pct+'%;background:'+barColor+'"></span></span>'+pct+'점</td>'
        +'<td>'+r.lastChk+'</td>'
        +'<td><span class="badge '+(r.ok?'badge-ok':'badge-alarm')+'">'+(r.ok?'이행':'미이행')+'</span></td>'
        +'</tr>';
  });
  document.getElementById('fpBody').innerHTML = html;
}

function sumCard(label, cnt, color, bg){
  return '<div style="background:'+bg+';border:1px solid var(--border);border-radius:10px;padding:14px 16px;text-align:center">'
       + '<div style="font-size:11px;color:var(--muted);margin-bottom:6px">'+label+'</div>'
       + '<div style="font-size:24px;font-weight:800;color:'+color+'">'+cnt+'</div>'
       + '</div>';
}

function showFp(filter, btn){
  document.querySelectorAll('.fp-tab').forEach(function(b){ b.classList.remove('active'); });
  btn.classList.add('active');
  renderFp(filter);
}
renderFp('all');
</script>
</body></html>
