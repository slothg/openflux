package com.openflux.states
{
	import flash.display.DisplayObjectContainer;
	
	public class OverrideBase
	{
		private var _target:Object; [Bindable]
		public function get target():Object { return _target; }
		public function set target(value:Object):void {
			_target = value;
		}
		
		public function OverrideBase()
		{
		}

	}
}