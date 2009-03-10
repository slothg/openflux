// =================================================================
//
// Copyright (c) 2009 The OpenFlux Team http://www.openflux.org
// 
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// =================================================================

package com.openflux.animators
{
	import caurina.transitions.Tweener;

	import com.openflux.containers.IFluxContainer;
	
	import flash.display.DisplayObject;
	
	import mx.core.IUIComponent;
	
	/**
	 * An animator class which uses the Tweener library.
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
		public var time:Number = 1000;
		
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
			Tweener.addTween(item, parameters);
		}
		
		public function addItem(item:DisplayObject):void {
			item.alpha = 0;
		}
		
		public function removeItem(item:DisplayObject, callback:Function):void
		{
			var token:Object = new Object();
			token.time = 1/4;
			token.alpha = 0;
			token.onComplete = callback;
			token.onCompleteParams = [item];
			
			Tweener.addTween(item, token);
		}
		
		private function getActualWidth(item:IUIComponent, parameters:Array, ...args):Number { return item.width; }
		private function setActualWidth(item:IUIComponent, value:Number, parameters:Array, ...args):void {
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
			parameters.z = token.z;
			parameters.rotationX = token.rotationX;
			parameters.rotationY = token.rotationY;
			parameters.rotationZ = token.rotationZ;
			parameters.actualWidth = token.width;
			parameters.actualHeight = token.height;
			//object.onComplete = onComplete;
			
			return parameters;
		}
		
	}
}