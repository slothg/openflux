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

	public class TopLeftLayout extends LayoutBase implements ILayout
	{
		public function TopLeftLayout()
		{
			super();
			updateOnChange = true;
		}
		
		public function measure(children:Array):Point
		{
			return new Point();
		}
		
		public function update(children:Array, rectangle:Rectangle):void
		{
			var numItems:int = children.length;			
			var list:IFluxList = (container as IFluxView).component as IFluxList;
			var selectedIndex:int = list ? Math.max(0, ListUtil.selectedIndex(list)) : 0;
			var radius:Number = rectangle.height;
			var anglePer:Number = Math.PI / numItems;
			
			container.animator.begin();
			
			var child:DisplayObject;
			var layoutItem:ILayoutItem;
			var token:PlexiAnimationToken;
			
			for (var i:int = 0; i < numItems; i++) {
				child = children[i];
				layoutItem = new LayoutItem(child as IUIComponent);
				token = new PlexiAnimationToken(layoutItem.preferredWidth, layoutItem.preferredHeight);
				if (i == selectedIndex) {
					token.y = rectangle.height / 2 - 100;
					token.x = -1 * rectangle.width / 2 + 100;
					token.z = -1 * 2 * numItems;
				} else {
					token.y = Math.cos((i - selectedIndex) * anglePer) * radius - rectangle.height;
					token.x = Math.sin((i - selectedIndex) * anglePer) * radius;
					token.z = 2 * i - 100;
				}
				
				if (i < selectedIndex)
					token.x += layoutItem.preferredWidth;
				
				container.animator.moveItem(child, token);
			}
			
			container.animator.end();
		}
		
	}
}