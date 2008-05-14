package com.openflux.core
{
	import mx.core.IUIComponent;
	
	[Bindable]
	/**
	 * @see IFluxComponent
	 * @see IFluxController
	 */
	public interface IFluxView extends IUIComponent
	{
		
		/**
		 * A reference to the component which is being rendered by the implementing class
		 * 
		 */
		function get component():Object;
		function set component(value:Object):void;
		
		/**
		 * A string representation of the component's state
		 */
		function get state():String;
		function set state(value:String):void;
		
	}
}