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
	 * 3D Spiral layout
	 */
	public class SpiralLayout extends LayoutBase implements ILayout, IDragLayout
	{
		/**
		 * Constructor
		 */
		public function SpiralLayout() {
			super();
		}
		
		// ========================================
		// rotations property
		// ========================================
		
		private var _rotations:Number = 5;
		
		/**
		 * Number of rotations the spiral should have. More rotations equals more 3D depth.
		 */
		public function get rotations():Number { return _rotations; }
		public function set rotations(value:Number):void {
			if (_rotations != value) {
				_rotations = value;
				if (container) {
					container.invalidateDisplayList();
				}
			}
		}

		// ========================================
		// gap property
		// ========================================
		
		private var _gap:Number = 50;
		
		/**
		 * Gap between each item.
		 */
		public function get gap():Number { return _gap; }
		public function set gap(value:Number):void {
			if (_gap != value) {
				_gap = value;
				if (container) {
					container.invalidateDisplayList();
				}
			}
		}
		
		// ========================================
		// ILayout implementation
		// ========================================
		
		public function measure(children:Array):Point
		{
			// TODO: Complete me
			return new Point();
		}
		
		public function update(children:Array, rectangle:Rectangle):void {
			adjust(children, rectangle, []);
		}
		
		// ========================================
		// IDragLayout implementation
		// ========================================
		
		public function adjust(children:Array, rectangle:Rectangle, indices:Array):void {
			var numOfItems:int = children.length;
			var radius:Number = Math.min(rectangle.width, rectangle.height) / 2;
			var angle:Number = ((Math.PI * 2) * _rotations) / numOfItems;
			var zPos:Number = 0;
			var m:int = 0;
			
			for(var i:uint=0; i<numOfItems; i++) {
				var child:IUIComponent = children[i];
				var token:AnimationToken = new AnimationToken(child.getExplicitOrMeasuredWidth(), child.getExplicitOrMeasuredHeight());

				token.x = Math.cos((i+m) * angle) * radius;
                token.y = Math.sin((i+m) * angle) * radius;
                token.z = zPos += _gap;
                
				if (indices.indexOf(i) != -1) {
					token.z = zPos += _gap;
					m++;
				}
				
				token.x = token.x + rectangle.width/2 - token.width/2;
				token.y = (token.y*-1) + rectangle.height/2 - token.height/2;
				animator.moveItem(child as DisplayObject, token);
			}
		}

		public function findIndexAt(children:Array, x:Number, y:Number):int {
			// TODO: Complete me
			return 0;
		}
	}
}