package com.plexiglass.cameras
{
	import away3d.cameras.Camera3D;
	import away3d.core.math.Number3D;
	
	import flash.events.Event;

	public class SimpleCamera extends CameraBase implements ICamera
	{		
		public function SimpleCamera()
		{
			super();
			camera = new Camera3D({z:-1000, zoom:11, focus:100, steps:20});
		}
		
		public function update(w:Number, h:Number):void
		{
		}
	}
}