package com.openflux.controllers
{
	import com.openflux.constants.ButtonStates;
	import com.openflux.core.IEnabled;
	import com.openflux.core.IFluxController;
	import com.openflux.core.ISelectable;
	import com.openflux.core.MetaControllerBase;
	
	import flash.events.MouseEvent;
	import flash.utils.*;
	
	import mx.utils.ObjectProxy;
	
	[ViewHandler(event="mouseOver", handler="mouseOverHandler")]
	[ViewHandler(event="mouseOut", handler="mouseOutHandler")]
	[ViewHandler(event="mouseDown", handler="mouseDownHandler")]
	[ViewHandler(event="mouseUp", handler="mouseUpHandler")]
	public class ButtonController extends MetaControllerBase implements IFluxController
	{
		
		[ModelAlias(required="false")] public var edata:IEnabled;
		[ModelAlias(required="false")] public var sdata:ISelectable;
		
		// implementing later
		[StyleProperty] public var selectable:Boolean;
		
		// really not hapy with this hacking,
		// but it's better than public event handlers
		public function ButtonController() {
			super(function(t:*):*{return this[t]});
		}
		
		//*************************************************
		// View Event Handlers
		//*************************************************
		
		private function mouseOverHandler(event:MouseEvent):void {
			data.view.state = resolveState(ButtonStates.OVER);
		}
		
		private function mouseOutHandler(event:MouseEvent):void {
			data.view.state = resolveState(ButtonStates.UP);
		}
		
		private function mouseDownHandler(event:MouseEvent):void {
			data.view.state = resolveState(ButtonStates.DOWN);
		}
		
		private function mouseUpHandler(event:MouseEvent):void {
			if(sdata) { sdata.selected = !sdata.selected; }
			data.view.state = resolveState(ButtonStates.OVER);
		}
		
		
		//******************************************************
		// Utility Functions
		//******************************************************
		
		private function resolveState(state:String):String {
			var selected:Boolean = sdata && selectable ? sdata.selected : false;
			if(edata && edata.enabled) {
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