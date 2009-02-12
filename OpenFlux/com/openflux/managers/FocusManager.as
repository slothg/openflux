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