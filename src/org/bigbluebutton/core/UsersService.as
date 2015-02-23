package org.bigbluebutton.core
{
	import org.bigbluebutton.model.IConferenceParameters;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.User;
	
	public class UsersService implements IUsersService
	{
		[Inject]
		public var usersServiceSO: IUsersServiceSO;
		
		[Inject]
		public var listenersServiceSO: IListenersServiceSO;
		
		[Inject]
		public var conferenceParameters: IConferenceParameters;
		
		[Inject]
		public var userSession: IUserSession;
		
		public function UsersService()
		{
		}
		
		public function connectUsers(uri:String):void {
			usersServiceSO.connect(userSession.mainConnection.connection, uri, conferenceParameters);
		}
		
		public function connectListeners(uri:String):void {
			listenersServiceSO.connect(userSession.mainConnection.connection, uri, conferenceParameters);
		}
		
		public function muteMe():void {
			mute(userSession.userList.me);
		}
		
		public function unmuteMe():void {
			unmute(userSession.userList.me);
		}
		
		public function mute(user:User):void {
			muteUnmute(user, true);
		}
		
		public function unmute(user:User):void {
			muteUnmute(user, false);
		}
		
		private function muteUnmute(user:User, mute:Boolean):void {
			if (user.voiceJoined) {
				listenersServiceSO.muteUnmuteUser(user.voiceUserId, mute);
			}
		}
		
		public function addStream(userId:String, streamName:String):void {
			usersServiceSO.addStream(userId, streamName);
		}
		
		public function removeStream(userId:String, streamName:String):void {
			usersServiceSO.removeStream(userId, streamName);
		}
		
		public function disconnect():void {
			usersServiceSO.disconnect();
			listenersServiceSO.disconnect();
		}
		
		public function raiseHand(userID:String, raise:Boolean):void
		{
			usersServiceSO.raiseHand(userID, raise);
		}
	}
}