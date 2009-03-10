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
	import com.openflux.containers.IFluxContainer;
	
	import flash.display.DisplayObject;
	
	import mx.core.IUIComponent;
	
	/**
	 * An animator class which uses the GTweeny library. This is the default animator provided by OpenFlux. 
	 */
	public class GTweenyAnimator implements IAnimator
	{			
		protected var container:IFluxContainer;
		
		private var tweens:Object = {};
		
		/**
		 * The duration of time used to animate a component.
		 */
		public var time:Number = 1;
				
		public function GTweenyAnimator() {
			super();
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
			if (item.alpha == 0) {
				var ui:IUIComponent = item as IUIComponent;
				ui.setActualSize(token.width, token.height);
				ui.move(token.x, token.y);
				token.alpha = 1;
			}
			
			new FluxTweeny(item, time, createTweenerParameters(token));
		}
		
		public function adjustItem(item:DisplayObject, token:AnimationToken):void {
			new FluxTweeny(item, time, createTweenerParameters(token));
		}
		
		public function addItem(item:DisplayObject):void {
			item.alpha = 0;
		}
		
		public function removeItem(item:DisplayObject, callback:Function):void
		{
			var token:Object = new Object();
			token.alpha = 0;
			
			new FluxTweeny(item, time, token, {completeListener: callback});
		}
		
		private function createTweenerParameters(token:AnimationToken):Object {
			var parameters:Object = new Object();
			parameters.x = token.x;
			parameters.y = token.y;
			parameters.z = token.z;
			parameters.rotationX = token.rotationX;
			parameters.rotationY = token.rotationY;
			parameters.rotationZ = token.rotationZ;
			parameters.width = token.width;
			parameters.height = token.height;
			parameters.alpha = token.alpha;
			return parameters;
		}
	}
}