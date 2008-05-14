package com.openflux.core
{
	
	import com.openflux.utils.MetaStyler;
	
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	use namespace mx_internal;
	
	
	public class FluxComponent extends UIComponent implements IFluxComponent
	{
		
		// private variables
		private var styleNames:Array;
		
		// property backing variables
		private var _view:IFluxView;
		private var _controller:IFluxController;
		
		// invalidation flags
		private var viewChanged:Boolean;
		private var controllerChanged:Boolean;
		
		[StyleBinding]
		public function get view():IFluxView { return _view; }
		public function set view(value:IFluxView):void {
			if(_view != null && contains(_view as UIComponent)) {
				removeChild(_view as UIComponent);
			}
			_view = value;
			viewChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		[StyleBinding]
		public function get controller():IFluxController { return _controller; }
		public function set controller(value:IFluxController):void {
			_controller = value;
			controllerChanged = true;
			invalidateProperties();
		}
		
		// should be moved/updated
		/*
		override public function set currentState(value:String):void {
			updateState(value);
			updateState(value, _view);
		}
		*/
		//******************************************
		// Constructor
		//******************************************
		
		public function FluxComponent():void {
			super();
		}
		
		//******************************************
		// Framework Overrides
		//******************************************
		
		override protected function commitProperties():void {
			super.commitProperties();
			if(viewChanged) {
				view.component = this;
				addChild(view as UIComponent);
				MetaStyler.initialize(view, this);
				viewChanged = false;
			}
			if(controllerChanged) {
				controller.component = this;
				MetaStyler.initialize(controller, this);
				controllerChanged = false;
			}
		}
		
		override protected function measure():void {
			super.measure();
			if(view) {
				measuredMinWidth = view.minWidth;
				measuredMinHeight = view.minHeight;
				measuredWidth = view.measuredWidth;
				measuredHeight = view.measuredHeight;
			}
		}
		
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(_view) {
				_view.width = unscaledWidth;
				_view.height =  unscaledHeight;
			}
		}
		
		override public function styleChanged(styleProp:String):void {
			super.styleChanged(styleProp);
			MetaStyler.updateStyle(styleProp, this);
			if(view) MetaStyler.updateStyle(styleProp, view, this);
			if(controller) MetaStyler.updateStyle(styleProp, controller, this);
			/*switch(styleProp) {
				case "view":
					updateViewStyle();
					break;
				case "controller":
					updateControllerStyle();
					break;
				case "layout":
					trace("me");
				default:
					if(view) view.styleChanged(styleProp);
					if(controller) controller.styleChanged(styleProp);
					break;
			}*/
		}
		
		override public function stylesInitialized():void {
			//updateViewStyle();
			//updateControllerStyle();
			MetaStyler.initialize(this);
		}
		
		//********************************************
		// UIComponent upgrades
		//********************************************
		
		override public function set styleName(value:Object):void {
			if(value is String) {
				styleNames = (value as String).split(" ");
			}
			super.styleName = value;
		}
		
		
		//********************************************
		// mx_internal hacking
		//********************************************
		
		// adds support for multiple styleNames (space seperated)
		// todo: test support for runtime/programmatic style updates
		override mx_internal function initProtoChain():void {
			super.initProtoChain();
			if(styleNames) {
			var length:int = styleNames.length;
			for(var i:int = 0; i < length; i++) {
				var style:String = styleNames[i] as String;
				var classSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("." + style);
				if (classSelector) {
					inheritingStyles = classSelector.addStyleToProtoChain(inheritingStyles, this);
					nonInheritingStyles = classSelector.addStyleToProtoChain(nonInheritingStyles, this);
					if (classSelector.effects) {
						registerEffects(classSelector.effects);
					}
				}
			}
			
			// Finally, we'll add the in-line styles
			// to the head of the proto chain.
			inheritingStyles = styleDeclaration ? styleDeclaration.addStyleToProtoChain(inheritingStyles, this) : inheritingStyles;
			nonInheritingStyles = styleDeclaration ? styleDeclaration.addStyleToProtoChain(nonInheritingStyles, this) : nonInheritingStyles;
			}
		}
		
		/*
		protected function updateState(token:String, target:Object = null):void {
			if(target == null) {
				target = this;
			}
			if(target is UIComponent) {
				var component:UIComponent = target as UIComponent;
				for each(var state:State in component.states) {
					if(state.name == token) {
						component.currentState = token;
					}
				}
			}
		}
		*//*
		private function updateViewStyle():void {
			var o:Object;
			var C:Class = getStyle("view");
			if(C) {
				o = new C();
			}
			if(o is IFluxView) {
				o.styleName = this;
				view = o as IFluxView;
			}
		}
		
		private function updateControllerStyle():void {
			var o:Object;
			var C:Class = getStyle("controller");
			if(C) {
				o = new C();
			}
			if(o is IFluxController) {
				o.styleName = this;
				controller = o as IFluxController;
			}
		}
		*/
	}
}