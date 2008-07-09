package com.openflux.layouts
{
	import com.openflux.containers.IFluxContainer;
	import com.openflux.utils.DisplayObjectFoamRenderer;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.events.ChildExistenceChangedEvent;
	
	import org.generalrelativity.foam.Foam;
	import org.generalrelativity.foam.dynamics.element.body.RigidBody;
	import org.generalrelativity.foam.dynamics.enum.Simplification;
	import org.generalrelativity.foam.dynamics.force.Friction;
	import org.generalrelativity.foam.dynamics.force.Gravity;
	import org.generalrelativity.foam.math.Vector;
	import org.generalrelativity.foam.util.ShapeUtil;

	public class PhysicsLayout extends LayoutBase implements ILayout
	{
		private var foam:Foam;
		
		private var leftWall:RigidBody;
		private var rightWall:RigidBody;
		private var topWall:RigidBody;
		private var bottomWall:RigidBody;
		
		private var childBody:Dictionary = new Dictionary(true);
        
		public function PhysicsLayout()
		{
			super();
		
			foam = new Foam();
			foam.solverIterations = 4;
			foam.setRenderer( new DisplayObjectFoamRenderer() );
			foam.useMouseDragger( true );
		
			foam.addGlobalForceGenerator( new Friction( 0.01 ) );
		}
		
		private var _gravityForce:Gravity;

		public function setGravity(yValue:Number=0, xValue:Number=0):void {
			if(_gravityForce) {
				foam.removeGlobalForceGenerator(_gravityForce);
			}
			else {
				foam.simulate();
			}
			
			_gravityForce = new Gravity( new Vector(xValue, yValue) );
			foam.addGlobalForceGenerator(_gravityForce);
		}
		
		override public function attach(container:IFluxContainer):void
		{
			super.attach(container);
			Container(container).rawChildren.addChild(foam);
			container.addEventListener(ChildExistenceChangedEvent.CHILD_ADD, onChildAdd);
			container.addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, onChildRemove);

			var child:UIComponent;
			for each (child in container.children)
			{
				addChild(child);
			}
			
			setGravity(.5);
		}
		
		override public function detach(container:IFluxContainer):void
		{
			super.detach(container);
			Container(container).rawChildren.removeChild(foam);
			container.removeEventListener(ChildExistenceChangedEvent.CHILD_ADD, onChildAdd);
			container.removeEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, onChildRemove);

			var child:UIComponent;
			for each (child in container.children)
			{
				removeChild(child);
			}
		}
		
		public function measure():Point
		{
			return new Point(100,100);
		}
		
		public function update(indices:Array=null):void
		{
			createWalls(container.getExplicitOrMeasuredWidth(), container.getExplicitOrMeasuredHeight());
		}
		
		private function createWalls(w:Number, h:Number):void {
			foam.removeElement(bottomWall);
			bottomWall = new RigidBody( w/2, h + 10, Simplification.INFINITE_MASS, ShapeUtil.createRectangle( w, 20 ) );
			foam.addElement( bottomWall, true, false);
			
			foam.removeElement(leftWall);
			leftWall = new RigidBody( -10, h/2, Simplification.INFINITE_MASS, ShapeUtil.createRectangle( 20, h ) );
			foam.addElement(leftWall, true, false);
			
			foam.removeElement(rightWall);
			rightWall = new RigidBody( w + 10, h/2, Simplification.INFINITE_MASS, ShapeUtil.createRectangle( 20, h ) );
			foam.addElement(rightWall, true, false);
			
			foam.removeElement(topWall);
			topWall = new RigidBody( w/2,-10, Simplification.INFINITE_MASS, ShapeUtil.createRectangle( w, 20 ) );
			foam.addElement(topWall, true, false);
		}
        
		private function onChildAdd(event:ChildExistenceChangedEvent):void
		{
			addChild(event.relatedObject as UIComponent);
		}
        
		private function addChild(child:UIComponent):void
		{
			child.validateSize(true);
			
			var childWidth:Number = child.getExplicitOrMeasuredWidth();
			var childHeight:Number = child.getExplicitOrMeasuredHeight();
			
			var body:RigidBody = new RigidBody(child.x, child.y, .5, ShapeUtil.createRectangle(childWidth, childHeight));
			childBody[child] = body;
			foam.addElement(body, true, true, child);
			
			if(_gravityForce) {
				foam.simulate();
			}
		}
        
		private function onChildRemove(event:ChildExistenceChangedEvent):void
		{
			removeChild(event.relatedObject as UIComponent);
		}
		
		private function removeChild(child:UIComponent):void
		{
			foam.removeElement(childBody[child]);
			delete childBody[child];
		}
	}
}