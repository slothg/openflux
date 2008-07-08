package com.plexiglass.cameras
{
	import com.plexiglass.containers.IPlexiContainer;
	
	public interface ICamera
	{
		function attach(container:IPlexiContainer):void;
		function detach(container:IPlexiContainer):void;
		function update(w:Number, h:Number):void;
	}
}