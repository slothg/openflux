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
			for each(var child:UIComponent in container.children) {
				point.x += child.measuredWidth + gap;
				point.y = Math.max(child.measuredHeight, point.y);
			}
			return point;
		}
		
		public function update(indices:Array = null):void {
			container.animator.begin();
			
			var position:Number = 0;
			var length:int = container.children.length;
			for (var i:int = 0; i < length; i++) {
				var child:UIComponent = container.children[i];
				var token:Object = new Object();
				
				token.x = position;
				token.y = 0
				token.width = child.measuredWidth;
				token.height = container.height;
				token.rotation = 0;
				if(indices && indices.indexOf(i, 0) >= 0) {
					position += child.measuredWidth + gap;
				}
				
				container.animator.moveItem(child, token);
				position += child.measuredWidth + gap;
			}
			
			container.animator.end();
		}
		
		override public function findItemAt(px:Number, py:Number, seamAligned:Boolean):int {
			var xPos:Number = 0;
			var child:UIComponent;
			var len:int = container.children.length;
			var offset:Number = seamAligned ? gap : 0;
			var width:Number;
			var height:Number;
			
			for (var i:int = 0; i < len; i++) {
				child = container.children[i] as UIComponent;
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