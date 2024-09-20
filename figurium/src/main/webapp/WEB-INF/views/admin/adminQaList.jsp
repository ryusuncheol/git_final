<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: 14A
  Date: 2024-08-26
  Time: 오후 4:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet"
      href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"/>
<html>
<head>
  <title>Q&A 미답변 현황</title>
  <!-- TODO : 제목 과 스타일 영역 -->
  <style>
    .thead-light>tr>th{
      text-align: center;
      vertical-align: middle !important;
    }
    tbody>tr>td{
      text-align: center;
      vertical-align: middle !important;
    }
    .nav-link:hover{
      cursor: pointer;
    }

  </style>
</head>

<body>
<!-- 메뉴바 -->
<jsp:include page="../common/header.jsp"/>
<div style="height: 90px"></div>
<div id="content-wrap-area">

  <nav class="navbar navbar-expand-sm bg-dark navbar-dark justify-content-center">
    <ul class="navbar-nav">
      <li class="nav-item">
        <a class="nav-link" style="font-size: 16px; vertical-align: middle !important;"
           href="adminSlideChange.do">메인 슬라이드 변경</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" style="font-size: 16px; vertical-align: middle !important;"
           href="productInsertForm.do">상품 등록</a>
      </li>
      &nbsp;&nbsp;
      <li class="nav-item">
        <a class="nav-link" href="admin.do">주문조회</a>
      </li>
      &nbsp;&nbsp;

      <li class="nav-item">
        <a class="nav-link" id="changeStatus" href="adminRefund.do">배송상태 변경</a>
      </li>
      <li class="nav-item">
        <div class="icon-header-item cl2 hov-cl1 trans-04 p-r-11 p-l-10 icon-header-noti"
             id="quantity-notify"
             data-notify="0">
          <a class="nav-link" style="font-size: 16px; vertical-align: middle !important; margin-top: 3px;"
             href="adminQuantity.do">상품 재고수정</a>
        </div>
      </li>
      &nbsp;&nbsp;
      <li class="nav-item">
        <div class="icon-header-item cl2 hov-cl1 trans-04 p-r-11 p-l-10 icon-header-noti"
             id="payment-notify"
             data-notify="0">
          <a class="nav-link" style="font-size: 16px; vertical-align: middle !important; margin-top: 3px;"
             href="adminPayment.do">결제취소</a>
        </div>
      </li>
      &nbsp;&nbsp;
      <li class="nav-item">
        <div class="icon-header-item cl2 hov-cl1 trans-04 p-r-11 p-l-10 icon-header-noti"
             id="retrun-notify"
             data-notify="0">
          <a class="nav-link" style="font-size: 16px; vertical-align: middle !important; margin-top: 3px;"
             href="adminReturns.do">반품승인</a>
        </div>
      </li>
      &nbsp;&nbsp;
      <li class="nav-item">
        <div class="icon-header-item cl2 hov-cl1 trans-04 p-r-11 p-l-10 icon-header-noti"
             id="qa-notify"
             data-notify="0">
          <a class="nav-link" style="font-size: 16px; vertical-align: middle !important; margin-top: 3px;"
             id="viewQaList" href="adminQaList.do" >Q&A 미답변</a>
        </div>
      </li>
    </ul>
  </nav>

  <br><br>

  <div class="container pt-3">
    <hr>
    <table class="table table-hover">
      <thead class="thead-light">
      <tr style="text-align: center">
        <th class="col-1">번호</th>
        <th class="col-2">제목</th>
        <th class="col-1">주문번호</th>
        <th class="col-1">상품번호</th>
        <th class="col-1">답변여부</th>
        <th class="col-1">작성자</th>
        <th class="col-2">작성일</th>
      </tr>
      </thead>
      <tbody style="text-align: center;">
      <c:forEach var="qa" items="${qaList}" varStatus="status">
      <tr onclick="location.href='qa/qaSelect.do?id=${qa.id}'" style="cursor: pointer;">
        <td>${status.index + 1}</td>
        <td class="truncate-title" style="text-align: left;">
          <span style="font-size: 18px;" class="material-symbols-outlined">lock</span>
          ${qa.title}
        </td>
        <td>
          <c:choose>
            <c:when test="${qa.ordersId eq null}">
              -
            </c:when>
            <c:otherwise>
              ${qa.ordersId}
            </c:otherwise>
          </c:choose>
        </td>
        <td>
          <c:choose>
            <c:when test="${qa.productId eq null}">
              -
            </c:when>
            <c:otherwise>
              ${qa.productId}
            </c:otherwise>
          </c:choose>
        </td>
        <td>${qa.replyStatus}</td>
        <td>${qa.name}</td>
        <td>${fn:substring(qa.created,0,10)} ${fn:substring(qa.created,11,16)}</td>
      </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>

</div>
<!-- 푸터 -->
<jsp:include page="../common/footer.jsp"/>
</body>

<script>


  $(document).ready(function () {

    updateCount();

    $('#viewQaList').click(function (event) {
      event.preventDefault();
      location.reload();
    });

  });

  function updateCount() {
    $.ajax({
      url: 'count.do', // 컨트롤러에서 갯수를 가져오는 URL
      type: 'GET',
      dataType: 'json',
      success: function (response) {
        if (response.quantityCount !== undefined) {
          $('#quantity-notify').attr('data-notify', response.quantityCount);
        } else {
          $('#quantity-notify').attr('data-notify', '0'); // 갯수가 없을 경우 0으로 설정
        }
        if (response.paymentCount !== undefined) {
          $('#payment-notify').attr('data-notify', response.paymentCount);
        } else {
          $('#payment-notify').attr('data-notify', '0'); // 갯수가 없을 경우 0으로 설정
        }
        if (response.retrunCount !== undefined) {
          $('#retrun-notify').attr('data-notify', response.retrunCount);
        } else {
          $('#retrun-notify').attr('data-notify', '0'); // 갯수가 없을 경우 0으로 설정
        }
        if (response.qaCount !== undefined) {
          $('#qa-notify').attr('data-notify', response.qaCount);
        } else {
          $('#qa-notify').attr('data-notify', '0'); // 갯수가 없을 경우 0으로 설정
        }

      },
      error: function (xhr, status, error) {
        console.error('count 가져오는 데 실패했습니다.', error);
        $('#quantity-notify').attr('data-notify', '0'); // 오류 발생 시 0으로 설정
        $('#payment-notify').attr('data-notify', '0'); // 오류 발생 시 0으로 설정
        $('#retrun-notify').attr('data-notify', '0'); // 오류 발생 시 0으로 설정
        $('#qa-notify').attr('data-notify', '0'); // 오류 발생 시 0으로 설정
      }
    });
  }


</script>

</script>
</html>