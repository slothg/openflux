package com.openflux.layouts
{
	import com.openflux.containers.IFluxContainer;
	
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import mx.core.IFlexDisplayObject;
	
	public class LayoutBase extends EventDispatcher
	{
		
		//private var _dragItems:Array;
		protected var container:IFluxContainer;
		
		public function findItemAt(px:Number, py:Number, seamAligned:Boolean):int {
			var length:int = container.children.length - 1;
			if (length == -1) return -1;
			
			var point:Point;
			var index:int = -1;
			for (var i:int = length; i > -1; i--) {
				var child:IFlexDisplayObject = container.children[i];
				var distance:Point = new Point(Math.abs(child.mouseX)-child.width/2, Math.abs(child.mouseY)-child.height/2);
				if(!point || Math.abs(distance.length) < Math.abs(point.length)) {
					point = distance;
					index = i;
				}
			}
			return index;
		}
		
		public function attach(container:IFluxContainer):void {
			this.container = container;
		}
		
		public function detach(container:IFluxContainer):void {
			this.container = null;
		}
		
	}
}