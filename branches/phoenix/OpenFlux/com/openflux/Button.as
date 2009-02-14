package com.openflux
{
	
	import com.openflux.core.FluxComponent;
	import com.openflux.core.IEnabled;
	import com.openflux.core.IFluxButton;
	import com.openflux.core.ISelectable;
	
	[Style(name="selectable", type="Boolean")]
	[DefaultSetting(view="com.openflux.views.ButtonView")]
	[DefaultSetting(controller="com.openflux.controllers.ButtonController")]
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
		
		
	}
}