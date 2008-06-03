package com.openflux.layouts
{
	import com.openflux.views.IContainerView;
	
	import flash.geom.Point;
	
	import mx.core.IFlexDisplayObject;
	
	public class LayoutBase
	{
		
		//private var _dragItems:Array;
		protected var container:IContainerView;
		
		public function findItemAt(px:Number, py:Number, seamAligned:Boolean):int {
			var length:int = container.renderers.length - 1;
			if (length == -1) return -1;
			
			var point:Point;
			var index:int = -1;
			for (var i:int = length; i > -1; i--) {
				var child:IFlexDisplayObject = container.renderers[i];
				var distance:Point = new Point(Math.abs(child.mouseX)-child.width/2, Math.abs(child.mouseY)-child.height/2);
				if(!point || Math.abs(distance.length) < Math.abs(point.length)) {
					point = distance;
					index = i;
				}
			}
			return index;
		}
		
		public function attach(container:IContainerView):void {
			this.container = container;
		}
		
		public function detach(container:IContainerView):void {
			this.container = null;
		}
		
	}
}