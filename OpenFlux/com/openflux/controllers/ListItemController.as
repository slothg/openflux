package com.openflux.controllers
{
	import com.openflux.core.IFluxComponent;
	import com.openflux.core.IFluxListItem;
	import com.openflux.core.ISelectable;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	
	/**
	 * Default list item controller
	 */
	public class ListItemController extends ButtonController
	{
		private var listItem:IFluxListItem;
		private var selectedItems:IList;
		private var selectedItemsWatcher:ChangeWatcher;
		
		/**
		 * Constructor
		 */
		public function ListItemController() {
			super();
		}
		
		/**
		 * Set component override method
		 */
		override public function set component(value:IFluxComponent):void {
			super.component = value;
			
			if(value is IFluxListItem) {
				listItem = value as IFluxListItem;
				
				if(selectedItemsWatcher) {
					selectedItemsWatcher.unwatch();
				}
				
				if(listItem && listItem.list) {
					selectedItemsWatcher = BindingUtils.bindSetter(selectedItemsChange, listItem.list, "selectedItems", true);
				}
			}
		}
		
		// ========================================
		// Event Handlers
		// ========================================
		
		private function selectedItemsChange(value:IList):void {
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
			// TODO: this needs to be optimized to take advantage of the collection event info
			updateSelected();
		}
		
		
		// ========================================
		// Utility Functions
		// ========================================
		
		private function updateSelected():void {
			if(component is ISelectable) {
				if(listItem.list && listItem.list.selectedItems) {
					var v:Boolean = listItem.list.selectedItems.getItemIndex(listItem.data) != -1;
					(component as ISelectable).selected = v;
				} else {
					(component as ISelectable).selected = false;
				}
			}
			this.metadata::rollOutHandler(null);
		}
		
	}
}