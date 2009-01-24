package com.openflux.core
{
	public interface IFluxDataGridColumn
	{
		function get headerText():String;
		function set headerText(value:String):void;
		
		function get dataField():String;
		function set dataField(value:String):void;
		
		function get dataFunction():Function;
		function set dataFunction(value:Function):void;
		
		function get width():Number;
		function set width(value:Number):void;
	}
}