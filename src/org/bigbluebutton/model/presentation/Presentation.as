package org.bigbluebutton.model.presentation
{
	import org.bigbluebutton.model.whiteboard.AnnotationStatus;
	import org.bigbluebutton.model.whiteboard.IAnnotation;
	
	public class Presentation
	{
		private var _fileName:String = "";
		private var _slides:Vector.<Slide> = new Vector.<Slide>();
		
		private var _changePresentation:Function;
		
		private var _loaded:Boolean = false;
		
		public function Presentation(fileName:String, changePresentation:Function):void {
			_fileName = fileName;
			_changePresentation = changePresentation;
		}
		
		public function get fileName():String {
			return _fileName;
		}
		
		public function get slides():Vector.<Slide> {
			return _slides;
		}
		
		public function getSlideAt(num:int):Slide {
			if (_slides.length > num) {
				return _slides[num];
			}
			trace("getSlideAt failed: Slide index out of bounds");
			return null;
		}
		
		public function add(slide:Slide):void {
			_slides.push(slide);
		}
		
		public function size():uint {
			return _slides.length;
		}
		
		public function finishedLoading():void {
			_loaded = true;
			_changePresentation(this);
		}
		
		public function get loaded():Boolean {
			return _loaded;
		}
		
		public function clear():void {
			_slides = new Vector.<Slide>();
		}
		
		public function addAnnotationHistory(slideNum:int, annotationHistory:Array):Boolean {
			var slide:Slide = getSlideAt(slideNum);
			if (slide != null) {
				for (var i:int = 0; i < annotationHistory.length; i++) {
					slide.addAnnotation(annotationHistory[i]);
				}
				return true;
			}
			return false;
		}
		
		public function addAnnotation(slideNum:int, annotation:IAnnotation):IAnnotation {
			var slide:Slide = getSlideAt(slideNum);
			if (slide != null) {
				if (annotation.status == AnnotationStatus.DRAW_START || annotation.status == AnnotationStatus.TEXT_CREATED) {
					slide.addAnnotation(annotation);
					return annotation;
				} else {
					return slide.updateAnnotation(annotation);
				}
			}
			return null;
		}
	}
}