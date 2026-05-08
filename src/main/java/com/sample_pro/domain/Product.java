package com.sample_pro.domain;

public class Product {
	
	//PRODUCT 테이블
	private int prod_code;
	private int corp_code;
	private String corp_name;           //거래처명
	private String prod_name;			//품명
	private String prod_no;				//품번
	private String prod_gyu;			//규격
	private String prod_jai;			//재질
	private String prod_danj;			//단중
	private String prod_danw;			//단위
	private String prod_dang;			//단가
	private String prod_cno;			//주문번호
	private String prod_gubn;			//구분[양산/개발]
	private String prod_pg
	;				//표면경도[HRC/HV/HS/HRA/HRB/HB/HR15N/HR30N/HR45N]
	private String prod_pg1;			//표면경도수치 시작값
	private String prod_pg2;			//표면경도수치 종료값
	private String prod_sg;				//심부경도[HRC/HV/HRA/HRB/HB]
	private String prod_sg1;			//심부경도수치 시작값
	private String prod_sg2;			//심부경도수치 종료값
	private String prod_gd1;			//경화깊이[유효경화/전경화]
	private String prod_gd2;			//경화깊이 수치
	private String prod_gd3;			//경화깊이[HV/HRC]
	private String prod_gd4;			//경화깊이 수치 시작값
	private String prod_gd5;			//경화깊이 수치 종료값
	private String prod_e1;
	private String prod_e2;
	private String prod_note;			//비고
	private String prod_date;
	private String prod_model;
	private String prod_danch;			//포장방법
	private String prod_plt;
	private String prod_box;			//BOX TYPE[A/B]
	private String prod_snp;			//열처리 곡선[불요/필요]
	private String prod_bangch;			//방청유[필요없음/수용성/유용성/기타]
	private String prod_vnyl;			//후처리[불요/쇼트SHOT-(H,T,A,H)/샌딩SAND-(A,index,T,conveyer)]
	private String prod_pad;			//시편제목[본품/대체시편/시편절단/시편필요없음]
	private String prod_realjai;		//제품 실재고현황
	private String prod_cd;
	private String prod_kijong;
	private String prod_e3;
	private String prod_e4;
	private String prod_pgs;
	private String prod_pgs1;
	private String prod_pgs2;
	private String prod_e5;
	private String prod_do;
	private String prod_ra;
	private String prod_upjong;			//업종[자동차/선박/유압/방산/기타]
	private String prod_appear;
	private String prod_transform;
	private String prod_refno;
	private String prod_pwsno;
	private String prod_whadeep;
	private String prod_file;
	private String prod_fac1;
	private String prod_fac2;
	private String prod_fac3;
	private String prod_fac4;
	private String prod_fac5;
	private String prod_fac6;
	private String prod_fac7;
	private String prod_fac8;
	private String prod_gj;					//금속조직
	private String prod_bh;					//변형량
	private String prod_chisu1n;			//치수1 비교시작값
	private String prod_chisu2n;			//치수2 비교시작값
	private String prod_chisu3n;			//치수3 비교시작값		
	private String prod_chisu4n;			//치수4 비교시작값
	private String prod_chisu5n;			//치수5 비교시작값
	private String prod_chisu1s;			//치수1 비교종료값
	private String prod_chisu2s;			//치수2 비교종료값
	private String prod_chisu3s;			//치수3 비교종료값
	private String prod_chisu4s;			//치수4 비교종료값
	private String prod_chisu5s;			//치수5 비교종료값
	private String prod_polish;				//연마여유
	private String prod_si;					//소입경도[HRC/HV/HS/HRA/HRB/HB/HR15N/HR30N/HR45N]
	private String prod_si1;				//소입경도수치 시작값
	private String prod_si2;				//소입경도수치 종료값
	private String prod_sr;					//소려경도[HRC/HV/HS/HRA/HRB/HB/HR15N/HR30N/HR45N]
	private String prod_sr1;				//소려경도수치 시작값
	private String prod_sr2;				//소려경도수치 종료값
	private String prod_boxsu;				//박스당 수량
	private String prod_khecd;
	private String prod_khtcd;

