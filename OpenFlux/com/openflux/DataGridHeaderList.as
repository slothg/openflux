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
	import com.openflux.controllers.DataGridHeaderListController;
	import com.openflux.controllers.DragListController;
	import com.openflux.controllers.DropListController;
	import com.openflux.controllers.ListController;
	import com.openflux.core.IFluxDataGridColumn;

	/**
	 * Data Grid Header List Component
	 */
	public class DataGridHeaderList extends List
	{
		/**
		 * Constructor
		 */
		public function DataGridHeaderList()
		{
			super();
		}
		
		// ========================================
		// framework overrides
		// ========================================
		
		override protected function createChildren():void {
			if (getStyle("factory") == null) {
				setStyle("factory", DataGridHeader);
			}
			
			if (!controller) {
				controller = new ComplexController([new ListController(), new DataGridHeaderListController()]);
			}
			
			super.createChildren();
		}
	
	} // End class
} // End package