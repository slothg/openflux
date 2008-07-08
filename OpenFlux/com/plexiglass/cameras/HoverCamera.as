package com.plexiglass.cameras
{
	import away3d.cameras.HoverCamera3D;
	import away3d.core.math.Number3D;
	import away3d.primitives.Sphere;
	
	import com.plexiglass.containers.IPlexiContainer;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class HoverCamera implements ICamera
	{
		private var container:IPlexiContainer;
		private var camera:HoverCamera3D;
		private var center:Sphere;
		
		private var rotCamera:Boolean = false;
		private var lastMouseX:Number = 0;
		private var lastMouseY:Number = 0;
		private var firstClick:Boolean = true;
		
		public function HoverCamera()
		{
			center = new Sphere();
			camera = new HoverCamera3D({zoom:11, focus:200, distance:1000, target:center});
			camera.tiltangle = 40;
			camera.targettiltangle = 40;
			camera.mintiltangle =  20;
			camera.maxtiltangle = 50;
			camera.yfactor = 1;
			camera.steps = 7;
		}
		
		public function attach(container:IPlexiContainer):void
		{	
			this.container = container;
			this.container.view.camera = camera;
			lastMouseX = container.mouseX;
			lastMouseY = container.mouseY;
			this.container.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		public function detach(container:IPlexiContainer):void
		{
			this.container.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			this.container = null;
		}
		
		public function update(w:Number, h:Number):void
		{
			container.view.x = w/2;
			container.view.y = h/2;
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
				var dragX:Number = (container.view.mouseX - lastMouseX);
				var dragY:Number = (container.view.mouseY - lastMouseY);
				
				lastMouseX = container.view.mouseX;
				lastMouseY = container.view.mouseY;
				
				camera.targetpanangle += dragX;
				camera.targettiltangle += dragY
				camera.hover();
			}
		}
	}
}