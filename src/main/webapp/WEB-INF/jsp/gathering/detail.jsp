<%@page import="java.sql.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
	<!-- 아이콘 -->
	<script src="https://kit.fontawesome.com/925e80bab6.js"></script>		
	<!-- head BEGIN -->
		<jsp:include page="/WEB-INF/jsp/include/head.jsp" /> 
	<!-- head END -->
</head>
<body>
	<!-- header BEGIN -->
		<jsp:include page="/WEB-INF/jsp/include/header.jsp" />
	<!-- header END -->
    
  <section class="section pb-0" style="  background-repeat: no-repeat;background-size: cover;background-image:url(${ pageContext.request.contextPath }/resources/img/coffe4.jpg)">
  
      <div class="container">
      <div class="row slider-text align-items-center justify-content-center mb-5 element-animate fadeInUp element-animated text-center">
            <div class="col-md-7 col-sm-12 element-animate">

              <h2 class="text-uppercase heading border-bottom mb-4" style="font-weight:600">${gathering.name}</h2>   
              <c:choose>
              <c:when test="${gathering.id == loginVO.id }">
              	<p class="mb-0 lead" style="color: #6c757d;">${fn:substring(gathering.accountNo, 0, 3)}-${fn:substring(gathering.accountNo, 3, 9)}-${fn:substring(gathering.accountNo, 9, 14)}</p>
              </c:when>
              <c:otherwise>
              	<p class="mb-0 lead" style="color: #6c757d;">${fn:substring(gathering.safeAccountNo, 0, 4)}-${fn:substring(gathering.safeAccountNo, 4, 6)}-${fn:substring(gathering.safeAccountNo, 6, 11)}</p>
              </c:otherwise>
              </c:choose>
			  <h2 class="text-uppercase heading mb-4"><fmt:formatNumber value="${gathering.balance}" pattern="#,###.##" />원</h2>
			
			
			<div id="participantListDiv">
			
				<c:forEach items="${participantList}">
					<span style="font-size: 2em; color:Tomato;">
					  <a data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">
					    <i class="fas fa-user-circle" style="color:gray;"></i>
					  </a>
					</span>
				</c:forEach>

				<div class="collapse" id="collapseExample">
				  <div class="card card-body">
				  		참여중 멤버(${fn:length(participantList)})
				   	<table class="table">
				   		<c:forEach items="${participantList}" var="participant">
				   			<c:choose>
					   			<c:when test="${participant.type == '301'}">
					   				<c:set var="holder" value="${participant.name}"/>
					   				<c:if test="${gathering.id == loginVO.id }">
					   					<a id="kakao-link-btn" href="javascript:sendLink()">초대</a>
							   		</c:if>
							   		<tr>
							   			<td>
										   	<span style="font-size: 2em; color: Tomato;">
											    <i class="fas fa-user-circle" style="color:gray;"></i>
											</span>${participant.name}★
							   			</td>
							   			<td>
							   				<span class="d-none">d</span>
							   			</td>
							   		</tr>					   				
					   			</c:when>
					   			<c:otherwise>
							   		<tr>
							   			<td>
										   	<span style="font-size: 2em; color: Tomato;">
											    <i class="fas fa-user-circle" style="color:gray;"></i>
											</span>${participant.name}
							   			</td>
							   			<td>
							   				<c:if test="${gathering.id == loginVO.id }">
							   					<input type="button" value="멤버끊기" id="${participant.id}" name="${participant.name}" class="expel btn btn-primary">
							   				</c:if>
							   			</td>
							   		</tr>					   			
					   			</c:otherwise>
				   			</c:choose>
				   		</c:forEach>

				   	</table>	
				  </div>
				</div>		
				
			</div>	
				
        </div>
      </div>
      </div>
      
      <div id="DetailtabWrap">
    	 <ul class="Detailtabul">
    	 	<li class="Detailtabli li0on" id="li0"><a href="#" onclick="javascript:transaction();return false;">거래내역</a></li>
    	 	<li class="Detailtabli" id="li1"><a href="#" onclick="javascript:dues();return false;">회비내역</a></li>
    	 	<li class="Detailtabli" id="li2"><a href="#" onclick="javascript:settings();return false;">모임설정</a></li>
    	 	<li class="Detailtabli" id="li3"><a href="#" onclick="javascript:calendar();return false;">일정관리</a></li>
    	 </ul> 
      </div>
    
    </section>
    <!-- END slider -->
    
    <section class="section pt-0">
      <div class="container">
        <div class="row mb-5">

          <div id="content" class="col-md-12 order-lg-1 pt-4">

			  <h3 id="transaction" class="table-title">거래내역</h3>
			  	<div>
					<table class="hTable"> <!-- class="table-bordered table info-table" -->
						<thead class="hHead">	
							<tr>
								<th>일시</th>
								<th>거래 대상</th>
								<th>거래 구분</th>
								<th>금액</th>
								<th>거래 후 잔액</th>
							</tr>	
						</thead>
						<tbody class="hBody">				
							<c:forEach items="${transactionList}" var="transaction" varStatus="loop">
								<tr>
									<td>${transaction.time}</td>
									<td>
										<c:choose>
											<c:when test="${not empty transaction.indication}">
												${transaction.indication}
											</c:when>
											<c:otherwise>
												${transaction.counterpart}
											</c:otherwise>
										</c:choose>
									</td>
									<td>
										<c:choose>
											<c:when test="${transaction.classification == '401'}">
												입금
											</c:when>
											<c:when test="${transaction.classification == '402'}">
												출금
											</c:when>
										</c:choose>
									</td>
									
										<c:choose>
											<c:when test="${transaction.classification == '401'}">
												<td class="text-right" style="color:#27b2a5;"> <fmt:formatNumber value="${transaction.amount}" pattern="+#,###.##" /></td>
											</c:when>
											<c:when test="${transaction.classification == '402'}">
												<td class="text-right" style="color:red;"> <fmt:formatNumber value="${transaction.amount}" pattern="-#,###.##" /></td>
											</c:when>
										</c:choose>					
									<td><fmt:formatNumber value="${transaction.balance}" pattern="#,###.##" /></td>
									<%-- <td>${transaction.memo}</td> --%>
								</tr>
							</c:forEach>
						</tbody>
					</table>			  		
			  	</div>
			  	
				<form id="excelForm" name="excelForm" method="post" action="${ pageContext.request.contextPath }/excelDownload">
					<input type="hidden" name="safeAccountNo" value="${gathering.safeAccountNo}">
					<input type="hidden" name="accountNo" value="${gathering.accountNo}">
					<input type="hidden" name="id" value="${gathering.id}">
					<input type="submit" class="excelDownBtn" value="거래내역 다운로드" />
					<img alt="excel" src="${ pageContext.request.contextPath }/resources/img/excel-png.png" style="width:2em;height:2em;float:right;">
				</form> 

    
        </div>
       </div>
       </div>
      </section>   
    
  
    <section class="section">
    </section>


	<!-- footer BEGIN -->
		<jsp:include page="/WEB-INF/jsp/include/footer.jsp" /> 
    <!-- footer END -->

    <!-- loader -->
    <div id="loader" class="show fullscreen"><svg class="circular" width="48px" height="48px"><circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/><circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#f4b214"/></svg></div>

  
  
