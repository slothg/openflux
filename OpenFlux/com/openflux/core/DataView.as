package com.openflux.core
{
	import com.openflux.ListItem;
	import com.openflux.events.DataViewEvent;
	import com.openflux.layouts.VerticalLayout;
	import com.openflux.utils.CollectionUtil;
	
	import flash.display.DisplayObject;
	
	import mx.collections.ICollectionView;
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	[Event(name="dataViewChanged", type="com.openflux.events.DataViewEvent")]
	public class DataView extends FluxContainer implements IDataView
	{
		private var _collection:ICollectionView;
		
		private var _content:Object;
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
		public function get content():Object { return _content; }
		public function set content(value:Object):void {
			_content = value;
			if(collection) {
				collection.removeEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
			}
			collection = CollectionUtil.resolveCollection(value);
			if(collection) {
				collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
			}
			collectionChanged = true;
			invalidateProperties();
			invalidateLayout();
		}
		
		public function get itemRenderer():IFactory { return _itemRenderer; }
		public function set itemRenderer(value:IFactory):void {
			_itemRenderer = value;
		}
		
		override public function get renderers():Array { return _renderers; }
		
		public function get dragTargetIndex():int { return _dragTargetIndex; }
		public function set dragTargetIndex(value:int):void {
			if (_dragTargetIndex != value) {
				_dragTargetIndex = value;
				invalidateLayout();
			}
		}
		
		//***********************************************
		// Protected Properties
		//***********************************************
		
		protected function get collection():ICollectionView { return _collection; }
		protected function set collection(value:ICollectionView):void {
			_collection = value;
		}
		
		//***********************************************
		// Framework Overrides
		//***********************************************
		
		override protected function createChildren():void {
			super.createChildren();
			if(itemRenderer == null) {
				itemRenderer = new ListItem();
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
				dispatchEvent(new DataViewEvent(DataViewEvent.DATA_VIEW_CHANGED));
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
			var renderer:UIComponent = itemRenderer.newInstance() as UIComponent;
			renderer.styleName = this; // ???
			(renderer as IDataRenderer).data = item;
			if (renderer is IFluxListItem) (renderer as IFluxListItem).list = data as IFluxList;
			
			if (index > 0) {
				_renderers.splice(index, 0, renderer);
				addChildAt(renderer, index);
			} else {
				_renderers.push(renderer);
				addChild(renderer);
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
					renderers.splice(event.location, 1);					
					this.invalidateLayout();
					break;
				case CollectionEventKind.RESET:
					collectionReset();
					break;
			}
		}
	}
}