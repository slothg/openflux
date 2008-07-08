package com.plexiglass.layouts
{
	import away3d.primitives.Plane;
	
	import com.openflux.containers.IFluxContainer;
	import com.openflux.core.FluxComponent;
	import com.openflux.layouts.ILayout;
	import com.openflux.layouts.LayoutBase;
	import com.plexiglass.containers.PlexiContainer;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.core.UIComponent;
	
	public class ConstraintLayout extends LayoutBase implements ILayout
	{
		private var watchers:Dictionary = new Dictionary(true);
		private static const props:Array = ['z','rotationX','rotationY','rotationZ'];//,'width','height'];
		
		public function ConstraintLayout() {
			super();
		}
		
		public function measure():Point {
			return new Point();
		}
		
		override public function detach(container:IFluxContainer):void {
			super.detach(container);
			
			var child:Object;
			var cw:ChangeWatcher;
			
			for (child in watchers) {
				for each (cw in watchers[child]) {
					cw.unwatch();
				}
				delete watchers[child];
			}
		}
		
		public function update(indices:Array = null):void {
			if (container is PlexiContainer) {
				var view:PlexiContainer = container as PlexiContainer;
				var child:Object;
				var cw:ChangeWatcher;
				var p:String;
				var plane:Plane;
				
				// remove any change watchers for children no longer added to stage
				for (child in watchers) {
					if (container.children.indexOf(child) == -1) {
						for each (cw in watchers[child]) {
							cw.unwatch();
						}
						
						delete watchers[child];
					}
				}
				
				// add change watchers for any newly added child
				for each (child in container.children) {
					plane = view.getChildPlane(child as UIComponent);
					if (!watchers[child] && plane) {
						plane.x = child.width / 2 + child.x;
						plane.y = (child.height / 2 + child.y) * -1;
						watchers[child] = [];
						//watchers[child].push(BindingUtils.bindProperty(view.planes[child], "x", child, {name: "x", getter: getX}));
						//watchers[child].push(BindingUtils.bindProperty(view.planes[child], "y", child, {name: "y", getter: getY}));
						for each (p in props) {
							watchers[child].push(BindingUtils.bindProperty(plane, p, child, p));
						}
					}
				}
			}
		}
		
		private function getX(child:FluxComponent):Number
		{
			var n:Number = (child.width / 2 + child.x) * -1;
			return isNaN(n) ? 0 : n; 
		}
		
		private function getY(child:FluxComponent):Number
		{
			var n:Number = (child.height / 2 + child.y) * -1;
			return isNaN(n) ? 0 : n;
		}
	}
}