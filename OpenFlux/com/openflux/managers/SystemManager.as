package com.openflux.managers
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import mx.core.IChildList;
	import mx.core.ISWFBridgeGroup;
	import mx.managers.IFocusManagerContainer;
	import mx.managers.ISystemManager;

	public class SystemManager extends MovieClip implements ISystemManager
	{
		public function SystemManager() {
			super();
			
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			} else {
				isStageRoot = false;
			}
			
			if (root && root.loaderInfo)
				root.loaderInfo.addEventListener(Event.INIT, initHandler);
		}
		
		private var isStageRoot:Boolean = true;
		
		private function initHandler(event:Event):void {}
		public function create(... parameters):Object { return null; }
		public function info():Object { return null; }
		
		private var _document:Object;
		public function get document():Object { return _document; }
		public function set document(value:Object):void {
			_document = value;
		}
		
		private var _focusPane:Sprite;
		public function get focusPane():Sprite { return _focusPane; }
		public function set focusPane(value:Sprite):void {
			_focusPane = value;
		}
		
		private var _numModalWindows:int;
		public function get numModalWindows():int { return _numModalWindows; }	
		public function set numModalWindows(value:int):void {
			_numModalWindows = value;
		}
		
		public function get cursorChildren():IChildList { return null; }
		public function get embeddedFontList():Object { return null; }
		public function get popUpChildren():IChildList { return null; }
		public function get rawChildren():IChildList { return null; }	
		public function get swfBridgeGroup():ISWFBridgeGroup { return null; }
		public function get screen():Rectangle { return null; }
		public function get toolTipChildren():IChildList { return null; }
		public function get topLevelSystemManager():ISystemManager { return null; }
		
		public function addFocusManager(f:IFocusManagerContainer):void {}
		public function removeFocusManager(f:IFocusManagerContainer):void {}
		public function activate(f:IFocusManagerContainer):void {}
		public function deactivate(f:IFocusManagerContainer):void {}
		public function getDefinitionByName(name:String):Object { return null; }
		public function isTopLevel():Boolean { return false; }
		public function isFontFaceEmbedded(tf:TextFormat):Boolean { return false; }
		public function isTopLevelRoot():Boolean { return false; }
		public function getTopLevelRoot():DisplayObject { return null; }
		public function getSandboxRoot():DisplayObject { return null; }
		public function addChildBridge(bridge:IEventDispatcher, owner:DisplayObject):void {}
		public function removeChildBridge(bridge:IEventDispatcher):void {}
		public function dispatchEventFromSWFBridges(event:Event, skip:IEventDispatcher=null, trackClones:Boolean=false, toOtherSystemManagers:Boolean=false):void {}
		public function useSWFBridge():Boolean { return false; }
		public function addChildToSandboxRoot(layer:String, child:DisplayObject):void {}
		public function removeChildFromSandboxRoot(layer:String, child:DisplayObject):void {}
		public function isDisplayObjectInABridgedApplication(displayObject:DisplayObject):Boolean { return false; }
		public function getVisibleApplicationRect(bounds:Rectangle=null):Rectangle { return null; }
		public function deployMouseShields(deploy:Boolean):void {}
	}
}