
package com.pixeldroid.r_c4d3.tools.perfmon {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	
	public class PerfMon extends Sprite {
		
		private static const MAXOUT_COLOR:uint   = 0xffffff;
		private static const EMPTY_COLOR:uint    = 0xff0000;
		private static const BACK_COLOR:uint     = 0x000000;
		private static const FRAME_COLOR_1:uint  = 0x00ff00;
		private static const FRAME_COLOR_2:uint  = 0x004400;
		private static const FRAME_COLOR_3:uint  = 0x007700;
		private static const MEMORY_COLOR_1:uint = 0xffff00;
		private static const MEMORY_COLOR_2:uint = 0x444400;
		private static const MEMORY_COLOR_3:uint = 0x777700;
		private static const LAG_COLOR_1:uint    = 0x00ffff;
		private static const LAG_COLOR_2:uint    = 0x004444;
		private static const LAG_COLOR_3:uint    = 0x007777;
		
		private var FRAMERATE_TARGET:Number;
		private var FRAMERATE_MAX:Number;
		private var MEMORY_TARGET:Number;
		private var MEMORY_MAX:Number;
		
		private var graphHeight:Number;
		private var graphWidth:Number;
		private var interval:Number;
		private var memoryScalar:Number;
		
		private var frames:Number;
		private var timer:Timer;
		private var lastUpdate:int;
		private var frameData:Array;
		private var memoryData:Array;
		private var lagData:Array;
		private var frameRate:Bitmap;
		private var memoryUsage:Bitmap;
		private var updateLag:Bitmap;
		
		
		
		public function PerfMon(height:Number=30, width:Number=60, updateInterval:Number=1000, memoryGrowthFactor:Number=10) {
			graphHeight = height;
			graphWidth = width;
			interval = updateInterval;
			memoryScalar = memoryGrowthFactor;
			
			addEventListener(Event.ADDED_TO_STAGE, onCreate, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, onDestroy, false, 0, true);
		}
		
		

		private function onCreate(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onCreate);
			initialize();
			addChildren();
			startPolling();
		}

		private function onDestroy(e:Event):void {
			stopPolling();
			frameData = [];
			memoryData = [];
			lagData = [];
			frameData = null;
			memoryData = null;
			lagData = null;
			frameRate.bitmapData.dispose();
			memoryUsage.bitmapData.dispose();
			updateLag.bitmapData.dispose();
		}

		
		private function onSample(e:Event):void {
			sampleFrameRate();
			sampleMemoryUsage();
			sampleUpdateLag();
		}
		
		private function onRefresh(e:Event):void {
			slide(frameRate.bitmapData, BACK_COLOR);
			slide(memoryUsage.bitmapData, BACK_COLOR);
			slide(updateLag.bitmapData, BACK_COLOR);
			
			sliver(
				frameRate.bitmapData, 
				avg(frameData), 
				FRAMERATE_TARGET, 
				0, 
				FRAMERATE_MAX, 
				FRAME_COLOR_1, 
				FRAME_COLOR_2, 
				FRAME_COLOR_3
			);
			sliver(
				memoryUsage.bitmapData, 
				avg(memoryData), 
				MEMORY_TARGET, 
				0, 
				MEMORY_MAX, 
				MEMORY_COLOR_1, 
				MEMORY_COLOR_2, 
				MEMORY_COLOR_3
			);
			sliver(
				updateLag.bitmapData, 
				avg(lagData), 
				0, 
				0, 
				FRAMERATE_TARGET, 
				LAG_COLOR_1, 
				LAG_COLOR_2, 
				LAG_COLOR_3
			);
			
			frames = 0;
			frameData = [];
			memoryData = [];
			lagData = [];
			lastUpdate = getTimer();
		}

		
		
		private function sampleFrameRate():void {
			frames++;
			var seconds:Number = (getTimer() - lastUpdate) * .001;
			var fps:Number = frames / seconds;
			frameData.push(fps);
		}

		private function sampleMemoryUsage():void {
			var mem:Number = System.totalMemory / 1024 / 1024;
			memoryData.push(mem);
		}
		
		private function sampleUpdateLag():void {
			var fps:Number = frameData[frameData.length-1];
			var delta:Number = FRAMERATE_TARGET - fps;
			lagData.push(delta);
		}

		private function initialize():void {
			MEMORY_TARGET = System.totalMemory / 1024 / 1024;
			MEMORY_MAX = MEMORY_TARGET * memoryScalar;
			FRAMERATE_TARGET = stage.frameRate;
			FRAMERATE_MAX = FRAMERATE_TARGET * 1.25;
			
			frames = 0;
			frameData = [];
			memoryData = [];
			lagData = [];
			
			frameRate = new Bitmap();
			frameRate.bitmapData = new BitmapData(graphWidth, graphHeight, false, BACK_COLOR);
			
			memoryUsage = new Bitmap();
			memoryUsage.bitmapData = new BitmapData(graphWidth, graphHeight, false, BACK_COLOR);
			
			updateLag = new Bitmap();
			updateLag.bitmapData = new BitmapData(graphWidth, graphHeight, false, BACK_COLOR);
		}
		
		private function addChildren():void {
			addChild(frameRate);
			addChild(memoryUsage);
			memoryUsage.x = frameRate.x + frameRate.width + 4;
			addChild(updateLag);
			updateLag.x = memoryUsage.x + memoryUsage.width + 4;
		}

		private function startPolling():void {
			addEventListener(Event.ENTER_FRAME, onSample);
			timer = new Timer(interval);
			timer.addEventListener(TimerEvent.TIMER, onRefresh);
			timer.start();
		}
		
		private function stopPolling():void {
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, onRefresh);
			removeEventListener(Event.ENTER_FRAME, onSample);
		}
		
		
		
		private static function sliver(bd:BitmapData, v:Number, target:Number, min:Number, max:Number, c1:uint, c2:uint, c3:uint):void {
			var h:int, ht:int;
			var c:uint;
			
			if (v <= min) { h = 1; c = EMPTY_COLOR; }
			else if (v >= max) { h = bd.height; c = MAXOUT_COLOR; }
			else { h = Math.ceil( ((v - min) / (max - min)) * bd.height ); c = c1; }
			ht = Math.ceil( ((target - min) / (max - min)) * bd.height );
			
			var x:int = bd.width-1;
			var y:int = bd.height - h;
			bd.fillRect(new Rectangle(x,y, 1,h), c2);
			bd.setPixel(x,bd.height-ht-1, c3);
			bd.setPixel(x,y, c);
		}
		
		private static function slide(bd:BitmapData, bg:uint):void {
			var w:int = bd.width-1;
			var h:int = bd.height;
			bd.copyPixels(bd, new Rectangle(1,0, w,h), new Point(0,0));
			bd.fillRect(new Rectangle(w,0, 1,h), bg);
		}
		
		private static function avg(A:Array):Number {
			var sum:Number = 0;
			var i:int = A.length;
			while(i--) { sum += A[i]; }
			return sum / A.length;
		}
	}
}