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
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	
	import mx.core.IButton;
	import mx.managers.IFocusManager;
	import mx.managers.IFocusManagerComponent;

	public class FocusManager implements IFocusManager
	{
		public function FocusManager()
		{
		}

		private var _defaultButton:IButton;
		public function get defaultButton():IButton { return _defaultButton; }
		public function set defaultButton(value:IButton):void {
			_defaultButton = value;
		}
		
		private var _defaultButtonEnabled:Boolean;
		public function get defaultButtonEnabled():Boolean { return _defaultButtonEnabled; }
		public function set defaultButtonEnabled(value:Boolean):void {
			_defaultButtonEnabled = value;
		}
		
		private var _focusPane:Sprite;
		public function get focusPane():Sprite { return _focusPane; }
		public function set focusPane(value:Sprite):void {
			_focusPane = value;
		}
		
		public function get nextTabIndex():int { return 0; }
		
		private var _showFocusIndicator:Boolean;
		public function get showFocusIndicator():Boolean { return _showFocusIndicator; }
		public function set showFocusIndicator(value:Boolean):void {
			_showFocusIndicator = value;
		}
		
		private var _focus:IFocusManagerComponent;
		public function getFocus():IFocusManagerComponent { return _focus; }
		public function setFocus(o:IFocusManagerComponent):void {
			_focus = o;
		}
		
		private var visible:Boolean;
		public function showFocus():void { visible = true; }
		public function hideFocus():void { visible = false; }
		
		private var enabled:Boolean;
		public function activate():void { enabled = true; }
		public function deactivate():void { enabled = false; }
		
		public function findFocusManagerComponent(o:InteractiveObject):IFocusManagerComponent { return null; }
		public function getNextFocusManagerComponent(backward:Boolean=false):IFocusManagerComponent { return null; }
		
		public function moveFocus(direction:String, fromDisplayObject:DisplayObject=null):void {}
		
		public function addSWFBridge(bridge:IEventDispatcher, owner:DisplayObject):void {}
		public function removeSWFBridge(bridge:IEventDispatcher):void {}
		
	}
}