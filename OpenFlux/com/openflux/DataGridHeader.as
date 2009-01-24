package com.openflux
{
	import com.openflux.controllers.ComplexController;
	import com.openflux.controllers.DataGridHeaderController;
	import com.openflux.controllers.ListItemController;
	import com.openflux.core.IFluxDataGrid;
	import com.openflux.core.IFluxDataGridHeader;
	import com.openflux.views.DataGridHeaderView;
	
	public class DataGridHeader extends ListItem implements IFluxDataGridHeader
	{
		override public function newInstance():* {
			return new DataGridHeader();
		}
		
		private var _dataGrid:IFluxDataGrid; [Bindable]
		public function get dataGrid():IFluxDataGrid { return _dataGrid; }
		public function set dataGrid(value:IFluxDataGrid):void {
			_dataGrid = value;
		}
		
		override protected function createChildren():void {
			if (!view)
				view = new DataGridHeaderView();
			if (!controller)
				controller = new ComplexController([new ListItemController(), new DataGridHeaderController()]);
		}
	}
}