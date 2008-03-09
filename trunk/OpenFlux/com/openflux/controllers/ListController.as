package com.openflux.controllers
{
	
	import com.openflux.core.*;
	import com.openflux.events.DataViewEvent;
	
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.core.IDataRenderer;
	import mx.events.ListEvent;
	
	public class ListController extends FluxController
	{
		
		private var list:IFluxList;
		//private var renderers:Dictionary;
		
		override public function set data(value:IFluxComponent):void {
			super.data = value;
			if(value is IFluxList) {
				list = (value as IFluxList);
			}
			//renderers = new Dictionary(true);
		}
		
		override protected function attachEventListeners(view:IEventDispatcher):void {
			super.attachEventListeners(view);
			view.addEventListener(DataViewEvent.DATA_VIEW_CHANGED, dataViewChangedHandler);
			//target.addEventListener(ListEvent.ITEM_CLICK, itemClickHandler);
		}
		
		override protected function detachEventListeners(view:IEventDispatcher):void {
			super.detachEventListeners(view);
			view.removeEventListener(DataViewEvent.DATA_VIEW_CHANGED, dataViewChangedHandler);
			//target.removeEventListener(ListEvent.ITEM_CLICK, itemClickHandler);
		}
		
		
		//***************************************************************
		// Event Listeners
		//***************************************************************
		
		private function dataViewChangedHandler(event:DataViewEvent):void {
			if(event.target is IDataView) {
				var view:IDataView = event.target as IDataView;
				for each(var renderer:IEventDispatcher in view.renderers) {
					// duplicate handlers?
					renderer.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
				}
			}
		}
		
		private function clickHandler(event:MouseEvent):void {
			if(event.currentTarget is IDataRenderer) {
				if(!event.ctrlKey) {
					clearSelection();
				}
				toggleSelection(event.currentTarget.data);
			}
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
				var i:int = list.selectedItems.getItemIndex(item);
				list.selectedItems.removeItemAt(i);
			}
		}
		
		private function clearSelection():void {
			if(list.selectedItems) {
				list.selectedItems.removeAll();
			}
		}
		
	}
}