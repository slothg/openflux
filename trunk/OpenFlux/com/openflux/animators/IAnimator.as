package com.openflux.animators
{
	import com.openflux.containers.IFluxContainer;
	
	import flash.display.DisplayObject;
	
	/**
	 * Defines the interface used by animators.
	 * Animator classes are responsable for tweening object properties (ie. x, y, width, height, etc).
	 */
	public interface IAnimator
	{
		/**
		 * attaches this animator to a given container
		 */
		function attach(container:IFluxContainer):void;
		function detach(container:IFluxContainer):void;
		
		
		/**
		 * Called before a series of addItem, moveItem, or removeItem calls.
		 */
		function begin():void;
		
		//function addItem(item:Object):void;
		function moveItem(item:DisplayObject, token:AnimationToken):void;
		//function adjustItem(item:DisplayObject, token:AnimationToken):void; // for scrolling, drag reactions etc.
		//function removeItem(item:Object):void;
		
		/**
		 * Called after a series of addItem, moveItem, or removeItem calls.
		 */
		function end():void;
		
	}
}