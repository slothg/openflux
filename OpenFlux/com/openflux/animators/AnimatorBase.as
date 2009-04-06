package com.openflux.animators
{
	import com.openflux.containers.IFluxContainer;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * Animator Base
	 */
	public class AnimatorBase extends EventDispatcher
	{
		private var tokens:Array;
		private var tokenItem:Dictionary;
		
		protected var container:IFluxContainer;
		
		/**
		 * Constructor
		 */
		public function AnimatorBase()
		{
			super();
		}
		
		// ========================================
		// time property
		// ========================================
		
		/**
		 * The duration of time used to animate a component.
		 */
		public var time:Number = 1;
		
		// ========================================
		// IAnimator implementation
		// ========================================
		
		public function attach(container:IFluxContainer):void {
			this.container = container;
		}
		public function detach(container:IFluxContainer):void {
			this.container = null;
		}
		
		public function begin():void {
			tokens = [];
			tokenItem = new Dictionary();
		}
		
		public function end():void {
			tokens.sortOn("z", Array.DESCENDING | Array.NUMERIC);
			
			for (var i:int = tokens.length - 1; i >= 0; i--) {
				DisplayObjectContainer(container).setChildIndex(tokenItem[tokens[i]] as DisplayObject, i);
			}
		}
		
		public function moveItem(item:DisplayObject, token:AnimationToken):void {
			doMove(item, createTweenerParameters(token));
			tokens.push(token);
			tokenItem[token] = item;
		}
		
		public function adjustItem(item:DisplayObject, token:AnimationToken):void {
			moveItem(item, token);
		}
		
		public function addItem(item:DisplayObject):void {
		}
		
		public function removeItem(item:DisplayObject, callback:Function):void {
			callback(item);
		}
		
		// ========================================
		// protected methods
		// ========================================
		
		protected function createTweenerParameters(token:AnimationToken):Object {
			var parameters:Object = new Object();
			parameters.x = token.x;
			parameters.y = token.y;
			parameters.z = token.z;
			parameters.rotationX = token.rotationX;
			parameters.rotationY = token.rotationY;
			parameters.rotationZ = token.rotationZ;
			parameters.width = token.width;
			parameters.height = token.height;
			//parameters.alpha = token.alpha;
			return parameters;
		}
		
		protected function doMove(item:DisplayObject, parameters:Object):void {
			for (var param:String in parameters) {
				item[param] = parameters[param];
			}
		}
		
	}
}