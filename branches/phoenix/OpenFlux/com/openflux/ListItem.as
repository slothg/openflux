package com.openflux
{
	
	import com.openflux.core.FluxComponent;
	import com.openflux.core.IFluxButton;
	import com.openflux.core.IFluxList;
	import com.openflux.core.IFluxListItem;
	import com.openflux.core.ISelectable;
	import mx.core.IFactory;
	
	[DefaultSetting(view="com.openflux.views.ListItemView")]
	[DefaultSetting(controller="com.openflux.controllers.ListItemController")]
	public class ListItem extends FluxComponent implements IFluxListItem, IFluxButton, ISelectable, IFactory 
	{
		
		private var _data:Object;
		private var _list:IFluxList;
		private var _selected:Boolean;
		
		
		[Bindable]
		public function get data():Object { return _data; }
		public function set data(value:Object):void {
			_data = value;
		}
		
		[Bindable]
		public function get list():IFluxList { return _list; }
		public function set list(value:IFluxList):void {
			_list = value;
		}
		
		[Bindable]
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void {
			_selected = value;
		}
		
		
	}
}