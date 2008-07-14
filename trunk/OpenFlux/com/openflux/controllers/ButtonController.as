package com.openflux.controllers
{
	import com.openflux.constants.ButtonStates;
	import com.openflux.core.IEnabled;
	import com.openflux.core.IFluxComponent;
	import com.openflux.core.IFluxController;
	import com.openflux.core.ISelectable;
	import com.openflux.core.MetaControllerBase;
	
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.*;
	
	import mx.events.PropertyChangeEvent;
	
	[ViewHandler(event="mouseOver", handler="mouseOverHandler")]
	[ViewHandler(event="mouseOut", handler="mouseOutHandler")]
	[ViewHandler(event="mouseDown", handler="mouseDownHandler")]
	[ViewHandler(event="mouseUp", handler="mouseUpHandler")]
	public class ButtonController extends MetaControllerBase implements IFluxController
	{
		
		[StyleBinding] public var selectable:Boolean;
		
		[ModelAlias(required="false")] public var ec:IEnabled;
		[ModelAlias(required="false")] public var sc:ISelectable;
		[ModelAlias(required="false")] public var dc:IEventDispatcher;
		
		// really not hapy with this hacking,
		// but it's better than public event handlers
		public function ButtonController() {
			super(function(t:*):*{return this[t]});
		}
		
		override protected function attachHandlers():void {
			super.attachHandlers();
			dc.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler, false, 0, true);
		}
		
		override protected function detachHandlers():void {
			super.detachHandlers();
			dc.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler, false);
		}
		
		
		//*************************************************
		// View Event Handlers
		//*************************************************
		
		private function propertyChangeHandler(event:PropertyChangeEvent):void {
			switch(event.property) {
				case "selected": 
				case "enabled" :
					component.view.state = resolveState(component.view.state);
			}
		}
		
		private function mouseOverHandler(event:MouseEvent):void {
			component.view.state = resolveState(ButtonStates.OVER);
		}
		
		private function mouseOutHandler(event:MouseEvent):void {
			component.view.state = resolveState(ButtonStates.UP);
		}
		
		private function mouseDownHandler(event:MouseEvent):void {
			component.view.state = resolveState(ButtonStates.DOWN);
		}
		
		private function mouseUpHandler(event:MouseEvent):void {
			if(sc && selectable) { sc.selected = !sc.selected; }
			component.view.state = resolveState(ButtonStates.OVER);
		}
		
		
		//******************************************************
		// Utility Functions
		//******************************************************
		
		private function resolveState(state:String):String {
			var selected:Boolean = (sc) ? sc.selected : false;
			if(!ec || ec.enabled) {
				switch(state) {
					case ButtonStates.OVER:
						return selected ? ButtonStates.SELECTED_OVER : ButtonStates.OVER;
						break;
					case ButtonStates.DOWN:
						return selected ? ButtonStates.SELECTED_DOWN : ButtonStates.DOWN;
						break;
					case ButtonStates.UP:
					default:
						return selected ? ButtonStates.SELECTED_UP : ButtonStates.UP;
						break;
				}
			} else {
				return ButtonStates.DISABLED;
			}
		}
		
	}
}