<script>
<!-- 탭 -->
	<!-- 거래내역 -->
	function transaction(){
        $.ajax({
        	url : '${ pageContext.request.contextPath }/transaction/list',
        	type : 'post', 
        	data : {
				accountNo : ${gathering.accountNo}, 
				safeAccountNo : ${gathering.safeAccountNo}
        	},   
        	success : function(data){   
				$('#content').empty();
				$('#content').html(data); 
        	}, error : function(){
        		alert('문제가 생겼습니다. 다시 시도해주세요.');
        	}
        }) 
	} 
	
	<!-- 회비내역 --> 
	function dues(){
        $.ajax({
        	url : '${ pageContext.request.contextPath }/dues/list',
        	type : 'post', 
        	data : {
				accountNo : ${gathering.accountNo}, 
				safeAccountNo : ${gathering.safeAccountNo}
        	},   
        	success : function(data){   
				$('#content').empty();
				$('#content').html(data); 
        	}, error : function(){
        		alert('문제가 생겼습니다. 다시 시도해주세요.');
        	}
        }) 
	} 
	
	<!-- 관리 --> 
	function settings(){
        $.ajax({
        	url : '${ pageContext.request.contextPath }/gathering/settings',
        	type : 'post', 
        	data : {
				accountNo : ${gathering.accountNo}, 
				safeAccountNo : ${gathering.safeAccountNo}
        	},   
        	success : function(data){    
				$('#content').empty();
				$('#content').html(data); 
        	}, error : function(){
        		alert('문제가 생겼습니다. 다시 시도해주세요.');
        	}
        })  
	} 
	
	<!-- 일정관리 --> 
	function calendar(){
        $.ajax({
        	url : '${ pageContext.request.contextPath }/calendar',
        	type : 'get',  
        	success : function(data){    
				$('#content').empty();
				$('#content').html(data);   
        	}, error : function(){
        		alert('문제가 생겼습니다. 다시 시도해주세요.');
        	}
        })  
	}
	
	
	<!-- 탭 클릭 시 css바꾸기 -->
   	$(document).ready(function(){
   		$('.Detailtabli').click(function(){
   			let index = $('.Detailtabli').index(this);
    		for(let i = 0; i < 4; i++){
   				$("#li" + i).removeClass('li' + i + 'on');
   			}
   			$(".Detailtabli:eq(" + index + ")").addClass("li" + index + "on");
   		})
   	})
