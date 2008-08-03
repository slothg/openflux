package com.openflux.layouts
{
	
	import com.openflux.containers.IFluxContainer;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Used to organize the layout of children in containers, lists, and related components.
	 */
	public interface ILayout
	{	
		
		function attach(container:IFluxContainer):void;
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