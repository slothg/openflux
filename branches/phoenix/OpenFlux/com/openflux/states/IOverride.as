package com.openflux.states
{
	import flash.display.DisplayObjectContainer;
	
	public interface IOverride
	{
		function initialize():void;
		function apply(parent:DisplayObjectContainer):void;
		function remove(parent:DisplayObjectContainer):void;
	}
}