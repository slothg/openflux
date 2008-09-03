package com.openflux.containers
{
	
	import mx.core.IFactory;
	
	// inferred dataViewChanged event
	public interface IDataView
	{
		
		function get content():*;
		function get factory():IFactory;
		
	}
}