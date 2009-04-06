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
	import com.openflux.controllers.ComplexController;
	import com.openflux.metadata.ClassDirectives;
	import com.openflux.metadata.DefaultSettingsDirective;
	
	import flash.utils.getDefinitionByName;
	
	public class MetaInjector
	{
		
		static public function createDefaults(target:Object):void {
			// create default assignments based on metadata
			var directives:ClassDirectives = MetaUtil.resolveDirectives(target);
			var defaultSettings:Array = directives.defaultSettings.concat().reverse();
			
			for each(var directive:DefaultSettingsDirective in defaultSettings) {
				updateProperty(target, directive.property, directive.value);
			}
		}
		
		static private function updateProperty(target:Object, property:String, value:String):void {
			if(target[property]==null) {
				if (property == "controller" && value.indexOf(",") != -1) {
					target[property] = new ComplexController(value.split(/\s*\,\s*/).map(function (item:*, index:int, array:Array):* {
						var Cls:Object = flash.utils.getDefinitionByName(item);
						return new Cls();
					}));
				} else {
					var Cls:Object = flash.utils.getDefinitionByName(value);
					target[property] = new Cls();
				}
			}
		}
		
	}
}