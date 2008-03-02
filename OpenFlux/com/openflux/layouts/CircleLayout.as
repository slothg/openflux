package com.openflux.layouts
{
	import flash.geom.Point;
	
	import mx.core.UIComponent;

	public class CircleLayout extends LayoutBase implements ILayout
	{
		
		public var rotate:Boolean = true;
		
		public function CircleLayout()
		{
			super();
		}
		
		public function getMeasuredSize():Point
		{
			return new Point(100, 100);
		}
		
		public function generateLayout():void {
			//if(!animator.isAnimating()) {
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
				rad = ((Math.PI*i)/(length/2))+offset;
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
			}
			animator.stopMove();
			//}
		}
		
	}
}