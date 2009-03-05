package com.openflux.core
{
	
	import com.openflux.metadata.*;
	import com.openflux.utils.MetaUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	
	import mx.events.PropertyChangeEvent;

	public class FluxController extends EventDispatcher implements IFluxController
	{
		protected namespace metadata = "http://www.openflux.org/2008";
		
		private var directives:ClassDirectives;
		
		/**
		 * Constructor
		 */
		public function FluxController() {
			super();
			directives = MetaUtil.resolveDirectives(this);
		}
		
		// ========================================
		// component property
		// ========================================
		
		private var _component:IFluxComponent;
		
		[Bindable("componentChange")]
		
		/**
		 * Component this controller is attached to
		 */
		public function get component():IFluxComponent { return _component; }		
		public function set component(value:IFluxComponent):void {
			detach(_component);
			
			_component = value;
			dispatchEvent(new Event("componentChange"));
			
			applyAliasDirectives();
			applyContractDirectives();
			attach(_component);
		}
		
		// ========================================
		// enabled property
		// ========================================
		
		private var _enabled:Boolean = true;
		
		/**
		 * Whether this controller is enabled
		 */
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void {
			if (_enabled != value) {
				_enabled = value;
			}
		}
				
		// ========================================
		// Private metadata automation methods
		// ========================================
		
		private function attach(instance:IFluxComponent):void {
			if(instance is IEventDispatcher) {
				attachModelHandlers(instance as IEventDispatcher);
			}
			if(instance && instance.view is IEventDispatcher) {
				attachViewHandlers(instance.view as IEventDispatcher);
				(component.view as IEventDispatcher).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler, false, 0, true);
			}
		}
		
		private function detach(instance:IFluxComponent):void {
			if(instance is IEventDispatcher) {
				detachModelHandlers(instance as IEventDispatcher);
			}
			if(instance && instance.view is IEventDispatcher) {
				detachViewHandlers(instance.view as IEventDispatcher);
				(component.view as IEventDispatcher).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler, false);
			}
		}
		
		private function detachModelHandlers(dispatcher:IEventDispatcher):void {
			for each(var directive:EventHandlerDirective in directives.modelHandlers) {
				var f:Function = this.metadata::[directive.handler] as Function;
				dispatcher.addEventListener(directive.event, f, false, 0, true);
			}
		}
		
		private function attachModelHandlers(instance:IEventDispatcher):void {
			for each(var directive:EventHandlerDirective in directives.modelHandlers) {
				var f:Function = this.metadata::[directive.handler] as Function;
				var d:IEventDispatcher = this[directive.dispatcher] as IEventDispatcher;
				//dispatcher.addEventListener(directive.event, f, false, 0, true);
				if(d) {d.addEventListener(directive.event, f, false, 0, true); }
			}
		}
		
		private function detachViewHandlers(dispatcher:IEventDispatcher):void {
			for each(var directive:ViewHandlerDirective in directives.viewHandlers) {
				var f:Function = this.metadata::[directive.handler] as Function;
				this[directive.dispatcher].removeEventListener(directive.event, f, false);
			}
		}
		
		private function attachViewHandlers(dispatcher:IEventDispatcher):void {
			for each(var directive:ViewHandlerDirective in directives.viewHandlers) {
				var f:Function = this.metadata::[directive.handler] as Function;
				dispatcher.addEventListener(directive.event, f, false, 0, true);
			}
		}
		
		private function applyAliasDirectives():void {
			for each(var alias:ModelAliasDirective in directives.modelAliases) {
				var type:Class = ApplicationDomain.currentDomain.getDefinition(alias.type) as Class;
				if(component is type) {
					this[alias.property] = component;
				}
			}
		}
		
		private function applyContractDirectives():void {
			for each(var contract:ViewContractDirective in directives.viewContracts) {
				if((component.view as Object).hasOwnProperty(contract.property)) {
					var ty:Class = ApplicationDomain.currentDomain.getDefinition(contract.type) as Class;
					if(component.view[contract.property] is ty) {
						this[contract.property] = component.view[contract.property];
					}
				}
			}
		}
		
		// this should be updated to handle all binding (with custom events)
		private function propertyChangeHandler(event:PropertyChangeEvent):void {
			for each(var contract:ViewContractDirective in directives.viewContracts) {
				if(event.property == contract.property) {
					if((component.view as Object).hasOwnProperty(contract.property)) {
						var type:Class = ApplicationDomain.currentDomain.getDefinition(contract.type) as Class;
						if(component.view[contract.property] is type) {
							this[contract.property] = component.view[contract.property];
						} else {
							this[contract.property] = null;
						}
					}
				}
			}
		}
		
	}
}