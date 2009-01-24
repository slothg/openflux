package com.openflux.controllers
{
	import com.openflux.views.DataGridView;
	import com.openflux.DataGridRow;
	import com.openflux.List;
	import com.openflux.core.FluxController;
	
	import mx.events.ChildExistenceChangedEvent;

	[ViewHandler(event="childAdd", handler="childAddHandler")]
	public class DataGridRowListController extends FluxController
	{
		[ModelAlias] public var list:List;
		
		metadata function childAddHandler(event:ChildExistenceChangedEvent):void {
			var child:DataGridRow = event.relatedObject as DataGridRow;
			if (child) {
				child.columns = DataGridView(list.parent).component.columns;
			}
		}
		
	}
}