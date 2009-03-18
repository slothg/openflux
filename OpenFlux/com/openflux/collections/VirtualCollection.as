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

package com.openflux.collections
{
	import flash.events.Event;
	
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	/**
	 * Virtual Collection
	 */
	public class VirtualCollection extends ProxyCollection
	{
		/**
		 * Constructor
		 */
		public function VirtualCollection(source:Object) {
			super(source);
		}
		
		// ========================================
		// position property
		// ========================================
		
		private var _position:int;
		
		[Bindable("positionChange")]
		
		/**
		 * Position
		 */
		public function get position():int { return _position; }
		public function set position(value:int):void {
			if (_position != value) {
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
				dispatchEvent(new Event("postionChange"));
			}
		}
		
		// ========================================
		// size property
		// ========================================
		
		private var _size:int = 10;
		
		[Bindable("sizeChange")]
		
		/**
		 * Size
		 */
		public function get size():int { return _size; }
		public function set size(value:int):void {
			if (_size != value) {
				_size = value;
				dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
				dispatchEvent(new Event("sizeChange"));
			}
		}
		
		// ========================================
		// ICollectionView
		// ========================================
		
		override public function get length():int {
			return Math.min(size, source.length - position);
		}
				
		override public function getItemAt(index:int, prefetch:int=0):Object {
			return super.getItemAt(position+index);
	    }
	    
	    // ========================================
		// Helper Methods
		// ========================================
	    
	    private function getItems(start:int=0, end:int=0):Array
		{
			var list:IList = source as IList;
			return list.toArray().slice(start, end);
		}
	}
}