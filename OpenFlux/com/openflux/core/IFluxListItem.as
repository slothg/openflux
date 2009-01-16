package com.openflux.core
{
	
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.IDataRenderer;
	
	public interface IFluxListItem extends IDataRenderer //IListItemRenderer
	{
		
		//function get data():Object;
		//function get index():int;
		function get list():IFluxList;
		function set list(value:IFluxList):void;
	}
}