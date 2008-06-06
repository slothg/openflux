package com.openflux.views
{
	import com.openflux.ListItem;
	import com.openflux.containers.Container;
	import com.openflux.core.IFluxList;
	import com.openflux.core.IFluxListItem;
	import com.openflux.layouts.VerticalLayout;
	import com.openflux.utils.CollectionUtil;
	
	import flash.display.DisplayObject;
	
	import mx.collections.ICollectionView;
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	//[Event(name="dataViewChanged", type="com.openflux.events.DataViewEvent")]
	public class DataView extends Container implements IDataView
	{
		private var _collection:ICollectionView;
		
		//private var _content:Object;
		private var _itemRenderer:IFactory;
		private var _renderers:Array = [];
		private var _dragTargetIndex:int = -1;
		
		private var collectionChanged:Boolean;
		
		//*********************************
		// Constructor
		//*********************************
		
		public function DataView()
		{
			super();
		}
		
		//************************************
		// Public Properties
		//************************************
		
		[Bindable] // holds data (like dataProvider)
		public function get collection():Object { return _collection; }
		public function set collection(value:Object):void {
			//_collection = value;
			if(_collection) {
				_collection.removeEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
			}
			_collection = CollectionUtil.resolveCollection(value);
			if(_collection) {
				_collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
			}
			collectionChanged = true;
			invalidateProperties();
			invalidateLayout();
		}
		
		public function get renderer():IFactory { return _itemRenderer; }
		public function set renderer(value:IFactory):void {
			_itemRenderer = value;
		}
		
		override public function get children():Array { return _renderers; }
		
		public function get dragTargetIndex():int { return _dragTargetIndex; }
		public function set dragTargetIndex(value:int):void {
			if (_dragTargetIndex != value) {
				_dragTargetIndex = value;
				invalidateLayout();
			}
		}
		
		//***********************************************
		// Framework Overrides
		//***********************************************
		
		override protected function createChildren():void {
			super.createChildren();
			if(renderer == null) {
				renderer = new ListItem();
			}
			if(layout == null) {
				layout = new VerticalLayout();
			}
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			if(collectionChanged) {
				collectionReset();
				collectionChanged = false;
				//dispatchEvent(new DataViewEvent(DataViewEvent.DATA_VIEW_CHANGED));
			}
		}
		
		//*****************************************
		// Private Functions
		//*****************************************
		
		protected function collectionReset():void {
			for each(var o:DisplayObject in _renderers) {
				removeChild(o);
			}
			_renderers = [];
			for each(var item:Object in collection) {
				addItem(item);
			}
			
			this.invalidateLayout();
		}
		
		protected function addItem(item:Object, index:int = 0):void {
			var instance:UIComponent = renderer.newInstance() as UIComponent;
			instance.styleName = this; // ???
			(instance as IDataRenderer).data = item;
			if(instance is IFluxListItem) (instance as IFluxListItem).list = data as IFluxList;
			
			if (index > 0) {
				_renderers.splice(index, 0, instance);
				addChildAt(instance, index);
			} else {
				_renderers.push(instance);
				addChild(instance);
			}
		}
		
		//******************************************
		// Event Listeners
		//******************************************
		
		private function collectionChangeHandler(event:CollectionEvent):void {
			switch(event.kind) {
				case CollectionEventKind.ADD:
					addItem(collection[event.location], event.location);
					this.invalidateLayout();
					break;
				case CollectionEventKind.REMOVE:
					removeChildAt(event.location);
					children.splice(event.location, 1);					
					this.invalidateLayout();
					break;
				case CollectionEventKind.RESET:
					collectionReset();
					break;
			}
		}
	}
}