package com.openflux.layouts
{
	import com.openflux.animators.AnimationToken;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IUIComponent;
	import mx.utils.ObjectUtil;

	public class CircleLayout extends LayoutBase implements ILayout, IDragLayout
	{
		
		[StyleBinding] public var rotate:Boolean = true;
		
		public function findIndexAt(children:Array, x:Number, y:Number):int {
			var hCenter:Number = container.width / 2;
			var vCenter:Number = container.height / 2;
			var angle:Number = Math.atan2(y-vCenter, x-hCenter) + Math.PI;
			var index:Number = angle * children.length / (2 * Math.PI);

			trace("hCenter: " + hCenter + " vCenter " + vCenter);			
			trace("angle: " + angle + " index: " + index);
			trace("degrees " + Math.round(angle * 180 / Math.PI));
			
			return index;
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
				var layoutItem:LayoutItem = new LayoutItem(child);
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