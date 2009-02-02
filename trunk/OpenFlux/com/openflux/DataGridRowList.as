package com.openflux
{
	import com.openflux.controllers.ComplexController;
	import com.openflux.controllers.DataGridRowListController;
	import com.openflux.controllers.DragListController;
	import com.openflux.controllers.DropListController;
	import com.openflux.controllers.ListController;
	import com.openflux.core.IFluxStrictList;
	
	public class DataGridRowList extends List implements IFluxStrictList
	{
		public function DataGridRowList()
		{
			super();
		}
		
		public function validate(item:Object):Boolean {
			return !(item is DataGridColumn);
		}
		
		override protected function createChildren():void {
			if (!controller) {
				controller = new ComplexController([new ListController(),
													new DragListController(),
													new DropListController(),
													new DataGridRowListController()]);
			}
			super.createChildren();
		}
		
	}
}