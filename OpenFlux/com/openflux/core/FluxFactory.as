package com.openflux.core
{
	import mx.core.IUIComponent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	public class FluxFactory implements IFluxFactory
	{
		
		public function FluxFactory()
		{
		}
		
		public function createComponent(item:Object):IUIComponent {
			var test:String = "";
			var declaration:CSSStyleDeclaration;
			var selectors:Array = StyleManager.selectors;
			for each(var selector:String in selectors) {
				if(selector.substr(0, 8) == "IFactory") {
					test = selector;
					declaration = StyleManager.getStyleDeclaration(selector);
				}
			}
			//var object:Object = declaration.getStyle("criteria");
			return null;
		}
		
	}
}