// =================================================================
//
// Copyright (c) 2009 The OpenFlux Team http://www.openflux.org
// 
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// =================================================================

package com.openflux.utils
{
	import com.openflux.core.IFluxList;
	
	public class ListUtil
	{
		public static function selectedItem(list:IFluxList):Object {
			return hasSelectedItems(list) ? list.selectedItems.getItemAt(0) : null;
		}
		
		public static function selectedIndices(list:IFluxList):Array {
			return hasSelectedItems(list) ? list.selectedItems.toArray().map(function(item:*, index:int, array:Array):int { return list.data.getItemIndex(item); }) : [];
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
	}
}