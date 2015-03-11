package org.bigbluebutton.view.navigation.pages.presentation
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.core.FlexGlobals;
	
	import org.bigbluebutton.command.LoadSlideSignal;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.presentation.Presentation;
	import org.bigbluebutton.model.presentation.Slide;
	import org.bigbluebutton.util.CursorIndicator;
	import org.osmf.logging.Log;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class PresentationViewMediator extends Mediator
	{
		[Inject]
		public var view: IPresentationView;
		
		[Inject]
		public var userSession: IUserSession;
		
		[Inject]
		public var loadSlideSignal: LoadSlideSignal;
		
		private var _currentPresentation:Presentation;
		private var _currentSlideNum:int = -1;
		private var _currentSlide:Slide;
		private var _slideModel:SlideModel = new SlideModel();
		private var _cursor:CursorIndicator = new CursorIndicator();
		
		override public function initialize():void
		{
			Log.getLogger("org.bigbluebutton").info(String(this));
			
			userSession.presentationList.presentationChangeSignal.add(presentationChangeHandler);
			userSession.presentationList.slideChangeSignal.add(slideChangeHandler);
			userSession.presentationList.viewedRegionChangeSignal.add(viewedRegionChangeHandler);
			userSession.presentationList.cursorUpdateSignal.add(cursorUpdateHandler);
			
			view.slide.addEventListener(Event.COMPLETE, handleLoadingComplete);
			
			_slideModel.parentChange(view.content.width, view.content.height);
			
			setPresentation(userSession.presentationList.currentPresentation);
			setCurrentSlideNum(userSession.presentationList.currentSlideNum);
			FlexGlobals.topLevelApplication.backBtn.visible = false;
			FlexGlobals.topLevelApplication.profileBtn.visible = true;
		}
		
		private function displaySlide():void {
			if (_currentSlide != null) {
				_currentSlide.slideLoadedSignal.remove(slideLoadedHandler);
			}
			
			if (_currentPresentation != null && _currentSlideNum >= 0) {
				_currentSlide = _currentPresentation.getSlideAt(_currentSlideNum);
				if (_currentSlide != null) {
					if (_currentSlide.loaded && view != null) {
						view.setSlide(_currentSlide);
					} else {
						_currentSlide.slideLoadedSignal.add(slideLoadedHandler);
						loadSlideSignal.dispatch(_currentSlide, _currentPresentation.fileName);
					}
				}
			} else if (view != null) {
				view.setSlide(null);
			}
		}
		
		private function viewedRegionChangeHandler(x:Number, y:Number, widthPercent:Number, heightPercent:Number):void {
			resetSize(x, y, widthPercent, heightPercent);
		}
		
		private function handleLoadingComplete(e:Event):void {
			_slideModel.resetForNewSlide(view.slide.contentWidth, view.slide.contentHeight);
			var currentSlide:Slide = userSession.presentationList.currentPresentation.getSlideAt(_currentSlideNum);
			if (currentSlide) {
				resetSize(currentSlide.x, currentSlide.y, currentSlide.widthPercent, currentSlide.heightPercent);
			}
		}
		
		private function resetSize(x:Number, y:Number, widthPercent:Number, heightPercent:Number):void {
			_slideModel.calculateViewportNeededForRegion(widthPercent, heightPercent);
			_slideModel.displayViewerRegion(x, y, widthPercent, heightPercent);
			_slideModel.calculateViewportXY();
			_slideModel.displayPresenterView();
			setViewportSize();
			fitLoaderToSize();
			//fitSlideToLoader();
			zoomCanvas(view.slide.x, view.slide.y, view.slide.width, view.slide.height, 1/Math.max(widthPercent/100, heightPercent/100));
		}
		
		private function setViewportSize():void {
			view.viewport.x = _slideModel.viewportX;
			view.viewport.y = _slideModel.viewportY;
			view.viewport.height = _slideModel.viewportH;
			view.viewport.width = _slideModel.viewportW;
		}
		
		private function fitLoaderToSize():void {
			view.slide.x = _slideModel.loaderX;
			view.slide.y = _slideModel.loaderY;
			view.slide.width = _slideModel.loaderW;
			view.slide.height = _slideModel.loaderH;
		}
		
		public function zoomCanvas(x:Number, y:Number, width:Number, height:Number, zoom:Number):void{
			view.whiteboardCanvas.moveCanvas(x, y, width, height, zoom);
		}
		
		private function resizeWhiteboard():void {
			view.whiteboardCanvas.height = view.slide.height;
			view.whiteboardCanvas.width = view.slide.width;
			view.whiteboardCanvas.x = view.slide.x;
			view.whiteboardCanvas.y = view.slide.y;
		}
		
		private function cursorUpdateHandler(xPercent:Number, yPercent:Number):void {
			_cursor.draw(view.viewport, xPercent, yPercent);
		}
		
		private function presentationChangeHandler():void {
			setPresentation(userSession.presentationList.currentPresentation);
		}
		
		private function slideChangeHandler():void {
			setCurrentSlideNum(userSession.presentationList.currentSlideNum);
			_cursor.remove(view.viewport);
		}
		
		private function setPresentation(p:Presentation):void {
			_currentPresentation = p;
			if (_currentPresentation != null) {
				view.setPresentationName(_currentPresentation.fileName);
			} else {
				view.setPresentationName("");
			}
		}
		
		private function setCurrentSlideNum(n:int):void {
			_currentSlideNum = userSession.presentationList.currentSlideNum;
			displaySlide();
		}
		
		private function slideLoadedHandler():void {
			displaySlide();
		}
		
		override public function destroy():void
		{
			view.slide.removeEventListener(Event.COMPLETE, handleLoadingComplete);
			
			userSession.presentationList.presentationChangeSignal.remove(presentationChangeHandler);
			userSession.presentationList.slideChangeSignal.remove(slideChangeHandler);
			userSession.presentationList.viewedRegionChangeSignal.remove(viewedRegionChangeHandler);
			userSession.presentationList.cursorUpdateSignal.remove(cursorUpdateHandler);
			
			super.destroy();
			
			view.dispose();
			view = null;
		}
	}
}