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

package com.openflux.collections
{
	import com.openflux.core.IFluxDataGridColumn;
	
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	/**
	 * Data Grid Row Collection
	 */
	public class DataGridRowCollection extends ProxyCollection
	{
		/**
		 * Constructor
		 */
		public function DataGridRowCollection(rowData:Object=null, source:IList=null) {
			this.rowData = rowData;
			this.source = source;
		}
		
		// ========================================
		// rowData property
		// ========================================
		
		private var _rowData:Object; [Bindable]
		public function get rowData():Object { return _rowData; }
		public function set rowData(value:Object):void {
			_rowData = value;
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
		}
		
		// ========================================
		// override methods
		// ========================================
		
		override public function getItemAt(index:int, prefetch:int=0):Object {
			var column:IFluxDataGridColumn = source.getItemAt(index) as IFluxDataGridColumn;
			return column.dataFunction != null ? column.dataFunction(rowData, column) : getData(column.dataField);
		}
		
		override protected function onCollectionChange(event:CollectionEvent):void {
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
		}
		
		// ========================================
		// private methods
		// ========================================
		
		private function getData( dataField:String ):Object {
			var obj:Object = _rowData;
			
			dataField.split(/\./).forEach(function(item:String, index:int, array:Array):void { obj = obj[item]; });
			
			return obj;
		}
		
	}
}