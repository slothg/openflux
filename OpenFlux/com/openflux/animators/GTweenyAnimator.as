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
			
			new FluxTweeny(item, time, token);
		}
		
		public function adjustItem(item:DisplayObject, token:AnimationToken):void {
			new FluxTweeny(item, time, token);
		}
		
		public function addItem(item:DisplayObject):void {
			item.alpha = 0;
		}
		
		public function removeItem(item:DisplayObject, callback:Function):void
		{
			var token:Object = new Object();
			token.time = 1/4;
			token.alpha = 0;
			
			new FluxTweeny(item, time, token, {completeListener: callback});
		}	
	}
}