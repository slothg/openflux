package com.openflux.controllers
{
	import com.openflux.core.FluxController;
	import com.openflux.core.IFluxTreeItem;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.events.TreeEvent;

	public class TreeItemController extends FluxController
	{
		[ModelAlias] public var treeItem:IFluxTreeItem;
		
		[EventHandler(event="click", handler="openButtonClickHandler")]
		[ViewContract] public var openButton:DisplayObject;
		
		metadata function openButtonClickHandler(event:MouseEvent):void
		{
			if (treeItem.opened) {
				dispatchComponentEvent(new TreeEvent(TreeEvent.ITEM_CLOSE, false, false, treeItem.data, treeItem, event));
			} else {
				dispatchComponentEvent(new TreeEvent(TreeEvent.ITEM_OPENING, false, false, treeItem.data, treeItem, event));
			}
		}
	}
}