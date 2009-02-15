package com.openflux.containers
{
	
	import mx.core.IFactory;
	
	public interface IDataView
	{
		
		function get content():*;
		function get factory():IFactory;
		
	}
}