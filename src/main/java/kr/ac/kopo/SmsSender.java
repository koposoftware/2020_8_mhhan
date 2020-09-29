package kr.ac.kopo;

import org.springframework.stereotype.Service;

//Install the Java helper library from twilio.com/docs/libraries/java
import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;

import kr.ac.kopo.participant.vo.ParticipantVO;

@Service
public class SmsSender {
 // Find your Account Sid and Auth Token at twilio.com/console
	 public static final String ACCOUNT_SID =
	         "";
	 public static final String AUTH_TOKEN =
	         "";
	 
//	 public static void main(String[] args) {
//	     Twilio.init(ACCOUNT_SID, AUTH_TOKEN);
//	
//	     Message message = Message
//	             .creator(new PhoneNumber("+821099194276"), // to
//	                     new PhoneNumber("+13236414260"), // from
//	                     "메세지를 입력하세요")
//	             .create();
//	
//	     System.out.println(message.getSid());
//	 }
//////////////////////////////////////////////////////////////////
	 public static final String fromPhoneN = "+13236414260";
	 private Message message;
	 
	 //생성자
	 public SmsSender() {
		 Twilio.init(ACCOUNT_SID, AUTH_TOKEN);
	 }
	 
	 
	 //문자 알림 메소드
	 public void send(String toPhoneNo, String msg) {
		 message = Message
	             .creator(new PhoneNumber("+82" + toPhoneNo.substring(1)), // to
	                     new PhoneNumber(fromPhoneN), // from
	                     msg)
	             .create();
	     System.out.println(message.getSid());
	 }
 

}
