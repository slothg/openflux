package com.openflux.layouts
{
	import com.openflux.animators.AnimationToken;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IUIComponent;

	public class CircleLayout extends LayoutBase implements ILayout, IDragLayout
	{
		
		[StyleBinding] public var rotate:Boolean = true;
		
		// this part seems busted, I'll deal with it later
		public function findIndexAt(children:Array, x:Number, y:Number/*, seamAligned:Boolean*/):int {
			// Can't execute this if we aren't attached to a container.
			//if (!container || container.renderers.length == 0)
			//	return NaN;
				
			// Get the radius and center of the circle.
			var radius : Number = Math.min(container.getExplicitOrMeasuredWidth(), container.getExplicitOrMeasuredHeight()) / 2;
			var hCenter : Number = container.getExplicitOrMeasuredWidth() / 2;
			var vCenter : Number = container.getExplicitOrMeasuredHeight() / 2;
			
			var angle : Number = Math.atan2(y-vCenter, x-hCenter);
			angle += 3.14;
			if (angle < 0)
				angle += 2 * Math.PI;
			// figure out the closest "item" by working backwards from the angle to the index, using floating point math.
			var result : Number = container.children.length * angle / (2 * Math.PI);
			//trace(result + " " + angle);
			// depending on whether this is seam aligned, do a ceil or round.			
			result = Math.round(result); //seamAligned ? int(result)+1 : Math.round(result);
			
			// do a modulo op to make sure that this is within [0, length-1]. Modulo is the correct
			// operator in this case because this is a circle.
			result %= container.children.length;
			return result;
		}
		
		public function measure(children:Array):Point
		{
			var point:Point = new Point(100, 100);
			return point;
		}
		
		public function update(children:Array, rectangle:Rectangle):void {
			adjust(children, rectangle, []);
		}
		
		public function adjust(children:Array, rectangle:Rectangle, indices:Array):void {
			animator.begin();
			var length:int = children.length;
			var width:Number = rectangle.width/2;
			var height:Number = rectangle.height/2;
			var offset:Number = 180*(Math.PI/180);
			var rad:Number;
			for (var i:int = 0; i < length; i++) {
				var child:IUIComponent = children[i];
				var token:AnimationToken = new AnimationToken(child.measuredWidth, child.measuredHeight);
				var w:Number = width-child.measuredWidth;
				var h:Number = height-child.measuredHeight;
				
				if(indices && indices.indexOf(i, 0) >= 0) {
					rad = ((Math.PI*i)/(length/2))+offset;
				} else {
					rad = ((Math.PI*i+1)/(length/2))+offset;
				}
				token.x = (w*Math.cos(rad))+w;
				token.y = (h*Math.sin(rad))+h;
				
				if(rotate) {
					token.rotationY = ((360/length)*i);
					while(token.rotationY > 180) {
						token.rotationY -= 360;
					}
				}
				animator.moveItem(child as DisplayObject, token);
			}
			animator.end();
		}
		
	}
}