package com.openflux.collections
{
	import com.openflux.utils.CollectionUtil;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	/**
	 * This is still mostly broken. don't let it fool you. :-)
	 */
	
	[DefaultProperty("collections")]
	public class ComplexCollection extends ArrayCollection
	{
		
		private var dictionary:Dictionary = new Dictionary(true); // key:collection
		
		private var _collections:Array;
		
		[Bindable]
		public function get collections():Array { return _collections; }
		public function set collections(value:Array):void {
			for each(var old:ICollectionView in _collections) {
				if(old != null) {
					old.removeEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler, false);
					removeCollection(old);
				}
			}
			_collections = new Array();
			for each(var item:Object in value) {
				if(item != null) {
					var collection:ICollectionView = CollectionUtil.resolveCollection(item);
					_collections.push(collection);
					collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler, false, 0, true);
					refreshCollection(collection);
				}
			}
		}
		
		public function ComplexCollection(source:Array=null)
		{
			super(source);
		}
		
		private function collectionChangeHandler(event:CollectionEvent):void {
			switch(event.kind) {
				case CollectionEventKind.ADD:
					addCollectionItems(event.items);
					break;
				case CollectionEventKind.MOVE:
					// ???
					break;
				case CollectionEventKind.REFRESH:
					refreshCollection(event.target as ICollectionView);
					break;
				case CollectionEventKind.REMOVE:
					removeCollectionItems(event.items);
					break;
				case CollectionEventKind.REPLACE:
					// ???
					break;
				case CollectionEventKind.RESET:
					// ???
					break;
				case CollectionEventKind.UPDATE:
					// ???
					break;
			}
		}
		
		private function refreshCollection(collection:ICollectionView):void {
			for each(var item:Object in collection) {
				this.addItem(item);
			}
		}
		
		private function removeCollection(collection:ICollectionView):void {
			for each(var item:Object in collection) {
				var index:int = this.getItemIndex(item);
				if(index > -1) this.removeItemAt(index);
			}
		}
		
		private function addCollectionItems(items:Array):void {
			for each(var item:Object in items) {
				this.addItem(item);
			}
		}
		
		private function removeCollectionItems(items:Array):void {
			for each(var item:Object in items) {
				var index:int = this.getItemIndex(item);
				if(index > -1) this.removeItemAt(index);
			}
		}
		
	}
}