package com.openflux.layout.elements
{
	import flash.display.DisplayObject;
	import com.openflux.layout.elements.Cell;
	
	public class GridCell extends Cell
	{
		
		private var _row:uint;
		private var _column:uint;
		private var _width:Number;
		private var _height:Number;
		
		public function GridCell(column:uint, row:uint, x:Number=0, y:Number=0, width:Number=0, height:Number=0, link:DisplayObject=null)
		{
			super(x, y, link);
			this._row=row;
			this._column=column;
			this._width=width;
			this._height=height;
		}
		
		public function get row():uint
		{
			return _row;
		}
		
		public function set row(value:uint):void
		{
			this._row=value;
		}
		
		public function get column():uint
		{
			return _column;
		}
		
		public function set column(value:uint):void
		{
			this._column=value;
		}
		
		public function get width():Number
		{
			return _width;
		}
		
		public function get height():Number
		{
			return _height;
		}
	}
}