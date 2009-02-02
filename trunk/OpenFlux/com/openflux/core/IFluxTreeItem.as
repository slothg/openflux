package com.openflux.core
{
	public interface IFluxTreeItem extends IFluxListItem
	{
		function get opened():Boolean;
		function set opened(value:Boolean):void;
		
		function get level():int;
		function set level(value:int):void;
	}
}