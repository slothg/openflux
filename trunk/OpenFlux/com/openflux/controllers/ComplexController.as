package com.openflux.controllers
{
	import com.openflux.core.IFluxComponent;
	import com.openflux.core.IFluxController;

	public class ComplexController implements IFluxController
	{
		
		private var controllers:Array;
		private var _component:IFluxComponent;
		
		public function ComplexController(controllers:Array)
		{
			super();
			this.controllers = controllers;
		}

		public function get component():IFluxComponent { return _component; }
		public function set component(value:IFluxComponent):void {
			_component = value;
			for each(var c:IFluxController in controllers) {
				c.component = value;
			}
		}
		
	}
}