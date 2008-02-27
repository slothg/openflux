package com.openflux.layouts
{
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	public class HorizontalLayout extends LayoutBase implements ILayout
	{
		
		private var _gap:Number = 0; [Bindable]
		public function get gap():Number { return _gap; }
		public function set gap(value:Number):void {
			_gap = value;
			container.invalidateSize();
			container.invalidateDisplayList();
		}
		
		public function HorizontalLayout():void 
		{
			super();
		}
		
		public function getMeasuredSize():Point {
			var point:Point = new Point(0, 0);
			for each(var child:UIComponent in container.renderers) {
				point.x += child.getExplicitOrMeasuredWidth() + gap;
				point.y = Math.max(child.getExplicitOrMeasuredHeight(), point.y);
			}
			return point;
		}
		
		public function generateLayout():void {
			if(animator) {
				animator.startMove();
				var position:Number = 0;
				for each(var child:UIComponent in container.renderers) {
					var token:Object = new Object();
					token.x = position;
					token.y = 0;
					token.width = child.measuredWidth;
					token.height = container.getExplicitOrMeasuredHeight();
					token.rotation = 0;
					animator.moveItem(child, token);
					position += child.measuredWidth + gap;
				}
				animator.stopMove();
			}
		}
		
	}
}