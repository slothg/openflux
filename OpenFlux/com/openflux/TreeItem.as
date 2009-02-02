package com.openflux
{
	import com.openflux.controllers.ComplexController;
	import com.openflux.controllers.ListItemController;
	import com.openflux.controllers.TreeItemController;
	import com.openflux.core.IFluxTreeItem;
	import com.openflux.views.TreeItemView;
	
	public class TreeItem extends ListItem implements IFluxTreeItem
	{
		public function TreeItem()
		{
			super();
		}
		
		private var _opened:Boolean; [Bindable]
		public function get opened():Boolean { return _opened; }
		public function set opened(value:Boolean):void {
			_opened = value;
		}
		
		private var _level:int; [Bindable]
		public function get level():int { return _level; }
		public function set level(value:int):void {
			_level = value;
		}
		
		override public function newInstance():* {
			return new TreeItem();
		}
		
		override protected function createChildren():void {
			if (!view) {
				view = new TreeItemView();
			}
			if (!controller) {
				controller = new ComplexController([new TreeItemController(), new ListItemController()]);
			}
			super.createChildren();
		}
		
	}
}