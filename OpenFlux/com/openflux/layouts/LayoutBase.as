package com.openflux.layouts
{
	import com.openflux.core.IDataView;
	import com.openflux.layouts.animators.ILayoutAnimator;
	import com.openflux.layouts.animators.TweenAnimator;
	
	import mx.core.IFlexDisplayObject;
	
	public class LayoutBase
	{
		protected var container:IDataView;
		private var _animator:ILayoutAnimator = new TweenAnimator();
		
		public function LayoutBase()
		{
			super();
		}

		public function get animator():ILayoutAnimator { return _animator; }		
		public function set animator(value:ILayoutAnimator):void {
			_animator = value;
		}
		
		public function findItemAt(px:Number, py:Number, seamAligned:Boolean):int {
			var len:int = container.renderers.length - 1;
			if (len == -1) return -1;
			
			for (var i:int = len; i > -1; i--) {
				var child:IFlexDisplayObject = container.renderers[i];
				if (child.x < px && child.x + child.width > px && child.y < py && child.y + child.height > py)
					return i; 
			}
			
			return -1;
		}
		
		public function attach(container:IDataView):void {
			this.container = container;
			if(animator) {
				animator.attach(container);
			}
		}
		
		public function detach(container:IDataView):void {
			this.container = null;
			if(animator) {
				animator.detach(container);
			}
		}
		
	}
}