package com.openflux.collections
{
	import com.openflux.core.IFluxDataGridColumn;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	public class DataGridRowCollection extends ProxyCollection
	{
		public function DataGridRowCollection(rowData:Object=null, source:ArrayCollection=null) {
			this.rowData = rowData;
			this.source = source;
		}
		
		private var _rowData:Object; [Bindable]
		public function get rowData():Object { return _rowData; }
		public function set rowData(value:Object):void {
			_rowData = value;
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
		}
		
		override public function getItemAt(index:int):Object {
			var column:IFluxDataGridColumn = source[index] as IFluxDataGridColumn;
			return column.dataFunction != null ? column.dataFunction(rowData, column) : rowData[column.dataField];
		}
		
		override protected function onCollectionChange(event:CollectionEvent):void {
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
		}
	}
}