package com.openflux.utils
{
	
	import com.openflux.animators.TweenAnimator;
	import com.openflux.controllers.ButtonController;
	import com.openflux.controllers.ListController;
	import com.openflux.controllers.ListItemController;
	import com.openflux.controllers.ScrollBarController;
	import com.openflux.core.FluxFactory;
	import com.openflux.layouts.ContraintLayout;
	import com.openflux.views.ButtonView;
	import com.openflux.views.ListItemView;
	import com.openflux.views.ListView;
	import com.openflux.views.VerticalScrollBarView;
	
	public class ClassReferences
	{
		
		private var fluxFactory:FluxFactory;
		private var constraintLayout:ContraintLayout;
		private var tweenAnimator:TweenAnimator;
		
		private var buttonView:ButtonView;
		private var buttonController:ButtonController;
		
		private var listView:ListView;
		private var listController:ListController;
		
		private var listItemController:ListItemController;
		private var listItemView:ListItemView;
		
		private var scrollBarController:ScrollBarController;
		private var verticalScrollBarView:VerticalScrollBarView;
		
	}
}