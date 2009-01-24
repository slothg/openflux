package com.openflux.core
{
	public interface IFluxDataGridHeader extends IFluxListItem
	{
		function get dataGrid():IFluxDataGrid;
		function set dataGrid(value:IFluxDataGrid):void;
	}
}