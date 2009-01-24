package com.openflux.controllers
{
	import com.openflux.DataGridHeader;
	import com.openflux.core.FluxController;
	import com.openflux.core.IFluxDataGrid;
	import com.openflux.core.IFluxView;
	
	import mx.core.IUIComponent;
	import mx.events.ChildExistenceChangedEvent;

	[ViewHandler(event="childAdd", handler="childAddHandler")]
	public class DataGridHeaderListController extends FluxController
	{
		[ModelAlias] public var list:IUIComponent;
		
		metadata function childAddHandler(event:ChildExistenceChangedEvent):void {
			var child:DataGridHeader = event.relatedObject as DataGridHeader;
			if (child) {
				child.dataGrid = IFluxView(list.parent).component as IFluxDataGrid;
			}
		}
		
	}
}