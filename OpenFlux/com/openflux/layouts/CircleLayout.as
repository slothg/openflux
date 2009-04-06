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
	 * Layout items in a circle
	 */
	public class CircleLayout extends LayoutBase implements ILayout, IDragLayout
	{
		/**
		 * Constructor
		 */
		public function CircleLayout() {
			super();
		}
		
		// ========================================
		// rotate property
		// ========================================
		
		private var _rotate:Boolean = true;
		
		[StyleBinding]
		
		/**
		 * Rotate the circle using the rotationY property
		 */
		public function get rotate():Boolean { return _rotate; }
		public function set rotate(value:Boolean):void {
			if (_rotate != value) {
				_rotate = value;
				
				if (container) {
					container.invalidateDisplayList();
				}
			}
		}
		
		// ========================================
		// ILayout implementation
		// ========================================
		
		public function findIndexAt(children:Array, x:Number, y:Number):int {
			var hCenter:Number = container.width / 2;
			var vCenter:Number = container.height / 2;
			var angle:Number = Math.atan2(y-vCenter, x-hCenter) + Math.PI;
			var index:Number = angle * children.length / (2 * Math.PI) + 1;
			
			return index;
		}
		
		public function measure(children:Array):Point
		{
			// TODO: Measure min width/height
			return new Point(100, 100);
		}
		
		// ========================================
		// IDragLayout implementation
		// ========================================
		
		public function update(children:Array, rectangle:Rectangle):void {
			adjust(children, rectangle, []);
		}
		
		public function adjust(children:Array, rectangle:Rectangle, indices:Array):void {
			var length:int = children.length;
			var width:Number = rectangle.width/2;
			var height:Number = rectangle.height/2;
			var offset:Number = 180*(Math.PI/180);
			var rad:Number;
			
			for (var i:int = 0; i < length; i++) {
				var child:IUIComponent = children[i];
				var layoutItem:LayoutItem = new LayoutItem(child);
				var token:AnimationToken = new AnimationToken(child.measuredWidth, child.measuredHeight);
				var w:Number = width-child.measuredWidth;
				var h:Number = height-child.measuredHeight;
				
				if(indices && indices.indexOf(i+1, 0) >= 0) {
					rad = ((Math.PI*i)/(length/2))+offset;
				} else {
					rad = ((Math.PI*i+1)/(length/2))+offset;
				}
				
				token.x = (w*Math.cos(rad))+w;
				token.y = (h*Math.sin(rad))+h;
				
				if(rotate) {
					token.rotationY = ((360/length)*i);
					
					while(token.rotationY > 180) {
						token.rotationY -= 360;
					}
				}
				
				animator.moveItem(child as DisplayObject, token);
			}
		}
	}
}