package com.openflux.containers
{
	import com.openflux.animators.IAnimator;
	import com.openflux.animators.TweenAnimator;
	import com.openflux.core.FluxView;
	import com.openflux.layouts.ILayout;
	import com.openflux.layouts.VerticalLayout;
	import com.openflux.utils.MetaStyler;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	import mx.styles.IStyleClient;
	
	public class Container extends FluxView implements IFluxContainer
	{
		private var _animator:IAnimator;
		private var _layout:ILayout;
		private var _tokens:Dictionary;
		
		private var layoutChanged:Boolean = false;
		private var childrenChanged:Boolean = false;
		
		//*********************************
		// Constructor
		//*********************************
		
		public function Container()
		{
			super();
			_tokens = new Dictionary(true);
		}
		
		//************************************
		// Public Properties
		//************************************
		
		public function get tokens():Dictionary { return _tokens; }
		
		[StyleBinding]
		public function get animator():IAnimator { return _animator; }
		public function set animator(value:IAnimator):void {
			if(_animator) { _animator.detach(this); }
			_animator = value;
			if(_animator) { _animator.attach(this); }
		}
		
		[StyleBinding]
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
			invalidateLayout();
		}
		
		public function get children():Array { return getChildren(); }
		
		//public function get horizontalScrollPosition():Number { return 0; }
		//public function get verticalScrollPosition():Number { return 0; }
		
		//***********************************************
		// Framework Overrides
		//***********************************************
		
		override protected function createChildren():void {
			super.createChildren();
			if (!_animator) {
				_animator = new TweenAnimator();
			}
			if (!_layout) {
				layout = new VerticalLayout();
			}
			childrenChanged = true;
			this.addEventListener(ResizeEvent.RESIZE, resizeHandler);
		}
		
		override protected function measure():void {
			super.measure();
			var point:Point = layout.measure();
			measuredWidth = point.x;
			measuredHeight = point.y;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(childrenChanged) {
				for each(var child:UIComponent in children) {
					if(child.getStyle("width") == null) {
						child.setStyle("width", child.getExplicitOrMeasuredWidth());
					}
					if(child.getStyle("height") == null) {
						child.setStyle("height", child.getExplicitOrMeasuredHeight());
					}
					if(child.width) { child.measuredWidth = child.width; }
					if(child.height) { child.measuredHeight = child.height; }
				}
				childrenChanged = false;
			}
			if(_layout && layoutChanged) {
				for each(var child:UIComponent in children) {
					if(child.getStyle("width") != null) {
						child.width = child.getStyle("width");
					}
					if(child.getStyle("height") != null) {
						child.height = child.getStyle("height");
					}
				}
				layoutChanged = false;
				_layout.update();
			}
		}
		
		override public function stylesInitialized():void {
			super.stylesInitialized();
			if(layout) { MetaStyler.initialize(layout, this.data as IStyleClient); }
			if(animator) { MetaStyler.initialize(animator, this.data as IStyleClient); }
		}
		
		override public function styleChanged(styleProp:String):void {
			super.styleChanged(styleProp);
			if(layout) { MetaStyler.updateStyle(styleProp, layout, this.data as IStyleClient); }
			if(animator) { MetaStyler.updateStyle(styleProp, animator, this.data as IStyleClient); }
		}
		
		public function invalidateLayout():void {
			layoutChanged = true;
			invalidateSize();
			invalidateDisplayList();
		}
		
		//******************************************
		// Event Listeners
		//******************************************
		
		private function resizeHandler(event:ResizeEvent):void {
			invalidateLayout();
		}
	}
}