package com.openflux.animators
{
	import caurina.transitions.Tweener;
	
	import com.openflux.containers.IFluxContainer;
	
	import flash.display.DisplayObject;
	
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	
	/**
	 * An animator class which uses the Tweener library. This is the default animator provided by OpenFlux. 
	 */
	public class TweenAnimator implements IAnimator
	{
		
		//private var count:int = 0;
		
		static public const TRANSITION_LINEAR:String = "linear";
		static public const EASE_OUT_EXPO:String = "easeOutExpo";
		static public const EASE_OUT_BOUNCE:String = "easeOutBounce";
		
		protected var container:IFluxContainer;
		
		/**
		 * The duration of time used to animate a component.
		 */
		public var time:Number = 1;
		
		/**
		 * The transition path on which to animate a component.
		 */
		[StyleBinding] public var transition:String = EASE_OUT_BOUNCE;
		
		public function TweenAnimator() {
			Tweener.registerSpecialProperty("actualWidth", getActualWidth, setActualWidth);
			Tweener.registerSpecialProperty("actualHeight", getActualHeight, setActualHeight);
		}
		
		public function attach(container:IFluxContainer):void {
			this.container = container;
		}
		public function detach(container:IFluxContainer):void {
			this.container = null;
		}
		
		public function begin():void {} // unused
		public function end():void {} // unused
		
		public function moveItem(item:DisplayObject, token:AnimationToken):void {
			var parameters:Object = createTweenerParameters(token, time);
			if (item.alpha == 0) {
				var ui:IUIComponent = item as IUIComponent;
				ui.setActualSize(token.width, token.height);
				ui.move(token.x, token.y);
				parameters.alpha = 1;
			}
			
			Tweener.addTween(item, parameters);
		}
		
		public function adjustItem(item:DisplayObject, token:AnimationToken):void {
			var parameters:Object = createTweenerParameters(token, 1/3);
			//Tweener.addTween(item, parameters);
		}
		
		public function addItem(item:DisplayObject):void {
			item.alpha = 0;
		}
		
		public function removeItem(item:DisplayObject, callback:Function):void
		{
			var token:Object = new Object();
			token.time = 1/4;
			/*
			token.x = item.x + item.width/2;
			token.y = item.y + item.height/2;
			token.width = 100;
			token.height = 100;
			*/
			token.alpha = 0;
			token.onComplete = callback;
			token.onCompleteParams = [item];
			Tweener.addTween(item, token);
		}
		
		private function getActualWidth(item:IUIComponent, parameters:Array, ...args):Number { return item.width; }
		private function setActualWidth(item:UIComponent, value:Number, parameters:Array, ...args):void {
			item.setActualSize(value, item.height);
		}
		
		private function getActualHeight(item:IUIComponent, parameters:Array, ...args):Number { return item.height; }
		private function setActualHeight(item:IUIComponent, value:Number, parameters:Array, ...args):void {
			item.setActualSize(item.width, value);
		}
		
		private function createTweenerParameters(token:AnimationToken, time:Number = 1):Object {
			var parameters:Object = new Object();
			parameters.time = time;
			parameters.transition = transition;
			
			parameters.x = token.x;
			parameters.y = token.y;
			parameters.actualWidth = token.width;
			parameters.actualHeight = token.height;
			parameters.rotation = token.rotationY;
			//object.onComplete = onComplete;
			
			return parameters;
		}
		
	}
}