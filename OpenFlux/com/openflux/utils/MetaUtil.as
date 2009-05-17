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

package com.openflux.utils
{
	
	import com.openflux.metadata.*;
	
	import flash.system.ApplicationDomain;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	/**
	 * Uses XML from describeType(class) to retrieve all custom OpenFlux metadata associated 
	 * with the class and all super classes.
	 * 
	 * @see flash.utils.describeType
	 */
	public class MetaUtil
	{
		/**
		 * Cache
		 */
		private static var directivesByClassName:Object = {};
		
		/**
		 * Return metadata for a specific class instance. Results are cached by class.
		 * 
		 * @param instance The object to resolve metadata for
		 * @return All metadata associated with object (class and super-classes) 
		 */
		public static function resolveDirectives(instance:Object):ClassDirectives {
			var cname:String = getQualifiedClassName(instance);
			return directivesForClass(cname);
		}
		
		/**
		 * Return metadata for a specific class. Results are cached.
		 * 
		 * @param className The class to resolve metadata for
		 * @return All metadata associated with class and super-classes
		 */
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
				directives.capacitors = baseClassDirectives.capacitors.concat();
				// methods are inherited down in describeTypeData.
			}
			
			var description:XML = flash.utils.describeType(type);
			resolveStyleBindings(description, directives.styles);
			resolveModelAliases(description, directives.modelAliases);
			resolveEventHandlers(description, directives.modelHandlers); 
			resolveViewContracts(description, directives.viewContracts);
			resolveViewHandlers(description, directives.viewHandlers);
			resolveDefaultSettings(description, directives.defaultSettings);
			resolveCapacitors(description, directives.capacitors);
			directivesByClassName[className] = directives;
			return directives;
		}
		
		/**
		 * Resolve [ModelAlias]
		 */
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
		
		/**
		 * Resolve [ViewContract]
		 */
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
		
		/**
		 * Resolve [ViewHandler]
		 */
		private static function resolveViewHandlers(description:XML, directives:Array):void {
			var metadata:XMLList = description.factory.metadata.(@name == "ViewHandler");				
			for (var i:int = 0; i < metadata.length(); i++) {
				var directive:ViewHandlerDirective = new ViewHandlerDirective();
				directive.dispatcher = "component.view";
				directive.event = metadata[i].arg.(@key == "event").@value;
				directive.handler = metadata[i].arg.(@key == "handler").@value;
				directives.push(directive);
			}
			
			metadata = description.factory.method.metadata.(@name == "ViewHandler");
			for (i = 0; i < metadata.length(); i++) {
				directive = new ViewHandlerDirective();
				directive.dispatcher = "component.view";
				directive.event = metadata[i].arg.(@key == "event" || @key == "").@value;
				directive.handler = metadata[i].parent().@name;
				directives.push(directive);
			}
		}
		
		/**
		 * Resolve [StyleBinding]
		 */
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
		
		/**
		 * Resolve [EventHandler]
		 */
		private static function resolveEventHandlers(description:XML, directives:Array):void {
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
			
			metadata = description.factory.method.metadata.(@name == "EventHandler");
			for (i = 0; i < metadata.length(); i++) {
				handlerDirective = new EventHandlerDirective();
				var dispatcherArg:Object = metadata[i].arg.(@key == "dispatcher");
				handlerDirective.dispatcher = metadata[i].arg.(@key == "dispatcher").@value;
				if (handlerDirective.dispatcher == "") {
					handlerDirective.dispatcher = "component";
				}
				handlerDirective.event = metadata[i].arg.(@key == "event" || @key == "").@value;
				handlerDirective.handler = metadata[i].parent().@name;
				directives.push(handlerDirective);
			}
		}
		
		/**
		 * Resolve [DefaultSetting]
		 */
		private static function resolveDefaultSettings(description:XML, directives:Array):void {
			var metadata:XMLList = description.factory.metadata.(@name == "DefaultSetting");
			for (var i:int = 0; i < metadata.length(); i++) {
				var directive:DefaultSettingsDirective = new DefaultSettingsDirective();
				directive.property = metadata[i].arg.@key;
				directive.value = metadata[i].arg.@value;
				directives.push(directive);
			}
		}
		
		/**
		 * Resolve [Capacitor]
		 */
		private static function resolveCapacitors(description:XML, directives:Array):void {
			var metadata:XMLList = description.factory.accessor.metadata.(@name == "Capacitor");
			metadata += description.factory.variable.metadata.(@name == "Capacitor");				
			for (var i:int = 0; i < metadata.length(); i++) {
				var directive:CapacitorDirective = new CapacitorDirective();
				var arrayElementType:String = metadata[i].parent().metadata.( @name == "ArrayElementType" ).arg.( @key == "" ).@value;
				
				directive.property = metadata[i].parent().@name;
				directive.type = getDefinitionByName( metadata[i].parent().@type ) as Class;
				directive.arrayElementType = arrayElementType ? getDefinitionByName( arrayElementType ) as Class : null; 
				directives.push( directive );
			}
		}
	}
}