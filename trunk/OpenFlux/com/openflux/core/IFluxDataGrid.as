package com.openflux.core
{
	import mx.collections.ArrayCollection;
	import mx.core.IDataRenderer;
		
	public interface IFluxDataGrid extends IDataRenderer
	{
		[ArrayElementType("com.openflux.core.IFluxDataGridColumn")]
		function get columns():ArrayCollection;
		function set columns(value:ArrayCollection):void;
	}
}