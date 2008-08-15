package com.plexiglass.cameras
{
	import away3d.cameras.Camera3D;
	
	import com.plexiglass.containers.IPlexiContainer;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class CameraBase
	{
		protected var camera:Camera3D;
		protected var container:IPlexiContainer;
		
		public function CameraBase()
		{
		}
		
		public function attach(container:IPlexiContainer):void {
			this.container = container;
			this.container.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.container.view.camera = camera;
		}
		
		public function detach(container:IPlexiContainer):void {
			this.container.view.camera = null;
			this.container.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.container = null;
		}
		
		public function update(rectangle:Rectangle):void {
			container.view.x = rectangle.width / 2;
			container.view.y = rectangle.height / 2;
		}
		
		protected function onEnterFrame(event:Event):void {
		}
	}
}