package com.openflux.states
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class AddChild extends OverrideBase implements IOverride
	{
		private var _relativeTo:DisplayObjectContainer; [Bindable]
		public function get relativeTo():DisplayObjectContainer { return _relativeTo; }
		public function set relativeTo(value:DisplayObjectContainer):void {
			_relativeTo = value;
		}
		
		private var _position:String; [Bindable]
		public function get position():String { return _position; }
		public function set position(value:String):void {
			_position = value;
		}
		
		public function AddChild() {
			super();
		}

		public function initialize():void {
		}
		
		public function apply(parent:DisplayObjectContainer):void {
			var obj:DisplayObjectContainer = relativeTo ? relativeTo : parent;
			
			if (!target || target.parent)
				return;

			switch (position) {
				case "before":
					obj.parent.addChildAt(target as DisplayObject, obj.parent.getChildIndex(obj));
					break;
				case "after":
					obj.parent.addChildAt(target as DisplayObject, obj.parent.getChildIndex(obj) + 1);
					break;
				case "firstChild":
					obj.addChildAt(target as DisplayObject, 0);
					break;
				case "lastChild":
					obj.addChild(target as DisplayObject);
					break;
			}
		}
		
		public function remove(parent:DisplayObjectContainer):void {
			var obj:DisplayObjectContainer = relativeTo ? relativeTo : parent;
			
			switch (position) {
				case "before":
				case "after":
					obj.parent.removeChild(target as DisplayObject);
					break;
				case "firstChild":
				case "lastChild":
				default:
					if (obj == target.parent)
						obj.removeChild(target as DisplayObject);
					break;
			}
		}
		
	}
}