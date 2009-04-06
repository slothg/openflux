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

package com.openflux.containers
{
	
	import com.openflux.animators.IAnimator;
	import com.openflux.core.IFluxFactory;
	import com.openflux.core.IFluxList;
	import com.openflux.core.IFluxListItem;
	import com.openflux.core.IFluxView;
	import com.openflux.core.PhoenixComponent;
	import com.openflux.layouts.ILayout;
	import com.openflux.utils.MetaInjector;
	import com.openflux.utils.MetaStyler;
	import com.openflux.animators.GTweenyAnimator; GTweenyAnimator;
	import com.openflux.core.FluxFactory; FluxFactory;
	import com.openflux.layouts.ContraintLayout; ContraintLayout;
	
	import flash.display.DisplayObject;
	import flash.events.Event; 
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.IList;
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	import mx.core.IUIComponent;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.styles.IStyleClient;
	
	[DefaultProperty("content")]
	[DefaultSetting(factory="com.openflux.core.FluxFactory")]
	[DefaultSetting(layout="com.openflux.layouts.ContraintLayout")]
	[DefaultSetting(animator="com.openflux.animators.GTweenyAnimator")]
	
	/**
	 * Core view class handling layouts, animation and item renderers
	 */
	public class Container extends PhoenixComponent implements IDataView, IFluxContainer, IDataRenderer
	{	
		//************************************
		// IDataRenderer implementation
		//************************************

		// ========================================
		// data property
		// ========================================

		private var _data:Object;
		
		[Bindable("dataChange")]
		
		public function get data():Object { return _data; }
		public function set data(value:Object):void {
			if (_data != value) {
				_data = value;
				dispatchEvent(new Event("dataChange"));
			}
		}
		
		//************************************
		// IDataView implementation
		//************************************
		
		// ========================================
		// content property
		// ========================================
		
		private var _content:*;
		private var collection:IList;
		private var contentChanged:Boolean = false;
		
		[Bindable("contentChange")]
		
		/**
		 * Holds data (like dataProvider) or UIComponents
		 */
		public function get content():* { return _content; }
		public function set content(value:*):void {
			if (_content != value) {
				if(collection) {
					collection.removeEventListener(CollectionEvent.COLLECTION_CHANGE, contentChangeHandler);
					collection = null;
				}
			
				if(value is IList) {
					_content = value;
					collection = value as IList;
					collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, contentChangeHandler);
				} else if(value is Array) {
					_content = value;
				} else {
					_content = [value];
				}
			
				contentChanged = true;
				invalidateProperties();
				dispatchEvent(new Event("contentChange"));
			}
		}
		
		// ========================================
		// factory property
		// ========================================
		
		private var _factory:IFactory;
		
		[StyleBinding]
		
		/**
		 * Item renderer
		 */
		public function get factory():IFactory { return _factory; }
		public function set factory(value:IFactory):void {
			if (_factory != value) {
				_factory = value;
				contentChanged = true;
				invalidateProperties();
			}
		}
		
		//************************************
		// IFluxContainer Implementation
		//************************************
		
		// ========================================
		// animator property
		// ========================================
		
		private var _animator:IAnimator;
		
		[StyleBinding]
		[Bindable("animatorChange")]
		
		/**
		 * The IAnimator instance used to handle moving and resizing child objects
		 */
		public function get animator():IAnimator { return _animator; }
		public function set animator(value:IAnimator):void {
			if (_animator != value) {
				if(_animator) {
					_animator.detach(this);
				}
				
				_animator = value;
				dispatchEvent(new Event("animatorChange"));
				
				if(_animator) {
					_animator.attach(this);
				}
			}
		}
		
		// ========================================
		// layout property
		// ========================================
		
		private var _layout:ILayout;
		private var layoutChanged:Boolean = false;
		private var invalidateLayoutFlag:Boolean = true;
		
		[StyleBinding]
		[Bindable("layoutChange")]
		
		/**
		 * The ILayout instance used to handle determining position and size of child objects
		 */
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void {
			if (_layout != value) {
				if(_layout) {
					_layout.detach(this);
				}
				
				trace("layout changed " + value);
				_layout = value;
				layoutChanged = true;
				invalidateProperties();
				dispatchEvent(new Event("layoutChange"));
			}
		}
		
		// ========================================
		// children property
		// ========================================
		
		private var _renderers:Array = [];
		
		public function get children():Array {
			return _renderers;
		}
		
		//***********************************************
		// Framework Overrides
		//***********************************************
		
		/** @private */
		override protected function createChildren():void {
			MetaInjector.createDefaults(this);
			super.createChildren();
		}
		
		/** @private */
		override protected function commitProperties():void {
			super.commitProperties();
			
			if(contentChanged) {
				contentReset();
				contentChanged = false;
			}
			
			if (layoutChanged) {
				layoutChanged = false;
				if(_layout) {
					_layout.attach(this);
					MetaStyler.initialize(_layout, this.data as IStyleClient);
				}
				if(_animator) {
					MetaStyler.initialize(_animator, this.data as IStyleClient);
				}
				invalidateLayoutFlag = true;
			}
			if(invalidateLayoutFlag) {
				updateLayout();
				invalidateLayoutFlag = false;
			}
		}
		
		/** @private */
		override protected function measure():void {
			super.measure();
			if (layout) {
				var point:Point = layout.measure(children); // filter out !includeInLayout later
				measuredWidth = point.x;
				measuredHeight = point.y;
			}
		}
		
		/** @private */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			graphics.clear(); // draw over dead space so drag/mouse operations register
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			graphics.endFill();
			invalidateLayoutFlag = true;
			invalidateProperties();
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
		
		// for convenience, trying to keep private
		private function invalidateLayout():void {
			invalidateLayoutFlag = true;
			invalidateProperties();
		}
		
		private function updateLayout():void {
			if(layout && animator && children.length > 0) {
				animator.begin();
				layout.update(children, new Rectangle(0, 0, width, height));
				animator.end();
			}
		}
		
		protected function contentReset():void {
			for each(var o:DisplayObject in _renderers) {
				removeChild(o);
			}
			_renderers = [];
			var c:Object = collection ? collection : _content;
			for each(var item:Object in c) {
				addItem(item);
			}
			invalidateDisplayList();
		}
		
		protected function addItem(item:Object, index:int=-1):IUIComponent {
			var instance:IUIComponent;
			//var factory:IFluxFactory = new FluxFactory(this.factory as IFactory); // testing CSS Data declarations
			if(item is IUIComponent) {
				instance = item as IUIComponent;
			} else if(factory is IFluxFactory) {
				instance = (factory as IFluxFactory).createComponent(item) as IUIComponent;
				if(instance is IDataRenderer) {
					(instance as IDataRenderer).data = item;
				}
			} else if(factory is IFactory) {
				instance = factory.newInstance() as IUIComponent;
				if(instance is IDataRenderer) {
					(instance as IDataRenderer).data = item;
				}
			}
			
			//instance.styleName = this; // ???

			if(this is IFluxView && instance is IFluxListItem) {
				// this is a little weird, but okay?... maybe?
				(instance as IFluxListItem).list = (this as IFluxView).component as IFluxList;
			}
			
			if (index != -1) {
				_renderers.splice(index, 0, instance);
				addChildAt(instance as DisplayObject, index);
			} else {
				_renderers.push(instance);
				addChild(instance as DisplayObject);
			}
			
			animator.addItem(instance as DisplayObject);
			invalidateDisplayList();
			invalidateSize();
			return instance;
		}
		
		protected function removeItem(item:Object, index:int = -1):IUIComponent {
			var child:DisplayObject = _renderers.splice(index, 1)[0];
			animator.removeItem(child, cleanChild);
			return child as IUIComponent;
		}
		
		private function cleanChild(child:DisplayObject):void {
			removeChild(child);
			invalidateLayout();
			invalidateDisplayList();
			invalidateSize();
		}
		
		//******************************************
		// Event Listeners
		//******************************************
		
		private function contentChangeHandler(event:CollectionEvent):void {
			var i:int;
			switch(event.kind) {
				case CollectionEventKind.ADD:
					for (i = 0; i < event.items.length; i++) {
						addItem(event.items[i] , event.location+i);
					}
					break;
				case CollectionEventKind.REMOVE:
					for (i = 0; i < event.items.length; i++) {
						removeItem(event.items[i] , event.location);
					}
					break;
				case CollectionEventKind.RESET:
					contentChanged = true;
					invalidateProperties();
					break;
			}
		}
	}
}