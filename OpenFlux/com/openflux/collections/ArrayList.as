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
	import flash.events.EventDispatcher;
	
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;

	[DefaultProperty("source")]
	public class ArrayList extends EventDispatcher implements IList
	{
		private var _source:Array = [];
		public function get source():Array { return _source; }
		public function set source(value:Array):void {
			_source = value;
		}
		
		public function ArrayList(source:Array=null)
		{
			super();
			
			if (source != null) {
				this.source = source; 
			}
		}
		
		public function get length():int {
			return source.length;
		}
		
		public function addItem(item:Object):void
		{
			source.push(item);
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
		}
		
		public function addItemAt(item:Object, index:int):void
		{
			source.splice(index, 0, item);
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
		}
		
		public function getItemAt(index:int, prefetch:int=0):Object
		{
			return source[prefetch+index];
		}
		
		public function getItemIndex(item:Object):int
		{
			return source.indexOf(item);
		}
		
		public function itemUpdated(item:Object, property:Object=null, oldValue:Object=null, newValue:Object=null):void
		{
			//dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, PropertyChangeEventKind.UPDATE, property, oldValue, newValue, item));
		}
		
		public function removeAll():void
		{
			source.splice(0, length);
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
		}
		
		public function removeItemAt(index:int):Object
		{
			var item:Object = source.splice(index, 1)[0];
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
			return item;
		}
		
		public function setItemAt(item:Object, index:int):Object
		{
			var oldItem:Object = source.splice(index, 1, item)[0];
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
			return oldItem;
		}
		
		public function toArray():Array
		{
			return source.concat();
		}		
	}
}