	//TECH 테이블
	private String tech_no;					//공정
	private String tech_pattern;			//공정패턴
	private String tech_seq;				//공정순서
	private String tech_te;

	//PRODUCT_IMG 테이블
//	private int prod_code;					//제품코드 기준으로 저장
	private String prod_img;				//제품사진
	private String prod_img2;				//외형사진 및 분석위치
	private String prod_img3;				//열처리공정
	
	private String product_file_name;	//제품 사진
	private String apperance_file_name;	//외형 사진
	private String heat_file_name;		//열처리 사진
	private String drawing_file_name;	//도면파일
	
	
	
	public String getDrawing_file_name() {
		return drawing_file_name;
	}
	public void setDrawing_file_name(String drawing_file_name) {
		this.drawing_file_name = drawing_file_name;
	}
	public String getProduct_file_name() {
		return product_file_name;
	}
	public void setProduct_file_name(String product_file_name) {
		this.product_file_name = product_file_name;
	}
	public String getApperance_file_name() {
		return apperance_file_name;
	}
	public void setApperance_file_name(String appereance_file_name) {
		this.apperance_file_name = appereance_file_name;
	}
	public String getHeat_file_name() {
		return heat_file_name;
	}
	public void setHeat_file_name(String heat_file_name) {
		this.heat_file_name = heat_file_name;
	}
	public int getProd_code() {
		return prod_code;
	}
	public void setProd_code(int prod_code) {
		this.prod_code = prod_code;
	}
	public int getCorp_code() {
		return corp_code;
	}
	public void setCorp_code(int corp_code) {
		this.corp_code = corp_code;
	}
	public String getProd_name() {
		return prod_name;
	}
	public void setProd_name(String prod_name) {
		this.prod_name = prod_name;
	}
	public String getProd_no() {
		return prod_no;
	}
	public void setProd_no(String prod_no) {
		this.prod_no = prod_no;
	}
	public String getProd_gyu() {
		return prod_gyu;
	}
	public void setProd_gyu(String prod_gyu) {
		this.prod_gyu = prod_gyu;
	}
	public String getProd_jai() {
		return prod_jai;
	}
	public void setProd_jai(String prod_jai) {
		this.prod_jai = prod_jai;
	}
	public String getProd_danj() {
		return prod_danj;
	}
	public void setProd_danj(String prod_danj) {
		this.prod_danj = prod_danj;
	}
	public String getProd_danw() {
		return prod_danw;
	}
	public void setProd_danw(String prod_danw) {
		this.prod_danw = prod_danw;
	}
	public String getProd_dang() {
		return prod_dang;
	}
	public void setProd_dang(String prod_dang) {
		this.prod_dang = prod_dang;
	}
	public String getProd_cno() {
		return prod_cno;
	}
	public void setProd_cno(String prod_cno) {
		this.prod_cno = prod_cno;
	}
	public String getProd_gubn() {
		return prod_gubn;
	}
	public void setProd_gubn(String prod_gubn) {
		this.prod_gubn = prod_gubn;
	}
	public String getTech_no() {
		return tech_no;
	}
	public void setTech_no(String tech_no) {
		this.tech_no = tech_no;
	}
	public String getProd_pg() {
		return prod_pg;
	}
	public void setProd_pg(String prod_pg) {
		this.prod_pg = prod_pg;
	}
	public String getProd_pg1() {
		return prod_pg1;
	}
	public void setProd_pg1(String prod_pg1) {
		this.prod_pg1 = prod_pg1;
	}
	public String getProd_pg2() {
		return prod_pg2;
	}
	public void setProd_pg2(String prod_pg2) {
		this.prod_pg2 = prod_pg2;
	}
	public String getProd_sg() {
		return prod_sg;
	}
	public void setProd_sg(String prod_sg) {
		this.prod_sg = prod_sg;
	}
	public String getProd_sg1() {
		return prod_sg1;
	}
	public void setProd_sg1(String prod_sg1) {
		this.prod_sg1 = prod_sg1;
	}
	public String getProd_sg2() {
		return prod_sg2;
	}
	public void setProd_sg2(String prod_sg2) {
		this.prod_sg2 = prod_sg2;
	}
	public String getProd_gd1() {
		return prod_gd1;
	}
	public void setProd_gd1(String prod_gd1) {
		this.prod_gd1 = prod_gd1;
	}
	public String getProd_gd2() {
		return prod_gd2;
	}
	public void setProd_gd2(String prod_gd2) {
		this.prod_gd2 = prod_gd2;
	}
	public String getProd_gd3() {
		return prod_gd3;
	}
	public void setProd_gd3(String prod_gd3) {
		this.prod_gd3 = prod_gd3;
	}
	public String getProd_gd4() {
		return prod_gd4;
	}
	public void setProd_gd4(String prod_gd4) {
		this.prod_gd4 = prod_gd4;
	}
	public String getProd_gd5() {
		return prod_gd5;
	}
	public void setProd_gd5(String prod_gd5) {
		this.prod_gd5 = prod_gd5;
	}
	public String getProd_e1() {
		return prod_e1;
	}
	public void setProd_e1(String prod_e1) {
		this.prod_e1 = prod_e1;
	}
	public String getProd_e2() {
		return prod_e2;
	}
	public void setProd_e2(String prod_e2) {
		this.prod_e2 = prod_e2;
	}
	public String getProd_note() {
		return prod_note;
	}
	public void setProd_note(String prod_note) {
		this.prod_note = prod_note;
	}
	public String getProd_date() {
		return prod_date;
	}
	public void setProd_date(String prod_date) {
		this.prod_date = prod_date;
	}
	public String getProd_model() {
		return prod_model;
	}
	public void setProd_model(String prod_model) {
		this.prod_model = prod_model;
	}
	public String getProd_danch() {
		return prod_danch;
	}
	public void setProd_danch(String prod_danch) {
		this.prod_danch = prod_danch;
	}
	public String getProd_plt() {
		return prod_plt;
	}
	public void setProd_plt(String prod_plt) {
		this.prod_plt = prod_plt;
	}
	public String getProd_box() {
		return prod_box;
	}
	public void setProd_box(String prod_box) {
		this.prod_box = prod_box;
	}
	public String getProd_snp() {
		return prod_snp;
	}
	public void setProd_snp(String prod_snp) {
		this.prod_snp = prod_snp;
	}
	public String getProd_bangch() {
		return prod_bangch;
	}
	public void setProd_bangch(String prod_bangch) {
		this.prod_bangch = prod_bangch;
	}
	public String getProd_vnyl() {
		return prod_vnyl;
	}
	public void setProd_vnyl(String prod_vnyl) {
		this.prod_vnyl = prod_vnyl;
	}
	public String getProd_pad() {
		return prod_pad;
	}
	public void setProd_pad(String prod_pad) {
		this.prod_pad = prod_pad;
	}
	public String getProd_realjai() {
		return prod_realjai;
	}
	public void setProd_realjai(String prod_realjai) {
		this.prod_realjai = prod_realjai;
	}
	public String getTech_pattern() {
		return tech_pattern;
	}
	public void setTech_pattern(String tech_pattern) {
		this.tech_pattern = tech_pattern;
	}
	public String getTech_seq() {
		return tech_seq;
	}
	public void setTech_seq(String tech_seq) {
		this.tech_seq = tech_seq;
	}
	public String getProd_cd() {
		return prod_cd;
	}
	public void setProd_cd(String prod_cd) {
		this.prod_cd = prod_cd;
	}
	public String getProd_kijong() {
		return prod_kijong;
	}
	public void setProd_kijong(String prod_kijong) {
		this.prod_kijong = prod_kijong;
	}
	public String getProd_e3() {
		return prod_e3;
	}
	public void setProd_e3(String prod_e3) {
		this.prod_e3 = prod_e3;
	}
	public String getProd_e4() {
		return prod_e4;
	}
	public void setProd_e4(String prod_e4) {
		this.prod_e4 = prod_e4;
	}
	public String getProd_pgs() {
		return prod_pgs;
	}
	public void setProd_pgs(String prod_pgs) {
		this.prod_pgs = prod_pgs;
	}
	public String getProd_pgs1() {
		return prod_pgs1;
	}
	public void setProd_pgs1(String prod_pgs1) {
		this.prod_pgs1 = prod_pgs1;
	}
	public String getProd_pgs2() {
		return prod_pgs2;
	}
	public void setProd_pgs2(String prod_pgs2) {
		this.prod_pgs2 = prod_pgs2;
	}
	public String getProd_e5() {
		return prod_e5;
	}
	public void setProd_e5(String prod_e5) {
		this.prod_e5 = prod_e5;
	}
	public String getProd_do() {
		return prod_do;
	}
	public void setProd_do(String prod_do) {
		this.prod_do = prod_do;
	}
	public String getProd_ra() {
		return prod_ra;
	}
	public void setProd_ra(String prod_ra) {
		this.prod_ra = prod_ra;
	}
	public String getProd_upjong() {
		return prod_upjong;
	}
	public void setProd_upjong(String prod_upjong) {
		this.prod_upjong = prod_upjong;
	}
	public String getProd_appear() {
		return prod_appear;
	}
	public void setProd_appear(String prod_appear) {
		this.prod_appear = prod_appear;
	}
	public String getProd_transform() {
		return prod_transform;
	}
	public void setProd_transform(String prod_transform) {
		this.prod_transform = prod_transform;
	}
	public String getProd_refno() {
		return prod_refno;
	}
	public void setProd_refno(String prod_refno) {
		this.prod_refno = prod_refno;
	}
	public String getProd_pwsno() {
		return prod_pwsno;
	}
	public void setProd_pwsno(String prod_pwsno) {
		this.prod_pwsno = prod_pwsno;
	}
	public String getProd_whadeep() {
		return prod_whadeep;
	}
	public void setProd_whadeep(String prod_whadeep) {
		this.prod_whadeep = prod_whadeep;
	}
	public String getProd_file() {
		return prod_file;
	}
	public void setProd_file(String prod_file) {
		this.prod_file = prod_file;
	}
	public String getProd_fac1() {
		return prod_fac1;
	}
	public void setProd_fac1(String prod_fac1) {
		this.prod_fac1 = prod_fac1;
	}
	public String getProd_fac2() {
		return prod_fac2;
	}
	public void setProd_fac2(String prod_fac2) {
		this.prod_fac2 = prod_fac2;
	}
	public String getProd_fac3() {
		return prod_fac3;
	}
	public void setProd_fac3(String prod_fac3) {
		this.prod_fac3 = prod_fac3;
	}
	public String getProd_fac4() {
		return prod_fac4;
	}
	public void setProd_fac4(String prod_fac4) {
		this.prod_fac4 = prod_fac4;
	}
	public String getProd_fac5() {
		return prod_fac5;
	}
	public void setProd_fac5(String prod_fac5) {
		this.prod_fac5 = prod_fac5;
	}
	public String getProd_fac6() {
		return prod_fac6;
	}
	public void setProd_fac6(String prod_fac6) {
		this.prod_fac6 = prod_fac6;
	}
	public String getProd_fac7() {
		return prod_fac7;
	}
	public void setProd_fac7(String prod_fac7) {
		this.prod_fac7 = prod_fac7;
	}
	public String getProd_fac8() {
		return prod_fac8;
	}
	public void setProd_fac8(String prod_fac8) {
		this.prod_fac8 = prod_fac8;
	}
	public String getProd_gj() {
		return prod_gj;
	}
	public void setProd_gj(String prod_gj) {
		this.prod_gj = prod_gj;
	}
	public String getProd_bh() {
		return prod_bh;
	}
	public void setProd_bh(String prod_bh) {
		this.prod_bh = prod_bh;
	}
	public String getProd_chisu1n() {
		return prod_chisu1n;
	}
	public void setProd_chisu1n(String prod_chisu1n) {
		this.prod_chisu1n = prod_chisu1n;
	}
	public String getProd_chisu2n() {
		return prod_chisu2n;
	}
	public void setProd_chisu2n(String prod_chisu2n) {
		this.prod_chisu2n = prod_chisu2n;
	}
	public String getProd_chisu3n() {
		return prod_chisu3n;
	}
	public void setProd_chisu3n(String prod_chisu3n) {
		this.prod_chisu3n = prod_chisu3n;
	}
	public String getProd_chisu4n() {
		return prod_chisu4n;
	}
	public void setProd_chisu4n(String prod_chisu4n) {
		this.prod_chisu4n = prod_chisu4n;
	}
	public String getProd_chisu5n() {
		return prod_chisu5n;
	}
	public void setProd_chisu5n(String prod_chisu5n) {
		this.prod_chisu5n = prod_chisu5n;
	}
	public String getProd_chisu1s() {
		return prod_chisu1s;
	}
	public void setProd_chisu1s(String prod_chisu1s) {
		this.prod_chisu1s = prod_chisu1s;
	}
	public String getProd_chisu2s() {
		return prod_chisu2s;
	}
	public void setProd_chisu2s(String prod_chisu2s) {
		this.prod_chisu2s = prod_chisu2s;
	}
	public String getProd_chisu3s() {
		return prod_chisu3s;
	}
	public void setProd_chisu3s(String prod_chisu3s) {
		this.prod_chisu3s = prod_chisu3s;
	}
	public String getProd_chisu4s() {
		return prod_chisu4s;
	}
	public void setProd_chisu4s(String prod_chisu4s) {
		this.prod_chisu4s = prod_chisu4s;
	}
	public String getProd_chisu5s() {
		return prod_chisu5s;
	}
	public void setProd_chisu5s(String prod_chisu5s) {
		this.prod_chisu5s = prod_chisu5s;
	}
	public String getProd_polish() {
		return prod_polish;
	}
	public void setProd_polish(String prod_polish) {
		this.prod_polish = prod_polish;
	}
	public String getProd_si() {
		return prod_si;
	}
	public void setProd_si(String prod_si) {
		this.prod_si = prod_si;
	}
	public String getProd_si1() {
		return prod_si1;
	}
	public void setProd_si1(String prod_si1) {
		this.prod_si1 = prod_si1;
	}
	public String getProd_si2() {
		return prod_si2;
	}
	public void setProd_si2(String prod_si2) {
		this.prod_si2 = prod_si2;
	}
	public String getProd_sr() {
		return prod_sr;
	}
	public void setProd_sr(String prod_sr) {
		this.prod_sr = prod_sr;
	}
	public String getProd_sr1() {
		return prod_sr1;
	}
	public void setProd_sr1(String prod_sr1) {
		this.prod_sr1 = prod_sr1;
	}
	public String getProd_sr2() {
		return prod_sr2;
	}
	public void setProd_sr2(String prod_sr2) {
		this.prod_sr2 = prod_sr2;
	}
	public String getProd_boxsu() {
		return prod_boxsu;
	}
	public void setProd_boxsu(String prod_boxsu) {
		this.prod_boxsu = prod_boxsu;
	}
	public String getProd_img() {
		return prod_img;
	}
	public void setProd_img(String prod_img) {
		this.prod_img = prod_img;
	}
	public String getProd_img2() {
		return prod_img2;
	}
	public void setProd_img2(String prod_img2) {
		this.prod_img2 = prod_img2;
	}
	public String getProd_img3() {
		return prod_img3;
	}
	public void setProd_img3(String prod_img3) {
		this.prod_img3 = prod_img3;
	}
	public String getCorp_name() {
		return corp_name;
	}
	public void setCorp_name(String corp_name) {
		this.corp_name = corp_name;
	}
	public String getTech_te() {
		return tech_te;
	}
	public void setTech_te(String tech_te) {
		this.tech_te = tech_te;
	}
	public String getProd_khecd() {
		return prod_khecd;
	}
	public void setProd_khecd(String prod_khecd) {
		this.prod_khecd = prod_khecd;
	}
	public String getProd_khtcd() {
		return prod_khtcd;
	}
	public void setProd_khtcd(String prod_khtcd) {
		this.prod_khtcd = prod_khtcd;
	}
	
}