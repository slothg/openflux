package com.openflux.layouts
{
	import com.openflux.animators.AnimationToken;
	import com.openflux.core.IFluxDataGridColumn;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import mx.collections.ICollectionView;
	import mx.core.IUIComponent;

	public class DataGridLayout extends HorizontalLayout implements ILayout, IDragLayout
	{
		public function DataGridLayout(colunns:ICollectionView=null)
		{
			this.columns = columns;
			super();
		}
		
		private var _columns:ICollectionView; [Bindable]
		public function get columns():ICollectionView { return _columns; }
		public function set columns(value:ICollectionView):void {
			_columns = value;
		}
		
		override public function adjust(children:Array, rectangle:Rectangle, indices:Array):void {
			animator.begin();
			var position:Number = rectangle.x;
			var length:int = children.length;
			var s:int = 0;
			for (var i:int = 0; i < length; i++) {
				if(indices[s] == i) {
					position += 20 + gap;
				}
				var column:IFluxDataGridColumn = columns[i] as IFluxDataGridColumn;
				var child:IUIComponent = children[i];
				//var w:Number = child.getExplicitOrMeasuredWidth();
				var token:AnimationToken = new AnimationToken(column.width, rectangle.height, position);
				animator.moveItem(child as DisplayObject, token);
				position += token.width + gap;
			}
			animator.end();
		}
		
	}
}