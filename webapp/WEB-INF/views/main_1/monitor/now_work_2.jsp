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
  col.c-customer { width: 14%; }
  col.c-product  { width: 18%; }
  col.c-lotno    { width: 18%; }
  col.c-st       { width: 6.6%; }

  th, td {
    text-align: center;
    vertical-align: middle;
    font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
    font-weight: 700;
    border: 1px solid #E8ECF0;
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
    border-color: #E2E8F0;
  }

  td.room {
    background: #EEF2F7;
    color: #475569;
    font-size: clamp(11px, 1.1vw, 19px);
    font-weight: 800;
    border-color: #E8ECF0;
  }

  td.data {
    background: #F8FAFC;
    color: #1E293B;
    font-size: clamp(11px, 1.15vw, 20px);
    font-weight: 700;
    border-color: #EEF1F5;
  }

  td.st {
    background: #D4EDBA;
    border-color: #BCDDA0;
  }
  td.st.on {
    background: #8DC34A;
    border-color: #6FAA2C;
  }

  tr.sep td { border-top: 2px solid #CBD5E1 !important; }

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
        <!-- 침탄 6호 -->
        <tr class="sep" data-equip-cd="dongwoo_06" data-row-sort="1">
          <td class="equip" rowspan="7">침탄 6호<br>(S-TKM)</td>
          <td class="room">예열실</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st"></td><td class="st"></td><td class="st"></td><td class="st"></td><td class="st"></td>
        </tr>
        <tr data-equip-cd="dongwoo_06" data-row-sort="2">
          <td class="room">가열실</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st"></td><td class="st"></td><td class="st"></td><td class="st"></td><td class="st"></td>
        </tr>
        <tr data-equip-cd="dongwoo_06" data-row-sort="3">
          <td class="room">침탄1실</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st"></td><td class="st"></td><td class="st"></td><td class="st"></td><td class="st"></td>
        </tr>
        <tr data-equip-cd="dongwoo_06" data-row-sort="4">
          <td class="room">침탄2실</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st"></td><td class="st"></td><td class="st"></td><td class="st"></td><td class="st"></td>
        </tr>
        <tr data-equip-cd="dongwoo_06" data-row-sort="5">
          <td class="room">침탄3실</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st"></td><td class="st"></td><td class="st"></td><td class="st"></td><td class="st"></td>
        </tr>
        <tr data-equip-cd="dongwoo_06" data-row-sort="6">
          <td class="room">강온실</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st"></td><td class="st"></td><td class="st"></td><td class="st"></td><td class="st"></td>
        </tr>
        <tr data-equip-cd="dongwoo_06" data-row-sort="7">
          <td class="room">냉각실</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st"></td><td class="st"></td><td class="st"></td><td class="st"></td><td class="st"></td>
        </tr>

        <!-- 침탄 11호 -->
        <tr class="sep" data-equip-cd="dongwoo_11" data-row-sort="1">
          <td class="equip" rowspan="3">침탄 11호<br>(2실형)</td>
          <td class="room">침탄1실</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st"></td><td class="st"></td><td class="st"></td><td class="st"></td><td class="st"></td>
        </tr>
        <tr data-equip-cd="dongwoo_11" data-row-sort="2">
          <td class="room">침탄2실</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st"></td><td class="st"></td><td class="st"></td><td class="st"></td><td class="st"></td>
        </tr>
        <tr data-equip-cd="dongwoo_11" data-row-sort="3">
          <td class="room">냉각실</td>
          <td class="data" data-col="cust"></td>
          <td class="data" data-col="prod"></td>
          <td class="data" data-col="lot"></td>
          <td class="st"></td><td class="st"></td><td class="st"></td><td class="st"></td><td class="st"></td>
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
    fetch(ROOT + '/monitor/nowWork/list?pageNo=2')
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
  setInterval(fetchData, 5000);
</script>
</body>
</html>
