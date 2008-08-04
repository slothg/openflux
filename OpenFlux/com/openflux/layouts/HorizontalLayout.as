package com.openflux.layouts
{
	import com.openflux.animators.AnimationToken;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IUIComponent;
	
	public class HorizontalLayout extends LayoutBase implements ILayout, IDragLayout
	{
		
		public var gap:Number = 0;
		
		public function measure(children:Array):Point {
			var point:Point = new Point(0, 0);
			for each(var child:IUIComponent in container.children) {
				var li:LayoutItem = new LayoutItem(child);
				point.x += li.preferredWidth + gap;
				point.y = Math.max(li.preferredHeight, point.y);
			}
			return point;
		}
		
		public function update(children:Array, rectangle:Rectangle):void {
			adjust(children, rectangle, []);
		}
		
		public function adjust(children:Array, rectangle:Rectangle, indices:Array):void {
			animator.begin();
			var position:Number = rectangle.x;
			var length:int = children.length;
			var s:int = 0;
			for (var i:int = 0; i < length; i++) {
				if(indices[s] == i) {
					position += 20 + gap;
				}
				var child:IUIComponent = children[i];
				var token:AnimationToken = new AnimationToken(child.measuredWidth, rectangle.height, position);
				animator.moveItem(child as DisplayObject, token);
				position += token.width + gap;
			}
			animator.end();
		}


		public function findIndexAt(children:Array, x:Number, y:Number):int {
			var closest:DisplayObject;
			var closestDistance:Number = Number.MAX_VALUE;
			
			// find the closest child
			var length:int = children.length;
			for each(var child:DisplayObject in children) {
				var distance:Number = x - (child.x+child.width/2);
				if(Math.abs(distance) < closestDistance) {
					closest = child;
					closestDistance = distance;
				}
			}
			
			// set the index based on the closest child
			var index:int = children.indexOf(closest);
			if(closestDistance > 0) { index += 1;}
			return index;
			
		}
		
	}
}