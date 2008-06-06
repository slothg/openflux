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
	//[ViewHandler(event="dragEnter", handler="dragEnterHadler")]
	[ViewHandler(event="dragOver", handler="dragOverHandler")]
	[ViewHandler(event="dragExit", handler="dragExitHandler")]
	//[ViewHandler(event="dragDrop", handler="dragDropHandler")]
	[ViewHandler(event="dragComplete", handler="dragCompleteHandler")]
	public class ListController extends MetaControllerBase implements IFluxController
	{
		
		[ModelAlias] private var list:IFluxList;
		
		[ViewContract(required="false")] [StyleBinding] public var layout:ILayout;
		
		private var view:IFluxContainer;
		
		//private var _allowDrag:Boolean = true;
		//private var _allowDrop:Boolean = true;
		
		override public function set component(value:IFluxComponent):void {
			super.component = value;
			view = component.view as IFluxContainer;
			/*if(value is IFluxList) {
				list = (value as IFluxList);
			}*/
		}
		/*
		public function get allowDrag():Boolean { return _allowDrag; }
		public function set allowDrag(value:Boolean):void {
			_allowDrag = value;
		}
		
		public function get allowDrop():Boolean { return _allowDrop; }
		public function set allowDrop(value:Boolean):void {
			_allowDrop = value;
		}
		*/
		public function ListController() {
			super(function(t:*):*{return this[t]});
		}
		
		/*
		override protected function attachEventListeners(view:IEventDispatcher):void {
			super.attachEventListeners(view);
			//this.view = view as IDataView;
			view.addEventListener(DataViewEvent.DATA_VIEW_CHANGED, dataViewChangedHandler);
			//target.addEventListener(ListEvent.ITEM_CLICK, itemClickHandler);
			//view.addEventListener(MouseEvent.MOUSE_DOWN, dragStartHandler);
			//view.addEventListener(DragEvent.DRAG_ENTER, dragEnterHandler);
			//view.addEventListener(DragEvent.DRAG_OVER, dragOverHandler);
			//view.addEventListener(DragEvent.DRAG_EXIT, dragOutHandler);
			//view.addEventListener(DragEvent.DRAG_DROP, dragDropHandler);
			//view.addEventListener(DragEvent.DRAG_COMPLETE, dragCompleteHandler);
		}
		
		override protected function detachEventListeners(view:IEventDispatcher):void {
			super.detachEventListeners(view);
			//this.view = null;
			view.removeEventListener(DataViewEvent.DATA_VIEW_CHANGED, dataViewChangedHandler);
			//target.removeEventListener(ListEvent.ITEM_CLICK, itemClickHandler);
			//view.removeEventListener(MouseEvent.MOUSE_DOWN, dragStartHandler);
			//view.removeEventListener(DragEvent.DRAG_ENTER, dragEnterHandler);
			//view.removeEventListener(DragEvent.DRAG_OVER, dragOverHandler);
			//view.removeEventListener(DragEvent.DRAG_EXIT, dragOutHandler);
			//view.removeEventListener(DragEvent.DRAG_DROP, dragDropHandler);
			//view.removeEventListener(DragEvent.DRAG_COMPLETE, dragCompleteHandler);
		}
		*/
		
		//***************************************************************
		// Event Listeners
		//***************************************************************
		
		private function dataViewChangedHandler(event:DataViewEvent):void {
			if(event.target is IDataView) {
				var view:IFluxContainer = event.target as IFluxContainer;
				for each(var renderer:IEventDispatcher in view.children) {
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
		
		//***************************************************************
		// Drag And Drop Event Listeners
		//***************************************************************
		
		/**
		 * dragStartHandler
		 * Initiate the drag
		 *//*
		private function dragStartHandler(event:MouseEvent):void {
			if (!_allowDrag) return;
			
			// Search for item renderer index at local x/y
			var p:Point = view.globalToLocal(new Point(event.stageX, event.stageY));
			var dragIdx:Number = -1;
			if(view.layout is IDragLayout) {
				IDragLayout(view.layout).findItemAt(p.x, p.y, false);
			}
			if(dragIdx == -1) return;
			
			// Reference the item renderer
			// If it's a 3D renderer, the UIComponent is at item.material.movie
			// ahhh!!! why's this here? :-)
			var dragItem:IUIComponent = view.renderers[dragIdx].hasOwnProperty("material") ? view.renderers[dragIdx].material.movie : view.renderers[dragIdx];
			if (!dragItem) return;
			
			// Init the DragImage and DragSource
			var dragImage:IFlexDisplayObject = new UIBitmap(dragItem, PixelSnapping.NEVER);			
			var dragSrc:DragSource = new DragSource();
			dragSrc.addData([list.dataProvider[dragIdx]], "items");
			dragSrc.addData(dragIdx, "index");
			
			DragManager.doDrag(view, dragSrc, event, dragImage, -dragItem.x , -dragItem.y, .6, true);
		}*/

		/**
		 * dragEnterHandler
		 * Initiate the drop
		 *//*
		private function dragEnterHandler(event:DragEvent):void {
			if (!_allowDrop) return;
			
			// Blindly accept the drag
			event.action = "move";
			DragManager.acceptDragDrop(view);
			DragManager.showFeedback(event.action);
		}*/
		
		private var indices:Array;
		
		/**
		 * dragOverHandler
		 * Update the position
		 */
		private function dragOverHandler(event:DragEvent):void {
			// Update the target index
			// TODO: Get the layouts actually showing drag feedback
			var p:Point = (view as DisplayObject).globalToLocal(new Point(event.stageX, event.stageY));
			//DragManager.showFeedback(event.action);
			/*if(view.layout is IDragLayout) {
				view.dragTargetIndex = IDragLayout(view.layout).findItemAt(p.x, p.y, true);
			}*/
			if(layout is IDragLayout) {
				var index:Array = [IDragLayout(layout).findItemAt(p.x, p.y, true)];
				if(ObjectUtil.compare(index, indices)) {
					layout.update(indices = index);
				}
			}
		}
		
		/**
		 * dragOutHandler
		 * Undefine the position
		 */
		private function dragExitHandler(event:DragEvent):void {
			//view.dragTargetIndex = -1;
			//if(layout) layout.dragItems = null;
			if(layout) layout.update();
		}
		
		/**
		 * dragDropHandler
		 * Drop the item
		 *//*
		private function dragDropHandler(event:DragEvent):void {
			// Search for item renderer index a local x/y
			var p:Point = view.globalToLocal(new Point(event.stageX, event.stageY));
			var dropIndex:int = -1;
			if(view.layout is IDragLayout) {
				view.dragTargetIndex = IDragLayout(view.layout).findItemAt(p.x, p.y, true);
			}
			if (dropIndex == -1) return;
			
			// Save target view for later
			if(event.dragInitiator == view)
				event.dragSource.addData(view, "target");

			var item:Object = (event.dragSource.dataForFormat("items") as Array)[0];

			if(event.dragInitiator == view) {				
				DragManager.showFeedback(event.action);
				var dragFromIndex:Number = Number(event.dragSource.dataForFormat("index"));

				// Move the item to it's new home (on the same list)		
				if(dropIndex > dragFromIndex) {
					(list.dataProvider as ArrayCollection).addItemAt(item, dropIndex);
					(list.dataProvider as ArrayCollection).removeItemAt(dragFromIndex);
				} else {
					(list.dataProvider as ArrayCollection).removeItemAt(dragFromIndex);
					(list.dataProvider as ArrayCollection).addItemAt(item, dropIndex);
				}
			} else {
				// Add the item to a new list
				(list.dataProvider as ArrayCollection).addItemAt(item, dropIndex);
			}
			
			view.dragTargetIndex = -1;
		}*/

		/**
		 * dragCompleteHandler
		 * Clean up
		 */
		private function dragCompleteHandler(event:DragEvent):void {
			/*if(event.action == DragManager.MOVE && event.dragSource.dataForFormat("target") != view) {
				// Remove the item from the list it no longer belongs to
				var dragFromIndex:Number = Number(event.dragSource.dataForFormat("index"));
				(list.dataProvider as ArrayCollection).removeItemAt(dragFromIndex);
			}*/
			
			view.invalidateLayout();
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