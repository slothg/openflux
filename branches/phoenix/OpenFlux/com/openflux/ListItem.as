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
	
	import com.openflux.core.FluxComponent;
	import com.openflux.core.IFluxButton;
	import com.openflux.core.IFluxList;
	import com.openflux.core.IFluxListItem;
	import com.openflux.core.ISelectable;
	import com.openflux.controllers.ListItemController; ListItemController;
	import com.openflux.views.ListItemView; ListItemView;
	import com.openflux.skins.ListItemSkin; ListItemSkin;
	
	import flash.events.Event;
	
	import mx.core.IFactory;
	
	[DefaultSetting(controller="com.openflux.controllers.ListItemController")]
	[DefaultSetting(view="com.openflux.views.ListItemView")]
	[DefaultSetting(skin="com.openflux.skins.ListItemSkin")]
	
	/**
	 * Default child component of a List.
	 * 
	 * @see com.openflux.views.ListItemView
	 * @see com.openflux.controllers.ListItemController
	 */
	public class ListItem extends FluxComponent implements IFluxListItem, IFluxButton, ISelectable, IFactory 
	{
		/**
		 * Contructor
		 */
		public function ListItem() {
			super();
		}
		
		// ========================================
		// data property
		// ========================================
		
		private var _data:Object;
		
		[Bindable("dataChange")]
		
		/**
		 * Data object for the current list item.
		 * 
		 * @see com.openflux.core.FluxFactory
		 */
		public function get data():Object { return _data; }
		public function set data(value:Object):void {
			if (_data != value) {
				_data = value;
				dispatchEvent(new Event("dataChange"));
			}
		}
		
		// ========================================
		// list property
		// ========================================
		
		private var _list:IFluxList;
		
		[Bindable("listChange")]
		
		/**
		 * Instance of the parent list component
		 */
		public function get list():IFluxList { return _list; }
		public function set list(value:IFluxList):void {
			if (_list != value) {
				_list = value;
				dispatchEvent(new Event("listChange"));
			}
		}
		
		// ========================================
		// selected property
		// ========================================
		
		private var _selected:Boolean;
		
		[Bindable("selectedChange")]
		
		/**
		 * Whether the data item in the list is currently selected
		 * 
		 * @see com.openflux.controllers.ListItemController
		 */
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void {
			if (_selected != value) {
				_selected = value;
				dispatchEvent(new Event("selectedChange"));
			}
		}
	}
}