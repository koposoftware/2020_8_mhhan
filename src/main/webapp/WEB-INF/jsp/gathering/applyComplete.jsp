<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
	<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
	<jsp:include page="/WEB-INF/jsp/include/head.jsp" /> 	
</head>
<body>
<!-- header BEGIN -->
	<jsp:include page="/WEB-INF/jsp/include/header.jsp" />
<!-- header END -->
    
    <section class="inner-page">
      <div class="slider-item py-5" style="background-image: url('${ pageContext.request.contextPath }/resources/img/slider-2.jpg');">
        
        <div class="container">
          <div class="row slider-text align-items-center justify-content-center text-center">
            <div class="col-md-7 col-sm-12 element-animate">
              <h1 class="text-white">모임통장 신청</h1>
            </div>
          </div>
        </div>

      </div>
    </section>
    
    <section class="section">
      <div class="container">
        <div class="row mb-5 justify-content-center">
          <div class="col-md-7 order-lg-1">
			
			<h2 class="text-uppercase heading mb-4">모임통장 신청 완료</h2>
            <p class="mb-3">이제 모임통장에 친구를 초대해보세요</p>
			<table class="table">
				<tr>
					<td>계좌</td>
					<td>모임통장<br>
					${ gatheringVO.accountNo }</td>
				</tr>
				<tr>
					<td>안심계좌번호</td>
					<td>${ gatheringVO.safeAccountNo }</td>
				</tr>	
				<tr>
					<td>모임통장 신청일</td>
					<td><%= new SimpleDateFormat("yyyy.MM.dd HH:mm:ss").format(new Date()) %></td>
				</tr>							
			</table>
			<ul class="list-unstyled check">
              <li>안심계좌번호란 예금주의 계좌 정보 보호를 위해 멤버들에게 보여지는 계좌번호입니다.</li>
              <li>모임통장 신청일 이후 내역부터 멤버들에게 보여집니다.</li>
            </ul>
			<div class="row mb-5">
			<div class="col-md-8 order-lg-1">
            	<button id="kakao-link-btn" class="btn btn-primary">카카오톡으로 모임원 초대하기</button>
            	<!-- <a id="kakao-link-btn" href="javascript:sendLink()">초대</a> -->
            	<%-- <button class="btn btn-primary" onclick = "location.href = '${ pageContext.request.contextPath }/participant/invite' ">친구초대하기</button> --%>
            </div>
            </div>
            	
		  </div>
		</div>				
      </div>
    </section>
    
    <section class="container cta-overlap">
      <div class="text d-flex">
        <h2 class="h3">Contact Us For Projects or Need a Quotations</h2>
        <div class="ml-auto btn-wrap">
          <a href="get-quote.html" class="btn-cta btn btn-outline-white">Get A Quote</a>
        </div>
      </div>
    </section>
    <!-- END section -->

	<!-- footer BEGIN -->
		<jsp:include page="/WEB-INF/jsp/include/footer.jsp" /> 
    <!-- footer END -->

    <!-- loader -->
    <div id="loader" class="show fullscreen"><svg class="circular" width="48px" height="48px"><circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/><circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#f4b214"/></svg></div>


    <script src="${ pageContext.request.contextPath }/resources/js/jquery-3.2.1.min.js"></script>
    <script src="${ pageContext.request.contextPath }/resources/js/popper.min.js"></script>
    <script src="${ pageContext.request.contextPath }/resources/js/bootstrap.min.js"></script>
    <script src="${ pageContext.request.contextPath }/resources/js/owl.carousel.min.js"></script>
    <script src="${ pageContext.request.contextPath }/resources/js/jquery.waypoints.min.js"></script>
    <script src="${ pageContext.request.contextPath }/resources/js/main.js"></script> 	
	
	
	<!-- 웹 페이지에 JavaScript SDK 포함하기 -->
	<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>	
	<script>
	<!-- javaScript 키를 할당하여 초기화 함수를 호출 -->
	Kakao.init('');		//자신의 appkey 삽입
	console.log(Kakao.isInitialized());
	</script>
	<script>
	  function sendLink() {
			let random = Math.random();
  			let authenticationNum = Math.floor( random * 9000 + 1000 )
  			let code = '${ gatheringVO.safeAccountNo }' + authenticationNum
		    Kakao.Link.sendCustom({
		        templateId: 35968,
		        /* url: /hanati/participant/invite/${param} 		param은 안심계좌번호	*/
		        templateArgs: {
		          title:
		        	  '${memberVO.name}',
		          description:
		        	  '${gatheringVO.name}',
		       		param:
		       			code
		        },	callback: function(){
		       		alert("초대 메세지가 전송되었습니다");
		       		location.href='${ pageContext.request.contextPath }/participant/authentication/' + code;
		       	}
		      })
	  	}
	  
	  	$(document).ready(function(){
	  		$('button').click(function(){
	  			sendLink()
	  		})
	  	})
	  </script>
	  
  </body>
</html>
