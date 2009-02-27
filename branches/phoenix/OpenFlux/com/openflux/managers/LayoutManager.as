package com.openflux.managers
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.managers.ILayoutManager;
	import mx.managers.ILayoutManagerClient;

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
			if (invalidProperties.indexOf(obj) == -1)
				invalidProperties.push(obj);
		}
		
		public function invalidateSize(obj:ILayoutManagerClient):void
		{
			if (invalidSize.indexOf(obj) == -1)
				invalidSize.push(obj);
		}
		
		public function invalidateDisplayList(obj:ILayoutManagerClient):void
		{
			if (invalidDisplayList.indexOf(obj) == -1)
				invalidDisplayList.push(obj);
		}
		
		public function validateNow():void
		{
			var obj:ILayoutManagerClient;
			
			while (invalidProperties.length > 0) {
				obj = invalidProperties.shift() as ILayoutManagerClient;
				obj.validateProperties();
			}
			
			while (invalidSize.length > 0) {
				obj = invalidSize.shift() as ILayoutManagerClient;
				obj.validateSize();
			}
			
			while (invalidDisplayList.length > 0) {
				obj = invalidDisplayList.shift() as ILayoutManagerClient;
				obj.validateDisplayList();
			}
				
		}
		
		public function validateClient(target:ILayoutManagerClient, skipDisplayList:Boolean=false):void
		{
			if (invalidProperties.indexOf(target) != -1)
				target.validateProperties();
			if (invalidSize.indexOf(target) != -1)
				target.validateSize();
			if (!skipDisplayList && invalidDisplayList.indexOf(target) != -1)
				target.validateDisplayList();
		}
		
		public function isInvalid():Boolean
		{
			return invalidProperties.length > 0 || invalidSize.length > 0 || invalidDisplayList.length > 0;
		}
		
		
	}
}