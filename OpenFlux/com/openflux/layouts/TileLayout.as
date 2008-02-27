package com.openflux.layouts
{
	import com.openflux.layouts.animators.TweenAnimator;
	
	import flash.geom.Point;
	
	import mx.core.UIComponent;

	public class TileLayout extends LayoutBase implements ILayout
	{
		
		public var measuredGap:Number;
		public var horizontalAlignment:String = "left";
		public var verticalAlignment:String = "top";
		
		public function TileLayout():void {
			super();
			animator = new TweenAnimator();
		}
		
		public function getMeasuredSize():Point {
			var point:Point = new Point();
			for each(var child:UIComponent in container.renderers) {
				point.x = Math.max(child.getExplicitOrMeasuredWidth(), point.x);
				point.y += child.getExplicitOrMeasuredHeight() + 10;
			}
			return point;
		}
		
		public function generateLayout():void {
			var point:Point = measureGrid();
			var cols:Number = Math.floor(container.getExplicitOrMeasuredWidth()/point.x);
			var space:Number = container.getExplicitOrMeasuredWidth()-(point.x*cols);
			space = space/(cols+1);
			animator.startMove();
			var x:Number = space/2;
			var y:Number = space/2;
			for each(var child:UIComponent in container.renderers) {
				var token:Object = new Object();
				token.x = x;
				token.y = y;
				token.width = child.measuredWidth;
				token.height = child.measuredHeight;
				token.rotation = 0;
				animator.moveItem(child, token);
				x += child.measuredWidth + 10;
				if(x > container.getExplicitOrMeasuredWidth() - child.measuredWidth - space/2) {
					x = space/2;
					y += child.measuredHeight + 8;
				}
			}
			animator.stopMove();
		}
		
		private function measureGrid():Point {
			
			var point:Point = new Point();
			for each(var child:UIComponent in container.renderers) {
				var w:Number = child.measuredWidth;
				var h:Number = child.measuredHeight;
				if(w > point.x) {
					point.x = w;
				}
				if(h > point.y) {
					point.y = h;
				}
			}
			var gap:Point = new Point(container.getExplicitOrMeasuredWidth(), container.getExplicitOrMeasuredHeight());
			// do something
			return point;
		}
		
	}
}