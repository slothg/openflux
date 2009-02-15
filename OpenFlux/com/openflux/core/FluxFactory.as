package com.openflux.core
{
	import com.openflux.ListItem;
	
	import flash.utils.getQualifiedClassName;
	
	import mx.core.IFactory;
	import mx.core.IUIComponent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	public class FluxFactory implements IFluxFactory, IFactory
	{
		
		private var itemRenderer:IFactory;
		
		public function FluxFactory(itemRenderer:IFactory = null)
		{
			this.itemRenderer = itemRenderer;
			if(this.itemRenderer == null) {
				this.itemRenderer = new ListItem();
			}
		}
		
		// I feel like list might belong as a second argument,
		// but I'm waiting to see the use case come up.
		public function createComponent(item:Object):IUIComponent {
			var declaration:CSSStyleDeclaration;
			var selectors:Array = StyleManager.selectors;
			var type:String = flash.utils.getQualifiedClassName(item);
			type = type.substr(type.indexOf("::")+2);
			for each(var selector:String in selectors) {
				if(selector == type) {
					declaration = StyleManager.getStyleDeclaration(selector);
				}
			}
			
			var component:IUIComponent;
			if(declaration) {
				component = createRenderer(declaration);
			} else {
				component = itemRenderer.newInstance();
			}
			return component;
		}
		
		public function newInstance():* {
			return itemRenderer.newInstance();
		}
		
		private function createRenderer(declaration:CSSStyleDeclaration):IUIComponent {
			var component:IUIComponent;
			var C:Class = declaration.getStyle("itemRenderer");
			C = C ? C : ListItem;
			component = new C();
			var prototype:Object = {factory:declaration.factory};
			prototype.factory();
			// how can we coordinate this with metastyler?
			for(var token:Object in prototype) {
				if(token=="view") {
					var P:Class = prototype.view;
					(component as IFluxComponent).view = new P() as IFluxView;
				}
			}
			return component;
		}
		
	}
}