package com.openflux
{
	import com.openflux.core.FluxComponent;
	import com.openflux.core.IFluxContainer;
	
	public class Container extends FluxComponent implements IFluxContainer
	{
		
		private var _children:Array;
		
		public function get children():Array { return _children; }
		public function set children(value:Array):void {
			_children = value;
		}
		
	}
}