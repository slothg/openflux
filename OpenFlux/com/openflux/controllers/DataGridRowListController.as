package com.openflux.controllers
{
	import com.openflux.DataGridRow;
	import com.openflux.List;
	import com.openflux.core.FluxController;
	import com.openflux.core.IFluxView;
	
	import mx.events.ChildExistenceChangedEvent;

	[ViewHandler(event="childAdd", handler="childAddHandler")]
	public class DataGridRowListController extends FluxController
	{
		[ModelAlias] public var list:List;
		
		metadata function childAddHandler(event:ChildExistenceChangedEvent):void {
			var child:DataGridRow = event.relatedObject as DataGridRow;
			if (child) {
				child.columns = (list.parent as IFluxView).component.columns;
			}
		}
		
	}
}