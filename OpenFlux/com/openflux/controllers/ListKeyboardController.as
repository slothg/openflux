package com.openflux.controllers
{
	import com.openflux.core.FluxController;
	import com.openflux.core.IFluxList;
	import com.openflux.utils.ListUtil;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;

	[EventHandler(event="keyDown", handler="keyDownHandler")]
	public class ListKeyboardController extends FluxController
	{
		[ModelAlias] public var list:IFluxList;
				
		metadata function keyDownHandler(event:KeyboardEvent):void
		{
			var selectedIndex:int = ListUtil.selectedIndex(list);
			var delta:int = 0;
			
			switch (event.keyCode) {
				case Keyboard.DOWN: delta = 1; break;
				case Keyboard.UP: delta = -1; break;
			}
			
			if (delta != 0) {
				var maxSelectedIndex:int = list.data.length - 1;
				var newSelectedIndex:int = Math.min( Math.max( selectedIndex + delta, 0 ), maxSelectedIndex );
			
				list.selectedItems = new ArrayCollection([ list.data[ newSelectedIndex ] ]);
			}
		}
	}
}