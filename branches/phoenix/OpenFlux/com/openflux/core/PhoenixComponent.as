package com.openflux.core
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import mx.core.IChildList;
	import mx.core.IDeferredInstantiationUIComponent;
	import mx.core.IFlexDisplayObject;
	import mx.core.IInvalidating;
	import mx.core.IRawChildrenContainer;
	import mx.core.IUIComponent;
	import mx.core.IUITextField;
	import mx.managers.ILayoutManagerClient;
	import mx.managers.ISystemManager;
	import mx.styles.ISimpleStyleClient;
	import mx.styles.IStyleClient;
	
	import mx.core.UIComponentDescriptor;
	import mx.core.UIComponentGlobals;
	import mx.states.State;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	import mx.events.FlexEvent;
	import mx.events.MoveEvent;
	import mx.events.ResizeEvent;
	import mx.events.StateChangeEvent;
	
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	public class PhoenixComponent extends Sprite 
	implements IFlexDisplayObject, IUIComponent, IInvalidating, ISimpleStyleClient, IStyleClient, IDeferredInstantiationUIComponent, ILayoutManagerClient, IChildList
	{

		// ***************************************************************
		// States
		// ***************************************************************
	
		private var _states:Array;
		[ArrayElementType("mx.states.State")]
		public function get states():Array { return _states; }
		public function set states(value:Array):void {
			_states = value;
		}
		
		private var _currentState:String;
		[Bindable("currentStateChange")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void {
			var oldState:String = _currentState;
			var commonBaseState:String = "";
			
			dispatchEvent(new StateChangeEvent(StateChangeEvent.CURRENT_STATE_CHANGING, false, false, _currentState, value));
			
			var state:State = getState(value);
			while (state) {
				state
				state = getState(state.basedOn);
			}
			
			if (isBaseState(_currentState))
            dispatchEvent(new FlexEvent(FlexEvent.EXIT_STATE));
					
	        removeState(_currentState, commonBaseState);
	        
			_currentState = value;
			
			if (isBaseState(_currentState))
				dispatchEvent(new FlexEvent(FlexEvent.ENTER_STATE));
			else
				applyState(_currentState, commonBaseState);

			dispatchEvent(new StateChangeEvent(StateChangeEvent.CURRENT_STATE_CHANGE, false, false, oldState, _currentState));
		}
		
		private function isBaseState(stateName:String):Boolean {
			return !stateName || stateName == "";
		}
		
		private function getState(stateName:String):State {
			if (!states || isBaseState(stateName))
				return null;

			for (var i:int = 0; i < states.length; i++) {
				if (states[i].name == stateName)
				return states[i];
			}
			
			return null;
		}
		
		private function removeState(stateName:String, lastState:String):void {
			var state:State = getState(stateName);
		
			if (stateName == lastState)
				return;
		
			if (state) {
				state.dispatchExitState();
				
				var overrides:Array = state.overrides;
			
				for (var i:int = overrides.length; i; i--)
					overrides[i-1].remove(this);
			
				if (state.basedOn != lastState)
					removeState(state.basedOn, lastState);
			}
		}
		
		private function applyState(stateName:String, lastState:String):void {
			var state:State = getState(stateName);
		
			if (stateName == lastState)
				return;
		
			if (state) {
				if (state.basedOn != lastState)
					applyState(state.basedOn, lastState);
		
				var overrides:Array = state.overrides;
		
				for (var i:int = 0; i < overrides.length; i++)
					overrides[i].apply(this);
		
				state.dispatchEnterState();
			}
		}

		// ***************************************************************
		// Sizes & Measurement
		// ***************************************************************

		private var oldWidth:Number = 0;
		private var oldHeight:Number = 0;

		private var _width:Number = 0; [Bindable] [PercentProxy("percentWidth")]
		override public function get width():Number { return _width; }
		override public function set width(value:Number):void {
	        if (explicitWidth != value) {
	            explicitWidth = value;
	            invalidateSize();
	        }
	
	        if (_width != value) {
	            invalidateProperties();
	            invalidateDisplayList();
	            invalidateParentSizeAndDisplayList();
	
	            _width = value;
	        }
		}
		
		private var _height:Number = 0; [Bindable] [PercentProxy("percentHeight")]
		override public function get height():Number { return _height; }
		override public function set height(value:Number):void {
	        if (explicitHeight != value) {
	        	explicitHeight = value;
	            invalidateSize();
	        }
	
	        if (_height != value) {
	            invalidateProperties();
	            invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
	
	            _height = value;
	        }
		}
		
		protected function get unscaledWidth():Number { return width / Math.abs(scaleX); }
		protected function get unscaledHeight():Number { return height / Math.abs(scaleY); }

		private var _explicitWidth:Number = 0; [Bindable]
		public function get explicitWidth():Number { return _explicitWidth; }
		public function set explicitWidth(value:Number):void {
			if (_explicitWidth != value) {            
				if (!isNaN(value))
					_percentWidth = NaN;
			
				_explicitWidth = value;
			
				invalidateSize();
				invalidateParentSizeAndDisplayList();
			}
		}
		
		private var _explicitHeight:Number = 0;
		public function get explicitHeight():Number { return _explicitHeight; }
		public function set explicitHeight(value:Number):void {
			if (_explicitHeight != value) {            
				if (!isNaN(value))
					_percentHeight = NaN;
			
				_explicitHeight = value;
			
				invalidateSize();
				invalidateParentSizeAndDisplayList();
			}
		};
		
		public function get minWidth():Number { return !isNaN(explicitMinWidth) ? explicitMinWidth : measuredMinWidth; }
		public function set minWidth(value:Number):void {
			if (explicitMinWidth != value)
				explicitMinWidth = value;
		}
		
		public function get minHeight():Number { return !isNaN(explicitMinHeight) ? explicitMinHeight : measuredMinHeight; }
		public function set minHeight(value:Number):void {
			if (explicitMinHeight != value)
				explicitMinHeight = value;
		}
		
		public function get maxWidth():Number { return !isNaN(explicitMaxWidth) ? explicitMaxWidth : 10000; }
		public function set maxWidth(value:Number):void {
			if (explicitMaxWidth != value)
				explicitMaxWidth = value;
		}
		
		public function get maxHeight():Number { return !isNaN(explicitMaxHeight) ? explicitMaxHeight : 10000; }
		public function set maxHeight(value:Number):void {
			if (explicitMaxHeight != value)
				explicitMaxHeight = value;
		}
				
		private var _explicitMinWidth:Number = 0;
		public function get explicitMinWidth():Number { return _explicitMinWidth; }
		public function set explicitMinWidth(value:Number):void {
			if (_explicitMinWidth != value) {
				_explicitMinWidth = value;
				invalidateSize();
				invalidateParentSizeAndDisplayList();
			}
		}
		
		private var _explicitMinHeight:Number = 0;
		public function get explicitMinHeight():Number { return _explicitMinHeight; }
		public function set explicitMinHeight(value:Number):void {
			if (_explicitMinWidth != value) {
				_explicitMinWidth = value;
				invalidateSize();
				invalidateParentSizeAndDisplayList();
			}
		}
		
		private var _explicitMaxWidth:Number = 0;
		public function get explicitMaxWidth():Number { return _explicitMaxWidth; }
		public function set explicitMaxWidth(value:Number):void {
			if (_explicitMaxWidth != value) {
				_explicitMaxWidth = value;
				invalidateSize();
				invalidateParentSizeAndDisplayList();
			}
		}
		
		private var _explicitMaxHeight:Number = 0;
		public function get explicitMaxHeight():Number { return _explicitMaxHeight; }
		public function set explicitMaxHeight(value:Number):void {
			if (_explicitMaxHeight != value) {
				_explicitMaxHeight = value;
				invalidateSize();
				invalidateParentSizeAndDisplayList();
			}
		}
		
		private var _measuredWidth:Number = 0;
		public function get measuredWidth():Number { return _measuredWidth; }
		public function set measuredWidth(value:Number):void {
			_measuredWidth = value;
		}
		
		private var _measuredHeight:Number = 0;
		public function get measuredHeight():Number { return _measuredHeight; }
		public function set measuredHeight(value:Number):void {
			_measuredHeight = value;
		}
		
		private var _measuredMinWidth:Number = 0;
		public function get measuredMinWidth():Number { return _measuredMinWidth; }
		public function set measuredMinWidth(value:Number):void {
			_measuredMinWidth = value;
		}
		
		private var _measuredMinHeight:Number = 0;
		public function get measuredMinHeight():Number { return _measuredMinHeight; }
		public function set measuredMinHeight(value:Number):void {
			_measuredMinHeight = value;
		}
		
		private var _percentWidth:Number = 0;
		public function get percentWidth():Number { return _percentWidth; }
		public function set percentWidth(value:Number):void {
			if (_percentWidth != value) {
				if (!isNaN(value))
					_explicitWidth = NaN;
				_percentWidth = value;
				invalidateParentSizeAndDisplayList();
			}
		}
		
		private var _percentHeight:Number = 0;
		public function get percentHeight():Number { return _percentHeight; }
		public function set percentHeight(value:Number):void {
			if (_percentHeight != value) {
				if (!isNaN(value))
					_explicitHeight = NaN;
				_percentHeight = value;
				invalidateParentSizeAndDisplayList();
			}
		};
		
		public function getExplicitOrMeasuredWidth():Number {
			return !isNaN(explicitWidth) ? _explicitWidth : _measuredWidth;
		}
		
		public function getExplicitOrMeasuredHeight():Number {
			return !isNaN(explicitHeight) ? _explicitHeight : _measuredHeight;
		}
		
		public function setActualSize(newWidth:Number, newHeight:Number):void {
			this.width = newWidth;
			this.height = newHeight;
			
			invalidateDisplayList();
            dispatchResizeEvent();
		}

		private var invalidateSizeFlag:Boolean;
		public function invalidateSize():void {
			invalidateSizeFlag = true;
			
			if (parent && UIComponentGlobals.layoutManager)
				UIComponentGlobals.layoutManager.invalidateSize(this);
		}
		
		public function validateSize(recursive:Boolean=false):void
		{
			trace("validate size");
			if (recursive) {
				for (var i:int = 0; i < numChildren; i++) {
					var child:DisplayObject = getChildAt(i);
					if (child is ILayoutManagerClient)
						(child as ILayoutManagerClient ).validateSize(true);
				}
			}
			
			if (invalidateSizeFlag) {
				if (isNaN(explicitWidth) || isNaN(explicitHeight)) {
					measure();
				
					if (!isNaN(explicitMinWidth) && measuredWidth < explicitMinWidth)
						measuredWidth = explicitMinWidth;
					if (!isNaN(explicitMaxWidth) && measuredWidth > explicitMaxWidth)
						measuredWidth = explicitMaxWidth;
					if (!isNaN(explicitMinHeight) && measuredHeight < explicitMinHeight)
						measuredHeight = explicitMinHeight;
					if (!isNaN(explicitMaxHeight) && measuredHeight > explicitMaxHeight)
						measuredHeight = explicitMaxHeight;
				}
				else
				{
					_measuredMinWidth = 0;
					_measuredMinHeight = 0;
				}
				
				invalidateSizeFlag = false;
				
				if (includeInLayout) {
					invalidateDisplayList();
					invalidateParentSizeAndDisplayList();
				}
        	}
		}
		
		protected function measure():void {
			measuredMinWidth = 0;
			measuredMinHeight = 0;
			measuredWidth = 0;
			measuredHeight = 0;
		}

		private function dispatchResizeEvent():void
		{
			var resizeEvent:ResizeEvent = new ResizeEvent(ResizeEvent.RESIZE);
			resizeEvent.oldWidth = oldWidth;
			resizeEvent.oldHeight = oldHeight;
			dispatchEvent(resizeEvent);
			
			oldWidth = width;
			oldHeight = height;
		}

		// ***************************************************************
		// Position
		// ***************************************************************

		private var oldX:Number;
		private var oldY:Number;
		
		public function move(x:Number, y:Number):void {
			var changed:Boolean = false;
			
			if (x != super.x) {
				super.x = x;
				changed = true;
			}
			
			if (y != super.y) {
				super.y = y;
				changed = true;
			}
			
			if (changed)
				dispatchMoveEvent();
		}
		
		private function dispatchMoveEvent():void
		{
			var moveEvent:MoveEvent = new MoveEvent(MoveEvent.MOVE);
			moveEvent.oldX = oldX;
			moveEvent.oldY = oldY;
			dispatchEvent(moveEvent);
			
			oldX = x;
			oldY = y;
		}

		// ***************************************************************
		// Properties
		// ***************************************************************

		private var invalidatePropertiesFlag:Boolean;
		public function invalidateProperties():void {
			invalidatePropertiesFlag = true;
			
			if (parent && UIComponentGlobals.layoutManager)
				UIComponentGlobals.layoutManager.invalidateProperties(this);
		}
		
		public function validateProperties():void
		{
			trace("validate properties");
			if (invalidatePropertiesFlag) {
				commitProperties();
				invalidatePropertiesFlag = false;
			}
		}
		
		protected function commitProperties():void {
			if (x != oldX || y != oldY)
				dispatchMoveEvent();
			
			if (width != oldWidth || height != oldHeight)
				dispatchResizeEvent();
		}
		
		// ***************************************************************
		// Display List
		// ***************************************************************
		
		private var invalidateDisplayListFlag:Boolean;
		public function invalidateDisplayList():void {
			invalidateDisplayListFlag = true;
			
			if (parent && UIComponentGlobals.layoutManager)
				UIComponentGlobals.layoutManager.invalidateDisplayList(this);
		}
		
		public function validateDisplayList():void
		{
			trace("validate display list");
			if (invalidateDisplayListFlag) {
				var unscaledWidth:Number = scaleX == 0 ? 0 : width / scaleX;
				var unscaledHeight:Number = scaleY == 0 ? 0 : height / scaleY;

				updateDisplayList(unscaledWidth,unscaledHeight);
				invalidateDisplayListFlag = false;
			}
		}
		
		protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {}

		// ***************************************************************
		// Overrides
		// ***************************************************************
		
		private function addingChild(child:DisplayObject):void
		{
			var formerParent:DisplayObjectContainer = child.parent;
			if (formerParent && !(formerParent is Loader))
				formerParent.removeChild(child);
			
			if (child is IUIComponent)
            	IUIComponent(child).parentChanged(this);
            	
	        if (child is ILayoutManagerClient)
	            ILayoutManagerClient(child).nestLevel = nestLevel + 1;
	        else if (child is IUITextField)
	            IUITextField(child).nestLevel = nestLevel + 1;
	            
			if (child is InteractiveObject)
            	if (doubleClickEnabled)
	                InteractiveObject(child).doubleClickEnabled = true;

			if (child is IStyleClient)
				IStyleClient(child).regenerateStyleCache(true);
			if (child is ISimpleStyleClient)
				ISimpleStyleClient(child).styleChanged(null);
			if (child is IStyleClient)
				IStyleClient(child).notifyStyleChangeInChildren(null, true);
		}
		
		private function addedChild(child:DisplayObject):void
		{
			if (child is IUIComponent)
				IUIComponent(child).initialize(); 
		}
		
		override public function addChild(child:DisplayObject):DisplayObject {
			addingChild(child);
			super.addChild(child);
			addedChild(child);
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			addingChild(child);
			super.addChildAt(child, index);
			addedChild(child);
			return child;
		}
		
		private function removingChild(child:DisplayObject):void {
			
		}
		
		private function removedChild(child:DisplayObject):void {
			if (child is IUIComponent) {
				IUIComponent(child).parentChanged(null);
			}
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject {
			removingChild(child);
			super.removeChild(child);
			removedChild(child);
			return child;
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			var child:DisplayObject = getChildAt(index);
			removingChild(child);
			super.removeChild(child);
			removedChild(child);
			return child;
		}

		// ***************************************************************
		// All Other Stuff
		// ***************************************************************
		
		public function validateNow():void {
			 UIComponentGlobals.layoutManager.validateClient(this);
		}
		
		// assumed (from above)
		protected function createChildren():void {}

		protected function childrenCreated():void {
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		public function stylesInitialized():void {}
		
		// component stuff
		
		private var _enabled:Boolean; [Bindable("enabledChanged")]
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void {
			_enabled = value;
			invalidateDisplayList();
			dispatchEvent(new Event("enabledChanged"));
		}
		
		
		// uility stuff
		
		public function initialize():void {
			if (initialized)
				return;
			
			dispatchEvent(new FlexEvent(FlexEvent.PREINITIALIZE));
			
			createChildren();
			childrenCreated();
		}
		
		public function owns(displayObject:DisplayObject):Boolean { return false; }
		
		public function parentChanged(p:DisplayObjectContainer):void {
		}
		
		// meat
		
		private var _document:Object;
		public function get document():Object { return _document; }
		public function set document(value:Object):void {
			_document = value;
		}
		
		private var _owner:DisplayObjectContainer;
		public function get owner():DisplayObjectContainer { return _owner ? _owner : parent; }
		public function set owner(value:DisplayObjectContainer):void {
			_owner = value;
		}
		
		private var _systemManager:ISystemManager;
		public function get systemManager():ISystemManager { return _systemManager; }
		public function set systemManager(value:ISystemManager):void {
			_systemManager = value;
		}
		
		// gross stuff
		
		private var _focusPane:Sprite;
		public function get focusPane():Sprite { return _focusPane; }
		public function set focusPane(value:Sprite):void {
			_focusPane = value;
		}
		
		private var _tweeningProperties:Array;
		public function get tweeningProperties():Array { return _tweeningProperties; }
		public function set tweeningProperties(value:Array):void {
			_tweeningProperties = value;
		}
		
		private var _isPopUp:Boolean;
		public function get isPopUp():Boolean { return _isPopUp; }
		public function set isPopUp(value:Boolean):void {
			_isPopUp = value;
		}
		
		private var _baselinePosition:Number;
		public function get baselinePosition():Number { return _baselinePosition; }
		
		private var _includeInLayout:Boolean = true; [Bindable]
		public function get includeInLayout():Boolean { return _includeInLayout; }
		public function set includeInLayout(value:Boolean):void {
			_includeInLayout = value;
			if (_includeInLayout != value) {
				_includeInLayout = value;
				
				invalidateParentSizeAndDisplayList();
			}
		}
		
		override public function get visible():Boolean { return super.visible; }
		override public function set visible(value:Boolean):void {
			setVisible(value);
		}
		
		public function setVisible(value:Boolean, event:Boolean=true):void
		{
			if (visible != value) {
				super.visible = value;
				if (initialized)
					dispatchEvent(new FlexEvent(value ? FlexEvent.SHOW : FlexEvent.HIDE));
			}	
		}
		
		// ISimpleStyleClient
		
		private var _styleName:Object;
		public function get styleName():Object { return _styleName; }
		public function set styleName(value:Object):void {
			_styleName = value;
		}
		
		public function styleChanged(styleProp:String):void {
			if (!styleProp || styleProp == "styleName" || StyleManager.isSizeInvalidatingStyle(styleProp)) {
				invalidateSize();
			}
			
			invalidateDisplayList();
			
			if (parent is IInvalidating) {
				if (StyleManager.isParentSizeInvalidatingStyle(styleProp))
					IInvalidating(parent).invalidateSize();
			
				if (StyleManager.isParentDisplayListInvalidatingStyle(styleProp))
					IInvalidating(parent).invalidateDisplayList();
			}
		}
		
		// IStyleClient
		
		private var _className:String;
		public function get className():String { return _className; }
		public function set className(value:String):void {
			_className = value;
		}
		
		private var _inheritingStyles:Object = {};
		public function get inheritingStyles():Object { return _inheritingStyles; }
		public function set inheritingStyles(value:Object):void {
			_inheritingStyles = value;
		}
		
		private var _nonInheritingStyles:Object = {};
		public function get nonInheritingStyles():Object { return _nonInheritingStyles; }
		public function set nonInheritingStyles(value:Object):void {
			_nonInheritingStyles = value;
		}
		
		private var _styleDeclaration:CSSStyleDeclaration;
		public function get styleDeclaration():CSSStyleDeclaration { return _styleDeclaration; } // CSSStyleDeclaration Ahhh!!!
		public function set styleDeclaration(value:CSSStyleDeclaration):void {
			_styleDeclaration = value;
		}
		
		public function getStyle(styleProp:String):* {
			return StyleManager.inheritingStyles[styleProp] ? _inheritingStyles[styleProp] : _nonInheritingStyles[styleProp];
		}
		public function setStyle(styleProp:String, newValue:*):void {
			if (styleProp == "styleName") {
				styleName = newValue;
	            return;
			}
			
			var isInheritingStyle:Boolean = StyleManager.isInheritingStyle(styleProp);
			var isProtoChainInitialized:Boolean = false; //inheritingStyles != UIComponent.STYLE_UNINITIALIZED;
			var valueChanged:Boolean = getStyle(styleProp) != newValue;
        
			if (!_styleDeclaration) {
				_styleDeclaration = new CSSStyleDeclaration();
				_styleDeclaration.mx_internal::setStyle(styleProp, newValue);
				
				if (isProtoChainInitialized)
					regenerateStyleCache(isInheritingStyle);
			} else {
				_styleDeclaration.mx_internal::setStyle(styleProp, newValue);
			}

	        if (isProtoChainInitialized && valueChanged) {
	            styleChanged(styleProp);
	            notifyStyleChangeInChildren(styleProp, isInheritingStyle);
	        }
		}
		
		public function clearStyle(styleProp:String):void {
			 setStyle(styleProp, undefined);
		}
	
    public function notifyStyleChangeInChildren(
                        styleProp:String, recursive:Boolean):void
    {

        var n:int = numChildren;
        for (var i:int = 0; i < n; i++)
        {
            var child:ISimpleStyleClient = getChildAt(i) as ISimpleStyleClient;
            if (child)
            {
                child.styleChanged(styleProp);

                if (child is IStyleClient)
                    IStyleClient(child).notifyStyleChangeInChildren(styleProp, recursive);
            }
        }
    }
		

    public function getClassStyleDeclarations():Array
    {
        var myApplicationDomain:ApplicationDomain;
        
            var myRoot:DisplayObject = root; //SystemManager.getSWFRoot(this);
            if (!myRoot)
                return [];
            myApplicationDomain = myRoot.loaderInfo.applicationDomain;

        var className:String = flash.utils.getQualifiedClassName(this)
        className = className.replace("::", ".");
        var cache:Array;
        cache = StyleManager.typeSelectorCache[className];
        if (cache)
            return cache;
        
        // trace("getClassStyleDeclaration", className);
        var decls:Array = [];
        var classNames:Array = [];
        var caches:Array = [];
        var declcache:Array = [];

        while (className != null && className != "com.openflux.core.PhoenixComponent")
        {
            var s:CSSStyleDeclaration;
            cache = StyleManager.typeSelectorCache[className];
            if (cache)
            {
                decls = decls.concat(cache);
                break;
            }

            s = StyleManager.getStyleDeclaration(className);
            
            if (s)
            {
                decls.unshift(s);
                // we found one so the next set define the selectors for this
                // found class and its ancestors.  Save the old list and start
                // a new list
                classNames.push(className);
                caches.push(classNames);
                declcache.push(decls);
                decls = [];
                classNames = [];
                // trace("   ", className);
                // break;
            }
            else
                classNames.push(className);

            try
            {
                className = flash.utils.getQualifiedSuperclassName(myApplicationDomain.getDefinition(className));
                className = className.replace("::", ".");
            }
            catch(e:ReferenceError)
            {
                className = null;
            }
        }

        caches.push(classNames);
        declcache.push(decls);
        decls = [];
        while (caches.length)
        {
            classNames = caches.pop();
            decls = decls.concat(declcache.pop());
            while (classNames.length)
            {
                StyleManager.typeSelectorCache[classNames.pop()] = decls;
            }
        }

        return decls;
    }

    public function regenerateStyleCache(recursive:Boolean):void
    {
        // Regenerate the proto chain for this object
        initProtoChain();

        var childList:IChildList =
            this is IRawChildrenContainer ?
            IRawChildrenContainer(this).rawChildren :
            IChildList(this);
        
        // Recursively call this method on each child.
        var n:int = childList.numChildren;
        for (var i:int = 0; i < n; i++)
        {
            var child:DisplayObject = childList.getChildAt(i);

            if (child is IStyleClient)
            {
                // Does this object already have a proto chain? 
                // If not, there's no need to regenerate a new one.
                if (IStyleClient(child).inheritingStyles !=
                    {})
                {
                    IStyleClient(child).regenerateStyleCache(recursive);
                }
            }
        }
    }

		
		    mx_internal function initProtoChain():void
    {
        //trace("initProtoChain", name);

        var classSelector:CSSStyleDeclaration;

        if (styleName)
        {
            if (styleName is CSSStyleDeclaration)
            {
                // Get the style sheet referenced by the styleName property
                classSelector = CSSStyleDeclaration(styleName);
            }
            else if (styleName is IFlexDisplayObject || styleName is IStyleClient)
            {
                // If the styleName property is a UIComponent, then there's a
                // special search path for that case.
                
                mx.styles.StyleProtoChain.initProtoChainForUIComponentStyleName(this);
                return;
            }
            else if (styleName is String)
            {
                // Get the style sheet referenced by the styleName property
                classSelector =
                    StyleManager.getStyleDeclaration("." + styleName);
            }
        }

        // To build the proto chain, we start at the end and work forward.
        // Referring to the list at the top of this function, we'll start by
        // getting the tail of the proto chain, which is:
        //  - for non-inheriting styles, the global style sheet
        //  - for inheriting styles, my parent's style object
        var nonInheritChain:Object = StyleManager.stylesRoot;
        
        if (nonInheritChain && nonInheritChain.effects)
            registerEffects(nonInheritChain.effects);
        
        var p:IStyleClient = parent as IStyleClient;
        if (p)
        {
            var inheritChain:Object = p.inheritingStyles;
            if (inheritChain == {})
                inheritChain = nonInheritChain;
        }
        else
        {
                inheritChain = StyleManager.stylesRoot;
        }

        // Working backwards up the list, the next element in the
        // search path is the type selector
        var typeSelectors:Array = getClassStyleDeclarations();
        var n:int = typeSelectors.length;
        for (var i:int = 0; i < n; i++)
        {
            var typeSelector:CSSStyleDeclaration = typeSelectors[i];
            inheritChain =
                typeSelector.addStyleToProtoChain(inheritChain, this);

            nonInheritChain =
                typeSelector.addStyleToProtoChain(nonInheritChain, this);
            
            if (typeSelector.effects)
                registerEffects(typeSelector.effects);
        }

        // Next is the class selector
        if (classSelector)
        {
            inheritChain =
                classSelector.addStyleToProtoChain(inheritChain, this);

            nonInheritChain =
                classSelector.addStyleToProtoChain(nonInheritChain, this);
            
            if (classSelector.effects)
                registerEffects(classSelector.effects);
        }

        // Finally, we'll add the in-line styles
        // to the head of the proto chain.
        inheritingStyles =
            _styleDeclaration ?
            _styleDeclaration.addStyleToProtoChain(inheritChain, this) :
            inheritChain;

        nonInheritingStyles =
            _styleDeclaration ?
            _styleDeclaration.addStyleToProtoChain(nonInheritChain, this) :
            nonInheritChain;
    }
		
		
		// IDefferredInstantiationUIComponent (Assumed by Flex Containers! wtf?!!!)
		
		public function set cacheHeuristic(value:Boolean):void {}
		public function get cachePolicy():String { return null; }
		
		private var _descriptor:UIComponentDescriptor;
		public function get descriptor():UIComponentDescriptor { return _descriptor; }
		public function set descriptor(value:UIComponentDescriptor):void {
			_descriptor = value;
		}

		private var _id:String;
		public function get id():String {return _id; }
		public function set id(value:String):void {
			_id = value;
		}

		public function createReferenceOnParentDocument(parentDocument:IFlexDisplayObject):void {}
		public function deleteReferenceOnParentDocument(parentDocument:IFlexDisplayObject):void {}
		public function executeBindings(recurse:Boolean = false):void {}
		public function registerEffects(effects:Array):void {}
		
		// ILayoutManagerClient
		
		private var _initialized:Boolean = false;
		public function get initialized():Boolean { return _initialized; }
		public function set initialized(value:Boolean):void {
			_initialized = value;
		}
		
		private var _nestLevel:int;
		public function get nestLevel():int { return _nestLevel; }
		public function set nestLevel(value:int):void {
			_nestLevel = value;
		}
		
		private var _processedDescriptors:Boolean;
		public function get processedDescriptors():Boolean { return _processedDescriptors; }
		public function set processedDescriptors(value:Boolean):void {
			_processedDescriptors = value;
			if (value)
				dispatchEvent(new FlexEvent(FlexEvent.INITIALIZE));
		}
		
		private var _updateCompletePendingFlag:Boolean;
		public function get updateCompletePendingFlag():Boolean { return _updateCompletePendingFlag; }
		public function set updateCompletePendingFlag(value:Boolean):void {
			_updateCompletePendingFlag = value;
		}
		
		// My own helper method
		private function invalidateParentSizeAndDisplayList():void
		{
			var p:IInvalidating = parent as IInvalidating;
			if (p && includeInLayout) {
				p.invalidateSize();
				p.invalidateDisplayList();
			}
		}
	}
}