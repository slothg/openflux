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

package com.openflux.layouts
{
	import com.openflux.animators.IAnimator;
	import com.openflux.containers.IFluxContainer;
	import com.openflux.core.IFluxList;
	import com.openflux.core.IFluxView;
	
	import flash.events.EventDispatcher;
	
	import mx.events.ListEvent;
	
	/**
	 * Base layout class containing common functionality. 
	 */
	public class LayoutBase extends EventDispatcher
	{
		/**
		 * Constructor
		 */
		public function LayoutBase() {
			super();
		}
		
		// ========================================
		// container property
		// ========================================
		
		private var _container:IFluxContainer;
		
		/**
		 * The container/view this layout is managing children size/position for.
		 */
		protected function get container():IFluxContainer { return _container; }
		
		// ========================================
		// updateOnChange property
		// ========================================
		
		private var _updateOnChange:Boolean = false;
		
		/**
		 * Toggles whether to refresh the layout with the selected items changes on the list. 
		 * Listens for a ListEvent.Change
		 */
		protected function get updateOnChange():Boolean { return _updateOnChange; }
		protected function set updateOnChange(value:Boolean):void {
			if (_updateOnChange != value) {
				_updateOnChange = value;
				
				if (container && (container as IFluxView).component is IFluxList) {
					if (value) {
						(container as IFluxView).component.addEventListener(ListEvent.CHANGE, onChange);
					} else {
						(container as IFluxView).component.removeEventListener(ListEvent.CHANGE, onChange);
					}
				}
			}
		}
		
		// ========================================
		// ILayout implementation
		// ========================================
		
		/**
		 * Attach the container. Called once when the layout is assigned to the view.
		 */
		public function attach(container:IFluxContainer):void {
			_container = container;
			
			if (updateOnChange && (container as IFluxView).component is IFluxList) {
				(container as IFluxView).component.addEventListener(ListEvent.CHANGE, onChange);
			}
		}
		
		/**
		 * Detach the container. Called once when the layout is no longer assigned to the view.
		 */
		public function detach(container:IFluxContainer):void {
			if (updateOnChange && (container as IFluxView).component is IFluxList) {
				(container as IFluxView).component.removeEventListener(ListEvent.CHANGE, onChange);
			}
			
			_container = null;
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Convenience getter method for accessing the animator stored on the container.
		 */
		protected function get animator():IAnimator {
			return _container ? _container.animator : null;
		}
		
		/**
		 * Executed when the selected items of the list changes.
		 */
		protected function onChange(event:ListEvent):void
		{
			_container.invalidateDisplayList();
		}
	}
}