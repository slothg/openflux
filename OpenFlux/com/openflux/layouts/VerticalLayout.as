package com.openflux.layouts
{
	import com.openflux.animators.AnimationToken;
	
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	public class VerticalLayout extends LayoutBase implements ILayout, IDragLayout
	{
		
		private var _gap:Number = 0;
		
		[Bindable] [StyleBinding]
		public function get gap():Number { return _gap; }
		public function set gap(value:Number):void {
			if (_gap != value) {
				_gap = value;
				container.invalidateLayout();
			}
		}
		
		public function measure():Point {
			var point:Point = new Point(0, 0);
			for each(var child:UIComponent in container.children) {
				point.x = Math.max(child.measuredWidth, point.x);
				point.y += child.measuredHeight + gap;
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
				
				if(indices && indices.indexOf(i, 0) >= 0) {
					position += child.measuredHeight + gap;
				}
				token.x = 0;
				token.y = position;
				token.width = container.width;
				token.height = child.height;
				
				container.animator.moveItem(child, token);
				position += token.height + gap;
			}
			container.animator.end();
		}
		/*
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
		*/
	}
}