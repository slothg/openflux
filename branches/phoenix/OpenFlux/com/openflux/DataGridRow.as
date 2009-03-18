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
	import flash.events.Event;
	
	import com.openflux.core.IFluxDataGridRow;
	import com.openflux.views.DataGridRowView;
	
	import mx.collections.IList;
	
	/**
	 * Data Grid Row Component
	 */
	public class DataGridRow extends ListItem implements IFluxDataGridRow
	{
		/**
		 * Constructor
		 */
		public function DataGridRow() {
			super();
		}
		
		// ========================================
		// columns property
		// ========================================
		
		private var _columns:IList;
		
		[Bindable("columnsChange")]
		[ArrayElementType("com.openflux.core.IFluxDataGridColumn")]
		
		/**
		 * Data grid columns
		 */
		public function get columns():IList { return _columns; }
		public function set columns(value:IList):void {
			if (_columns != value) {
				_columns = value;
				dispatchEvent(new Event("columnsChange"));
			}
		}
		
		// ========================================
		// framework overrides
		// ========================================
		
		override protected function createChildren():void {
			if (!view) {
				view = new DataGridRowView();
			}
			
			super.createChildren();
		}
		
	} // End class
} // End package