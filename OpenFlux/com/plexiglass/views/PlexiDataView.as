package com.plexiglass.views
{
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import away3d.core.math.Number3D;
	import away3d.events.MouseEvent3D;
	import away3d.materials.MovieMaterial;
	import away3d.primitives.Plane;
	
	import com.openflux.core.*;
	import com.openflux.views.IDataView;
	import com.openflux.views.DataView;
	
	import flash.events.Event;
	
	import mx.core.ClassFactory;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	
	public class PlexiDataView extends DataView implements IFluxView, IDataView
	{
		private var view:View3D;
		public var camera:Camera3D;
		private var container:UIComponent;
		private var viewContainer:UIComponent;
		private var _selectedIndex:int = 0;
		
		//************************************
		// Public Properties
		//************************************
		
		// TODO: Move this to model
		[Bindable]
		public function get selectedIndex():Number { return _selectedIndex; }
		public function set selectedIndex(value:Number):void {
			_selectedIndex = value;
			this.invalidateLayout();
		}
		
		//************************************
		// Framework overides
		//************************************
		
		override protected function createChildren():void {
			super.createChildren();
			
			//if(itemRenderer == null) {
				//itemRenderer = new ClassFactory(ImageView);
			//}
			
			container = new UIComponent();
			container.visible = false;
			addChild(container);
			
			viewContainer = new UIComponent();
			addChild(viewContainer);
			
			camera = new Camera3D({z:-200, zoom:2, focus:100});
			view = new View3D({camera:camera, x:getExplicitOrMeasuredWidth() / 2, y:getExplicitOrMeasuredHeight() / 2});
			viewContainer.addChild(view);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
      		view.x = this.getExplicitOrMeasuredWidth() / 2;
			view.y = this.getExplicitOrMeasuredHeight() / 2;
		}
		
		override protected function addItem(item:Object, index:int=0):void {
			var child:UIComponent = renderer.newInstance() as UIComponent;
			(child as IDataRenderer).data = item;
			if (child is IFluxListItem) (child as IFluxListItem).list = data as IFluxList;
			container.addChild(child);
			
			var m:MovieMaterial = new MovieMaterial(child, {smooth:true, interactive:true});
			var p:Plane = new Plane({yUp:false, material:m, width:child.getExplicitOrMeasuredWidth(), height:child.getExplicitOrMeasuredHeight()});
			view.scene.addChild(p);
			children.push(p);
			p.addOnMouseUp(planeClicked);
		}
		
		//************************************
		// Event Handlers
		//************************************
		
		private function planeClicked(event:MouseEvent3D):void {
			this.selectedIndex = children.indexOf(event.object);
			this.invalidateDisplayList();
		}
		
		private function enterFrameHandler(event:Event):void {
			if (view && view.stage) {
				camera.lookAt(new Number3D(0, 0, 0));
				view.render();
			}
		}
	}
}