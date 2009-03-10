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
	import flash.events.EventDispatcher;
	
	import mx.events.FlexEvent;

	[Event(name="enterState", type="mx.events.FlexEvent")]
	[Event(name="exitState", type="mx.events.FlexEvent")]
	[DefaultProperty("overrides")]
	public class State extends EventDispatcher
	{
		private var initialized:Boolean = false;
		
		public var basedOn:String;
		public var name:String;
		
		[ArrayElementType("com.openflux.states.IOverride")]
		public var overrides:Array = [];
		
		public function State()
		{
			super();
		}

		public function initialize():void {
			if (!initialized) {
				initialized = true;
				for (var i:int = 0; i < overrides.length; i++) {
					IOverride(overrides[i]).initialize();
				}
			}
		}

		public function dispatchEnterState():void {
			dispatchEvent(new FlexEvent(FlexEvent.ENTER_STATE));
		}
		
		public function dispatchExitState():void {
			dispatchEvent(new FlexEvent(FlexEvent.EXIT_STATE));
		}

	}
}