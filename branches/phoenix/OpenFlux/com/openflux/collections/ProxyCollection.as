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
	
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;

	[DefaultProperty("source")]

	/**
	 * Proxy Collection
	 */
	public class ProxyCollection extends Proxy implements IList
	{
		private var ed:EventDispatcher;
		
		/**
		 * Constructor
		 */
		public function ProxyCollection(source:Object=null) {
			super();
			ed = new EventDispatcher(this);
			this.source = source;
		}
		
		// ========================================
		// source property
		// ========================================
		
		private var _source:Object
		
		public function get source():Object { return _source; }
		public function set source(value:Object):void {
			if (_source is IList) {
				_source.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
			}
			
			if (value is IList || value is Array) {
				_source = value;
			} else {
				_source = [value];
			}
			
			if (_source is IList) {
				_source.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
			}
			
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
		}
		
		// ========================================
		// IList Implementation
		// ========================================
		
		public function get length():int {
			return _source.length;
		}
		
		public function getItemAt(index:int, prefetch:int=0):Object {
			return _source is IList ? IList(_source).getItemAt(index, prefetch) : _source[index + prefetch];
		}
		
		public function itemUpdated(item:Object, property:Object=null, oldValue:Object=null, newValue:Object=null):void {
			
		}
		
		public function addItem(item:Object):void {
			if (_source is IList) {
				IList(_source).addItem(item);
			} else {
				_source.push(item);
			}
			
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
		}
		
		public function addItemAt(item:Object, index:int):void {
			if (_source is IList) {
				IList(_source).addItemAt(item, index);
			} else {
				_source.splice(index, 0, item);
			}
			
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
		}
			
		public function getItemIndex(item:Object):int {
			return _source is IList ? IList(_source).getItemIndex(item) : _source.indexOf(item);
		}
		
		public function removeAll():void {
			if (_source is IList) {
				IList(_source).removeAll();
			} else {
				_source.splice(0, length);
			}
			
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
		}
		
		public function removeItemAt(index:int):Object {
			var item:Object = _source is IList ? IList(_source).removeItemAt(index) : _source.splice(index, 1)[0];
						
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
			return item;
		}
		
		public function setItemAt(item:Object, index:int):Object
		{
			var oldItem:Object = _source is IList ? IList(_source).setItemAt(item, index) : _source.splice(index, 1, item)[0];
			
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
			return oldItem;
		}
		
		public function toArray():Array
		{
			return _source is IList ? IList(_source).toArray() : _source.concat();
		}
		
		// ========================================
		// IEventDispatcher
		// ========================================
		
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
		
		// ========================================
		// Proxy Overrides
		// ========================================
		
		override flash_proxy function getProperty(name:*):* {	
	        var index:int = int(parseInt(String(name)));
			return getItemAt(index);
	    }
	    
	    override flash_proxy function hasProperty(name:*):Boolean {
	        var index:int = int(parseInt(String(name)));
	        return index >= 0 && index < length;
	    }
	    
	    override flash_proxy function nextNameIndex(index:int):int {
	        return index < length ? index + 1 : 0;
	    }
	    
	    override flash_proxy function nextName(index:int):String {
	        return (index + 1).toString();
	    }
	    
	    override flash_proxy function nextValue(index:int):* {
	        return this[String(index - 1)];
	    }
		
		override flash_proxy function setProperty(name:*, value:*):void {
			var index:int = int(parseInt(String(name)));
			setItemAt(value, index);
		}
		
	    override flash_proxy function callProperty(name:*, ... rest):* {
	    	return null;
	    }
	    
	    // ========================================
	    // protected methods
	    // ========================================
	    
	    protected function onCollectionChange(event:CollectionEvent):void {
			dispatchEvent(event.clone());
		}
	}
}