package com.openflux.core
{
	
	import com.openflux.utils.MetaStyler;
	
	import flash.display.DisplayObject;
	
	import mx.core.IInvalidating;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.managers.ILayoutManagerClient;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	use namespace mx_internal;
	
	[DefaultProperty("capacitor")]
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
		
		public function get capacitor():Array { return [view, controller]; }
		public function set capacitor(value:Array):void {
			for each(var item:Object in value) {
				if(item is IFluxView) {
					view = item as IFluxView;
				}
				if(item is IFluxController) {
					controller = item as IFluxController;
				}
			}
		}
		
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
		
		private var _z:Number = 0;
		[Bindable]
		public function get z():Number { return _z; }
		public function set z(value:Number):void { _z = value; }
		
		private var _rotationX:Number = 0;
		[Bindable]
		public function get rotationX():Number { return _rotationX; } 
		public function set rotationX(value:Number):void { _rotationX = value; }
		
		private var _rotationY:Number = 0;
		[Bindable]
		public function get rotationY():Number { return _rotationY; }
		public function set rotationY(value:Number):void { _rotationY = value; }
		
		private var _rotationZ:Number = 0;
		[Bindable]
		public function get rotationZ():Number { return _rotationZ; }
		public function set rotationZ(value:Number):void { _rotationZ = value; }
		
		//******************************************
		// Constructor
		//******************************************
		
		/** @private */
		public function FluxComponent():void {
			super();
			x = 0;
			y = 0;
		}
		
		
		//***************************************************
		// Framework Overrides
		//***************************************************
		
		/** @private */
		override protected function commitProperties():void {
			super.commitProperties();
			if(viewChanged) {
				view.component = this;
				//(view as UIComponent).styleName = this;
				addChild(view as UIComponent);
				/*this.measuredWidth = view.measuredWidth;
				this.measuredHeight = view.measuredHeight;
				this.measuredMinWidth = view.measuredMinWidth;
				this.measuredMinHeight = view.measuredMinHeight;*/
				MetaStyler.initialize(view, this);
				viewChanged = false;
			}
			if(controllerChanged && controller) {
				controller.component = this;
				MetaStyler.initialize(controller, this);
				controllerChanged = false;
			}
		}
		
		/** @private */
		override protected function measure():void {
			super.measure();
			if(view) {				
				measuredWidth = view.getExplicitOrMeasuredWidth();
				measuredHeight = view.getExplicitOrMeasuredHeight();
				measuredMinWidth = isNaN( view.explicitWidth ) ? view.minWidth : view.explicitWidth;
				measuredMinHeight = isNaN( view.explicitHeight ) ? view.minHeight : view.explicitHeight;
			}
		}
		
		/** @private */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(view) {
				view.setActualSize(unscaledWidth, unscaledHeight);
				UIComponent(view).invalidateDisplayList();
			}
		}
		
		/** @private */
		override public function styleChanged(styleProp:String):void {
			super.styleChanged(styleProp);
			MetaStyler.updateStyle(styleProp, this);
			if(view) MetaStyler.updateStyle(styleProp, view, this);
			if(controller) MetaStyler.updateStyle(styleProp, controller, this);
		}
		
		/** @private */
		override public function stylesInitialized():void {
			MetaStyler.initialize(this);
		}
		
		//********************************************
		// UIComponent upgrades
		//********************************************
		
		/** @private */
		override public function set styleName(value:Object):void {
			if(value is String) {
				styleNames = (value as String).split(" ");
			}
			super.styleName = value;
		}
		
		/** @private */
		/*
		override public function validateSize(recursive:Boolean = false):void {
			if (recursive) {
				for (var i:int = 0; i < numChildren; i++) {
					var child:DisplayObject = getChildAt(i);
					if (child is ILayoutManagerClient )
						(child as ILayoutManagerClient ).validateSize(true);
				}
			}
			
			if (invalidateSizeFlag) {
				var sizeChanging:Boolean = measureSizes();
				if (sizeChanging && includeInLayout) {
					invalidateDisplayList();
					var p:IInvalidating = parent as IInvalidating;
					if (p) {
						p.invalidateSize();
						p.invalidateDisplayList();
					}
				}
			}
		}
		*/
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
		
		//private var oldMinWidth:Number, oldMinHeight:Number;
		//private var oldExplicitWidth:Number, oldExplicitHeight:Number;
		
		/** @private */
		/*
		private function measureSizes():Boolean {
			var changed:Boolean = false;
			//this.validateSize();
			if (!invalidateSizeFlag) 
				return changed;
			
			var scalingFactor:Number;
			var newValue:Number;
			
			// We can skip the measure function if the object's width and height
			// have been explicitly specified (e.g.: the object's MXML tag has
			// attributes like width="50" and height="100").
			//
			// If an object's width and height have been explicitly specified,
			// then the explicitWidth and explicitHeight properties contain
			// Numbers (as opposed to NaN)
			//if (isNaN(explicitWidth) || isNaN(explicitHeight)) {
				var xScale:Number = Math.abs(scaleX);
				var yScale:Number = Math.abs(scaleY);
				
				if (xScale != 1.0) {
					measuredMinWidth /= xScale;
					measuredWidth /= xScale;
				}
				
				if (yScale != 1.0) {
					measuredMinHeight /= yScale;
					measuredHeight /= yScale;
				}
				
				measure();
				invalidateSizeFlag = false;
				
				if (!isNaN(explicitMinWidth) && measuredWidth < explicitMinWidth)
					measuredWidth = explicitMinWidth;
				
				if (!isNaN(explicitMaxWidth) && measuredWidth > explicitMaxWidth)
					measuredWidth = explicitMaxWidth;
				
				if (!isNaN(explicitMinHeight) && measuredHeight < explicitMinHeight)
					measuredHeight = explicitMinHeight;
				
				if (!isNaN(explicitMaxHeight) && measuredHeight > explicitMaxHeight)
					measuredHeight = explicitMaxHeight;
				
				if (xScale != 1.0) {
					measuredMinWidth *= xScale;
					measuredWidth *= xScale;
				}
				
				if (yScale != 1.0) {
					measuredMinHeight *= yScale;
					measuredHeight *= yScale;
				}
			//} else {
				//invalidateSizeFlag = false;
				//measuredMinWidth = 0;
				//measuredMinHeight = 0;
			//}
			
			adjustSizesForScaleChanges();
			
			if (isNaN(oldMinWidth)) {
				// This branch does the same thing as the else branch,
				// but it is optimized for the first time that
				// measureSizes() is called on this object.
				oldMinWidth = !isNaN(explicitMinWidth) ? explicitMinWidth : measuredMinWidth;
				oldMinHeight = !isNaN(explicitMinHeight) ? explicitMinHeight : measuredMinHeight;
				oldExplicitWidth = !isNaN(explicitWidth) ? explicitWidth : measuredWidth;
				oldExplicitHeight = !isNaN(explicitHeight) ? explicitHeight : measuredHeight;
				changed = true;
			} else {
				newValue = !isNaN(explicitMinWidth) ? explicitMinWidth : measuredMinWidth;
				if (newValue != oldMinWidth) {
					oldMinWidth = newValue;
					changed = true;
				}
				
				newValue = !isNaN(explicitMinHeight) ? explicitMinHeight : measuredMinHeight;
				
				if (newValue != oldMinHeight) {
					oldMinHeight = newValue;
					changed = true;
				}
				
				newValue = !isNaN(explicitWidth) ? explicitWidth : measuredWidth;
				
				if (newValue != oldExplicitWidth) {
					oldExplicitWidth = newValue;
					changed = true;
				}
				
				newValue = !isNaN(explicitHeight) ? explicitHeight : measuredHeight;
				
				if (newValue != oldExplicitHeight) {
					oldExplicitHeight = newValue;
					changed = true;
				}
			}
			return changed;
		}*/
		
	}
}