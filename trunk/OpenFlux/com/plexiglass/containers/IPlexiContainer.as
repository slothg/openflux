package com.plexiglass.containers
{
	import away3d.containers.View3D;
	
	import com.openflux.containers.IFluxContainer;
	
	public interface IPlexiContainer extends IFluxContainer
	{
		function get view():View3D;
	}
}