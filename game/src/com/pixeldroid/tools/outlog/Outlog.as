/*

Outlog
A console for displaying messages sent via LocalConnection.

for mxmlc:
-default-size 400 600 -default-frame-rate 2

*/

package com.pixeldroid.tools.outlog {

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.LocalConnection;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
		
	import com.pixeldroid.diagnostic.LocalTrace;
	
	/**
	* Outlog implements a simple console for viewing run-time messages sent via LocalTrace.
	* The context menu allows the user to <code>Pause</code>, <code>Resume</code>, 
	* and <code>Clear</code> the message display.
	* 
	* This class embeds a distributable font named "VeraMono.ttf" Copyright 2003 by Bitstream, Inc.
	* 
	* @see com.pixeldroid.diagnostic.LocalTrace
	* @see http://www.gnome.org/fonts/
	*/
	public class Outlog extends Sprite {

		private static const VERSION:String = "1.0.0";
		
		[Embed(source="VeraMono.ttf", fontName="FONT_CONSOLE")]
		private static const FONT_CONSOLE:Class;

		private static const BACK_COLOR:uint = 0x888888;
		private static const FORE_COLOR:uint = 0xffffff;
		private static const WIDTH:uint = 400;
		private static const HEIGHT:uint = 600;
		
		private static var background:Shape;
		private static var backgroundColor:uint;
		private static var console:TextField;
		private static var traceReceiver:LocalConnection;
		private static var contextMenu:ContextMenu;
		
		private var loggingPaused:Boolean;
		private var first:Boolean;
	
		/**
		* Create a new Outlog console with optional parameters.
		* 
		* @param channel Channel id to listen for trace messages on
		* @param bgColor Console background color
		* @param fgColor Console text color
		*/
		public function Outlog(
			channel:String = LocalTrace.DEFAULT_CHANNEL, 
			bgColor:uint = BACK_COLOR, 
			fgColor:uint = FORE_COLOR
		) {
			background = new Shape();
			backgroundColor = bgColor;
			addChild(background);

			var format:TextFormat = new TextFormat();
			format.font = "FONT_CONSOLE";
			format.color = fgColor;
			format.size = 12;
			format.align = TextFormatAlign.LEFT;
			
			console = new TextField();
			console.defaultTextFormat = format;
			console.embedFonts = true;
			console.multiline = true;
			console.selectable = true;
			console.wordWrap = true;
			addChild(console);
			
			contextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			addContextMenuItem(contextMenu, new ContextMenuItem("Pause logging"), pause);
			addContextMenuItem(contextMenu, new ContextMenuItem("Resume logging"), resume);
			addContextMenuItem(contextMenu, new ContextMenuItem("Clear display"), clear);
			console.contextMenu = contextMenu;
			
			traceReceiver = new LocalConnection();
			traceReceiver.allowDomain('*');
			traceReceiver.client = this;
			traceReceiver.connect(channel);
			
			loggingPaused = false;
			first = true;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_RIGHT;
			stage.addEventListener(Event.RESIZE, onResize);
			
			out("Outlog v." +VERSION);
			out("receiving on channel '" +channel +"'");
			out("");
		}

		private function onResize(e:Event):void {
			var w:Number = stage.stageWidth;
			var h:Number = stage.stageHeight;
			var l:Number = this.width - w;
			var t:Number = h - this.height;
			
			background.graphics.clear();
			background.graphics.beginFill(backgroundColor);
			background.graphics.drawRect(0, 0, w, h);
			background.graphics.endFill();
			
			console.width = w;
			console.height = h;
				
			if (!first) {
				background.x += l;
				background.y += t;
				
				console.x += l;
				console.y += t;
			}
			first = false;
		}


		public function out(msg:String):void {
			if (loggingPaused == false) {
				console.appendText(msg +"\n");
				console.scrollV = console.maxScrollV;
			}
		}
	
	
		public function clear(e:ContextMenuEvent=null):void {
			console.replaceText(0, console.length, "");
		}
	
	
		public function pause(e:ContextMenuEvent=null):void {
			out("<PAUSE>");
			loggingPaused = true;
		}
	
	
		public function resume(e:ContextMenuEvent=null):void {
			loggingPaused = false;
			out("<RESUME>");
		}

		
		private static function addContextMenuItem(menu:ContextMenu, item:ContextMenuItem, handler:Function):void {
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handler);
			menu.customItems.push(item);
		}
		
	}

}
