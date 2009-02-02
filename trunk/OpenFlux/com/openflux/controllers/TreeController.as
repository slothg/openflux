package com.openflux.controllers
{
	import com.openflux.core.FluxController;
	import com.openflux.core.IFluxList;
	import com.openflux.core.IFluxTreeItem;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
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
			
			dispatchComponentEvent(new TreeEvent(TreeEvent.ITEM_OPENING, false, false, event.item, event.itemRenderer, event.triggerEvent));

			openItem(event.item, index + 1);			
			(event.itemRenderer as IFluxTreeItem).opened = true;
			
			dispatchComponentEvent(new TreeEvent(TreeEvent.ITEM_OPEN, false, false, event.item, event.itemRenderer, event.triggerEvent));
		}
		
		private function itemCloseHandler(event:TreeEvent):void {
			var index:int = DisplayObjectContainer(component.view).getChildIndex(event.itemRenderer as DisplayObject);
			
			closeItem(event.item, index + 1);
			(event.itemRenderer as IFluxTreeItem).opened = false;

			dispatchComponentEvent(new TreeEvent(TreeEvent.ITEM_CLOSE, false, false, event.item, event.itemRenderer, event.triggerEvent));
		}
		
		private function collectionChangeHandler(event:CollectionEvent):void {
			var collection:ArrayCollection = list.data as ArrayCollection;
			var item:Object = collectionItems[event.target];
			
			refreshItem(item, collection.getItemIndex(item));
		}
		
		private function openItem(item:Object, index:int):void {
			var collection:ArrayCollection = list.data as ArrayCollection;
			var data:IList = list.data as IList;
			
			if (!lengths[item]) {
				lengths[item] = item.children.length;
				collectionItems[item.children] = item;
				
				var newItems:Array = item.children.toArray();
				var childIndex:int = index;
				for each (var childItem:Object in newItems.reverse()) {
					collection.source.splice(index, 0, childItem);
					levels[childIndex++] = levels[index-1] != null ? levels[index-1] + 1 : 1;
				}
				
				collection.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, index, -1, newItems));
				
				if (item.children is IEventDispatcher) {
					(item.children as IEventDispatcher).addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler, false, 0, true);
				}
			}	
		}
		
		private function closeItem(item:Object, index:int):void {
			var collection:ArrayCollection = list.data as ArrayCollection;
			
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
				
				var removed:Array = collection.source.splice(index, lengths[item]);
				var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, index, -1, removed);
				collection.dispatchEvent(event);
				
				delete lengths[item];
				delete collectionItems[item.children];
			}
		}
		
		private function refreshItem(item:Object, index:int):void {
			var collection:ArrayCollection = list.data as ArrayCollection;
			
			if (lengths[item]) {
				collection.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, index, -1,
															 collection.source.splice(index, lengths[item])));
				
				collection.source.splice(index, 0, item.children.toArray());
				collection.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, index, -1, item.children.toArray()));
				
				lengths[item] = item.children.length;
			}
		}
	}
}