<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common_style.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script type="text/javascript" src="https://oss.sheetjs.com/sheetjs/xlsx.full.min.js"></script>

<style>
/* ═══════════════════════════════════════════════
   제품등록 전용 스타일 (새 프로젝트 공통 변수 기반)
   ═══════════════════════════════════════════════ */

/* ── 검색 바 ── */
.search-bar {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}
.search-bar label {
  font-size: 12px;
  font-weight: 600;
  color: var(--muted);
  white-space: nowrap;
}
.search-bar input,
.search-bar select {
  height: 32px;
  padding: 0 10px;
  border: 1px solid var(--border);
  border-radius: 8px;
  font-size: 12px;
  background: var(--white);
  color: var(--text);
  transition: border-color .15s;
}
.search-bar input:focus,
.search-bar select:focus {
  outline: none;
  border-color: var(--primary);
  box-shadow: 0 0 0 3px rgba(37,99,235,.08);
}

/* ── 테이블 헤더 필터 높이 ── */
.tabulator .tabulator-col { height: 52px !important; }
.tabulator .tabulator-col .tabulator-col-content {
  height: 100%; display: flex; flex-direction: column; justify-content: space-between;
}

/* ════════════════════════════════
   모달 오버레이
   ════════════════════════════════ */
.modal-overlay {
  display: none; position: fixed;
  top: 0; left: 0; width: 100%; height: 100%;
  background: rgba(0,0,0,0.45); z-index: 999;
}
.modal-overlay.active { display: block; }

/* 거래처·도면 모달 */
#cutumListModal.modal-overlay,
#drawingFileModal.modal-overlay {
  display: flex; align-items: center; justify-content: center;
  z-index: 1100; background: rgba(0,0,0,0.55);
}
#cutumListModal .modal-content,
#drawingFileModal .modal-content {
  background: var(--white); padding: 16px; border-radius: 12px;
  width: 90%; max-width: 1000px; position: relative;
  z-index: 1101; box-shadow: var(--shadow);
}
#cutumListModal .modal-header,
#drawingFileModal .modal-header {
  display: flex; justify-content: space-between; align-items: center;
  font-weight: 700; font-size: 15px;
  margin-bottom: 12px; padding-bottom: 10px;
  border-bottom: 2px solid var(--border);
}
#cutumListModal .modal-close,
#drawingFileModal .modal-close {
  cursor: pointer; font-size: 22px; color: var(--muted); transition: color .2s;
}
#cutumListModal .modal-close:hover,
#drawingFileModal .modal-close:hover { color: var(--red); }

/* ════════════════════════════════
   제품 등록/수정 모달 (메인)
   ════════════════════════════════ */
.product-modal {
  display: none; position: fixed;
  top: 50%; left: 50%;
  transform: translate(-50%, -50%);
  width: 1560px; max-width: 95vw; max-height: 95vh;
  background: var(--white); border-radius: 14px;
  box-shadow: 0 20px 60px rgba(0,0,0,.2);
  z-index: 1000; overflow: hidden;
}
.product-modal.active { display: flex; flex-direction: column; }

