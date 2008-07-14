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
	[Event(name="itemClick", type="mx.events.ListEvent")]
	[Event(name="itemDoubleClick", type="mx.events.ListEvent")]
	[Event(name="itemRollOver", type="mx.events.ListEvent")]
	[Event(name="itemRollOut", type="mx.events.ListEvent")]
	
	[Style(name="itemRenderer", type="mx.core.IFactory")] // ???
	[Style(name="layout", type="com.openflux.layouts.ILayout")]
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
			// move to controller
			//_selectedItems.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
			//dispatchEvent(new ListEvent(ListEvent.CHANGE, false, false));
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
		
		
		//********************************************************************
		// Event Listeners
		//********************************************************************
		
		// move to controller
		/*
		private function collectionChangeHandler(event:CollectionEvent):void {
			dispatchEvent(new ListEvent(ListEvent.CHANGE, false, false));
		}
		*/
	}
}