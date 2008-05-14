package com.openflux.controllers
{
	import com.openflux.core.FluxController;
	import com.openflux.core.IFluxComponent;
	import com.openflux.core.IFluxController;

	public class ComplexController extends FluxController
	{
		
		private var controllers:Array;
		
		public function ComplexController(controllers:Array)
		{
			super();
			this.controllers = controllers;
		}

		
		override public function set component(value:IFluxComponent):void {
			super.component = value;
			for each(var c:IFluxController in controllers) {
				c.component = value;
			}
		}
		
	}
}