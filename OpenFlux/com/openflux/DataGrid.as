package com.openflux
{
	import com.openflux.controllers.ComplexController;
	import com.openflux.core.IFluxDataGrid;
	import com.openflux.views.DataGridView;
	
	import mx.collections.ArrayCollection;
	
	public class DataGrid extends List implements IFluxDataGrid
	{
		public function DataGrid()
		{
			super();
		}
		
		private var _columns:ArrayCollection; [Bindable]
		[ArrayElementType("com.openflux.core.IFluxDataGridColumn")]
		public function get columns():ArrayCollection { return _columns; }
		public function set columns(value:ArrayCollection):void {
			_columns = value;
		}
		
		override public function set capacitor(value:Array):void {
			for each (var item:Object in value) {
				if (item is DataGridColumn) {
					if (!columns)
						columns = new ArrayCollection([item]);
					else
						columns.addItem(item);
				}
			}
			super.capacitor = value;
		}
		
		override protected function createChildren():void {
			if (!view)
				view = new DataGridView();
			if (!controller)
				controller = new ComplexController([]);
			super.createChildren();
		}
	}
}