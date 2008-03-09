package com.openflux.core
{
	import com.openflux.utils.MetaBinder;
	
	import flash.events.IEventDispatcher;

	public class FluxController implements IFluxController
	{
		
		private var _data:IFluxComponent; [Bindable]
		public function get data():IFluxComponent { return _data; }		
		public function set data(value:IFluxComponent):void {
			if(_data && _data.view is IEventDispatcher) {
				detachEventListeners(_data.view as IEventDispatcher);
			}
			_data = value;
			if(_data && _data.view is IEventDispatcher) {
				attachEventListeners(_data.view as IEventDispatcher);
			}
		}
		
		public function FluxController() {
			super();
			MetaBinder.InitObject(this);
		}
		
		protected function attachEventListeners(view:IEventDispatcher):void {
			// stubbed out for extending classes
		}
		
		protected function detachEventListeners(view:IEventDispatcher):void {
			// stubbed out for extending classes
		}
		
		
		
	}
}