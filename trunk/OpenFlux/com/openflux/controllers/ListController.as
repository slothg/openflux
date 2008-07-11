package com.openflux.controllers
{
	import com.openflux.containers.*;
	import com.openflux.core.*;
	import com.openflux.events.DataViewEvent;
	import com.openflux.layouts.IDragLayout;
	import com.openflux.layouts.ILayout;
	import com.openflux.views.*;
	
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.core.IDataRenderer;
	import mx.events.DragEvent;
	import mx.utils.ObjectUtil;
	
	
	//[ViewHandler(event="mouseDown", handler="mouseDownHandler")]
	public class ListController extends MetaControllerBase implements IFluxController
	{
		
		[EventHandler(event="itemClick", handler="dragCompleteHandler")]
		[ModelAlias] private var list:IFluxList;
		
		//[ViewContract(required="false")] [StyleBinding] public var layout:ILayout;
		
		private var view:IFluxContainer;
		
		override public function set component(value:IFluxComponent):void {
			super.component = value;
			view = component.view as IFluxContainer;
			//view.addEventListener(
		}
		
		public function ListController() {
			super(function(t:*):*{return this[t]});
		}
		
		/*
		override protected function attachEventListeners(view:IEventDispatcher):void {
			super.attachEventListeners(view);
			//this.view = view as IDataView;
			view.addEventListener(DataViewEvent.DATA_VIEW_CHANGED, dataViewChangedHandler);
			//target.addEventListener(ListEvent.ITEM_CLICK, itemClickHandler);
		}
		
		override protected function detachEventListeners(view:IEventDispatcher):void {
			super.detachEventListeners(view);
			//this.view = null;
			view.removeEventListener(DataViewEvent.DATA_VIEW_CHANGED, dataViewChangedHandler);
			//target.removeEventListener(ListEvent.ITEM_CLICK, itemClickHandler);
		}
		*/
		
		//***************************************************************
		// Event Listeners
		//***************************************************************
		/*
		private function dataViewChangedHandler(event:DataViewEvent):void {
			if(event.target is IDataView) {
				var view:IFluxContainer = event.target as IFluxContainer;
				for each(var renderer:IEventDispatcher in view.children) {
					// duplicate handlers?
					renderer.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
				}
			}
		}
		*/
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