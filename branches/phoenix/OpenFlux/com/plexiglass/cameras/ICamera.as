package com.plexiglass.cameras
{
	import com.plexiglass.containers.IPlexiContainer;
	
	import flash.geom.Rectangle;
	
	public interface ICamera
	{
		function attach(container:IPlexiContainer):void;
		function detach(container:IPlexiContainer):void;
		function update(rectangle:Rectangle):void;
	}
}