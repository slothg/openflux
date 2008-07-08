package com.plexiglass.layouts
{
	import com.openflux.core.IFluxList;
	import com.openflux.layouts.ILayout;
	import com.openflux.layouts.LayoutBase;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class CoverFlowLayout extends LayoutBase implements ILayout
	{
		public function CoverFlowLayout()
		{
			super();
		}
		
		private var _gap:Number = 2;
		[Bindable]
		public function get gap():Number { return _gap; }
		public function set gap(value:Number):void {
			_gap = value;
			container.invalidateDisplayList();
		}
		
		private var _distance:Number = 2;
		[Bindable]
		public function get distance():Number { return _distance; }
		public function set distance(value:Number):void {
			_distance = value;
			container.invalidateDisplayList();
		}
		
		private var _rotationAngle:Number = 70;
		[Bindable]
		public function get rotationAngle():Number { return _rotationAngle; }
		public function set rotationAngle(value:Number):void {
			_rotationAngle = value;
			container.invalidateDisplayList();
		}
		
		private var _direction:String = "horizontal";
		[Bindable]
		public function get direction():String { return _direction; }
		public function set direction(value:String):void {
			_direction = value;
			container.invalidateDisplayList();
		} 
		
		public function measure():Point
		{
			return new Point(100, 100);
		}
		
		public function update(indices:Array = null):void
		{
			if (container.children.length > 0) {
				var selectedIndex:int = 0; //container["selectedIndex"] as int;
				if(container is IFluxList) {
					(container as IFluxList).selectedItems;
				}
				var selectedChild:DisplayObject = container.children[selectedIndex]; //.material.movie;
				
				var maxChildHeight:Number = 123;
				var maxChildWidth:Number = 79;	
				var horizontalGap:Number = direction == "horizontal" ? maxChildHeight / 3 : _distance;
				var verticalGap:Number = direction == "horizontal" ? _distance : maxChildWidth / 3;
				
				var abs:Number;
				var xPosition:Number;
				var yPosition:Number;
				var zPosition:Number;
				var yRotation:Number;
				var xRotation:Number;
				
				container.animator.begin();
				
				for (var i:int = 0; i < container.children.length; i++) {
					var child:DisplayObject = container.children[i];
					
					abs = Math.abs(selectedIndex - i);
					
					if (direction == "horizontal") {
						xPosition = selectedChild.width + ((abs - 1) * horizontalGap);
						if (_gap > 0) xPosition += (abs - 1) * (_gap + child.width);
						yPosition = -(maxChildHeight - child.height) / 2;
						zPosition = -200 / 2 + selectedChild.width + abs * verticalGap;
						yRotation = rotationAngle;
						xRotation = 0;
						
						if(i < selectedIndex) {
							xPosition *= -1;
							yRotation *= -1;
						} else if(i == selectedIndex) {
							xPosition = 0;
							zPosition = -200 / 2;
							yRotation = 0;
						}
					} else {
						yPosition = selectedChild.height + ((abs - 1) * verticalGap);
						if (_gap > 0) yPosition += (abs - 1) * (_gap + child.height);
						xPosition = 0;
						zPosition = -200 / 2 + selectedChild.height + abs * horizontalGap;
						xRotation = rotationAngle;
						yRotation = 0;
						
						if(i < selectedIndex) {
							yPosition *= -1;
							xRotation *= -1;
						} else if(i == selectedIndex) {
							yPosition = 0;
							zPosition = -200 / 2;
							xRotation = 0;
						}
					}
					
					if(i != selectedIndex) {
						container.animator.moveItem(child, {z:zPosition, time:1/3});
						container.animator.moveItem(child, {x:xPosition, y:yPosition, rotationY:yRotation, rotationX:xRotation, time:0.500});
					} else {
						container.animator.moveItem(child, {x:xPosition, y:yPosition, z:zPosition, rotationZ:0, rotationY:yRotation, rotationX:xRotation, time:0.500});
					}
				}
				
				container.animator.end();	
			}
			
		}
		
	}
}