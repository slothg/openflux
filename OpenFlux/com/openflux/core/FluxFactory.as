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

package com.openflux.core
{
	import flash.utils.getQualifiedClassName;
	
	import mx.core.IFactory;
	import mx.core.IUIComponent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	/**
	 * Create DisplayObject instances for data object instances.
	 * Could handle caching in the future.
	 */
	public class FluxFactory implements IFluxFactory, IFactory
	{
		private var itemRenderer:IFactory;
		
		/**
		 * Constructor
		 */
		public function FluxFactory(itemRenderer:IFactory = null) {
			this.itemRenderer = itemRenderer;
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		// I feel like list might belong as a second argument,
		// but I'm waiting to see the use case come up.
		
		/**
		 * Create a DisplayObject for a data object
		 */
		public function createComponent(item:Object):IUIComponent {
			var declaration:CSSStyleDeclaration;
			var selectors:Array = StyleManager.selectors;
			var type:String = flash.utils.getQualifiedClassName(item);
			
			if (type.indexOf("::") != -1) {
			 	type = type.substr(type.indexOf("::") + 2);
			}
			 
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
		
		/**
		 * Create a new instance
		 */
		public function newInstance():* {
			return itemRenderer.newInstance();
		}
		
		// ========================================
		// Private methods
		// ========================================
		
		private function createRenderer(declaration:CSSStyleDeclaration):IUIComponent {
			var component:IUIComponent;
			var C:Class = declaration.getStyle("itemRenderer");
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