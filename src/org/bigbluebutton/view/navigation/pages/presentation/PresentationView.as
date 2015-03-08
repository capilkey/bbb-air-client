package org.bigbluebutton.view.navigation.pages.presentation
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageOrientation;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StageOrientationEvent;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import mx.controls.SWFLoader;
	import mx.core.FlexGlobals;
	import mx.resources.ResourceManager;
	
	import org.bigbluebutton.model.presentation.Slide;
	import org.bigbluebutton.view.navigation.pages.whiteboard.WhiteboardCanvas;
	
	import spark.components.Group;
	import spark.components.Image;
	
	
	public class PresentationView extends PresentationViewBase implements IPresentationView
	{
		override protected function childrenCreated():void
		{
			super.childrenCreated();
		}
		
		public function get content():Group {
			return content0;
		}
		
		public function get viewport():Group {
			return viewport0;
		}
		
		public function get slide():SWFLoader {
			return slide0;
		}
		
		public function get whiteboardCanvas():WhiteboardCanvas {
			return whiteboardCanvas0;
		}
		
		public function setPresentationName(name:String):void {
			FlexGlobals.topLevelApplication.pageName.text = name;
		}
		
		public function setSlide(s:Slide):void {
			if (s != null) {	
				var context:LoaderContext = new LoaderContext();			
				context.allowCodeImport = true;
				slide.loaderContext = context;
				slide.source = s.SWFFile.source;
			} else {
				slide.source = null;
			}
		}
		
		public function securityError(e:Event):void
		{
			trace("PresentationView.as Security error : " + e.toString());	
		}
		
		override public function rotationHandler(rotation:String):void {
			switch (rotation) {
				case StageOrientation.ROTATED_LEFT:
					slide.rotation = -90;
					break;
				case StageOrientation.ROTATED_RIGHT:
					slide.rotation = 90;
					break;
				case StageOrientation.UPSIDE_DOWN:
					slide.rotation = 180;
					break;
				case StageOrientation.DEFAULT:
				case StageOrientation.UNKNOWN:
				default:
					slide.rotation = 0;
			}
		}
		
		
		public function dispose():void
		{
			
		}
		
	}
}