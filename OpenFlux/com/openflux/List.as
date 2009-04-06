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

package com.openflux
{
	import com.openflux.controllers.ListController;
	import com.openflux.core.FluxComponent;
	import com.openflux.core.IEnabled;
	import com.openflux.core.IFluxList; ListController;
	import com.openflux.views.ListView; ListView;
	import com.openflux.ListItem; ListItem;
	
	import flash.events.Event;
	
	import mx.events.ListEvent;
	import mx.collections.IList;
	import com.openflux.core.IFluxListItem;
	
	[Event(name="change", type="mx.events.ListEvent")]
	[Event(name="itemClick", type="mx.events.ListEvent")]
	[Event(name="itemDoubleClick", type="mx.events.ListEvent")]
	[Event(name="itemRollOver", type="mx.events.ListEvent")]
	[Event(name="itemRollOut", type="mx.events.ListEvent")]
	
	[DefaultSetting(view="com.openflux.views.ListView")]
	[DefaultSetting(controller="com.openflux.controllers.ListController")]
	
	/**
	 * Standard IFluxList component that contains selectable, draggable and 
	 * droppable IFluxListItem instances
	 * 
	 * @see com.openflux.views.ListView
	 * @see com.openflux.controllers.ListController
	 */
	public class List extends FluxComponent implements IFluxList, IEnabled
	{
		/**
		 * Constructor
		 */
		public function List() {
			super();
		}

		// ========================================
		// data property
		// ========================================
		
		private var _data:Object;
		
		[Bindable("dataChange")]
		
		/**
		 * Array of items to display in the list
		 */
		public function get data():Object { return _data; }
		public function set data(value:Object):void {
			if (_data != value) {
				_data = value;
				dispatchEvent(new Event("dataChange"));
			}
		}

		// ========================================
		// selectedItems property
		// ========================================
		
		private var _selectedItems:IList;
		
		[Bindable("selectedItemsChange")]
		
		/**
		 * Array of currently selected items in the list
		 * 
		 * @see com.openflux.controllers.ListController
		 */
		public function get selectedItems():IList { return _selectedItems; }
		public function set selectedItems(value:IList):void {
			if (_selectedItems != value) {
				_selectedItems = value;
				dispatchEvent(new Event("selectedItemsChange"));
			}
		}
		
		// ========================================
		// framework overrides
		// ========================================
		
		override public function set capacitor(value:Array):void {
			for each (var item:Object in value) {
				if (item is IFluxListItem) {
					setStyle("factory", item);
				}
			}
			
			super.capacitor = value;
		}
	}
}