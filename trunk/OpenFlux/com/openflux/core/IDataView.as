package com.openflux.core
{
	
	import com.openflux.layouts.ILayout;
	
	import mx.collections.ICollectionView;
	import mx.core.IFactory;
	import mx.core.IInvalidating;
	import mx.core.IUIComponent;
	
	// inferred dataViewChanged event
	// this needs to get split up to seperate dragging (perhaps scrolling) interfaces
	public interface IDataView extends IUIComponent, IInvalidating
	{
		
		//function get dataProvider():Object;
		function get content():Object;
		
		function get layout():ILayout;
		function set layout(value:ILayout):void;
		
		
		function get renderers():Array;
		
		function get itemRenderer():IFactory;
		//function get collection():ICollectionView;
		//
		
		function get verticalScrollPosition():Number;
		function get horizontalScrollPosition():Number;
		
		function get dragTargetIndex():int;
		function set dragTargetIndex(value:int):void;
		
		function invalidateLayout():void;
		
		//function localToGlobal(point:Point):Point;
		
	}
}