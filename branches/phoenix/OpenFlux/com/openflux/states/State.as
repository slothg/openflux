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