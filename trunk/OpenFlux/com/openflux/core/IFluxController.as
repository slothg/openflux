package com.openflux.core
{
	import mx.core.UIComponent;
	
	/**
	 * Defines the interface which all Flux controllers extending from this library must implement.
	 * @see IFluxComponent
	 * @see IFluxView
	 */
	public interface IFluxController
	{
		
		/**
		 * A reference to the component which the implementing class controls
		 */
		function get component():IFluxComponent;
		function set component(value:IFluxComponent):void;
		
	}
}