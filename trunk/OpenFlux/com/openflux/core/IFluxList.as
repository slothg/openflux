package com.openflux.core
{
	import mx.collections.ArrayCollection;
	
	public interface IFluxList
	{
		
		function get dataProvider():Object;
		function set dataProvider(value:Object):void;
		
		function get selectedItems():ArrayCollection;
		function set selectedItems(value:ArrayCollection):void;
		
	}
}