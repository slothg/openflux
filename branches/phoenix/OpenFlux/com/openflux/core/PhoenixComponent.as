package com.openflux.core
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import mx.core.IDeferredInstantiationUIComponent;
	import mx.core.IFlexDisplayObject;
	import mx.core.IInvalidating;
	import mx.core.IUIComponent;
	import mx.core.UIComponentDescriptor;
	import mx.managers.ISystemManager;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.ISimpleStyleClient;
	import mx.styles.IStyleClient;
	
	public class PhoenixComponent extends Sprite 
	implements IFlexDisplayObject, IUIComponent, IInvalidating, ISimpleStyleClient, IStyleClient, IDeferredInstantiationUIComponent
	{
		
		public function get states():Array { return null; }
		public function set states(value:Array):void {}
		
		public function get currentState():String { return null; }
		public function set currentState(value:String):void {}
		
		private var _width:Number; [Bindable]
		override public function get width():Number { return _width; }
		override public function set width(value:Number):void {
			_width = value;
		}
		
		private var _height:Number; [Bindable]
		override public function get height():Number { return _height; }
		override public function set height(value:Number):void {
			_height = value;
		}
		
		// IInvalidation
		
		public function invalidateProperties():void {};
		public function invalidateDisplayList():void {};
		public function invalidateSize():void {}
		public function validateNow():void {}
		
		// assumed (from above)
		protected function createChildren():void {}
		protected function commitProperties():void {}
		protected function measure():void {}
		protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {}
		public function stylesInitialized():void {}
		
		
		// component stuff
		
		public function get enabled():Boolean { return true; }
		public function set enabled(value:Boolean):void {}
		
		
		// uility stuff
		
		public function initialize():void {
			
		}
		
		public function owns(displayObject:DisplayObject):Boolean {
			return false;
		}
		
		public function parentChanged(p:DisplayObjectContainer):void {
			
		}
		
		// meat
		
		public function get document():Object { return null; }
		public function set document(value:Object):void {}
		
		public function get owner():DisplayObjectContainer { return null; }
		public function set owner(value:DisplayObjectContainer):void {}
		
		public function get systemManager():ISystemManager { return null; }
		public function set systemManager(value:ISystemManager):void {}
		
		// gross stuff
		
		public function get focusPane():Sprite { return null; }
		public function set focusPane(value:Sprite):void {}
		
		public function get tweeningProperties():Array { return null; }
		public function set tweeningProperties(value:Array):void {}
		
		public function get isPopUp():Boolean { return false; }
		public function set isPopUp(value:Boolean):void {}
		
		public function get baselinePosition():Number { return 0; }
		
		public function get includeInLayout():Boolean { return true; }
		public function set includeInLayout(value:Boolean):void {}
		
		// measurement stuff
		
		public function get explicitWidth():Number { return 0; }
		public function set explicitWidth(value:Number):void {}
		
		public function get explicitHeight():Number { return 0; }
		public function set explicitHeight(value:Number):void {};
		
		public function get minWidth():Number { return 0; }
		public function set minWidth(value:Number):void {} // implied
		
		public function get minHeight():Number { return 0; }
		public function set minHeight(value:Number):void {} // implied
		
		public function get explicitMinWidth():Number { return 0; }
		public function get explicitMinHeight():Number { return 0; }
		
		public function get explicitMaxWidth():Number { return 0; }
		public function get explicitMaxHeight():Number { return 0; }
		
		public function get maxWidth():Number { return 0; }
		public function get maxHeight():Number { return 0; }
		
		public function get measuredWidth():Number { return 0; }
		public function set measuredWidth(value:Number):void {} // implied
		
		public function get measuredHeight():Number { return 0; }
		public function set measuredHeight(value:Number):void {} // implied
		
		public function get measuredMinWidth():Number { return 0; }
		public function set measuredMinWidth(value:Number):void {}
		
		public function get measuredMinHeight():Number { return 0; }
		public function set measuredMinHeight(value:Number):void {}
		
		public function get percentWidth():Number { return 0; }
		public function set percentWidth(value:Number):void {};
		
		public function get percentHeight():Number { return 0; }
		public function set percentHeight(value:Number):void {};
		
		public function getExplicitOrMeasuredWidth():Number { return 0; }
		public function getExplicitOrMeasuredHeight():Number { return 0; }
		
		
		// uility stuff
		
		public function move(x:Number, y:Number):void {
			
		}
		
		public function setActualSize(newWidth:Number, newHeight:Number):void {
			
		}
		
		public function setVisible(value:Boolean, noEvent:Boolean = false):void {
			
		}
		
		// ISimpleStyleClient
		public function get styleName():Object { return null; }
		public function set styleName(value:Object):void {}
		
		public function styleChanged(styleProp:String):void {}
		
		// IStyleClient
		public function get className():String { return null; }
		
		public function get inheritingStyles():Object { return null; }
		public function set inheritingStyles(value:Object):void {}
		
		public function get nonInheritingStyles():Object { return null; }
		public function set nonInheritingStyles(value:Object):void {}
		
		public function get styleDeclaration():CSSStyleDeclaration { return null; } // CSSStyleDeclaration Ahhh!!!
		public function set styleDeclaration(value:CSSStyleDeclaration):void {}
		
		public function getStyle(styleProp:String):* { return null; }
		public function setStyle(styleProp:String, newValue:*):void {}
		
		public function clearStyle(styleProp:String):void {}
		public function getClassStyleDeclarations():Array { return null; }
		
		public function notifyStyleChangeInChildren(styleProp:String, recursive:Boolean):void {}
		
		public function regenerateStyleCache(recursive:Boolean):void {}
		public function registerEffects(effects:Array /* of String */):void {}
		
		// IDefferredInstantiationUIComponent (Assumed by Flex Containers! wtf?!!!)
		public function set cacheHeuristic(value:Boolean):void {}
		public function get cachePolicy():String { return null; }
		public function get descriptor():UIComponentDescriptor { return null; }
		public function set descriptor(value:UIComponentDescriptor):void {}
		public function get id():String {return null; }
		public function set id(value:String):void {}
		public function createReferenceOnParentDocument(parentDocument:IFlexDisplayObject):void {}
		public function deleteReferenceOnParentDocument(parentDocument:IFlexDisplayObject):void {}
		public function executeBindings(recurse:Boolean = false):void {}
		//public function registerEffects(effects:Array):void {}
	}
}