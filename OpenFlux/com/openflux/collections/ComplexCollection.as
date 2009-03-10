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
	import com.openflux.utils.CollectionUtil;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	/**
	 * This is still mostly broken. don't let it fool you. :-)
	 */
	
	[DefaultProperty("collections")]
	public class ComplexCollection extends ArrayList
	{
		
		private var dictionary:Dictionary = new Dictionary(true); // key:collection
		
		private var _collections:Array;
		
		[Bindable]
		public function get collections():Array { return _collections; }
		public function set collections(value:Array):void {
			for each(var old:IList in _collections) {
				if(old != null) {
					old.removeEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler, false);
					removeCollection(old);
				}
			}
			_collections = new Array();
			for each(var item:Object in value) {
				if(item != null) {
					var collection:IList = CollectionUtil.resolveCollection(item);
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
					refreshCollection(event.target as IList);
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
		
		private function refreshCollection(collection:IList):void {
			for each(var item:Object in collection) {
				this.addItem(item);
			}
		}
		
		private function removeCollection(collection:IList):void {
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