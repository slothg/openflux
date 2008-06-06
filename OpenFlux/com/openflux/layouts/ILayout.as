package com.openflux.layouts
{
	
	import flash.geom.Point;
	import com.openflux.containers.IFluxContainer;
	
	/**
	 * Used to layout items in containers, lists, etc.
	 */
	public interface ILayout
	{	
		
		function attach(container:IFluxContainer):void;
		function detach(container:IFluxContainer):void;
		
		function measure():Point;
		function update(indices:Array = null):void;
		
		// function findItemAt(px:Number, py:Number, seamAligned:Boolean):int; // moved to seperate interface IDragLayout
		
	}
}