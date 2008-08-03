package com.openflux.core
{
	
	import com.openflux.utils.MetaStyler;
	
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.*;
	
	import mx.events.PropertyChangeEvent;
	
	// todo: move all this code into a utility class
	public class MetaControllerBase
	{
		
		//***************************************************
		// Static Metadata Handling
		//***************************************************
		
		private static var directivesByClassName:Object = {};
		
		private static function directivesForClass(className:String):ClassDirective
		{
			var directives:ClassDirective = directivesByClassName[className];
			if(directives != null)
				return directives;
			
			var ty:Class = ApplicationDomain.currentDomain.getDefinition(className) as Class;
			directives = new ClassDirective();
			var baseClassName:String = getQualifiedSuperclassName(ty);
			if(baseClassName != null) {
				var baseClassDirectives:ClassDirective = directivesForClass(baseClassName);
				directives.modelAliases = baseClassDirectives.modelAliases.concat();
				directives.viewContracts = baseClassDirectives.viewContracts.concat();
				directives.viewHandlers = baseClassDirectives.viewHandlers.concat();
			}
			
			var des:XML = flash.utils.describeType(ty);
			var metadata:XMLList = des.factory.accessor.metadata.(@name == "ModelAlias");
			metadata += des.factory.variable.metadata.(@name == "ModelAlias");				
			for (var i:int = 0; i < metadata.length(); i++) {
				var alias:ModelAliasDirective = new ModelAliasDirective();
				alias.property = metadata[i].parent().@name;
				alias.type = metadata[i].parent().@type;
				directives.modelAliases.push(alias);
			}
			metadata = des.factory.accessor.metadata.(@name == "ViewContract");
			metadata += des.factory.variable.metadata.(@name == "ViewContract");				
			for (i = 0; i < metadata.length(); i++) {
				var contract:ViewContractDirective = new ViewContractDirective();
				contract.property = metadata[i].parent().@name;
				contract.type = metadata[i].parent().@type;
				directives.viewContracts.push(contract);
			}
			
			metadata = des.factory.metadata.(@name == "ViewHandler");				
			for (i = 0; i < metadata.length(); i++) {
				var handler:ViewHandlerDirective = new ViewHandlerDirective();
				handler.event = metadata[i].arg.(@key == "event").@value;
				handler.handler = metadata[i].arg.(@key == "handler").@value;
				directives.viewHandlers.push(handler);
			}
			
			metadata = des.factory.metadata.(@name == "EventHandler");				
			for (i = 0; i < metadata.length(); i++) {
				var handlerX:HandleEventDirective = new HandleEventDirective();
				handlerX.dispatcher = "component";
				handlerX.event = metadata[i].arg.(@key == "event").@value;
				handlerX.handler = metadata[i].arg.(@key == "handler").@value;
				directives.handleEventDirectives.push(handlerX);
			}
			
			metadata = des.factory.accessor.metadata.(@name == "EventHandler");
			metadata += des.factory.variable.metadata.(@name == "EventHandler");
			for (i = 0; i < metadata.length(); i++) {
				var handlerDirective:HandleEventDirective = new HandleEventDirective();
				handlerDirective.dispatcher = metadata[i].parent().@name;
				handlerDirective.event = metadata[i].arg.(@key == "event").@value;
				handlerDirective.handler = metadata[i].arg.(@key == "handler").@value;
				directives.handleEventDirectives.push(handlerDirective);
			}
			directivesByClassName[className] = directives;
			return directives;
		}
		
		private static function directivesForObject(target:Object):ClassDirective {
			var cname:String = getQualifiedClassName(target);
			return directivesForClass(cname);
		}
		
		
		//**********************************
		
		private var directives:ClassDirective;
		
		private var _component:IFluxComponent;
		public function get component():IFluxComponent { return _component; }
		public function set component(value:IFluxComponent):void {
			if(_component && _component.view is IEventDispatcher) {
				detachHandlers();
				(_component.view as IEventDispatcher).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler, false);
			}
			_component = value;
			applyAliasDirectives();
			applyContractDirectives();
			if(_component && _component.view is IEventDispatcher) {
				attachHandlers();
				(_component.view as IEventDispatcher).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler, false, 0, true);
			}
			//MetaBinder.InitObject(this);
			applyEventHandlers();
		}
		
		// this should be updated to handle all binding (with custom events)
		private function propertyChangeHandler(event:PropertyChangeEvent):void {
			for each(var contract:ViewContractDirective in directives.viewContracts) {
				if(event.property == contract.property) {
					if((component.view as Object).hasOwnProperty(contract.property)) {
						var ty:Class = ApplicationDomain.currentDomain.getDefinition(contract.type) as Class;
						if(component.view[contract.property] is ty) {
							this[contract.property] = component.view[contract.property];
						} else {
							this[contract.property] = null;
						}
					}
				}
			}
		}
		
		private var tokenFunction:Function;
		public function MetaControllerBase(scope:Object)
		{
			super();
			if(scope is Function) {
				tokenFunction = scope as Function;
			}
			directives = directivesForObject(this);
			MetaStyler.initialize(this);
		}
		
		//********************************************
		// Utility Functions
		//********************************************
		
		protected function attachHandlers():void {
			var dispatcher:IEventDispatcher = component.view as IEventDispatcher;
			for each(var handler:ViewHandlerDirective in directives.viewHandlers) {
				var f:Function = tokenFunction(handler.handler) as Function;
				dispatcher.addEventListener(handler.event, f, false, 0, true);
			}
		}
		
		protected function detachHandlers():void {
			var dispatcher:IEventDispatcher = component.view as IEventDispatcher;
			for each(var handler:ViewHandlerDirective in directives.viewHandlers) {
				dispatcher.removeEventListener(handler.event, this[handler.handler], false);
			}
		}
		
		private function applyAliasDirectives():void {
			for each(var alias:ModelAliasDirective in directives.modelAliases) {
				var ty:Class = ApplicationDomain.currentDomain.getDefinition(alias.type) as Class;
				if(component is ty) {
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
		
		private function applyEventHandlers():void {
			for each(var directive:HandleEventDirective in directives.handleEventDirectives) {
				var f:Function = tokenFunction(directive.handler) as Function;
				var dispatcher:IEventDispatcher = this[directive.dispatcher];
				if(dispatcher) {
					dispatcher.addEventListener(directive.event, f, false, 0, true);
				}
			}
		}
		
	}
}

class ClassDirective {
	public var modelAliases:Array = [];
	public var viewContracts:Array = [];
	public var viewHandlers:Array = [];
	public var handleEventDirectives:Array = [];
}

class ModelAliasDirective {
	public var property:String;
	public var type:String;
}

class ViewContractDirective {
	public var property:String;
	public var type:String;
}

class ViewHandlerDirective {
	public var event:String;
	public var handler:String;
}

class HandleEventDirective
{
	public var dispatcher:String;
	public var event:String;
	public var handler:String;	
}