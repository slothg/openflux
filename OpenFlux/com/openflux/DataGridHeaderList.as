package com.openflux
{
	import com.openflux.controllers.ComplexController;
	import com.openflux.controllers.DataGridHeaderListController;
	import com.openflux.controllers.DragListController;
	import com.openflux.controllers.DropListController;
	import com.openflux.controllers.ListController;
	import com.openflux.core.IFluxDataGridColumn;
	import com.openflux.core.IFluxStrictList;

	public class DataGridHeaderList extends List implements IFluxStrictList
	{
		public function DataGridHeaderList()
		{
			super();
		}
		
		public function validate(item:Object):Boolean
		{
			return item is IFluxDataGridColumn;
		}
		
		override protected function createChildren():void {
			setStyle("factory", new DataGridHeader());
			if (!controller)
				controller = new ComplexController([new ListController(), new DragListController(), new DropListController(), new DataGridHeaderListController()]);
			super.createChildren();
		}
	}
}