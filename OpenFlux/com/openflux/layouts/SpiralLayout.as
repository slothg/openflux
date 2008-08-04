package com.openflux.layouts
{
	import com.openflux.animators.AnimationToken;
	import com.plexiglass.animators.PlexiAnimationToken;
	
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
			var numOfItems:int = children.length;		
			if(numOfItems == 0) return;
			
			var radius:Number = Math.min(rectangle.width, rectangle.height);
			var angle:Number = ((Math.PI * 2) * _rotations) / numOfItems;
			var zPos:Number = 0;
			
			for(var i:uint=0; i<numOfItems; i++) {
				var child:IUIComponent = children[i];
				var layoutItem:LayoutItem = new LayoutItem(child);
				var token:AnimationToken = new PlexiAnimationToken(layoutItem.preferredWidth, layoutItem.preferredHeight);
				token.x = Math.cos(i * angle) * radius;
                token.y = Math.sin(i * angle) * radius;
                token.z = zPos += _gap;
                
				animator.moveItem(child as DisplayObject, token);
			}
		}

	}
}