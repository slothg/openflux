package com.openflux.layouts
{
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	public class VerticalLayout extends LayoutBase implements ILayout, IDragLayout
	{
		
		private var _gap:Number = 0; [Bindable] [StyleBinding]
		public function get gap():Number { return _gap; }
		public function set gap(value:Number):void {
			if (_gap != value) {
				_gap = value;
				container.invalidateLayout();
			}
		}
		
		public function measure():Point {
			var point:Point = new Point(0, 0);
			for each(var child:UIComponent in container.renderers) {
				point.x = Math.max(child.getExplicitOrMeasuredWidth(), point.x);
				point.y += child.getExplicitOrMeasuredHeight() + gap;
			}
			return point;
		}
		
		public function update(indices:Array = null):void {
			animator.begin();
			var position:Number = 0;
			var length:int = container.renderers.length;
			//var time:Number = container.dragTargetIndex != -1 ? .2 : 2;
			for (var i:int = 0; i < length; i++) {
				var token:Object = new Object();
				var child:UIComponent = container.renderers[i];
				token.width = container.getExplicitOrMeasuredWidth();
				token.height = child.measuredHeight;
				if(indices && indices.indexOf(i, 0) >= 0) {
					position += token.height + gap;
				}
				token.x = 0;
				token.y = position;
				token.rotation;
				animator.moveItem(child, token);
				position += token.height + gap;
			}
			animator.end();
		}
		/*
		override public function findItemAt(px:Number, py:Number, seamAligned:Boolean):int {
			var yPos:Number = 0;
			var len:int = container.renderers.length;
			var offset:Number = seamAligned ? gap : 0;
			var child:UIComponent;
			var width:Number;
			var height:Number;
			
			for (var i:int = 0; i < len; i++) {
				child = container.renderers[i] as UIComponent;
				width = child.getExplicitOrMeasuredWidth();
				height = child.getExplicitOrMeasuredHeight();
				
				if (px <= width && py >= yPos - offset && py <= yPos + height)
					return i;
				yPos += height + gap;
			}
			
			return -1;
		}*/
	}
}