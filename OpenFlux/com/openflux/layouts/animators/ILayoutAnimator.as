package com.openflux.layouts.animators
{
	import com.openflux.core.IDataView;
	
	
	public interface ILayoutAnimator
	{
		function attach(container:IDataView):void;
		function detach(container:IDataView):void;
		function startMove():void;
		function stopMove():void;
		function moveItem(item:Object, token:Object):void;
		function addItem(item:Object, token:Object):void;
		function removeItem(item:Object):void;
	}
}