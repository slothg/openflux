package com.openflux.utils
{
	
	import com.openflux.metadata.*;
	
	import flash.system.ApplicationDomain;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	public class MetaUtil
	{
		
		
		private static var directivesByClassName:Object = {};
		
		public static function resolveDirectives(instance:Object):ClassDirectives {
			var cname:String = getQualifiedClassName(instance);
			return directivesForClass(cname);
		}
		
		private static function directivesForClass(className:String):ClassDirectives
		{
			var directives:ClassDirectives = directivesByClassName[className];
			if(directives != null) { return directives; }
			
			directives = new ClassDirectives();
			var type:Class = ApplicationDomain.currentDomain.getDefinition(className) as Class;
			var baseClassName:String = getQualifiedSuperclassName(type);
			if(baseClassName != null) {
				var baseClassDirectives:ClassDirectives = directivesForClass(baseClassName);
				//directives.bindings = baseClassDirectives.bindings.concat();
				directives.defaultSettings = baseClassDirectives.defaultSettings.concat();
				directives.modelAliases = baseClassDirectives.modelAliases.concat();
				directives.modelHandlers = baseClassDirectives.modelHandlers.concat();
				directives.viewContracts = baseClassDirectives.viewContracts.concat();
				directives.viewHandlers = baseClassDirectives.viewHandlers.concat();
				directives.styles = baseClassDirectives.styles.concat();
				// methods are inherited down in describeTypeData.
			}
			
			var description:XML = flash.utils.describeType(type);
			resolveStyleBindings(description, directives.styles);
			resolveModelAliases(description, directives.modelAliases);
			resolveModelHandlers(description, directives.modelHandlers); 
			resolveViewContracts(description, directives.viewContracts);
			resolveViewHandlers(description, directives.viewHandlers);
			resolveDefaultSettings(description, directives.defaultSettings);
			directivesByClassName[className] = directives;
			return directives;
		}
		
		private static function resolveModelAliases(description:XML, directives:Array):void {
			var metadata:XMLList = description.factory.accessor.metadata.(@name == "ModelAlias");
			metadata += description.factory.variable.metadata.(@name == "ModelAlias");				
			for (var i:int = 0; i < metadata.length(); i++) {
				var directive:ModelAliasDirective = new ModelAliasDirective();
				directive.property = metadata[i].parent().@name;
				directive.type = metadata[i].parent().@type;
				directives.push(directive);
			}
		}
		
		private static function resolveViewContracts(description:XML, directives:Array):void {
			var metadata:XMLList = description.factory.accessor.metadata.(@name == "ViewContract");
			metadata += description.factory.variable.metadata.(@name == "ViewContract");				
			for (var i:int = 0; i < metadata.length(); i++) {
				var directive:ViewContractDirective = new ViewContractDirective();
				directive.property = metadata[i].parent().@name;
				directive.type = metadata[i].parent().@type;
				directives.push(directive);
			}
		}
		
		private static function resolveViewHandlers(description:XML, directives:Array):void {
			var metadata:XMLList = description.factory.metadata.(@name == "ViewHandler");				
			for (var i:int = 0; i < metadata.length(); i++) {
				var directive:ViewHandlerDirective = new ViewHandlerDirective();
				directive.dispatcher = "component.view";
				directive.event = metadata[i].arg.(@key == "event").@value;
				directive.handler = metadata[i].arg.(@key == "handler").@value;
				directives.push(directive);
			}
		}
		
		private static function resolveStyleBindings(description:XML, directives:Array):void {
			var metadata:XMLList = description.factory.variable.metadata.(@name == "StyleBinding");				
			metadata += description.factory.accessor.metadata.(@name == "StyleBinding");
			for (var i:int = 0; i < metadata.length(); i++) {
				var directive:StyleBindingDirective = new StyleBindingDirective();
				directive.property = metadata[i].parent().@name;
				directive.type = metadata[i].parent().@type;
				directives.push(directive);
			}
		}
		
		private static function resolveModelHandlers(description:XML, directives:Array):void {
			var metadata:XMLList = description.factory.metadata.(@name == "EventHandler");				
			for (var i:int = 0; i < metadata.length(); i++) {
				var handlerX:EventHandlerDirective = new EventHandlerDirective();
				handlerX.dispatcher = "component";
				handlerX.event = metadata[i].arg.(@key == "event").@value;
				handlerX.handler = metadata[i].arg.(@key == "handler").@value;
				directives.push(handlerX);
			}
			
			metadata = description.factory.accessor.metadata.(@name == "EventHandler");
			metadata += description.factory.variable.metadata.(@name == "EventHandler");
			for (i = 0; i < metadata.length(); i++) {
				var handlerDirective:EventHandlerDirective = new EventHandlerDirective();
				handlerDirective.dispatcher = metadata[i].parent().@name;
				handlerDirective.event = metadata[i].arg.(@key == "event").@value;
				handlerDirective.handler = metadata[i].arg.(@key == "handler").@value;
				directives.push(handlerDirective);
			}
		}
		
		private static function resolveDefaultSettings(description:XML, directives:Array):void {
			var metadata:XMLList = description.factory.metadata.(@name == "DefaultSetting");
			for (var i:int = 0; i < metadata.length(); i++) {
				var directive:DefaultSettingsDirective = new DefaultSettingsDirective();
				directive.property = metadata[i].arg.@key;
				directive.value = metadata[i].arg.@value;
				directives.push(directive);
			}
		}
		
	}
}