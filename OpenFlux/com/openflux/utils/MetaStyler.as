package com.openflux.utils
{
	import com.degrafa.core.utils.StyleUtil;
	
	import flash.system.ApplicationDomain;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import mx.graphics.IFill;
	import mx.styles.IStyleClient;
	
	/**
	 * The MetaStyler Utility is used to marshal style information into properties automatically through Metadata.
	 * 
	 * [StyleBinding]
	 * public var fill:IFill = null; // null default
	 * public var stroke:IStroke;
	 * public var isSomething:Boolean;
	 * public var measure:IMeasure;
	 * public var value:Number; // int, uint
	 * public var filters:...;
	 */
	public class MetaStyler
	{
		
		private static var directivesByClassName:Object = {};
		
		static public function initialize(target:Object, source:IStyleClient = null):void {
			var directives:ClassDirective = getDirectivesForObject(target);
			for each(var directive:StyleBindingDirective in directives.styles) {
				updateStyle(directive.property, target, source);
			}
		}
		
		static public function updateStyle(style:String, target:Object, source:IStyleClient = null):void {
			if(!source) { source = target as IStyleClient; }
			var directive:StyleBindingDirective;
			var directives:ClassDirective = getDirectivesForObject(target);
			for each(directive in directives.styles) {
				if(directive.property == style) {
					target[directive.property] = updateStyleBinding(directive, target, source);
				}
			}
		}
		
		//*****************************
		
		private static function updateStyleBinding(directive:StyleBindingDirective, target:Object, source:IStyleClient):Object {
			if(source) {
				var value:Object = source.getStyle(directive.property);
				var none:Object = target[directive.property];
				switch(directive.type) {
					case "Boolean":
						return resolveBoolean(value, none);
						break;
					case "Number":
					case "int":
					case "uint":
						return resolveNumber(value, none.valueOf());
						break;
					case "String":
						return resolveString(value, none.toString());
						break;
					default:
						var type:Object = flash.utils.getDefinitionByName(directive.type);
						return resolveClass(value, type as Class, none);
						break;
				}
			}
			return none;
		}
		
		private static function resolveBoolean(value:Object, none:Boolean):Boolean {
			return value != null ? value : none;
		}
		
		private static function resolveNumber(value:Object, none:Number):Boolean {
			return value != null ? value.valueOf() : none;
		}
		
		private static function resolveString(value:Object, none:String):String {
			return value != null ? value.toString() : none;
		}
		
		/* // later 
		private static function resolveFill(base:String, none:IFill):IFill {
			return StyleUtil.resolveFill(0, none);
		}*/
		
		// last ditch effort to resolve something :-)
		private static function resolveClass(value:Object, type:Class, none:Object):Object {
			if(value is type) {
				return value;
			} else if(value is Class) {
				var C:Class = value as Class;
				var instance:Object = new C();
				if(instance is type) {
					return instance;
				}
			}
			return none;
		}
		
		//*****************************
		
		private static function getDirectivesForObject(target:Object):ClassDirective {
			var cname:String = getQualifiedClassName(target);
			return getClassDirective(cname);
		}
		
		private static function getClassDirective(className:String):ClassDirective {
			var directives:ClassDirective = directivesByClassName[className];
			if(directives != null) { return directives; }
			
			directives = new ClassDirective();
			var type:Class = ApplicationDomain.currentDomain.getDefinition(className) as Class;
			var baseClassName:String = getQualifiedSuperclassName(type);
			if(baseClassName != null) {
				var baseClassDirectives:ClassDirective = getClassDirective(baseClassName);
				directives.styles = baseClassDirectives.styles.concat();
				// methods are inherited down in describeTypeData.
			}
			var description:XML = flash.utils.describeType(type);
			directives.styles = getStyleBindingDirectives(description);
			directivesByClassName[className] = directives;
			return directives;
		}
		
		private static function getStyleBindingDirectives(description:XML):Array {
			var directives:Array = new Array();
			var directive:StyleBindingDirective;
			var metadata:XMLList = description.factory.variable.metadata.(@name == "StyleBinding");				
			metadata += description.factory.accessor.metadata.(@name == "StyleBinding");
			for (var i:int = 0; i < metadata.length(); i++) {
				directive = new StyleBindingDirective();
				directive.property = metadata[i].parent().@name;
				directive.type = metadata[i].parent().@type;
				directives.push(directive);
			}
			return directives;
		}
		
	}
}

class ClassDirective
{
	public var styles:Array;
}

class StyleDirective
{
	
}

class StyleBindingDirective
{
	public var property:String;
	public var type:String;
}