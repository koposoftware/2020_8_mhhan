<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%> 

<script src="https://kit.fontawesome.com/925e80bab6.js"></script>   

<script>
    //기간별 회비 입금 내역 조회 에이쟉스
	 $(document).ready(function(){
	        $('#periodList').change(function(){
	            $.ajax({
	            	url : '${ pageContext.request.contextPath }/dues/period',
	            	type : 'post', 
	            	data : {
						accountNo : ${gathering.accountNo}, 
						time : $("#periodList option:selected").val()
	            	}, 
	            	success : function(data){   
						$('#dListByPeriod').empty
						$('#dListByPeriod').html(data);
	            	}, error : function(){
	            		alert('문제가 생겼습니다. 다시 시도해주세요.');
	            	}
	            }) 
	        })
		})  	
    
    
    //멤버별 회비 입금 내역 조회 에이쟉스
    $(document).ready(function(){
		$('.Bymember').click(function(){
			$.ajax({
				url: '${ pageContext.request.contextPath }/dues/member',
				type: 'post',
				data: {
					accountNo : ${gathering.accountNo}, 
					name : $(this).attr('id') 
				}, success: function(data){
					$('#dListByMemeber').empty
					$('#dListByMemeber').html(data);
				}, error: function(){
					alert('문제가 생겼습니다. 다시 시도해주세요.');
				}	
			})
		})
	})
	
    <!-- 모임원 클릭하면 색 변하기 -->
   	$(document).ready(function(){
   		$('.Bymember').click(function(){
   			let index = $('.Bymember').index(this);
   			$(".Bymember").css({color:"gray"});
   			$(".Bymember:eq(" + index + ")").css({color:"#27b2a5"});
   		})
   	})
</script>

<!-- 카카오톡 메세지카드 보내기 -->
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script>
	<!-- javaScript 키를 할당하여 초기화 함수를 호출 -->
	Kakao.init('');		//자신의 appkey 삽입
	console.log(Kakao.isInitialized());
