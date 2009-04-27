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
				switch(xml.@type.toString()) {
					// reference types
					case "com.openflux.core::IFluxView":
					case "com.openflux.core::IFluxController":
					case "com.openflux.layouts::ILayout":
					case "com.openflux.animator::IAnimator":
					case "flash.display::DisplayObject":
						target[property] = copy(source[property]); // no recursion for now
						break;
					/*case "Boolean":
					case "Number":
					case "int":
					case "uint":
					case "String":
					case "Array":
					case "XML":
					case "XMLList":
					case "mx.collections::IList":*/
					default: // value types
						target[property] = source[property];
						break;
				}
			}
		}
		
	}
}