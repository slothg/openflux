package com.openflux.core
{
	public interface IFluxButton
	{
		
		// label may need to be in it's own interface
		// we'll wait and see though
		//function get label():String;
		//function set label(value:String):void;
		
		function get buttonState():String;
		function set buttonState(value:String):void;
		
	}
}