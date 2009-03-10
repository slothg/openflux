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
	import flash.geom.Rectangle;
	
	/**
	 * Used by layout classes that support visual feedback of drag and drop operations.
	 */
	public interface IDragLayout
	{
		
		/**
		 * This method is used to determine the index that ...
		 */
		function findIndexAt(children:Array, x:Number, y:Number/*, seamAligned:Boolean*/):int; // do we need seam aligned?
		
		/**
		 * Adjusts the children's positions to indicate a response to the designated indices.
		 * @argument indices An array of integers representing the index at which a drop would result in additions to the children array.
		 * Each integer represents an index in the original children array. For example, the array [0, 1, 1] would represent one item before 
		 * index 0 and two items after index 0.
		 */
		function adjust(children:Array, rectangle:Rectangle, indices:Array):void;
		
	}
}