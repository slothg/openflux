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
	import com.openflux.core.IFluxDataGridColumn;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * Data Grid Column Component
	 */
	public class DataGridColumn extends EventDispatcher implements IFluxDataGridColumn
	{
		/**
		 * Constructor
		 */
		public function DataGridColumn() {
			super();
		}

		// ========================================
		// headerText property
		// ========================================

		private var _headerText:String;
		
		[Bindable("headerTextChange")]
		
		/**
		 * Column header text
		 */
		public function get headerText():String { return _headerText; }
		public function set headerText(value:String):void {
			if (_headerText != value) {
				_headerText = value;
				dispatchEvent(new Event("headerTextChange"));
			}
		}

		// ========================================
		// dataField property
		// ========================================
		
		private var _dataField:String;
		
		[Bindable("dataFieldChange")]
		
		/**
		 * Data field
		 */
		public function get dataField():String { return _dataField; }
		public function set dataField(value:String):void {
			if (_dataField != value) {
				_dataField = value;
				dispatchEvent(new Event("dataFieldChange"));
			}
		}

		// ========================================
		// dataFunction property
		// ========================================
		
		private var _dataFunction:Function;
		
		[Bindable("dataFunctionChange")]
		
		/**
		 * Data function
		 */
		public function get dataFunction():Function { return _dataFunction; }
		public function set dataFunction(value:Function):void {
			if (_dataFunction != value) {
				_dataFunction = value;
				dispatchEvent(new Event("dataFunctionChange"));
			}
		}

		// ========================================
		// width property
		// ========================================
		
		private var _width:Number;
		
		[Bindable("widthChange")]
		
		/**
		 * Width
		 */
		public function get width():Number { return _width; }
		public function set width(value:Number):void {
			if (_width != value) {
				_width = value;
				dispatchEvent(new Event("widthChange"));
			}
		}
		
	}
}