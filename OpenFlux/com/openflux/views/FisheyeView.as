package com.openflux.views
{
	import away3d.primitives.Plane;
	
	import com.plexiglass.views.PlexiListView;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	public class FisheyeView extends PlexiListView
	{
		public var radius:Number = 200;
		public var minScale:Number = 0.25;
		public var maxScale:Number = 1.0;
		public var hasScaled:Boolean = false;
		public function FisheyeView() {
			super();
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseMove(event:MouseEvent):void {
			var p1:Point = new Point(mouseX, mouseY);
			var p2:Point;
			var dx:Number;
			var dy:Number;
			var distance:Number;
			hasScaled = true;
			var i:int=0;
			for each (var child:UIComponent in children) {
				var plane:Plane = this.getChildPlane(child);
				/*if (i==0) {
					trace("plane x: " + plane.x + " y: " + plane.y + " bb: " + (plane.y - (height/2+plane.height/2)));
				}*/
				p2 = new Point(plane.x + (width/2+plane.width/2), (plane.y + height/2*-1 + plane.height/2)*-1);
				dx = p2.x - p1.x;;
				dy = p2.y - p1.y;
				distance = Math.sqrt(dx * dx + dy * dy);
				i++;
				
				child.scaleX = child.scaleY = distance < radius ? (1 - distance / radius) * (maxScale-minScale) + minScale : minScale;
			}
			
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			trace("updateDisplayList");
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
	}
}