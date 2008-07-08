package com.plexiglass.cameras
{
	import away3d.cameras.HoverCamera3D;
	import away3d.core.math.Number3D;
	import away3d.primitives.Sphere;
	
	import com.plexiglass.containers.IPlexiContainer;
	
	import flash.events.Event;
	
	public class HoverCamera implements ICamera
	{
		private var container:IPlexiContainer;
		private var camera:HoverCamera3D;
		private var center:Sphere;
		
		public function HoverCamera()
		{
			center = new Sphere();
			camera = new HoverCamera3D({target:center});//{z:-1200, zoom:11, focus:100, , distance:-1200});
		}
		
		public function attach(container:IPlexiContainer):void
		{	
			this.container = container;
			this.container.view.camera = camera;
			//this.container.view.scene.addChild(center);
			this.container.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		public function detach(container:IPlexiContainer):void
		{
			this.container.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			//this.container.view.scene.removeChild(center);
			this.container = null;
		}
		
		public function update(w:Number, h:Number):void
		{
			camera.x = (w/2);
			camera.y = -(h/2);
			center.x = camera.x;
			center.y = camera.y;
			camera.lookAt(new Number3D(0, 0, 0));
		}
		
		private function enterFrameHandler(event:Event):void
		{
			if (container.view && container.view.scene)
			{
				camera.targetpanangle = 90 * (container.getExplicitOrMeasuredWidth() / 2 - container.mouseX) / (container.getExplicitOrMeasuredWidth() / 2);
				camera.targettiltangle = 90 * (container.getExplicitOrMeasuredHeight() / 2 - container.mouseY) / (container.getExplicitOrMeasuredHeight() / 2) * -1;
				camera.hover();
			}
		}
	}
}