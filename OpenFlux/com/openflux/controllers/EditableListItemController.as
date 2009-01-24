package com.openflux.controllers
{
	import com.openflux.core.FluxController;
	import com.openflux.core.IFluxEditableListItem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.TextInput;

	[ViewHandler(event="doubleClick", handler="doubleClickHandler")] 
	public class EditableListItemController extends FluxController
	{
		[ModelAlias] public var listItem:IFluxEditableListItem;
		
		[EventHandler(event="enter", handler="inputEnterHandler")]
		[ViewContract] public var input:TextInput;
		
		metadata function doubleClickHandler(event:MouseEvent):void {
			if (!listItem.editing) {
				listItem.editing = true;
				component.view.state = "editing";
				input.text = String(listItem.data);
			}
		}
		
		metadata function inputEnterHandler(event:Event):void {
			listItem.editing = false;
			component.view.state = "notEditing";
			listItem.data = input.text;
		}
		
	}
}