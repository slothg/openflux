package
{
	import com.openflux.containers.IFluxContainer;
	import com.openflux.layouts.ILayout;
	import com.openflux.layouts.VerticalLayout;
	
	import flex.core.Group;
	import flex.intf.ILayout;

	public class FluxLayout implements flex.intf.ILayout
	{
		private var container:FluxLayoutContainer;
		
		public function FluxLayout(layout:com.openflux.layouts.ILayout)
		{
			container = new FluxLayoutContainer();
			container.animator = new FluxLayoutAnimator();
			container.layout = layout;
		}
		
		public function get layout():com.openflux.layouts.ILayout { return container.layout; }
		public function set layout(value:com.openflux.layouts.ILayout):void {
			container.layout = value;
		}
		
		private var _target:Group;
		public function get target():Group { return _target; }
		public function set target(value:Group):void {
			container.target = _target = value;
		}
		
		public function measure():void
		{
			if (!_target)
				return;
			
			var size:Object = container.layout.measure();
			_target.measuredWidth = size.x;
			_target.measuredHeight = size.y;
		}
		
		public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if (!_target)
				return;
			
			container.layout.update();
		}
	}
}

import com.openflux.animators.IAnimator;
import mx.core.UIComponent;
import com.openflux.containers.IFluxContainer;
import com.openflux.core.FluxView;
import flex.core.Group;
import flex.intf.ILayoutItem;
import flex.layout.LayoutItemFactory;
import com.openflux.layouts.ILayout;

[ExcludeClass]
class FluxLayoutContainer extends UIComponent implements IFluxContainer {
	public var target:Group;
	
	public function FluxLayoutContainer() {
		
	}
	
	private var _animator:IAnimator;
	public function get animator():IAnimator { return _animator; }
	public function set animator(value:IAnimator):void {
		if (_animator)
			_animator.detach(this);
		_animator = value;
		if (_animator)
			_animator.attach(this);
	}
	
	private var _layout:com.openflux.layouts.ILayout;
	public function get layout():com.openflux.layouts.ILayout { return _layout; }
	public function set layout(value:com.openflux.layouts.ILayout):void {
		if (_layout)
			_layout.detach(this);
		_layout = value;
		if (_layout)
			_layout.attach(this);
	}
	
	public function get children():Array {
		var layoutItemArray:Array = [];
		var count:uint = target.numLayoutItems;
		var layoutItem:ILayoutItem;
		
		for (var i:int = 0; i < count; i++)
		{
			layoutItem = LayoutItemFactory.getLayoutItemFor(target.getLayoutItemAt(i));
			if (layoutItem && layoutItem.includeInLayout)
				layoutItemArray.push(new FluxLayoutChild(layoutItem));
		}
		
		return layoutItemArray;
	}
	
	override public function get width():Number { return target.width; }
	override public function get height():Number { return target.height; }
	override public function getExplicitOrMeasuredWidth():Number { return target.getExplicitOrMeasuredWidth(); }
	override public function getExplicitOrMeasuredHeight():Number { return target.getExplicitOrMeasuredHeight(); }
}

[ExcludeClass]
class FluxLayoutAnimator implements IAnimator {
	public function attach(container:IFluxContainer):void {}
	public function detach(container:IFluxContainer):void {}
	public function begin():void {}
	public function end():void {}
	public function moveItem(item:Object, token:Object):void {
		var child:FluxLayoutChild = item as FluxLayoutChild;
		if (child.layoutItem) {
			child.layoutItem.setActualPosition(token.x, token.y);
			child.layoutItem.setActualSize(token.width, token.height);
		}
	}
}

[ExcludeClass]
class FluxLayoutChild extends UIComponent {
	public var layoutItem:ILayoutItem;
	
	public function FluxLayoutChild(layoutItem:ILayoutItem) {
		this.layoutItem = layoutItem;
	}
	
	override public function get width():Number { return layoutItem.preferredSize.x; }
	override public function get measuredWidth():Number { return layoutItem.preferredSize.x; }
	override public function get height():Number { return layoutItem.preferredSize.y; }
	override public function get measuredHeight():Number { return layoutItem.preferredSize.y; }
}