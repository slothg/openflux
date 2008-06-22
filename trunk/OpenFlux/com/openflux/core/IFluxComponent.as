package com.openflux.core
{
	
	/**
	 * Defines the interface which all components extending from this library must implement.
	 * This interface enforces a consistent seperation of model, view, and controller functionality (in which the component itself represents the model).
	 * An IFluxComponent should contain only the core data model which is inherent to the component. Properties which only effect the behavior
	 * or appearance of a component should be declared on the controller or view respectively.
	 * @see IFluxController
	 * @see IFluxView
	 */
	public interface IFluxComponent
	{
		
		/**
		 * The controller is responsible for the behavior of a component
		 * , which includes reacting to user input/gestures.
		 */
		function get controller():IFluxController;
		function set controller(value:IFluxController):void;
		
		/**
		 * The view is responsible for the visual appearance of a component
		 * , which includes graphics, child management, states, and transitions.
		 */
		function get view():IFluxView;
		function set view(value:IFluxView):void;
		
	}
}