package com.openflux
{
	import com.openflux.containers.Container;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import mx.core.ApplicationGlobals;
	import mx.core.Singleton;
	import mx.core.UIComponentGlobals;
	import mx.core.mx_internal;
	import mx.managers.ILayoutManager;
	import mx.managers.ISystemManager;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	use namespace mx_internal;

	[Frame(factoryClass="com.openflux.managers.SystemManager")]
	
	[Event(name="applicationComplete", type="mx.events.FlexEvent")]
	[Event(name="error", type="flash.events.ErrorEvent")]
	
	[ResourceBundle("core")]

	public class Application extends Container
	{		
		private var _url:String;
		private var _parameters:Object;
		private var _viewSourceURL:String;
		
		private var resizeHandlerAdded:Boolean = false;
		private var resizeWidth:Boolean = true;
		private var resizeHeight:Boolean = true;
		
		public static function get application():Object {
			return ApplicationGlobals.application;
		}
		
		public function Application()
		{
			//name = "application";

			UIComponentGlobals.layoutManager = ILayoutManager(Singleton.getInstance("mx.managers::ILayoutManager"));

			if (!ApplicationGlobals.application)
				ApplicationGlobals.application = this;
			
			super();
			
			var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("global");
			
			if (!style) {
				style = new CSSStyleDeclaration();
				StyleManager.setStyleDeclaration("global", style, false);
			}
			
			if (style.defaultFactory == null) {
				style.defaultFactory = function():void {
					this.fontWeight = "normal";
					this.modalTransparencyBlur = 3;
					this.verticalGridLineColor = 0xd5dddd;
					this.borderStyle = "inset";
					this.buttonColor = 0x6f7777;
					this.borderCapColor = 0x919999;
					this.textAlign = "left";
					this.disabledIconColor = 0x999999;
					this.stroked = false;
					this.fillColors = [0xffffff, 0xcccccc, 0xffffff, 0xeeeeee];
					this.fontStyle = "normal";
					this.borderSides = "left top right bottom";
					this.borderThickness = 1;
					this.modalTransparencyDuration = 100;
					this.useRollOver = true;
					this.strokeWidth = 1;
					this.filled = true;
					this.borderColor = 0xb7babc;
					this.horizontalGridLines = false;
					this.horizontalGridLineColor = 0xf7f7f7;
					this.shadowCapColor = 0xd5dddd;
					this.fontGridFitType = "pixel";
					this.horizontalAlign = "left";
					this.modalTransparencyColor = 0xdddddd;
					this.disabledColor = 0xaab3b3;
					//this.borderSkin = mx.skins.halo.HaloBorder;
					this.dropShadowColor = 0x000000;
					this.paddingBottom = 0;
					this.indentation = 17;
					this.version = "3.0.0";
					this.fontThickness = 0;
					this.verticalGridLines = true;
					this.embedFonts = false;
					this.fontSharpness = 0;
					this.shadowDirection = "center";
					this.textDecoration = "none";
					this.selectionDuration = 250;
					this.bevel = true;
					this.fillColor = 0xffffff;
					this.focusBlendMode = "normal";
					this.dropShadowEnabled = false;
					this.textRollOverColor = 0x2b333c;
					this.textIndent = 0;
					this.fontSize = 10;
					this.openDuration = 250;
					this.closeDuration = 250;
					this.kerning = false;
					this.paddingTop = 0;
					this.highlightAlphas = [0.3, 0];
					this.cornerRadius = 0;
					this.horizontalGap = 8;
					this.textSelectedColor = 0x2b333c;
					this.paddingLeft = 0;
					this.modalTransparency = 0.5;
					this.roundedBottomCorners = true;
					this.repeatDelay = 500;
					this.selectionDisabledColor = 0xdddddd;
					this.fontAntiAliasType = "advanced";
					//this.focusSkin = mx.skins.halo.HaloFocusRect;
					this.verticalGap = 6;
					this.leading = 2;
					this.shadowColor = 0xeeeeee;
					this.backgroundAlpha = 1.0;
					this.iconColor = 0x111111;
					this.focusAlpha = 0.4;
					this.borderAlpha = 1.0;
					this.focusThickness = 2;
					this.themeColor = 0x009dff;
					this.backgroundSize = "auto";
					this.indicatorGap = 14;
					this.letterSpacing = 0;
					this.fontFamily = "Verdana";
					this.fillAlphas = [0.6, 0.4, 0.75, 0.65];
					this.color = 0x0b333c;
					this.paddingRight = 0;
					this.errorColor = 0xff0000;
					this.verticalAlign = "top";
					this.focusRoundedCorners = "tl tr bl br";
					this.shadowDistance = 2;
					this.repeatInterval = 35;
				};
			}
			
			var styleNames:Array = ["fontWeight", "modalTransparencyBlur", "textRollOverColor", "backgroundDisabledColor", "textIndent", "barColor", "fontSize", "kerning", "textAlign", "fontStyle", "modalTransparencyDuration", "textSelectedColor", "modalTransparency", "fontGridFitType", "disabledColor", "fontAntiAliasType", "modalTransparencyColor", "leading", "dropShadowColor", "themeColor", "letterSpacing", "fontFamily", "color", "fontThickness", "errorColor", "fontSharpness", "textDecoration"];
			
			for (var i:int = 0; i < styleNames.length; i++) {
				StyleManager.registerInheritingStyle(styleNames[i]);
			}
			
			StyleManager.mx_internal::initProtoChainRoots();
		}
		
		override public function get id():String {
			if (!super.id && this == Application.application && ExternalInterface.available) {
				return ExternalInterface.objectID;
			}
		
			return super.id;
		}


		override public function initialize():void {
			var sm:ISystemManager = systemManager;
		
			_url = sm.loaderInfo.url;
			_parameters = sm.loaderInfo.parameters;
		
			initManagers(sm);
			/*_descriptor = null;
		
			if (documentDescriptor) {
				//creationPolicy = documentDescriptor.properties.creationPolicy;
				//if (creationPolicy == null || creationPolicy.length == 0)
				//	creationPolicy = ContainerCreationPolicy.AUTO;
			
				var properties:Object = documentDescriptor.properties;
				
				if (properties.width != null) {
					width = properties.width;
					delete properties.width;
				}
				if (properties.height != null) {
					height = properties.height;
					delete properties.height;
				}
			
				documentDescriptor.events = null;
			}*/
		
			initContextMenu();
		
			super.initialize();
		
			//addEventListener(Event.ADDED, addedHandler);
		
			//if (sm.isTopLevelRoot() && Capabilities.isDebugger == true)
			//	setInterval(debugTickler, 1500);
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			
			resizeWidth = isNaN(explicitWidth);
			resizeHeight = isNaN(explicitHeight);
			
			if (resizeWidth || resizeHeight) {
				//resizeHandler(new Event(Event.RESIZE));
			
				if (!resizeHandlerAdded) {
					systemManager.addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
					resizeHandlerAdded = true;
				}
			} else {
				if (resizeHandlerAdded) {
					systemManager.removeEventListener(Event.RESIZE, resizeHandler);
					resizeHandlerAdded = false;
				}
			}
		}
		
		
		private function initManagers(sm:ISystemManager):void {
			if (sm.isTopLevel()) {
				//focusManager = new FocusManager(this);
				//sm.activate(this);
			}
		}
		
		private function initContextMenu():void {
			/*if (flexContextMenu != null) {
				if (systemManager is InteractiveObject)
					InteractiveObject(systemManager).contextMenu = contextMenu;
				return;
			}
			
			var defaultMenu:ContextMenu = new ContextMenu();
			defaultMenu.hideBuiltInItems();
			defaultMenu.builtInItems.print = true;
			
			if (_viewSourceURL) {
				const caption:String = resourceManager.getString("core", "viewSource");
				viewSourceCMI = new ContextMenuItem(caption, true);
				viewSourceCMI.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
				defaultMenu.customItems.push(viewSourceCMI);
			}
			
			contextMenu = defaultMenu;
			
			if (systemManager is InteractiveObject)
				InteractiveObject(systemManager).contextMenu = defaultMenu;*/
		}
		
		private function resizeHandler(event:Event):void {
			var w:Number;
			var h:Number
		
			if (resizeWidth) {
				if (isNaN(percentWidth)) {
					w = DisplayObject(systemManager).width;
				} else {
					super.percentWidth = Math.max(percentWidth, 0);
					super.percentWidth = Math.min(percentWidth, 100);
					//w = percentWidth*screen.width/100;
				}
		
				if (!isNaN(explicitMaxWidth))
					w = Math.min(w, explicitMaxWidth);
		
				if (!isNaN(explicitMinWidth))
					w = Math.max(w, explicitMinWidth);
			} else {
				w = width;
			}
		
			if (resizeHeight) {
				if (isNaN(percentHeight)) {
					h = DisplayObject(systemManager).height;
				} else {
					super.percentHeight = Math.max(percentHeight, 0);
					super.percentHeight = Math.min(percentHeight, 100);
					//h = percentHeight*screen.height/100;
				}
		
				if (!isNaN(explicitMaxHeight))
					h = Math.min(h, explicitMaxHeight);
		
				if (!isNaN(explicitMinHeight))
					h = Math.max(h, explicitMinHeight);
			} else {
				h = height;
			}
		
			if (w != width || h != height) {
				//invalidateProperties();
				invalidateSize();
			}
		
			setActualSize(w, h);
			//invalidateDisplayList();
		}   
	}
}