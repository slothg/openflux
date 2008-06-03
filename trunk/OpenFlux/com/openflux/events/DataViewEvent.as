package com.openflux.events
{
	import flash.events.Event;

	public class DataViewEvent extends Event
	{
		
		//public static var DATA_VIEW_CHANGED:String = "dataViewChanged";
		
		public function DataViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}