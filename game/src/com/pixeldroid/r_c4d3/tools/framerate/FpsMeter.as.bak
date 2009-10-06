
package com.pixeldroid.r_c4d3.tools.framerate {
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	
	/**
	* <code>FpsMeter</code> monitors frame rate. It graphs timed averages against a target rate.
	* 
	* This class embeds a distributable font named "PixelHugger.ttf" Copyright pixelhugger.com.
	* 
	* @see http://www.pixelhugger.com/fonts.php
	*/
	public class FpsMeter extends Sprite {
		
		[Embed(source="PixelHugger.ttf", fontName="FONT")]
		private static var FONT:Class;
		
		private static const NUM_METERS:uint = 3;
		private static const UPDATE_INTERVAL:uint = 250;
		private static const frameCounts:Array = [0,0,0];
		private static const timeChecks:Array = [0,0,0];
		private static const timeCheckIntervals:Array = [1000,5000,9000];
		private static const timeCheckHandlers:Array = [null, null, null];
		private static const timeCheckTimers:Array = [null, null, null];
		private static const labels:Array = [null, null, null];
		private static const meters:Array = [null, null, null];
		private static const displays:Array = [null, null, null];

		private var targetFps:Number;
		private var UPDATE_INTERVAL:int;
		private var updateTimer:Timer;
		
		private var targetLine:Shape;
		private var meterShadowContainer:Sprite;
		private var meterContainer:Sprite;


		
		/**
		* Create a new <code>FpsMeter</code>.
		* Default target framerate of 30fps and interval meters averaging 1, 5, and 9 second frame counts will be created.
		* These can be changed with <code>setFpsTarget</code> and <code>setFpsInterval</code>.
		* 
		* Monitoring starts when you call <code>startMonitoring()</code>
		* 
		* @see #setFpsTarget
		* @see #setFpsInterval
		*/
		public function FpsMeter() {
			timeCheckHandlers[0] = timeCheck1;
			timeCheckHandlers[1] = timeCheck2;
			timeCheckHandlers[2] = timeCheck3;
			
			buildParts();
			
			setFpsTarget(30);
			setFpsInterval(0, 1);
			setFpsInterval(1, 5);
			setFpsInterval(2, 9);
		}
		
		
		/**
		* Set the target frame rate threshold.
		* When actual frame rates dip below the target, the meters will turn from black to red.
		* 
		* @param t Target frame rate, in frames per second
		*/
		public function setFpsTarget(t:Number):void {
			targetLine.x = targetFps = Math.max(1, Math.min(99, t));
		}
		
		/**
		* Set the update interval for one of the three frame rate meters.
		* Each meter displays a frame rate average over its given interval.
		* 
		* @param which Zero-based meter index (0,1,2)
		* @param seconds Interval duration
		*/
		public function setFpsInterval(which:uint, seconds:Number):void {
			if (which >= 0 && which < NUM_METERS) {
				var s:String = String(seconds);
				labels[which].text = (s.charAt(0) == "0") ? s.substring(1, s.length) : s;
				timeChecks[which] = getTimer();
				timeCheckIntervals[which] = seconds*1000;
			}
		}
		
		/**
		* Activate frame rate monitoring.
		*/
		public function startMonitoring():void {
			addEventListener(Event.ENTER_FRAME, countFrame);
			updateTimer = new Timer(UPDATE_INTERVAL);
			updateTimer.addEventListener(TimerEvent.TIMER, update);
			updateTimer.start();
			for (var i:uint = 0; i < NUM_METERS; i++) {
				timeCheckTimers[i] = new Timer(timeCheckIntervals[i]);
				timeCheckTimers[i].addEventListener(TimerEvent.TIMER, timeCheckHandlers[i]);
				timeCheckTimers[i].start();
			}
		}
		
		/**
		* Terminate frame rate monitoring.
		*/
		public function stopMonitoring():void {
			updateTimer.stop();
			removeEventListener(Event.ENTER_FRAME, countFrame);
			for (var i:uint = 0; i < NUM_METERS; i++) {
				timeCheckTimers[i].stop();
				timeCheckTimers[i].removeEventListener(TimerEvent.TIMER, timeCheckHandlers[i]);
			}
		}
		
		
		
		private function buildParts():void {
			buildMeterShadows()
			buildMeters();
			
			targetLine = new Shape();
			targetLine.graphics.beginFill(0x00ff00);
			targetLine.graphics.drawRect(0,0, 1,27);
			targetLine.graphics.endFill();
			meterContainer.addChild(targetLine);
			
			var format:TextFormat = new TextFormat();
			format.font = "FONT";
			format.color = 0x000000;
			format.size = 9;
			format.align = TextFormatAlign.LEFT;
			
			buildLabels(format);
			buildDisplays(format);
		}
		
		private function buildMeterShadows():void {
			meterShadowContainer = new Sprite();
			var s:Shape;
			for (var i:uint = 0; i < NUM_METERS; i++) {
				s = new Shape();
				s.graphics.beginFill(0x000000, .25);
				s.graphics.drawRect(0,0, 100,7);
				s.graphics.endFill();
				s.y = (i*10);
				meterShadowContainer.addChild(s);
			}
			meterShadowContainer.x = 12;
			addChild(meterShadowContainer);
		}
		
		private function buildMeters():void {
			meterContainer = new Sprite();
			for (var i:uint = 0; i < NUM_METERS; i++) {
				meters[i] = new Shape();
				meters[i].graphics.beginFill(0x000000);
				meters[i].graphics.drawRect(0,0, 100,7);
				meters[i].graphics.endFill();
				meters[i].y = (i*10);
				meterContainer.addChild(meters[i]);
			}
			meterContainer.x = 12;
			addChild(meterContainer);
		}
		
		private function buildLabels(format:TextFormat):void {
			for (var i:uint = 0; i < NUM_METERS; i++) {
				labels[i] = new TextField();
				labels[i].defaultTextFormat = format;
				labels[i].embedFonts = true;
				labels[i].multiline = false;
				labels[i].selectable = false;
				labels[i].wordWrap = false;
				labels[i].text = "99";
				labels[i].y = (i*10) - 5;
				addChild(labels[i]);
			}
		}
		
		private function buildDisplays(format:TextFormat):void {
			for (var i:uint = 0; i < NUM_METERS; i++) {
				displays[i] = new TextField();
				displays[i].defaultTextFormat = format;
				displays[i].embedFonts = true;
				displays[i].multiline = false;
				displays[i].selectable = false;
				displays[i].wordWrap = false;
				displays[i].text = "99";
				displays[i].x = 112;
				displays[i].y = (i*10) - 5;
				addChild(displays[i]);
			}
		}
		
		private function fillBar(bar:Shape, color:uint):void {
			var w:Number = bar.width;
			var h:Number = bar.height;
			bar.graphics.clear();
			bar.graphics.beginFill(color);
			bar.graphics.drawRect(0,0, w,h);
			bar.graphics.endFill();
		}
		
		private function update(e:TimerEvent):void {
			var t:Number = getTimer();
			for (var which:uint = 0; which < NUM_METERS; which++) {
				var v:int = Math.round( (frameCounts[which] * 1000) / ( t - timeChecks[which]) );
				v = Math.max(1, Math.min(99, v));
				(v < targetFps) ? fillBar(meters[which], 0xff2211) : fillBar(meters[which], 0x000000);
				meters[which].width = v;
				displays[which].text = v;
				displays[which].x = v + 12;
			}
		}
		
		private function countFrame(e:Event):void {
			for (var i:uint = 0; i < NUM_METERS; i++) {
				frameCounts[i]++;
			}
		}
		
		private function timeCheck(which:uint):void {
			var t:Number = getTimer();
			timeChecks[which] = t;
			frameCounts[which] = 0;
		}
		private function timeCheck1(e:TimerEvent):void { timeCheck(0); }
		private function timeCheck2(e:TimerEvent):void { timeCheck(1); }
		private function timeCheck3(e:TimerEvent):void { timeCheck(2); }

	}
}
