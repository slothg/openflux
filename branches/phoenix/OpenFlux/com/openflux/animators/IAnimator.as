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

package com.openflux.animators
{
	import com.openflux.containers.IFluxContainer;
	
	import flash.display.DisplayObject;
	
	/**
	 * Defines the interface used by animators.
	 * Animator classes are responsable for tweening object properties (ie. x, y, width, height, etc).
	 */
	public interface IAnimator
	{
		/**
		 * attaches this animator to a given container
		 */
		function attach(container:IFluxContainer):void;
		
		/**
		 * detaches this animator from the container
		 */
		function detach(container:IFluxContainer):void;
		
		
		/**
		 * Called before a series of addItem, moveItem, or removeItem calls.
		 */
		function begin():void;
		
		// we might break these up into seperate interfaces later
		function addItem(item:DisplayObject):void;
		function moveItem(item:DisplayObject, token:AnimationToken):void;
		function adjustItem(item:DisplayObject, token:AnimationToken):void; // for scrolling, drag reactions etc.
		function removeItem(item:DisplayObject, callback:Function):void;
		
		/**
		 * Called after a series of addItem, moveItem, or removeItem calls.
		 */
		function end():void;
		
	}
}