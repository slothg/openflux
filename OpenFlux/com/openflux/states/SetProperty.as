package com.openflux.states
{
	import com.openflux.core.PhoenixComponent;
	
	import flash.display.DisplayObjectContainer;

	public class SetProperty extends OverrideBase implements IOverride {
		private var oldValue:Object;
		private var oldRelatedValues:Array;
		
		private static const PSEUDONYMS:Object = {
			width: "explicitWidth",
			height: "explicitHeight" };
		
		private static const RELATED_PROPERTIES:Object = {
			explicitWidth: [ "percentWidth" ],
			explicitHeight: [ "percentHeight" ] };
		
		private var _name:String;
		public function get name():String { return _name; }
		public function set name(value:String):void {
			_name = value;
		}
		
		private var _value:*;
		public function get value():* { return _value; }
		public function set value(value:*):void {
			_value = value;
		}
		
		public function SetProperty() {
		}

		public function initialize():void {
		}
		
		public function apply(parent:DisplayObjectContainer):void {
			var obj:Object = target ? target : parent;
			var propName:String = PSEUDONYMS[name] ? PSEUDONYMS[name] : name;
			var relatedProps:Array = RELATED_PROPERTIES[propName] ? RELATED_PROPERTIES[propName] : null;
			var newValue:* = value;

			oldValue = obj[propName];

			if (relatedProps) {
				oldRelatedValues = [];
				for (var i:int = 0; i < relatedProps.length; i++)
					oldRelatedValues[i] = obj[relatedProps[i]];
			}
			
			if (name == "width" || name == "height") {
				if (newValue is String && newValue.indexOf("%") >= 0) {
					propName = name == "width" ? "percentWidth" : "percentHeight";
					newValue = newValue.slice(0, newValue.indexOf("%"));
				} else {
					propName = name;
				}
			}
			
			setPropertyValue(obj, propName, newValue, oldValue);
		}
		
		public function remove(parent:DisplayObjectContainer):void {
			var obj:Object = target ? target : parent;
			var propName:String = PSEUDONYMS[name] ? PSEUDONYMS[name] : name;
			var relatedProps:Array = RELATED_PROPERTIES[propName] ? RELATED_PROPERTIES[propName] : null;
			
			if ((name == "width" || name == "height") && !isNaN(Number(oldValue))) {
				propName = name;
			}
			
			setPropertyValue(obj, propName, oldValue, oldValue);
			
			if (relatedProps) {
				for (var i:int = 0; i < relatedProps.length; i++) {
					setPropertyValue(obj, relatedProps[i],
					oldRelatedValues[i], oldRelatedValues[i]);
				}
			}
		}


		private function setPropertyValue(obj:Object, name:String, value:*, valueForType:Object):void {
			if (valueForType is Number)
				obj[name] = Number(value);
			else if (valueForType is Boolean)
				obj[name] = toBoolean(value);
			else
				obj[name] = value;
		}
		
		private function toBoolean(value:Object):Boolean {
			if (value is String)
				return value.toLowerCase() == "true";
			return value != false;
		}

	}
}