/* 모달 헤더 */
.pm-header {
  display: flex; justify-content: space-between; align-items: center;
  padding: 12px 20px;
  background: linear-gradient(135deg, var(--primary), var(--primary-d, #1a56db));
  color: #fff; cursor: move; flex-shrink: 0;
  border-radius: 14px 14px 0 0;
}
.pm-header h2 { margin: 0; font-size: 16px; font-weight: 700; letter-spacing: .3px; }
.pm-close-btn {
  background: rgba(255,255,255,.15); border: none; color: #fff;
  font-size: 22px; cursor: pointer;
  width: 30px; height: 30px;
  display: flex; align-items: center; justify-content: center;
  border-radius: 6px; transition: all .2s;
}
.pm-close-btn:hover { background: rgba(255,255,255,.3); transform: rotate(90deg); }

/* 모달 본문 */
.pm-body {
  flex: 1; overflow-y: auto; overflow-x: hidden;
  background: var(--bg, #f4f6f9);
  padding: 10px;
}
.pm-body::-webkit-scrollbar { width: 5px; }
.pm-body::-webkit-scrollbar-track { background: var(--border); }
.pm-body::-webkit-scrollbar-thumb { background: var(--muted); border-radius: 4px; }

/* 2열 그리드 (좌: 입력 / 우: 이미지) */
.pm-grid {
  display: grid;
  grid-template-columns: 2.5fr 1fr;
  gap: 10px;
  height: 100%;
}
.pm-left, .pm-right {
  display: flex; flex-direction: column; gap: 8px;
}

/* 섹션 카드 */
.pm-section {
  background: var(--white);
  border: 1px solid var(--border);
  border-radius: 10px;
  padding: 10px 14px;
  box-shadow: 0 1px 3px rgba(0,0,0,.04);
}
.pm-section-title {
  margin: 0 0 8px 0;
  font-size: 12px; font-weight: 700; color: var(--primary);
  padding-bottom: 6px;
  border-bottom: 1.5px solid var(--border);
  letter-spacing: .3px;
}

/* 필드 행 */
.pm-row {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 8px;
  margin-bottom: 6px;
}
.pm-row:last-child { margin-bottom: 0; }
.pm-col       { display: flex; flex-direction: column; gap: 3px; }
.pm-col-full  { grid-column: 1/-1; display: flex; flex-direction: column; gap: 3px; }

.pm-col label,
.pm-col-full label {
  font-size: 10px; font-weight: 600; color: var(--muted);
}
.req { color: var(--red); margin-left: 2px; }

/* 입력 공통 */
.pm-col input[type="text"],
.pm-col input[type="date"],
.pm-col input[type="number"],
.pm-col select,
.pm-col-full input[type="text"],
.pm-col-full textarea,
.pm-right textarea {
  width: 100%;
  height: 28px;
  padding: 0 8px;
  border: 1px solid var(--border);
  border-radius: 6px;
  font-size: 11px;
  color: var(--text);
  background: var(--white);
  box-sizing: border-box;
  transition: border-color .15s;
}
.pm-col input:focus, .pm-col select:focus,
.pm-col-full input:focus, .pm-col-full textarea:focus {
  outline: none; border-color: var(--primary);
  box-shadow: 0 0 0 3px rgba(37,99,235,.08);
}
.pm-col select {
  cursor: pointer; appearance: none;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='10' height='10' viewBox='0 0 12 12'%3E%3Cpath fill='%23888' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
  background-repeat: no-repeat; background-position: right 8px center; padding-right: 24px;
}
textarea {
  height: auto !important; min-height: 38px; padding: 6px 8px !important;
  resize: vertical; font-family: inherit; line-height: 1.4;
}

/* 검색 버튼 포함 입력 */
.input-with-btn { display: flex; gap: 4px; }
.input-with-btn input { flex: 1; }
.btn-search {
  padding: 0 10px; border: none; border-radius: 6px;
  background: var(--primary); color: #fff;
  font-size: 11px; font-weight: 600; cursor: pointer; white-space: nowrap;
  transition: background .15s;
}
.btn-search:hover { background: var(--primary-d, #1a56db); }

/* 기호 버튼 */
.input-with-symbols { display: flex; gap: 3px; align-items: center; }
.input-with-symbols input { flex: 1; }
.btn-symbol {
  padding: 2px 7px; border: 1px solid var(--border); border-radius: 5px;
  background: var(--white); font-size: 10px; cursor: pointer; transition: all .15s;
  color: var(--text);
}
.btn-symbol:hover { background: var(--bg); border-color: var(--primary); color: var(--primary); }

/* SPEC 그리드 */
.spec-grid {
  display: grid; grid-template-columns: repeat(2,1fr);
  gap: 8px; margin-bottom: 6px;
}
.spec-item { display: flex; flex-direction: column; gap: 3px; }
.spec-item label { font-size: 10px; font-weight: 600; color: var(--muted); }
.spec-inputs { display: flex; align-items: center; gap: 4px; }
.spec-inputs select {
  width: 68px; height: 28px; padding: 0 4px;
  border: 1px solid var(--border); border-radius: 6px;
  font-size: 10px; cursor: pointer;
}
.spec-inputs input {
  width: 50px; height: 28px; padding: 0 6px;
  border: 1px solid var(--border); border-radius: 6px; font-size: 10px;
}
.spec-inputs span { font-size: 10px; color: var(--muted); }

/* 경화깊이 */
.depth-inputs { display: flex; align-items: center; gap: 4px; flex-wrap: wrap; }
.depth-inputs select {
  height: 28px; padding: 0 6px;
  border: 1px solid var(--border); border-radius: 6px; font-size: 10px;
}
.depth-inputs input {
  width: 60px; height: 28px; padding: 0 6px;
  border: 1px solid var(--border); border-radius: 6px; font-size: 10px;
}
.depth-inputs span { font-size: 10px; color: var(--muted); }

/* 수입검사 */
.inspection-grid { display: grid; grid-template-columns: repeat(2,1fr); gap: 5px; }
.inspection-row { display: flex; align-items: center; gap: 4px; }
.inspection-row label {
  font-size: 10px; font-weight: 600; color: var(--muted); min-width: 44px;
}
.inspection-row input {
  width: 56px; height: 28px; padding: 0 6px;
  border: 1px solid var(--border); border-radius: 6px; font-size: 10px;
}
.inspection-row span { font-size: 10px; color: var(--muted); }

/* 공정 체크 */
.process-check-grid { display: grid; grid-template-columns: repeat(4,1fr); gap: 6px; }
.process-item { display: flex; align-items: center; gap: 5px; }
.process-item input[type="checkbox"] {
  width: 14px; height: 14px; cursor: pointer;
  accent-color: var(--primary);
}
.process-item label { font-size: 11px; cursor: pointer; margin: 0; color: var(--text); }

/* 이미지 업로드 */
.img-upload-area { display: flex; flex-direction: column; gap: 6px; }
.img-upload-area input[type="file"] {
  padding: 4px; border: 1px solid var(--border); border-radius: 6px;
  font-size: 10px; cursor: pointer; background: var(--bg);
}
.img-upload-area input[type="file"]::-webkit-file-upload-button {
  padding: 3px 8px; border: none; border-radius: 5px;
  background: var(--primary); color: #fff;
  font-size: 10px; font-weight: 600; cursor: pointer; margin-right: 6px;
}
.img-preview {
  width: 100%; height: 190px;
  border: 2px dashed var(--border); border-radius: 8px;
  display: flex; align-items: center; justify-content: center;
  background: var(--bg); overflow: hidden; transition: all .2s;
}
.img-preview-sm { height: 100px; }
.img-preview:hover { border-color: var(--primary); background: #eff6ff; }
.img-preview img { max-width: 100%; max-height: 100%; object-fit: contain; }

.file-link {
  display: inline-block; padding: 3px 8px; font-size: 10px;
  color: var(--primary); text-decoration: none;
  border: 1px solid var(--primary); border-radius: 5px; transition: all .2s;
}
.file-link:hover { background: var(--primary); color: #fff; }

.btn-clear {
  padding: 3px 10px; border: 1px solid var(--red); border-radius: 5px;
  background: var(--white); color: var(--red);
  font-size: 10px; font-weight: 600; cursor: pointer; transition: all .2s;
}
.btn-clear:hover { background: var(--red); color: #fff; }

.file-upload-area { display: flex; flex-direction: column; gap: 5px; }
.file-upload-area input[type="file"] {
  padding: 4px; border: 1px solid var(--border); border-radius: 6px;
  font-size: 10px; cursor: pointer; background: var(--bg);
}
.file-upload-area a {
  display: inline-block; padding: 3px 8px; font-size: 10px;
  color: var(--primary); text-decoration: none; word-break: break-all;
}
.file-upload-area a:hover { text-decoration: underline; }

/* 모달 푸터 */
.pm-footer {
  display: flex; justify-content: center; align-items: center; gap: 8px;
  padding: 10px 20px;
  background: var(--white); border-top: 1px solid var(--border); flex-shrink: 0;
}
.pm-footer button {
  min-width: 86px; height: 34px;
  border: none; border-radius: 8px;
  font-size: 12px; font-weight: 700; cursor: pointer; transition: all .2s;
}
.btn-save    { background: var(--green,  #22c55e); color: #fff; }
.btn-save:hover    { filter: brightness(1.08); transform: translateY(-1px); }
.btn-saveas  { background: var(--primary); color: #fff; }
.btn-saveas:hover  { filter: brightness(1.08); transform: translateY(-1px); }
.btn-delete  { background: var(--red,    #ef4444); color: #fff; }
.btn-delete:hover  { filter: brightness(1.08); transform: translateY(-1px); }
.btn-cancel  { background: var(--muted,  #6b7280); color: #fff; }
.btn-cancel:hover  { filter: brightness(1.08); transform: translateY(-1px); }

/* 이미지 확대 오버레이 */
#imgZoomOverlay {
  display: none; position: fixed;
  top: 0; left: 0; width: 100%; height: 100%;
  background: rgba(0,0,0,.75); z-index: 9999;
  align-items: center; justify-content: center;
  pointer-events: none;
}
#imgZoomTarget {
  max-width: 80vw; max-height: 80vh;
  object-fit: contain; border-radius: 8px;
  box-shadow: 0 0 40px rgba(255,255,255,.15); pointer-events: none;
}

/* 반응형 */
@media (max-width:1600px){ .product-modal{ width:1360px; } }
@media (max-width:1400px){ .product-modal{ width:95vw; } .pm-grid{ grid-template-columns:2fr 1fr; } }
@media (max-width:1100px){ .pm-row{ grid-template-columns:repeat(2,1fr); } }
@media (max-width:800px) { .pm-grid{ grid-template-columns:1fr; } .pm-row{ grid-template-columns:1fr; } }
</style>

<body>
<div class="page-wrap">

  <!-- 페이지 헤더 -->
  <div class="page-header">
    <div>
      <div class="page-title">제품 등록</div>
      <div class="page-sub">제품 기본정보 및 공정·품질·SPEC 정보를 등록·관리합니다.</div>
    </div>
    <div style="display:flex; gap:8px;">
      <button class="btn-primary select-button" onclick="getProductList();">🔍 조회</button>
      <button class="btn-primary insert-button">➕ 등록</button>
      <button class="btn-primary excel-button">📥 엑셀</button>
    </div>
  </div>

  <!-- 검색 바 -->
  <div class="card" style="padding:12px 16px; margin-bottom:12px;">
    <div class="search-bar">
      <label>거래처</label>
      <input type="text" id="search_corp" placeholder="거래처명 검색" style="width:160px;">
      <label>품명</label>
      <input type="text" id="search_name" placeholder="품명 검색" style="width:160px;">
      <label>품번</label>
      <input type="text" id="search_no" placeholder="품번 검색" style="width:140px;">
    </div>
  </div>

  <!-- 테이블 -->
  <div class="card">
    <div class="card-title">제품 목록</div>
    <div id="tab1"></div>
  </div>
</div>

<!-- ═══════════════════════════════════════════
     제품 등록/수정 모달
     ═══════════════════════════════════════════ -->
<form autocomplete="off" method="post" class="corrForm" id="productInsertForm"
      name="productInsertForm" enctype="multipart/form-data">

  <div class="modal-overlay"></div>

  <div class="product-modal">
    <!-- 헤더 -->
    <div class="pm-header">
      <h2>📦 제품등록</h2>
      <button type="button" class="pm-close-btn">&times;</button>
    </div>

    <!-- 본문 -->
    <div class="pm-body">
      <div class="pm-grid">

        <!-- ── 왼쪽: 입력 필드 ── -->
        <div class="pm-left">

          <!-- 기본 정보 -->
          <div class="pm-section">
            <div class="pm-section-title">기본 정보</div>
            <div class="pm-row">
              <div class="pm-col">
                <label>등록일</label>
                <input type="date" id="prod_date" name="prod_date">
              </div>
              <div class="pm-col">
                <label>구분</label>
                <select id="prod_gubn" name="prod_gubn">
                  <option>양산</option>
                  <option>개발</option>
                </select>
              </div>
              <div class="pm-col">
                <label>거래처</label>
                <div class="input-with-btn">
                  <input type="text" id="corp_name" name="corp_name" readonly placeholder="검색 버튼 클릭">
                  <input type="hidden" id="corp_code" name="corp_code">
                  <button type="button" class="btn-search" onclick="openCutumModal();">검색</button>
                </div>
              </div>
            </div>
            <div class="pm-row">
              <div class="pm-col">
                <label>품명 <span class="req">*</span></label>
                <input type="text" id="prod_name" name="prod_name" placeholder="품명">
              </div>
              <div class="pm-col">
                <label>품번</label>
                <input type="text" id="prod_no" name="prod_no" placeholder="품번">
              </div>
              <div class="pm-col">
                <label>관리번호</label>
                <input type="text" id="prod_cno" name="prod_cno" placeholder="관리번호">
              </div>
            </div>
            <div class="pm-row">
              <div class="pm-col">
                <label>모델명</label>
                <input type="text" id="prod_model" name="prod_model" placeholder="모델명">
              </div>
              <div class="pm-col">
                <label>재질</label>
                <input type="text" id="prod_jai" name="prod_jai" placeholder="재질">
              </div>
              <div class="pm-col">
                <label>규격</label>
                <div class="input-with-symbols">
                  <input type="text" id="prod_gyu" name="prod_gyu" placeholder="규격">
                  <button type="button" class="btn-symbol" onclick="$('#prod_gyu').val($('#prod_gyu').val()+'Φ');">Φ</button>
                  <button type="button" class="btn-symbol" onclick="$('#prod_gyu').val($('#prod_gyu').val()+'X');">X</button>
                  <button type="button" class="btn-symbol" onclick="$('#prod_gyu').val($('#prod_gyu').val()+'L');">L</button>
                </div>
              </div>
            </div>
            <div class="pm-row">
              <div class="pm-col">
                <label>단중(kg)</label>
                <input type="text" id="prod_danj" name="prod_danj" placeholder="단중">
              </div>
              <div class="pm-col">
                <label>단가</label>
                <input type="text" id="prod_dang" name="prod_dang" value="0">
              </div>
              <div class="pm-col">
                <label>단위</label>
                <select id="prod_danw" name="prod_danw">
                  <option>EA</option>
                  <option>CH</option>
                  <option>KG</option>
                </select>
              </div>
            </div>
          </div>

          <!-- 공정 정보 -->
          <div class="pm-section">
            <div class="pm-section-title">공정 정보</div>
            <div class="pm-row">
              <div class="pm-col">
                <label>공정</label>
                <select id="tech_no" name="tech_no">
                  <option value="A08">PIT로-가스산질화(A08)</option>
                  <option value="A11">PIT로-가스질화(A11)</option>
                  <option value="A12">PIT로-가스연질화(A12)</option>
                  <option value="A13">PIT로-Annearling(A13)</option>
                  <option value="A14">PIT로-Normalizing(A14)</option>
                  <option value="A15">PIT로-기타(A15)</option>
                  <option value="A16">Box Type-QT(A16)</option>
                  <option value="A17">Box Type-침탄(A17)</option>
                  <option value="A18">Box Type-침탄질화(A18)</option>
                  <option value="A20">Box Type-가스연질화(A20)</option>
                  <option value="A21">Box Type-Normalizing(A21)</option>
                  <option value="A27">이온질화-이온질화(A27)</option>
                  <option value="A30">Salt로-염욕질화(A30)</option>
                  <option value="A31">Box Type-Case-Vc(A31)</option>
                  <option value="A32">PIT로-Normalizing(A32)</option>
                  <option value="A33">Box Type-VC침탄(A33)</option>
                  <option value="A34">Box Type-가스질화(A34)</option>
                  <option value="A35">PIT로-침류질화(A35)</option>
                  <option value="B16">템퍼링로-템퍼링(B16)</option>
                  <option value="B17">템퍼링로-템퍼링기타(B17)</option>
                  <option value="B38">진공로-진공열처리(B38)</option>
                  <option value="B39">이온질화-PLASOX(B39)</option>
                  <option value="B40">진공로-Annearling(B40)</option>
                  <option value="B41">진공로-Normalizing(B41)</option>
                  <option value="B42">진공로-기타(B42)</option>
                  <option value="C01">PQ-PQ(C01)</option>
                  <option value="C02">PQ-외주품(C02)</option>
                  <option value="C03">PQ-침탄PQ(C03)</option>
                </select>
              </div>
              <div class="pm-col">
                <label>공정순서</label>
                <input type="text" id="tech_seq" name="tech_seq" placeholder="공정순서">
              </div>
              <div class="pm-col">
                <label>공정패턴</label>
                <input type="number" id="tech_pattern" name="tech_pattern" placeholder="패턴">
              </div>
            </div>
            <div class="pm-row">
              <div class="pm-col">
                <label>박스당수량</label>
                <input type="text" id="prod_boxsu" name="prod_boxsu" placeholder="수량">
              </div>
              <div class="pm-col">
                <label>포장방법</label>
                <input type="text" id="prod_danch" name="prod_danch" placeholder="포장방법">
              </div>
              <div class="pm-col">
                <label>BOX TYPE</label>
                <select id="prod_box" name="prod_box">
                  <option>A</option>
                  <option>B</option>
                </select>
              </div>
            </div>
          </div>

          <!-- 품질 정보 -->
          <div class="pm-section">
            <div class="pm-section-title">품질 정보</div>
            <div class="pm-row">
              <div class="pm-col">
                <label>열처리곡선</label>
                <select id="prod_snp" name="prod_snp">
                  <option>불요</option><option>필요</option>
                </select>
              </div>
              <div class="pm-col">
                <label>방청유</label>
                <select id="prod_bangch" name="prod_bangch">
                  <option>필요없음</option><option>수용성</option><option>유용성</option><option>기타</option>
                </select>
              </div>
              <div class="pm-col">
                <label>후처리</label>
                <select id="prod_vnyl" name="prod_vnyl">
                  <option>불요</option><option>쇼트SHOT-H</option><option>쇼트SHOT-T</option>
                  <option>쇼트SHOT-A</option><option>센딩SAND-A</option><option>센딩SAND-index</option>
                  <option>센딩SAND-T</option><option>센딩SAND-conveyer</option>
                </select>
              </div>
            </div>
            <div class="pm-row">
              <div class="pm-col">
                <label>시편제목</label>
                <select id="prod_pad" name="prod_pad">
                  <option>본품</option><option>대체시편</option>
                  <option>시편절단(본품절단)</option><option>시편필요없음</option>
                </select>
              </div>
              <div class="pm-col">
                <label>업종</label>
                <select id="prod_upjong" name="prod_upjong">
                  <option>자동차</option><option>선박</option><option>유압</option>
                  <option>방산</option><option>기타</option>
                </select>
              </div>
              <div class="pm-col">
                <label>성적서</label>
                <select id="prod_plt" name="prod_plt">
                  <option>필요</option><option>불필요</option>
                </select>
              </div>
            </div>
            <div class="pm-row">
              <div class="pm-col-full">
                <label>제품실재고 현황</label>
                <input type="text" id="prod_realjai" name="prod_realjai" placeholder="재고현황">
              </div>
            </div>
          </div>

          <!-- SPEC 정보 -->
          <div class="pm-section">
            <div class="pm-section-title">SPEC 정보</div>
            <div class="spec-grid">
              <div class="spec-item">
                <label>표면경도</label>
                <div class="spec-inputs">
                  <select id="prod_pg" name="prod_pg">
                    <option>HRC</option><option>HV</option><option>HS</option><option>HRA</option>
                    <option>HRB</option><option>HB</option><option>HR15N</option><option>HR30N</option><option>HR45N</option>
                  </select>
                  <input type="text" id="prod_pg1" name="prod_pg1" placeholder="MIN">
                  <span>~</span>
                  <input type="text" id="prod_pg2" name="prod_pg2" placeholder="MAX">
                </div>
              </div>
              <div class="spec-item">
                <label>소입경도</label>
                <div class="spec-inputs">
                  <select id="prod_si" name="prod_si">
                    <option>HRC</option><option>HV</option><option>HS</option><option>HRA</option>
                    <option>HRB</option><option>HB</option><option>HR15N</option><option>HR30N</option><option>HR45N</option>
                  </select>
                  <input type="text" id="prod_si1" name="prod_si1" placeholder="MIN">
                  <span>~</span>
                  <input type="text" id="prod_si2" name="prod_si2" placeholder="MAX">
                </div>
              </div>
            </div>
            <div class="spec-grid">
              <div class="spec-item">
                <label>소려경도</label>
                <div class="spec-inputs">
                  <select id="prod_sr" name="prod_sr">
                    <option>HRC</option><option>HV</option><option>HS</option><option>HRA</option>
                    <option>HRB</option><option>HB</option><option>HR15N</option><option>HR30N</option><option>HR45N</option>
                  </select>
                  <input type="text" id="prod_sr1" name="prod_sr1" placeholder="MIN">
                  <span>~</span>
                  <input type="text" id="prod_sr2" name="prod_sr2" placeholder="MAX">
                </div>
              </div>
              <div class="spec-item">
                <label>심부경도</label>
                <div class="spec-inputs">
                  <select id="prod_sg" name="prod_sg">
                    <option>HRC</option><option>HV</option><option>HRA</option><option>HRB</option><option>HB</option>
                  </select>
                  <input type="text" id="prod_sg1" name="prod_sg1" placeholder="MIN">
                  <span>~</span>
                  <input type="text" id="prod_sg2" name="prod_sg2" placeholder="MAX">
                </div>
              </div>
            </div>
            <div class="pm-row">
              <div class="pm-col-full">
                <label>경화깊이</label>
                <div class="depth-inputs">
                  <select id="prod_gd1" name="prod_gd1"><option>유효경화</option><option>전경화</option></select>
                  <select id="prod_gd3" name="prod_gd3"><option>HV</option><option>HRC</option></select>
                  <input type="text" id="prod_gd2" name="prod_gd2" placeholder="기준">
                  <span>기준,</span>
                  <input type="text" id="prod_gd4" name="prod_gd4" placeholder="MIN">
                  <span>~</span>
                  <input type="text" id="prod_gd5" name="prod_gd5" placeholder="MAX">
                </div>
              </div>
            </div>
            <div class="pm-row">
              <div class="pm-col">
                <label>화합물층 깊이</label>
                <div class="spec-inputs">
                  <select id="prod_whadeep" name="prod_whadeep"><option>㎛</option><option>㎜</option></select>
                  <input type="text" id="prod_e1" name="prod_e1" placeholder="MIN">
                  <span>~</span>
                  <input type="text" id="prod_e2" name="prod_e2" placeholder="MAX">
                </div>
              </div>
              <div class="pm-col">
                <label>연마여유(mm)</label>
                <input type="text" id="prod_polish" name="prod_polish" value="0">
              </div>
            </div>
            <div class="pm-row">
              <div class="pm-col">
                <label>금속조직</label>
                <input type="text" id="prod_gj" name="prod_gj" placeholder="금속조직">
              </div>
              <div class="pm-col">
                <label>변형량</label>
                <input type="text" id="prod_bh" name="prod_bh" placeholder="변형량">
              </div>
            </div>
            <div class="pm-row">
              <div class="pm-col-full">
                <label>비고</label>
                <textarea id="prod_note" name="prod_note" rows="2" placeholder="비고"></textarea>
              </div>
            </div>
          </div>

          <!-- 수입검사 -->
          <div class="pm-section">
            <div class="pm-section-title">수입검사</div>
            <div class="inspection-grid">
              <div class="inspection-row">
                <label>치수1</label>
                <input type="text" id="prod_chisu1n" name="prod_chisu1n" placeholder="MIN">
                <span>~</span>
                <input type="text" id="prod_chisu1s" name="prod_chisu1s" placeholder="MAX">
              </div>
              <div class="inspection-row">
                <label>치수2</label>
                <input type="text" id="prod_chisu2n" name="prod_chisu2n" placeholder="MIN">
                <span>~</span>
                <input type="text" id="prod_chisu2s" name="prod_chisu2s" placeholder="MAX">
              </div>
              <div class="inspection-row">
                <label>치수3</label>
                <input type="text" id="prod_chisu3n" name="prod_chisu3n" placeholder="MIN">
                <span>~</span>
                <input type="text" id="prod_chisu3s" name="prod_chisu3s" placeholder="MAX">
              </div>
              <div class="inspection-row">
                <label>치수4</label>
                <input type="text" id="prod_chisu4n" name="prod_chisu4n" placeholder="MIN">
                <span>~</span>
                <input type="text" id="prod_chisu4s" name="prod_chisu4s" placeholder="MAX">
              </div>
              <div class="inspection-row">
                <label>치수5</label>
                <input type="text" id="prod_chisu5n" name="prod_chisu5n" placeholder="MIN">
                <span>~</span>
                <input type="text" id="prod_chisu5s" name="prod_chisu5s" placeholder="MAX">
              </div>
            </div>
          </div>

          <!-- 공정 체크 -->
          <div class="pm-section">
            <div class="pm-section-title">공정 체크</div>
            <div class="process-check-grid">
              <div class="process-item"><input type="checkbox" id="prod_fac1" name="prod_fac1"><label for="prod_fac1">전세정</label></div>
              <div class="process-item"><input type="checkbox" id="prod_fac2" name="prod_fac2"><label for="prod_fac2">방탄</label></div>
              <div class="process-item"><input type="checkbox" id="prod_fac3" name="prod_fac3"><label for="prod_fac3">침탄</label></div>
              <div class="process-item"><input type="checkbox" id="prod_fac4" name="prod_fac4"><label for="prod_fac4">고주파</label></div>
              <div class="process-item"><input type="checkbox" id="prod_fac5" name="prod_fac5"><label for="prod_fac5">후세정</label></div>
              <div class="process-item"><input type="checkbox" id="prod_fac6" name="prod_fac6"><label for="prod_fac6">템퍼링</label></div>
              <div class="process-item"><input type="checkbox" id="prod_fac7" name="prod_fac7"><label for="prod_fac7">쇼트</label></div>
              <div class="process-item"><input type="checkbox" id="prod_fac8" name="prod_fac8"><label for="prod_fac8">후처리</label></div>
            </div>
          </div>
        </div><!-- /pm-left -->

        <!-- ── 오른쪽: 이미지·도면 ── -->
        <div class="pm-right">
          <div class="pm-section">
            <div class="pm-section-title">제품 이미지</div>
            <div class="img-upload-area">
              <input type="file" id="imgInput0" class="imgInputClass" name="product_file_url" accept="image/*">
              <div class="img-preview">
                <img id="img0" src="/chunil/css/image/no_image.png" alt="제품이미지">
              </div>
              <a href="" class="aphoto file-link" download="">다운로드</a>
            </div>
          </div>

          <div class="pm-section">
            <div class="pm-section-title">외형사진</div>
            <div class="img-upload-area">
              <input type="file" id="imgInput1" class="imgInputClass" name="apperance_file_url" accept="image/*">
              <div class="img-preview img-preview-sm">
                <img id="img1" src="/chunil/css/image/no_image.png" alt="외형사진">
              </div>
              <button type="button" class="btn-clear"
                      onclick="$('#img1').attr('src','/chunil/css/image/no_image.png');$('#imgInput1').val('');">✕ 삭제</button>
            </div>
          </div>

          <div class="pm-section">
            <div class="pm-section-title">열처리공정</div>
            <div class="img-upload-area">
              <input type="file" id="imgInput2" class="imgInputClass" name="heat_file_url" accept="image/*">
              <div class="img-preview img-preview-sm">
                <img id="img2" src="/chunil/css/image/no_image.png" alt="열처리공정">
              </div>
              <button type="button" class="btn-clear"
                      onclick="$('#img2').attr('src','/chunil/css/image/no_image.png');$('#imgInput2').val('');">✕ 삭제</button>
            </div>
          </div>

          <div class="pm-section">
            <div class="pm-section-title">도면파일</div>
            <div class="file-upload-area">
              <input type="file" id="file" name="drawing_file_url">
              <button type="button" class="btn-clear" onclick="$('#fileLink').text('');">✕ 삭제</button>
              <a href="#" id="fileLink" onclick="openDrawingModal(event)"></a>
            </div>
          </div>
        </div><!-- /pm-right -->

      </div><!-- /pm-grid -->
    </div><!-- /pm-body -->

    <!-- 푸터 -->
    <div class="pm-footer">
      <button type="button" class="btn-delete" onclick="deleteProduct();" style="display:none;">🗑 삭제</button>
      <button type="button" class="btn-save"   onclick="save();">💾 저장</button>
      <button type="button" class="btn-saveas" id="btnSaveAs" onclick="saveAsNew();" style="display:none;">📋 다른이름저장</button>
      <button type="button" class="btn-cancel">✕ 닫기</button>
    </div>
  </div><!-- /product-modal -->
</form>

<!-- 거래처 검색 모달 -->
<div id="cutumListModal" class="modal-overlay" style="display:none;">
  <div class="modal-content">
    <div class="modal-header">
      <span>거래처 검색</span>
      <span class="modal-close" onclick="closeCutumListModal()">&times;</span>
    </div>
    <div id="cutumListTabulator" style="height:480px;"></div>
  </div>
</div>

<!-- PDF 미리보기 모달 -->
<div id="drawingFileModal" class="modal-overlay" style="display:none;">
  <div class="modal-content" style="max-width:90%;height:90%;">
    <div class="modal-header">
      <span>도면 파일: <span id="drawingFileName"></span></span>
      <span class="modal-close" onclick="closeDrawingModal()">&times;</span>
    </div>
    <div style="height:calc(100% - 60px);">
      <iframe id="pdfViewer" src="" frameborder="0" width="100%" height="100%"></iframe>
    </div>
  </div>
</div>

<!-- 이미지 확대 오버레이 -->
<div id="imgZoomOverlay">
  <img id="imgZoomTarget" src="">
</div>

<script>
// ═══ 전역 ═══
let now_page_code = "h01";
var productTable;
var isEditMode = false;
var selectedRowData = null;

$(function(){
  if (typeof userInfoList === 'function') userInfoList(now_page_code);
  getProductList();
});

// ═══ 파일 미리보기 ═══
$('.imgInputClass').change(function(event){
  var file = event.target.files[0];
  if (!file) return;
  var img = $(this).closest('.img-upload-area').find('img')[0];
  if (!img) return;
  img.title = file.name;
  var reader = new FileReader();
  reader.onload = function(e){ img.src = e.target.result; };
  reader.readAsDataURL(file);
});

// ═══ 모달 열기 (신규) ═══
$('.insert-button').on('click', function(){
  isEditMode = false; selectedRowData = null;
  $('#productInsertForm')[0].reset();
  $('#img0,#img1,#img2').attr('src','/chunil/css/image/no_image.png');
  $('.aphoto,#fileLink').attr('href','').text('');
  $('.btn-delete,#btnSaveAs').hide();
  $('#prod_dang,#prod_danj,#prod_boxsu,#prod_polish,#tech_pattern').val('0');
  const d = new Date();
  $('#prod_date').val(d.getFullYear()+'-'+String(d.getMonth()+1).padStart(2,'0')+'-'+String(d.getDate()).padStart(2,'0'));
  $('.product-modal').css({left:'50%',top:'50%',transform:'translate(-50%,-50%)'});
  $('.modal-overlay,.product-modal').addClass('active');
});

// ═══ 모달 닫기 ═══
$('.pm-close-btn,.btn-cancel').on('click', function(){
  $('.modal-overlay,.product-modal').removeClass('active');
});

// ═══ 드래그 ═══
let isDragging=false, startX, startY, modalLeft, modalTop;
$('.pm-header').on('mousedown', function(e){
  if($(e.target).hasClass('pm-close-btn')||$(e.target).closest('.pm-close-btn').length) return;
  isDragging=true;
  const off=$('.product-modal').offset();
  startX=e.pageX; startY=e.pageY; modalLeft=off.left; modalTop=off.top;
  $('.product-modal').css('transform','none');
  e.preventDefault();
});
$(document).on('mousemove',function(e){
  if(isDragging) $('.product-modal').css({left:(modalLeft+e.pageX-startX)+'px',top:(modalTop+e.pageY-startY)+'px'});
}).on('mouseup',function(){ isDragging=false; });

// ═══ 제품 목록 조회 ═══
function getProductList(){
  if(productTable){ productTable.destroy(); productTable=null; }
  $('#tab1').empty();
  productTable = new Tabulator("#tab1",{
    height:"680px", layout:"fitColumns", selectable:true,
    tooltips:true, reactiveData:true, headerHozAlign:"center",
    ajaxConfig:"POST", ajaxLoader:false,
    ajaxURL:"/chunil/management/productInsert/productList",
    ajaxParams:{"corp_name":$("#search_corp").val()},
    placeholder:"조회된 데이터가 없습니다.",
    pagination:"local", paginationSize:20,
    paginationSizeSelector:[20,50,100,500,1000],
    paginationCounter:"rows", headerFilterPlaceholder:"",
    ajaxResponse:function(url,params,response){
      return response.data ? response.data : response;
    },
    columns:[
      {title:"제품", field:"product_file_name", width:60, hozAlign:"center", headerSort:false,
        formatter:"image", cssClass:"rp-img-popup",
        formatterParams:{height:"16px",width:"16px",urlPrefix:"/tkPrint/사진/제품등록/"}},
      {title:"NO",      field:"idx",       sorter:"int",    width:50,  hozAlign:"center"},
      {title:"등록일",  field:"prod_date", sorter:"string", width:110, hozAlign:"center", headerFilter:"input", headerSort:false},
      {title:"거래처",  field:"corp_name", sorter:"string", width:130, hozAlign:"center", headerFilter:"input", headerSort:false},
      {title:"품명",    field:"prod_name", sorter:"string", width:160, hozAlign:"center", headerFilter:"input", headerSort:false},
      {title:"품번",    field:"prod_no",   sorter:"string", width:130, hozAlign:"center", headerFilter:"input", headerSort:false},
      {title:"규격",    field:"prod_gyu",  sorter:"string", width:110, hozAlign:"center", headerFilter:"input", headerSort:false},
      {title:"재질",    field:"prod_jai",  sorter:"string", width:100, hozAlign:"center", headerFilter:"input", headerSort:false},
      {title:"공정",    field:"tech_te",   sorter:"string", width:110, hozAlign:"center", headerFilter:"input", headerSort:false},
      {title:"단중",    field:"prod_danj", sorter:"int",    width:70,  hozAlign:"center", headerFilter:"input", headerSort:false},
      {title:"단위",    field:"prod_danw", sorter:"string", width:70,  hozAlign:"center", headerFilter:"input", headerSort:false},
      {title:"단가(EA)",field:"prod_dang", sorter:"int",    width:100, hozAlign:"center", headerFilter:"input", headerSort:false},
      {title:"표면경도",field:"prod_pg",   sorter:"string", width:100, hozAlign:"center", headerFilter:"input", headerSort:false},
      {title:"경화깊이",field:"prod_gd3",  sorter:"string", width:100, hozAlign:"center", headerFilter:"input", headerSort:false},
      {title:"심부경도",field:"prod_sg",   sorter:"string", width:100, hozAlign:"center", headerFilter:"input", headerSort:false},
    ],
    rowFormatter:function(row){
      row.getElement().style.fontWeight="600";
      row.getElement().style.backgroundColor="#fff";
    },
    rowClick:function(e,row){
      $("#tab1 .tabulator-row").removeClass('row_select');
      row.getElement().classList.add("row_select");
    },
    rowDblClick:function(e,row){
      const perm=userPermissions?.[now_page_code];
      if(!['U','D'].includes(perm)){ alert("수정 권한이 없습니다."); return false; }
      var data=row.getData();
      selectedRowData=data; isEditMode=true;
      productInsertDetail(data.prod_code);
      if(perm==='D'){ $('.btn-delete,#btnSaveAs').show(); }
      else          { $('#btnSaveAs').show(); $('.btn-delete').hide(); }
    }
  });
}

// ═══ 제품 상세 ═══
function productInsertDetail(prod_code){
  $.ajax({
    url:"/chunil/management/productInsert/productInsertDetail",
    type:"post", dataType:"json",
    data:{prod_code:prod_code},
    success:function(result){
      const d=result.data;
      $('#productInsertForm')[0].reset();
      for(let key in d){
        if(key==="prod_date") $("[name='"+key+"']").val(d[key].substring(0,10));
        else if(key.startsWith("prod_fac")) $("#"+key).prop("checked",(d[key]||"").includes("1"));
        else $("[name='"+key+"']").val(d[key]);
      }
      $("#img0,#img1,#img2").attr("src","/chunil/css/image/no_image.png");
      $(".aphoto,.bphoto,.cphoto").attr("href","").text("");
      if(d.product_file_name){ const p="/tkPrint/사진/제품등록/"+d.product_file_name; $("#img0").attr("src",p); $(".aphoto").attr("href",p).text(d.product_file_name); }
      if(d.apperance_file_name){ const p="/tkPrint/사진/제품등록/"+d.apperance_file_name; $("#img1").attr("src",p); }
      if(d.heat_file_name){ const p="/tkPrint/사진/제품등록/"+d.heat_file_name; $("#img2").attr("src",p); }
      if(d.drawing_file_name){ const p="/tkPrint/사진/제품등록/"+d.drawing_file_name; $("#fileLink").attr("href",p).text(d.drawing_file_name); }
      $('.modal-overlay,.product-modal').addClass('active');
      $('.product-modal').css({left:'50%',top:'50%',transform:'translate(-50%,-50%)'});
    }
  });
}

// ═══ 거래처 검색 ═══
function openCutumModal(){
  document.getElementById('cutumListModal').style.display='flex';
  new Tabulator("#cutumListTabulator",{
    height:"430px", layout:"fitColumns", selectable:true, headerSort:false,
    pagination:"local", paginationSize:20, headerFilterPlaceholder:"",
    ajaxURL:"/chunil/management/cutumInsert/cutumInsertList", ajaxConfig:"POST",
    ajaxParams:{corp_name:"",corp_plc:"",corp_gubn:"",corp_mast:"",corp_code:""},
    ajaxResponse:function(url,params,response){ return response.data; },
    columns:[
      {title:"구분ID",   field:"corp_gubn", width:110, hozAlign:"center", headerFilter:"input"},
      {title:"거래처명", field:"corp_name", width:160, hozAlign:"center", headerFilter:"input"},
      {title:"사업자번호",field:"corp_no",  width:200, hozAlign:"center", headerFilter:"input"},
      {title:"코드",     field:"corp_code", width:120, hozAlign:"center", visible:false},
    ],
    rowDblClick:function(e,row){
      const d=row.getData();
      document.getElementById('corp_name').value=d.corp_name;
      document.getElementById('corp_code').value=d.corp_code;
      document.getElementById('cutumListModal').style.display='none';
    }
  });
}
function closeCutumListModal(){ document.getElementById('cutumListModal').style.display='none'; }

// ═══ 저장 ═══
function save(){
  const perm=userPermissions?.[now_page_code];
  if(!isEditMode && !['I','U','D'].includes(perm)){ alert("등록 권한이 없습니다."); return; }
  if( isEditMode && !['U','D'].includes(perm))    { alert("수정 권한이 없습니다."); return; }

  ['prod_dang','prod_danj','prod_boxsu','prod_polish','tech_pattern'].forEach(function(f){
    if(!$('#'+f).val()||isNaN($('#'+f).val())) $('#'+f).val('0');
  });
  ['prod_fac1','prod_fac2','prod_fac3','prod_fac4','prod_fac5','prod_fac6','prod_fac7','prod_fac8'].forEach(function(f){
    $("#hidden_"+f).remove();
    $("<input>").attr({type:"hidden",id:"hidden_"+f,name:f,value:$("#"+f).is(":checked")?"1":"0"}).appendTo("#productInsertForm");
  });

  var fd=new FormData($("#productInsertForm")[0]);
  if(isEditMode && selectedRowData?.prod_code){
    fd.append("mode","update"); fd.append("prod_code",selectedRowData.prod_code);
    if(!confirm("수정하시겠습니까?")) return;
  } else {
    fd.append("mode","insert"); fd.delete("prod_code");
    if(!confirm("저장하시겠습니까?")) return;
  }

  $.ajax({
    url:"/chunil/management/productInsert/productInsertSave",
    type:"POST", data:fd, contentType:false, processData:false, dataType:"json",
    success:function(){
      $('.modal-overlay,.product-modal').removeClass('active');
      $('.product-modal').css({left:'50%',top:'50%',transform:'translate(-50%,-50%)'});
      isEditMode=false; selectedRowData=null;
      getProductList();
      setTimeout(function(){ alert("저장되었습니다."); }, 200);
    },
    error:function(){ alert("저장 중 오류가 발생했습니다."); }
  });
}

// ═══ 다른이름으로 저장 ═══
function saveAsNew(){
  const perm=userPermissions?.[now_page_code];
  if(!['I','U','D'].includes(perm)){ alert("등록 권한이 없습니다."); return; }
  ['prod_fac1','prod_fac2','prod_fac3','prod_fac4','prod_fac5','prod_fac6','prod_fac7','prod_fac8'].forEach(function(f){
    $("#hidden_"+f).remove();
    $("<input>").attr({type:"hidden",id:"hidden_"+f,name:f,value:$("#"+f).is(":checked")?"1":"0"}).appendTo("#productInsertForm");
  });
  var fd=new FormData($("#productInsertForm")[0]);
  fd.append("mode","insert"); fd.delete("prod_code");
  if(!confirm("현재 데이터를 바탕으로 새 제품을 등록하시겠습니까?")) return;
  $.ajax({
    url:"/chunil/management/productInsert/productInsertSave",
    type:"POST", data:fd, contentType:false, processData:false, dataType:"json",
    success:function(){
      $('.modal-overlay,.product-modal').removeClass('active');
      $('.product-modal').css({left:'50%',top:'50%',transform:'translate(-50%,-50%)'});
      isEditMode=false; selectedRowData=null;
      getProductList();
      setTimeout(function(){ alert("새로운 제품으로 저장되었습니다."); }, 200);
    },
    error:function(){ alert("저장 중 오류가 발생했습니다."); }
  });
}

// ═══ 삭제 ═══
function deleteProduct(){
  const perm=userPermissions?.[now_page_code];
  if(perm!=='D'){ alert("삭제 권한이 없습니다."); return; }
  if(!selectedRowData?.prod_code){ alert("삭제할 대상을 선택하세요."); return; }
  if(!confirm("삭제하시겠습니까?")) return;
  $.ajax({
    url:"/chunil/management/productInsert/productDelete",
    type:"POST", data:{prod_code:selectedRowData.prod_code}, dataType:"json",
    success:function(r){
      if(r.status==="success"){
        $('.modal-overlay,.product-modal').removeClass('active');
        $('.product-modal').css({left:'50%',top:'50%',transform:'translate(-50%,-50%)'});
        isEditMode=false; selectedRowData=null;
        getProductList();
        setTimeout(function(){ alert("삭제되었습니다."); }, 200);
      } else { alert("삭제 중 오류: "+r.message); }
    },
    error:function(){ alert("삭제 요청 중 오류가 발생했습니다."); }
  });
}

// ═══ 이미지 확대 ═══
$(document).on('mouseenter','.img-preview img',function(){
  const src=$(this).attr('src');
  if(!src||src.includes('no_image.png')) return;
  $('#imgZoomTarget').attr('src',src);
  $('#imgZoomOverlay').css('display','flex');
}).on('mouseleave','.img-preview img',function(){
  $('#imgZoomOverlay').css('display','none');
});
$('#imgZoomOverlay').on('click',function(){ $(this).css('display','none'); });

// ═══ 엑셀 다운로드 ═══
$('.excel-button').on('click',function(){
  const today=new Date().toISOString().slice(0,10).replace(/-/g,'');
  productTable.download("xlsx","제품등록_"+today+".xlsx",{sheetName:"제품등록"});
});

// ═══ PDF 미리보기 ═══
function openDrawingModal(event){
  event.preventDefault();
  const fl=$("#fileLink"), path=fl.attr("href"), name=fl.text();
  if(!path||path==="#"||!name){ alert("저장된 도면 파일이 없습니다."); return; }
  $("#drawingFileName").text(name);
  $("#pdfViewer").attr("src",path);
  $('#drawingFileModal').css('display','flex');
}
function closeDrawingModal(){
  $('#drawingFileModal').css('display','none');
  $("#pdfViewer").attr("src","");
}
</script>
</body>
