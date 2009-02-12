package com.openflux.managers
{
	import flash.events.MouseEvent;
	import mx.core.DragSource;
	import mx.managers.IDragManager;
	import mx.core.IUIComponent;
	import mx.core.IFlexDisplayObject;

	public class DragManager implements IDragManager
	{
		public function DragManager()
		{
		}

		public function get isDragging():Boolean { return false; }
		
		public function doDrag(dragInitiator:IUIComponent, dragSource:DragSource, mouseEvent:MouseEvent, dragImage:IFlexDisplayObject=null, xOffset:Number=0, yOffset:Number=0, imageAlpha:Number=0, allowMove:Boolean=true):void {}
		
		public function acceptDragDrop(target:IUIComponent):void {}
		
		public function showFeedback(feedback:String):void {}
		
		public function getFeedback():String { return null; }
		
		public function endDrag():void {}
		
	}
}