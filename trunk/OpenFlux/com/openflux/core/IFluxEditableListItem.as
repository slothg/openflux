package com.openflux.core
{
	public interface IFluxEditableListItem extends IFluxListItem
	{
		function get editing():Boolean;
		function set editing(value:Boolean):void;
	}
}