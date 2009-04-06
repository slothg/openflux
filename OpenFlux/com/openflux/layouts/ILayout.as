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

package com.openflux.layouts
{
	
	import com.openflux.containers.IFluxContainer;
	import com.openflux.core.IFluxCapacitorItem;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Used to organize the layout of children in containers, lists, and related components.
	 */
	public interface ILayout extends IFluxCapacitorItem
	{	
		/**
		 * Attach the container. Called once when the layout is assigned to the view.
		 */
		function attach(container:IFluxContainer):void;
		
		/**
		 * Detach the container. Called once when the layout is no longer assigned to the view.
		 */
		function detach(container:IFluxContainer):void;
		
		/**
		 * The measure function is used to determine the measured width and height 
		 * of a container given the current contents and layout.
		 */
		function measure(children:Array):Point; // should we get more complex (ie. min vs. measured etc.)
		
		/**
		 * The update method can be used to arrange children in any pattern.
		 */
		function update(children:Array, rectangle:Rectangle):void;
		
	}
}