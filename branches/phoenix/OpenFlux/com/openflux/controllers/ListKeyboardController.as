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

package com.openflux.controllers
{
	import com.openflux.core.FluxController;
	import com.openflux.core.IFluxList;
	import com.openflux.utils.ListUtil;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayList;

	[EventHandler(event="keyDown", handler="keyDownHandler")]
	
	/**
	 * Untested controller to add changing list selection using the arrow keys
	 */
	public class ListKeyboardController extends FluxController
	{
		[ModelAlias] public var list:IFluxList;
		
		/**
		 * Constructor
		 */
		public function ListKeyboardController() {
			super();
		}
		
		// =========================================
		// Event handlers
		// ========================================
		
		metadata function keyDownHandler(event:KeyboardEvent):void {
			var selectedIndex:int = ListUtil.selectedIndex(list);
			var delta:int = 0;
			
			switch (event.keyCode) {
				case Keyboard.DOWN: delta = 1; break;
				case Keyboard.UP: delta = -1; break;
			}
			
			if (delta != 0) {
				var maxSelectedIndex:int = list.data.length - 1;
				var newSelectedIndex:int = Math.min( Math.max( selectedIndex + delta, 0 ), maxSelectedIndex );
			
				list.selectedItems = new ArrayList([ list.data[ newSelectedIndex ] ]);
			}
		}
	}
}