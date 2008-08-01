package com.openflux.layouts
{
	import com.openflux.animators.AnimationToken;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import mx.core.IUIComponent;
	
	public class VerticalLayout extends LayoutBase implements ILayout//, IDragLayout
	{
		
		[Bindable] [StyleBinding] public var gap:Number; // container listens for propertyChange
		
		public function measure(children:Array):Point {
			var point:Point = new Point(0, 0);
			for each(var child:IUIComponent in children) {
				point.x = Math.max(child.measuredWidth, point.x);
				point.y += child.measuredHeight + gap;
			}
			return point;
		}
		
		public function update(children:Array, width:Number, height:Number):void {
			animator.begin();
			var position:Number = 0;
			var length:int = children.length; //container.children.length;
			for (var i:int = 0; i < length; i++) {
				var child:IUIComponent = children[i];
				var token:AnimationToken = new AnimationToken(width, child.measuredHeight, 0, position);
				animator.moveItem(child as DisplayObject, token);
				position += token.height + gap;
			}
			animator.end();
		}
		
	}
}