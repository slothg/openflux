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
	import com.openflux.core.IFluxTreeItem;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.IList;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.TreeEvent;

	[ViewHandler(event="childAdd", handler="childAddHandler")]
	[ViewHandler(event="childRemove", handler="childRemoveHandler")]
	public class TreeController extends FluxController
	{
		[ModelAlias] public var list:IFluxList;
		[ModelAlias] public var dispatcher:IEventDispatcher;
		
		private var lengths:Dictionary;
		private var collectionItems:Dictionary;
		private var levels:Dictionary;
		
		public function TreeController()
		{
			super();
			lengths = new Dictionary(true);
			collectionItems = new Dictionary(true);
			levels = new Dictionary(true);
		}
		
		metadata function childAddHandler(event:ChildExistenceChangedEvent):void {
			var child:IFluxTreeItem = event.relatedObject as IFluxTreeItem;
			var index:int = DisplayObjectContainer(component.view).getChildIndex(child as DisplayObject);
			
			if (child) {
				child.opened = lengths[child.data] != null;
				child.level = levels[index];
				child.addEventListener(TreeEvent.ITEM_OPENING, itemOpenHandler, false, 0, true);
				child.addEventListener(TreeEvent.ITEM_CLOSE, itemCloseHandler, false, 0, true);
			}
		}
		
		metadata function childRemoveHandler(event:ChildExistenceChangedEvent):void {
			var child:IFluxTreeItem = event.relatedObject as IFluxTreeItem;
			
			if (child) {
				child.removeEventListener(TreeEvent.ITEM_OPENING, itemOpenHandler, false);
				child.removeEventListener(TreeEvent.ITEM_CLOSE, itemCloseHandler, false);
			}
		}
		
		private function itemOpenHandler(event:TreeEvent):void {
			var index:int = DisplayObjectContainer(component.view).getChildIndex(event.itemRenderer as DisplayObject);
			
			dispatcher.dispatchEvent(new TreeEvent(TreeEvent.ITEM_OPENING, false, false, event.item, event.itemRenderer, event.triggerEvent));

			openItem(event.item, index + 1);			
			(event.itemRenderer as IFluxTreeItem).opened = true;
			
			dispatcher.dispatchEvent(new TreeEvent(TreeEvent.ITEM_OPEN, false, false, event.item, event.itemRenderer, event.triggerEvent));
		}
		
		private function itemCloseHandler(event:TreeEvent):void {
			var index:int = DisplayObjectContainer(component.view).getChildIndex(event.itemRenderer as DisplayObject);
			
			closeItem(event.item, index + 1);
			(event.itemRenderer as IFluxTreeItem).opened = false;

			dispatcher.dispatchEvent(new TreeEvent(TreeEvent.ITEM_CLOSE, false, false, event.item, event.itemRenderer, event.triggerEvent));
		}
		
		private function collectionChangeHandler(event:CollectionEvent):void {
			var collection:IList = list.data as IList;
			var item:Object = collectionItems[event.target];
			
			refreshItem(item, collection.getItemIndex(item));
		}
		
		private function openItem(item:Object, index:int):void {
			var collection:IList = list.data as IList;
			var data:IList = list.data as IList;
			
			if (!lengths[item]) {
				lengths[item] = item.children.length;
				collectionItems[item.children] = item;
				
				var newItems:Array = item.children.toArray();
				var childIndex:int = index;
				for each (var childItem:Object in newItems.reverse()) {
					collection.toArray().splice(index, 0, childItem);
					levels[childIndex++] = levels[index-1] != null ? levels[index-1] + 1 : 1;
				}
				
				collection.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, index, -1, newItems));
				
				if (item.children is IEventDispatcher) {
					(item.children as IEventDispatcher).addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler, false, 0, true);
				}
			}	
		}
		
		private function closeItem(item:Object, index:int):void {
			var collection:IList = list.data as IList;
			
			if (lengths[item]) {
				if (item.children is IEventDispatcher) {
					(item.children as IEventDispatcher).removeEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler, false);
				}
				
				var childIndex:int = index;
				for each (var childItem:Object in item.children) {
					if (lengths[childItem] && childItem.hasOwnProperty("children")) {
						closeItem(childItem, childIndex);
					}
					childIndex++;
				}
				
				var removed:Array = collection.toArray().splice(index, lengths[item]);
				var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, index, -1, removed);
				collection.dispatchEvent(event);
				
				delete lengths[item];
				delete collectionItems[item.children];
			}
		}
		
		private function refreshItem(item:Object, index:int):void {
			var collection:IList = list.data as IList;
			
			if (lengths[item]) {
				collection.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, index, -1,
															 collection.toArray().splice(index, lengths[item])));
				
				collection.toArray().splice(index, 0, item.children.toArray());
				collection.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, index, -1, item.children.toArray()));
				
				lengths[item] = item.children.length;
			}
		}
	}
}