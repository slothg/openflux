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
	import com.openflux.collections.ArrayList;
	import com.openflux.controllers.ComplexController; ComplexController;
	import com.openflux.core.IFluxDataGrid;
	import com.openflux.core.IFluxDataGridColumn;
	import com.openflux.views.DataGridView; DataGridView;
	
	import flash.events.Event;
	
	import mx.collections.IList;
	
	[DefaultSetting(view="com.openflux.views.DataGridView")]
	[DefaultSetting(controller="com.openflux.controllers.ComplexController")] // empty controller
	
	/**
	 * Data Grid Component
	 */
	public class DataGrid extends List implements IFluxDataGrid
	{
		/**
		 * Constructor
		 */
		public function DataGrid() {
			super();
		}
		
		// ========================================
		// columns property
		// ========================================
		
		private var _columns:IList;
		
		[Bindable("columnsChange")]
		[ArrayElementType("com.openflux.core.IFluxDataGridColumn")]
		
		/**
		 * List of data grid columns
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
		
		override public function set capacitor(value:Array):void {
			for each (var item:Object in value) {
				if (item is IFluxDataGridColumn) {
					if (!columns) {
						columns = new ArrayList([item]);
					} else {
						columns.addItem(item);
					}
				}
			}
			
			super.capacitor = value;
		}
		
	}
}