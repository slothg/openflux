package com.openflux.layouts
{
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	public class HorizontalLayout extends LayoutBase implements ILayout, IDragLayout
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
		
		public function measure():Point {
			var point:Point = new Point(0, 0);
			for each(var child:UIComponent in container.renderers) {
				point.x += child.getExplicitOrMeasuredWidth() + gap;
				point.y = Math.max(child.getExplicitOrMeasuredHeight(), point.y);
			}
			return point;
		}
		
		public function update(indices:Array = null):void {
			animator.begin();
			
			var xPos:Number = 0;
			var len:int = container.renderers.length;
			//var time:Number = container.dragTargetIndex != -1 ? .2 : 2;
			var child:UIComponent;
			var width:Number;
			var height:Number;
			
			for (var i:int = 0; i < len; i++) {
				child = container.renderers[i];
				width = child.measuredWidth;
				height = container.getExplicitOrMeasuredHeight();
				
				if(indices && indices.indexOf(i, 0) >= 0) {
					xPos += width + gap;
				}
					
				animator.moveItem(child, {x:xPos, y:0, width:width, height:height, rotation:0});
				xPos += width + gap;
			}
			
			animator.end();
		}
		
		override public function findItemAt(px:Number, py:Number, seamAligned:Boolean):int {
			var xPos:Number = 0;
			var child:UIComponent;
			var len:int = container.renderers.length;
			var offset:Number = seamAligned ? gap : 0;
			var width:Number;
			var height:Number;
			
			for (var i:int = 0; i < len; i++) {
				child = container.renderers[i] as UIComponent;
				width = child.getExplicitOrMeasuredWidth();
				height = child.getExplicitOrMeasuredHeight();
				
				if (py <= height && px >= xPos - offset && px <= xPos + width)
					return i;
				xPos += width + gap;
			}
			
			return -1;
		}
		
	}
}