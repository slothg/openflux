package com.openflux.managers
{
	import mx.managers.ICursorManager;

	public class CursorManager implements ICursorManager
	{
		public function CursorManager()
		{
		}

		public function get currentCursorID():int { return 0; }
		public function set currentCursorID(value:int):void {}
		
		public function get currentCursorXOffset():Number { return 0; }
		public function set currentCursorXOffset(value:Number):void {}
		
		public function get currentCursorYOffset():Number { return 0; }
		public function set currentCursorYOffset(value:Number):void {}
		
		public function showCursor():void {}
		public function hideCursor():void {}
		
		public function setCursor(cursorClass:Class, priority:int=2, xOffset:Number=0, yOffset:Number=0):int { return 0; }
		
		public function removeCursor(cursorID:int):void {}
		public function removeAllCursors():void {}
		
		public function setBusyCursor():void {}
		public function removeBusyCursor():void {}
		
		public function registerToUseBusyCursor(source:Object):void {}
		public function unRegisterToUseBusyCursor(source:Object):void {}
		
	}
}