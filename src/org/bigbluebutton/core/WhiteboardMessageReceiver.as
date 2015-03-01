package org.bigbluebutton.core
{
	import org.bigbluebutton.model.IMessageListener;

	public class WhiteboardMessageReceiver implements IMessageListener
	{
		private static var LOG:String = "WhiteboardMessageReciever - ";
		
		public function WhiteboardMessageReceiver() {
			
		}
		
		public function onMessage(messageName:String, message:Object):void {
			// LogUtil.debug("WB: received message " + messageName);
			
			switch (messageName) {
				case "WhiteboardRequestAnnotationHistoryReply":
					handleRequestAnnotationHistoryReply(message);
					break;
				case "WhiteboardIsWhiteboardEnabledReply":
					handleIsWhiteboardEnabledReply(message);
					break;
				case "WhiteboardEnableWhiteboardCommand":
					handleEnableWhiteboardCommand(message);
					break;    
				case "WhiteboardNewAnnotationCommand":
					handleNewAnnotationCommand(message);
					break;  
				case "WhiteboardClearCommand":
					handleClearCommand(message);
					break;  
				case "WhiteboardUndoCommand":
					handleUndoCommand(message);
					break;  
				case "WhiteboardChangePageCommand":
					handleChangePageCommand(message);
					break; 
				case "WhiteboardChangePresentationCommand":
					handleChangePresentationCommand(message);
					break; 				
				default:
					//          LogUtil.warn("Cannot handle message [" + messageName + "]");
			}
		}
		
		private function handleChangePresentationCommand(message:Object):void {
//			whiteboardModel.changePresentation(message.presentationID, message.numberOfPages);
		}
		
		private function handleChangePageCommand(message:Object):void {
//			whiteboardModel.changePage(message.pageNum, message.numAnnotations);
		}
		
		private function handleClearCommand(message:Object):void {
//			whiteboardModel.clear();
		}
		
		private function handleUndoCommand(message:Object):void {
//			whiteboardModel.undo();
		}
		
		private function handleEnableWhiteboardCommand(message:Object):void {
			//whiteboardModel.enable(message.enabled);
		}
		
		private function handleNewAnnotationCommand(message:Object):void {
			if (message.type == undefined || message.type == null || message.type == "") return;
			if (message.id == undefined || message.id == null || message.id == "") return;
			if (message.status == undefined || message.status == null || message.status == "") return;
			
			trace(LOG + "handleNewAnnotationCommand received");
			
//			var annotation:Annotation = new Annotation(message.id, message.type, message);
//			annotation.status = message.status;
//			whiteboardModel.addAnnotation(annotation);
		}
		
		private function handleIsWhiteboardEnabledReply(message:Object):void {
			//LogUtil.debug("Whiteboard Enabled? " + message.enabled);
		}
		
		private function handleRequestAnnotationHistoryReply(message:Object):void {				
			if (message.count == 0) {
				trace(LOG + "handleRequestAnnotationHistoryReply: No annotations.");
			} else {
				trace(LOG + "handleRequestAnnotationHistoryReply: Number of annotations in history = " + message.count);
				var annotations:Array = message.annotations as Array;
				var tempAnnotations:Array = new Array();
				
				for (var i:int = 0; i < message.count; i++) {
					var an:Object = annotations[i] as Object;
					
					if (an.type == undefined || an.type == null || an.type == "") return;
					if (an.id == undefined || an.id == null || an.id == "") return;
					if (an.status == undefined || an.status == null || an.status == "") return;
					
					//LogUtil.debug("handleRequestAnnotationHistoryReply: annotation id=" + an.id);
					
		//			var annotation:Annotation = new Annotation(an.id, an.type, an);
		//			annotation.status = an.status;
		//			tempAnnotations.push(annotation);
				}   
				
				if (tempAnnotations.length > 0) {
		//			whiteboardModel.addAnnotationFromHistory(message.presentationID, message.pageNumber, tempAnnotations);
				}
			}
		}
	}
}