package com.plexiglass.layouts
{
	import com.openflux.animators.AnimationToken;
	import com.openflux.containers.IFluxContainer;
	import com.openflux.layouts.ILayout;
	import com.openflux.layouts.LayoutBase;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import mx.core.IUIComponent;
	
	public class SpiralLayout extends LayoutBase implements ILayout
	{
		public function measure(children:Array):Point
		{
			return new Point();
		}
		
		override public function detach(container:IFluxContainer):void
		{
			super.detach(container);
			//container.animator.moveItem(container["view"], {x:0, y:0});
		}
		
		public function update(children:Array, width:Number, height:Number):void {
			var numOfItems:int = container.children.length;		
			if(numOfItems == 0) return;
			
			//container.animator.moveItem(container["view"], {x:container.width / 2, y:container.height / 2});
			
			var radius:Number = Math.min(width, height);
			var rotations:Number = 5;
			var angle:Number = ((Math.PI * 2) * rotations) / numOfItems;
			var zPos:Number = 0;
			
			for(var i:uint=0; i<numOfItems; i++) {
				var child:IUIComponent = container.children[i];
				var token:AnimationToken = new AnimationToken(child.measuredWidth, child.measuredHeight);
				token.x = Math.cos(i * angle) * radius;
                token.y = Math.sin(i * angle) * radius;
                token.z = zPos += 50;
                
				container.animator.moveItem(child as DisplayObject, token);
			}
		}

	}
}