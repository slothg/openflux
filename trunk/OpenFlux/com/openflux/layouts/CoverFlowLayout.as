package com.openflux.layouts
{
	import com.openflux.animators.AnimationToken;
	import com.openflux.core.IFluxList;
	import com.openflux.core.IFluxView;
	import com.openflux.layouts.ILayout;
	import com.openflux.layouts.LayoutBase;
	import com.openflux.utils.ListUtil;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IUIComponent;

	public class CoverFlowLayout extends LayoutBase implements ILayout
	{
		public function CoverFlowLayout()
		{
			super();
			updateOnChange = true;
		}
		
		private var _gap:Number = 0;
		[Bindable]
		public function get gap():Number { return _gap; }
		public function set gap(value:Number):void {
			_gap = value;
			if (container) container.invalidateDisplayList();
		}
		
		private var _distance:Number = 10;
		[Bindable]
		public function get distance():Number { return _distance; }
		public function set distance(value:Number):void {
			_distance = value;
			if (container) container.invalidateDisplayList();
		}
		
		private var _angle:Number = 70;
		[Bindable]
		public function get angle():Number { return _angle; }
		public function set angle(value:Number):void {
			_angle = value;
			if (container) container.invalidateDisplayList();
		}
		
		private var _direction:String = "horizontal";
		[Bindable]
		public function get direction():String { return _direction; }
		public function set direction(value:String):void {
			_direction = value;
			if (container) container.invalidateDisplayList();
		}
		
		public function measure(children:Array):Point
		{
			return new Point(100, 100);
		}
		
		public function update(children:Array, rectangle:Rectangle):void
		{
			adjust(children, rectangle, []);
		}
			
		public function adjust(children:Array, rectangle:Rectangle, indices:Array):void
		{
			var list:IFluxList = (container as IFluxView).component as IFluxList;
			var selectedIndex:int = list ? Math.max(0, ListUtil.selectedIndex(list)) : 0;
			var selectedChild:IUIComponent = children[selectedIndex];
			
			var maxChildHeight:Number = selectedChild.measuredHeight;
			var maxChildWidth:Number = selectedChild.measuredWidth;	
			var horizontalGap:Number = direction == "horizontal" ? maxChildHeight / 3 : _distance;
			var verticalGap:Number = direction == "horizontal" ? _distance : maxChildWidth / 3;
				
			container.animator.begin();
				
			var child:IUIComponent;
			var token:AnimationToken;
			var abs:Number;
			var offset:Number = 0;
			
			for (var i:int = 0; i < children.length; i++) {
				child = children[i];
				token = new AnimationToken(child.getExplicitOrMeasuredWidth(), child.getExplicitOrMeasuredHeight());
				abs = Math.abs(selectedIndex - i);
				
				if (direction == "horizontal") {
					if (indices.indexOf(i) != -1)
						offset += token.width;

					token.x = selectedChild.getExplicitOrMeasuredWidth() + ((abs - 1) * horizontalGap) + offset;
					if (_gap > 0) token.x += (abs - 1) * (_gap + token.width);
					token.y = -(maxChildHeight - child.height) / 2;
					token.z = selectedChild.getExplicitOrMeasuredWidth() + abs * verticalGap;
					token.rotationY = angle;
					
					if(i < selectedIndex) {
						token.x *= -1;
						token.rotationY *= -1;
					} else if(i == selectedIndex) {
						token.x = 0;
						token.z = -200 / 2;
						token.rotationY = 0;
						offset = 0;
					}
				} else {
					if (indices.indexOf(i) != -1)
						offset += token.height;
						
					token.y = selectedChild.getExplicitOrMeasuredHeight() + ((abs - 1) * verticalGap) + offset;
					if (_gap > 0) token.y += (abs - 1) * (_gap + token.height);
					token.x = 0;
					token.z = selectedChild.getExplicitOrMeasuredHeight() + abs * horizontalGap; 
					token.rotationX = angle;
					token.rotationY = 0;
					
					if(i < selectedIndex) {
						token.y *= -1;
						token.rotationX *= -1;
					} else if(i == selectedIndex) {
						token.y = 0;
						token.z = 200 / 2; 
						token.rotationX = 0;
						offset = 0;
					}
				}
				
				token.x = token.x + rectangle.width/2 - token.width/2;
				token.y = (token.y*-1) + rectangle.height/2 - token.height/2;
				container.animator.moveItem(child as DisplayObject, token);
			}
			
			container.animator.end();	
		}		
	}
}