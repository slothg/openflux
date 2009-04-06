// =================================================================
//
// Copyright (c) 2009 The OpenFlux Team http://www.openflux.org
// 
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// =================================================================

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
		// validator property
		// ========================================
		
		private var _validator:Function;
		
		/**
		 * External method used to validate whether an item being dragged
		 * should be accepted to be dropped.
		 */
		public function get validator():Function { return _validator; }
		public function set validator(value:Function):void {
			_validator = value;
		}
		
		// ========================================
		// Event handlers
		// ========================================
		
		metadata function dragEnterHandler(event:DragEvent):void {
			if (enabled && (_validator == null || _validator(event.dragSource) == true)) {
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