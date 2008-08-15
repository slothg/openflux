package com.openflux.layouts
{
	import com.openflux.animators.AnimationToken;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IUIComponent;
	
	public class VerticalLayout extends LayoutBase implements ILayout, IDragLayout
	{
		
		[Bindable] [StyleBinding] public var gap:Number; // container listens for propertyChange
		
		// ILayout Implementation
		
		public function measure(children:Array):Point {
			var point:Point = new Point(0, 0);
			for each(var child:IUIComponent in children) {
				var li:LayoutItem = new LayoutItem(child);
				point.x = Math.max(child.getExplicitOrMeasuredWidth(), point.x);
				point.y += child.getExplicitOrMeasuredHeight() + gap;
			}
			return point;
		}
		
		public function update(children:Array, rectangle:Rectangle):void {
			adjust(children, rectangle, []);
		}
		
		// IDragLayout Implementation
		
		public function adjust(children:Array, rectangle:Rectangle, indices:Array):void {
			animator.begin();
			var position:Number = rectangle.y;
			var length:int = children.length; //container.children.length;
			var s:int = 0;
			for (var i:int = 0; i < length; i++) {
				if(indices[s] == i) {
					position += 20 + gap;
				}
				var child:IUIComponent = children[i];
				var token:AnimationToken = new AnimationToken(rectangle.width, child.getExplicitOrMeasuredHeight(), 0, position);
				animator.moveItem(child as DisplayObject, token);
				position += token.height + gap;
			}
			animator.end();
		}
		
		public function findIndexAt(children:Array, x:Number, y:Number):int {
			
			var closest:DisplayObject;
			var closestDistance:Number = Number.MAX_VALUE;
			
			// find the closest child
			var length:int = children.length;
			for each(var child:DisplayObject in children) {
				var distance:Number = y - (child.y+child.height/2);
				if(Math.abs(distance) < Math.abs(closestDistance)) {
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