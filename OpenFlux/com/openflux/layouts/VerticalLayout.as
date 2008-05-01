package com.openflux.layouts
{
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	public class VerticalLayout extends LayoutBase implements ILayout
	{
		
		private var _gap:Number = 0; [Bindable]
		public function get gap():Number { return _gap; }
		public function set gap(value:Number):void {
			if (_gap != value) {
				_gap = value;
				container.invalidateLayout();
			}
		}
		
		public function VerticalLayout():void {
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
			animator.begin();
			
			var yPos:Number = 0;
			var len:int = container.renderers.length;
			var time:Number = container.dragTargetIndex != -1 ? .2 : 2;
			var child:UIComponent;
			var width:Number;
			var height:Number;
			
			for (var i:int = 0; i < len; i++) {
				child = container.renderers[i];
				width = child.getExplicitOrMeasuredWidth();
				height = child.getExplicitOrMeasuredHeight();
				
				if (i == container.dragTargetIndex)
					yPos += height + gap;
					
				animator.moveItem(child, {x:0, y:yPos, width:width, height:height, rotation:0, time:time});
				yPos += height + gap;
			}
			
			animator.end();
		}
		
		override public function findItemAt(px:Number, py:Number, seamAligned:Boolean):int {
			var yPos:Number = 0;
			var len:int = container.renderers.length;
			var offset:Number = seamAligned ? gap : 0;
			var child:UIComponent;
			var width:Number;
			var height:Number;
			
			for (var i:int = 0; i < len; i++) {
				child = container.renderers[i] as UIComponent;
				width = child.getExplicitOrMeasuredWidth();
				height = child.getExplicitOrMeasuredHeight();
				
				if (px <= width && py >= yPos - offset && py <= yPos + height)
					return i;
				yPos += height + gap;
			}
			
			return -1;
		}
	}
}