package com.openflux
{
	import com.openflux.core.IFluxDataGridColumn;
	
	public class DataGridColumn implements IFluxDataGridColumn
	{
		public function DataGridColumn()
		{
		}

		private var _headerText:String; [Bindable]
		public function get headerText():String { return _headerText; }
		public function set headerText(value:String):void {
			_headerText = value;
		}
		
		private var _dataField:String; [Bindable]
		public function get dataField():String { return _dataField; }
		public function set dataField(value:String):void {
			_dataField = value;
		}
		
		private var _dataFunction:Function; [Bindable]
		public function get dataFunction():Function { return _dataFunction; }
		public function set dataFunction(value:Function):void {
			_dataFunction = value;
		}
		
		private var _width:Number; [Bindable]
		public function get width():Number { return _width; }
		public function set width(value:Number):void {
			_width = value;
		}
	}
}