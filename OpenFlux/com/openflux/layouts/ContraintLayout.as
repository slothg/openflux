package com.openflux.layouts
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;

	public class ContraintLayout extends LayoutBase implements ILayout
	{
		public function ContraintLayout()
		{
			super();
		}
		
		public function measure(children:Array):Point
		{
			var width:Number = 0;
			var height:Number = 0;
			var minWidth:Number = 0;
			var minHeight:Number = 0;
			
			for each (var child:UIComponent in children) {
				var li:LayoutItem = new LayoutItem(child);
				
				var left:Number   = li.getConstraint("left");
				var right:Number  = li.getConstraint("right");
				var top:Number    = li.getConstraint("top");
				var bottom:Number = li.getConstraint("bottom");
				    
				var extX:Number = 0;
				var extY:Number = 0;
				
				if (isNaN(left) && isNaN(right) && isNaN(li.getConstraint("horizontalCenter"))) {
				    extX += child.x;
				} else {
				    extX += isNaN(left) ? 0 : left;
				    extX += isNaN(right) ? 0 : right;
				}
				
				if (isNaN(top) && isNaN(bottom) && isNaN(li.getConstraint("verticalCenter"))) {
				    extY += child.y;
				} else {
				    extY += isNaN(top) ? 0 : top;
				    extY += isNaN(bottom) ? 0 : bottom;
				}
				    
				width = Math.max(width, extX + li.preferredWidth);
				height = Math.max(height, extY + li.preferredHeight);
				
				var itemMinWidth:Number = li.constraintsDetermineWidth() ? li.minWidth : li.preferredWidth;
				var itemMinHeight:Number = li.constraintsDetermineHeight() ? li.maxHeight : li.preferredHeight;
				
				minWidth = Math.max(minWidth, extX + itemMinWidth);
				minHeight = Math.max(minHeight, extY + itemMinHeight);
			}
	        container.measuredMinWidth = minWidth;
	        container.measuredMinHeight = minHeight;   
	        return new Point(Math.max(width, minWidth), Math.max(height, minHeight));
		}
		
		public function update(children:Array, rectangle:Rectangle):void {	
	        for each (var child:UIComponent in children) {
	            var li:LayoutItem = new LayoutItem(child);
	            
	            var hCenter:Number = li.getConstraint("horizontalCenter");
	            var vCenter:Number = li.getConstraint("verticalCenter");
	            var left:Number    = li.getConstraint("left");
	            var right:Number   = li.getConstraint("right");
	            var top:Number     = li.getConstraint("top");
	            var bottom:Number  = li.getConstraint("bottom");
				var itemMinSize:Point = new Point(li.minWidth, li.minHeight);
				var itemMaxSize:Point = new Point(li.maxWidth, li.maxHeight);
	
				// Calculate size
	            var childWidth:Number = 0;
	            var childHeight:Number = 0;
	            
	            if (!isNaN(left) && !isNaN(right))
	                childWidth = container.getExplicitOrMeasuredWidth() - right - left;
	            else
	                childWidth = Math.max(itemMinSize.x, Math.min(itemMaxSize.x, childWidth));
	            
	            if (!isNaN(top) && !isNaN(bottom))
	                childHeight = container.getExplicitOrMeasuredHeight() - bottom - top;
	            else
	                childHeight = Math.max(itemMinSize.y, Math.min(itemMaxSize.y, childHeight));

				// Set size
	            child.setActualSize(childWidth, childHeight);
	            var actualSize:Point = new Point(childWidth, childHeight);
	
	            // Calculate position            
	            var childX:Number;
	            var childY:Number;
	
	            // Horizontal
	            if (!isNaN(hCenter))
	                childX = Math.round((container.getExplicitOrMeasuredWidth() - actualSize.x) / 2 + hCenter);
	            else if (!isNaN(left))
	                childX = left;
	            else if (!isNaN(right))
	                childX = container.getExplicitOrMeasuredWidth() - actualSize.x - right;
	            else
	                childX = child.x;
	            
	            // Vertical
	            if (!isNaN(vCenter))
	                childY = Math.round((container.getExplicitOrMeasuredHeight() - actualSize.y) / 2 + vCenter);
	            else if (!isNaN(top))
	                childY = top;
	            else if (!isNaN(bottom))
	                childY = container.getExplicitOrMeasuredHeight() - actualSize.y - bottom;
	            else
	                childY = child.y;
	
	            // Set position
	            child.visible = true;
	            child.move(childX, childY);
	        }
			
		}
	}
}