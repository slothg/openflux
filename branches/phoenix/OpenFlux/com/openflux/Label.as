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