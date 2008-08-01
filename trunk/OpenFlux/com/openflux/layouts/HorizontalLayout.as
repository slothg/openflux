package com.openflux.layouts
{
	import com.openflux.animators.AnimationToken;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	
	public class HorizontalLayout extends LayoutBase implements ILayout//, IDragLayout
	{
		
		public var gap:Number = 0;
		
		public function measure(children:Array):Point {
			var point:Point = new Point(0, 0);
			for each(var child:UIComponent in container.children) {
				point.x += child.measuredWidth + gap;
				point.y = Math.max(child.measuredHeight, point.y);
			}
			return point;
		}
		
		public function update(children:Array, width:Number, height:Number):void {
			animator.begin();
			var position:Number = 0;
			var length:int = children.length;
			for (var i:int = 0; i < length; i++) {
				var child:IUIComponent = children[i];
				var token:AnimationToken = new AnimationToken(child.measuredWidth, height, position);
				animator.moveItem(child as DisplayObject, token);
				position += child.measuredWidth + gap;
			}
			animator.end();
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