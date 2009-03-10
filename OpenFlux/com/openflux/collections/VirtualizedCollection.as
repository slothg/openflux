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
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;

	public class VirtualizedCollection extends ArrayCollection
	{
		public function VirtualizedCollection(source:Array=null) {
			super(source);
		}
		private var _data:ICollectionView;
		/**
		 * The full collection of items
		 */
		public function get data():ICollectionView { return _data; }
		public function set data(value:ICollectionView):void {
			_data = value;
			var arr:Array = [];
			for (var i:int = 0; i < size; i++) {
				arr.push(_data[position+i]);
			}
			source = arr;
		}
		
		private var _position:int;
		/**
		 * The index of the first item you want displayed. 
		 * Usually bound to ScrollBar.position
		 */
		public function get position():int { return _position; }
		public function set position(value:int):void {
			if (_data && _data.length > value+size) {
				var diff:int = Math.abs(position - value);
				var i:int;
				
				this.disableAutoUpdate();
				
				if (diff >= size) { // all new items
					var arr:Array = [];
					for (i = 0; i < size; i++) {
						arr.push(_data[value+i]);
					}
					source = arr;
				} else if (value > position) { // shift items up
					for (i = 0; i < diff; i++) {
						this.removeItemAt(0);
						this.addItem(_data[position+size+i]);
					}
				} else if (value < position) { // shift items down
					for (i = 0; i < diff; i++) {
						this.removeItemAt(this.length-1);
						this.addItemAt(_data[position-i-1], 0);
					}
				}
				
				this.enableAutoUpdate();
			}
			_position = value;
		}
		
		private var _size:int = 10;
		/**
		 * The number of items you want displayed at a time
		 */
		public function get size():int { return _size; }
		public function set size(value:int):void {
			_size = value;
			// TODO: Optimize this (if nessasary, not sure how often the size is changed)
			var arr:Array = [];
			for (var i:int = 0; i < size; i++) {
				arr.push(_data[position+i]);
			}
			source = arr;
		}
	}
}