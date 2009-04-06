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
	import com.openflux.core.IFluxDataGridColumn;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.IList;
	import mx.core.IUIComponent;

	public class DataGridLayout extends HorizontalLayout implements ILayout, IDragLayout
	{
		public function DataGridLayout(colunns:IList=null)
		{
			this.columns = columns;
			super();
		}
		
		private var _columns:IList; [Bindable]
		public function get columns():IList { return _columns; }
		public function set columns(value:IList):void {
			_columns = value;
		}
		
		override public function measure(children:Array):Point {
			var p:Point = super.measure(children);
			
			if (container) {
				p.x -= container.x;
			}
			
			return p;
		}
		
		override public function adjust(children:Array, rectangle:Rectangle, indices:Array):void {
			var position:Number = rectangle.x;
			var length:int = children.length;
			var s:int = 0;
			
			for (var i:int = 0; i < length; i++) {
				if(indices[s] == i) {
					position += 20 + gap;
				}
				var column:IFluxDataGridColumn = columns.getItemAt(i) as IFluxDataGridColumn;
				var child:IUIComponent = children[i];
				//var w:Number = child.getExplicitOrMeasuredWidth();
				
				var width:Number = i == 0 ? column.width - container.x : column.width;
				
				var token:AnimationToken = new AnimationToken(width, rectangle.height, position);
				animator.moveItem(child as DisplayObject, token);
				position += token.width + gap;
			}
		}
		
	}
}