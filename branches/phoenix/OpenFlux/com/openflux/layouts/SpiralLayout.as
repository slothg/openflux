package com.openflux.layouts
{
	import com.openflux.animators.AnimationToken;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IUIComponent;
	
	public class SpiralLayout extends LayoutBase implements ILayout
	{
		public function SpiralLayout() {
			super();
		}
		
		private var _rotations:Number = 5;
		public function get rotations():Number { return _rotations; }
		public function set rotations(value:Number):void {
			_rotations = value;
			if (container)
				container.invalidateDisplayList();
		}
		
		private var _gap:Number = 50;
		public function get gap():Number { return _gap; }
		public function set gap(value:Number):void {
			_gap = value;
			if (container)
				container.invalidateDisplayList();
		}
		
		public function measure(children:Array):Point
		{
			return new Point();
		}
		
		public function update(children:Array, rectangle:Rectangle):void {
			adjust(children, rectangle, []);
		}
		
		public function adjust(children:Array, rectangle:Rectangle, indices:Array):void {
			var numOfItems:int = children.length;		
			if(numOfItems == 0) return;
			
			var radius:Number = Math.min(rectangle.width, rectangle.height) / 2;
			var angle:Number = ((Math.PI * 2) * _rotations) / numOfItems;
			var zPos:Number = 0;
			var m:int = 0;
			
			for(var i:uint=0; i<numOfItems; i++) {
				var child:IUIComponent = children[i];
				var token:AnimationToken = new AnimationToken(child.getExplicitOrMeasuredWidth(), child.getExplicitOrMeasuredHeight());

				token.x = Math.cos((i+m) * angle) * radius;
                token.y = Math.sin((i+m) * angle) * radius;
                token.z = zPos += _gap;
                
				if (indices.indexOf(i) != -1) {
					token.z = zPos += _gap;
					m++;
				}
				
				token.x = token.x + rectangle.width/2 - token.width/2;
				token.y = (token.y*-1) + rectangle.height/2 - token.height/2;
				animator.moveItem(child as DisplayObject, token);
			}
		}

		public function findIndexAt(children:Array, x:Number, y:Number):int {
			return 0;
		}

	}
}