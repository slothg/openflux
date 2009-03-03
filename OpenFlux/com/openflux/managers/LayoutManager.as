package com.openflux.managers
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.events.FlexEvent;
	import mx.managers.ILayoutManager;
	import mx.managers.ILayoutManagerClient;
	import mx.core.ApplicationGlobals;

	public class LayoutManager extends EventDispatcher implements ILayoutManager
	{
		private var invalidProperties:Array = [];
		private var invalidSize:Array = [];
		private var invalidDisplayList:Array = [];
		
		private static var instance:ILayoutManager;
		public static function getInstance():ILayoutManager {
			if (!instance) instance = new LayoutManager();
			return instance;
		}
		
		public function LayoutManager(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		private var _usePhasedInstatiation:Boolean = false;
		public function get usePhasedInstantiation():Boolean { return _usePhasedInstatiation; }
		public function set usePhasedInstantiation(value:Boolean):void {
			_usePhasedInstatiation = value;
		}
		
		public function invalidateProperties(obj:ILayoutManagerClient):void
		{
			//trace("invalidateProperties");
			if (invalidProperties.indexOf(obj) == -1)
				invalidProperties.push(obj);
		}
		
		public function invalidateSize(obj:ILayoutManagerClient):void
		{
			//trace("invalidateSize");
			if (invalidSize.indexOf(obj) == -1)
				invalidSize.push(obj);
		}
		
		public function invalidateDisplayList(obj:ILayoutManagerClient):void
		{
			//trace("invalidateDisplayList");
			if (invalidDisplayList.indexOf(obj) == -1)
				invalidDisplayList.push(obj);
		}
		
		public function validateNow():void
		{
			var complete:Array = [];
			
			//trace("validateNow");
			var obj:ILayoutManagerClient;
			
			while (invalidProperties.length > 0) {
				obj = invalidProperties.shift() as ILayoutManagerClient;
				obj.validateProperties();
				if ( complete.indexOf( obj ) == -1 )
					complete.push( obj );
			}
			
			while (invalidSize.length > 0) {
				obj = invalidSize.shift() as ILayoutManagerClient;
				obj.validateSize(true);
				if ( complete.indexOf( obj ) == -1 )
					complete.push( obj );
			}
			
			while (invalidDisplayList.length > 0) {
				obj = invalidDisplayList.shift() as ILayoutManagerClient;
				obj.validateDisplayList();
				if ( complete.indexOf( obj ) == -1 )
					complete.push( obj );
			}
			
			while (complete.length > 0) {
				obj = complete.shift() as ILayoutManagerClient;
				if (!obj.initialized && obj.processedDescriptors)
					obj.initialized = true;
				obj.dispatchEvent(new FlexEvent(FlexEvent.UPDATE_COMPLETE));
			}
			
		}
		
		private var isInited:Boolean = false;
		
		public function validateClient(target:ILayoutManagerClient, skipDisplayList:Boolean=false):void
		{
			if (!isInited && target == mx.core.ApplicationGlobals.application)
			{
				target.addEventListener( Event.ENTER_FRAME, onEnterFrame );
				isInited = true;
			}
			
			trace("validateClient");
			if (invalidProperties.indexOf(target) != -1)
				target.validateProperties();
			if (invalidSize.indexOf(target) != -1)
				target.validateSize();
			if (!skipDisplayList && invalidDisplayList.indexOf(target) != -1)
				target.validateDisplayList();
		}
		
		public function isInvalid():Boolean
		{
			trace("isInvalid");
			return invalidProperties.length > 0 || invalidSize.length > 0 || invalidDisplayList.length > 0;
		}
		
		private function onEnterFrame( event:Event ):void
		{
			validateNow();
		}
		
	}
}