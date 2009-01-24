package com.openflux.controllers
{
	import com.openflux.core.FluxController;
	import com.openflux.core.IFluxDataGridHeader;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ICollectionView;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	[ViewHandler(event="click", handler="clickHandler")]
	public class DataGridHeaderController extends FluxController
	{
		[ModelAlias] public var header:IFluxDataGridHeader;
		
		metadata function clickHandler(event:MouseEvent):void {
			var d:ICollectionView = header.dataGrid.data as ICollectionView;
			var s:Sort = d.sort;
			
			if (s && s.fields.length == 1 && s.fields[0].name == header.data.dataField) {
				s.fields[0].descending = !s.fields[0].descending;
			} else {
				s = new Sort();
				s.fields = [new SortField(header.data.dataField)];
				d.sort = s;
			}
			
			d.refresh();
		}
	}
}