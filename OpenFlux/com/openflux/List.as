package com.openflux
{
	
	import com.openflux.core.FluxComponent;
	import com.openflux.core.IEnabled;
	import com.openflux.core.IFluxList;
	//import com.openflux.utils.CollectionUtil;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.events.ListEvent;
	
	[Event(name="change", type="mx.events.ListEvent")]
	[Event(name="itemClick", type="mx.events.ListEvent")]
	[Event(name="itemDoubleClick", type="mx.events.ListEvent")]
	[Event(name="itemRollOver", type="mx.events.ListEvent")]
	[Event(name="itemRollOut", type="mx.events.ListEvent")]
	
	[Style(name="factory", type="mx.core.IFactory")]
	[Style(name="layout", type="com.openflux.layouts.ILayout")]
	
	[DefaultSetting(view="com.openflux.views.ListView")]
	[DefaultSetting(controller="com.openflux.controllers.ListController")]
	public class List extends FluxComponent implements IFluxList, IEnabled
	{
		
		//****************************************************************************
		// IFluxList Implementation
		//****************************************************************************
		
		private var collection:Object; [Bindable] // ICollectionView
		public function get data():Object { return collection; }
		public function set data(value:Object):void {
			collection = value; //CollectionUtil.resolveCollection(value);
		}
		
		private var _selectedItems:ArrayCollection; [Bindable]
		public function get selectedItems():ArrayCollection { return _selectedItems; }
		public function set selectedItems(value:ArrayCollection):void {
			_selectedItems = value;
			// move to controller
			//_selectedItems.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);			
			dispatchEvent(new ListEvent(ListEvent.CHANGE));
		}
		
		
		//****************************************************************************
		// IFluxListItem Implementation (for hierarchical data)
		//****************************************************************************
		/*
		private var _data:Object; [Bindable]
		public function get data():Object { return _data; }
		public function set data(value:Object):void {
			_data = value;
		}
		
		private var _list:IFluxList; [Bindable]
		public function get list():IFluxList { return _list; }
		public function set list(value:IFluxList):void {
			_list = value;
		}
		
		*/
		
	}
}