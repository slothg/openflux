package com.openflux
{
	import com.openflux.core.PhoenixComponent;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * Label class
	 */
	public class Label extends PhoenixComponent
	{
		private var textField:TextField;
		private var textFormat:TextFormat;
		
		/**
		 * Constructor
		 */
		public function Label()
		{
			super();
		}
		
		// ========================================
		// text
		// ========================================
		
		private var _text:String;
		private var textChanged:Boolean = false;
		
		[Bindable("textChange")]
		
		/**
		 * Text to be displayed
		 */
		public function get text():String
		{
			return _text;
		}
		
		public function set text( value:String ):void
		{
			if ( _text != value )
			{
				_text = value;
				dispatchEvent( new Event( "textChange" ) );
				
				textChanged = true;
				invalidateProperties();
			}
		}
		
		// ========================================
		// framework overrides
		// ========================================
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			textField = new TextField();
			textField.autoSize = TextFieldAutoSize.LEFT;
			addChild( textField );
			
			textFormat = new TextFormat();
			textField.defaultTextFormat = textFormat;
		}
		
		override protected function measure():void
		{
			measuredWidth = textField.textWidth;
			measuredHeight = textField.textHeight;
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if ( textChanged )
			{
				textField.text = _text;
				textChanged = false;
				invalidateSize();
			}
		}
		
		override public function styleChanged( styleProp:String ):void
		{
			super.styleChanged( styleProp );
			
			if ( textFormat && textFormat.hasOwnProperty( styleProp ) )
			{
				textFormat[ styleProp ] = getStyle( styleProp );
			}
		}
		
	} // end class
} // end package