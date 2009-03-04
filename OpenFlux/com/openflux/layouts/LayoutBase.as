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
				
				if (container && (_container as IFluxView).component is IFluxList) {
					if (_updateOnChange) {
						(_container as IFluxView).component.addEventListener(ListEvent.CHANGE, onChange);
					} else {
						(_container as IFluxView).component.removeEventListener(ListEvent.CHANGE, onChange);
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
			
			if (updateOnChange && (_container as IFluxView).component is IFluxList) {
				(_container as IFluxView).component.addEventListener(ListEvent.CHANGE, onChange);
			}
		}
		
		/**
		 * Detach the container. Called once when the layout is no longer assigned to the view.
		 */
		public function detach(container:IFluxContainer):void {
			_container = null;
			
			if (updateOnChange && (_container as IFluxView).component is IFluxList) {
				(_container as IFluxView).component.removeEventListener(ListEvent.CHANGE, onChange);
			}
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