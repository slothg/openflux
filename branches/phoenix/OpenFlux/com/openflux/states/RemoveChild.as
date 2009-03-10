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
	import com.openflux.core.PhoenixComponent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class RemoveChild extends OverrideBase implements IOverride
	{
		private var oldParent:DisplayObjectContainer;
		private var oldIndex:int;
		
		public function RemoveChild() {
			super();
		}

		public function initialize():void {
		}
		
		public function apply(parent:DisplayObjectContainer):void {
			if (target.parent) {
				oldParent = target.parent;
				oldIndex = oldParent.getChildIndex(target as DisplayObject);
				oldParent.removeChild(target as DisplayObject);
			}
		}
		
		public function remove(parent:DisplayObjectContainer):void {
			oldParent.addChildAt(target as DisplayObject, oldIndex);
			
			// hmm, do I really need this?
			if (target is PhoenixComponent)
				PhoenixComponent(target).updateCallbacks();
		}
		
	}
}