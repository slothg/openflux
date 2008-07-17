package com.plexiglass.cameras
{
	import away3d.cameras.Camera3D;
	import away3d.core.math.Number3D;
	import away3d.primitives.Plane;
	
	import com.plexiglass.containers.IPlexiContainer;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	import mx.events.ChildExistenceChangedEvent;
	
	public class CameraBase
	{
		protected var camera:Camera3D;
		protected var container:IPlexiContainer;
		protected var cameraPos:Number3D;
		protected var origCameraPos:Number3D;
		protected var lookAt:Number3D = new Number3D(0,0,0);
		protected var zoomedPlane:Plane;
		
		public function CameraBase()
		{
		}
		
		private var _zoom:Boolean = false;
		public function get zoom():Boolean { return _zoom; }
		public function set zoom(value:Boolean):void {
			var child:DisplayObject;
			
			if (!value && _zoom) {
				container.animator.moveItem(lookAt, {x:0, y:0, z:0});
				if (origCameraPos) container.animator.moveItem(cameraPos, {x:origCameraPos.x, y:origCameraPos.y, z:origCameraPos.z});
				origCameraPos = null;
				
				container.removeEventListener(ChildExistenceChangedEvent.CHILD_ADD, onChildAdd);
				container.removeEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, onChildRemove);
				for each (child in container.children)
				{
					child.removeEventListener(MouseEvent.CLICK, onClick);
				}
			} else if (value && !_zoom) {
				container.addEventListener(ChildExistenceChangedEvent.CHILD_ADD, onChildAdd);
				container.addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, onChildRemove);
				for each (child in container.children)
				{
					child.addEventListener(MouseEvent.CLICK, onClick);
				}
			}
			
			_zoom = value;
		}
		
		public function attach(container:IPlexiContainer):void
		{
			this.container = container;
			this.container.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.container.view.camera = camera;
		}
		
		public function detach(container:IPlexiContainer):void
		{
			this.container.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.container = null;
		}
		
		private function onChildAdd(event:ChildExistenceChangedEvent):void
		{
			event.relatedObject.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onChildRemove(event:ChildExistenceChangedEvent):void
		{
			event.relatedObject.removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(event:MouseEvent):void
		{
			var plane:Plane = container.getChildPlane(event.currentTarget as UIComponent);
			if (plane == zoomedPlane) {
				container.animator.moveItem(lookAt, {x:0, y:0, z:0});
				container.animator.moveItem(cameraPos, {x:origCameraPos.x, y:origCameraPos.y, z:origCameraPos.z});
				origCameraPos = null;
				zoomedPlane = null;
			} else {
				if (!origCameraPos) origCameraPos = camera.position.clone();
				container.animator.moveItem(cameraPos, {x:plane.x, y:plane.y, z:plane.z - 50});
				container.animator.moveItem(lookAt, {x:plane.x, y:plane.y, z:plane.z});
				zoomedPlane = plane;
			}
		}
		
		protected function onEnterFrame(event:Event):void
		{
			if (!cameraPos) cameraPos = camera.position;
			camera.moveTo(cameraPos.clone());
			camera.lookAt(lookAt.clone());
		}
	}
}