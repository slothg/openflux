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

package com.openflux.core
{
	import com.openflux.containers.Container;
	import com.openflux.utils.MetaStyler;
	import com.openflux.states.State;
	
	import mx.styles.IStyleClient;
	
	/**
	 * View class you would usually extend when creating your own custom views
	 */
	public class FluxView extends Container implements IFluxView
	{
		
		//***********************************************************
		// IFluxView Implementation
		//***********************************************************
		
		private var _component:Object;
		private var _state:String;
		
		/**
		 * Stores the component model instance
		 */
		[Bindable]
		public function get component():Object { return _component; }
		public function set component(value:Object):void {
			_component = value;
		}
		
		[Bindable]
		public function get state():String { return _state; }
		public function set state(value:String):void {
			_state = value;
			for each(var state:State in states) {
				if(state.name == value) {
					super.currentState = value;
				}
			}
		}
		
		//***********************************************************
		// Constructor
		//***********************************************************
		
		/** @private */
		public function FluxView()
		{
			super();
			MetaStyler.initialize(this);
		}
		
		/** @private */
		override public function styleChanged(styleProp:String):void {
			super.styleChanged(styleProp);
			MetaStyler.updateStyle(styleProp, this, this.component as IStyleClient);
		}
	}
}