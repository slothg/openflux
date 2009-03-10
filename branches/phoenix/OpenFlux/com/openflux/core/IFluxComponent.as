// =================================================================
//
// Copyright (c) 2009 The OpenFlux Team http://www.openflux.org
// 
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// =================================================================

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
		
		/**
		 * Used for PlexiGlass Simple3DLayout
		 */
		// these shouldn't be required on the interface
		// we put them in FluxComponent just for convenience
		/*
		function get z():Number;
		function set z(value:Number):void;
		function get rotationX():Number;
		function set rotationX(value:Number):void;
		function get rotationY():Number;
		function set rotationY(value:Number):void;
		function get rotationZ():Number;
		function set rotationZ(value:Number):void;
		 */
	}
}