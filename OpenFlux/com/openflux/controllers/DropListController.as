package com.openflux.controllers
{
	import com.openflux.containers.IFluxContainer;
	import com.openflux.core.FluxController;
	import com.openflux.core.IFluxList;
	import com.openflux.core.IFluxListItem;
	import com.openflux.layouts.IDragLayout;
	
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	
	import mx.collections.IList;
	import mx.core.IUIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	[EventHandler(event="dragEnter", handler="dragEnterHandler")]
	[EventHandler(event="dragOver", handler="dragOverHandler")]
	[EventHandler(event="dragDrop", handler="dragDropHandler")]
	[EventHandler(event="dragExit", handler="dragExitHandler")]
	
	/**
	 * Adds ability to drop items on to component and show drag feedback
	 */
	public class DropListController extends FluxController
	{
		[ViewAlias] private var view:IFluxContainer;
		[ModelAlias] public var list:IFluxList;
		[ViewContract(required="false")] public var layout:IDragLayout; // bah, this shouldn't be here probably
		
		/**
		 * Constructor
		 */
		public function DropListController() {
			super();
		}
		
		// ========================================
		// Event handlers
		// ========================================
		
		metadata function dragEnterHandler(event:DragEvent):void {
			if (enabled) {
				// TODO: we need better evaluation here. perhaps integrate with IFluxFactory
				if(event.dragSource.hasFormat("items")) {
					var dropTarget:IUIComponent = event.currentTarget as IUIComponent;
					DragManager.acceptDragDrop(dropTarget);
				}
			}
		}
		
		metadata function dragOverHandler(event:DragEvent):void {
			// this shouldn't really be in the controller ???
			if(layout) {
				var target:IUIComponent = component as IUIComponent;
				var rectangle:Rectangle = new Rectangle(0, 0, target.width, target.height);
				var index:int = layout.findIndexAt(view.children, view.mouseX, view.mouseY);
				layout.adjust(view.children, rectangle, [index]);
			}
		}
		
		metadata function dragDropHandler(event:DragEvent):void {
			var data:Object = event.dragSource.dataForFormat("items")[0];
			var collection:IList = list.data as IList;
			
			if (event.currentTarget == (event.dragInitiator as IFluxListItem).list) {
				var oldIndex:int = collection.getItemIndex(data);
				collection.removeItemAt(oldIndex);
			}

			var index:int = layout ? layout.findIndexAt(view.children, view.mouseX, view.mouseY) : collection.length;
			if(index == -1) { index = collection.length; }
			collection.addItemAt(data, Math.min(collection.length, index));
			
			var dispatcher:IEventDispatcher = event.currentTarget as IEventDispatcher;
			var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_COMPLETE, false, true, event.dragInitiator, event.dragSource, event.action);
			dispatcher.dispatchEvent(dragEvent);
			// update
		}
		
		metadata function dragExitHandler(event:DragEvent):void {
			if(layout) {
				var target:IUIComponent = component as IUIComponent;
				var rectangle:Rectangle = new Rectangle(0, 0, target.width, target.height);
				layout.adjust(view.children, rectangle, []);
			}
		}
	}
}