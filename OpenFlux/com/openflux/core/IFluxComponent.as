package com.openflux.core
{
	
	/**
	 * Defines the interface which all visual components extending from this library must implement.
	 * This enforces a consistent seperation of model, view, and controller functionality (in which the component itself represents the model)
	 * @see IFluxController
	 * @see IFluxView
	 */
	public interface IFluxComponent
	{
		
		/**
		 * An instance of IFluxController.
		 * The IFluxController instance should be responsible for the behavior of this component, 
		 * including reacting to user input/gestures or changes in the model.
		 */
		function get controller():IFluxController;
		function set controller(value:IFluxController):void;
		
		/**
		 * An instance of IFluxView.
		 * The IFluxView instance should be responsible for the visual appearance of this component,
		 * including graphics, child management, states, and transitions.
		 */
		function get view():IFluxView;
		function set view(value:IFluxView):void;
		
	}
}