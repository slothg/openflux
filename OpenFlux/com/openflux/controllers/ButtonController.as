package com.openflux.controllers
{
	import com.openflux.constants.ButtonStates;
	import com.openflux.core.FluxController;
	import com.openflux.core.IFluxButton;
	import com.openflux.core.IFluxComponent;
	import com.openflux.core.ISelectable;
	
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	public class ButtonController extends FluxController
	{
		
		private var bdata:IFluxButton;
		private var sdata:ISelectable;
		
		override public function set data(value:IFluxComponent):void {
			super.data = value;
			if(value is IFluxButton) {
				bdata = value as IFluxButton;
			}
			if(value is ISelectable) {
				sdata = value as ISelectable;
			}
		}
		
		override protected function addEventListeners(view:IEventDispatcher):void {
			super.addEventListeners(view);
			view.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			view.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			view.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			view.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		override protected function removeEventListeners(view:IEventDispatcher):void {
			super.removeEventListeners(view);
			view.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			view.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			view.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			view.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		
		//*************************************************
		// Event Handlers
		//*************************************************
		
		private function mouseOverHandler(event:MouseEvent):void {
			if(bdata) {
				bdata.buttonState = ButtonStates.OVER;
			}
		}
		
		private function mouseOutHandler(event:MouseEvent):void {
			if(bdata) {
				bdata.buttonState = ButtonStates.UP;
			}
		}
		
		private function mouseDownHandler(event:MouseEvent):void {
			if(bdata) {
				bdata.buttonState = ButtonStates.DOWN;
			}
		}
		
		private function mouseUpHandler(event:MouseEvent):void {
			if(bdata) {
				bdata.buttonState = ButtonStates.OVER;
			}
			if(sdata) {
				sdata.selected = !sdata.selected;
			}
		}
		
	}
}