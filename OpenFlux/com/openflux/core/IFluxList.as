package com.openflux.core
{
	import mx.collections.IList;
	
	public interface IFluxList
	{
		
		function get data():Object;
		function set data(value:Object):void;
		
		function get selectedItems():IList;
		function set selectedItems(value:IList):void;
		
	}
}