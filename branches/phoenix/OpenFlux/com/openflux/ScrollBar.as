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

package com.openflux
{
	
	import com.openflux.core.FluxComponent;
	import com.openflux.core.IFluxScrollBar;
	import com.openflux.controllers.ScrollBarController; ScrollBarController;
	import com.openflux.views.VerticalScrollBarView; VerticalScrollBarView;
	
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