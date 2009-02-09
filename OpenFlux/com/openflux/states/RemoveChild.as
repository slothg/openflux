package com.openflux.states
{
	import com.openflux.core.PhoenixComponent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class RemoveChild extends OverrideBase implements IOverride
	{
		private var oldParent:DisplayObjectContainer;
		private var oldIndex:int;
		
		public function RemoveChild() {
			super();
		}

		public function initialize():void {
		}
		
		public function apply(parent:DisplayObjectContainer):void {
			if (target.parent) {
				oldParent = target.parent;
				oldIndex = oldParent.getChildIndex(target as DisplayObject);
				oldParent.removeChild(target as DisplayObject);
			}
		}
		
		public function remove(parent:DisplayObjectContainer):void {
			oldParent.addChildAt(target as DisplayObject, oldIndex);
			
			// hmm, do I really need this?
			if (target is PhoenixComponent)
				PhoenixComponent(target).updateCallbacks();
		}
		
	}
}