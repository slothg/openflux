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
	import com.openflux.DataGridHeader;
	import com.openflux.core.FluxController;
	import com.openflux.core.IFluxDataGrid;
	import com.openflux.core.IFluxView;
	
	import mx.core.IUIComponent;
	import mx.events.ChildExistenceChangedEvent;

	[ViewHandler(event="childAdd", handler="childAddHandler")]
	public class DataGridHeaderListController extends FluxController
	{
		[ModelAlias] public var list:IUIComponent;
		
		metadata function childAddHandler(event:ChildExistenceChangedEvent):void {
			var child:DataGridHeader = event.relatedObject as DataGridHeader;
			if (child) {
				child.dataGrid = IFluxView(list.parent).component as IFluxDataGrid;
			}
		}
		
	}
}