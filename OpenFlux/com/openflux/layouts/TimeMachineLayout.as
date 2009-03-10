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
	import com.openflux.core.IFluxList;
	import com.openflux.core.IFluxView;
	import com.openflux.utils.ListUtil;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IUIComponent;

	/**
	 * 3D Layout that orders the items in a list fading off in to the distance. 
	 * Selected item is tilted and at the front of the visible list.
	 */
	public class TimeMachineLayout extends LayoutBase implements ILayout
	{
		/**
		 * Constructor
		 */
		public function TimeMachineLayout() {
			super();
			updateOnChange = true;
		}
		
		// ========================================
		// gap property
		// ========================================
		
		private var _gap:Number = 10;
		
		[Bindable("gapProperty")]
		
		/**
		 * Gap between each item
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
		
		public function measure(children:Array):Point {
			// TODO: Complete me
			return new Point();
		}
		
		public function update(children:Array, rectangle:Rectangle):void {
			var list:IFluxList = (container as IFluxView).component as IFluxList;
			var selectedIndex:int = list ? Math.max(0, ListUtil.selectedIndex(list)) : 0;
			var selectedChild:DisplayObject = children[selectedIndex];
			var child:IUIComponent;
			var token:AnimationToken;
			
			container.animator.begin();
			
			for (var i:int = 0; i < children.length; i++) {
				child = children[i];
				token = new AnimationToken(child.getExplicitOrMeasuredWidth(), child.getExplicitOrMeasuredHeight());
				
				if (i > selectedIndex) {
					token.x = -(gap * (selectedIndex - i));
					token.z = -(gap * (selectedIndex - i));
				} else if (i == selectedIndex) {
					token.rotationZ = -40;
					token.x = token.width + gap;
				} else if (i < selectedIndex) {
					token.x = gap * (i - selectedIndex);
					token.z = gap * (i - selectedIndex);
				}
				
				token.x = token.x + rectangle.width/2 - token.width/2;
				token.y = (token.y*-1) + rectangle.height/2 - token.height/2;
				container.animator.moveItem(child as DisplayObject, token);
			}
			
			container.animator.end();
		}
	}
}