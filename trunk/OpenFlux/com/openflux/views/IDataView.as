package com.openflux.views
{
	
	import com.openflux.layouts.ILayout;
	
	import mx.collections.ICollectionView;
	import mx.core.IFactory;
	import mx.core.IInvalidating;
	import mx.core.IUIComponent;
	
	// inferred dataViewChanged event
	public interface IDataView
	{
		
		function get collection():Object;
		function get renderer():IFactory;
		
	}
}