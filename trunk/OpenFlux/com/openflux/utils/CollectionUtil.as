package com.openflux.utils
{
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.collections.XMLListCollection;
	
	public class CollectionUtil
	{
		
		public static function resolveCollection(value:Object):ICollectionView {
			var collection:ICollectionView;
			if (value is Array) {
				collection = new ArrayCollection(value as Array);
			} else if (value is ICollectionView) {
				collection = ICollectionView(value);
			} else if (value is IList) {
				collection = new ListCollectionView(IList(value));
			} else if (value is XMLList) {
				collection = new XMLListCollection(value as XMLList);
			} else if (value is XML) {
				var xl:XMLList = new XMLList();
				xl += value;
				collection = new XMLListCollection(xl);
			} else {
				// convert it to an array containing this one item
				var tmp:Array = [];
				if (value != null)
					tmp.push(value);
				collection = new ArrayCollection(tmp);
			}
			return collection;
		}
		
	}
}