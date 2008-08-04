package com.plexiglass.layouts
{
	import com.openflux.animators.AnimationToken;
	import com.openflux.containers.IFluxContainer;
	import com.openflux.core.IFluxList;
	import com.openflux.core.IFluxView;
	import com.openflux.layouts.ILayout;
	import com.openflux.layouts.LayoutBase;
	import com.openflux.layouts.LayoutItem;
	import com.plexiglass.animators.PlexiAnimationToken;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	import mx.core.IUIComponent;
	import mx.events.ListEvent;

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
		
		override public function attach(container:IFluxContainer):void
		{
			super.attach(container);
			
			if ((container as IFluxView).component is IFluxList)
				(container as IFluxView).component.addEventListener(ListEvent.ITEM_CLICK, onChange);
		}
		
		override public function detach(container:IFluxContainer):void
		{
			super.detach(container);
			
			if ((container as IFluxView).component is IFluxList)
				(container as IFluxView).component.removeEventListener(ListEvent.ITEM_CLICK, onChange);
		}
		
		private function onChange(event:ListEvent):void
		{
			container.invalidateDisplayList();
		}
		
		public function measure(children:Array):Point
		{
			return new Point(100, 100);
		}
		
		public function update(children:Array, rectangle:Rectangle):void
		{				
			var list:IFluxList = (container as IFluxView).component as IFluxList;
			var selectedIndex:int = (list && list.selectedItems) ? (list.data as ArrayCollection).getItemIndex(list.selectedItems.getItemAt(0)) : 0;			
			var selectedChild:IUIComponent = container.children[selectedIndex];
			var selectedLayoutItem:LayoutItem = new LayoutItem(selectedChild);
			var maxChildHeight:Number = selectedLayoutItem.preferredHeight;
			var maxChildWidth:Number = selectedLayoutItem.preferredWidth;	
			var horizontalGap:Number = direction == "horizontal" ? maxChildHeight / 3 : _distance;
			var verticalGap:Number = direction == "horizontal" ? _distance : maxChildWidth / 3;
			var abs:Number;
				
			container.animator.begin();
				
			for (var i:int = 0; i < container.children.length; i++) {
				var child:IUIComponent = container.children[i];
				var li:LayoutItem = new LayoutItem(child);
				var token:AnimationToken = new PlexiAnimationToken(li.preferredWidth, li.preferredHeight);
				
				abs = Math.abs(selectedIndex - i);
				
				if (direction == "horizontal") {
					token.x = selectedChild.width + ((abs - 1) * horizontalGap);
					if (_gap > 0) token.x += (abs - 1) * (_gap + li.preferredWidth);
					token.y = -(maxChildHeight - li.preferredHeight) / 2;
					token.z = selectedLayoutItem.preferredWidth + abs * verticalGap;
					token.rotationY = rotationAngle;
					
					if(i < selectedIndex) {
						token.x *= -1;
						token.rotationY *= -1;
					} else if(i == selectedIndex) {
						token.x = 0;
						token.z = -200 / 2;
						token.rotationY = 0;
					}
				} else {
					token.y = selectedChild.height + ((abs - 1) * verticalGap);
					if (_gap > 0) token.y += (abs - 1) * (_gap + li.preferredHeight);
					token.x = 0;
					token.z = selectedLayoutItem.preferredHeight + abs * horizontalGap; 
					token.rotationX = rotationAngle;
					token.rotationY = 0;
					
					if(i < selectedIndex) {
						token.y *= -1;
						token.rotationX *= -1;
					} else if(i == selectedIndex) {
						token.y = 0;
						token.z = 200 / 2; 
						token.rotationX = 0;
					}
				}
				
				container.animator.moveItem(child as DisplayObject, token);
			}
			
			container.animator.end();	
		}
		
	}
}