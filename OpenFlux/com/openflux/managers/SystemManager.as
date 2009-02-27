package com.openflux.managers
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.core.FlexSprite;
	import mx.core.IChildList;
	import mx.core.ISWFBridgeGroup;
	import mx.core.IUIComponent;
	import mx.core.Singleton;
	import mx.core.mx_internal;
	import mx.core.IFlexDisplayObject;
	import mx.events.FlexEvent;
	import mx.managers.IFocusManagerContainer;
	import mx.managers.ILayoutManagerClient;
	import mx.managers.ISystemManager;
	import mx.managers.SystemManagerGlobals;
	import mx.messaging.config.LoaderConfig;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceBundle;
	import mx.resources.ResourceManager;
	import mx.styles.ISimpleStyleClient;
	import mx.styles.IStyleClient; mx.styles.StyleManagerImpl;
	
	import com.openflux.utils.ClassReferences; ClassReferences;

	[Event(name="applicationComplete", type="mx.events.FlexEvent")]
	[Event(name="idle", type="mx.events.FlexEvent")]
	[Event(name="resize", type="flash.events.Event")]

	use namespace mx_internal;

	public class SystemManager extends MovieClip implements ISystemManager, IChildList
	{
		public static var allSystemManagers:Dictionary = new Dictionary(true);
		public static var lastSystemManager:ISystemManager;
		
		private var topLevel:Boolean = true;
		private var initCallbackFunctions:Array = [];
		private var isStageRoot:Boolean = true;
		private var doneExecutingInitCallbacks:Boolean = false;
		private var lastFrame:int;
		private var nextFrameTimer:Timer = null;
		private var initialized:Boolean = false;
		//private var preloader:Preloader;
		private var _width:Number;
		private var _height:Number;
		private var _screen:Rectangle;
		private var isDispatchingResizeEvent:Boolean = false;
		private var mouseCatcher:Sprite;
		private var nestLevel:int = 0;
		
		public var topLevelWindow:IUIComponent;
		
		public function SystemManager() {
			super();
			
			if (stage) {
				stage.scaleMode =  StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			} else {
				isStageRoot = false;
			}
			
			if (SystemManagerGlobals.topLevelSystemManagers.length > 0 && !stage)
				topLevel = false;
			
			if (topLevel)
				SystemManagerGlobals.topLevelSystemManagers.push(this);
				
			lastSystemManager = this;
			
			var compiledLocales:Array = info()["compiledLocales"];
			ResourceBundle.mx_internal::locale = compiledLocales != null && compiledLocales.length > 0 ? compiledLocales[0] : "en_US";
			
			executeCallbacks();
				
			stop();
			
			if (root && root.loaderInfo)
				root.loaderInfo.addEventListener(Event.INIT, initHandler);
		}
		
		public static function getSWFRoot(obj:DisplayObject):DisplayObject { return lastSystemManager as DisplayObject; }
		
		// Both these are implemented by generated code
		public function create(... parameters):Object {
			var mainClassName:String = info()["mainClassName"];
			
			if (mainClassName == null) {
				var url:String = loaderInfo.loaderURL;
				var dot:int = url.lastIndexOf(".");
				var slash:int = url.lastIndexOf("/");
				mainClassName = url.substring(slash + 1, dot);
			}
			
			var mainClass:Class = Class(getDefinitionByName(mainClassName));
			
			return mainClass ? new mainClass() : null;
		}
		public function info():Object { return {}; }
		
		private var _document:Object;
		public function get document():Object { return _document; }
		public function set document(value:Object):void {
			_document = value;
		}
		
		private var _focusPane:Sprite;
		public function get focusPane():Sprite { return _focusPane; }
		public function set focusPane(value:Sprite):void {
			_focusPane = value;
		}
		
		private var _numModalWindows:int = 0;
		public function get numModalWindows():int { return _numModalWindows; }	
		public function set numModalWindows(value:int):void {
			_numModalWindows = value;
		}
		
		private var _cursorChildren:IChildList;
		public function get cursorChildren():IChildList {
			//if (!topLevel)
			//	return _topLevelSystemManager.cursorChildren;
				
			//if (!_cursorChildren)
			//	_cursorChildren = new SystemChildrenList(this, new QName(mx_internal, "toolTipIndex"), new QName(mx_internal, "cursorIndex"));

			return _cursorChildren;
		}
		
		private var _fontList:Object;
		public function get embeddedFontList():Object { return {};
			/*if (_fontList == null) {
				_fontList = {};
				
				var o:Object = info()["fonts"];
				var p:String;
				
				for (p in o) {
					_fontList[p] = o[p];
				}
				
				if (!topLevel && _topLevelSystemManager) {
					var fl:Object = _topLevelSystemManager.embeddedFontList;
					for (p in fl) {
						_fontList[p] = fl[p];
					}
				}
			}
			
			return _fontList;*/
		}
		
		private var _popUpChildren:IChildList;
		public function get popUpChildren():IChildList {
			//if (!topLevel)
			//	return _topLevelSystemManager.popUpChildren;
			
			//if (!_popUpChildren) {
			//	_popUpChildren = new SystemChildrenList(this, new QName(mx_internal, "noTopMostIndex"), new QName(mx_internal, "topMostIndex"));
			//}
			
			return this; //_popUpChildren;
		}
		
		private var _rawChildren:IChildList;
		public function get rawChildren():IChildList {
			//if (!_rawChildren)
			//	_rawChildren = new SystemRawChildrenList(this);
			
			return this; //_rawChildren;
		}
		
		private var _swfBridgeGroup:ISWFBridgeGroup;
		public function get swfBridgeGroup():ISWFBridgeGroup {
			//if (topLevel)
				return _swfBridgeGroup;
			//else if (topLevelSystemManager)
			//	return topLevelSystemManager.swfBridgeGroup;
			//
			//return null;
		}
		
		public function get screen():Rectangle {
			if (!_screen || !isStageRoot)
				Stage_resizeHandler();
			
			return _screen;
		}
		
		private var _toolTipChildren:IChildList;
		public function get toolTipChildren():IChildList {
			//if (!topLevel)
			//	return _topLevelSystemManager.toolTipChildren;
			
			//if (!_toolTipChildren) {
			//	_toolTipChildren = new SystemChildrenList(this, new QName(mx_internal, "topMostIndex"), new QName(mx_internal, "toolTipIndex"));
			//}
			
			return this; //_toolTipChildren;
		}
		
		//private var _topLevelSystemManager:ISystemManager;
		public function get topLevelSystemManager():ISystemManager { return this; } //_topLevelSystemManager; }
		
		public function addFocusManager(f:IFocusManagerContainer):void {}
		public function removeFocusManager(f:IFocusManagerContainer):void {}
		public function activate(f:IFocusManagerContainer):void {}
		public function deactivate(f:IFocusManagerContainer):void {}
		
		public function getDefinitionByName(name:String):Object {
			var domain:ApplicationDomain = !topLevel && parent is Loader ? Loader(parent).contentLoaderInfo.applicationDomain : info()["currentDomain"] as ApplicationDomain;
			var definition:Object;

			if (domain.hasDefinition(name))
				definition = domain.getDefinition(name);

			return definition;
		}
		
		public function isFontFaceEmbedded(textFormat:TextFormat):Boolean { return false;
			/*var fontName:String = textFormat.font;
			var fl:Array = Font.enumerateFonts();
			
			for (var f:int = 0; f < fl.length; ++f) {
				var font:Font = Font(fl[f]);
				if (font.fontName == fontName) {
					var style:String = "regular";
					if (textFormat.bold && textFormat.italic)
						style = "boldItalic";
					else if (textFormat.bold)
						style = "bold";
					else if (textFormat.italic)
						style = "italic";
			
					if (font.fontStyle == style)
						return true;
				}
			}
			
			if (!fontName || !embeddedFontList || !embeddedFontList[fontName]) {
				return false;
			}
			
			var info:Object = embeddedFontList[fontName];
			
			return !((textFormat.bold && !info.bold) || (textFormat.italic && !info.italic) || (!textFormat.bold && !textFormat.italic && !info.regular));*/
		}

		public function isTopLevel():Boolean { return topLevel; }
		public function isTopLevelRoot():Boolean { return isStageRoot; } //|| isBootstrapRoot; }
		public function getTopLevelRoot():DisplayObject { return this; }
		public function getSandboxRoot():DisplayObject { return this; }
		public function addChildToSandboxRoot(layer:String, child:DisplayObject):void {}
		public function removeChildFromSandboxRoot(layer:String, child:DisplayObject):void {}

		public function addChildBridge(bridge:IEventDispatcher, owner:DisplayObject):void {}
		public function removeChildBridge(bridge:IEventDispatcher):void {}
		public function dispatchEventFromSWFBridges(event:Event, skip:IEventDispatcher=null, trackClones:Boolean=false, toOtherSystemManagers:Boolean=false):void {}
		public function useSWFBridge():Boolean { return false; }
		public function isDisplayObjectInABridgedApplication(displayObject:DisplayObject):Boolean { return false; }
		
		public function getVisibleApplicationRect(bounds:Rectangle=null):Rectangle { return null; }
		public function deployMouseShields(deploy:Boolean):void {}
		
		// =====================================
		// Methods not in ISystemManager
		// =====================================
		
		public function get parentAllowsChild():Boolean {
			try {
				return loaderInfo.parentAllowsChild;
			} catch (error:Error) {}
		
			return false;
		}
		
		private function initHandler(event:Event):void {
			allSystemManagers[this] = this.loaderInfo.url;
			root.loaderInfo.removeEventListener(Event.INIT, initHandler);
			
			addEventListener(Event.ENTER_FRAME, docFrameListener);
			initialize();
		}

		private function docFrameListener(event:Event):void {
			if (currentFrame == 2) {
				removeEventListener(Event.ENTER_FRAME, docFrameListener);
				if (totalFrames > 2)
					addEventListener(Event.ENTER_FRAME, extraFrameListener);
				docFrameHandler();
			}
		}

		private function extraFrameListener(event:Event):void {
			if (lastFrame == currentFrame)
				return;
		
			lastFrame = currentFrame;
		
			if (currentFrame + 1 > totalFrames)
				removeEventListener(Event.ENTER_FRAME, extraFrameListener);
		
			extraFrameHandler();
		}
		
		private function docFrameHandler(event:Event = null):void {
			Singleton.registerClass("mx.managers::IBrowserManager",  Class(getDefinitionByName("mx.managers::BrowserManagerImpl")));
			Singleton.registerClass("mx.managers::ICursorManager",   Class(getDefinitionByName("mx.managers::CursorManagerImpl")));
			Singleton.registerClass("mx.managers::IHistoryManager",  Class(getDefinitionByName("mx.managers::HistoryManagerImpl")));
			Singleton.registerClass("mx.managers::ILayoutManager",   Class(getDefinitionByName("mx.managers::LayoutManager")));
			Singleton.registerClass("mx.managers::IPopUpManager",    Class(getDefinitionByName("mx.managers::PopUpManagerImpl")));
			Singleton.registerClass("mx.managers::IToolTipManager2", Class(getDefinitionByName("mx.managers::ToolTipManagerImpl")));
		
			if (Capabilities.playerType == "Desktop") {
				Singleton.registerClass("mx.managers::IDragManager", Class(getDefinitionByName("mx.managers::NativeDragManagerImpl")));
				if (Singleton.getClass("mx.managers::IDragManager") == null)
					Singleton.registerClass("mx.managers::IDragManager", Class(getDefinitionByName("mx.managers::DragManagerImpl")));
			} else { 
				Singleton.registerClass("mx.managers::IDragManager", Class(getDefinitionByName("mx.managers::DragManagerImpl")));
			}
		
			//var textFieldFactory:TextFieldFactory;
			//Singleton.registerClass("mx.core::ITextFieldFactory", Class(getDefinitionByName("mx.core::TextFieldFactory")));
				
			executeCallbacks();
			doneExecutingInitCallbacks = true;
		
			var mixinList:Array = info()["mixins"];
			if (mixinList && mixinList.length > 0) {
				var n:int = mixinList.length;
				for (var i:int = 0; i < n; ++i) {
					var c:Class = Class(getDefinitionByName(mixinList[i]));
					if (c)
						c["init"](this);
				}
			}
		
			installCompiledResourceBundles();
			initializeTopLevelWindow(null);
			deferredNextFrame();
		}
		
		private function installCompiledResourceBundles():void {
			var info:Object = this.info();
			var applicationDomain:ApplicationDomain = !topLevel && parent is Loader ? Loader(parent).contentLoaderInfo.applicationDomain : info["currentDomain"];
			var compiledLocales:Array = info["compiledLocales"];
			var compiledResourceBundleNames:Array = info["compiledResourceBundleNames"];
			var resourceManager:IResourceManager = ResourceManager.getInstance();
		
			resourceManager.installCompiledResourceBundles( applicationDomain, compiledLocales, compiledResourceBundleNames);
		
			if (!resourceManager.localeChain)
				resourceManager.initializeLocaleChain(compiledLocales);
		}

		private function initialize():void {
			if (isStageRoot) {
				_width = stage.stageWidth;
				_height = stage.stageHeight;
			} else {
				_width = loaderInfo.width;
				_height = loaderInfo.height;
			}
			
			//preloader = new Preloader();
			//preloader.addEventListener(FlexEvent.INIT_PROGRESS, preloader_initProgressHandler);
			//preloader.addEventListener(FlexEvent.PRELOADER_DONE, preloader_preloaderDoneHandler);
			
			//addingChild(preloader);
			//this.addChild(preloader);
			//childAdded(preloader);
			
			//var rsls:Array = info()["rsls"];
			//var cdRsls:Array = info()["cdRsls"];
			//var usePreloader:Boolean = true;
			//if (info()["usePreloader"] != undefined)
			//	usePreloader = info()["usePreloader"];
			
			//var preloaderDisplayClass:Class = info()["preloader"] as Class;
			//if (usePreloader && !preloaderDisplayClass)
			//	preloaderDisplayClass = DownloadProgressBar;
			
			//var rslList:Array = [];
			//var n:int;
			//var i:int;
			/*if (cdRsls && cdRsls.length > 0) {
				var crossDomainRSLItem:Class = Class(getDefinitionByName("mx.core::CrossDomainRSLItem"));
				n = cdRsls.length;
				for (i = 0; i < n; i++) {
					var cdNode:Object = new crossDomainRSLItem(cdRsls[i]["rsls"],
											cdRsls[i]["policyFiles"],
											cdRsls[i]["digests"],
											cdRsls[i]["types"],
											cdRsls[i]["isSigned"],
											this.loaderInfo.url);
					rslList.push(cdNode);	
				}
			}*/

			/*if (rsls != null && rsls.length > 0) {
				n = rsls.length;
				for (i = 0; i < n; i++) {
					var node:RSLItem = new RSLItem(rsls[i].url, this.loaderInfo.url);
					rslList.push(node);
				}
			}*/

			Singleton.registerClass("mx.resources::IResourceManager", Class(getDefinitionByName("mx.resources::ResourceManagerImpl")));
			//Singleton.registerClass("mx.core::IEmbeddedFontRegistry", Class(getDefinitionByName("mx.core::EmbeddedFontRegistry")));
			var resourceManager:IResourceManager = ResourceManager.getInstance();
			//var fontRegistry:EmbeddedFontRegistry;
			Singleton.registerClass("mx.styles::IStyleManager", Class(getDefinitionByName("mx.styles::StyleManagerImpl")));
			Singleton.registerClass("mx.styles::IStyleManager2", Class(getDefinitionByName("mx.styles::StyleManagerImpl")));

			var localeChainList:String = loaderInfo.parameters["localeChain"];
			if (localeChainList != null && localeChainList != "")
				resourceManager.localeChain = localeChainList.split(",");
			var resourceModuleURLList:String = loaderInfo.parameters["resourceModuleURLs"];
			var resourceModuleURLs:Array = resourceModuleURLList ? resourceModuleURLList.split(",") : null;

			//preloader.initialize(
			//	usePreloader,
			//	preloaderDisplayClass,
			//	preloaderBackgroundColor,
			//	1, //preloaderBackgroundAlpha,
			//	null, //preloaderBackgroundImage,
			//	null, //preloaderBackgroundSize,
			//	isStageRoot ? stage.stageWidth : loaderInfo.width,
			//	isStageRoot ? stage.stageHeight : loaderInfo.height,
			//	null,
			//	null,
			//	rslList,
			//	resourceModuleURLs);
			
			deferredNextFrame();
		}

		private function executeCallbacks():void {
			if (!parent && parentAllowsChild)
				return;

			while (initCallbackFunctions.length > 0) {
				var initFunction:Function = initCallbackFunctions.shift();
				initFunction(this);
			}
		}
		
		private function extraFrameHandler(event:Event = null):void {
			var frameList:Object = info()["frames"];
		
			if (frameList && frameList[currentLabel]) {
				var c:Class = Class(getDefinitionByName(frameList[currentLabel]));
				c["frame"](this);
			}
		
			deferredNextFrame();
		}

		private function deferredNextFrame():void {
			if (currentFrame + 1 > totalFrames)
				return;
		
			if (currentFrame + 1 <= framesLoaded) {
				nextFrame();
			} else {
				nextFrameTimer = new Timer(100);
				nextFrameTimer.addEventListener(TimerEvent.TIMER, nextFrameTimerHandler);
				nextFrameTimer.start();
			}
		}

		private function initializeTopLevelWindow(event:Event):void {
			initialized = true;
		
			if (!parent && parentAllowsChild)
				return;
		
			/*if (!topLevel) {
				var obj:DisplayObjectContainer = parent.parent;
				if (!obj)
		  			return;
		  
				while (obj) {
					if (obj is IUIComponent) {
						var sm:ISystemManager = IUIComponent(obj).systemManager;
						if (sm && !sm.isTopLevel())
							sm = sm.topLevelSystemManager;
						_topLevelSystemManager = sm;
						break;
					}
					obj = obj.parent;
				}
			}*/

			//if (isTopLevelRoot() || getSandboxRoot() == this)
				addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, true);
			
			//if (isTopLevelRoot() && stage)
				stage.addEventListener(Event.RESIZE, Stage_resizeHandler, false, 0, true);
			//else if (topLevel && stage) {
			//	var sandboxRoot:DisplayObject = getSandboxRoot();
			//	if (sandboxRoot != this)
			//		sandboxRoot.addEventListener(Event.RESIZE, Stage_resizeHandler, false, 0, true);
			//}
						
			var app:IUIComponent;
			document = app = topLevelWindow = IUIComponent(create());
			
			if (document) {
				IEventDispatcher(app).addEventListener(FlexEvent.CREATION_COMPLETE, appCreationCompleteHandler);
			
				if (!LoaderConfig._url) {
					LoaderConfig._url = loaderInfo.url;
					LoaderConfig._parameters = loaderInfo.parameters;
				}
			
				//if (isStageRoot && stage) {
					_width = stage.stageWidth;
					_height = stage.stageHeight;
					IFlexDisplayObject(app).setActualSize(_width, _height);
				//}
				//else
				//	IFlexDisplayObject(app).setActualSize(loaderInfo.width, loaderInfo.height);
			
				//if (preloader)
				//	preloader.registerApplication(app);
			
				addingChild(DisplayObject(app));
				preloader_preloaderDoneHandler(null);
				childAdded(DisplayObject(app));
				Object(app).validateNow();
			} else {
				document = this;
			}
		}
		
		private function nextFrameTimerHandler(event:TimerEvent):void {
			if (currentFrame + 1 <= framesLoaded) {
				nextFrame();
				nextFrameTimer.removeEventListener(TimerEvent.TIMER, nextFrameTimerHandler);
				nextFrameTimer.reset();
			}
		}
		
		private function mouseDownHandler(event:MouseEvent):void {
			
		}
		
		private function Stage_resizeHandler(event:Event=null):void {
			if (isDispatchingResizeEvent)
				return;

			var w:Number = 0;
			var h:Number = 0;
			var m:Number;
			var n:Number;

			try {
    			m = loaderInfo.width;
    			n = loaderInfo.height;
			} catch (error:Error) { return; }

			var align:String = StageAlign.TOP_LEFT;
			try {
				if (stage) {
					w = stage.stageWidth;
					h = stage.stageHeight;
					align = stage.align;
				}
			} catch (error:SecurityError) {
				var sandboxScreen:Rectangle = getSandboxScreen();
				w = sandboxScreen.width;
				h = sandboxScreen.height;
			}

			var x:Number = (m - w) / 2;
			var y:Number = (n - h) / 2;

			if (align == StageAlign.TOP) {
				y = 0;
			} else if (align == StageAlign.BOTTOM) {
				y = n - h;
			} else if (align == StageAlign.LEFT) {
				x = 0;
			} else if (align == StageAlign.RIGHT) {
				x = m - w;
			} else if (align == StageAlign.TOP_LEFT || align == "LT") {
				y = 0;
				x = 0;
			} else if (align == StageAlign.TOP_RIGHT) {
				y = 0;
				x = m - w;
			} else if (align == StageAlign.BOTTOM_LEFT) {
				y = n - h;
				x = 0;
			} else if (align == StageAlign.BOTTOM_RIGHT) {
				y = n - h;
				x = m - w;
			}

			if (!_screen)
				_screen = new Rectangle();
			
			_screen.x = x;
			_screen.y = y;
			_screen.width = w;
			_screen.height = h;

			if (isStageRoot) {
				_width = stage.stageWidth;
				_height = stage.stageHeight;
			}

			if (event) {
				resizeMouseCatcher();
				isDispatchingResizeEvent = true;
				dispatchEvent(event);
				isDispatchingResizeEvent = false;
			}
		}
		
		private function appCreationCompleteHandler(event:FlexEvent):void {
			/*if (!topLevel && parent) {
				var obj:DisplayObjectContainer = parent.parent;
				while (obj) {
					if (obj is IInvalidating) {
						IInvalidating(obj).invalidateSize();
						IInvalidating(obj).invalidateDisplayList();
						return;
					}
					obj = obj.parent;
				}
			}*/
			 
			//if (topLevel && useSWFBridge())
			//	dispatchInvalidateRequest();
		}
		
		private function addingChild(child:DisplayObject):void {
			var newNestLevel:int = 1;
			
			/*if (!topLevel && parent) {
				var obj:DisplayObjectContainer = parent.parent;
				while (obj) {
					if (obj is ILayoutManagerClient) {
						newNestLevel = ILayoutManagerClient(obj).nestLevel + 1;
						break;
					}
					obj = obj.parent;
				}
			}*/
			nestLevel = newNestLevel;
			
			if (child is IUIComponent)
				IUIComponent(child).systemManager = this;
			
			if (child is IUIComponent && !IUIComponent(child).document)
				IUIComponent(child).document = document;
			
			if (child is ILayoutManagerClient)
				ILayoutManagerClient(child).nestLevel = nestLevel + 1;
			
			if (child is InteractiveObject)
				if (doubleClickEnabled)
					InteractiveObject(child).doubleClickEnabled = true;
			
			if (child is IUIComponent)
				IUIComponent(child).parentChanged(this);
			
			if (child is IStyleClient )
				IStyleClient(child).regenerateStyleCache(true);
			
			if (child is ISimpleStyleClient)
				ISimpleStyleClient(child).styleChanged(null);
			
			if (child is IStyleClient)
				IStyleClient(child).notifyStyleChangeInChildren(null, true);
		}
		
		private function childAdded(child:DisplayObject):void {
			child.dispatchEvent(new FlexEvent(FlexEvent.ADD));
			
			if (child is IUIComponent)
				IUIComponent(child).initialize();
		}

		private function removingChild(child:DisplayObject):void {
			child.dispatchEvent(new FlexEvent(FlexEvent.REMOVE));
		}
		
		private function childRemoved(child:DisplayObject):void {
			if (child is IUIComponent)
				IUIComponent(child).parentChanged(null);
		}

		private function getSandboxScreen():Rectangle {
			var sandboxRoot:DisplayObject = getSandboxRoot();
			var sandboxScreen:Rectangle;
			
			//if (sandboxRoot == this)
				sandboxScreen = new Rectangle(0, 0, width, height);			
			//else if (sandboxRoot == topLevelSystemManager) {
			//	var sm:DisplayObject = DisplayObject(topLevelSystemManager);
			//	sandboxScreen = new Rectangle(0, 0, sm.width, sm.height);
			//} else {
			//	var me:InterManagerRequest = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST, false, false, "screen");
			//	sandboxRoot.dispatchEvent(me);
			//	sandboxScreen = Rectangle(me.value);
			//}
			
			return sandboxScreen;
		}
		
		private function resizeMouseCatcher():void {
			if (mouseCatcher) {
				try {
					var g:Graphics = mouseCatcher.graphics;
					var s:Rectangle = screen;
					g.clear();
					g.beginFill(0x000000, 0);
					g.drawRect(0, 0, s.width, s.height);
					g.endFill();
				} catch (e:SecurityError) {}
			}
		}
		
		/*private function preloader_initProgressHandler(event:Event):void {
			preloader.removeEventListener(FlexEvent.INIT_PROGRESS, preloader_initProgressHandler);
			deferredNextFrame();
		}*/
		
		private function preloader_preloaderDoneHandler(event:Event):void {
			var app:IUIComponent = topLevelWindow;
			//preloader.removeEventListener(FlexEvent.PRELOADER_DONE, preloader_preloaderDoneHandler);
		
			//removingChild(preloader);
			//this.removeChild(preloader);
			//childRemoved(preloader);
			//preloader = null;
		
			mouseCatcher = new FlexSprite();
			mouseCatcher.name = "mouseCatcher";
			//noTopMostIndex++;
			super.addChildAt(mouseCatcher, 0);	
			resizeMouseCatcher();
			//if (!topLevel) {
			//	mouseCatcher.visible = false;
			//	mask = mouseCatcher;
			//}
			
			//noTopMostIndex++;
			super.addChildAt(DisplayObject(app), 1);
			
			app.dispatchEvent(new FlexEvent(FlexEvent.APPLICATION_COMPLETE));
			dispatchEvent(new FlexEvent(FlexEvent.APPLICATION_COMPLETE));
		}
	}
}