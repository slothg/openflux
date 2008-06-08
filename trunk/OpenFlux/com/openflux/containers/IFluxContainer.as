package com.openflux.containers
{
	import com.openflux.animators.IAnimator;
	import com.openflux.layouts.ILayout;
	
	import flash.utils.Dictionary;
	
	import mx.core.IInvalidating;
	import mx.core.IUIComponent;
	
	public interface IFluxContainer extends IUIComponent, IInvalidating
	{
		
		function get animator():IAnimator;
		function set animator(value:IAnimator):void;
		
		function get layout():ILayout;
		function set layout(value:ILayout):void;
		
		function get children():Array; // always DisplayObjects
		//function get tokens():Dictionary;
		
		function invalidateLayout():void;
		
	}
}