package com.openflux.controllers
{
	import com.openflux.containers.*;
	import com.openflux.core.*;
	import com.openflux.views.*;
	
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.IDataRenderer;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.ListEvent;
	import mx.events.ListEventReason;
	
	/* // These are just for my reference
	[Event(name="change", type="mx.events.ListEvent")]
	[Event(name="itemClick", type="mx.events.ListEvent")]
	[Event(name="itemDoubleClick", type="mx.events.ListEvent")]
	[Event(name="itemRollOver", type="mx.events.ListEvent")]
	[Event(name="itemRollOut", type="mx.events.ListEvent")]
	*/
	
	[ViewHandler(event="childAdd", handler="childAddHandler")]
	[ViewHandler(event="childRemove", handler="childRemoveHandler")]
	public class ListController extends FluxController
	{
		
		[ModelAlias] [Bindable] public var list:IFluxList;
		
		
		//***************************************************************
		// Event Handlers
		//***************************************************************
		
		metadata function childAddHandler(event:ChildExistenceChangedEvent):void {
			var child:DisplayObject = event.relatedObject;
			child.addEventListener(MouseEvent.CLICK, child_clickHandler, false, 0, true);
		}
		
		metadata function childRemoveHandler(event:ChildExistenceChangedEvent):void {
			var child:DisplayObject = event.relatedObject;
			child.removeEventListener(MouseEvent.CLICK, child_clickHandler, false);
		}
		
		private function child_clickHandler(event:MouseEvent):void {
			if(event.currentTarget is IDataRenderer) {
				if(!event.ctrlKey) { clearSelection(); }
				toggleSelection(event.currentTarget.data);
			}
			
			var e:ListEvent = new ListEvent(ListEvent.ITEM_CLICK, false, false, -1, -1, ListEventReason.OTHER, event.currentTarget as IListItemRenderer);
			(component as IEventDispatcher).dispatchEvent(e);
			e = new ListEvent(ListEvent.CHANGE, false, false, -1, -1, ListEventReason.OTHER, event.currentTarget as IListItemRenderer);
			(component as IEventDispatcher).dispatchEvent(e);
		}
		
		
		//************************************
		// List Utility Functions
		//************************************
		
		private function toggleSelection(item:Object):void {
			if(list.selectedItems && list.selectedItems.contains(item)) {
				removeSelection(item);
			} else {
				addSelection(item);
			}
		}
		
		private function addSelection(item:Object):void {
			if(!list.selectedItems) {
				list.selectedItems = new ArrayCollection();
			}
			if(!list.selectedItems.contains(item)) {
				list.selectedItems.addItem(item);
			}
		}
		
		private function removeSelection(item:Object):void {
			if(list.selectedItems) {
				var index:int = list.selectedItems.getItemIndex(item);
				list.selectedItems.removeItemAt(index);
			}
		}
		
		private function clearSelection():void {
			if(list.selectedItems) { // update data
				list.selectedItems.removeAll();
			}
			
		}
		
	}
}