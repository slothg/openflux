package com.plexiglass.layouts
{
	import com.openflux.containers.IFluxContainer;
	import com.openflux.core.IFluxList;
	import com.openflux.core.IFluxView;
	import com.openflux.layouts.ILayout;
	import com.openflux.layouts.LayoutBase;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.events.ListEvent;
	import mx.utils.ObjectUtil;
	
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
		}
		
		private function onChange(event:ListEvent):void
		{
			container.invalidateLayout();
		}
		
		public function measure():Point
		{
			return new Point();
		}
		
		public function update(indices:Array = null):void {
			var numOfItems:int = container.children.length;		
			if(numOfItems == 0) return;
			
			var list:IFluxList = (container as IFluxView).component as IFluxList;
			var selectedIndex:int = list && list.dataProvider && list.selectedItems && list.selectedItems.getItemAt(0) ? (list.dataProvider as ArrayCollection).getItemIndex(list.selectedItems.getItemAt(0)) : 0;
			var radius:Number = container.width;
			var anglePer:Number = (Math.PI * 2) / numOfItems;

			for(var i:uint=0; i<numOfItems; i++) {
				var child:DisplayObject = container.children[i];
				var zPosition:Number = -(Math.cos((i-selectedIndex) * anglePer) * radius) + radius;
				var xPosition:Number = Math.sin((i-selectedIndex) * anglePer) * radius;
				var yRotation:Number = (-(i-selectedIndex) * anglePer) * (180 / Math.PI);
				
				container.animator.moveItem(child, {x:xPosition, y:0, z:zPosition, rotationY:yRotation});
			}
		}

	}
}