</script>	 
<script>
	//카카오톡 메세지
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
    
    
    
    
   	<div style="margin-bottom:15px;">
  		<h3 id="duesStatus" class="table-title" style="display:inline;">회비 입금 현황</h3>
  		<c:if test="${gathering.id == loginVO.id }">
  			<a data-toggle="modal" data-target="#messageCard" 
  				class="sendMessageBtn" style="margin-bottom:15px;margin-left:780px;">메세지카드 보내기</a>
  		</c:if>
  	<div>
		<!-- 탭 -->
		<ul class="nav nav-tabs dues-tabs" id="myTab" role="tablist">
		  <li class="nav-item">
		    <a class="nav-link active" id="period-tab" data-toggle="tab" href="#period" role="tab" aria-controls="period" aria-selected="true">기간별</a>
		  </li>
		  <li class="nav-item">
		    <a class="nav-link" id="memeber-tab" data-toggle="tab" href="#memeber" role="tab" aria-controls="memeber" aria-selected="false">멤버별</a>
		  </li>
		</ul>
		
		<!-- 콘텐츠 -->
		<div class="tab-content" id="myTabContent">
			<!-- 기간별 -->
			<div class="tab-pane fade show active text-center" id="period" role="tabpanel" aria-labelledby="period-tab">
				<!-- 기간 목록 -->
				<select id="periodList" name="periodList">
					<c:choose>
						<%-- 입금 내역이 하나도 없을 경우 --%>
						<c:when test="${empty periodList}">
							<option value="${fn:substring(date, 0, 4)}년 ${fn:substring(date, 5, 7)}월">${fn:substring(date, 0, 4)}년 ${fn:substring(date, 5, 7)}월</option>
							<option value="${fn:substring(date, 0, 4)}년">${fn:substring(date, 0, 4)}년</option>
						</c:when>
						<c:otherwise>
							<c:forEach items="${monthList}" var="month" varStatus="loop">
								<c:choose>
									<c:when test="${loop.index == 0}">
										<option value="${month}" selected="selected">${month}</option>	
									</c:when>
									<c:otherwise>
										<option value="${month}">${month}</option>	
									</c:otherwise>
								</c:choose>
							</c:forEach>																		
						</c:otherwise>
					</c:choose>
				</select>			
				
				<c:set var="totalMonthAmount" value="0"/>
				<c:forEach items="${duesList}" var="dues">
					<c:if test="${fn:substring(dues.time, 0, 7) == date}">
						<c:set var="totalMonthAmount" value="${totalMonthAmount + dues.amount}"/>
					</c:if>
				</c:forEach>
				<h2 class="font-weight-bold"><fmt:formatNumber value="${totalMonthAmount}" pattern="#,###.##" />원</h2>						 
								
				<div id="dListByPeriod">
					<c:set var="yearlAmount" value='0'/>						
						<table class="table info-table">
							<c:set var="totalCnt" value="0"/>
						<c:forEach items="${participantList}" var="participant">	
							<tr> <!-- class="duesDetail" name="" value="" -->
								<td>${participant.name}</td>
								<c:set var="cnt" value="0"/>
								<c:set var="totalAmount" value="0"/>
								<c:forEach items="${duesList}" var="dues">
									<c:set var="yearmonth" value="${fn:substring(dues.time, 0, 7)}"/>
									<c:if test="${participant.name == dues.paidMember && yearmonth == date}">
										<c:set var="cnt" value="${cnt+1}"/>
										<c:set var="totalAmount" value="${totalAmount + dues.amount}"/>
									</c:if>
									<c:set var="totalCnt" value="${totalCnt + cnt}"/>
								</c:forEach>
									<td>${cnt}건</td>
									<td><fmt:formatNumber value="${totalAmount}" pattern="#,###.##" />원</td>	
							</tr>
						</c:forEach>
					</table>
				</div>
			</div>
			<!-- 멤버별 -->
			<div class="tab-pane fade" id="memeber" role="tabpanel" aria-labelledby="memeber-tab">
				<!-- 멤버 목록 -->
					<c:forEach items="${participantList}" var="participant" varStatus="loop">
						<span>
							<span style="font-size: 3em; color: gray;">
								<c:choose>
									<c:when test="${loop.index == 0}">
										<i class="fas fa-user-circle Bymember" id="${participant.name}" style="color:#27b2a5;"></i>
									</c:when>		
									<c:otherwise>
										<i class="fas fa-user-circle Bymember" id="${participant.name}"></i>
									</c:otherwise>
								</c:choose>							
							</span>
							${participant.name}
						</span>
					</c:forEach>
					<!-- 회비 내역 -->
					<div id="dListByMemeber">
						<table class="table">
							<c:forEach items="${yearList}" var="year">
								<tr>
									<th>${year}</th>
									<c:set var="yearlAmount" value='0'/>
									<c:forEach items="${duesList}" var="dues">
										<c:if test="${fn:substring(dues.time, 0, 4) == fn:substring(year, 0, 4) 
														&& dues.paidMember == participantList[0].name}">
											<c:set var="yearlAmount" value="${yearlAmount + dues.amount}"/>
										</c:if>
									</c:forEach>
									<th>총 <fmt:formatNumber value="${yearlAmount}" pattern="#,###.##" />원</th>	
								</tr>	
				
								<c:forEach var="i" begin="1" end="12" step="1">
									<fmt:formatNumber type="number" value="${13-i}" var="month" pattern="00"/>
									<c:set var="totalMonthlyAmount" value="0"/>
									<c:forEach items="${duesList}" var="dues">

										<c:if test="${dues.paidMember == participantList[0].name 
															&& fn:substring(dues.time, 0, 4) == fn:substring(year, 0, 4) 
																&& fn:substring(dues.time, 5, 7) == month}">
											<c:set var="totalMonthlyAmount" value="${totalMonthlyAmount + dues.amount}"/>
										</c:if>
									</c:forEach>
									<c:if test="${totalMonthlyAmount != 0}">
										<tr>
											<td>${13-i}월</td>
											<td><fmt:formatNumber value="${totalMonthlyAmount}" pattern="#,###.##" />원</td>
										</tr> 	
									</c:if>
								</c:forEach>
																			
							</c:forEach>
						</table>
					</div>
			</div>
		</div>
  	</div>
  	
  	
	<!-- 메세지 카드 보내기 모달 -->
	<!-- Modal -->
	<div class="modal fade" id="messageCard" tabindex="-1" role="dialog" aria-labelledby="messageCardLabel" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="messageCardLabel">메시지카드 보내기</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	     
	      <div class="modal-body">
	        	<p>카카오톡으로 멤버들에게 메시지카드를 보내보세요.</p>	
				<input type="radio" name="chk_message" value="requestDues">회비 요청
				<input type="radio" name="chk_message" value="shareStatus">현황 공유
				<div id="messageContent"></div>
	      </div>
	      
	      <div class="modal-footer">
	        <button type="button" class="btn btn-warning" onclick="sendMessage()">카카오톡 공유하기</button>
	      </div>
	    </div>
	  </div>
	</div>  
	
	
		
