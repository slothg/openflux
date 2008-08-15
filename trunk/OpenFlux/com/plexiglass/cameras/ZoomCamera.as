package com.plexiglass.cameras
{
	import away3d.cameras.Camera3D;
	import away3d.core.math.Number3D;
	import away3d.primitives.Plane;
	
	import caurina.transitions.Tweener;
	
	import com.plexiglass.containers.IPlexiContainer;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.events.ChildExistenceChangedEvent;
	
	public class ZoomCamera extends CameraBase implements ICamera
	{
		protected var cameraPos:Number3D;
		protected var origCameraPos:Number3D;
		protected var lookAt:Number3D = new Number3D(0,0,0);
		protected var zoomedPlane:Plane;
		
		public function ZoomCamera()
		{
			super();
			camera = new Camera3D({z:-1000, zoom:11, focus:100});
		}

		override public function attach(container:IPlexiContainer):void {
			super.attach(container);
			
			var child:IUIComponent;
			container.addEventListener(ChildExistenceChangedEvent.CHILD_ADD, onChildAdd);
			container.addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, onChildRemove);
			for each (child in container.children) {
				child.addEventListener(MouseEvent.CLICK, onClick);
			}
		}

		override public function detach(container:IPlexiContainer):void {
			super.detach(container);
			
			var child:IUIComponent;
			Tweener.addTween(lookAt, {x:0, y:0, z:0, time:1});
			if (origCameraPos) Tweener.addTween(cameraPos, {x:origCameraPos.x, y:origCameraPos.y, z:origCameraPos.z, time:1});
			origCameraPos = null;
			
			container.removeEventListener(ChildExistenceChangedEvent.CHILD_ADD, onChildAdd);
			container.removeEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, onChildRemove);
			for each (child in container.children) {
				child.removeEventListener(MouseEvent.CLICK, onClick);
			}
		}

		private function onClick(event:MouseEvent):void {
			var plane:Plane = container.getChildPlane(event.currentTarget as UIComponent);
			if (plane == zoomedPlane) {
				Tweener.addTween(lookAt, {x:0, y:0, z:0, time:1});
				Tweener.addTween(cameraPos, {x:origCameraPos.x, y:origCameraPos.y, z:origCameraPos.z, time:1});
				origCameraPos = null;
				zoomedPlane = null;
				container.view.camera = camera;
			} else {
				if (!origCameraPos) origCameraPos = camera.position.clone();
				Tweener.addTween(cameraPos, {x:plane.x, y:plane.y, z:plane.z - 50, time:1});
				Tweener.addTween(lookAt, {x:plane.x, y:plane.y, z:plane.z, time:1});
				zoomedPlane = plane;
				container.view.camera = camera;
			}
		}
		
		private function onChildAdd(event:ChildExistenceChangedEvent):void {
			event.relatedObject.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onChildRemove(event:ChildExistenceChangedEvent):void {
			event.relatedObject.removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		override protected function onEnterFrame(event:Event):void {
			if (!cameraPos) cameraPos = container.view.camera.position;
			container.view.camera.moveTo(cameraPos.clone());
			container.view.camera.lookAt(lookAt.clone());
		}
	}
}