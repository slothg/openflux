package com.openflux.layouts
{
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	public class VerticalLayout extends LayoutBase implements ILayout
	{
		
		private var _gap:Number = 0; [Bindable]
		public function get gap():Number { return _gap; }
		public function set gap(value:Number):void {
			_gap = value;
			container.invalidateSize();
			container.invalidateDisplayList();
		}
		
		public function VerticalLayout():void 
		{
			super();
		}
		
		public function getMeasuredSize():Point {
			var point:Point = new Point(0, 0);
			for each(var child:UIComponent in container.renderers) {
				point.x = Math.max(child.getExplicitOrMeasuredWidth(), point.x);
				point.y += child.getExplicitOrMeasuredHeight() + gap;
			}
			return point;
		}
		
		public function generateLayout():void {
			if(animator) {
				animator.startMove();
				var position:Number = 0;
				for each(var child:UIComponent in container.renderers) {
					var token:Object = new Object();
					token.x = 0;
					token.y = position;
					token.height = child.measuredHeight;
					token.width = container.getExplicitOrMeasuredWidth();
					token.rotation = 0;
					animator.moveItem(child, token);
					position += child.measuredHeight + gap;
				}
				animator.stopMove();
			}
		}
		
	}
}