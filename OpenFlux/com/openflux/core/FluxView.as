package com.openflux.core
{
	import com.openflux.utils.MetaStyler;
	
	import mx.core.Container;
	import mx.core.ScrollPolicy;
	import mx.states.State;
	import mx.styles.IStyleClient;
	
	/**
	 * View class you would usually extend when creating your own custom views
	 */
	public class FluxView extends Container implements IFluxView
	{
		
		//***********************************************************
		// IFluxView Implementation
		//***********************************************************
		
		private var _component:Object;
		private var _state:String;
		
		/**
		 * Stores the component model instance
		 */
		[Bindable]
		public function get component():Object { return _component; }
		public function set component(value:Object):void {
			_component = value;
		}
		
		[Bindable]
		public function get state():String { return _state; }
		public function set state(value:String):void {
			_state = value;
			for each(var state:State in states) {
				if(state.name == value) {
					super.currentState = value;
				}
			}
		}
		
		//***********************************************************
		// Constructor
		//***********************************************************
		
		/** @private */
		public function FluxView()
		{
			super();
			clipContent = false;
			verticalScrollPolicy = horizontalScrollPolicy = ScrollPolicy.OFF;
			MetaStyler.initialize(this);
		}
		
		/** @private */
		override protected function createChildren():void {
			super.createChildren();
		}
		
		/** @private */
		override public function styleChanged(styleProp:String):void {
			super.styleChanged(styleProp);
			MetaStyler.updateStyle(styleProp, this, this.component as IStyleClient);
		}
	}
}