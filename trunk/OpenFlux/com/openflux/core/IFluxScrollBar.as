package com.openflux.core
{
	public interface IFluxScrollBar
	{
		function get min():Number;
		function set min(value:Number):void;
		
		function get max():Number;
		function set max(value:Number):void;
		
		function get position():Number;
		function set position(value:Number):void;
	}
}