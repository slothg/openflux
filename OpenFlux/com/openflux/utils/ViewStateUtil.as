package com.openflux.utils
{
	
	import com.openflux.constants.ButtonStates;
	import com.openflux.constants.ViewStates;
	import com.openflux.core.IEnabled;
	import com.openflux.core.IFluxList;
	
	public class ViewStateUtil
	{
		
		public static function resolveButtonState(state:String, selected:Boolean=false, enabled:Boolean=true):String {
			if(enabled) {
				switch(state) {
					case ButtonStates.OVER:
						return selected ? ViewStates.SELECTED_OVER : ViewStates.OVER;
						break;
					case ButtonStates.DOWN:
						return selected ? ViewStates.SELECTED_DOWN : ViewStates.DOWN;
						break;
					case ButtonStates.UP:
					default:
						return selected ? ViewStates.SELECTED_UP : ViewStates.UP;
						break;
				}
			} else {
				return ViewStates.DISABLED;
			}
		}
		/*
		public static function resolveListItemState(state:String, list:IFluxList, data:Object, ...rest):String {
			var selected:Boolean;
			var enabled:Boolean = true;
			if(list is IEnabled) {
				enabled = (list as IEnabled).enabled;
			}
			if(list && list.selectedItems) {
				selected = list.selectedItems.contains(data);
			}
			return resolveButtonState(state, selected, enabled);
		}*/
		
	}
}