package com.openflux.controllers
{
	import com.openflux.core.FluxController;
	import com.openflux.core.IFluxScrollBar;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	
	public class ScrollBarController extends FluxController
	{
		
		private static const LINE_SCROLL_SIZE:Number = 1;
		private static const PAGE_SCROLL_SIZE:Number = 40;
		
		private static const SCROLL_MULTIPLIER:Number = 1.1;
		
		private var direction:int;
		private var timer:Timer;
		
		private var trackScrollDirection:int;
		private var trackScrollTimer:Timer;
		private var trackScrollPosition:Number;
		
		[ModelAlias] public var edata:IEventDispatcher;
		[ModelAlias] public var sdata:IFluxScrollBar;
		[ModelAlias] public var view:UIComponent;
		
		[EventHandler(event="mouseDown", handler="upButton_mouseDownHandler")]
		[ViewContract] public var upButton:DisplayObject;
		
		[EventHandler(event="mouseDown", handler="downButton_mouseDownHandler")]
		[ViewContract] public var downButton:DisplayObject;
		
		[EventHandler(event="mouseDown", handler="thumb_mouseDownHandler")]
		[ViewContract] public var thumb:DisplayObject;
		
		[EventHandler(event="mouseDown", handler="track_mouseDownHandler")]
		[ViewContract] public var track:DisplayObject;
		
		
		//*************************************************************
		// Arrow Event Handlers
		//*************************************************************
		
		metadata function upButton_mouseDownHandler(event:MouseEvent):void {
			direction = -1;
			arrow_mouseDownHandler(event);
		}
		
		metadata function downButton_mouseDownHandler(event:MouseEvent):void {
			direction = 1;
			arrow_mouseDownHandler(event);
		}
		
		private function arrow_mouseDownHandler(event:MouseEvent):void {
			if (!timer) {
				timer = new Timer(1);
				timer.addEventListener(TimerEvent.TIMER, arrow_timerHandler);
			}
			event.target.addEventListener(MouseEvent.MOUSE_OUT, arrow_mouseOutHandler);
			event.target.addEventListener(MouseEvent.MOUSE_OVER, arrow_mouseOverHandler);
			view.systemManager.addEventListener(MouseEvent.MOUSE_UP, arrow_mouseUpHandler, true);
			view.systemManager.stage.addEventListener(Event.MOUSE_LEAVE, arrow_mouseUpHandler);
			timer.start();
		}
		
		private function arrow_mouseOutHandler(event:MouseEvent):void {
			if (timer) timer.stop();
		}
		
		private function arrow_mouseOverHandler(event:MouseEvent):void {
			if (timer) timer.start();
		}
		
		private function arrow_mouseUpHandler(event:Event):void {
			if (timer) { timer.stop(); }
			var arrow:Object = direction == -1 ? upButton : downButton;
			arrow.removeEventListener(MouseEvent.MOUSE_OUT, arrow_mouseOutHandler);
			arrow.removeEventListener(MouseEvent.MOUSE_OVER, arrow_mouseOverHandler);
			view.systemManager.removeEventListener(MouseEvent.MOUSE_UP, arrow_mouseUpHandler, true);
			view.systemManager.stage.removeEventListener(Event.MOUSE_LEAVE, arrow_mouseUpHandler);
		}
		
		private function arrow_timerHandler(event:TimerEvent):void {
			//var oldPosition:Number = sdata.position;
			sdata.position = sdata.position + direction * LINE_SCROLL_SIZE;
			//dispatchScrollEvent(oldPosition, direction > 0 ? ScrollEventDetail.LINE_DOWN : ScrollEventDetail.LINE_UP);
		}
		
		
		//*************************************************************
		// Track Event Handlers
		//*************************************************************
		
		metadata function track_mouseDownHandler(event:MouseEvent):void {

			if (track.width < track.height) {
				trackScrollPosition = event.localY / track.height * (sdata.max - sdata.min);
			} else {
				trackScrollPosition = event.localX / track.width * (sdata.max - sdata.min);
			}

			trackScrollDirection = trackScrollPosition < sdata.position ? -1 : trackScrollPosition > sdata.position ? 1 : 0;
			
			if (!trackScrollTimer) {
				trackScrollTimer = new Timer(1);
				trackScrollTimer.addEventListener(TimerEvent.TIMER, trackScrollTimerHandler);
			}
			
			trackScrollTimer.start();
			
			track.addEventListener(MouseEvent.MOUSE_OUT, trackMouseOutHandler);
			track.addEventListener(MouseEvent.MOUSE_OVER, trackMouseOverHandler);
			view.systemManager.addEventListener(MouseEvent.MOUSE_UP, trackMouseUpHandler, true);
			view.systemManager.addEventListener(MouseEvent.MOUSE_MOVE, trackMouseMoveHandler, true);
			view.systemManager.stage.addEventListener(MouseEvent.MOUSE_MOVE, trackStageMouseMoveHandler);
			view.systemManager.stage.addEventListener(Event.MOUSE_LEAVE, trackMouseLeaveHandler);
		}
		
		private function trackMouseUpHandler(event:MouseEvent):void {
			trackMouseLeaveHandler(event);
		}
		
		private function trackMouseLeaveHandler(event:Event):void {
			track.removeEventListener(MouseEvent.MOUSE_OUT, trackMouseOutHandler);
			track.removeEventListener(MouseEvent.MOUSE_OVER, trackMouseOverHandler);
			view.systemManager.removeEventListener(MouseEvent.MOUSE_UP, trackMouseUpHandler, true);
			view.systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, trackMouseMoveHandler, true);
			view.systemManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE, trackStageMouseMoveHandler);
			view.systemManager.stage.removeEventListener(Event.MOUSE_LEAVE, trackMouseLeaveHandler);
			
			if (trackScrollTimer) trackScrollTimer.stop();
		}
		
		private function trackMouseMoveHandler(event:MouseEvent):void {
			var pt:Point = new Point(event.stageX, event.stageY);
			pt = track.globalToLocal(pt);
			
			if (track.width < track.height) {
				trackScrollPosition = pt.y / track.height * (sdata.max - sdata.min);
			} else {
				trackScrollPosition = pt.x / track.width * (sdata.max - sdata.min);
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
			
			//var oldPosition:Number = sdata.position;
			sdata.position = sdata.position + trackScrollDirection * PAGE_SCROLL_SIZE;
			//dispatchScrollEvent(oldPosition, trackScrollDirection > 0 ? ScrollEventDetail.PAGE_DOWN : ScrollEventDetail.PAGE_UP);
		}
		
		/******************************
		 * Thumb Event Handlers
		 ******************************/
		
		metadata function thumb_mouseDownHandler(event:MouseEvent):void {
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
			pt = track.globalToLocal(pt);
			
			if (track.width < track.height) {
				sdata.position = (pt.y - 16) / track.height * (sdata.max - sdata.min);
			} else {
				sdata.position = (pt.x - 16) / track.width * (sdata.max - sdata.min);
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
		/*
		private function dispatchScrollEvent(oldPosition:Number, detail:String):void {
			var event:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
			event.detail = detail;
			event.position = sdata.position;
			event.delta = sdata.position - oldPosition;
			edata.dispatchEvent(event);
		}
		*/
	}
}