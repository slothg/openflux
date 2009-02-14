package com.openflux.utils
{
	import com.openflux.metadata.ClassDirectives;
	import com.openflux.metadata.DefaultSettingsDirective;
	
	import flash.utils.getDefinitionByName;
	
	public class MetaInjector
	{
		
		static public function createDefaults(target:Object):void {
			// create default assignments based on metadata
			var directives:ClassDirectives = MetaUtil.resolveDirectives(target);
			for each(var directive:DefaultSettingsDirective in directives.defaultSettings) {
				updateProperty(target, directive.property, directive.value);
			}
		}
		
		static private function updateProperty(target:Object, property:String, value:String):void {
			if(target[property]==null) {
				var Cls:Object = flash.utils.getDefinitionByName(value);
				target[property] = new Cls();
			}
		}
		
	}
}