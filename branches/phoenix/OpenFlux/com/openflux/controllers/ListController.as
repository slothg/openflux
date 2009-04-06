// =================================================================
//
// Copyright (c) 2009 The OpenFlux Team http://www.openflux.org
// 
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// =================================================================

package com.openflux.controllers
{	
	import com.openflux.core.FluxController;
	import com.openflux.core.IFluxList;
	import com.openflux.collections.ArrayList;
	
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.IDataRenderer;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.ListEvent;
	import mx.events.ListEventReason;
	
	[ViewHandler(event="childAdd", handler="childAddHandler")]
	[ViewHandler(event="childRemove", handler="childRemoveHandler")]
	
	/**
	 * Default List controller which handles multiple selection and dispatching ITEM_* events
	 */
	public class ListController extends FluxController
	{
		[ModelAlias] public var dispatcher:IEventDispatcher;
		[ModelAlias] [Bindable] public var list:IFluxList;
		
		/**
		 * Constructor
		 */
		public function ListController() {
			super();
		}
		
		// ========================================
		// View Event Handlers
		// ========================================
		
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
		
		// ========================================
		// Child Event Handlers
		// ========================================
		
		private function child_clickHandler(event:MouseEvent):void {
			if(event.currentTarget is IDataRenderer) {
				if(!event.ctrlKey) { clearSelection(); }
				toggleSelection(event.currentTarget.data);
			}
			
			dispatcher.dispatchEvent(new ListEvent(ListEvent.ITEM_CLICK, false, false, -1, -1, ListEventReason.OTHER, event.currentTarget as IListItemRenderer));
			dispatcher.dispatchEvent(new ListEvent(ListEvent.CHANGE, false, false, -1, -1, ListEventReason.OTHER, event.currentTarget as IListItemRenderer));
			dispatcher.dispatchEvent(new Event("selectedItemsChange"));
		}
		
		private function child_doubleClickHandler(event:MouseEvent):void {
			dispatcher.dispatchEvent(new ListEvent(ListEvent.ITEM_DOUBLE_CLICK, false, false, -1, -1, ListEventReason.OTHER, event.currentTarget as IListItemRenderer));
		}
		
		private function child_rollOverHandler(event:MouseEvent):void {
			dispatcher.dispatchEvent(new ListEvent(ListEvent.ITEM_ROLL_OVER, false, false, -1, -1, ListEventReason.OTHER, event.currentTarget as IListItemRenderer));
		}
		
		private function child_rollOutHandler(event:MouseEvent):void {
			dispatcher.dispatchEvent(new ListEvent(ListEvent.ITEM_ROLL_OUT, false, false, -1, -1, ListEventReason.OTHER, event.currentTarget as IListItemRenderer));
		}
		
		// ========================================
		// List Selection Utility Functions
		// ========================================
		
		private function toggleSelection(item:Object):void {
			if(list.selectedItems && list.selectedItems.getItemIndex(item) != -1) {
				removeSelection(item);
			} else {
				addSelection(item);
			}
		}
		
		private function addSelection(item:Object):void {
			if(!list.selectedItems) {
				list.selectedItems = new ArrayList();
			}
			
			if(!list.selectedItems.getItemIndex(item) != -1) {
				list.selectedItems.addItem(item);
			}
		}
		
		private function removeSelection(item:Object):void {
			if(list.selectedItems) {
				var index:int = list.selectedItems.getItemIndex(item);
				
				if (index != -1) {
					list.selectedItems.removeItemAt(index);
				}
			}
		}
		
		private function clearSelection():void {
			if(list.selectedItems) { // update data
				list.selectedItems.removeAll();
			}
			
		}
		
	}
}