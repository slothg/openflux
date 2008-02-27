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
		 * Usually an instance of IFluxComponent.
		 * 
		 */
		function get data():IFluxComponent;
		function set data(value:IFluxComponent):void;
	}
}