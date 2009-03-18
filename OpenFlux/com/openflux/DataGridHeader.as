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
	import com.openflux.controllers.DataGridHeaderController;
	import com.openflux.controllers.ListItemController;
	import com.openflux.core.IFluxDataGrid;
	import com.openflux.core.IFluxDataGridHeader;
	import com.openflux.views.DataGridHeaderView;
	
	import flash.events.Event;
	
	/**
	 * Data Grid Header Component
	 */
	public class DataGridHeader extends ListItem implements IFluxDataGridHeader
	{
		/**
		 * Constructor
		 */
		public function DataGridHeader() {
			super();
		}
		
		// ========================================
		// dataGrid property
		// ========================================
		
		private var _dataGrid:IFluxDataGrid;
		
		[Bindable("dataGridChange")]
		
		/**
		 * Data grid instance
		 */
		public function get dataGrid():IFluxDataGrid { return _dataGrid; }
		public function set dataGrid(value:IFluxDataGrid):void {
			if (_dataGrid != value) {
				_dataGrid = value;
				dispatchEvent(new Event("dataGridChange"));
			}
		}
		
		// ========================================
		// framework overrides
		// ========================================
		
		override protected function createChildren():void {
			if (!view) {
				view = new DataGridHeaderView();
			}
			
			if (!controller) {
				controller = new ComplexController([new ListItemController(), new DataGridHeaderController()]);
			}
			
			super.createChildren();
		}
		
	} // End class
} // End package