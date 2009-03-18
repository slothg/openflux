// =================================================================
//
// Copyright (c) 2009 The OpenFlux Team http://www.openflux.org
// 
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// =================================================================

package com.openflux.controllers
{
	import com.openflux.core.FluxController;
	import com.openflux.core.IFluxTreeItem;
	
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import mx.events.TreeEvent;

	public class TreeItemController extends FluxController
	{
		[ModelAlias] public var treeItem:IFluxTreeItem;
		[ModelAlias] public var dispatcher:IEventDispatcher; 
		
		[EventHandler(event="click", handler="openButtonClickHandler")]
		[ViewContract] public var openButton:DisplayObject;
		
		metadata function openButtonClickHandler(event:MouseEvent):void
		{
			if (treeItem.opened) {
				dispatcher.dispatchEvent(new TreeEvent(TreeEvent.ITEM_CLOSE, false, false, treeItem.data, treeItem, event));
			} else {
				dispatcher.dispatchEvent(new TreeEvent(TreeEvent.ITEM_OPENING, false, false, treeItem.data, treeItem, event));
			}
		}
	}
}