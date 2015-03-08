package org.bigbluebutton.core
{
	import org.bigbluebutton.model.IMessageListener;
	import org.bigbluebutton.model.IUserSession;
	
	public class PresentMessageReceiver implements IMessageListener
	{
		private var _userSession:IUserSession;
		
		public function PresentMessageReceiver(userSession:IUserSession) {
			_userSession = userSession;
		}
		
		public function onMessage(messageName:String, message:Object):void {
			switch (messageName) {
				case "PresentationCursorUpdateCommand":
					handlePresentationCursorUpdateCommand(message);
					break;			
				default:
			}
		}  
		
		private function handlePresentationCursorUpdateCommand(message:Object):void {
			_userSession.presentationList.cursorUpdate(message.xPercent, message.yPercent);
		}
	}
}