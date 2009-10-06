
package com.pixeldroid.r_c4d3.tools.console {

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	/**
	* <code>Console</code> implements a simple on screen display for viewing run-time text messages.
	* New messages accumulate at the bottom of the console, old messages roll off the top.
	*
	* The console can be hidden, shown, paused, resumed, and cleared. Text in the console is selectable 
	* so it can be copied to the clipboard.
	*
	* The buffer size is also configurable. As the buffer fills up, oldest lines are discarded first.
	*
	* @example The following code shows a simple console instantiation:
	* <listing version="3.0" >
	* package {
	*    import com.pixeldroid.tools.osd.Console;
	*    import flash.display.Sprite;
	*
	*    public class MyConsoleExample extends Sprite {
	*       public function MyConsoleExample() {
	*          super();
	*          var C:Console = new Console();
	*          addChild(C);
	*          C.out("Hello World");
	*       }
	*    }
	* }
	* </listing>
	* 
	* This class embeds a distributable font named "VeraMono.ttf" Copyright 2003 by Bitstream, Inc.
	* 
	* @see http://www.gnome.org/fonts/
	*/
	public class Console extends Sprite {
		
		[Embed(source="VeraMono.ttf", fontName="FONT_CONSOLE")]
		private static var FONT_CONSOLE:Class;

		private static const WIDTH:Number = 780;
		private static const HEIGHT:Number = 200;
		private static const BACK_COLOR:uint = 0x000000;
		private static const FORE_COLOR:uint = 0xffffff;
		private static const FONT_SIZE:Number = 10;
		private static const BACK_ALPHA:Number = .6;
		private static const BUFFER_SIZE:int = 64;
		
		private static var background:Shape;
		private static var console:TextField;
		
		private var loggingPaused:Boolean;
		private var first:Boolean;
		private var bufferMax:int;
	
		/**
		* Create a new Console with optional parameters.
		* 
		* @param left Left edge of console (pixels)
		* @param top Top edge of console (pixels)
		* @param width Width of console (pixels)
		* @param height Height of console (pixels)
		* @param bgColor Console background color
		* @param fgColor Console text color
		* @param txtSize Console text size
		* @param bgAlpha Console background alpha
		* @param buffer Max number of recent lines to retain
		*/
		public function Console (
			width:Number = WIDTH,
			height:Number = HEIGHT,
			bgColor:uint = BACK_COLOR, 
			fgColor:uint = FORE_COLOR,
			txtSize:Number = FONT_SIZE,
			bgAlpha:Number = BACK_ALPHA,
			buffer:int = BUFFER_SIZE
		) {
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, registerKeyhandler);
		
			background = new Shape();
			background.graphics.beginFill(bgColor, bgAlpha);
			background.graphics.drawRect(0, 0, width, height);
			background.graphics.endFill();
			addChild(background);

			var format:TextFormat = new TextFormat();
			format.font = "FONT_CONSOLE";
			format.color = fgColor;
			format.size = txtSize;
			format.align = TextFormatAlign.LEFT;
			
			console = new TextField();
			console.defaultTextFormat = format;
			console.embedFonts = true;
			console.multiline = true;
			console.selectable = true;
			console.wordWrap = true;
			addChild(console);
			
			console.width = width;
			console.height = height;
			
			loggingPaused = false;
			first = true;
			bufferMax = buffer;
		}
		
		


		/**
		* Send a message to the console.
		*/
		public function out(msg:String):void {
			if (loggingPaused == false) {
				console.appendText(pad(getTimer().toString()) +" " +msg +"\n");
				var overage:int = console.numLines - bufferMax;
				if (overage > 0) { console.replaceText(0, console.getLineOffset(overage), ""); }
				console.scrollV = console.maxScrollV;
			}
		}
	
	
		/**
		* Clear all messages from the console.
		*/
		public function clear():void {
			console.replaceText(0, console.length, "");
		}
	
	
		/**
		* Pause the console. Messages received while paused are ignored.
		*/
		public function pause():void {
			out("<PAUSE>");
			loggingPaused = true;
		}
	
	
		/**
		* Resume the console.
		*/
		public function resume():void {
			loggingPaused = false;
			out("<RESUME>");
		}
	
	
		/**
		* Hide the console. Messages are still received.
		*/
		public function hide():void {
			visible = false;
		}
	
	
		/**
		* Show the console.
		*/
		public function show():void {
			visible = true;
		}

		
		private function registerKeyhandler(e:Event):void {
			out(": : : : : : : : : : : : : :");
			out(": tick (`) toggles hide   :");
			out(": ctrl-tick toggles pause :");
			out(": ctrl-bkspc clears       :");
			out("");
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		private function keyDownHandler(e:KeyboardEvent):void {
			if ("`" == String.fromCharCode(e.charCode)) {
				if (e.ctrlKey == true) { toggleLog(); }
				else                   { toggleVis(); }
			}
			else if ((e.keyCode == Keyboard.BACKSPACE) && (e.ctrlKey == true)) {
				clear();
			}
		}
		
		private function toggleLog():void { (loggingPaused == true) ? resume() : pause(); }
		
		private function toggleVis():void { (visible == false) ? show() : hide(); }
		
		private static function pad(s:String, p:uint = 8):String {
			while(s.length < p) { s = "0" +s; }
			return s;
		}
		
	}

}
