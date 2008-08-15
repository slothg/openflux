package com.plexiglass.cameras
{
	import away3d.cameras.Camera3D;
	import away3d.core.math.Number3D;
	
	import caurina.transitions.Tweener;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class MouseCamera extends CameraBase implements ICamera
	{
		private var measuredWidth:Number;
		private var measuredHeight:Number;
		public var x:Number = 0;
		public var y:Number = 0;
		public var lastMouseX:Number = 0;
		public var lastMouseY:Number = 0;
		public var offset:Number = 0;
		
		public function MouseCamera() {
			super();
			camera = new Camera3D({z:-1000, zoom:11, focus:100});
		}
		
		override public function update(rectangle:Rectangle):void {
			super.update(rectangle);
			var point:Point = container.layout.measure(container.children);
			measuredWidth = point.x;
			measuredHeight = point.y;
		}
		
		override protected function onEnterFrame(event:Event):void {
			if (lastMouseX > container.mouseX) {
				Tweener.addTween(this, {offset:-1000, time:5});
			} else if (lastMouseX < container.mouseX) {
				Tweener.addTween(this, {offset:1000, time:5});
			} else if (!Tweener.isTweening(this) && offset != 0) {
				Tweener.addTween(this, {offset:0, time:1/3});
			}
			
			lastMouseX = container.mouseX;
			lastMouseY = container.mouseY;
			
			Tweener.addTween(this, {x:container.mouseX / container.width * measuredWidth - container.width/2, y:container.mouseY / container.height * measuredHeight, time:1});
			camera.moveTo(new Number3D(x, y, -1000));
			camera.lookAt(new Number3D(x+offset, y, 0));
		}
	}
}