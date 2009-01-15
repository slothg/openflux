package com.openflux
{
	import com.openflux.controllers.ScrollBarController;
	import com.openflux.core.FluxComponent;
	import com.openflux.core.IFluxScrollBar;
	import com.openflux.views.VerticalScrollBarView;
	
	public class ScrollBar extends FluxComponent implements IFluxScrollBar
	{
		private var _min:Number = 0;
		private var _max:Number = 0;
		private var _position:Number = 0;
		
		[Bindable]
		public function get min():Number { return _min; }
		public function set min(value:Number):void {
			_min = value;
			if (_position < value ) _position = value;
		}
		
		[Bindable]
		public function get max():Number { return _max; }
		public function set max(value:Number):void {
			_max = value;
			if (value > 0 && _position > value ) _position = value;
		}
		
		[Bindable]
		public function get position():Number { return _position; }
		public function set position(value:Number):void {
			_position = Math.max(Math.min(value, max), min);
		}
		
		//***************************************************
		// Framework Overrides
		//***************************************************
		
		override protected function createChildren():void {
			if(!controller) {
				controller = new ScrollBarController();
			}
			if(!view) {
				view = new VerticalScrollBarView();
			}
			super.createChildren();
		}
		
	}
}