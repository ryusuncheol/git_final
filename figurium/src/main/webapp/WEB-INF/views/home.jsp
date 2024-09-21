<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%@ page language="java" contentType="text/html; charset=UTF-8"         pageEncoding="UTF-8" %><%@ taglib prefix="fun" uri="http://java.sun.com/jsp/jstl/functions" %><%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %><!DOCTYPE html><html lang="ko"><head>    <title>Figurium</title>    <meta charset="UTF-8">    <!-- SweetAlert2 -->    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>    <style>        .product_insert > a {            text-decoration: none;            color: #888;        }        .product_insert:hover > a {            text-decoration: none;            color: white;        }        .section-slide {        }        .item-slick1 {            /*max-height: 600px;*/        }        .slick-list {            aspect-ratio: 3.8 / 1;        }        .product-category a {            color: black;            text-decoration: none;            font-size: 18px;            height: 30px;        }        .sort_box {            display: block;            justify-content: space-between;            align-items: center; /* 수직 중앙 정렬 */            margin-bottom: 30px;        }        .select_filter {            padding: 5px; /* 선택 박스의 패딩 */            border-radius: 5px; /* 선택 박스의 둥근 모서리 */        }        /* 필터 박스 스타일 */        .filter_box {            display: flex;            justify-content: flex-end; /* 오른쪽 정렬 */            margin-top: 20px;        }        /* 선택 컨테이너 스타일 */        .select_container {            position: relative;            display: inline-block;        }        /* 드롭다운 스타일 */        .select_filter {            font-size: 16px;            padding: 10px 20px;            border: 1px solid #ddd;            border-bottom-right-radius: 5px;            border-bottom-left-radius: 5px;            background-color: #fff;            color: #333;            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);            cursor: pointer;            transition: all 0.3s ease;        }        .select_filter:focus {            outline: none;            border-color: #007bff;            box-shadow: 0 0 0 2px rgba(38, 143, 255, 0.2);        }        .select_filter option {            padding: 10px;        }        #product-price {            text-align: center;        }        /*Sold Out*/        .block2-pic {            position: relative;            display: inline-block;        }        .block2-pic img {            display: block;            width: 100%;            height: auto;        }        .sold-out-overlay {            position: absolute;            width: 525px;            height: 525px;            top: 0;            left: 0;            right: 0;            bottom: 0;            background: rgba(255, 0, 0, 0.5); /* 흐림 효과를 위한 배경 */            color: red; /* SOLD OUT 텍스트 색상 */            display: flex;            align-items: center;            justify-content: center;            font-size: 24px;            font-weight: bold;            text-transform: uppercase;            z-index: 10; /* 이미지 위에 표시되도록 설정 */            opacity: 0; /* 흐림 효과 */            pointer-events: none; /* 오버레이가 클릭되지 않도록 설정 */        }        .product-category > div:hover {            cursor: pointer;        }        .product-category > div > img:hover {            transform: scale(1.1);            transition: transform 0.9s ease;        }        /* 반응형을 위한 미디어 쿼리 */        @media (min-width: 768px) {        }        @media (max-width: 768px) {        }        @media (max-width: 576px) {            .product-category {                max-width: 30%;            }            .product-category img {                max-width: 100%;            }            .isotope-item{                max-width: 50%;            }        }    </style></head><body class="animsition"><jsp:include page="./common/header.jsp"/><div style="height: 75px;"></div><c:if test="${not empty message}">    <script>        Swal.fire({            icon: 'success',            title: '알림',            text: '${message}'        });    </script></c:if><c:if test="${not empty error}">    <script>        Swal.fire({            icon: 'error',            title: '오류',            text: '${error}'        });    </script></c:if><section class="bg0 p-t-23 p-b-140">    <div style="width: 100%">        <!-- Slider -->        <div style="width: 100%">            <div class="container-fluid" style="padding: 0;">                <section class="section-slide">                    <div class="wrap-slick1">                        <div class="slick1" >                            <div class="item-slick1"                                 style="background-image: url(/images/Slider1.jpg);">                                <div class="container">                                </div>                            </div>                            <div class="item-slick1"                                 style="background-image: url(/images/Slider2.jpg);">                                <div class="container">                                </div>                            </div>                            <div class="item-slick1"                                 style="background-image: url(/images/Slider3.jpg);">                                <div class="container">                                </div>                            </div>                        </div>                    </div>                </section>            </div>        </div>        <br>        <div class="p-b-10">            <div class="ltext-103 cl5" style="text-align: center;">                <img src="/images/피규리움메시지.png" style="width: 100%;">            </div>        </div>    </div>        <br>        <!-- Product -->        <div class="container" style="max-width: 1230px !important;">            <br>            <!-- 카테고리 -->            <div class="flex-w flex-l-m filter-tope-group m-tb-10" style="margin-bottom: 30px;">                <ul class="nav justify-content-center">                    <li class="nav-item product-category">                        <div class="nav-link" onclick="javascript:void(0);">                            <img src="/images/전체보기.png" alt="전체보기" style="width: 170px; height: auto;"                                 data-category="전체">                        </div>                    </li>                    <c:forEach var="category" items="${figureCategories}">                    <li class="nav-item product-category">                        <div class="nav-link" onclick="javascript:void(0);">                            <img src="/images/${category.name}.png" alt="${category.name}"                                 style="width: 170px; height: auto;"                                 data-category="${category.name}">                        </div>                    </li>                </c:forEach>                </ul>            </div>            <div class="sort_box">                <!-- Filter -->                <div class="filter_box">                    <select class="select_filter">                        <option value="newProducts">최신순</option>                        <option value="bestProducts">추천★상품</option>                        <option value="highPrice">높은 가격순</option>                        <option value="lowPrice">낮은 가격순</option>                    </select>                </div>            </div>            <!-- 상품(피규어) 조회 -->            <div id="productsList" class="row isotope-grid">            </div>        </div></section><!-- Footer --><jsp:include page="common/footer.jsp"/><c:if test="${not_search}">    <script>        // 해당 검색어에 공백을 입력 할 경우 처리        $(document).ready(function () {            setTimeout(function () {                alert("공백은 입력하실 수 없습니다.\n다시 검색 해주세요.");                return;            }, 500);        });    </script></c:if><script>    var lastCreatedAt = null; // 마지막 생성일자 저장    var lastId = null; // 마지막 상품 ID 저장    var lastPrice = null; // 마지막 상품 가격 저장    var lastLikeCount = null; // 마지막 좋아요 수 저장    var categoryName = '전체'; // 조회할 카테고리 이름(기본값:전체)    var selectFilter = 'newProducts'; // 정렬 옵션(기본값:newProducts)    var loading = false; // 데이터 로딩 중인지 상태를 저장    var noMoreData = false; // 더 이상 데이터가 없음을 표시    // 카테고리 a 태그 클릭 시 실행할 함수    $('.product-category > div > img').click(function () {        // 카테고리 이름 변수에 할당.        categoryName = $(this).data('category');        console.log(categoryName);        // 해당 카테고리 css 변경.        $('.product-category > div > img').css('font-weight', ''); // 모든 이미지의 폰트 두께 초기화        $(this).css('font-weight', 'bold'); // 클릭한 이미지 강조        // 정렬 옵션 기본값(최신순)으로 초기화.        $('.select_filter').val('newProducts');        // 마지막 생성일자, 가격, 좋아요 수, 상품 ID 값 초기화        lastCreatedAt = null;        lastPrice = null;        lastLikeCount = null;        lastId = null;        // 리스트 뿌릴 div 비우기.        $('#productsList').empty();        // 템플릿 Isotope 초기화.        $container = $('#productsList').isotope({            itemSelector: '.isotope-item',            layoutMode: 'fitRows'        });        saveState();        loadMore();    });    // select태그 option 선택 시 호출하는 함수    $('.select_filter').on('change', function () {        selectFilter = $(this).val(); // 선택한 옵션 할당.        // categoryName을 제외한  나머지 초기화.        lastCreatedAt = null;        lastPrice = null;        lastLikeCount = null;        lastId = null;        // 리스트 뿌릴 div 비우기.        $('#productsList').empty();        // 템플릿 Isotope 초기화.        $container = $('#productsList').isotope({            itemSelector: '.isotope-item',            layoutMode: 'fitRows'        });        saveState();        loadMore();    });    $(document).ready(function () {        // 이전 상태 복원        restoreState();        // 상품 카테고리 글씨 css 변경.        $('li a').each(function () {            if ($(this).text().trim() === categoryName) {                $(this).css('font-weight', 'bold');            }        });        loadMore();        // 리스트 뿌릴 div 비우기.        $('#productsList').empty();        // Isotope 초기화        var $container = $('#productsList').isotope({            itemSelector: '.isotope-item',            layoutMode: 'fitRows'        });        let preScroll = sessionStorage.getItem('preScroll');        if (preScroll) {            $('html, body').animate({scrollTop: preScroll}, 3000);            sessionStorage.removeItem('preScroll');        }        // 무한 스크롤 이벤트 리스너 추가        $(window).on('scroll', function () {            // // 화면의 푸터 영역 위에 스크롤이 도달했을 경우 loadMore() 호출.            if ($(window).scrollTop() + $(window).height() > $(document).height() - 320) {                if (!loading && !noMoreData) {                    loadMore();                }            }        });    });    function loadMore() {        console.log(categoryName);        // 데이터 로딩 중인 상태로 변경        loading = true;        // 날짜를 원하는 형식으로 포맷 옵션        var options = {year: 'numeric', month: 'long', day: 'numeric'};        $.ajax({            url: '/load-more-products',            method: 'GET',            data: {                'lastCreatedAt': lastCreatedAt,                'lastId': lastId,                'lastPrice': lastPrice,                'categoryName': categoryName,                'selectFilter': selectFilter,                "lastLikeCount": lastLikeCount            },            success: function (response) {                const products = response;                if (products.length === 0) {                    noMoreData = true; // 더 이상 데이터가 없음을 표시                } else {                    let html = '';                    products.forEach(function (product) {                        // JavaScript에서 날짜 문자열을 Date 객체로 변환                        var createdAt = new Date(product.createdAt);                        // 날짜를 원하는 형식으로 포맷                        var options = {                            year: 'numeric',                            month: '2-digit',                            day: '2-digit',                        };                        // 날짜를 가져와서 .으로 구분된 형식으로 변환                        var formattedDate = createdAt.toLocaleDateString('ko-KR', options).replace(/\//g, '.');                        html += `                            <div class='col-sm-6 col-md-4 col-lg-3 p-b-35 isotope-item \${product.categoryName}' style='margin-top:20px;' >                                <div class="block2">                                    <div class="block2-pic hov-img0" style="border: 1px solid #d1d1d1">                                        <img src="\${product.imageUrl}" alt="IMG-PRODUCT">                                        <img src="/images/soldout3.png" alt="Sold Out" class="sold-out-overlay" id="sold-out-img" style=" \${product.quantity == 0 ? 'display: block;' : 'display: none;'}">                                        <a href="productInfo.do?id=\${product.id}"                                           class="moveProductInfo block2-btn flex-c-m stext-103 cl2 size-102 bg0 bor2 hov-btn1 p-lr-15 trans-04">                                            상품 상세                                        </a>                                    </div>                                    <div class="block2-txt flex-w flex-t p-t-14">                                        <div class="block2-txt-child1 flex-col-l" id="product-name" style="display: flex; flex-direction: column; align-items: center; text-align: center;">                                            <a href="productInfo.do?id=\${product.id}" class="moveProductInfo stext-104 cl4 hov-cl1 trans-04 js-name-b2 p-b-6">                                               [\${product.categoryName}]  \${product.name}                                            </a>                                            <span class="stext-105 cl3" id="product-price" style="font-weight: bold; font-size: 16px;">                                                \${product.price}￦                                            </span>                                    <div style="display: flex; width: 100%; justify-content: space-between; align-items: center; margin-top: 10px;">                                        <span class="stext-105 cl3" style="margin-right: 5px;">                                            \${formattedDate}                                        </span>                                        <span class="stext-105 cl3" id="product-like" style="font-weight: bold;">                                            💖\${product.likeCount}                                        </span>                                    </div>                                        </div>                                    </div>                                </div>                            </div>`;                    });                    // 새 아이템을 추가하고 Isotope 레이아웃을 업데이트합니다.                    const $newItems = $(html);                    $('#productsList').append($newItems).isotope('appended', $newItems);                    // 마지막 생성일자 or 마지막 가격 or 마지막 좋아요 수 or 상품 ID 업데이트                    lastCreatedAt = products[products.length - 1].createdAt;                    lastPrice = products[products.length - 1].price;                    lastLikeCount = products[products.length - 1].likeCount;                    lastId = products[products.length - 1].id;                    // 다음 페이지가 없으면 버튼 숨김                    if (products.length < 20) {                        noMoreData = true; // 더 이상 데이터가 없음을 표시                    }                    // 데이터 로딩 상태를 완료로 변경                    loading = false;                }            },            error: function (xhr, status, error) {                console.error('Error loading products:', error);                loading = false; // 에러 발생 시 로딩 상태 초기화            }        });    }    // 상품 상세 페이지로 가는 링크 클릭 시 상태 저장    $(document).on('click', '.moveProductInfo', function (event) {        event.preventDefault(); // 기본 동작 차단        let href = $(this).attr('href'); // 클릭한 링크의 href 값 가져오기        // 세션에 스크롤 위치 저장.        sessionStorage.setItem('preScroll', $(window).scrollTop());        // 상태 저장        saveState();        // 상태 저장이 완료된 후 이동        setTimeout(function () {            location.href = href;        }, 100); // 약간의 지연을 주어 상태 저장이 완료되도록 함    });    // 세션 스토리지에 현재 상태 저장    function saveState() {        sessionStorage.setItem('categoryName', categoryName);        sessionStorage.setItem('selectFilter', selectFilter);    }    // 세션 스토리지에서 이전 상태 복원    function restoreState() {        categoryName = sessionStorage.getItem('categoryName') || '전체';        selectFilter = sessionStorage.getItem('selectFilter') || 'newProducts';    }</script></body></html>