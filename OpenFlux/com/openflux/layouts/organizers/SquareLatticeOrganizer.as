package com.openflux.layout.organizers
{
	import com.openflux.layout.elements.*;
	import flash.display.*;

	public class SquareLatticeOrganizer extends LatticeOrganizer implements ILayoutOrganizer
	{
		
		private var _allowOverflow:Boolean;
		private var _maxCells:uint;
		
		/**
		 * Mutator for allowOverflow property
		 *
		 * @param	value	Boolean value determining whether overflow is allowed    
		 */
		public function set allowOverflow(value:Boolean):void
		{
			this._allowOverflow=value;
		}
		
		/**
		 * Accessor for allowOverflox property
		 *
		 * @return	Boolean value determining whether overflow is allowed   
		 */
		public function get allowOverflow():Boolean
		{
			return this._allowOverflow;
		}
		
		/**
		 * Mutator for width property
		 *
		 * @param	value	Global width dimension of layout organizer   
		 */
		public override function set width(value:Number):void
		{
			this.columnWidth = value/_columns;
		}
		
		public override function get width():Number
		{
			return _columnWidth*_columns;
		}
		
		/**
		 * Mutator for height property
		 *
		 * @param	value	Global height dimension of layout organizer   
		 */
		public override function set height(value:Number):void
		{
			this.rowHeight = value/_rows;
		}
		
		public override function get height():Number
		{
			return _rowHeight*_rows;
		}
		
		/**
		 * Mutator for rows property
		 *
		 * @param	value	the amount of rows in the lattice   
		 */
		public function set rows(value:uint):void
		{
			this._rows=value;
			this._order=LatticeOrganizer.ORDER_VERTICALLY;
			this.adjustLattice();
			this.adjustLayout();
			if(_autoAdjust) this.apply(_tweenFunction);
			this._maxCells=_rows*_columns;
		}
		
		/**
		 * Mutator for columns property
		 *
		 * @param	value	the amount of columns in the lattice   
		 */
		public function set columns(value:uint):void
		{
			this._columns=value;
			this._order=LatticeOrganizer.ORDER_HORIZONTALLY;
			this.adjustLattice();
			this.adjustLayout();
			if(_autoAdjust) this.apply(_tweenFunction);
			this._maxCells=_rows*_columns;
		}
		
		/**
		 * Mutator for order property
		 *
		 * @param	value	the order in which elements are put in the lattice (horizonal or vertical)   
		 */
		public override function set order(value:String):void
		{
			this._order=value;
			this.adjustLattice();
			this.adjustLayout();
			if(_autoAdjust) this.apply(_tweenFunction);
		}
		
		/**
		 * Constructor for SquareLatticeOrganizer 
		 *
		 * @param  target  DisplayObject where all layout elements will reside
		 * @param  columnWidth  total width of the entire grid
		 * @param  rowHeight  total height of the entire grid
		 * @param  columns  number of columns in the grid
		 * @param  rows  number of rows in the grid
		 * @param  allowOverflow determines whether lattice will expand to items added past the specified size
		 * @param  order sets order of how items are set in the lattice
		 * @param  hPadding  horizontal padding between cells
		 * @param  vPadding  vertical padding between cells
		 * @param  xOffset  x position of grid
		 * @param  yOffset  y position of grid
		 */
		public function SquareLatticeOrganizer(target:Sprite, columnWidth:Number, rowHeight:Number, columns:uint=1, rows:uint=1, allowOverflow:Boolean=true, order:String=LatticeOrganizer.ORDER_HORIZONTALLY, hPadding:uint=0, vPadding:uint=0, xOffset:Number=0, yOffset:Number=0):void
		{
			super(target, columnWidth*columns, rowHeight*rows, columns, rows, order)
			this._paddingX=hPadding;
			this._paddingY=vPadding;
			this._x=xOffset;
			this._y=yOffset;
			this._columnWidth=columnWidth;
			this._rowHeight=rowHeight;
			this._maxCells=_rows*_columns;
			this._allowOverflow=allowOverflow
		}
		
		/**
		 * Adds DisplayObject to layout in next available position
		 *
		 * @param  object  DisplayObject to add to organizer
		 * @param  moveToCoordinates  automatically move DisplayObject to corresponding cell's coordinates
		 * @param  addToStage  adds a child DisplayObject instance to target's DisplayObjectContainer instance
		 */
		public override function addToLayout(object:DisplayObject, moveToCoordinates:Boolean=true, addToStage:Boolean=true):void
		{
			if(!_allowOverflow&&totalCells>=_maxCells) return;
			super.addToLayout(object, moveToCoordinates, addToStage);
			if(_order==LatticeOrganizer.ORDER_VERTICALLY) this._columns = Math.ceil(totalCells/_rows);
			else if(_order==LatticeOrganizer.ORDER_HORIZONTALLY) this._rows = Math.ceil(totalCells/_columns);
		}
		
		/**
		* Clones the current object's properties (does not include links to DisplayObjects)
		* 
		* @return SquareLatticeOrganizer clone of object
		*/
		public function clone():SquareLatticeOrganizer
		{
			return new SquareLatticeOrganizer(_target, _columnWidth, _rowHeight, _columns, _rows, _allowOverflow, _order, _paddingX, _paddingY, _x, _y);
		}
				
		protected override function adjustLattice():void
		{
			super.adjustLattice();
			if(_order==LatticeOrganizer.ORDER_VERTICALLY) this._columns = Math.ceil(totalCells/_rows);
			else if(_order==LatticeOrganizer.ORDER_HORIZONTALLY) this._rows = Math.ceil(totalCells/_columns);
		}				
	}
}