package com.openflux.layouts
{
	import com.openflux.animators.AnimationToken;
	import com.openflux.core.IFluxList;
	import com.openflux.core.IFluxView;
	import com.openflux.utils.ListUtil;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IUIComponent;

	public class TimeMachineLayout extends LayoutBase implements ILayout
	{
		public function TimeMachineLayout()
		{
			super();
			updateOnChange = true;
		}
		
		private var _gap:Number = 10;
		[Bindable]
		public function get gap():Number { return _gap; }
		public function set gap(value:Number):void {
			_gap = value;
			if (container) container.invalidateDisplayList();
		}
		
		public function measure(children:Array):Point
		{
			return new Point();
		}
		
		public function update(children:Array, rectangle:Rectangle):void
		{
			var list:IFluxList = (container as IFluxView).component as IFluxList;
			var selectedIndex:int = list ? Math.max(0, ListUtil.selectedIndex(list)) : 0;
			var selectedChild:DisplayObject = children[selectedIndex];
			
			container.animator.begin();
			
			var child:IUIComponent;
			var token:AnimationToken;
			
			for (var i:int = 0; i < children.length; i++) {
				child = children[i];
				token = new AnimationToken(child.getExplicitOrMeasuredWidth(), child.getExplicitOrMeasuredHeight());
				if (i > selectedIndex) {
					token.x = -(gap * (selectedIndex - i));
					token.z = -(gap * (selectedIndex - i));
				} else if (i == selectedIndex) {
					token.rotationZ = -40;
					token.x = token.width + gap;
				} else if (i < selectedIndex) {
					token.x = gap * (i - selectedIndex);
					token.z = gap * (i - selectedIndex);
				}
				
				token.x = token.x + rectangle.width/2 - token.width/2;
				token.y = (token.y*-1) + rectangle.height/2 + token.height/2;
				container.animator.moveItem(child as DisplayObject, token);
			}
			
			container.animator.end();
		}
		
	}
}