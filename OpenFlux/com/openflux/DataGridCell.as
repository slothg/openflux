package com.openflux
{
	import com.openflux.controllers.ComplexController;
	import com.openflux.controllers.EditableListItemController;
	import com.openflux.controllers.ListItemController;
	import com.openflux.core.IFluxEditableListItem;
	import com.openflux.views.DataGridCellView;
	
	public class DataGridCell extends ListItem
	{
		public function DataGridCell()
		{
			super();
		}
		
		override public function newInstance():* {
			return new DataGridCell();
		}
		
		override protected function createChildren():void {
			if (!view)
				view = new DataGridCellView();
			if (!controller)
				controller = new ComplexController([new ListItemController(), new EditableListItemController()]);
			super.createChildren();
		}
		
	}
}