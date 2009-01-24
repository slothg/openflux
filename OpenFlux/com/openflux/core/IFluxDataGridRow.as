package com.openflux.core
{
	import mx.collections.ICollectionView;
	
	public interface IFluxDataGridRow extends IFluxListItem
	{
		[ArrayElementType("com.openflux.core.IFluxDataGridColumn")]
		function get columns():ICollectionView;
		function set columns(value:ICollectionView):void;
	}
}