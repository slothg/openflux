package com.openflux.layouts
{
	import com.openflux.core.IFluxList;
	import com.openflux.core.IFluxView;
	import com.openflux.utils.ListUtil;
	import com.plexiglass.animators.PlexiAnimationToken;
	
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
			
			var child:DisplayObject;
			var layoutItem:ILayoutItem;
			var token:PlexiAnimationToken;
			
			for (var i:int = 0; i < children.length; i++) {
				child = children[i] as DisplayObject;
				layoutItem = new LayoutItem(child as IUIComponent);
				token = new PlexiAnimationToken(layoutItem.preferredWidth, layoutItem.preferredHeight);
				if (i > selectedIndex) {
					token.x = -(gap * (selectedIndex - i));
					token.z = -(gap * (selectedIndex - i));
				} else if (i == selectedIndex) {
					token.rotationZ = -40;
					token.x = layoutItem.preferredWidth + gap;
				} else if (i < selectedIndex) {
					token.x = gap * (i - selectedIndex);
					token.z = gap * (i - selectedIndex);
				}
				
				container.animator.moveItem(child, token);
			}
			
			container.animator.end();
		}
		
	}
}