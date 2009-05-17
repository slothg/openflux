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
	import com.openflux.collections.ArrayList;
	import com.openflux.containers.IDataView;
	import com.openflux.containers.IFluxContainer;
	import com.openflux.core.FluxController;
	import com.openflux.core.IFluxList;
	import com.openflux.core.IFluxTreeItem;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.IList;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.TreeEvent;
	
	/**
	 * Adds tree functionality to a List component
	 */
	public class TreeController extends FluxController
	{
		private var itemChildrenLength:Dictionary;
		private var collectionItems:Dictionary;
		private var levels:Dictionary;
		private var array:Array;
		private var collection:IList;
		
		[ModelAlias] public var list:IFluxList;
		
		/**
		 * Constructor
		 */
		public function TreeController() {
			super();
			itemChildrenLength = new Dictionary(true);
			collectionItems = new Dictionary(true);
			levels = new Dictionary(true);
		}
		
		// ========================================
		// view event handlers
		// ========================================
		
		[ViewHandler("childAdd")]
		
		/**
		 * Listens for new IFluxTreeItem instances added to the IFluxTree component 
		 * and adds TreeEvent.ITEM_OPENING and TreeEvent.ITEM_CLOSE listeners.
		 */
		metadata function childAddHandler(event:ChildExistenceChangedEvent):void {
			var child:IFluxTreeItem = event.relatedObject as IFluxTreeItem;
			var index:int = DisplayObjectContainer(component.view).getChildIndex(child as DisplayObject);
			
			if (child) {
				// toggle whether the child is open based on whether 
				// its data length is cached in the lengths dictionary
				child.opened = itemChildrenLength[child.data] != null;
				
				// set the child's level (aka depth) within the tree
				child.level = levels[index];
				
				// add TreeEvent listeners
				child.addEventListener(TreeEvent.ITEM_OPENING, childItemOpeningHandler, false, 0, true);
				child.addEventListener(TreeEvent.ITEM_CLOSE, childItemCloseHandler, false, 0, true);
			}
		}
		
		[ViewHandler("childRemove")]
		
		/**
		 * Removes the TreeEvent listeners added by childAddHandler
		 */
		metadata function childRemoveHandler(event:ChildExistenceChangedEvent):void {
			var child:IFluxTreeItem = event.relatedObject as IFluxTreeItem;
			
			if (child) {
				// remove TreeEvent listeners
				child.removeEventListener(TreeEvent.ITEM_OPENING, childItemOpeningHandler, false);
				child.removeEventListener(TreeEvent.ITEM_CLOSE, childItemCloseHandler, false);
			}
		}
		
		[ViewHandler("creationComplete")]
		
		metadata function creationCompleteHandler(event:Event):void {
			initCollection();
		}
		
		// ========================================
		// child event handlers
		// ========================================
		
		/**
		 * Listens for TreeEvent.ITEM_OPENING events on children (IFluxTreeItem instances)
		 */
		private function childItemOpeningHandler(event:TreeEvent):void {
			var index:int = IFluxContainer(component.view).children.indexOf(event.itemRenderer as DisplayObject);
			
			dispatcher.dispatchEvent(new TreeEvent(TreeEvent.ITEM_OPENING, false, false, event.item, event.itemRenderer, event.triggerEvent));

			openItem(event.item, index + 1);			
			IFluxTreeItem(event.itemRenderer).opened = true;
			
			dispatcher.dispatchEvent(new TreeEvent(TreeEvent.ITEM_OPEN, false, false, event.item, event.itemRenderer, event.triggerEvent));
		}
		
		/**
		 * Listens for TreeEvent.ITEM_CLOSE events on children (IFluxTreeItem instances)
		 */
		private function childItemCloseHandler(event:TreeEvent):void {
			var index:int = IFluxContainer(component.view).children.indexOf(event.itemRenderer as DisplayObject);
			
			closeItem(event.item, index + 1);
			IFluxTreeItem(event.itemRenderer).opened = false;

			dispatcher.dispatchEvent(new TreeEvent(TreeEvent.ITEM_CLOSE, false, false, event.item, event.itemRenderer, event.triggerEvent));
		}
		
		// ========================================
		// collection event handlers
		// ========================================
		
		/**
		 * Refresh the rows associated with changed collection
		 */
		private function collectionChangeHandler(event:CollectionEvent):void {
			var item:Object = collectionItems[event.target];
			
			refreshItem(item, array.indexOf(item));
		}
		
		// ========================================
		// private helper methods
		// ========================================
		
		/**
		 * Expand the row, including it's children in the list
		 */
		private function openItem(item:Object, index:int):void {
			if (!itemChildrenLength[item]) { // if not already open
				itemChildrenLength[item] = item.children.length; // cache length
				collectionItems[item.children] = item; // cache collection-to-item reference
				
				var newItems:Array = item.children.toArray();
				var childIndex:int = index;
				
				// open children individually so we can set their level property
				for each (var childItem:Object in newItems.reverse()) {
					array.splice(index, 0, childItem);
					levels[childIndex++] = levels[index-1] != null ? levels[index-1] + 1 : 1;
				}
				
				// dispatch collection event
				collection.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, index, -1, newItems));
				
				// add collection event listener
				if (item.children is IEventDispatcher) {
					IEventDispatcher(item.children).addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler, false, 0, true);
				}
			}
		}
		
		/**
		 * Colapse the row, removing it's children from the list
		 */
		private function closeItem(item:Object, index:int):void {
			if (itemChildrenLength[item]) {
				// remove collection event listener
				if (item.children is IEventDispatcher) {
					IEventDispatcher(item.children).removeEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler, false);
				}
				
				var childIndex:int = index;
				
				// close any open child branches
				for each (var childItem:Object in item.children) {
					if (itemChildrenLength[childItem] && childItem.hasOwnProperty("children")) {
						closeItem(childItem, childIndex + 1);
					}
					
					childIndex++;
				}
				
				// remove direct children
				var removed:Array = array.splice(index, itemChildrenLength[item]);
				
				// dispatch collection event
				collection.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, index, -1, removed));
				
				// delete cache
				delete itemChildrenLength[item];
				delete collectionItems[item.children];
			}
		}
		
		/**
		 * Add or remove rows based on the collection changes
		 */
		private function refreshItem(item:Object, index:int):void {
			if (itemChildrenLength[item]) {
				var added:Array = item.children is IList ? IList(item.children).toArray() : item.children as Array;
				var removed:Array = array.splice(index, itemChildrenLength[item], added);
								
				collection.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, index, -1, removed));
				collection.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, index, -1, added));
				
				itemChildrenLength[item] = item.children.length;
			}
		}
		
		/**
		 * Set the view content to the private collection property
		 */
		private function initCollection():void {
			var dataView:IDataView = component.view as IDataView;
			
			if (!collection) {
				array = list.data is IList ? IList(list.data).toArray() : list.data as Array;
				collection = new ArrayList(array);
			}
			
			if (dataView && dataView.content != collection) {
				dataView.content = collection;
			}
		}
	}
}