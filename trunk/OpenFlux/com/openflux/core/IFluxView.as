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
		 * Usually an instance of IFluxComponent.
		 * 
		 */
		function get data():Object;
		function set data(value:Object):void;
		
		/**
		 * A String representation of the components state.
		 */
		function get state():String;
		function set state(value:String):void;
		
	}
}