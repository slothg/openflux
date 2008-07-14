package com.openflux.controllers
{
	import com.openflux.core.IFluxComponent;
	import com.openflux.core.IFluxListItem;
	import com.openflux.core.ISelectable;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	//[ViewHandler(event="mouseOver", handler="mouseOverHandler")]
	public class ListItemController extends ButtonController
	{
		
		private var listItem:IFluxListItem;
		private var selectedItems:ArrayCollection;
		private var selectedItemsWatcher:ChangeWatcher;
		
		override public function set component(value:IFluxComponent):void {
			super.component = value;
			if(value is IFluxListItem) {
				listItem = value as IFluxListItem;
				if(selectedItemsWatcher) { selectedItemsWatcher.unwatch(); }
				if(listItem && listItem.list) {
					selectedItemsWatcher = BindingUtils.bindSetter(selectedItemsChange, listItem.list, "selectedItems", true);
				}
			}
		}
		
		
		//****************************************************************
		// Event Handlers
		//****************************************************************
		
		private function selectedItemsChange(value:ArrayCollection):void {
			if(selectedItems) {
				selectedItems.removeEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler, false);
			}
			selectedItems = value;
			if(selectedItems) {
				selectedItems.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler, false, 0, true);
			}
			updateSelected();
		}
		
		private function collectionChangeHandler(event:CollectionEvent):void {
			// this needs to be optimized to take 
			// advantage of the collection event info
			updateSelected();
		}
		
		
		//**************************************
		// Utility Functions
		//**************************************
		
		private function updateSelected():void {
			if(component is ISelectable) {
				if(listItem.list && listItem.list.selectedItems) {
					var v:Boolean = listItem.list.selectedItems.contains(listItem.data);
					(component as ISelectable).selected = v;
				} else {
					(component as ISelectable).selected = false;
				}
			}
		}
		
	}
}