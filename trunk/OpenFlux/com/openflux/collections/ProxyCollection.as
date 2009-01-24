package com.openflux.collections
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import mx.collections.ICollectionView;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;

	public class ProxyCollection extends Proxy implements ICollectionView
	{
		private var ed:EventDispatcher;
		
		public function ProxyCollection()
		{
			super();
			ed = new EventDispatcher(this);
		}
		
		private var _source:ICollectionView;
		public function get source():ICollectionView { return _source; }
		public function set source(value:ICollectionView):void {
			if (_source)
				_source.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
			_source = value;
			if (_source)
				_source.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
			
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
		}
		
		protected function onCollectionChange(event:CollectionEvent):void {
			dispatchEvent(event.clone());
		}
		
		//****************************************************
		// ICollectionView
		//****************************************************
		
		public function get length():int {
			return _source.length;
		}
		
		public function contains(item:Object):Boolean {
			return _source.contains(item);
		}
		
		// not in ICollectionView, but is nice to have
		public function getItemAt(index:int):Object {
			return _source[index];
		}
		
		// not used
		public function itemUpdated(item:Object, property:Object=null, oldValue:Object=null, newValue:Object=null):void { _source.itemUpdated(item, property, oldValue, newValue); }
	    public function disableAutoUpdate():void { _source.disableAutoUpdate(); }
		public function enableAutoUpdate():void { _source.enableAutoUpdate(); }
		public function createCursor():IViewCursor { return _source.createCursor(); }
		public function get filterFunction():Function { return _source.filterFunction; }
		public function set filterFunction(value:Function):void { _source.filterFunction = value; }
		public function get sort():Sort { return _source.sort; }
		public function set sort(value:Sort):void { _source.sort = value; }
		public function refresh():Boolean { return _source.refresh(); }
		
		//****************************************************
		// IEventDispatcher
		//****************************************************
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			return ed.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			return ed.removeEventListener(type, listener, useCapture);
		}
		public function dispatchEvent(event:Event):Boolean {
			return ed.dispatchEvent(event);
		}
		public function hasEventListener(type:String):Boolean {
			return ed.hasEventListener(type);
		}
		public function willTrigger(type:String):Boolean {
			return ed.willTrigger(type);
		}
		
		//************************************************
		// Proxy Overrides
		//************************************************
		
		override flash_proxy function getProperty(name:*):* {	
	        var index:int = int(parseInt(String(name)));
			return getItemAt(index);
	    }
	    
	    override flash_proxy function hasProperty(name:*):Boolean {
	        var index:int = int(parseInt(String(name)));
	        return index >= 0 && index < length;
	    }
	    
	    override flash_proxy function nextNameIndex(index:int):int {
	        return index < length ? index + 1 : 0;
	    }
	    
	    override flash_proxy function nextName(index:int):String {
	        return (index + 1).toString();
	    }
	    
	    override flash_proxy function nextValue(index:int):* {
	        return this[String(index - 1)];
	    }
		
		// not used
		override flash_proxy function setProperty(name:*, value:*):void {}
	    override flash_proxy function callProperty(name:*, ... rest):* { return null; }
	}
}