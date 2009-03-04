package com.openflux.layouts
{
	import com.openflux.animators.AnimationToken;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IUIComponent;
	
	/**
	 * Horizontal layout (similar to HBox)
	 */
	public class HorizontalLayout extends LayoutBase implements ILayout, IDragLayout
	{
		/**
		 * Constructor
		 */
		public function HorizontalLayout() {
			super();
		}
		
		// ========================================
		// gap property
		// ========================================
		
		private var _gap:Number = 0;
		
		public function get gap():Number { return _gap; }
		public function set gap(value:Number):void {
			if (_gap != value) {
				_gap = value;
				
				if (container) {
					container.invalidateDisplayList();
				}
			}
		}
		
		// ========================================
		// ILayout implementation
		// ========================================
		
		public function measure(children:Array):Point {
			var point:Point = new Point(0, 0);
			
			for each(var child:IUIComponent in container.children) {
				point.x += child.getExplicitOrMeasuredWidth() + gap;
				point.y = Math.max(child.getExplicitOrMeasuredHeight(), point.y);
			}
			
			return point;
		}
		
		public function update(children:Array, rectangle:Rectangle):void {
			adjust(children, rectangle, []);
		}
		
		// ========================================
		// IDragLayout implementation
		// ========================================
		
		public function adjust(children:Array, rectangle:Rectangle, indices:Array):void {
			var position:Number = rectangle.x;
			var length:int = children.length;
			var s:int = 0;
			
			animator.begin();
			
			for (var i:int = 0; i < length; i++) {
				if(indices[s] == i) {
					position += 20 + gap;
				}
				
				var child:IUIComponent = children[i];
				var token:AnimationToken = new AnimationToken(child.getExplicitOrMeasuredWidth(), rectangle.height, position);
				
				animator.moveItem(child as DisplayObject, token);
				position += token.width + gap;
			}
			
			animator.end();
		}
		
		public function findIndexAt(children:Array, x:Number, y:Number):int {
			var closest:DisplayObject;
			var closestDistance:Number = Number.MAX_VALUE;
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
			
			if(closestDistance > 0) {
				index += 1;
			}
			
			return index;
		}
	}
}