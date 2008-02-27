package com.openflux.layout.organizers
{
	import flash.display.*;
	import com.openflux.layout.elements.Cell;
	
	public class VerticalOrganizer extends LayoutOrganizer implements ILayoutOrganizer
	{
		/**
		 * Constructor for VerticalOrganizer 
		 *
		 * @param  target  DisplayObject where all layout elements will reside
		 * @param  height  total height of the entire ellipse
		 * @param  x  x position of ellipse
		 * @param  y  y position of ellipse
		 */
		public function VerticalOrganizer(target:Sprite, height:Number, x:Number=0, y:Number=0):void
		{
			super(target);
			this._height=height;
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
		* @return VerticalOrganizer clone of object
		*/
		public function clone():VerticalOrganizer
		{
			return new VerticalOrganizer(_target, _height, _x, _y);
		}
		
		protected override function adjustLayout():void
		{
			var len:int=this._cells.length;
			var c:Cell;
			for(var i:int=0; i<len; i++)
			{	
				c = this._cells[i];
								
				c.y = ((_height/totalCells)*i)+_y;
				c.x = this._x;
			}
		}
		
	}
}