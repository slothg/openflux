package com.plexiglass.animators
{
	import away3d.primitives.Plane;
	
	import caurina.transitions.Tweener;
	
	import com.openflux.animators.IAnimator;
	import com.openflux.containers.IFluxContainer;
	import com.plexiglass.containers.IPlexiContainer;
	
	import mx.core.UIComponent;

	public class PlexiAnimator implements IAnimator
	{
		
		public var time:Number = 1;
		public var transition:String = "easeInOutCirc";
		
		private var container:IFluxContainer;
		
		public function PlexiAnimator()
		{
			super();
		}
		
		public function attach(container:IFluxContainer):void {
			this.container = container;
		}
		
		public function detach(layout:IFluxContainer):void {
			this.container = null;
		}
		
		public function begin():void {} // unused
		public function end():void {} // unused
		
		public function moveItem(item:Object, token:Object):void
		{
			token.time = time;
			token.transition = transition;
			if(container is IPlexiContainer) {
				var token3d:Object = new Object();
				token3d.x = token.x + item.width/2;
				token3d.y = (token.y + item.height/2) * -1;
				//token3d.z = token.z ? token.z : getDepth(item as DisplayObject)/100;
				
				token3d.rotationZ = token.rotation ? token.rotation : 0;
				token3d.rotationX = token.rotationX ? token.rotationX : 0;
				token3d.rotationY = token.rotationY ? token.rotationY : 0;
				token3d.rotationZ = token.rotationZ ? token.rotationZ : 0;
				
				token3d.time = token.time;
				token3d.transition = transition;
				
				var pv:IPlexiContainer = container as IPlexiContainer;
				var plane:Plane = pv.getChildPlane(item as UIComponent);
				if (plane) {
					Tweener.addTween(plane, token3d);
				}
			}
			
		}
		
	}
}