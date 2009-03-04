package com.openflux.layouts
{
	import com.openflux.animators.AnimationToken;
	import com.openflux.core.IFluxList;
	import com.openflux.core.IFluxView;
	import com.openflux.utils.ListUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IUIComponent;

	/**
	 * Cover Flow 3D layout similar to iTunes. 
	 * Original code was from Doug McCune's CoverFlow component but has changed over time.
	 */
	public class CoverFlowLayout extends LayoutBase implements ILayout
	{
		/**
		 * Constructor
		 */
		public function CoverFlowLayout()
		{
			super();
			updateOnChange = true;
		}
		
		// ========================================
		// gap property
		// ========================================
		
		private var _gap:Number = 0;
		
		[Bindable("gapChange")]
		
		/**
		 * Gap between each item
		 */
		public function get gap():Number { return _gap; }
		public function set gap(value:Number):void {
			if (_gap != value) {
				_gap = value;
				dispatchEvent(new Event("gapChange"));
				
				if (container) {
					container.invalidateDisplayList();
				}
			}
		}
		
		// ========================================
		// distance property
		// ========================================
		
		private var _distance:Number = 50;
		
		[Bindable("distanceChange")]
		
		/**
		 * 3D perception of distance between each item. Number is not based on any specific measurement
		 */
		public function get distance():Number { return _distance; }
		public function set distance(value:Number):void {
			if (_distance != value) {
				_distance = value;
				dispatchEvent(new Event("distanceChange"));
				
				if (container) {
					container.invalidateDisplayList();
				}
			}
		}
		
		// ========================================
		// angle property
		// ========================================
		
		private var _angle:Number = 40;
		
		[Bindable("angleChange")]
		
		/**
		 * Degrees (0 to 90 usually) to angle items. Not including the selected item.
		 */
		public function get angle():Number { return _angle; }
		public function set angle(value:Number):void {
			if (_angle != value) {
				_angle = value;
				dispatchEvent(new Event("angleChange"));
				
				if (container) {
					container.invalidateDisplayList();
				}
			}
		}

		// ========================================
		// direction property
		// ========================================

		private var _direction:String = "horizontal";
		
		[Bindable("directionChange")]
		
		/**
		 * Layout direction (horizontal or vertical)
		 */
		public function get direction():String { return _direction; }
		public function set direction(value:String):void {
			if (_direction != value) {
				_direction = value;
				dispatchEvent(new Event("directionChange"));
				
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
			// TODO: Figure out a min measured width/height
			return new Point(100, 100);
		}
		
		public function update(children:Array, rectangle:Rectangle):void
		{
			adjust(children, rectangle, []);
		}
		
		// ========================================
		// IDragLayout implementation
		// ========================================
		
		public function adjust(children:Array, rectangle:Rectangle, indices:Array):void
		{
			var list:IFluxList = (container as IFluxView).component as IFluxList;
			var selectedIndex:int = list ? Math.max(0, ListUtil.selectedIndex(list)) : 0;
			var selectedChild:IUIComponent = children[selectedIndex];
			
			var maxChildHeight:Number = selectedChild.measuredHeight;
			var maxChildWidth:Number = selectedChild.measuredWidth;	
			var horizontalGap:Number = direction == "horizontal" ? maxChildHeight / 3 : _distance;
			var verticalGap:Number = direction == "horizontal" ? _distance : maxChildWidth / 3;
				
			var child:IUIComponent;
			var token:AnimationToken;
			var abs:Number;
			var offset:Number = 0;
			
			var selectedWidth:Number = selectedChild.getExplicitOrMeasuredWidth();
			
			container.animator.begin();
			
			for (var i:int = 0; i < children.length; i++) {
				child = children[i];
				token = new AnimationToken(child.getExplicitOrMeasuredWidth(), child.getExplicitOrMeasuredHeight());
				abs = Math.abs(selectedIndex - i);
				
				if (direction == "horizontal") {
					if (indices.indexOf(i) != -1) {
						offset += token.width;
					}

					token.x = selectedWidth + ((abs - 1) * horizontalGap) + offset + 30;
					token.y = -(maxChildHeight - child.height) / 2;
					token.z = (selectedWidth + abs * verticalGap);
					token.rotationY = angle * -1;
					
					if (_gap > 0) {
						token.x += (abs - 1) * (_gap + token.width);
					}
					
					if (i < selectedIndex) {
						token.x *= -1;
						token.x += selectedWidth;
						token.rotationY *= -1;
					} else if (i == selectedIndex) {
						token.x = 0;
						token.z = 0;
						token.rotationY = 0;
						offset = 0;
					}
				} else {
					if (indices.indexOf(i) != -1) {
						offset += token.height;
					}
						
					token.y = selectedChild.getExplicitOrMeasuredHeight() + ((abs - 1) * verticalGap) + offset;
					token.x = 0;
					token.z = selectedChild.getExplicitOrMeasuredHeight() + abs * horizontalGap; 
					token.rotationX = angle;
					token.rotationY = 0;
					
					if (_gap > 0) {
						token.y += (abs - 1) * (_gap + token.height);
					}
					
					if (i < selectedIndex) {
						token.y *= -1;
						token.rotationX *= -1;
					} else if (i == selectedIndex) {
						token.y = 0;
						token.z = 200 / 2; 
						token.rotationX = 0;
						offset = 0;
					}
				}
				
				token.x = token.x + rectangle.width/2 - token.width/2;
				token.y = (token.y*-1) + rectangle.height/2 - token.height/2;
				
				container.animator.moveItem(child as DisplayObject, token);
			}
			
			container.animator.end();	
		}		
	}
}