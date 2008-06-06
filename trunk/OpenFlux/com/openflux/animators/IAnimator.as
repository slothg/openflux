package com.openflux.animators
{
	import com.openflux.containers.IFluxContainer;
	
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
		
		//function animate(item:Object, token:Object):void;
		
		//function addItem(item:Object, token:Object):void;
		function moveItem(item:Object, token:Object):void;
		//function removeItem(item:Object):void;
		
		/**
		 * Called after a series of addItem, moveItem, or removeItem calls.
		 */
		function end():void;
		
	}
}