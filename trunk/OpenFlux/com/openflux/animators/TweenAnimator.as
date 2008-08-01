package com.openflux.animators
{
	import caurina.transitions.Tweener;
	
	import com.openflux.containers.IFluxContainer;
	
	import flash.display.DisplayObject;
	
	/**
	 * An animator class which uses the Tweener library. This is the default animator provided by OpenFlux. 
	 */
	public class TweenAnimator implements IAnimator
	{
		
		//private var count:int = 0;
		
		static public const TRANSITION_LINEAR:String = "linear";
		static public const EASE_OUT_EXPO:String = "easeOutExpo";
		static public const EASE_OUT_BOUNCE:String = "easeOutBounce";
		
		/**
		 * The duration of time used to animate a component.
		 */
		[StyleBinding] public var time:Number = 1;
		
		/**
		 * The transition path on which to animate a component.
		 */
		[StyleBinding] public var transition:String = EASE_OUT_EXPO;
		
		public function attach(container:IFluxContainer):void {}
		public function detach(container:IFluxContainer):void {}
		
		public function begin():void {} // unused
		public function end():void {} // unused
		
		public function moveItem(item:DisplayObject, token:AnimationToken):void
		{
			var parameters:Object = createTweenerParameters(token);
			Tweener.addTween(item, parameters);
			//count++;
		}
		/*
		public function addItem(item:Object, token:Object):void
		{
			moveItem(item, token);
		}
		
		public function removeItem(item:Object):void
		{
			var token:Object = new Object();
			token.x = item.width/2;
			token.y = item.width/2;
			token.width = 0;
			token.height = 0;
			moveItem(item, token);
		}
		*/
		// review for interface
		/*
		public function isAnimating():Boolean {
			return count > 0 ? true : false;
		}
		
		private function onComplete():void {
			count--;
		}
		*/
		
		private function createTweenerParameters(token:AnimationToken):Object {
			var parameters:Object = new Object();
			parameters.time = 1;
			parameters.transition = transition;
			
			parameters.x = token.x;
			parameters.y = token.y;
			parameters.width = token.width;
			parameters.height = token.height;
			parameters.rotation = token.rotationY;
			//object.onComplete = onComplete;
			return parameters;
		}
		
	}
}