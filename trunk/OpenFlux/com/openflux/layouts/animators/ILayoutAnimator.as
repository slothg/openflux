package com.openflux.layouts.animators
{
	import com.openflux.core.IDataView;
	
	/**
	 * Defines the interface used by animators.
	 * Animator classes are responsable for tweening object properties (ie. x, y, width, height, etc).
	 */
	public interface ILayoutAnimator
	{
		/**
		 * attaches this animator to a given container
		 */
		function attach(container:IDataView):void;
		function detach(container:IDataView):void;
		
		/**
		 * Called before a series of addItem, moveItem, or removeItem calls.
		 */
		function begin():void;
		function addItem(item:Object, token:Object):void;
		function moveItem(item:Object, token:Object):void;
		function removeItem(item:Object):void;
		
		/**
		 * Called after a series of addItem, moveItem, or removeItem calls.
		 */
		function end():void;
		
	}
}