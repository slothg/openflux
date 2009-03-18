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
	import com.openflux.controllers.ComplexController;
	import com.openflux.controllers.ListItemController;
	import com.openflux.controllers.TreeItemController;
	import com.openflux.core.IFluxTreeItem;
	import com.openflux.views.TreeDataGridRowView;
	
	public class TreeDataGridRow extends DataGridRow implements IFluxTreeItem
	{
		public function TreeDataGridRow()
		{
			super();
		}
		
		private var _opened:Boolean; [Bindable]
		public function get opened():Boolean { return _opened; }
		public function set opened(value:Boolean):void {
			_opened = value;
		}
		
		private var _level:int; [Bindable]
		public function get level():int { return _level; }
		public function set level(value:int):void {
			_level = value;
		}
		
		override public function newInstance():* {
			return new TreeDataGridRow();
		}
		
		override protected function createChildren():void {
			if (!view) {
				view = new TreeDataGridRowView();
			}
			if (!controller) {
				controller = new ComplexController([new TreeItemController(), new ListItemController()]);
			}
			super.createChildren();
		}
	}
}