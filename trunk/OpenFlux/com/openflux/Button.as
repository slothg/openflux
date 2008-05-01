package com.openflux
{
	
	import com.openflux.controllers.ButtonController;
	import com.openflux.core.*;
	import com.openflux.views.ButtonView;
	
	import mx.core.UIComponent;
	
	[Style(name="selectable", type="Boolean")]
	public class Button extends FluxComponent implements IFluxButton, ISelectable, IEnabled
	{
		
		private var _label:String;
		private var _selected:Boolean;
		private var _buttonState:String;
		
		[Bindable]
		public function get label():String { return _label; }
		public function set label(value:String):void {
			_label = value;
		}
		
		[Bindable]
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void {
			_selected = value;
		}
		
		[Bindable]
		public function get buttonState():String { return _buttonState; }
		public function set buttonState(value:String):void {
			_buttonState = value;
		}
		
		
		//***************************************************
		// Framework Overrides
		//***************************************************
		
		override protected function createChildren():void {
			if(!controller) {
				controller = new ButtonController();
			}
			if(!view) {
				view = new ButtonView();
			}
			super.createChildren();
		}
		
		override protected function measure():void {
			super.measure();
			if(view) {
				measuredWidth = view.measuredWidth;
				measuredHeight = view.measuredHeight;
			}
		}
		
	}
}