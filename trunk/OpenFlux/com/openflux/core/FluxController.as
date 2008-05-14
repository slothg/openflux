package com.openflux.core
{
	import com.openflux.utils.MetaBinder;
	
	import flash.events.IEventDispatcher;

	public class FluxController implements IFluxController
	{
		
		private var _component:IFluxComponent;
		
		[Bindable]
		public function get component():IFluxComponent { return _component; }		
		public function set component(value:IFluxComponent):void {
			if(_component && _component.view is IEventDispatcher) {
				detachEventListeners(_component.view as IEventDispatcher);
			}
			_component = value;
			if(_component && _component.view is IEventDispatcher) {
				attachEventListeners(_component.view as IEventDispatcher);
			}
		}
		
		public function FluxController() {
			super();
			MetaBinder.initialize(this);
		}
		
		protected function attachEventListeners(view:IEventDispatcher):void {
			// abstract
		}
		
		protected function detachEventListeners(view:IEventDispatcher):void {
			// abstract
		}
		
		
		
	}
}