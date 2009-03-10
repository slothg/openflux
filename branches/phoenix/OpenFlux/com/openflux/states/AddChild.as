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

package com.openflux.states
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class AddChild extends OverrideBase implements IOverride
	{
		private var _relativeTo:DisplayObjectContainer; [Bindable]
		public function get relativeTo():DisplayObjectContainer { return _relativeTo; }
		public function set relativeTo(value:DisplayObjectContainer):void {
			_relativeTo = value;
		}
		
		private var _position:String; [Bindable]
		public function get position():String { return _position; }
		public function set position(value:String):void {
			_position = value;
		}
		
		public function AddChild() {
			super();
		}

		public function initialize():void {
		}
		
		public function apply(parent:DisplayObjectContainer):void {
			var obj:DisplayObjectContainer = relativeTo ? relativeTo : parent;
			
			if (!target || target.parent)
				return;

			switch (position) {
				case "before":
					obj.parent.addChildAt(target as DisplayObject, obj.parent.getChildIndex(obj));
					break;
				case "after":
					obj.parent.addChildAt(target as DisplayObject, obj.parent.getChildIndex(obj) + 1);
					break;
				case "firstChild":
					obj.addChildAt(target as DisplayObject, 0);
					break;
				case "lastChild":
					obj.addChild(target as DisplayObject);
					break;
			}
		}
		
		public function remove(parent:DisplayObjectContainer):void {
			var obj:DisplayObjectContainer = relativeTo ? relativeTo : parent;
			
			switch (position) {
				case "before":
				case "after":
					obj.parent.removeChild(target as DisplayObject);
					break;
				case "firstChild":
				case "lastChild":
				default:
					if (obj == target.parent)
						obj.removeChild(target as DisplayObject);
					break;
			}
		}
		
	}
}