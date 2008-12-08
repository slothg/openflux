package com.openflux.controllers
{
	import com.openflux.containers.*;
	import com.openflux.core.*;
	import com.openflux.views.*;
	
	import flash.display.DisplayObject;
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
			child.addEventListener(MouseEvent.DOUBLE_CLICK, child_doubleClickHandler, false, 0, true);
			child.addEventListener(MouseEvent.ROLL_OVER, child_rollOverHandler, false, 0, true);
			child.addEventListener(MouseEvent.ROLL_OUT, child_rollOutHandler, false, 0, true);
		}
		
		metadata function childRemoveHandler(event:ChildExistenceChangedEvent):void {
			var child:DisplayObject = event.relatedObject;
			child.removeEventListener(MouseEvent.CLICK, child_clickHandler, false);
			child.removeEventListener(MouseEvent.DOUBLE_CLICK, child_doubleClickHandler, false);
			child.removeEventListener(MouseEvent.ROLL_OVER, child_rollOverHandler, false);
			child.removeEventListener(MouseEvent.ROLL_OUT, child_rollOutHandler, false);
		}
		
		private function child_clickHandler(event:MouseEvent):void {
			if(event.currentTarget is IDataRenderer) {
				if(!event.ctrlKey) { clearSelection(); }
				toggleSelection(event.currentTarget.data);
			}
			
			var e:ListEvent = new ListEvent(ListEvent.ITEM_CLICK, false, false, -1, -1, ListEventReason.OTHER, event.currentTarget as IListItemRenderer);
			dispatchComponentEvent(e);
			e = new ListEvent(ListEvent.CHANGE, false, false, -1, -1, ListEventReason.OTHER, event.currentTarget as IListItemRenderer);
			dispatchComponentEvent(e);
		}
		
		private function child_doubleClickHandler(event:MouseEvent):void {
			var e:ListEvent = new ListEvent(ListEvent.ITEM_DOUBLE_CLICK, false, false, -1, -1, ListEventReason.OTHER, event.currentTarget as IListItemRenderer);
			dispatchComponentEvent(e);
		}
		
		private function child_rollOverHandler(event:MouseEvent):void {
			var e:ListEvent = new ListEvent(ListEvent.ITEM_ROLL_OVER, false, false, -1, -1, ListEventReason.OTHER, event.currentTarget as IListItemRenderer);
			dispatchComponentEvent(e);
		}
		
		private function child_rollOutHandler(event:MouseEvent):void {
			var e:ListEvent = new ListEvent(ListEvent.ITEM_ROLL_OUT, false, false, -1, -1, ListEventReason.OTHER, event.currentTarget as IListItemRenderer);
			dispatchComponentEvent(e);
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