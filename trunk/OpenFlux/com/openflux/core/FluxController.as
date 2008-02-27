package com.openflux.core
{
	import flash.events.IEventDispatcher;
	
	import mx.core.UIComponent;

	public class FluxController implements IFluxController
	{
		
		private var _data:IFluxComponent; [Bindable]
		public function get data():IFluxComponent { return _data; }		
		public function set data(value:IFluxComponent):void {
			if(_data && _data.view is IEventDispatcher) {
				removeEventListeners(_data.view as IEventDispatcher);
			}
			_data = value;
			if(_data && _data.view is IEventDispatcher) {
				addEventListeners(_data.view as IEventDispatcher);
			}
		}
		
		protected function addEventListeners(view:IEventDispatcher):void {
			// stubbed out for extending classes
		}
		
		protected function removeEventListeners(view:IEventDispatcher):void {
			// stubbed out for extending classes
		}
		
		// not using this to update view state
		/*
		protected function updateState(token:String):void {
			if(_data is UIComponent) {
				(_data as UIComponent).currentState = token;
			}
		}*/
		
	}
}