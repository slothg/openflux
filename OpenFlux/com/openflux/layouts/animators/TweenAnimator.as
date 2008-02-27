package com.openflux.layouts.animators
{
	import caurina.transitions.Tweener;
	
	import com.openflux.core.IDataView;
	
	public class TweenAnimator implements ILayoutAnimator
	{
		
		static public const TRANSITION_LINEAR:String = "linear";
		
		public var time:Number = 1;
		public var transition:String = "linear";
		
		public function attach(container:IDataView):void {}
		public function detach(container:IDataView):void {}
		
		public function startMove():void {} // later
		public function stopMove():void {} // later
		
		public function moveItem(item:Object, token:Object):void
		{
			token.time = time;
			//token.transition = transition;
			Tweener.addTween(item, token);
		}
		
		public function addItem(item:Object, token:Object):void
		{
			
		}
		
		public function removeItem(item:Object):void
		{

		}
		
	}
}