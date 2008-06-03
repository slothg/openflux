package com.openflux.views
{
	import com.openflux.animators.IAnimator;
	import com.openflux.layouts.ILayout;
	
	import mx.core.IInvalidating;
	import mx.core.IUIComponent;
	
	public interface IContainerView extends IUIComponent, IInvalidating
	{
		
		function get animator():IAnimator;
		function set animator(value:IAnimator):void;
		
		function get layout():ILayout;
		function set layout(value:ILayout):void;
		
		function get renderers():Array; // always DisplayObjects
		
		//function get verticalScrollPosition():Number;
		//function get horizontalScrollPosition():Number;
		
		function invalidateLayout():void;
		
	}
}