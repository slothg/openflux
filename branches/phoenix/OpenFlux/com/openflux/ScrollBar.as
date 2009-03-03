package com.openflux
{
	
	import com.openflux.core.FluxComponent;
	import com.openflux.core.IFluxScrollBar;
	
	import flash.events.Event;
	
	[DefaultSetting(view="com.openflux.views.VerticalScrollBarView")]
	[DefaultSetting(controller="com.openflux.controllers.ScrollBarController")]
	
	/**
	 * Scroll bar component that by default is a vertical scroll bar. 
	 * Simply keeps track of the minimum, maximum and current position.
	 * 
	 * @see com.openflux.views.VerticalScrollBarView
	 * @see com.openflux.views.ScrollBarController
	 */
	public class ScrollBar extends FluxComponent implements IFluxScrollBar
	{
		/**
		 * Constructor
		 */
		public function ScrollBar() {
			super();
		}
		
		// ========================================
		// min property
		// ========================================
		
		private var _min:Number = 0;
		
		[Bindable("minChange")]
		
		/**
		 * Minimum scrolling position
		 */
		public function get min():Number { return _min; }
		public function set min(value:Number):void {
			if (_min != value) {
				_min = value;
				if (_position < value) {
					_position = value;
				}
				dispatchEvent(new Event("minChange"));
			}
		}
		
		// ========================================
		// max property
		// ========================================
		
		private var _max:Number = 0;
		
		[Bindable("maxChange")]
		
		/**
		 * Maximum scrolling position
		 */
		public function get max():Number { return _max; }
		public function set max(value:Number):void {
			if (_max != value) {
				_max = value;
				if (value > 0 && _position > value) {
					_position = value;
				}
				dispatchEvent(new Event("maxChange"));
			}
		}
		
		// ========================================
		// max property
		// ========================================
		
		private var _position:Number = 0;
		
		[Bindable("positionChange")]
		
		/**
		 * Current scrolling position. Adjusts to fit within min/max
		 */
		public function get position():Number { return _position; }
		public function set position(value:Number):void {
			if (_position != value) {
				_position = Math.max(Math.min(value, max), min);
				dispatchEvent(new Event("positionChange"));
			}
		}
	}
}