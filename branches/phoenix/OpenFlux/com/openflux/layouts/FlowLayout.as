// =================================================================
//
// Copyright (c) 2009 The OpenFlux Team http://www.openflux.org
// 
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// =================================================================

package com.openflux.layouts
{
	import com.openflux.animators.AnimationToken;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IUIComponent;

	/**
	 * Flow layout that aligns items horizontally on as many lines required.
	 */
	public class FlowLayout extends LayoutBase implements ILayout, IDragLayout
	{
		/**
		 * Constructor
		 */	
		public function FlowLayout():void {
			super();
		}

		// ========================================
		// ILayout implementation
		// ========================================
		
		public function measure(children:Array):Point {
			var point:Point = new Point();
			for each(var child:IUIComponent in container.children) {
				point.x = Math.max(child.getExplicitOrMeasuredWidth(), point.x);
				point.y += child.getExplicitOrMeasuredHeight() + 10;
			}
			return point;
		}
		
		public function update(children:Array, rectangle:Rectangle):void {
			adjust(children, rectangle, []);
		}
		
		// ========================================
		// IDragLayout implementation
		// ========================================

		public function adjust(children:Array, rectangle:Rectangle, indices:Array):void {
			var point:Point = measureGrid();
			var cols:Number = Math.floor(rectangle.width / point.x);
			var space:Number = (rectangle.width - (point.x * cols)) / (cols + 1);
			var xPos:Number = rectangle.x + space/2;
			var yPos:Number = rectangle.y + space/2;
			var length:int = children.length;
			var child:IUIComponent;
			var token:AnimationToken;
			
			for (var i:int = 0; i < length; i++) {
				child = children[i];
				token = new AnimationToken(child.getExplicitOrMeasuredWidth(), child.getExplicitOrMeasuredHeight(), xPos, yPos);
				
				if(indices && indices.indexOf(i, 0) >= 0) {
					xPos += token.width + 10;
					if(xPos > rectangle.width - token.width - space / 2) {
						xPos = space / 2;
						yPos += token.height + 8;
					}
				}
				
				animator.moveItem(child as DisplayObject, token);
				
				xPos += token.width + 10;
				
				if(xPos > rectangle.width - token.width - space/2) {
					xPos = space / 2;
					yPos += token.height + 8;
				}
			}
		}
		
		public function findIndexAt(children:Array, x:Number, y:Number):int {
			var containerWidth:Number = container.getExplicitOrMeasuredWidth();
			var point:Point = measureGrid();
			var cols:Number = Math.floor(containerWidth / point.x);
			var space:Number = (containerWidth - (point.x * cols)) / (cols + 1);
			var xPos:Number = space / 2;
			var yPos:Number = space / 2;
			var len:int = container.children.length;
			var child:IUIComponent;
			var layoutItem:LayoutItem;
			var width:Number;
			var height:Number;
			
			for (var i:int = 0; i < len; i++) {
				child = container.children[i];
				width = child.getExplicitOrMeasuredWidth();
				height = child.getExplicitOrMeasuredHeight();
				
				if (x >= xPos - 10 && x <= xPos + width && y >= yPos - 8 && y <= yPos + height)
					return i;
				
				xPos += width + 10;
				if(xPos > containerWidth - width - space / 2) {
					xPos = space / 2;
					yPos += height + 8;
				}
			}
			
			return -1;
		}
		
		// ========================================
		// Private util methods
		// ========================================
		
		private function measureGrid():Point {
			
			var point:Point = new Point();
			var w:Number;
			var h:Number;
				
			for each(var child:IUIComponent in container.children) {
				w = child.getExplicitOrMeasuredWidth();
				h = child.getExplicitOrMeasuredHeight();
				if(w > point.x) {
					point.x = w;
				}
				if(h > point.y) {
					point.y = h;
				}
			}
			var gap:Point = new Point(container.getExplicitOrMeasuredWidth(), container.getExplicitOrMeasuredHeight());
			// do something
			return point;
		}
		
	}
}