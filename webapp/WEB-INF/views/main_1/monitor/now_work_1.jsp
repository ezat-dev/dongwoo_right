<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>공정 현황</title>
<style>
  *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

  html, body {
    width: 100%; height: 100%;
    background: #F4F6F9;
    font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
    overflow: hidden;
  }

  .wrap {
    width: 100%; height: 100vh;
    display: flex; flex-direction: column;
    align-items: center; justify-content: center;
    padding: 6vh 6vw;
  }

  .card {
    width: 100%;
    height: 88vh;
    background: #fff;
    border-radius: 10px;
    border: 1px solid #E2E8F0;
    box-shadow: 0 1px 3px rgba(0,0,0,.06), 0 4px 16px rgba(0,0,0,.04);
    overflow: hidden;
    display: flex;
    flex-direction: column;
  }

  table {
    width: 100%;
    height: 100%;
    border-collapse: collapse;
    table-layout: fixed;
  }

  col.c-equip    { width: 9%; }
  col.c-room     { width: 8%; }
  col.c-customer { width: 20%; }
  col.c-product  { width: 20%; }
  col.c-lotno    { width: 16%; }
  col.c-st       { width: 6.6%; }

  th, td {
    text-align: center;
    vertical-align: middle;
    font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
    font-weight: 700;
    border: 1px solid #94A3B8;
  }

  thead tr:first-child th {
    background: #8DC34A;
    color: #1A3A00;
    font-size: clamp(13px, 1.35vw, 24px);
    font-weight: 900;
    letter-spacing: 1px;
    height: 5.5vh;
    border-color: #7AB03A;
  }

  th.th-equip {
    background: #F4956A;
    color: #5A1A00;
  }

  thead tr:last-child th {
    background: #8DC34A;
    color: #1A3A00;
    font-size: clamp(11px, 1.1vw, 19px);
    font-weight: 800;
    height: 4vh;
    border-color: #7AB03A;
    border-bottom: 1px solid #6FAA2C;
  }

  td.equip {
    background: #EEF2F7;
    color: #1E293B;
    font-size: clamp(12px, 1.2vw, 21px);
    font-weight: 900;
    line-height: 1.8;
    border-color: #94A3B8;
  }

  td.room {
    background: #EEF2F7;
    color: #475569;
    font-size: clamp(11px, 1.1vw, 19px);
    font-weight: 800;
    border-color: #94A3B8;
  }

  td.data {
    background: #F8FAFC;
    color: #1E293B;
    font-size: clamp(11px, 1.15vw, 20px);
    font-weight: 700;
    border-color: #94A3B8;
  }

  td.st {
    background: #D4EDBA;
    border-color: #86B84A;
  }
  td.st.on {
    background: #8DC34A;
    border-color: #6FAA2C;
  }
  td.st.active {
    background: #559df9;
    border-color: #3a85e8;
  }

  tr.sep td { border-top: 2px solid #64748B !important; }

  tbody tr { height: auto; }
</style>
</head>
<body>
<div class="wrap">
  <div class="card">
    <table id="workTable">
      <colgroup>
        <col class="c-equip"><col class="c-room">
        <col class="c-customer"><col class="c-product"><col class="c-lotno">
        <col class="c-st"><col class="c-st"><col class="c-st"><col class="c-st"><col class="c-st">
      </colgroup>
      <thead>
        <tr>
          <th class="th-equip" rowspan="2" colspan="2">설 비 명</th>
          <th rowspan="2">고 객 사</th>
          <th rowspan="2">품 명</th>
          <th rowspan="2">LOT NO</th>
          <th colspan="5">공 정 현 황</th>
        </tr>
        <tr>
          <th>승온</th><th>본처리</th><th>강온</th><th>냉각</th><th>공로</th>
        </tr>
      </thead>
      <tbody>
        <!-- 침탄 1호 -->
        <tr class="sep" data-equip-cd="dongwoo_01" data-row-sort="1">
          <td class="equip" colspan="2">침탄 1호</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st" data-tags="bcf1_96"></td>
          <td class="st" data-tags="bcf1_97"></td>
          <td class="st" data-tags="bcf1_98"></td>
          <td class="st" data-tags="bcf1_51"></td>
          <td class="st" data-tags="bcf1_50,bcf1_51" data-logic="alloff"></td>
        </tr>
        <!-- 침탄 2호 -->
        <tr data-equip-cd="dongwoo_02" data-row-sort="1">
          <td class="equip" colspan="2">침탄 2호</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st" data-tags="bcf2_96"></td>
          <td class="st" data-tags="bcf2_97"></td>
          <td class="st" data-tags="bcf2_98"></td>
          <td class="st" data-tags="bcf2_51"></td>
          <td class="st" data-tags="bcf2_96,bcf2_97,bcf2_98,bcf2_51" data-logic="alloff"></td>
        </tr>
        <!-- 침탄 3호 -->
        <tr data-equip-cd="dongwoo_03" data-row-sort="1">
          <td class="equip" colspan="2">침탄 3호</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st" data-tags="bcf3_96"></td>
          <td class="st" data-tags="bcf3_97"></td>
          <td class="st" data-tags="bcf3_98"></td>
          <td class="st" data-tags="bcf3_51"></td>
          <td class="st" data-tags="bcf3_96,bcf3_97,bcf3_98,bcf3_51" data-logic="alloff"></td>
        </tr>
        <!-- 침탄 4호 -->
        <tr data-equip-cd="dongwoo_04" data-row-sort="1">
          <td class="equip" colspan="2">침탄 4호</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st" data-tags="bcf4_96"></td>
          <td class="st" data-tags="bcf4_97"></td>
          <td class="st" data-tags="bcf4_98"></td>
          <td class="st" data-tags="bcf4_51"></td>
          <td class="st" data-tags="bcf4_50,bcf4_51" data-logic="alloff"></td>
        </tr>
        <!-- 침탄 5호 -->
        <tr data-equip-cd="dongwoo_05" data-row-sort="1">
          <td class="equip" colspan="2">침탄 5호</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st" data-tags="bcf5_98"></td>
          <td class="st" data-tags="bcf5_99"></td>
          <td class="st" data-tags="bcf5_100"></td>
          <td class="st" data-tags="bcf5_54"></td>
          <td class="st" data-tags="bcf5_53,bcf5_54" data-logic="alloff"></td>
        </tr>

        <!-- 침탄 7호 -->
        <tr class="sep" data-equip-cd="dongwoo_07" data-row-sort="1">
          <td class="equip" rowspan="2">침탄 7호</td>
          <td class="room">본처리실</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st" data-tags="bcf7_272,bcf7_273,bcf7_274,bcf7_275"></td>
          <td class="st" data-tags="bcf7_276,bcf7_277,bcf7_278"></td>
          <td class="st" data-tags="bcf7_279"></td>
          <td class="st"></td>
          <td class="st" data-tags="bcf7_144" data-logic="alloff"></td>
        </tr>
        <tr data-equip-cd="dongwoo_07" data-row-sort="2">
          <td class="room">냉각실</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st"></td>
          <td class="st"></td>
          <td class="st"></td>
          <td class="st" data-tags="bcf7_145"></td>
          <td class="st" data-tags="bcf7_145" data-logic="alloff"></td>
        </tr>

        <!-- 침탄 8호 -->
        <tr class="sep" data-equip-cd="dongwoo_08" data-row-sort="1">
          <td class="equip" rowspan="2">침탄 8호</td>
          <td class="room">본처리실</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st" data-tags="bcf8_164"></td>
          <td class="st" data-tags="bcf8_165"></td>
          <td class="st" data-tags="bcf8_166"></td>
          <td class="st"></td>
          <td class="st" data-tags="bcf8_116" data-logic="alloff"></td>
        </tr>
        <tr data-equip-cd="dongwoo_08" data-row-sort="2">
          <td class="room">냉각실</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st"></td>
          <td class="st"></td>
          <td class="st"></td>
          <td class="st" data-tags="bcf8_117"></td>
          <td class="st" data-tags="bcf8_117" data-logic="alloff"></td>
        </tr>

        <!-- 침탄 9호 -->
        <tr class="sep" data-equip-cd="dongwoo_09" data-row-sort="1">
          <td class="equip" rowspan="2">침탄 9호</td>
          <td class="room">본처리실</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st" data-tags="bcf9_272,bcf9_273,bcf9_274,bcf9_275"></td>
          <td class="st" data-tags="bcf9_276,bcf9_277,bcf9_278"></td>
          <td class="st" data-tags="bcf9_279"></td>
          <td class="st"></td>
          <td class="st" data-tags="bcf9_144" data-logic="alloff"></td>
        </tr>
        <tr data-equip-cd="dongwoo_09" data-row-sort="2">
          <td class="room">냉각실</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st"></td>
          <td class="st"></td>
          <td class="st"></td>
          <td class="st" data-tags="bcf9_145"></td>
          <td class="st" data-tags="bcf9_145" data-logic="alloff"></td>
        </tr>

        <!-- 침탄 10호 -->
        <tr class="sep" data-equip-cd="dongwoo_10" data-row-sort="1">
          <td class="equip" colspan="2">침탄 10호</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st" data-tags="bcf10_98"></td>
          <td class="st" data-tags="bcf10_99"></td>
          <td class="st" data-tags="bcf10_100"></td>
          <td class="st" data-tags="bcf10_54"></td>
          <td class="st" data-tags="bcf10_53,bcf10_54" data-logic="alloff"></td>
        </tr>
        <!-- 침탄 12호 -->
        <tr data-equip-cd="dongwoo_12" data-row-sort="1">
          <td class="equip" colspan="2">침탄 12호</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st" data-tags="bcf12_L0301"></td>
          <td class="st" data-tags="bcf12_L0302,bcf12_L0303,bcf12_L0304,bcf12_L0305"></td>
          <td class="st" data-tags="bcf12_L0306"></td>
          <td class="st" data-tags="bcf12_Y119H"></td>
          <td class="st new_st" data-tags="bcf12_L0301,bcf12_L0302,bcf12_L0303,bcf12_L0304,bcf12_L0305,bcf12_L0306,bcf12_Y119H" data-logic="alloff"></td>
        </tr>
      </tbody>
    </table>
  </div>
</div>

<script>
  var ROOT = '<%=request.getContextPath()%>';

  function fit() {
    var tbl  = document.getElementById('workTable');
    var rows = tbl.querySelectorAll('tbody tr');
    var card = tbl.closest('.card');
    var theadH = tbl.querySelector('thead').offsetHeight;
    var rowH   = Math.floor((card.clientHeight - theadH) / rows.length);
    rows.forEach(function(r){ r.style.height = rowH + 'px'; });
  }

  function fetchData() {
    fetch(ROOT + '/monitor/nowWork/list?pageNo=1')
      .then(function(r) { return r.json(); })
      .then(function(items) {
        items.forEach(function(item) {
          var tr = document.querySelector(
            'tr[data-equip-cd="' + item.equipCd + '"][data-row-sort="' + item.rowSort + '"]'
          );
          if (!tr) return;
          tr.querySelector('[data-col="cust"]').textContent = item.custNm || '';
          tr.querySelector('[data-col="prod"]').textContent = item.prodNm || '';
          tr.querySelector('[data-col="lot"]').textContent  = item.lotNo  || '';
        });
      })
      .catch(function(e) { console.error('nowWork fetch error', e); });
  }

  fit();
  fetchData();
  window.addEventListener('resize', fit);
  document.querySelectorAll('td.st[data-tags]').forEach(function(td) {
    td.title = td.getAttribute('data-tags').replace(/,/g, '\n');
  });
  setInterval(fetchData, 5000);

  /* PLC 공정현황 상태 — 스냅샷 캐시 폴링 */
  var plcBusy = false;

  function fetchPlcStatus() {
    if (plcBusy) return;
    plcBusy = true;
    fetch(ROOT + '/monitor/snapshot')
    .then(function(r) { return r.ok ? r.json() : Promise.reject(r.status); })
    .then(function(data) {
      var changed  = [];
      var equipMap = {};

      document.querySelectorAll('td.st[data-tags]').forEach(function(td) {
        var tags    = td.getAttribute('data-tags').split(',').map(function(t){ return t.trim(); });
        var logic   = td.getAttribute('data-logic');
        var wasOn   = td.classList.contains('active');
        // alloff: 태그 전부 0일 때만 활성 (공로 - 로 비어있을 때)
        // 기본:   태그 하나라도 1이면 활성
        var isActive = (logic === 'alloff')
          ? tags.every(function(t){ return data[t] == 0; })
          : (logic === 'allon')
          ? tags.every(function(t){ return data[t] == 1; })
          : tags.some(function(t){ return data[t] == 1; });
        var tr      = td.closest('tr');
        var equip   = tr ? (tr.getAttribute('data-equip-cd') || '?') : '?';
        var rowSort = tr ? (tr.getAttribute('data-row-sort') || '1') : '1';
        var key     = equip + (rowSort !== '1' ? '[' + rowSort + ']' : '');

        if (!equipMap[key]) equipMap[key] = [];
        equipMap[key].push(tags.join('+') + (isActive ? '=●ON' : '=○'));

        if (isActive !== wasOn) {
          changed.push('[' + key + '] ' + tags.join('+') + ' ' + (isActive ? 'OFF→ON' : 'ON→OFF'));
        }
        td.classList.toggle('active', isActive);
      });

      var ts    = new Date().toLocaleTimeString('ko-KR', {hour12: false});
      var lines = ['[NowWork1 ' + ts + '] 공정현황 비트 상태'];
      Object.keys(equipMap).forEach(function(k) {
        lines.push('  ' + k + ' │ ' + equipMap[k].join('  '));
      });
      if (changed.length) {
        lines.push('  ▶ 변경 ' + changed.length + '건: ' + changed.join(' / '));
      }
      console.log(lines.join('\n'));
    })
    .catch(function(e) { console.warn('[NowWork1] 스냅샷 fetch 실패:', e); })
    .finally(function() { plcBusy = false; });
  }

  fetchPlcStatus();
  setInterval(fetchPlcStatus, 3000);
</script>
</body>
</html>
