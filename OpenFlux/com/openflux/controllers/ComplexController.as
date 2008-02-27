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

		
		override public function set data(value:IFluxComponent):void {
			super.data = value;
			for each(var c:IFluxController in controllers) {
				c.data = value;
			}
		}
		
	}
}