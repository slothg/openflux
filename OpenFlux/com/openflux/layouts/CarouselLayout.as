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
	
	public class CarouselLayout extends LayoutBase implements ILayout
	{		
		public function CarouselLayout() {
			super();
			updateOnChange = true;
		}
		
		public function measure(children:Array):Point
		{
			return new Point();
		}
		
		public function update(children:Array, rectangle:Rectangle):void {
			var numOfItems:int = children.length;			
			var list:IFluxList = (container as IFluxView).component as IFluxList;
			var selectedIndex:int = list ? Math.max(0, ListUtil.selectedIndex(list)) : 0;
			var radius:Number = rectangle.width - 10;
			var anglePer:Number = (Math.PI * 2) / numOfItems;

			var child:IUIComponent;
			var token:AnimationToken;

			for(var i:uint=0; i<numOfItems; i++) {
				child = children[i];
				token = new AnimationToken(child.getExplicitOrMeasuredWidth(), child.getExplicitOrMeasuredHeight());
				token.x = Math.sin((i-selectedIndex) * anglePer) * radius;
				token.z = -(Math.cos((i-selectedIndex) * anglePer) * radius) + radius;
				token.rotationY = (-(i-selectedIndex) * anglePer) * (180 / Math.PI);
				
				token.x = token.x + rectangle.width/2 - token.width/2;
				token.y = (token.y * -1) + rectangle.height / 2 - token.height / 2;
				animator.moveItem(child as DisplayObject, token);
			}
		}

	}
}