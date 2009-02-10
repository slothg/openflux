package com.openflux
{
	
	import com.openflux.controllers.ButtonController;
	import com.openflux.core.FluxComponent;
	import com.openflux.core.IEnabled;
	import com.openflux.core.IFluxButton;
	import com.openflux.core.ISelectable;
	import com.openflux.views.ButtonView;
	
	[Style(name="selectable", type="Boolean")]
	public class Button extends FluxComponent implements IFluxButton, ISelectable, IEnabled
	{
		
		//**********************************************************
		// IFluxButton & ISelectable Implementations
		//**********************************************************
		
		private var _label:String;
		private var _selected:Boolean;
		
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
		
		
	}
}