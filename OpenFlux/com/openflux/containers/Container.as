package com.openflux.containers
{
	import com.openflux.ListItem;
	import com.openflux.animators.IAnimator;
	import com.openflux.animators.TweenAnimator;
	import com.openflux.core.FluxFactory;
	import com.openflux.core.FluxView;
	import com.openflux.core.IFluxFactory;
	import com.openflux.core.IFluxList;
	import com.openflux.core.IFluxListItem;
	import com.openflux.layouts.ILayout;
	import com.openflux.layouts.VerticalLayout;
	import com.openflux.utils.CollectionUtil;
	import com.openflux.utils.MetaStyler;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.collections.ICollectionView;
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.styles.IStyleClient;
	
	[DefaultProperty("content")]
	public class Container extends FluxView implements IDataView, IFluxContainer
	{
		
		
		private var collection:ICollectionView;
		
		private var _renderers:Array = [];
		//private var _dragTargetIndex:int = -1;
		
		private var collectionChanged:Boolean;
		
		//*********************************
		// Constructor
		//*********************************
		
		public function Container()
		{
			super();
		}
		
		
		//************************************
		// IDataView implementation
		//************************************
		
		// backing vars
		private var _factory:Object;
		
		// ivalidation flags
		private var childrenChanged:Boolean = false;
		
		
		[Bindable] // holds data (like dataProvider) or UIComponents
		public function get content():* { return collection; }
		public function set content(value:*):void {
			if(collection) {
				collection.removeEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
			}
			collection = CollectionUtil.resolveCollection(value);
			if(collection) {
				collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
			}
			collectionChanged = true;
			layoutChanged = true;
			invalidateProperties();
			//invalidateLayout();
			invalidateDisplayList();
		}
		
		public function get factory():Object { return _factory; }
		public function set factory(value:Object):void {
			_factory = value;
			collectionChanged = true;
			layoutChanged = true;
			invalidateProperties();
			//invalidateLayout();
			invalidateDisplayList();
		}
		
		
		//************************************
		// IFluxContainer Implementation
		//************************************
		
		private var _animator:IAnimator;
		private var _layout:ILayout;
		
		private var layoutChanged:Boolean = false;
		
		[StyleBinding] [Bindable]
		public function get animator():IAnimator { return _animator; }
		public function set animator(value:IAnimator):void {
			if(_animator) { _animator.detach(this); }
			_animator = value;
			if(_animator) { _animator.attach(this); }
		}
		
		[StyleBinding] [Bindable]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void {
			if(_layout) {
				_layout.detach(this);
			}
			_layout = value;
			if(_layout) {
				_layout.attach(this);
				MetaStyler.initialize(_layout, this.data as IStyleClient);
			}
			if(_animator) {
				MetaStyler.initialize(_animator, this.data as IStyleClient);
			}
			layoutChanged = true;
			//invalidateProperties();
			//invalidateLayout();
			invalidateDisplayList();
		}
		
		public function get children():Array { return _renderers; }
		
		/*
		public function get dragTargetIndex():int { return _dragTargetIndex; }
		public function set dragTargetIndex(value:int):void {
			if (_dragTargetIndex != value) {
				_dragTargetIndex = value;
				invalidateLayout();
			}
		}*/
		
		//***********************************************
		// Framework Overrides
		//***********************************************
		
		/** @private */
		override protected function createChildren():void {
			super.createChildren();
			if (animator == null) {
				animator = new TweenAnimator();
			}
			if (layout == null) {
				layout = new VerticalLayout();
			}
			if(factory == null) {
				factory = new ListItem();
			}
			// childrenChanged = true;
		}
		
		/** @private */
		override protected function commitProperties():void {
			super.commitProperties();
			if(collectionChanged) {
				collectionReset();
				collectionChanged = false;
			}
			if(childrenChanged) {
				updateChildren();
				childrenChanged = false;
			}/*
			if(layoutChanged) {
				updateLayout();
				layoutChanged = false;
			}*/
		}
		
		/** @private */
		override protected function measure():void {
			super.measure();
			var point:Point = layout.measure();
			measuredWidth = point.x;
			measuredHeight = point.y;
		}
		
		/** @private */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(layoutChanged) {
				updateLayout();
				layoutChanged = false;
			}
		}
		
		/** @private */
		override public function stylesInitialized():void {
			super.stylesInitialized();
			if(layout) { MetaStyler.initialize(layout, this.data as IStyleClient); }
			if(animator) { MetaStyler.initialize(animator, this.data as IStyleClient); }
		}
		
		/** @private */
		override public function styleChanged(styleProp:String):void {
			super.styleChanged(styleProp);
			if(layout) { MetaStyler.updateStyle(styleProp, layout, this.data as IStyleClient); }
			if(animator) { MetaStyler.updateStyle(styleProp, animator, this.data as IStyleClient); }
		}
		
		//*****************************************
		// Private Functions
		//*****************************************
		
		private function updateLayout():void {
			if(layout && animator) {
				layout.update();
			}
		}
		
		private function updateChildren():void {
			for each(var child:UIComponent in children) {
				if(child.measuredWidth == 0 || child.measuredHeight == 0) {
					child.measuredWidth = child.width;
					child.measuredHeight = child.height;
				}
			}
		}
		
		protected function collectionReset():void {
			for each(var o:DisplayObject in _renderers) {
				removeChild(o);
			}
			_renderers = [];
			for each(var item:Object in collection) {
				addItem(item);
			}
			
			//this.invalidateLayout();
		}
		
		protected function addItem(item:Object, index:int=-1):void {
			var instance:UIComponent;
			var factory:IFluxFactory = new FluxFactory(this.factory as IFactory); // testing CSS Data declarations
			if(item is UIComponent) {
				instance = item as UIComponent;
			} else if(factory is IFluxFactory) {
				instance = factory.createComponent(item) as UIComponent;
			} /*else {
				instance = itemRenderer.newInstance() as UIComponent;
			}*/
			
			instance.styleName = this; // ???
			if(instance is IDataRenderer) {
				(instance as IDataRenderer).data = item;
			}
			if(instance is IFluxListItem) {
				(instance as IFluxListItem).list = component as IFluxList;
			}
			
			if (index != -1) {
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
		
		private function renderHandler(event:Event):void {
			layoutChanged = true;
			invalidateProperties();
		}
		
		private function resizeHandler(event:Event):void {
			layoutChanged = true;
			invalidateSize();
			invalidateProperties();
			invalidateDisplayList();
		}
		
		private function collectionChangeHandler(event:CollectionEvent):void {
			switch(event.kind) {
				case CollectionEventKind.ADD:
					addItem(collection[event.location], event.location);
					//this.invalidateLayout();
					break;
				case CollectionEventKind.REMOVE:
					removeChildAt(event.location);
					//children.splice(event.location, 1);					
					//this.invalidateLayout();
					break;
				case CollectionEventKind.RESET:
					collectionReset();
					break;
			}
		}
	}
}