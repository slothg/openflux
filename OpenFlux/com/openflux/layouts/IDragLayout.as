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