package com.plexiglass.cameras
{
	import away3d.cameras.Camera3D;
	import away3d.core.math.Number3D;
	
	import com.plexiglass.containers.IPlexiContainer;
	
	import flash.events.Event;

	public class SimpleCamera implements ICamera
	{
		public var camera:Camera3D;
		private var container:IPlexiContainer;
		
		public function SimpleCamera()
		{
			camera = new Camera3D({z:-100, zoom:2, focus:100});
		}

		public function attach(container:IPlexiContainer):void
		{
			this.container = container;
			this.container.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.container.view.camera = camera;
		}
		
		public function detach(container:IPlexiContainer):void
		{
			this.container.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.container = null;
		}
		
		public function update(w:Number, h:Number):void
		{
			container.view.x = w / 2;
			container.view.y = h / 2;
		}
		
		private function onEnterFrame(event:Event):void
		{
			camera.lookAt(new Number3D(0, 0, 0));
		}
		
	}
}