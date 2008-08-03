package com.openflux.core
{
	import com.openflux.utils.MetaStyler;
	
	import flash.display.BitmapData;
	
	import mx.containers.Canvas;
	import mx.states.State;
	import mx.styles.IStyleClient;
	
	// Everything's a Canvas!? That's no good. :-)
	// I'll look at fixing this after beta release.
	/**
	 * View class you would usually extend when creating your own custom views
	 */
	public class FluxView extends Canvas implements IFluxView
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
			MetaStyler.initialize(this);
		}
		
		/** @private */
		override protected function createChildren():void {
			super.createChildren();
			measuredWidth = explicitWidth;
			measuredHeight = explicitHeight;
			measuredMinWidth = explicitMinWidth;
			measuredMinHeight = explicitMinHeight;
		}
		
		/** @private */
		override public function styleChanged(styleProp:String):void {
			super.styleChanged(styleProp);
			MetaStyler.updateStyle(styleProp, this, this.component as IStyleClient);
		}
		
		override public function set width(value:Number):void {
			super.width = value;
		}
		
	}
}