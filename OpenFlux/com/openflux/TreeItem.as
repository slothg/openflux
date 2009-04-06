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
	import com.openflux.controllers.ListItemController; ListItemController
	import com.openflux.controllers.TreeItemController; TreeItemController;
	import com.openflux.core.IFluxTreeItem;
	import com.openflux.views.TreeItemView; TreeItemView;
	
	import flash.events.Event;
	
	[DefaultSetting(view="com.openflux.views.TreeItemView")]
	[DefaultSetting(controller="com.openflux.controllers.ListItemController, com.openflux.controllers.TreeItemController")]
	
	/**
	 * Tree item component
	 */
	public class TreeItem extends ListItem implements IFluxTreeItem
	{
		/**
		 * Constructor
		 */
		public function TreeItem() {
			super();
		}
		
		// ========================================
		// opened property
		// ========================================
		
		private var _opened:Boolean;
		
		[Bindable("openedChange")]
		
		/**
		 * Whether the row should appear expanded or colapsed
		 * 
		 * @see com.openflux.controllers.TreeController
		 */
		public function get opened():Boolean { return _opened; }
		public function set opened(value:Boolean):void {
			if (_opened != value) {
				_opened = value;
				dispatchEvent(new Event("openedChange"));
			}
		}
		
		// ========================================
		// level property
		// ========================================
		
		private var _level:int;
		
		[Bindable("levelChange")]
		
		/**
		 * How deep the data item is within the tree. Aka depth.
		 * 
		 * @see com.openflux.controllers.TreeController
		 */
		public function get level():int { return _level; }
		public function set level(value:int):void {
			if (_level != value) {
				_level = value;
				dispatchEvent(new Event("levelChange"));
			}
		}
		
	}
}