</script>	
 
 
      
    <!-- 카카오톡 초대 -->
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
  			let code = '${ gathering.safeAccountNo }' + authenticationNum
		    Kakao.Link.sendCustom({
		        templateId: 35968,
		        //url: /hanati/participant/invite/${param}		//param은 안심계좌번호
		        templateArgs: {
		          title:
		        	  '${holder}',
		          description:
		        	  '${gathering.name}',
		       		param:
		       			code	       		  
		        },	callback: function(){
		       		alert("초대 메세지가 전송되었습니다");
		       		location.href='${ pageContext.request.contextPath }/participant/authentication/' + code;
		       	}
		      })
	  	}
	  </script>
	
	
	<!-- 카카오톡 메세지 -->
	<script>
	$(document).ready(function(){
		$("input:radio[name=chk_message]").click(function(){
			if($("input[name=chk_message]:checked").val() == "requestDues"){
				let $img = $('<img src="${ pageContext.request.contextPath }/resources/img/10_MANANDGIRL.png" width="100%" height="30%">');
				let $input = $('<input type="text" id="requestDuesAmount">')
				$('#messageContent').empty();
				$('#messageContent').append($img);
				$('#messageContent').append("요청할 금액 : ");
				$('#messageContent').append($input);
				$('#messageContent').append("원");
			}else if($("input[name=chk_message]:checked").val() == "shareStatus"){
				let $img = $('<img src="${ pageContext.request.contextPath }/resources/img/6_BIRD.png" width="100%" height="30%">');
				$('#messageContent').empty();
				$('#messageContent').append($img);
			}	
		})
	})

	  function sendMessage() {
		//회비 요청
		if($("input[name=chk_message]:checked").val() == "requestDues"){	
			
		    Kakao.Link.sendCustom({
		        templateId: 36914,
		        templateArgs: {
		        	amount:
		        	  $('#requestDuesAmount').val(),
		        	safeAccountNo:
		        	  '${gathering.safeAccountNo}',
		        	  name:
		        	   '${gathering.name}',	       		  
		        	   holder:
		        		'${holder}'
		        },	callback: function(){
		       		alert("메세지카드가 전송되었습니다");
		       	}
		      })    
		//현황 공유	
		}else if($("input[name=chk_message]:checked").val() == "shareStatus"){
			
		    Kakao.Link.sendCustom({
		        templateId: 36915,
		        templateArgs: {
		        	dues:
							'${totalMonthAmount}',
		        	  balance:
		        	  	'${gathering.balance}',
		        	  count:
							'${totalCnt}',
		       			name:
		       				'${gathering.name}',
		       			safeAccountNo:
		       				'${gathering.safeAccountNo}'
		        },	callback: function(){
		       		alert("메세지카드가 전송되었습니다");
		       		location.href='${ pageContext.request.contextPath }/participant/authentication/' + code;
		       	}
		      })
			
		}
	}
	</script>
	

		    
<script>	
		<!-- 멤버 내보내기 -->
		$(document).ready(function(){
		    $('.expel').click(function(){	
		    	let name = $(this).attr('name');
	        	$.ajax({
	            	url : '${ pageContext.request.contextPath }/participant/expel',
	            	type : 'post',
	            	data : {
	            		id : $(this).attr('id'), 
	            		accountNo : ${gathering.accountNo}
	            	}, 
	            	success : function(data){
	            		$('#participantListDiv').empty();
	            		$('#participantListDiv').html(data);
	            		alert(name + '님을 내보냈습니다.');
	            	}, error : function(){
	            		alert('문제가 생겼습니다. 다시 시도해주세요.');
	            	}
	            })    
        	})
	}) 
		
</script>			 
			


  </body>
</html>
