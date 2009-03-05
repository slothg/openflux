package com.openflux.core
{
	import mx.collections.ArrayCollection;
	
	public interface IFluxList
	{
		
		function get data():Object;
		function set data(value:Object):void;
		
		function get selectedItems():Array;
		function set selectedItems(value:Array):void;
		
	}
}