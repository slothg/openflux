package com.openflux.skins
{
	import com.openflux.core.PhoenixComponent;

	public class ListItemSkin extends PhoenixComponent
	{
		public function ListItemSkin()
		{
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			this.graphics.clear();
			this.graphics.moveTo(0, 0);
			
			if (name == "over") {
				this.graphics.beginFill(0x7FCEFF, 0.7);
			} else if (name.substr(0, 8) == "selected") {
				this.graphics.beginFill(0x7FCEFF);
			} else {
	 			this.graphics.beginFill(0xffffff);
	 		}
			
			this.graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			this.graphics.endFill();
		}
	}
}