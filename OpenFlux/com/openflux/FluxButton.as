package com.openflux
{
	
	import com.openflux.core.FluxComponent;
	import com.openflux.core.IEnabled;
	import com.openflux.core.IFluxButton;
	import com.openflux.core.ISelectable;
	import com.openflux.controllers.ButtonController; ButtonController;
	import com.openflux.views.ButtonView; ButtonView;
	
	import flash.events.Event;
	
	[Style(name="selectable", type="Boolean")]
	[DefaultSetting(view="com.openflux.views.ButtonView")]
	[DefaultSetting(controller="com.openflux.controllers.ButtonController")]
	
	/**
	 * Button component that has a label and is selectable.
	 * 
	 * TEMPORARILY NAMED FluxButton WHILE WORKING ON CSS ISSUE
	 * 
	 * @see com.openflux.views.ButtonView
	 * @see com.openflux.controllers.ButtonController
	 */
	public class FluxButton extends FluxComponent implements IFluxButton, ISelectable, IEnabled
	{
		/**
		 * Contructor
		 */
		 public function FluxButton() {
		 	super();
		 }
		 
		// ========================================
		// label property
		// ========================================
		
		private var _label:String;
		
		[Bindable("labelChange")]
		
		/**
		 * Label to be displayed by the view
		 */
		public function get label():String { return _label; }
		public function set label(value:String):void {
			if (_label != value) {
				_label = value;
				dispatchEvent(new Event("labelChange"));
			}
		}
		
		// ========================================
		// selected property
		// ========================================
		
		private var _selected:Boolean;
		
		[Bindable("selectedChange")]
		
		/**
		 * Whether the button is currently selected.
		 * Set by ButtonController and used by CheckBoxView
		 * 
		 * @see com.openflux.controllers.ButtonController
		 * @see com.openflux.views.CheckBoxView
		 */
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void {
			if (_selected != value) {
				_selected = value;
				dispatchEvent(new Event("selectedChange"));
			}
		}
	}
}