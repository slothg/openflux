package com.openflux.core
{
	
	import mx.controls.listClasses.IListItemRenderer;
	
	public interface IFluxListItem extends IListItemRenderer
	{
		
		//function get data():Object;
		//function get index():int;
		function get list():IFluxList;
		function set list(value:IFluxList):void;
	}
}