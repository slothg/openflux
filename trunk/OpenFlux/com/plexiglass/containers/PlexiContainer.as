package com.plexiglass.containers
{
	import away3d.cameras.HoverCamera3D;
	import away3d.containers.View3D;
	import away3d.core.math.Number3D;
	import away3d.materials.MovieMaterial;
	import away3d.primitives.Plane;
	import away3d.primitives.Sphere;
	
	import com.openflux.containers.Container;
	import com.openflux.core.*;
	import com.plexiglass.animators.PlexiAnimator;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	
	public class PlexiContainer extends Container
	{
		private var view:View3D;
		public var camera:HoverCamera3D;
		private var viewContainer:UIComponent;
		private var container:UIComponent;
		private var _selectedIndex:int = 0;
		private var _renderers:Array = new Array();
		private var center:Sphere;
		
		override public function get children():Array { return _renderers; }
		public var planes:Dictionary = new Dictionary(true);
		
		public function PlexiContainer()
		{
			super();
			container = new Canvas();
			container.visible = false;
			center = new Sphere();
			camera = new HoverCamera3D({z:-1200, zoom:11, focus:100, target:center, distance:-1200});
			view = new View3D({camera:camera}); // x:getExplicitOrMeasuredWidth() / 2, y:getExplicitOrMeasuredHeight() / 2
			//view.scene.addChild(center);
		}
		
		//************************************
		// Public Properties
		//************************************
		/*
		public function get selectedIndex():int { return _selectedIndex; }
		public function set selectedIndex(value:int):void {
			_selectedIndex = value;
			invalidateLayout();
		}
		*/
		//************************************
		// Framework overides
		//************************************
		
		override protected function createChildren():void {
			if (!animator) {
				animator = new PlexiAnimator();
			}
			super.createChildren();
			viewContainer = new UIComponent();
			rawChildren.addChild(viewContainer);
			rawChildren.addChild(container);
			viewContainer.addChild(view);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
      		view.x = unscaledWidth/2;
			view.y = unscaledHeight/2;
			camera.x = (unscaledWidth/2);
			camera.y = -(unscaledHeight/2);
			center.x = camera.x;
			center.y = camera.y;
			camera.lookAt(new Number3D(0, 0, 0));
		}
		
		override public function addChild(child:DisplayObject):DisplayObject {
			container.addChild(child);
			if (child.width > 0 && child.height > 0) {
				var m:MovieMaterial = new MovieMaterial(child as Sprite, {smooth:true, interactive:true});
				var p:Plane = new Plane({yUp:false, material:m, width:child.width, height:child.height, bothsides:true});
				view.scene.addChild(p);
				children.push(child);
				planes[child] = p;
			}
			return child;
		}
		
		override public function getChildAt(index:int):DisplayObject {
			return view.scene.children[index].material.movie;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject {		
			view.scene.removeChild(planes[child]);
			delete planes[child];
			return child;
		}
		
		//************************************
		// Event Handlers
		//************************************
		
		private function enterFrameHandler(event:Event):void {
			if (view && view.stage) {
				camera.targetpanangle = 90 * (width/2-mouseX)/(width/2);
				camera.targettiltangle = 90 * (height/2-mouseY)/(height/2) * -1;
				camera.hover();
				view.render();
			}
		}
	}
}