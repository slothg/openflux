package com.plexiglass.containers
{
	import away3d.containers.View3D;
	import away3d.primitives.Plane;
	
	import com.openflux.containers.IFluxContainer;
	
	import mx.core.IUIComponent;
	
	public interface IPlexiContainer extends IFluxContainer
	{
		function get view():View3D;
		function getChildPlane(child:IUIComponent):Plane;
	}
}