package com.openflux.controllers
{
	import com.openflux.core.FluxController;
	import com.openflux.core.IFluxList;
	import com.openflux.core.IFluxListItem;
	
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import mx.collections.IList;
	import mx.core.DragSource;
	import mx.core.IDataRenderer;
	import mx.core.IUIComponent;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	[ViewHandler(event="childAdd", handler="childAddHandler")]
	[ViewHandler(event="childRemove", handler="childRemoveHandler")]
	[EventHandler(event="dragStart", handler="dragStartHandler")]
	[EventHandler(event="dragComplete", handler="dragCompleteHandler")]
	
	/**
	 * Handles starting drag from a List component
	 */
	public class DragListController extends FluxController
	{
		[ModelAlias] public var list:IFluxList;
		[ModelAlias] public var dispatcher:IEventDispatcher;

		/**
		 * Constructor
		 */
		public function DragListController() {
			super();
		}
		
		// ========================================
		// Event handlers
		// ========================================
		
		metadata function childAddHandler(event:ChildExistenceChangedEvent):void {
			var child:DisplayObject = event.relatedObject;
			child.addEventListener(MouseEvent.MOUSE_DOWN, child_mouseDownHandler, false, 0, true);
		}
		
		metadata function childRemoveHandler(event:ChildExistenceChangedEvent):void {
			var child:DisplayObject = event.relatedObject;
			child.removeEventListener(MouseEvent.MOUSE_DOWN, child_mouseDownHandler, false);
		}
		
		metadata function dragStartHandler(event:DragEvent):void {
			
		}
		
		metadata function dragCompleteHandler(event:DragEvent):void {
			if (event.currentTarget == (event.dragInitiator as IFluxListItem).list)
				return;
			
			var data:Object = event.dragSource.dataForFormat("data");
			var collection:IList = list.data as IList;
			var index:int = collection.getItemIndex(data);
			collection.removeItemAt(index);
		}

		// ========================================
		// Child Event Handlers
		// ========================================
		
		private function child_mouseDownHandler(event:MouseEvent):void {
			if (enabled) {
				var instance:DisplayObject = event.currentTarget as DisplayObject;
				instance.addEventListener(MouseEvent.MOUSE_UP, child_mouseUpHandler, false, 0, true);
				instance.addEventListener(MouseEvent.MOUSE_MOVE, child_mouseMoveHandler, false, 0, true);
			}
		}
		
		private function child_mouseUpHandler(event:MouseEvent):void {
			var instance:DisplayObject = event.currentTarget as DisplayObject;
			instance.removeEventListener(MouseEvent.MOUSE_UP, child_mouseUpHandler, false);
			instance.removeEventListener(MouseEvent.MOUSE_MOVE, child_mouseMoveHandler, false);
		}
		
		private function child_mouseMoveHandler(event:MouseEvent):void {
			var instance:DisplayObject = event.currentTarget as DisplayObject;
			instance.removeEventListener(MouseEvent.MOUSE_UP, child_mouseUpHandler, false);
			instance.removeEventListener(MouseEvent.MOUSE_MOVE, child_mouseMoveHandler, false);
			
			// add some data
			var source:DragSource = new DragSource();
			if(instance is IDataRenderer) {
				source.addData([(instance as IDataRenderer).data], "items");
			}
			
			// create image
			DragManager.doDrag(instance as IUIComponent, source, event);
			
			// dispatch drag start
			var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_START, false, true, instance as IUIComponent, source, null, event.ctrlKey, event.altKey, event.shiftKey);
			dispatcher.dispatchEvent(dragEvent);
		}		
	}
}