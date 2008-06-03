package com.openflux.layouts
{
	
	import flash.geom.Point;
	import com.openflux.views.IContainerView;
	
	/**
	 * Used to layout items in containers, lists, etc.
	 */
	public interface ILayout
	{	
		
		function attach(container:IContainerView):void;
		function detach(container:IContainerView):void;
		
		function measure():Point;
		function update(indices:Array = null):void;
		
		// function findItemAt(px:Number, py:Number, seamAligned:Boolean):int; // moved to seperate interface IDragLayout
		
	}
}