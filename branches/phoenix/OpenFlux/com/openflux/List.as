package com.openflux
{
	import com.openflux.core.FluxComponent;
	import com.openflux.core.IEnabled;
	import com.openflux.core.IFluxList;
	import com.openflux.controllers.ListController; ListController;
	import com.openflux.views.ListView; ListView;
	import com.openflux.ListItem; ListItem;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.events.ListEvent;
	import mx.collections.IList;
	
	[Event(name="change", type="mx.events.ListEvent")]
	[Event(name="itemClick", type="mx.events.ListEvent")]
	[Event(name="itemDoubleClick", type="mx.events.ListEvent")]
	[Event(name="itemRollOver", type="mx.events.ListEvent")]
	[Event(name="itemRollOut", type="mx.events.ListEvent")]
	
	[Style(name="factory", type="mx.core.IFactory")]
	[Style(name="layout", type="com.openflux.layouts.ILayout")]
	
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
		
		override protected function createChildren():void
		{
			super.createChildren();
			setStyle("factory", ListItem);
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
	}
}