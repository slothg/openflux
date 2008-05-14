package com.openflux.layouts
{
	import com.openflux.core.IFluxContainer;
	
	import flash.geom.Point;
	//import flash.events.MouseEvent;
	//import mx.events.DragEvent;
	
	public interface ILayout
	{	
		/*
		function get animator():ILayoutAnimator;
		function set animator(value:ILayoutAnimator):void;
		*/
		function attach(container:IFluxContainer):void;
		function detach(container:IFluxContainer):void;
		
		function measure():Point;
		function update(indices:Array = null):void;
		
		// function findItemAt(px:Number, py:Number, seamAligned:Boolean):int; // moved to seperate interface IDragLayout
		/* // not sure drag event handlers belong here
		function dragStart(e:MouseEvent) : Boolean;
		function dragEnter(e:DragEvent) : Boolean;
		function dragOver(e:DragEvent) : Boolean;
		function dragDrop(e:DragEvent) : Boolean;
		function dragComplete(e:DragEvent) : Boolean;
		function dragOut(e:DragEvent) : Boolean;
		*/
	}
}