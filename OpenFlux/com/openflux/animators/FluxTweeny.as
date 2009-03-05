package com.openflux.animators
{
	import com.gskinner.motion.GTweeny;
	
	import mx.core.IFlexDisplayObject;

	public class FluxTweeny extends GTweeny
	{
		public function FluxTweeny(target:Object=null, duration:Number=10, properties:Object=null, tweenProperties:Object=null)
		{
			super(target, duration, properties, tweenProperties);
		}
		
		override public function setProperty(name:String, value:Number):void
		{
			if (name == "width" && target is IFlexDisplayObject) {
				IFlexDisplayObject(target).setActualSize(value, target.height);
			} else if (name == "height" && target is IFlexDisplayObject) {
				IFlexDisplayObject(target).setActualSize(target.width, value);
			} else {
				super.setProperty(name, value);
			}
		}
		
	}
}