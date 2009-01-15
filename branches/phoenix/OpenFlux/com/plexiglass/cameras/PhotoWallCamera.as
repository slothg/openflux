package com.plexiglass.cameras
{
	import away3d.cameras.HoverCamera3D;
	import away3d.core.math.Number3D;
	import away3d.primitives.Sphere;
	
	import com.plexiglass.containers.IPlexiContainer;
	
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class PhotoWallCamera extends CameraBase implements ICamera
	{
		private var sphere:Sphere;
		private var hcamera:HoverCamera3D;
		
		public function PhotoWallCamera()
		{
			super();
			
			sphere = new Sphere({radius:10});
			camera = hcamera = new HoverCamera3D({zoom:11, focus:100, distance:-1000, target:sphere, steps:0});
			hcamera.mintiltangle = -90;
			hcamera.maxtiltangle = 90;
			hcamera.targetpanangle = -90;
			hcamera.targettiltangle = 0;
			hcamera.yfactor = 10;
		}
		
		private var _maxAngle:Number = 80;
		public function get maxAngle():Number { return _maxAngle; }
		public function set maxAngle(value:Number):void {
			_maxAngle = value;
		}

		override public function attach(container:IPlexiContainer):void
		{
			super.attach(container);
			sphere.moveTo(new Number3D(container.width/2, container.height/2));
			//container.view.scene.addChild(sphere);
		}
		
		override public function detach(container:IPlexiContainer):void
		{
			super.detach(container);
			//container.view.scene.addChild(sphere);
		}
		
		override public function update(rectangle:Rectangle):void
		{
			super.update(rectangle);
			sphere.moveTo(new Number3D(0, 0, 0));
		}
		
		override protected function onEnterFrame(event:Event):void
		{
			if (container.width > 0)
				hcamera.targetpanangle = Math.min(80,Math.max(-80,(container.width/2 - container.mouseX)/(container.width/2)*_maxAngle));
				
			hcamera.hover();
		}
		
	}
}