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
	import com.openflux.core.IEnabled;
	import com.openflux.core.IFluxButton;
	import com.openflux.core.ISelectable;
	import com.openflux.controllers.ButtonController; ButtonController;
	import com.openflux.views.ButtonView; ButtonView;
	
	import flash.events.Event;
	
	[Style(name="selectable", type="Boolean")]
	[DefaultSetting(view="com.openflux.views.ButtonView")]
	[DefaultSetting(controller="com.openflux.controllers.ButtonController")]
	
	/**
	 * Button component that has a label and is selectable.
	 * 
	 * @see com.openflux.views.ButtonView
	 * @see com.openflux.controllers.ButtonController
	 */
	public class Button extends FluxComponent implements IFluxButton, ISelectable, IEnabled
	{
		/**
		 * Contructor
		 */
		 public function Button() {
		 	super();
		 }
		 
		// ========================================
		// label property
		// ========================================
		
		private var _label:String;
		
		[Bindable("labelChange")]
		
		/**
		 * Label to be displayed by the view
		 */
		public function get label():String { return _label; }
		public function set label(value:String):void {
			if (_label != value) {
				_label = value;
				dispatchEvent(new Event("labelChange"));
			}
		}
		
		// ========================================
		// selected property
		// ========================================
		
		private var _selected:Boolean;
		
		[Bindable("selectedChange")]
		
		/**
		 * Whether the button is currently selected.
		 * Set by ButtonController and used by CheckBoxView
		 * 
		 * @see com.openflux.controllers.ButtonController
		 * @see com.openflux.views.CheckBoxView
		 */
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void {
			if (_selected != value) {
				_selected = value;
				dispatchEvent(new Event("selectedChange"));
			}
		}
	}
}