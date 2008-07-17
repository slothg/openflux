package com.openflux.core
{
	import mx.core.IUIComponent;
	
	public interface IFluxFactory
	{
		
		function createComponent(item:Object):IUIComponent;
		
	}
	
}