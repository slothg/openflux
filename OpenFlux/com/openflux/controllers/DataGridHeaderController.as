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
	import com.openflux.core.IFluxDataGridHeader;
	
	import flash.events.MouseEvent;
	
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	/**
	 * Data Grid Header Controller
	 */
	public class DataGridHeaderController extends FluxController
	{		
		[ModelAlias] public var header:IFluxDataGridHeader;
		
		/**
		 * Constructor
		 */
		public function DataGridHeaderController() {
			super();
		}
		
		[ViewHandler("click")]
		
		/**
		 * Re-sorts the data grid data when the header is clicked
		 */
		metadata function clickHandler(event:MouseEvent):void {
			var l:IList = header.dataGrid.data as IList;
			var a:Array = l ? l.toArray() : header.dataGrid.data as Array;
			
			a.sortOn(header.data.dataField, Array.CASEINSENSITIVE);
			
			if (l) {
				l.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
			}
		}
		
	}
}