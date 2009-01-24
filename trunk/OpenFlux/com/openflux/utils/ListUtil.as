package com.openflux.utils
{
	import com.openflux.core.IFluxList;
	
	public class ListUtil
	{
		public static function selectedItem(list:IFluxList):Object {
			return hasSelectedItems(list) ? list.selectedItems.getItemAt(0) : null;
		}
		
		public static function selectedIndices(list:IFluxList):Array {
			return hasSelectedItems(list) ? list.selectedItems.source.map(function(item:*, index:int, array:Array):int { return list.data.getItemIndex(item); }) : [];
		}
		
		public static function selectedIndex(list:IFluxList):int {
			return hasSelectedItems(list) ? selectedIndices(list)[0] : -1;
		}
		
		public static function hasSelectedItems(list:IFluxList):Boolean {
			return numSelectedItems(list) > 0;
		}
		
		public static function numSelectedItems(list:IFluxList):int {
			return list.selectedItems ? list.selectedItems.length : 0;
		}
		
		public static function getItemsAt(list:IFluxList, indices:Array):Array {
			return indices.map(function(item:*, index:int, array:Array):Object { return list.data[item]; });
		}
	}
}