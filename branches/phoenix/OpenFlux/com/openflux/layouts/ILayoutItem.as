package com.openflux.layouts
{
	public interface ILayoutItem
	{
		function getConstraint(name:String):Number;
		function get constraintsDetermineWidth():Boolean;
		function get constraintsDetermineHeight():Boolean;
		function get preferredWidth():Number;
		function get preferredHeight():Number;
		function get minWidth():Number;
		function get minHeight():Number;
		function get maxWidth():Number
		function get maxHeight():Number;
	}
}