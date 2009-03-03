package com.openflux.core
{
	
	import com.openflux.controllers.ComplexController;
	import com.openflux.utils.ComponentUtil;
	import com.openflux.utils.MetaInjector;
	import com.openflux.utils.MetaStyler;
	
	import flash.display.DisplayObject;
	
	import mx.core.IInvalidating;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	[DefaultProperty("capacitor")]
	public class FluxComponent extends PhoenixComponent implements IFluxComponent
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
					if (!controller) {
						controller = item as IFluxController;
					} else if (controller is ComplexController) {
						ComplexController(controller).controllers.push(item);
					} else {
						controller = new ComplexController([controller, item]);
					}
				}
			}
		}
		
		[StyleBinding]
		public function get view():IFluxView { return _view; }
		public function set view(value:IFluxView):void {
			if(_view != null && contains(_view as DisplayObject)) {
				removeChild(_view as DisplayObject);
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
		
		//******************************************
		// lazy IFactory base
		// (for overrides that implement IFactory)
		//******************************************
		
		public function newInstance():* {
			var instance:Object = ComponentUtil.clone(this, "com.openflux.core::FluxComponent");
			return instance;
		}
		
		
		//***************************************************
		// Framework Overrides
		//***************************************************
		
		override protected function createChildren():void {
			MetaInjector.createDefaults(this);
			super.createChildren();
		}
		
		/** @private */
		override protected function commitProperties():void {
			super.commitProperties();
			if(viewChanged) {
				view.component = this;
				//(view as UIComponent).styleName = this;
				addChild(view as DisplayObject);
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
				// an explicit width/height in the view becomes measured width/height for the component
				// ie. component declared width/height trumps view preferences
				measuredWidth = isNaN( view.explicitWidth ) ? view.measuredWidth : view.explicitWidth;
				measuredHeight = isNaN( view.explicitHeight ) ? view.measuredHeight : view.explicitHeight;
				measuredMinWidth = isNaN( view.explicitMinWidth ) ? view.measuredMinWidth : view.explicitMinWidth;
				measuredMinHeight = isNaN( view.explicitMinHeight ) ? view.measuredMinHeight : view.explicitMinHeight;
			}
		}
		
		/** @private */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(view) {
				view.setActualSize(unscaledWidth, unscaledHeight);
				IInvalidating(view).invalidateDisplayList();
			}
		}
		
		override public function setActualSize(w:Number, h:Number):void {
			super.setActualSize(w, h);
			if(view) {
				view.setActualSize(w, h);
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
	}
}