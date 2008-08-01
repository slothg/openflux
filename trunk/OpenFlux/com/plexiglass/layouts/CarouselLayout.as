package com.plexiglass.layouts
{
	import com.openflux.animators.AnimationToken;
	import com.openflux.containers.IFluxContainer;
	import com.openflux.core.IFluxList;
	import com.openflux.core.IFluxView;
	import com.openflux.layouts.ILayout;
	import com.openflux.layouts.LayoutBase;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.events.ListEvent;
	
	public class CarouselLayout extends LayoutBase implements ILayout
	{		
		override public function attach(container:IFluxContainer):void
		{
			super.attach(container);
			UIComponent(container).callLater(attachComponent);
		}
		
		private function attachComponent():void
		{
			if ((container as IFluxView).component is IFluxList)
				(container as IFluxView).component.addEventListener(ListEvent.ITEM_CLICK, onChange);
		}
		
		override public function detach(container:IFluxContainer):void
		{
			super.detach(container);
			
			if ((container as IFluxView).component is IFluxList)
				(container as IFluxView).component.removeEventListener(ListEvent.ITEM_CLICK, onChange);
				
			//container.animator.moveItem(container["view"], {x:0, y:0});
		}
		
		private function onChange(event:ListEvent):void
		{
			container.invalidateDisplayList();
		}
		
		public function measure(children:Array):Point
		{
			return new Point();
		}
		
		public function update(children:Array, width:Number, height:Number):void {
			var numOfItems:int = container.children.length;		
			if(numOfItems == 0) return;
			
			//container.animator.moveItem(container["view"], {x:container.width / 2, y:container.height / 2});
			
			var list:IFluxList = (container as IFluxView).component as IFluxList;
			var selectedIndex:int = list && list.data && list.selectedItems && list.selectedItems.getItemAt(0) ? (list.data as ArrayCollection).getItemIndex(list.selectedItems.getItemAt(0)) : 0;
			var radius:Number = container.width;
			var anglePer:Number = (Math.PI * 2) / numOfItems;

			for(var i:uint=0; i<numOfItems; i++) {
				var child:IUIComponent = container.children[i];
				var token:AnimationToken = new AnimationToken(child.measuredWidth, child.measuredHeight)
				token.x = Math.sin((i-selectedIndex) * anglePer) * radius;
				token.y = 0;
				token.z = -(Math.cos((i-selectedIndex) * anglePer) * radius) + radius;
				token.rotationY = (-(i-selectedIndex) * anglePer) * (180 / Math.PI);
				container.animator.moveItem(child as DisplayObject, token);
			}
		}

	}
}