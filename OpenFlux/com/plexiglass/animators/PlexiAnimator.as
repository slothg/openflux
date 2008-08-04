package com.plexiglass.animators
{
	import away3d.primitives.Plane;
	
	import caurina.transitions.Tweener;
	
	import com.openflux.animators.AnimationToken;
	import com.openflux.animators.IAnimator;
	import com.openflux.containers.IFluxContainer;
	import com.plexiglass.containers.IPlexiContainer;
	
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;

	public class PlexiAnimator implements IAnimator
	{
		public var time:Number = 1;
		public var transition:String = "easeInOutCirc";
		
		private var container:IFluxContainer;
		private var known:Dictionary = new Dictionary(true);
		
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
		
		public function moveItem(item:DisplayObject, token:AnimationToken):void {
			if(container is IPlexiContainer && item != container["view"] && item is DisplayObject) {
				var parameters3d:Object = createTweenParameters3d(item, token, 1);
				var pv:IPlexiContainer = container as IPlexiContainer;
				var plane:Plane = pv.getChildPlane(item as UIComponent);
				if (plane) {
						Tweener.addTween(plane, parameters3d);
				}
			} else {
				var parameters:Object = createTweenParameters(token, 1);
				Tweener.addTween(item, token);
			}
		}
		
		public function addItem(item:DisplayObject):void {};
		public function removeItem(item:DisplayObject, callback:Function):void {
			callback(item);
		}
		
		public function adjustItem(item:DisplayObject, token:AnimationToken):void {
			if(container is IPlexiContainer && item != container["view"] && item is DisplayObject) {
				var parameters3d:Object = createTweenParameters3d(item, token, 1/3);
				var pv:IPlexiContainer = container as IPlexiContainer;
				var plane:Plane = pv.getChildPlane(item as UIComponent);
				if (plane) {
						Tweener.addTween(plane, parameters3d);
				}
			} else {
				var parameters:Object = createTweenParameters(token, 1/3);
				Tweener.addTween(item, token);
			}
		}
		
		private function createTweenParameters3d(item:DisplayObject, token:AnimationToken, time:Number):Object {
			var parameters:Object = new Object();
			
			parameters.time = token.time;
			parameters.transition = transition;
			
			parameters.x = token.x + item.width/2;
			parameters.y = (token.y + item.height/2) * -1;
			parameters.z = token.z ? token.z : 0; //getDepth(item as DisplayObject)/100;
			
			parameters.rotationX = token.rotationX ? token.rotationX : 0;
			parameters.rotationY = token.rotationY ? token.rotationY : 0;
			parameters.rotationZ = token.rotationZ ? token.rotationZ : 0;
			return parameters;
		}
		
		private function createTweenParameters(token:AnimationToken, time:Number = 1):Object {
			var parameters:Object = new Object();
			parameters.time = time;
			parameters.transition = transition;
			parameters.x = token.x;
			parameters.y = token.y;
			parameters.width = token.width;
			parameters.height = token.height;
			return parameters;
		}
		
	}
}