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
	import flash.events.EventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;

	public class VirtualCollection extends Proxy implements ICollectionView
	{
		public function VirtualCollection() {
			super();
			ed = new EventDispatcher(this);
		}
		
		private var _data:ICollectionView;
		public function get data():ICollectionView { return _data; }
		public function set data(value:ICollectionView):void {
			_data = value;
			ed.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
		}
		
		private var _position:int;
		public function get position():int { return _position; }
		public function set position(value:int):void {
			var diff:int = Math.abs(value - position);
			if (diff >= size) {
				ed.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
			} else if (value > position) {
				ed.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, 0, -1, getItems(position, position + diff)));
				ed.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, length - diff, -1, getItems(position + size, position + size + diff)));
			} else if (value < position) {
				ed.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, length - diff, -1, getItems(position + size - diff, position + size)));
				ed.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, 0, -1, getItems(position - diff, position)));
			}
			_position = value;
		}
		
		private var _size:int = 10;
		public function get size():int { return _size; }
		public function set size(value:int):void {
			_size = value;
			ed.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
		}
		
		public function get length():int {
			return Math.min(size, data.length - position);
		}
		
		public function contains(item:Object):Boolean {
			return getItems(position, position+length).indexOf(item) != -1;
		}

		private function getItems(start:int=0, end:int=0):Array
		{
			var list:IList = data as IList;
			return list.toArray().slice(start, end);
		}
		
		private var ed:EventDispatcher;
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			return ed.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			return ed.removeEventListener(type, listener, useCapture);
		}
		public function dispatchEvent(event:Event):Boolean {
			return ed.dispatchEvent(event);
		}
		public function hasEventListener(type:String):Boolean {
			return ed.hasEventListener(type);
		}
		public function willTrigger(type:String):Boolean {
			return ed.willTrigger(type);
		}
		
		override flash_proxy function getProperty(name:*):* {	
	        var index:int = int(parseInt(String(name)));
			return data[position+index];
	    }
	    
	    override flash_proxy function hasProperty(name:*):Boolean {
	        var index:int = int(parseInt(String(name)));
	        return index >= 0 && index < length;
	    }
	    
	    override flash_proxy function nextNameIndex(index:int):int {
	        return index < length ? index + 1 : 0;
	    }
	    
	    override flash_proxy function nextName(index:int):String {
	        return (index - 1).toString();
	    }
	    
	    override flash_proxy function nextValue(index:int):* {
	        return data[position + index - 1];
	    }    
	
		// not allowed or unused
	    override flash_proxy function setProperty(name:*, value:*):void {}
	    override flash_proxy function callProperty(name:*, ... rest):* { return null; }
	    public function itemUpdated(item:Object, property:Object=null, oldValue:Object=null, newValue:Object=null):void { }
	    public function disableAutoUpdate():void { }
		public function enableAutoUpdate():void { }
		public function createCursor():IViewCursor { return null; }
		public function get filterFunction():Function { return null; }
		public function set filterFunction(value:Function):void {}
		public function get sort():Sort { return null; }
		public function set sort(value:Sort):void {}
		public function refresh():Boolean { return false; }
	}
}