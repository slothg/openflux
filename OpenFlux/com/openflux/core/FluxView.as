package com.openflux.core
{
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.states.State;
	
	//use namespace mx_internal;
	
	// Default property is a no-go when component is root
	//[DefaultProperty("contentData")]
	public class FluxView extends Canvas implements IFluxView
	{
		
		private var _state:String;
		public function get state():String { return _state; }
		public function set state(value:String):void {
			_state = value;
			for each(var state:State in states) {
				if(state.name == value) {
					super.currentState = value;
				}
			}
		}
		
		//************************************
		// Constructor
		//************************************
		
		public function FluxView()
		{
			super();
			clipContent = false;
		}
		
		//************************************
		// Public Properties
		//************************************
		
		/*
		[Bindable]
		public function get data():Object { return _data; }
		public function set data(value:Object):void {
			_data = value;
			dataChanged = true;
			// data templates
		}*/
		/*
		override public function set currentState(value:String):void {
			for each(var state:State in states) {
				if(state.name == value) {
					super.currentState = value;
				}
			}
		}
		*/
		//**********************************************
		// Child Handling Overrides
		//**********************************************
		/*
		override public function addChild(child:DisplayObject):DisplayObject {
			return addChildAt(child, numChildren);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			var formerParent:DisplayObjectContainer = child.parent;
			if (formerParent && !(formerParent is Loader)) {
				formerParent.removeChild(child);
			}
			
			addingChild(child);
			// The player will dispatch an "added" event from the child
			// after it has been added, so all "added" handlers execute here.
			$addChildAt(child, index);
			childAdded(child);
			
			return child;
		}
		*/
		//**********************************************
		// Framework Overrides
		//**********************************************
		/*
		override protected function createChildren():void {
			super.createChildren();
			if(_content is Array) {
				addContentFromArray(_content as Array);
			} else if(_content is UIComponent) {
				addContentFromUIComponent(_content as UIComponent);
			} else {
				addContentFromData(_content);
			}
		}
		*/
		//**********************************************
		// mx_internal overrides
		//**********************************************
		
		/**
		 *  @private
		 *//*
		override mx_internal function addingChild(child:DisplayObject):void {
			// throw an RTE if child is not an IUIComponent.
			var ui:IUIComponent = IUIComponent(child);
	        // set the child's virtual parent, nestLevel, document, etc.
			super.addingChild(child);
			invalidateSize();
			invalidateDisplayList();
		}
		*/
		/**
		 *  @private
		 *//*
		override mx_internal function childAdded(child:DisplayObject):void {
			dispatchEvent(new Event("childrenChanged"));
			var event:ChildExistenceChangedEvent = new ChildExistenceChangedEvent(ChildExistenceChangedEvent.CHILD_ADD);
			event.relatedObject = child;
			dispatchEvent(event);
			child.dispatchEvent(new FlexEvent(FlexEvent.ADD));
			super.childAdded(child); // calls createChildren()
		}
		*/
		//**********************************************
		// Private Content Utility Methods
		//**********************************************
		
		private function addContentFromArray(value:Array):void {
			for each(var o:Object in value) {
				if(o is UIComponent) {
					addContentFromUIComponent(o as UIComponent);
				} else {
					addContentFromData(o);
				}
			} 
		}
		
		private function addContentFromUIComponent(value:UIComponent):void {
			addChild(value);
		}
		
		private function addContentFromData(value:Object):void {
			
		}
		
	}
}