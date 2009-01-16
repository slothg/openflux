package com.openflux.utils
{
	import com.openflux.metadata.ClassDirectives;
	import com.openflux.metadata.StyleBindingDirective;
	
	import flash.utils.getDefinitionByName;
	
	import mx.styles.ISimpleStyleClient;
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
		
		static public function initialize(target:Object, source:IStyleClient = null):void {
			var directives:ClassDirectives = MetaUtil.resolveDirectives(target);
			for each(var directive:StyleBindingDirective in directives.styles) {
				updateStyle(directive.property, target, source);
			}
		}
		
		static public function updateStyle(style:String, target:Object, source:IStyleClient = null):void {
			if(!source) { source = target as IStyleClient; }
			var directive:StyleBindingDirective;
			var directives:ClassDirectives = MetaUtil.resolveDirectives(target);
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
						return resolveNumber(value, none as Number);
						break;
					case "String":
						return resolveString(value, none as String);
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
		
		private static function resolveNumber(value:Object, none:Number):Number {
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
		
	}
}
