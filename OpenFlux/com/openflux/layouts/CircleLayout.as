package com.openflux.layouts
{
	import flash.geom.Point;
	
	import mx.utils.ObjectUtil;

	public class CircleLayout extends LayoutBase implements ILayout, IDragLayout
	{
		
		[StyleBinding] public var rotate:Boolean = true;
		
		override public function findItemAt(px:Number, py:Number, seamAligned:Boolean):int
		{
			// Can't execute this if we aren't attached to a container.
			//if (!container || container.renderers.length == 0)
			//	return NaN;
				
			// Get the radius and center of the circle.
			var radius : Number = Math.min(container.getExplicitOrMeasuredWidth(), container.getExplicitOrMeasuredHeight()) / 2;
			var hCenter : Number = container.getExplicitOrMeasuredWidth() / 2;
			var vCenter : Number = container.getExplicitOrMeasuredHeight() / 2;
			
			var angle : Number = Math.atan2(py-vCenter, px-hCenter);
			angle += 3.14;
			if (angle < 0)
				angle += 2 * Math.PI;
			// figure out the closest "item" by working backwards from the angle to the index, using floating point math.
			var result : Number = container.children.length * angle / (2 * Math.PI);
			//trace(result + " " + angle);
			// depending on whether this is seam aligned, do a ceil or round.			
			result = seamAligned ? int(result)+1 : Math.round(result);
			
			// do a modulo op to make sure that this is within [0, length-1]. Modulo is the correct
			// operator in this case because this is a circle.
			result %= container.children.length;
			return result;
		}
		
		public function measure():Point
		{
			var point:Point = new Point(100, 100);
			return point;
		}
		
		public function update(indices:Array = null):void {
			container.animator.begin();
			var length:int = container.children.length;
			var width:Number = container.width/2;
			var height:Number = container.height/2;
			var offset:Number = 180*(Math.PI/180);
			var rad:Number;
			for (var i:int = 0; i < length; i++) {
				var child:Object = container.children[i];
				var token:Object = new Object();
				var w:Number = width-child.width;
				var h:Number = height-child.height;
				
				if(indices && indices.indexOf(i, 0) >= 0) {
					rad = ((Math.PI*i)/(length/2))+offset;
				} else {
					rad = ((Math.PI*i+1)/(length/2))+offset;
				}
				token.x = (w*Math.cos(rad))+w;
				token.y = (h*Math.sin(rad))+h;
				token.width = child.width;
				token.height = child.height;
				if(rotate) {
					token.rotation = ((360/length)*i);
					while(token.rotation > 180) {
						token.rotation -= 360;
					}
				}
				container.animator.moveItem(child, token);
				
				trace(ObjectUtil.toString(token));
			}
			container.animator.end();
		}
		
	}
}