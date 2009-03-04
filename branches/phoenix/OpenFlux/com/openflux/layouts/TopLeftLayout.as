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

	/**
	 * 3D Layout similar to a roller coaster look. Selected item is displayed in the top left
	 */
	public class TopLeftLayout extends LayoutBase implements ILayout
	{
		/**
		 * Constructor
		 */
		public function TopLeftLayout()
		{
			super();
			updateOnChange = true;
		}
		
		// ========================================
		// ILayout implementation
		// ========================================
		
		public function measure(children:Array):Point {
			// TODO: Complete me
			return new Point();
		}
		
		public function update(children:Array, rectangle:Rectangle):void {
			var numItems:int = children.length;			
			var list:IFluxList = (container as IFluxView).component as IFluxList;
			var selectedIndex:int = list ? Math.max(0, ListUtil.selectedIndex(list)) : 0;
			var radius:Number = rectangle.height;
			var anglePer:Number = Math.PI / numItems;
			var child:IUIComponent;
			var token:AnimationToken;
						
			container.animator.begin();
			
			for (var i:int = 0; i < numItems; i++) {
				child = children[i];
				token = new AnimationToken(child.getExplicitOrMeasuredWidth(), child.getExplicitOrMeasuredHeight());
				
				if (i == selectedIndex) {
					token.y = rectangle.height / 2 - 100;
					token.x = -1 * rectangle.width / 2 + 100;
					token.z = -1 * 2 * numItems;
				} else {
					token.y = Math.cos((i - selectedIndex) * anglePer) * radius - rectangle.height;
					token.x = Math.sin((i - selectedIndex) * anglePer) * radius;
					token.z = 2 * i - 100;
				}
				
				if (i < selectedIndex) {
					token.x += token.width;
				}
				
				token.x = token.x + rectangle.width/2 - token.width/2;
				token.y = (token.y*-1) + rectangle.height/2 - token.height/2;
				container.animator.moveItem(child as DisplayObject, token);
			}
			
			container.animator.end();
		}
		
	}
}