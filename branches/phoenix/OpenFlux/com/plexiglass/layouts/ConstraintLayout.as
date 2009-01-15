package com.plexiglass.layouts
{
	import away3d.primitives.Plane;
	
	import com.openflux.containers.IFluxContainer;
	import com.openflux.layouts.ILayout;
	import com.openflux.layouts.LayoutBase;
	import com.plexiglass.containers.PlexiContainer;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.core.UIComponent;
	
	public class ConstraintLayout extends LayoutBase implements ILayout
	{
		
		private var watchers:Dictionary = new Dictionary(true);
		private static const props:Array = ['z','rotationX','rotationY','rotationZ','width','height'];
		
		public function ConstraintLayout() {
			super();
		}
		
		public function measure(children:Array):Point {
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
		
		public function update(children:Array, rectangle:Rectangle):void {
			if (container is PlexiContainer) {
				var view:PlexiContainer = container as PlexiContainer; // wtf?
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
						plane.x = child.getExplicitOrMeasuredWidth() / 2 + child.x + rectangle.width/2;
						plane.y = (child.getExplicitOrMeasuredHeight() / 2 + child.y + rectangle.height/2) * -1;
						watchers[child] = [];
						for each (p in props) {
							watchers[child].push(BindingUtils.bindProperty(plane, p, child, p));
						}
					}
				}
			}
		}
	}
}