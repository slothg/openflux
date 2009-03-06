package com.openflux.animators
{
	import com.gskinner.motion.GTweeny;
	
	import mx.core.IFlexDisplayObject;

	public class FluxTweeny extends GTweeny
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
}