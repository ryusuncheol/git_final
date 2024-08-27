<%--
  Created by IntelliJ IDEA.
  User: mac
  Date: 8/26/24
  Time: 5:03 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>

<div class="container pt-5">
    <h1>Q&A게시판</h1>
    <table class="table table-hover">
        <thead class="thead-light">
        <tr>
            <th>번호</th>
            <th>제목</th>
            <th>답변여부</th>
            <th>작성자</th>
            <th>작성일</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <th>1</th>
            <th>test</th>
            <th>미답변</th>
            <th>test</th>
            <th>8월26일</th>
        </tr>
        </tbody>
    </table>

    <hr>
    <a class="btn btn-dark float-right">글쓰기</a>

    <ul class="pagination justify-content-center" style="margin:20px 0">
    <li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>
    <li class="page-item"><a class="page-link" href="#">1</a></li>
    <li class="page-item"><a class="page-link" href="#">2</a></li>
    <li class="page-item"><a class="page-link" href="#">3</a></li>
    <li class="page-item"><a class="page-link" href="#">Next</a></li>
    </ul>

</div>
</body>
</html>