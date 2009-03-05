package com.openflux.core
{
	import com.openflux.controllers.ComplexController;
	import com.openflux.utils.ComponentUtil;
	import com.openflux.utils.MetaInjector;
	import com.openflux.utils.MetaStyler;
	
	import flash.display.DisplayObject;
	
	import mx.binding.utils.BindingUtils;
	import mx.core.IInvalidating;
	import mx.core.mx_internal;
	import mx.skins.ProgrammaticSkin;
	
	use namespace mx_internal;
	
	[DefaultProperty("capacitor")]
	
	/**
	 * Base class for all OpenFlux components. Stores the view and controller.
	 */
	public class FluxComponent extends PhoenixComponent implements IFluxComponent
	{
		private var styleNames:Array;
		
		/**
		 * Constructor
		 */
		public function FluxComponent() {
			super();
		}
		
		// ========================================
		// capacitor property
		// ========================================
		
		/**
		 * The default property allowing you to pass an Array of views, controllers. 
		 * Components can override this to add futher support for other settings. 
		 * For example, List allows you to specify the layout and item renderer and  
		 * DataGrid allows you to specify the DataGridColumn instances.
		 */
		public function get capacitor():Array { return [view, controller]; }
		public function set capacitor(value:Array):void {
			for each(var item:Object in value) {
				if (item is IFluxView) {
					view = item as IFluxView;
				}
				
				if (item is IFluxController) {
					if (!controller) {
						controller = item as IFluxController;
					} else if (controller is ComplexController) {
						ComplexController(controller).controllers.push(item);
					} else {
						controller = new ComplexController([controller, item]);
					}
				}
				
				if (item is ProgrammaticSkin) {
					skin = item as ProgrammaticSkin;
				}
			}
		}
		
		// ========================================
		// view property
		// ========================================
		
		private var _view:IFluxView;
		private var viewChanged:Boolean;
		
		[StyleBinding]
		
		/**
		 * View assigned to this component
		 */
		public function get view():IFluxView { return _view; }
		public function set view(value:IFluxView):void {
			if (_view != value) {
				if(_view != null && contains(_view as DisplayObject)) {
					removeChild(_view as DisplayObject);
				}
				
				_view = value;
				viewChanged = true;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		// ========================================
		// controller property
		// ========================================
		
		private var _controller:IFluxController;
		private var controllerChanged:Boolean;
		
		[StyleBinding]
		
		/**
		 * Controller assigned to the component. To attach multiple controllers use ComplexController
		 */
		public function get controller():IFluxController { return _controller; }
		public function set controller(value:IFluxController):void {
			if (_controller != value) {
				_controller = value;
				controllerChanged = true;
				invalidateProperties();
			}
		}
		
		// ========================================
		// skin property
		// ========================================
		
		// TODO: This should use an interface if possible
		
		private var _skin:ProgrammaticSkin;
		private var skinChanged:Boolean;
		
		[StyleBinding]
		
		/**
		 * Skin assigned to this component
		 */
		public function get skin():ProgrammaticSkin { return _skin; }
		public function set skin(value:ProgrammaticSkin):void {
			if (_skin != value) {
				if(_skin != null && contains(_skin)) {
					removeChild(_skin);
				}
				
				_skin = value;
				skinChanged = true;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		// ========================================
		// lazy IFactory base
		// (for overrides that implement IFactory)
		// ========================================
		
		public function newInstance():* {
			var instance:Object = ComponentUtil.clone(this, "com.openflux.core::FluxComponent");
			return instance;
		}
		
		
		// ========================================
		// Framework Overrides
		// ========================================
		
		override protected function createChildren():void {
			MetaInjector.createDefaults(this);
			super.createChildren();
		}
		
		/** @private */
		override protected function commitProperties():void {
			super.commitProperties();
			
			if (viewChanged) {
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
			
			if (controllerChanged && controller) {
				controller.component = this;
				MetaStyler.initialize(controller, this);
				controllerChanged = false;
			}
			
			if (skinChanged && skin) {
				addChildAt(skin, 0);
				MetaStyler.initialize(skin, this);
				skinChanged = false;
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
			
			if (view) {
				view.setActualSize(unscaledWidth, unscaledHeight);
				IInvalidating(view).invalidateDisplayList();
			}
			
			if (skin) {
				skin.move(0, 0);
				skin.setActualSize(unscaledWidth, unscaledHeight);
				skin.invalidateDisplayList();
			}
		}
		
		override public function setActualSize(w:Number, h:Number):void {
			super.setActualSize(w, h);
			
			if (view) {
				view.setActualSize(w, h);
			}
			
			if (skin) {
				skin.setActualSize(w, h);
			}
		}
		
		/** @private */
		override public function styleChanged(styleProp:String):void {
			super.styleChanged(styleProp);
			MetaStyler.updateStyle(styleProp, this);
			
			if (view) {
				MetaStyler.updateStyle(styleProp, view, this);
			}
			
			if (controller) {
				MetaStyler.updateStyle(styleProp, controller, this);
			}
			
			if (skin) {
				MetaStyler.updateStyle(styleProp, skin, this);
			}
		}
		
		/** @private */
		override public function stylesInitialized():void {
			MetaStyler.initialize(this);
		}
		
		// ========================================
		// UIComponent upgrades
		// ========================================
		
		/** @private */
		override public function set styleName(value:Object):void {
			if(value is String) {
				styleNames = (value as String).split(" ");
			}
			
			super.styleName = value;
		}
		
		override public function set currentState(value:String):void {
			super.currentState = value;
			
			if (view) {
				view.state = value;
			}
			
			if (skin) {
				skin.name = value;
				skin.invalidateDisplayList();
			}
		}
	}
}