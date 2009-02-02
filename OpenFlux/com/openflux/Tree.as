package com.openflux
{
	import com.openflux.controllers.ComplexController;
	import com.openflux.controllers.DragListController;
	import com.openflux.controllers.DropListController;
	import com.openflux.controllers.ListController;
	import com.openflux.controllers.TreeController;
	import com.openflux.views.TreeView;
	
	public class Tree extends List
	{
		public function Tree()
		{
			super();
		}
		
		override protected function createChildren():void {
			if (!view) {
				view = new TreeView();
			}
			if (!controller) {
				controller = new ComplexController([new TreeController(), new ListController(), new DragListController(), new DropListController()]);
			}
			super.createChildren();
		}
	}
}