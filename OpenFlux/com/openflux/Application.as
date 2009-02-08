package com.openflux
{
	import com.openflux.core.FluxComponent;
	import com.openflux.core.LayoutManager;
	
	import mx.core.UIComponentGlobals;
	import mx.core.mx_internal;
	
	use namespace mx_internal;

	public class Application extends FluxComponent
	{
		public function Application()
		{
			super();
			// Yuck, another Flex class. Just here to show what a Flex application does
			UIComponentGlobals.layoutManager = new LayoutManager();
		}
		
	}
}