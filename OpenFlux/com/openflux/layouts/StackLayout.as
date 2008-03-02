package com.openflux.layouts
{
	
	import com.openflux.core.IDataView;
	import com.openflux.core.ISelectable;
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
			container.invalidateSize();
			container.invalidateDisplayList();
		}
		
		private var _gap:Number = 20; [Bindable]
		public function get gap():Number { return _gap; }
		public function set gap(value:Number):void {
			_gap = value;
			container.invalidateSize();
			container.invalidateDisplayList();
		}
		
		public function StackLayout():void {
			super();
			animator = new TweenAnimator();
		}
		
		override public function attach(container:IDataView):void {
			super.attach(container);
			container.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		override public function detach(container:IDataView):void {
			super.detach(container);
			container.removeEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		public function clickHandler(event:MouseEvent):void {
			generateLayout();
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
			animator.startMove();
			var positionX:Number = 0;
			var positionY:Number = 0;
			var direction:Number = 1;
			
			for each(var child:UIComponent in container.renderers) {
				var token:Object = new Object();
				token.x = positionX;
				token.y = positionY;
				token.width = child.measuredWidth;
				token.height = child.measuredHeight;
				token.rotation = 0;
				animator.moveItem(child, token);
				if (selectMode == "ZigZag") {
					
					if (child is ISelectable && (child as ISelectable).selected) direction = direction * -1;
					positionX += gap;
					positionY += gap * direction;
				} else {
					if ((child as ISelectable).selected) positionX += child.width;
					else positionX += _gap;
				}
			}
				
			animator.stopMove();
		}
		
	}
}