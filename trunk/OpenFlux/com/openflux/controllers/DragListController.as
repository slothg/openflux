package com.openflux.controllers
{
	import com.openflux.ListItem;
	import com.openflux.core.FluxController;
	import com.openflux.core.IFluxList;
	
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import mx.collections.IList;
	import mx.core.DragSource;
	import mx.core.IDataRenderer;
	import mx.core.IUIComponent;
	import mx.core.IUITextField;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	
	[ViewHandler(event="childAdd", handler="childAddHandler")]
	[ViewHandler(event="childRemove", handler="childRemoveHandler")]
	[EventHandler(event="dragStart", handler="dragStartHandler")]
	//[EventHandler(event="dragComplete", handler="dragCompleteHandler")]
	public class DragListController extends FluxController
	{
		
		public var dragEnabled:Boolean = true;
		
		[ModelAlias] public var list:IFluxList;
		[ModelAlias] public var dispatcher:IEventDispatcher;
		
		
		//***************************************************************
		// Event Listeners
		//***************************************************************
		
		metadata function childAddHandler(event:ChildExistenceChangedEvent):void {
			var child:DisplayObject = event.relatedObject;
			child.addEventListener(MouseEvent.MOUSE_DOWN, child_mouseDownHandler, false, 0, true);
			child.addEventListener(DragEvent.DRAG_COMPLETE, dragCompleteHandler, false, 0, true)
		}
		
		metadata function childRemoveHandler(event:ChildExistenceChangedEvent):void {
			var child:DisplayObject = event.relatedObject;
			child.removeEventListener(MouseEvent.MOUSE_DOWN, child_mouseDownHandler, false);
			child.removeEventListener(DragEvent.DRAG_COMPLETE, dragCompleteHandler, false);
		}
		
		private function child_mouseDownHandler(event:MouseEvent):void {
			if ( event.target is IUITextField )
				return;
			
			var instance:DisplayObject = event.currentTarget as DisplayObject;
			instance.addEventListener(MouseEvent.MOUSE_UP, child_mouseUpHandler, false, 0, true);
			instance.addEventListener(MouseEvent.MOUSE_MOVE, child_mouseMoveHandler, false, 0, true);
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
			if(instance is IDataRenderer) { // need to cover multiple items
				source.addData([(instance as IDataRenderer).data], "items");
			}
			
			// create image
			DragManager.doDrag(instance as IUIComponent, source, event);
			// does doDrag dispatch this for us?
			var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_START, false, true, instance as IUIComponent, source, null, event.ctrlKey, event.altKey, event.shiftKey);
			dispatcher.dispatchEvent(dragEvent);
		}
		
		metadata function dragStartHandler(event:DragEvent):void {
			
		}
		
		protected function dragCompleteHandler(event:DragEvent):void {
			if (event.dragInitiator is ListItem) {
				if (event.action == DragManager.NONE || event.currentTarget == (event.dragInitiator as ListItem).list)
					return;
				
				var data:Object = event.dragSource.dataForFormat("items")[0];
				var collection:IList = list.data as IList;
				var index:int = collection.getItemIndex(data);
				collection.removeItemAt(index);
			}
		}
		
	}
}