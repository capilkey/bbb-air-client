package org.bigbluebutton.model.whiteboard
{
	import org.bigbluebutton.view.navigation.pages.whiteboard.IWhiteboardCanvas;
	
	import spark.primitives.supportClasses.GraphicElement;

	public class Annotation extends GraphicElement implements IAnnotation {
		private var _type:String = "undefined";
		private var _anID:String = "undefined";
		private var _presentationID:String;
		private var _pageNumber:int;
		private var _status:String = AnnotationStatus.DRAW_START;
		private var _color:Number;
		
		public function Annotation(type:String, anID:String, presentationID:String, pageNumber:int, status:String, color:Number) {
			_type = type;
			_anID = anID;
			_presentationID = presentationID;
			_pageNumber = pageNumber;
			_status = status;
			_color = color;
		}
		
		public function get type():String{
			return _type;
		}
		
		public function get anID():String {
			return _anID;
		}
		
		public function get presentationID():String {
			return _presentationID;
		}
		
		public function get pageNumber():int {
			return _pageNumber;
		}
		
		public function get status():String {
			return _status;
		}
		
		public function get color():Number {
			return _color;
		}
		
		public function update(an:IAnnotation):void {
			if (an.anID == this.anID) {
				_color = an.color;
			}
		}
		
		public function denormalize(val:Number, side:Number):Number {
			return (val*side)/100.0;
		}
		
		public function normalize(val:Number, side:Number):Number {
			return (val*100.0)/side;
		}
		
		public function draw(canvas:IWhiteboardCanvas, zoom:Number):void {
			
		}
		
		public function remove(canvas:IWhiteboardCanvas):void {
			
		}
	}
}