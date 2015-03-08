package org.bigbluebutton
{
	import org.bigbluebutton.command.CameraQualityCommand;
	import org.bigbluebutton.command.CameraQualitySignal;
	import org.bigbluebutton.command.ConnectCommand;
	import org.bigbluebutton.command.ConnectSignal;
	import org.bigbluebutton.command.DisconnectUserCommand;
	import org.bigbluebutton.command.DisconnectUserSignal;
	import org.bigbluebutton.command.LoadPresentationCommand;
	import org.bigbluebutton.command.LoadPresentationSignal;
	import org.bigbluebutton.command.LoadSlideCommand;
	import org.bigbluebutton.command.LoadSlideSignal;
	import org.bigbluebutton.command.ShareCameraCommand;
	import org.bigbluebutton.command.ShareCameraSignal;
	import org.bigbluebutton.command.ShareMicrophoneCommand;
	import org.bigbluebutton.command.ShareMicrophoneSignal;
	import org.bigbluebutton.core.BaseConnection;
	import org.bigbluebutton.core.BigBlueButtonConnection;
	import org.bigbluebutton.core.ChatMessageService;
	import org.bigbluebutton.core.DeskshareConnection;
	import org.bigbluebutton.core.DeskshareService;
	import org.bigbluebutton.core.DeskshareServiceSO;
	import org.bigbluebutton.core.IBaseConnection;
	import org.bigbluebutton.core.IBigBlueButtonConnection;
	import org.bigbluebutton.core.IChatMessageService;
	import org.bigbluebutton.core.IDeskshareConnection;
	import org.bigbluebutton.core.IDeskshareService;
	import org.bigbluebutton.core.IDeskshareServiceSO;
	import org.bigbluebutton.core.IListenersServiceSO;
	import org.bigbluebutton.core.ILoginService;
	import org.bigbluebutton.core.IPresentServiceSO;
	import org.bigbluebutton.core.IPresentationService;
	import org.bigbluebutton.core.IUsersService;
	import org.bigbluebutton.core.IUsersServiceSO;
	import org.bigbluebutton.core.IVideoConnection;
	import org.bigbluebutton.core.IVoiceConnection;
	import org.bigbluebutton.core.IWhiteboardService;
	import org.bigbluebutton.core.ListenersServiceSO;
	import org.bigbluebutton.core.LoginService;
	import org.bigbluebutton.core.PresentServiceSO;
	import org.bigbluebutton.core.PresentationService;
	import org.bigbluebutton.core.UsersService;
	import org.bigbluebutton.core.UsersServiceSO;
	import org.bigbluebutton.core.VideoConnection;
	import org.bigbluebutton.core.VoiceConnection;
	import org.bigbluebutton.core.WhiteboardService;
	import org.bigbluebutton.model.ConferenceParameters;
	import org.bigbluebutton.model.IConferenceParameters;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.UserUISession;
	import org.bigbluebutton.model.chat.ChatMessagesSession;
	import org.bigbluebutton.model.chat.IChatMessagesSession;
	
	import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;
	
	public class AppConfig implements IConfig
	{
		[Inject]
		public var injector: IInjector;
		
		[Inject]
		public var signalCommandMap: ISignalCommandMap;
		
		public function configure(): void
		{
			// Singleton mapping
			injector.map(IUserUISession).toSingleton(UserUISession);
			injector.map(IUserSession).toSingleton(UserSession);
			injector.map(IConferenceParameters).toSingleton(ConferenceParameters);
			injector.map(IUsersService).toSingleton(UsersService);
			injector.map(IChatMessageService).toSingleton(ChatMessageService);
			injector.map(IPresentationService).toSingleton(PresentationService);
			injector.map(IWhiteboardService).toSingleton(WhiteboardService);
			injector.map(IChatMessagesSession).toSingleton(ChatMessagesSession);
			injector.map(IDeskshareConnection).toSingleton(DeskshareConnection);
			injector.map(IDeskshareService).toSingleton(DeskshareService);
			
			// Type mapping
			injector.map(IBaseConnection).toType(BaseConnection);	
			injector.map(IVoiceConnection).toType(VoiceConnection);
			injector.map(ILoginService).toType(LoginService);
			injector.map(IBigBlueButtonConnection).toType(BigBlueButtonConnection);
			injector.map(IVideoConnection).toType(VideoConnection);
			
			injector.map(IUsersServiceSO).toType(UsersServiceSO);
			injector.map(IListenersServiceSO).toType(ListenersServiceSO);
			injector.map(IPresentServiceSO).toType(PresentServiceSO);
			injector.map(IDeskshareServiceSO).toType(DeskshareServiceSO);
			
			// Signal to Command mapping
			signalCommandMap.map(ConnectSignal).toCommand(ConnectCommand);
			signalCommandMap.map(ShareMicrophoneSignal).toCommand(ShareMicrophoneCommand);
			signalCommandMap.map(ShareCameraSignal).toCommand(ShareCameraCommand);
			signalCommandMap.map(LoadPresentationSignal).toCommand(LoadPresentationCommand);
			signalCommandMap.map(LoadSlideSignal).toCommand(LoadSlideCommand);
			signalCommandMap.map(CameraQualitySignal).toCommand(CameraQualityCommand);
			signalCommandMap.map(DisconnectUserSignal).toCommand(DisconnectUserCommand);
		}
	}
}