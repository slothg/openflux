package com.openflux.views
{
	import com.openflux.animators.IAnimator;
	import com.openflux.animators.TweenAnimator;
	import com.openflux.core.FluxView;
	import com.openflux.layouts.ILayout;
	import com.openflux.layouts.VerticalLayout;
	import com.openflux.utils.MetaStyler;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import mx.events.ResizeEvent;
	import mx.styles.IStyleClient;
	
	public class ContainerView extends FluxView implements IContainerView
	{
		private var _animator:IAnimator;
		private var _layout:ILayout;
		
		private var layoutChanged:Boolean = false;
		
		//*********************************
		// Constructor
		//*********************************
		
		public function ContainerView()
		{
			super();
		}
		
		//************************************
		// Public Properties
		//************************************
		
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
		
		public function get renderers():Array { return getChildren(); }
		
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
			if(_layout && layoutChanged) {
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