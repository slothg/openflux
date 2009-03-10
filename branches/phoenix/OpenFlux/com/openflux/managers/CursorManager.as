// =================================================================
//
// Copyright (c) 2009 The OpenFlux Team http://www.openflux.org
// 
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// =================================================================

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