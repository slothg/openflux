package com.openflux.controllers
{
	import com.openflux.core.FluxController;
	import com.openflux.core.IFluxComponent;
	import com.openflux.core.IScrollBar;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	import mx.events.ScrollEvent;
	import mx.events.ScrollEventDetail;
	
	public class ScrollBarController extends FluxController
	{
		private var sdata:IScrollBar;
		private var edata:IEventDispatcher;
		
		private var arrowDirection:int;
		private var arrowTimer:Timer;
		
		private var trackScrollDirection:int;
		private var trackScrollTimer:Timer;
		private var trackScrollPosition:Number;
		
		private var view:UIComponent;
		
		private static const LINE_SCROLL_SIZE:Number = 1;
		private static const PAGE_SCROLL_SIZE:Number = 40;
		
		override public function set data(value:IFluxComponent):void {
			super.data = value;
			if (value is IScrollBar) {
				sdata = value as IScrollBar;
			}
			if (value is IEventDispatcher) {
				edata = value as IEventDispatcher;
			}
		}
		
		override protected function addEventListeners(view:IEventDispatcher):void {
			super.addEventListeners(view);		
			if (view["upArrow"] != null) {
				view["upArrow"].addEventListener(MouseEvent.MOUSE_DOWN, upArrowMouseDownHandler);
			}
			if (view["downArrow"] != null) {
				view["downArrow"].addEventListener(MouseEvent.MOUSE_DOWN, downArrowMouseDownHandler);
			}
			if (view["thumb"] != null) {
				view["thumb"].addEventListener(MouseEvent.MOUSE_DOWN, thumbMouseDownHandler);
			}
			if (view["track"] != null) {
				view["track"].addEventListener(MouseEvent.MOUSE_DOWN, trackMouseDownHandler);
			}
			this.view = view as UIComponent;
		}
		
		override protected function removeEventListeners(view:IEventDispatcher):void {
			super.removeEventListeners(view);
			if (view["upArrow"] != null) {
				view["upArrow"].removeEventListener(MouseEvent.MOUSE_DOWN, upArrowMouseDownHandler);
			}
			if (view["downArrow"] != null) {
				view["downArrow"].removeEventListener(MouseEvent.MOUSE_DOWN, downArrowMouseDownHandler);
			}
			if (view["thumb"] != null) {
				view["thumb"].removeEventListener(MouseEvent.MOUSE_DOWN, thumbMouseDownHandler);
			}
			if (view["track"] != null) {
				view["track"].removeEventListener(MouseEvent.MOUSE_DOWN, trackMouseDownHandler);
			}
			this.view = null;
		}
		
		/******************************
		 * Arrow Event Handlers
		 ******************************/
		
		private function upArrowMouseDownHandler(event:MouseEvent):void {
			arrowPress(event, -1);
		}
		
		private function downArrowMouseDownHandler(event:MouseEvent):void {
			arrowPress(event, 1);
		}
		
		private function arrowPress(event:MouseEvent, direction:Number):void {
			arrowDirection = direction;
			
			if (!arrowTimer) {
				arrowTimer = new Timer(1);
				arrowTimer.addEventListener(TimerEvent.TIMER, arrowTimerHandler);
			}
			
			event.target.addEventListener(MouseEvent.MOUSE_OUT, arrowMouseOutHandler);
			event.target.addEventListener(MouseEvent.MOUSE_OVER, arrowMouseOverHandler);
			view.systemManager.addEventListener(MouseEvent.MOUSE_UP, arrowMouseUpHandler, true);
			view.systemManager.stage.addEventListener(Event.MOUSE_LEAVE, arrowMouseLeaveHandler);
			
			arrowTimer.start();
		}
		
		private function arrowMouseOutHandler(event:MouseEvent):void {
			if (arrowTimer) arrowTimer.stop();
		}
		
		private function arrowMouseOverHandler(event:MouseEvent):void {
			if (arrowTimer) arrowTimer.start();
		}
		
		private function arrowMouseUpHandler(event:MouseEvent):void {
			arrowMouseLeaveHandler(event);
		}
		
		private function arrowMouseLeaveHandler(event:Event):void
		{
			if (arrowTimer) arrowTimer.stop();
			
			var arrow:Object = arrowDirection == -1 ? view["upArrow"] : view["downArrow"];
			arrow.removeEventListener(MouseEvent.MOUSE_OUT, arrowMouseOutHandler);
			arrow.removeEventListener(MouseEvent.MOUSE_OVER, arrowMouseOverHandler);
			view.systemManager.removeEventListener(MouseEvent.MOUSE_UP, arrowMouseUpHandler, true);
			view.systemManager.stage.removeEventListener(Event.MOUSE_LEAVE, arrowMouseLeaveHandler);
		}
			
		private function arrowTimerHandler(event:TimerEvent):void {
			var oldPosition:Number = sdata.position;
			sdata.position = sdata.position + arrowDirection * LINE_SCROLL_SIZE;
			dispatchScrollEvent(oldPosition, arrowDirection > 0 ? ScrollEventDetail.LINE_DOWN : ScrollEventDetail.LINE_UP);
		}
		
		/******************************
		 * Track Event Handlers
		 ******************************/
		
		private function trackMouseDownHandler(event:MouseEvent):void {

			if (view["trackShape"].width < view["trackShape"].height) {
				trackScrollPosition = event.localY / view["trackShape"].height * (sdata.max - sdata.min);
			} else {
				trackScrollPosition = event.localX / view["trackShape"].width * (sdata.max - sdata.min);
			}

			trackScrollDirection = trackScrollPosition < sdata.position ? -1 : trackScrollPosition > sdata.position ? 1 : 0;
			
			if (!trackScrollTimer) {
				trackScrollTimer = new Timer(1);
				trackScrollTimer.addEventListener(TimerEvent.TIMER, trackScrollTimerHandler);
			}
			
			trackScrollTimer.start();
			
			view["track"].addEventListener(MouseEvent.MOUSE_OUT, trackMouseOutHandler);
			view["track"].addEventListener(MouseEvent.MOUSE_OVER, trackMouseOverHandler);
			view.systemManager.addEventListener(MouseEvent.MOUSE_UP, trackMouseUpHandler, true);
			view.systemManager.addEventListener(MouseEvent.MOUSE_MOVE, trackMouseMoveHandler, true);
			view.systemManager.stage.addEventListener(MouseEvent.MOUSE_MOVE, trackStageMouseMoveHandler);
			view.systemManager.stage.addEventListener(Event.MOUSE_LEAVE, trackMouseLeaveHandler);
		}
		
		private function trackMouseUpHandler(event:MouseEvent):void {
			trackMouseLeaveHandler(event);
		}
		
		private function trackMouseLeaveHandler(event:Event):void {
			view["track"].removeEventListener(MouseEvent.MOUSE_OUT, trackMouseOutHandler);
			view["track"].removeEventListener(MouseEvent.MOUSE_OVER, trackMouseOverHandler);
			view.systemManager.removeEventListener(MouseEvent.MOUSE_UP, trackMouseUpHandler, true);
			view.systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, trackMouseMoveHandler, true);
			view.systemManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE, trackStageMouseMoveHandler);
			view.systemManager.stage.removeEventListener(Event.MOUSE_LEAVE, trackMouseLeaveHandler);
			
			if (trackScrollTimer) trackScrollTimer.stop();
		}
		
		private function trackMouseMoveHandler(event:MouseEvent):void {
			var pt:Point = new Point(event.stageX, event.stageY);
			pt = view["track"].globalToLocal(pt);
			
			if (view["trackShape"].width < view["trackShape"].height) {
				trackScrollPosition = pt.y / view["trackShape"].height * (sdata.max - sdata.min);
			} else {
				trackScrollPosition = pt.x / view["trackShape"].width * (sdata.max - sdata.min);
			}
			
			trackScrollDirection = trackScrollPosition < sdata.position ? -1 : trackScrollPosition > sdata.position ? 1 : 0;
		}
		
		private function trackStageMouseMoveHandler(event:MouseEvent):void {
			if (event.target == view.stage) trackMouseMoveHandler(event);
		}
		
		private function trackMouseOutHandler(event:MouseEvent):void {
			if (trackScrollTimer) trackScrollTimer.stop();
		}
		
		private function trackMouseOverHandler(event:MouseEvent):void {
			if (trackScrollTimer) trackScrollTimer.start();
		}
		
		private function trackScrollTimerHandler(event:TimerEvent):void {
			if (trackScrollDirection == -1 && trackScrollPosition >= sdata.position || 
				trackScrollDirection == 1 && trackScrollPosition <= sdata.position)
				return;
			
			var oldPosition:Number = sdata.position;
			sdata.position = sdata.position + trackScrollDirection * PAGE_SCROLL_SIZE;
			dispatchScrollEvent(oldPosition, trackScrollDirection > 0 ? ScrollEventDetail.PAGE_DOWN : ScrollEventDetail.PAGE_UP);
		}
		
		/******************************
		 * Thumb Event Handlers
		 ******************************/
		
		private function thumbMouseDownHandler(event:MouseEvent):void {
			view.systemManager.addEventListener(MouseEvent.MOUSE_MOVE, thumbMouseMoveHandler, true);
			view.systemManager.addEventListener(MouseEvent.MOUSE_UP, thumbMouseUpHandler, true);
			view.systemManager.stage.addEventListener(MouseEvent.MOUSE_MOVE, thumbStageMouseMoveHandler);
			view.systemManager.stage.addEventListener(MouseEvent.MOUSE_UP, thumbStageMouseUpHandler);
		}
		
		private function thumbMouseUpHandler(event:MouseEvent):void {
			view.systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, thumbMouseMoveHandler, true);
			view.systemManager.removeEventListener(MouseEvent.MOUSE_UP, thumbMouseUpHandler, true);
			view.systemManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE, thumbStageMouseMoveHandler);
			view.systemManager.stage.removeEventListener(MouseEvent.MOUSE_UP, thumbStageMouseUpHandler);
		}
		
		private function thumbMouseMoveHandler(event:MouseEvent):void {
			var pt:Point = new Point(event.stageX, event.stageY);
			pt = view["track"].globalToLocal(pt);
			
			if (view["trackShape"].width < view["trackShape"].height) {
				sdata.position = (pt.y - 16) / view["trackShape"].height * (sdata.max - sdata.min);
			} else {
				sdata.position = (pt.x - 16) / view["trackShape"].width * (sdata.max - sdata.min);
			}
		}
		
		private function thumbStageMouseMoveHandler(event:MouseEvent):void {
			if (event.target == view.systemManager.stage) thumbMouseMoveHandler(event);
		}
		private function thumbStageMouseUpHandler(event:MouseEvent):void {
			if (event.target == view.systemManager.stage) thumbMouseUpHandler(event);
		}
		
		/******************************
		 * Helpers
		 ******************************/
		 
		private function dispatchScrollEvent(oldPosition:Number, detail:String):void {
			var event:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
			event.detail = detail;
			event.position = sdata.position;
			event.delta = sdata.position - oldPosition;
			edata.dispatchEvent(event);
		}
	}
}