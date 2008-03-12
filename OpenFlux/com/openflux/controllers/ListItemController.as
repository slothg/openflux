package com.openflux.controllers
{
	import com.openflux.core.IFluxComponent;
	import com.openflux.core.IFluxListItem;
	import com.openflux.core.ISelectable;
	
	import flash.events.IEventDispatcher;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	public class ListItemController extends ButtonController
	{
		
		private var ldata:IFluxListItem;
		private var selectedItemsWatcher:ChangeWatcher;
		
		override public function set data(value:IFluxComponent):void {
			if(value is IFluxListItem) {
				ldata = value as IFluxListItem;
				
				if(selectedItemsWatcher) selectedItemsWatcher.unwatch();
				if(ldata && ldata.list)
					selectedItemsWatcher = BindingUtils.bindSetter(selectedItemsChange, ldata.list, "selectedItems", true);
			}
			super.data = value;
		}
		
		/*
		override protected function attachEventListeners(view:IEventDispatcher):void {
			super.attachEventListeners(view);
			
			if(ldata && ldata.list) {
				selectedItemsWatcher = BindingUtils.bindSetter(selectedItemsChange, ldata.list, "selectedItems", true);
			}
		}
		
		override protected function detachEventListeners(target:IEventDispatcher):void {
			super.detachEventListeners(target);
			
			if(selectedItemsWatcher) {
				selectedItemsWatcher.unwatch();
				selectedItemsWatcher = null;
			}
		}
		*/
		
		
		private function selectedItemsChange(value:ArrayCollection):void {
			if(value) {
				value.addEventListener(CollectionEvent.COLLECTION_CHANGE, selectedItems_collectionChangeHandler, false, 0, true);
			}
			updateSelected();
		}
		
		private function selectedItems_collectionChangeHandler(event:CollectionEvent):void {
			updateSelected();
		}
		
		private function updateSelected():void {
			if(ldata is ISelectable) {
				if(ldata.list && ldata.list.selectedItems) {
					(ldata as ISelectable).selected = ldata.list.selectedItems.contains(ldata.data);
				} else {
					(ldata as ISelectable).selected = false;
				}
			}
		}
		
	}
}