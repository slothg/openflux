package com.openflux.utils
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	public class ComponentUtil
	{
		
		static public function clone(component:Object, stop:String = "Object"):Object {
			var instance:Object = copy(component);
			var description:XML = flash.utils.describeType(component);
			var accessors:XMLList = description.accessor.(@declaredBy==description.@name);
			for each(var ex:XML in description.extendsClass) {
				accessors += description.accessor.(@declaredBy==ex.@type);
				if(ex.@type == stop) {break;}
			}
			for each(var xml:XML in accessors) {
				setProperty(instance, component, xml);
			}
			return instance;
		}
		
		static private function copy(component:Object):Object {
			var instance:Object = null;
			if(component != null) {
				var name:String = flash.utils.getQualifiedClassName(component);
				var Cls:Object = flash.utils.getDefinitionByName(name);
				instance = new Cls();
			}
			return instance;
		}
		
		static private function setProperty(target:Object, source:Object, xml:XML):void {
			var property:String = xml.@name;
			var access:String = xml.@access;
			if(access == "readwrite" || access == "write") {
				switch(xml.@type) {
					// value types
					case "Boolean":
					case "Number":
					case "int":
					case "uint":
					case "String":
						target[property] = source[property];
						break;
					default: // reference types
						target[property] = copy(source[property]); // no recursion for now
						break;
				}
			}
		}
		
	}
}