    <%--
      Created by IntelliJ IDEA.
      User: mac
      Date: 8/27/24
      Time: 9:28 AM
      To change this template use File | Settings | File Templates.
    --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <title>Title</title>
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <jsp:include page="../common/header.jsp"/>
    <div style="height: 90px"></div>
    <body>

    <div class="container pt-5">
        <h1>게시글 작성</h1>
        <hr>
        <form action="${pageContext.request.contextPath}/qa/qaSave.do" method="post">
            <div class="form-group">
                <input type="text" class="form-control" id="title" name="title" placeholder="제목을 입력하세요">
            </div>
            <div class="form-group">
                <input type="password" class="form-control" id="author" name="author" placeholder="비밀번호를 입력하세요">
            </div>
            <form>
                <select name="category" class="custom-select">
                    <option selected>:::분류 선택:::</option>
                    <option value="배송문의">배송문의</option>
                    <option value="취소문의">취소문의</option>
                    <option value="교환">교환</option>
                    <option value="반품문의">반품문의</option>
                    <option value="배송지변경문의">배송지변경문의</option>
                    <option value="기타문의">기타문의</option>
                </select>
            </form>
            <br>
            <div class="form-group">
                <input type="text" class="form-control" name="title" placeholder="제목을 입력하세요">
            </div>
            <div class="form-group">
                <textarea class="form-control" style="resize: none; height: 180px;" id="content" name="content" placeholder="내용을 입력하세요"></textarea>
            </div>
            <button type="submit" class="btn btn-dark" style="margin-bottom: 10px;" >등록</button>
            <button type="button" class="btn btn-light" role="button" onclick="location.href='${pageContext.request.contextPath}/qa/qaList.do'" style="margin-bottom: 10px;">취소</button>
        </form>
    </div>





    <!-- NOTE : 푸터바 -->
    <jsp:include page="../common/footer.jsp"/>

    </body>


    </html>
