package com.openflux
{
	import com.openflux.controllers.ListController;
	import com.openflux.core.FluxComponent;
	import com.openflux.core.IEnabled;
	import com.openflux.core.IFluxList;
	import com.openflux.utils.CollectionUtil;
	import com.openflux.views.ListView;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.events.CollectionEvent;
	import mx.events.ListEvent;
	
	[Event(name="change", type="mx.events.ListEvent")]
	[Style(name="itemRenderer")]
	[Style(name="layout", type="com.openflux.core.layouts.ILayout")]
	public class List extends FluxComponent implements IFluxList, IEnabled
	{
		
		//****************************************************************************
		// IFluxList Implementation
		//****************************************************************************
		
		private var collection:ICollectionView; [Bindable]
		public function get dataProvider():Object { return collection; }
		public function set dataProvider(value:Object):void {
			collection = CollectionUtil.resolveCollection(value);
		}
		
		private var _selectedItems:ArrayCollection; [Bindable]
		public function get selectedItems():ArrayCollection { return _selectedItems; }
		public function set selectedItems(value:ArrayCollection):void {
			_selectedItems = value;
			_selectedItems.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
			dispatchEvent(new ListEvent(ListEvent.CHANGE, false, false));
		}
		
		
		//*****************************************************************
		// Framework Overrides
		//*****************************************************************
		
		override protected function createChildren():void {
			if(!controller) {
				controller = new ListController();
			}
			if(!view) {
				view = new ListView();
			}
			
		}
		/*
		override protected function measure():void {
			super.measure();
			measuredWidth = 200;
			measuredHeight = 200;
		}
		*/
		
		//********************************************************************
		// Event Listeners
		//********************************************************************
		
		private function collectionChangeHandler(event:CollectionEvent):void {
			dispatchEvent(new ListEvent(ListEvent.CHANGE, false, false));
		}
		
	}
}