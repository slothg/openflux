package com.openflux.controllers
{
	import com.openflux.core.FluxController;
	import com.openflux.core.IFluxList;
	import com.openflux.utils.ListUtil;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayList;

	[EventHandler(event="keyDown", handler="keyDownHandler")]
	
	/**
	 * Untested controller to add changing list selection using the arrow keys
	 */
	public class ListKeyboardController extends FluxController
	{
		[ModelAlias] public var list:IFluxList;
		
		/**
		 * Constructor
		 */
		public function ListKeyboardController() {
			super();
		}
		
		// =========================================
		// Event handlers
		// ========================================
		
		metadata function keyDownHandler(event:KeyboardEvent):void {
			var selectedIndex:int = ListUtil.selectedIndex(list);
			var delta:int = 0;
			
			switch (event.keyCode) {
				case Keyboard.DOWN: delta = 1; break;
				case Keyboard.UP: delta = -1; break;
			}
			
			if (delta != 0) {
				var maxSelectedIndex:int = list.data.length - 1;
				var newSelectedIndex:int = Math.min( Math.max( selectedIndex + delta, 0 ), maxSelectedIndex );
			
				list.selectedItems = new ArrayList([ list.data[ newSelectedIndex ] ]);
			}
		}
	}
}