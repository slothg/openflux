package com.plexiglass.layouts
{
	import com.openflux.containers.IFluxContainer;
	import com.openflux.layouts.ILayout;
	import com.openflux.layouts.LayoutBase;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	public class SpiralLayout extends LayoutBase implements ILayout
	{
		public function measure():Point
		{
			return new Point();
		}
		
		override public function detach(container:IFluxContainer):void
		{
			super.detach(container);
			container.animator.moveItem(container["view"], {x:0, y:0});
		}
		
		public function update(indices:Array = null):void {
			var numOfItems:int = container.children.length;		
			if(numOfItems == 0) return;
			
			container.animator.moveItem(container["view"], {x:container.width / 2, y:container.height / 2});
			
			var radius:Number = Math.min(container.width, container.height);
			var rotations:Number = 5;
			var angle:Number = ((Math.PI * 2) * rotations) / numOfItems;
			var zPos:Number = 0;
			
			for(var i:uint=0; i<numOfItems; i++) {
				var child:DisplayObject = container.children[i];
				
				var x:Number = Math.cos(i * angle) * radius;
                var y:Number = Math.sin(i * angle) * radius;
                var z:Number = zPos += 50;

				container.animator.moveItem(child, {x:x, y:y, z:z});
			}
		}

	}
}