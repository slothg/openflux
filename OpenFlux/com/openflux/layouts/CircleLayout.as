package com.openflux.layouts
{
	import flash.geom.Point;
	import mx.utils.ObjectUtil;

	public class CircleLayout extends LayoutBase implements ILayout
	{
		
		public var rotate:Boolean = true;
		
		public function CircleLayout()
		{
			super();
		}
		
		override public function findItemAt(px:Number, py:Number, seamAligned:Boolean):int
		{
			// Can't execute this if we aren't attached to a container.
			if (!container || container.renderers.length == 0)
				return NaN;
				
			// Get the radius and center of the circle.
			var radius : Number = Math.min(container.getExplicitOrMeasuredWidth(), container.getExplicitOrMeasuredHeight()) / 2;
			var hCenter : Number = container.getExplicitOrMeasuredWidth() / 2;
			var vCenter : Number = container.getExplicitOrMeasuredHeight() / 2;
			
			var angle : Number = Math.atan2(py-vCenter, px-hCenter);
			angle += 3.14;
			if (angle < 0)
				angle += 2 * Math.PI;
			// figure out the closest "item" by working backwards from the angle to the index, using floating point math.
			var result : Number = container.renderers.length * angle / (2 * Math.PI);
			trace(result + " " + angle);
			// depending on whether this is seam aligned, do a ceil or round.			
			result = seamAligned ? int(result)+1 : Math.round(result);
			
			// do a modulo op to make sure that this is within [0, length-1]. Modulo is the correct
			// operator in this case because this is a circle.
			result %= container.renderers.length;
			return result;
		}
		
		public function getMeasuredSize():Point
		{
			return new Point(100, 100);
		}
		
		public function generateLayout():void {
			animator.startMove();
			var length:int = container.renderers.length;
			var width:Number = container.getExplicitOrMeasuredWidth()/2;
			var height:Number = container.getExplicitOrMeasuredHeight()/2;
			var offset:Number = 180*(Math.PI/180);
			var rad:Number;
			for (var i:int = 0; i < length; i++) {
				var child:Object = container.renderers[i];
				var token:Object = new Object();
				var w:Number = width;//-child.measuredWidth;
				var h:Number = height;//-child.measuredHeight;
				
				if (i < container.dragTargetIndex)
					rad = ((Math.PI*i)/(length/2))+offset;
				else
					rad = ((Math.PI*i+1)/(length/2))+offset;
				token.x = (w*Math.cos(rad))+w;
				token.y = (h*Math.sin(rad))+h;
				token.width = child.measuredWidth;
				token.height = child.measuredHeight;
				if(rotate) {
					token.rotation = ((360/length)*i);
					while(token.rotation > 180) {
						token.rotation -= 360;
					}
				}
				animator.moveItem(child, token);
				
				trace(ObjectUtil.toString(token));
			}
			animator.stopMove();
		}
		
	}
}