package com.openflux.collections
{
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;

	public class VirtualCollection extends ProxyCollection
	{		
		private var _position:int; [Bindable]
		public function get position():int { return _position; }
		public function set position(value:int):void {
			var diff:int = Math.abs(value - position);
			if (diff >= size) {
				dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
			} else if (value > position) {
				dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, 0, -1, getItems(position, position + diff)));
				dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, length - diff, -1, getItems(position + size, position + size + diff)));
			} else if (value < position) {
				dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, length - diff, -1, getItems(position + size - diff, position + size)));
				dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, 0, -1, getItems(position - diff, position)));
			}
			_position = value;
		}
		
		private var _size:int = 10; [Bindable]
		public function get size():int { return _size; }
		public function set size(value:int):void {
			_size = value;
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
		}
		
		//****************************************************
		// ICollectionView
		//****************************************************
		
		override public function get length():int {
			return Math.min(size, source.length - position);
		}
		
		override public function contains(item:Object):Boolean {
			return getItems(position, position+length).indexOf(item) != -1;
		}
				
		override public function getItemAt(index:int):Object {
			return super.getItemAt(position+index);
	    }
	    
	    //************************************************
		// Helper Methods
		//************************************************
	    
	    private function getItems(start:int=0, end:int=0):Array
		{
			var list:IList = source as IList;
			return list.toArray().slice(start, end);
		}
	}
}