// =================================================================
//
// Copyright (c) 2009 The OpenFlux Team http://www.openflux.org
// 
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// =================================================================

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
		
		[ModelAlias] public var dispatcher:IEventDispatcher;
		
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