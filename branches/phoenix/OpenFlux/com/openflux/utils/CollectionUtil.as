package com.openflux.utils
{
	import mx.collections.ArrayList;
	import mx.collections.IList;
	
	public class CollectionUtil
	{
		
		public static function resolveCollection(value:Object):IList {
			var collection:IList;
			if (value is Array) {
				collection = new ArrayList(value as Array);
			} else if (value is IList) {
				collection = IList(value);
			//} else if (value is XMLList) {
			//	collection = new XMLL XMLListCollection(value as XMLList);
			//} else if (value is XML) {
			//	var xl:XMLList = new XMLList();
			//	xl += value;
			//	collection = new XMLListCollection(xl);
			} else {
				// convert it to an array containing this one item
				var tmp:Array = [];
				if (value != null)
					tmp.push(value);
				collection = new ArrayList(tmp);
			}
			return collection;
		}
		
	}
}