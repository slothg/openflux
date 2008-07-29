package com.openflux.containers
{
	
	import com.openflux.layouts.ILayout;
	
	import mx.collections.ICollectionView;
	import mx.core.IFactory;
	import mx.core.IInvalidating;
	import mx.core.IUIComponent;
	
	// inferred dataViewChanged event
	public interface IDataView
	{
		
		function get content():*;
		function get factory():Object;
		
	}
}