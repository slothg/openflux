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