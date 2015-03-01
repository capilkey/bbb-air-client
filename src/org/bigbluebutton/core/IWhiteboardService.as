package org.bigbluebutton.core
{
	public interface IWhiteboardService
	{
		function setupMessageSenderReceiver():void;
		function getAnnotationHistory():void;
		function changePage(pageNum:Number):void;
		function undoGraphic():void;
		function clearBoard():void;
		function sendText():void;
		function sendShape():void;
		function setActivePresentation():void;
	}
}