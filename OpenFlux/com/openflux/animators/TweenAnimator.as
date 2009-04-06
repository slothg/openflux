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
	
	import flash.display.DisplayObject;
	
	import mx.core.IUIComponent;
	
	/**
	 * An animator class which uses the Tweener library.
	 */
	public class TweenAnimator extends AnimatorBase implements IAnimator
	{
		static public const TRANSITION_LINEAR:String = "linear";
		static public const EASE_OUT_EXPO:String = "easeOutExpo";
		static public const EASE_OUT_BOUNCE:String = "easeOutBounce";

		public function TweenAnimator() {
			Tweener.registerSpecialProperty("width", getActualWidth, setActualWidth);
			Tweener.registerSpecialProperty("height", getActualHeight, setActualHeight);
		}

		/**
		 * The transition path on which to animate a component.
		 */
		public var transition:String = EASE_OUT_BOUNCE;
				
		private function getActualWidth(item:IUIComponent, parameters:Array, ...args):Number { return item.width; }
		private function setActualWidth(item:IUIComponent, value:Number, parameters:Array, ...args):void {
			item.setActualSize(value, item.height);
		}
		
		private function getActualHeight(item:IUIComponent, parameters:Array, ...args):Number { return item.height; }
		private function setActualHeight(item:IUIComponent, value:Number, parameters:Array, ...args):void {
			item.setActualSize(item.width, value);
		}
		
		override protected function createTweenerParameters(token:AnimationToken):Object {
			var parameters:Object = super.createTweenerParameters(token);
			parameters.time = time;
			parameters.transition = transition;
			return parameters;
		}
		
		override protected function doMove(item:DisplayObject, parameters:Object):void {
			Tweener.addTween(item, parameters);
		}
		
	}
}