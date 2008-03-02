package com.openflux.layouts.animators
{
	import caurina.transitions.Tweener;
	
	import com.openflux.core.IDataView;
	
	public class TweenAnimator implements ILayoutAnimator
	{
		
		private var count:int = 0;
		
		static public const TRANSITION_LINEAR:String = "linear";
		
		public var time:Number = 2;
		public var transition:String = "easeInOutCirc";
		
		public function attach(container:IDataView):void {}
		public function detach(container:IDataView):void {}
		
		public function startMove():void {} // later
		public function stopMove():void {} // later
		
		public function moveItem(item:Object, token:Object):void
		{
			token.time = time;
			token.transition = transition;
			token.onComplete = onComplete;
			Tweener.addTween(item, token);
			count++;
		}
		
		public function addItem(item:Object, token:Object):void
		{
			
		}
		
		public function removeItem(item:Object):void
		{

		}
		
		public function isAnimating():Boolean {
			return count > 0 ? true : false;
		}
		
		private function onComplete():void {
			count--;
		}
		
	}
}