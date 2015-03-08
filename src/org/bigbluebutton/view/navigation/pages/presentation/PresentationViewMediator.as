package org.bigbluebutton.view.navigation.pages.presentation
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	
	import org.bigbluebutton.command.LoadSlideSignal;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.presentation.Presentation;
	import org.bigbluebutton.model.presentation.Slide;
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
		
		override public function initialize():void
		{
			Log.getLogger("org.bigbluebutton").info(String(this));
			
			userSession.presentationList.presentationChangeSignal.add(presentationChangeHandler);
			userSession.presentationList.slideChangeSignal.add(slideChangeHandler);
			
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
		
		private function handleLoadingComplete(e:Event):void {
			_slideModel.resetForNewSlide(view.slide.contentWidth, view.slide.contentHeight);
			
			resizeSlide();
		}
		
		private function resizeSlide():void {
			_slideModel.calculateViewportNeededForRegion();
			_slideModel.displayViewerRegion();
			_slideModel.calculateViewportXY();
			_slideModel.displayPresenterView();
			setViewportSize();
			fitLoaderToSize();
			fitSlideToLoader();
		}
		
		private function setViewportSize():void {
			view.viewport.x = _slideModel.viewportX;
			view.viewport.y = _slideModel.viewportY;
			view.viewport.height = _slideModel.viewportH;
			view.viewport.width = _slideModel.viewportW;
		}
		
		private function fitLoaderToSize():void {
			view.slide.x = _slideModel.loaderX;
			view.slide.y = _slideModel.loaderY+40;
			view.slide.width = _slideModel.loaderW;
			view.slide.height = _slideModel.loaderH;
		}
		
		private function fitSlideToLoader():void {
			if (view.slide.source == null) return;
			view.slide.content.x = view.slide.x;
			view.slide.content.y = view.slide.y;
			view.slide.content.width = view.slide.width;
			view.slide.content.height = view.slide.height;
			zoomCanvas(view.slide.width, view.slide.height, 1.0);
		}
		
		public function zoomCanvas(width:Number, height:Number, zoom:Number):void{
			//whiteboardCanvasHolder.x = slideLoader.x * SlideCalcUtil.MYSTERY_NUM;
			//whiteboardCanvasHolder.y = slideLoader.y * SlideCalcUtil.MYSTERY_NUM;
			
			view.whiteboardCanvas.moveCanvas(view.slide.x, view.slide.y-40, width, height, zoom);
		}
		
		private function resizeWhiteboard():void {
			view.whiteboardCanvas.height = view.slide.height;
			view.whiteboardCanvas.width = view.slide.width;
			view.whiteboardCanvas.x = view.slide.x;
			view.whiteboardCanvas.y = view.slide.y;
		}
		
		private function presentationChangeHandler():void {
			setPresentation(userSession.presentationList.currentPresentation);
		}
		
		private function slideChangeHandler():void {
			setCurrentSlideNum(userSession.presentationList.currentSlideNum);
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
			
			super.destroy();
			
			view.dispose();
			view = null;
		}
	}
}