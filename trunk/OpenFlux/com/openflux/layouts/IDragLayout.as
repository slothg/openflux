package com.openflux.layouts
{
	import mx.core.DragSource;
	
	public interface IDragLayout
	{
		/*
		function get dragItems():Array;
		function set dragItems(value:Array):void;
		*/
		function findItemAt(x:Number, y:Number, seamAligned:Boolean):int;
		
	}
}