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
	import flash.display.DisplayObject;
	
	/**
	 * An animator class which uses the GTweeny library. This is the default animator provided by OpenFlux. 
	 */
	public class GTweenyAnimator extends AnimatorBase implements IAnimator
	{				
		public function GTweenyAnimator() {
			super();
		}
		
		override protected function doMove(item:DisplayObject, parameters:Object):void {
			new FluxTweeny(item, time, parameters, {autoVisible:false});
		}
	}
}

import com.gskinner.motion.GTweeny;

import mx.core.IFlexDisplayObject;

class FluxTweeny extends GTweeny
{
	public function FluxTweeny(target:Object=null, duration:Number=10, properties:Object=null, tweenProperties:Object=null) {
		super(target, duration, properties, tweenProperties);
	}
	
	override protected function updateProperty(property:String, startValue:Number, endValue:Number, tweenRatio:Number):void {
		var value:Number = startValue+(endValue-startValue)*tweenRatio;
		
		if (property == "width" && target is IFlexDisplayObject) {
			IFlexDisplayObject(target).setActualSize(value, target.height);
		} else if (property == "height" && target is IFlexDisplayObject) {
			IFlexDisplayObject(target).setActualSize(target.width, value);
		} else {
			super.updateProperty(property, startValue, endValue, tweenRatio);
		}
	}
}