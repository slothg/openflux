package com.openflux.layout.organizers
{
	import com.openflux.layout.elements.*;
	import flash.display.*;

	public class LatticeOrganizer extends LayoutOrganizer
	{
		
		protected var _order:String;
		protected var _rows:uint;
		protected var _columns:uint;
		protected var _paddingX:uint=0;
		protected var _paddingY:uint=0;
		protected var _columnWidth:Number;
		protected var _rowHeight:Number;
		
		public static const ORDER_HORIZONTALLY:String = "latticeOrderHorizontally";
		public static const ORDER_VERTICALLY:String = "latticeOrderVertically";
		
		/**
		 * Accessor for paddingY property
		 *
		 * @return	X padding of grid cells for layout organizer   
		 */
		public function get paddingX():Number
		{
			return _paddingX;
		}

		/**
		 * Accessor for paddingY property
		 *
		 * @return	Y padding of grid cells for layout organizer   
		 */
		public function get paddingY():Number
		{
			return _paddingY;
		}
		
		/**
		 * Mutator for paddingY property
		 *
		 * @param	value	Y padding of grid cells for layout organizer   
		 */
		public function set paddingY(value:Number):void
		{
			this._paddingY=value;
			this.adjustLayout();
			if(_autoAdjust) this.apply(_tweenFunction);
		}
		
		/**
		 * Mutator for paddingX property
		 *
		 * @param	value	X padding of grid cells for layout organizer   
		 */
		public function set paddingX(value:Number):void
		{
			this._paddingX=value;
			this.adjustLayout();
			if(_autoAdjust) this.apply(_tweenFunction);
		}
		
		/**
		 * Mutator for column width property
		 *
		 * @param	value	column width of each individual cell in the layout   
		 */
		public function set columnWidth(value:Number):void
		{
			this._columnWidth=value;
			this.adjustLayout();
			if(_autoAdjust) this.apply(_tweenFunction);
		}
		
		/**
		 * Mutator for row height property
		 *
		 * @param	value	row height of each individual cell in the layout   
		 */
		public function set rowHeight(value:Number):void
		{
			this._rowHeight=value;
			this.adjustLayout();
			if(_autoAdjust) this.apply(_tweenFunction);
		}
		
		/**
		 * Accessor for columnWidth property
		 *
		 * @return	column width of each individual cell  
		 */
		public function get columnWidth():Number
		{
			return this._columnWidth;
		}
		
		/**
		 * Accessor for rowHeight property
		 *
		 * @return	row height of each individual cell   
		 */
		public function get rowHeight():Number
		{
			return this._rowHeight;
		}

		/**
		 * Accessor for width property
		 *
		 * @return	global width property of organizer   
		 */
		public override function get width():Number
		{
			return _width;
		}
		
		/**
		 * Accessor for height property
		 *
		 * @return	global height property of organizer   
		 */
		public override function get height():Number
		{
			return _height;
		}
		
		/**
		 * Accessor for rows property
		 *
		 * @return	Row length   
		 */
		public function get rows():uint
		{
			return _rows;
		}
		
		/**
		 * Accessor for columns property
		 *
		 * @return	Column length   
		 */
		public function get columns():uint
		{
			return _columns;
		}
		
		/**
		 * Mutator for order property
		 *
		 * @param value	the order in which elements are put in the lattice (horizonal or vertical)   
		 */
		public function set order(value:String):void
		{
			this._order=value;
		}
		
		/**
		 * Accessor for order property
		 *
		 * @return 	the order in which elements are put in the lattice (horizonal or vertical)   
		 */
		public function get order():String
		{
			return _order;
		}
		
		/**
		 * Constructor for SquareLatticeOrganizer 
		 *
		 * @param  target  DisplayObject where all layout elements will reside
		 * @param  width  total width of the entire grid
		 * @param  height  total height of the entire grid
		 * @param  columns  number of columns in the grid
		 * @param  rows  number of rows in the grid
		 * @param  order sets order of how items are set in the lattice
		 */
		public function LatticeOrganizer(target:Sprite, width:Number, height:Number, columns:uint, rows:uint, order:String=LatticeOrganizer.ORDER_VERTICALLY):void
		{
			super(target);
			this._width=width;
			this._height=height;
			this._rows=rows;
			this._columns=columns;
			this._order=order;
		}
		
		/**
		 * Adds DisplayObject to layout in next available position
		 *
		 * @param  object  DisplayObject to add to organizer
		 * @param  moveToCoordinates  automatically move DisplayObject to corresponding cell's coordinates
		 * @param  addToStage  adds a child DisplayObject instance to target's DisplayObjectContainer instance
		 */
		public function addToLayout(object:DisplayObject, moveToCoordinates:Boolean=true, addToStage:Boolean=true):void
		{
			
			if(!_cells) _cells = new Array();
			var c:uint = (_order==LatticeOrganizer.ORDER_VERTICALLY) ? (totalCells)%_columns:(totalCells)%Math.floor(((totalCells)/_rows));
			var r:uint = (_order==LatticeOrganizer.ORDER_VERTICALLY) ? Math.floor((totalCells)/_columns):(totalCells)%_rows;
			var cell:GridCell = new GridCell(c,r);
			cell.link=object;

			this._cells.push(cell);
			this.adjustLattice();
			this.adjustLayout();
			
			if(moveToCoordinates)
			{
				this.apply(_tweenFunction);
			}
			if(addToStage)
			{
				this._target.addChild(object);
			}
			
		}
		
		/**
		 * Removes specified cell and its link from layout organizer and adjusts layout appropriately
		 *
		 * @param  cell  cell object to remove
		 */
		public override function removeCell(cell:Cell):void
		{
			super.removeCell(cell);
			this.adjustLattice();
			this.adjustLayout();
			if(_autoAdjust) this.apply(_tweenFunction);
		}
				
		protected override function adjustLayout():void
		{
			var len:uint=this._cells.length;
			var c:uint;
			var r:uint;
			var cell:GridCell;
			for(var i:int=0; i<len; i++)
			{
				cell = this._cells[i];
				if(!cell) break;
							
				cell.x = (cell.column*(_columnWidth+_paddingX))+_x;
				cell.y = (cell.row*(_rowHeight+_paddingY))+_y;
			}
			
		}
		
		protected function adjustLattice():void
		{
			var len:uint=this._cells.length;
			var c:uint;
			var r:uint;
			var cell:GridCell;
			var i:int; 
			
			if(_order==LatticeOrganizer.ORDER_HORIZONTALLY)
			{
				for(i=0; i<len; i++)
				{
					cell = this._cells[i];
					if(!cell) break;
					
					c = i%_columns;
					r = Math.floor(i/_columns);
									
					cell.column=c;
					cell.row=r;
				}
			} else
			{
				for(i=0; i<len; i++)
				{
					cell = this._cells[i];
					if(!cell) break;
					
					c = Math.floor(i/_rows);
					r = i%_rows;
									
					cell.column=c;
					cell.row=r;
				}
			}
		}				
	}
}