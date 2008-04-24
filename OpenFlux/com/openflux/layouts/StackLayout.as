package com.openflux.layouts
{
	
	import com.openflux.core.IDataView;
	import com.openflux.core.ISelectable;
	import com.openflux.events.DataViewEvent;
	import com.openflux.layouts.animators.TweenAnimator;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	public class StackLayout extends LayoutBase implements ILayout
	{
		private var _selectMode:String = "ZigZag";
		public function get selectMode():String { return _selectMode; }
		public function set selectMode(value:String):void {
			_selectMode = value;
			container.invalidateLayout();
		}
		
		private var _gap:Number = 20;
		[Bindable]
		public function get gap():Number { return _gap; }
		public function set gap(value:Number):void {
			_gap = value;
			container.invalidateLayout();
		}
		
		public function StackLayout():void {
			super();
			animator = new TweenAnimator();
		}
		
		override public function attach(container:IDataView):void {
			super.attach(container);
			container.addEventListener(MouseEvent.CLICK, clickHandler);
			container.addEventListener(DataViewEvent.DATA_VIEW_CHANGED, dataViewChanged);
		}
		
		override public function detach(container:IDataView):void {
			super.detach(container);
			container.removeEventListener(MouseEvent.CLICK, clickHandler);
			container.removeEventListener(DataViewEvent.DATA_VIEW_CHANGED, dataViewChanged);
		}
		
		public function dataViewChanged(event:DataViewEvent):void {
			container.invalidateLayout();
		}
		
		public function clickHandler(event:MouseEvent):void {
			container.invalidateLayout();
		}
		
		public function getMeasuredSize():Point {
			var point:Point = new Point();
			
			for each(var child:UIComponent in container.renderers) {
				point.y = Math.max(child.y + child.measuredHeight, point.y);
				point.x = Math.max(child.x + child.measuredWidth, point.x);
			}
			
			return point;
		}
		
		public function generateLayout():void {
			if (container.renderers && container.renderers.length > 0) {
				animator.startMove();
				
				var len:int = container.renderers.length;
				var xPos:Number = 0;
				var yPos:Number = 0;
				var direction:Number = 1;
				var time:Number = container.dragTargetIndex != -1 ? .2 : 2;
				var child:UIComponent;
				var width:Number;
				var height:Number;
				
				for (var i:int = 0; i < len; i++) {
					child = container.renderers[i] as UIComponent;
					width = child.getExplicitOrMeasuredWidth();
					height = child.getExplicitOrMeasuredHeight();
					
					if (i == container.dragTargetIndex) {
						if (selectMode == "ZigZag") {
							xPos += gap;
							yPos += gap * direction;
						} else {
							xPos += _gap;
						}
					}
					
					animator.moveItem(child, {x:xPos, y:yPos, width:width, height:height, rotation:0, time:time});
					
					if (selectMode == "ZigZag") {
						if ((child as ISelectable).selected) direction = direction * -1;
						xPos += gap;
						yPos += gap * direction;
					} else {
						if ((child as ISelectable).selected) xPos += width;
						else xPos += _gap;
					}
				}
				
				animator.stopMove();
			}
		}
		
		override public function findItemAt(px:Number, py:Number, seamAligned:Boolean):int {
			var xPos:Number = 0;
			var yPos:Number = 0;
			var direction:Number = 1;
			var len:int = container.renderers.length - 1;
			var offset:Number = seamAligned ? gap : 0;
			var child:UIComponent;
			var width:Number;
			var height:Number;
			
			for (var i:int = 0; i < len; i++) {
				child = container.renderers[i] as UIComponent;
				width = child.getExplicitOrMeasuredWidth();
				height = child.getExplicitOrMeasuredHeight();
				
				if (px >= xPos - offset && px <= xPos + gap && py >= yPos - offset && py <= yPos + gap)
					return i;
				
				if (selectMode == "ZigZag") {
					if ((child as ISelectable).selected) direction = direction * -1;
					xPos += gap;
					yPos += gap * direction;
				} else {
					if ((child as ISelectable).selected) xPos += width;
					else xPos += _gap;
				}
			}
			
			return -1;
		}
	}
}