package com.openflux.managers
{
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	import mx.styles.CSSStyleDeclaration;
	import flash.events.IEventDispatcher;
	import mx.styles.IStyleManager2;

	public class StyleManager implements IStyleManager2
	{
		public function StyleManager()
		{
		}

		public function get inheritingStyles():Object { return null; }
		public function set inheritingStyles(value:Object):void { }
		
		public function get selectors():Array { return null; }
		
		public function get stylesRoot():Object { return null; }
		public function set stylesRoot(value:Object):void { }
		
		public function get typeSelectorCache():Object { return null; }
		public function set typeSelectorCache(value:Object):void { }
		
		public function loadStyleDeclarations2(url:String, update:Boolean=true, applicationDomain:ApplicationDomain=null, securityDomain:SecurityDomain=null):IEventDispatcher { return null; }
		
		public function getStyleDeclaration(selector:String):CSSStyleDeclaration { return null; }
		public function setStyleDeclaration(selector:String, styleDeclaration:CSSStyleDeclaration, update:Boolean):void {}
		
		public function clearStyleDeclaration(selector:String, update:Boolean):void {}
		
		public function registerInheritingStyle(styleName:String):void {}
		
		public function isInheritingStyle(styleName:String):Boolean { return false; }
		
		public function isInheritingTextFormatStyle(styleName:String):Boolean { return false; }
		
		public function registerSizeInvalidatingStyle(styleName:String):void { }
		
		public function isSizeInvalidatingStyle(styleName:String):Boolean { return false;}
		
		public function registerParentSizeInvalidatingStyle(styleName:String):void {}
		
		public function isParentSizeInvalidatingStyle(styleName:String):Boolean { return false; }
		
		public function registerParentDisplayListInvalidatingStyle(styleName:String):void { }
		
		public function isParentDisplayListInvalidatingStyle(styleName:String):Boolean { return false; }
		
		public function registerColorName(colorName:String, colorValue:uint):void {}
		
		public function isColorName(colorName:String):Boolean { return false;}
		
		public function getColorName(colorName:Object):uint { return 0; }
		
		public function getColorNames(colors:Array):void { }
		
		public function isValidStyleValue(value:*):Boolean { return false; }
		
		public function loadStyleDeclarations(url:String, update:Boolean=true, trustContent:Boolean=false):IEventDispatcher { return null; }
		
		public function unloadStyleDeclarations(url:String, update:Boolean=true):void {}
		
		public function initProtoChainRoots():void {}
		
		public function styleDeclarationsChanged():void {}
		
	}
}