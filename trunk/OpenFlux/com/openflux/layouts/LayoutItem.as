package com.openflux.layouts
{
	import mx.core.IConstraintClient;
	import mx.core.IUIComponent;
	
	public class LayoutItem
	{
		private var ui:IUIComponent;
		
		public function LayoutItem(ui:IUIComponent)
		{
			this.ui = ui;
		}
		
		public function constraintsDetermineWidth():Boolean {
			return !isNaN(getConstraint("left")) && !isNaN(getConstraint("right"));
		}
		
		public function constraintsDetermineHeight():Boolean {
			return !isNaN(getConstraint("top")) && !isNaN(getConstraint("bottom"));
		}

		public function getConstraint(name:String):Number {
			var constraintClient:IConstraintClient = ui as IConstraintClient;
			if (!constraintClient)
				return NaN;
			
			var value:String = constraintClient.getConstraintValue(name);
			var result:Array = parseConstraintExp(value);
			if (!result || result.length != 1)
				return NaN;
			
			return result[0];
		}
		
		public function parseConstraintExp(val:String):Array {
			if (!val)
				return null;
			// Replace colons with spaces
			var temp:String = val.replace(/:/g, " ");
			
			// Split the string into an array 
			var args:Array = temp.split(/\s+/);
			return args;
		}
		
		public function get preferredWidth():Number
		{
			var width:Number;
			
			if (!isNaN(ui.explicitWidth)) {
				width = ui.explicitWidth;
			} else {
				width = ui.measuredWidth;
				
				if (!isNaN(ui.explicitMinWidth))
					width = Math.max(width, ui.explicitMinWidth);
				if (!isNaN(ui.explicitMaxWidth))
					width = Math.min(width, ui.explicitMaxWidth);
			}
			
			width /= ui.scaleX;
			return width;
		}
		
		public function get preferredHeight():Number {
		  	var height:Number;

			if (!isNaN(ui.explicitHeight)) {
				height = ui.explicitHeight;
			} else {
				height = ui.measuredHeight;
			
				if (!isNaN(ui.explicitMinHeight))
					height = Math.max(height, ui.explicitMinHeight);
				if (!isNaN(ui.explicitMaxHeight))
					height = Math.min(height, ui.explicitMaxHeight);
			}
			
			height /= ui.scaleY;
			return height;
		}
		
		public function get minWidth():Number
		{
			var minWidth:Number;
			if (!isNaN(ui.explicitWidth)) {
				minWidth = ui.explicitWidth;
			} else if (!isNaN(ui.explicitMinWidth)) {
				minWidth = ui.explicitMinWidth;
			} else {
				minWidth = isNaN(ui.measuredMinWidth) ? 0 : ui.measuredMinWidth;
				if (!isNaN(ui.explicitMaxWidth))
					minWidth = Math.min(minWidth, ui.explicitMaxWidth);
			}
			
			minWidth /= ui.scaleX;
			return minWidth;
		}
		
		public function get minHeight():Number
		{
			var minHeight:Number;
			if (!isNaN(ui.explicitHeight)) {
				minHeight = ui.explicitHeight;
			} else if (!isNaN(ui.explicitMinHeight)) {
				minHeight = ui.explicitMinHeight;
			} else {
				minHeight = isNaN(ui.measuredMinHeight) ? 0 : ui.measuredMinHeight;
				if (!isNaN(ui.explicitMaxHeight))
					minHeight = Math.min(minHeight, ui.explicitMaxHeight);
			}
			
			minHeight /= ui.scaleY;
			return minHeight;
		}
		
		public function get maxWidth():Number {
			var maxWidth:Number;
			if (!isNaN(ui.explicitWidth))
				maxWidth = ui.explicitWidth;
			else if (!isNaN(ui.explicitMaxWidth))
				maxWidth = ui.explicitMaxWidth;
			else
				maxWidth = Number.MAX_VALUE;

			maxWidth /= ui.scaleX;
			return maxWidth;
    	}
    	
		public function get maxHeight():Number {
			var maxHeight:Number;
			if (!isNaN(ui.explicitHeight))
				maxHeight = ui.explicitHeight;
			else if(!isNaN(ui.explicitMaxHeight))
				maxHeight = ui.explicitMaxHeight;
			else
				maxHeight = Number.MAX_VALUE;
			
			maxHeight /= ui.scaleY;
			return maxHeight;
		}

	}
}