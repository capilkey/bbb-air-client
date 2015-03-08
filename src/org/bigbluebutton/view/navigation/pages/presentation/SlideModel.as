package org.bigbluebutton.view.navigation.pages.presentation
{
	public class SlideModel
	{
		public static const MAX_ZOOM_PERCENT:Number = 400;
		public static const HUNDRED_PERCENT:Number = 100;
		
		public var viewportX:Number = 0;
		public var viewportY:Number = 0;
		public var viewportW:Number = 0;
		public var viewportH:Number = 0;
		
		public var loaderW:Number = 0;
		public var loaderH:Number = 0;
		public var loaderX:Number = 0;
		public var loaderY:Number = 0;
		
		private var _viewedRegionX:Number = 0;
		private var _viewedRegionY:Number = 0;
		private var _viewedRegionW:Number = HUNDRED_PERCENT;
		private var _viewedRegionH:Number = HUNDRED_PERCENT;
		
		private var _pageOrigW:Number = 0;
		private var _pageOrigH:Number = 0;
		private var _calcPageW:Number = 0;
		private var _calcPageH:Number = 0;
		private var _calcPageX:Number = 0;
		private var _calcPageY:Number = 0;
		private var _parentW:Number = 0;
		private var _parentH:Number = 0;
		
		public function SlideModel()
		{
		}
		
		public function resetForNewSlide(pageWidth:Number, pageHeight:Number):void {
			_pageOrigW = pageWidth;
			_pageOrigH = pageHeight;
		}
		
		public function parentChange(parentW:Number, parentH:Number):void {
			viewportW = _parentW = parentW;
			viewportH = _parentH = parentH;
		}
		
		public function calculateViewportNeededForRegion():void {			
			var vrwp:Number = _pageOrigW * (_viewedRegionW/HUNDRED_PERCENT);
			var vrhp:Number = _pageOrigH * (_viewedRegionH/HUNDRED_PERCENT);
			
			if (_parentW < _parentH) {
				viewportW = _parentW;
				viewportH = (vrhp/vrwp)*_parentW;				 
				if (_parentH < viewportH) {
					viewportH = _parentH;
					viewportW = ((vrwp * viewportH)/vrhp);
				}
			} else {
				viewportH = _parentH;
				viewportW = (vrwp/vrhp)*_parentH;
				if (_parentW < viewportW) {
					viewportW = _parentW;
					viewportH = ((vrhp * viewportW)/vrwp);
				}
			}
		}
		
		public function displayViewerRegion():void {
			_calcPageW = viewportW/(_viewedRegionW/HUNDRED_PERCENT);
			_calcPageH = viewportH/(_viewedRegionH/HUNDRED_PERCENT);
			_calcPageX = (_viewedRegionX/HUNDRED_PERCENT) * _calcPageW;
			_calcPageY = (_viewedRegionY/HUNDRED_PERCENT) * _calcPageH;
		}
		
		public function calculateViewportXY():void {
			viewportX = SlideCalcUtil.calculateViewportX(viewportW, _parentW);
			viewportY = SlideCalcUtil.calculateViewportY(viewportH, _parentH);			
		}
		
		public function displayPresenterView():void {
			loaderX = Math.round(_calcPageX);
			loaderY = Math.round(_calcPageY);
			loaderW = Math.round(_calcPageW);
			loaderH = Math.round(_calcPageH);
		}
	}
}