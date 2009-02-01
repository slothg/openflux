package com.openflux
{
	import com.openflux.core.IFluxDataGridRow;
	import com.openflux.views.DataGridRowView;
	
	import mx.collections.ICollectionView;
	
	public class DataGridRow extends ListItem implements IFluxDataGridRow
	{
		public function DataGridRow()
		{
			super();
		}
		
		private var _columns:ICollectionView; [Bindable]
		[ArrayElementType("com.openflux.core.IFluxDataGridColumn")]
		public function get columns():ICollectionView { return _columns; }
		public function set columns(value:ICollectionView):void {
			_columns = value;
		}
		
		override public function newInstance():* {
			return new DataGridRow();
		}
		
		override protected function createChildren():void {
			if (!view)
				view = new DataGridRowView();
			super.createChildren();
		}
		
	}
}