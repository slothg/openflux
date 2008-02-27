package com.openflux.layouts
{
	import com.openflux.core.IDataView;
	import com.openflux.layouts.animators.ILayoutAnimator;
	import com.openflux.layouts.animators.TweenAnimator;
	
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