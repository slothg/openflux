package com.openflux.layout.organizers
{
	import flash.display.*;
	import com.openflux.layout.elements.Cell;
	
	public class HorizontalOrganizer extends LayoutOrganizer implements ILayoutOrganizer
	{
		/**
		 * Constructor for HorizontalOrganizer 
		 *
		 * @param  target  DisplayObject where all layout elements will reside
		 * @param  width  total width of the entire ellipse
		 * @param  x  x position of ellipse
		 * @param  y  y position of ellipse
		 */
		public function HorizontalOrganizer(target:Sprite, width:Number, x:Number=0, y:Number=0):void
		{
			super(target);
			this._width=width;
			this._x=x;
			this._y=y;
		}
			
		 /**
		 * Adds DisplayObject to layout in next available position
		 *
		 * @param  object  DisplayObject to add to organizer
		 * @param  moveToCoordinates  automatically move DisplayObject to corresponding cell's coordinates
		 * @param  addToStage  adds a child DisplayObject instance to target's DisplayObjectContainer instance
		 */
		public function addToLayout(object:DisplayObject,  moveToCoordinates:Boolean=true, addToStage:Boolean=true):void
		{
			if(!_cells) _cells = new Array;
			var cell:Cell = new Cell(0,0,object);
			this._cells.push(cell);
			
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
		* Clones the current object's properties (does not include links to DisplayObjects)
		* 
		* @return HorizontalOrganizer clone of object
		*/
		public function clone():HorizontalOrganizer
		{
			return new HorizontalOrganizer(_target, _width, _x, _y);
		}
		
		protected override function adjustLayout():void
		{
			var len:int=this._cells.length;
			var c:Cell;
			for(var i:int=0; i<len; i++)
			{	
				c = this._cells[i];
								
				c.x = ((_width/totalCells)*i)+_x;
				c.y = this._y;
			}
		}
		
	}
}