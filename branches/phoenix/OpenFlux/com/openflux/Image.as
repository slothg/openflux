package com.openflux
{
	import com.openflux.core.FluxComponent;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	/**
	 * Image control
	 */
	public class Image extends FluxComponent
	{
		protected var loader:Loader;
		protected var loaderContext:LoaderContext;
		
		/**
		 * Constructor
		 */
		public function Image() {
			super();
		}
		
		// ========================================
		// source property
		// ========================================
		
		private var _source:Object;
		private var sourceChanged:Boolean = false;
		
		/**
		 * Image URL or ByteArray
		 */
		public function get source():Object { return _source; }
		public function set source(value:Object):void {
			if (_source != value) {
				_source = value;
				sourceChanged = true;
				invalidateProperties();
			}
		}
		
		// ========================================
		// scaleToFit property
		// ========================================
		
		private var _scaleToFit:Boolean = true;

		/**
		 * Scale image to fit UI width/height
		 */
		public function get scaleToFit():Boolean { return _scaleToFit; }
		public function set scaleToFit(value:Boolean):void {
			if (_scaleToFit != value) {
				_scaleToFit = value;
				invalidateDisplayList();
			}
		}
		
		// ========================================
		// maintainAspectRatio property
		// ========================================
		
		private var _maintainAspectRatio:Boolean = true;
		
		/**
		 * Whether to maintain aspect ratio when scaling image
		 */
		public function get maintainAspectRatio():Boolean { return _maintainAspectRatio; }
		public function set maintainAspectRatio(value:Boolean):void {
			if (_maintainAspectRatio != value) {
				_maintainAspectRatio = value;
				invalidateDisplayList();
			}
		}
		
		// ========================================
		// contentWidth
		// ========================================
		
		private var _contentWidth:Number = 0;
		
		/**
		 * Original content width
		 */
		public function get contentWidth():Number { return _contentWidth; }
		
		// ========================================
		// contentHeight
		// ========================================
		
		private var _contentHeight:Number = 0;
		
		/**
		 * Original content width
		 */
		public function get contentHeight():Number { return _contentHeight; }
		
		// ========================================
		// Framework overrides
		// ========================================
		
		override protected function commitProperties():void {
			super.commitProperties();
			
			if (sourceChanged) {
				loadSource();
				sourceChanged = false;
			}
		}
		
		override protected function measure():void {
			measuredWidth = _contentWidth;
			measuredHeight = _contentHeight;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			scaleContent();
		}
		
		// ========================================
		// Protected helper methods
		// ========================================
		
		protected function createLoader():void {
			if (!loader) {
				loader = new Loader();
				loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
				loaderContext = new LoaderContext(true);
				addChild(loader);
			}
		}
		
		protected function loadSource():void {
			createLoader();
			
			if (source is String) {
				loader.load(new URLRequest(source as String), loaderContext);
			} else if (source is ByteArray) {
				loader.loadBytes(source as ByteArray, loaderContext);
			}
		}
		
		protected function scaleContent():void {
			if (_scaleToFit && loader && loader.content) {
				var scaleX:Number = unscaledWidth / _contentWidth;
				var scaleY:Number = unscaledHeight / _contentHeight;
				
				if (_maintainAspectRatio) {
					scaleX = scaleY = Math.min(scaleX, scaleY);
				}
				
				loader.content.width = _contentWidth * scaleX;
				loader.content.height = _contentHeight * scaleY;
			}
		}
		
		// ========================================
		// Loader event handlers
		// ========================================
		
		protected function loaderCompleteHandler(event:Event):void {
			_contentWidth = loader.content.width;
			_contentHeight = loader.content.height;
			dispatchEvent(new Event(Event.COMPLETE));
			invalidateSize();
			invalidateDisplayList();
		}
		
		protected function loaderIOErrorHandler(event:IOErrorEvent):void {
			_contentHeight = _contentWidth = 0;
			invalidateSize();
			invalidateDisplayList();
		}
	}
}