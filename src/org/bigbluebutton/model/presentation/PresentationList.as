package org.bigbluebutton.model.presentation
{
	import mx.collections.ArrayCollection;
	
	import org.bigbluebutton.model.whiteboard.IAnnotation;
	import org.flexunit.internals.namespaces.classInternal;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public class PresentationList
	{
		private var _presentations:ArrayCollection = new ArrayCollection();
		
		private var _currentPresentation:Presentation;
		private var _currentSlideNum:int = -1;
		
		private var _presentationChangeSignal:ISignal = new Signal();
		private var _slideChangeSignal:ISignal = new Signal();
		private var _viewedRegionChangeSignal:ISignal = new Signal();
		private var _cursorUpdateSignal:ISignal = new Signal();
		
		private var _annotationHistorySignal:ISignal = new Signal();
		private var _annotationUpdatedSignal:ISignal = new Signal();
		private var _annotationUndoSignal:ISignal = new Signal();
		private var _annotationClearSignal:ISignal = new Signal();
		
		public function PresentationList() {
		}
		
		public function addPresentation(presentationName:String):void {
			trace("Adding presentation " + presentationName);
			for (var i:int=0; i < _presentations.length; i++) {
				var p:Presentation = _presentations[i] as Presentation;
				if (p.fileName == presentationName) return;
			}
			_presentations.addItem(new Presentation(presentationName, changeCurrentPresentation));
		}
		
		public function removePresentation(presentationName:String):void {
			for (var i:int=0; i < _presentations.length; i++) {
				var p:Presentation = _presentations[i] as Presentation;
				if (p.fileName == presentationName) {
					trace("Removing presentation " + presentationName);
					_presentations.removeItemAt(i);
				}
			}
		}
		
		public function getPresentation(presentationName:String):Presentation {
			trace("PresentProxy::getPresentation: presentationName=" + presentationName);
			for (var i:int=0; i < _presentations.length; i++) {
				var p:Presentation = _presentations[i] as Presentation;
				if (p.fileName == presentationName) {
					return p;
				}
			}
			return null;
		}
		
		public function cursorUpdate(xPercent:Number, yPercent:Number):void {
			if (_currentPresentation != null && _currentSlideNum >= 0) {
				_cursorUpdateSignal.dispatch(xPercent, yPercent);
			}
		}
		
		public function addAnnotationHistory(presentationID:String, pageNumber:int, annotationArray:Array):void {
			var presentation:Presentation = getPresentation(presentationID);
			if (presentation != null) {
				if (presentation.addAnnotationHistory(pageNumber, annotationArray)) {
					if (presentation == _currentPresentation && pageNumber == _currentSlideNum) {
						_annotationHistorySignal.dispatch();
					}
				}
			}
		}
		
		public function addAnnotation(annotation:IAnnotation):void {
			var presentation:Presentation = getPresentation(annotation.presentationID);
			if (presentation != null) {
				var newAnnotation:IAnnotation = presentation.addAnnotation(annotation.pageNumber, annotation);
				if (newAnnotation != null && presentation == _currentPresentation && annotation.pageNumber == _currentSlideNum) {
					_annotationUpdatedSignal.dispatch(newAnnotation);
				}
			}
		}
		
		public function clearAnnotations():void {
			if (_currentPresentation != null && _currentSlideNum >= 0) {
				if (_currentPresentation.clearAnnotations(_currentSlideNum)) {
					_annotationClearSignal.dispatch();
				}
			}
		}
		
		public function undoAnnotation():void {
			if (_currentPresentation != null && _currentSlideNum >= 0) {
				var removedAnnotation:IAnnotation = _currentPresentation.undoAnnotation(_currentSlideNum);
				if (removedAnnotation != null) {
					_annotationUndoSignal.dispatch(removedAnnotation);
				}
			}
		}
		
		public function setViewedRegion(x:Number, y:Number, widthPercent:Number, heightPercent:Number):void {
			if (_currentPresentation != null && _currentSlideNum >= 0) {
				if (_currentPresentation.setViewedRegion(_currentSlideNum, x, y, widthPercent, heightPercent)) {
					_viewedRegionChangeSignal.dispatch(x, y, widthPercent, heightPercent);
				}
				
			}
		}
		
		private function changeCurrentPresentation(p:Presentation, currentSlideNum:int):void {
			currentPresentation = p;
			this.currentSlideNum = currentSlideNum;
		}
		
		public function get currentPresentation():Presentation {
			return _currentPresentation;
		}
		
		public function set currentPresentation(p:Presentation):void {
			trace("PresentationList changing current presentation");
			_currentPresentation = p;
			_presentationChangeSignal.dispatch();
		}
		
		public function get currentSlideNum():int {
			return _currentSlideNum;
		}
		
		public function set currentSlideNum(n:int):void {
			if (_currentPresentation != null) {
				trace("PresentationList changing current slide");
				_currentSlideNum = n;
				_slideChangeSignal.dispatch();
			}
		}
		
		public function get presentationChangeSignal():ISignal {
			return _presentationChangeSignal;
		}
		
		public function get slideChangeSignal():ISignal {
			return _slideChangeSignal;
		}
		
		public function get viewedRegionChangeSignal():ISignal {
			return _viewedRegionChangeSignal;
		}
		
		public function get cursorUpdateSignal():ISignal {
			return _cursorUpdateSignal;
		}
		
		public function get annotationHistorySignal():ISignal {
			return _annotationHistorySignal;
		}
		
		public function get annotationUpdatedSignal():ISignal {
			return _annotationUpdatedSignal;
		}
		
		public function get annotationUndoSignal():ISignal {
			return _annotationUndoSignal;
		}
		
		public function get annotationClearSignal():ISignal {
			return _annotationClearSignal;
		}
	}
}