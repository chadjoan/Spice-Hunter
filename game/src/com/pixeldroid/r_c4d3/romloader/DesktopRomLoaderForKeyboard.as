
package com.pixeldroid.r_c4d3.romloader
{

	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	
	import com.pixeldroid.interfaces.IGameRom;
	import com.pixeldroid.r_c4d3.controls.KeyboardGameControlsProxy;
	import com.pixeldroid.r_c4d3.romloader.ConfigDataProxy;
	import com.pixeldroid.r_c4d3.romloader.HaxeSideDoor;
	import com.pixeldroid.r_c4d3.scoring.LocalHighScores;

	
	
	/**
	Loads a valid IGameRom SWF and provides access to an IGameControlsProxy
	and an IGameHighScoresProxy. 
	
	<p>
	The IGameRom SWF url to load is defined in a companion xml file that must 
	live in the same folder as the 	DesktopRomLoaderForKeyboard SWF and be
	named <code>romloader-config.xml</code>.
	</p>
	
	<p>
	Game control events are triggered by keyboard events. The particular keys 
	are defined in a companion xml file that must live in the same folder as the 
	DesktopRomLoaderForKeyboard SWF and be named <code>romloader-config.xml</code>.
	</p>
	
	@example Sample <code>romloader-config.xml</code>:
	<listing version="3.0">
    &lt;configuration&gt;
        &lt;!-- trace logging on when true --&gt;
        &lt;logging enabled="true" /&gt;

        &lt;!-- rom to load --&gt;
        &lt;rom file="../controls/ControlTestGameRom.swf" /&gt;

        &lt;!-- key mappings, player numbers start at 1 --&gt;
        &lt;keymappings&gt;
            &lt;joystick playerNumber="1"&gt;
				&lt;hatUp    keyCode="38" /&gt;
				&lt;hatRight keyCode="39" /&gt;
				&lt;hatLeft  keyCode="37" /&gt;
				&lt;hatDown  keyCode="40" /&gt;
				&lt;buttonY  keyCode="17" /&gt;
				&lt;buttonR  keyCode="46" /&gt;
				&lt;buttonG  keyCode="35" /&gt;
				&lt;buttonB  keyCode="34" /&gt;
            &lt;/joystick&gt;
        &lt;/keymappings&gt;
    &lt;/configuration&gt;
	</listing>

	<p>Note: <i>
	Due to the way HaXe inserts top-level classes when compiling a SWF,
	HaXe users must use the HaxeSideDoor to declare IGameRom compliance.
	</i></p>
	
	@see com.pixeldroid.interfaces.IGameControlsProxy
	@see com.pixeldroid.interfaces.IGameHighScoresProxy
	@see HaxeSideDoor
	*/
	public class DesktopRomLoaderForKeyboard extends Sprite
	{
		private var romLoader:Loader;
		private var xmlLoader:URLLoader;
		private var configData:ConfigDataProxy;
		private var controlsProxy:KeyboardGameControlsProxy;
		private var highScoresProxy:LocalHighScores;
		
		private static const configUrl:String = "romloader-config.xml";
		
		protected var preloaderContainer:Sprite;
		protected var swfBytesLoaded:int;
		protected var swfBytesTotal:int;
		protected var swfLoaded:Boolean;
		protected var xmlBytesLoaded:int;
		protected var xmlBytesTotal:int;
		protected var xmlLoaded:Boolean;



		/**
		Constructor.
		
		<p>
		Creates a rom loader designed to interpret keyboard events as game control events.
		</p>
		*/
		public function DesktopRomLoaderForKeyboard()
		{
			super();
			
			romLoader = Loader(addChild(new Loader()));
			romLoader.visible = false;
			xmlLoader = new URLLoader();

			preloaderContainer = Sprite(addChild(new Sprite()));
			swfLoaded = false;
			xmlLoaded = false;

			addChildren(preloaderContainer);
			_addListeners();
			openPreloader();
		}

		protected function addChildren(container:DisplayObjectContainer):void
		{
			// to be overridden
			// base implementation creates a thin rectangle across the screen
			var progressBar:Shape = Shape(container.addChild(new Shape()));
			progressBar.x = 0;
			progressBar.y = stage.stageHeight * .5 - 2;

			var progressBarOutline:Shape = Shape(container.addChild(new Shape()));
			progressBarOutline.x = 0;
			progressBarOutline.y = progressBar.y;
			var g:Graphics = progressBarOutline.graphics;
			g.lineStyle(1, 0x222222);
			g.drawRect(0, 0, stage.stageWidth-1, 4);
		}

		protected function openPreloader():void
		{
			// to be overridden
			onPreloaderOpened(null);
		}

		protected function onPreloadProgress(e:ProgressEvent):void
		{
			// to be overridden
			// base implementation draws a thin rectangle across the screen
			var progress:Number = (e.bytesTotal > 0) ? (e.bytesLoaded / e.bytesTotal) : 0;
			var w:int = Math.round(progress * stage.stageWidth);
			var g:Graphics;

			var progressBar:Shape = Shape(preloaderContainer.getChildAt(0));
			progressBar.x = 0;
			progressBar.y = stage.stageHeight * .5 - 2;

			g = progressBar.graphics;
			g.clear();
			g.beginFill(0x444444, .6);
			g.drawRect(0, 0, w, 4);
			g.endFill();

			var progressBarOutline:Shape = Shape(preloaderContainer.getChildAt(1));
			progressBarOutline.x = 0;
			progressBarOutline.y = progressBar.y;

			g = progressBarOutline.graphics;
			g.clear();
			g.lineStyle(1, 0x222222);
			g.drawRect(0, 0, stage.stageWidth-1, 4);
		}

		protected function closePreloader():void
		{
			// to be overridden
			onPreloaderClosed(null);
		}




		/*
			Triggered as swf bytes are loaded.

			Calls updateProgress().
		*/
		protected function onSwfProgress(e:ProgressEvent):void
		{
			swfBytesLoaded = e.bytesLoaded;
			swfBytesTotal = e.bytesTotal;
			updateProgress();
		}

		/*
			Triggered when all swf bytes are loaded.

			Calls closePreloader() if all xml bytes are also loaded.
		*/
		protected function onSwfComplete(e:Event):void
		{
			swfLoaded = true;
			closePreloader();
		}

		/*
			Triggered as xml bytes are loaded.

			Calls updateProgress().
		*/
		protected function onXmlProgress(e:ProgressEvent):void
		{
			xmlBytesLoaded = e.bytesLoaded;
			xmlBytesTotal = e.bytesTotal;
			updateProgress();
		}

		/*
			Triggered when all xml bytes are loaded.

			Calls closePreloader() if all swf bytes are also loaded.
		*/
		protected function onXmlComplete(e:Event):void
		{
			xmlLoaded = true;
			configData = new ConfigDataProxy(xmlLoader.data);

			loadSwf();
		}

		/*
			Triggered when an IOError occurs.

			Writes the IOErrorEvent.toString() to the tracelog.
		*/
		protected function onIoError(e:IOErrorEvent):void
		{
			trace("IO Error: " +e);
			closePreloader();
		}

		/*
			Triggered when an SecurityError occurs.

			Writes the SecurityErrorEvent.toString() to the tracelog.
		*/
		protected function onSecurityError(e:SecurityErrorEvent):void
		{
			trace("Security Error: " +e);
			closePreloader();
		}

		/*
			Event hook to add as listener to an event marking
			the completion of the preloader opening animation.

			Calls initiateLoad()

			This base implementation calls onPreloaderOpened() from openPreloader()

			@see initiateLoad
		*/
		protected function onPreloaderOpened(e:Event):void
		{
			loadXml();
		}

		/*
			Event hook to add as listener to an event marking
			the completion of the preloader closing animation.

			Calls finalizeLoad()

			This base implementation calls onPreloaderClosed() from closePreloader()
		*/
		protected function onPreloaderClosed(e:Event):void
		{
			finalizeLoad();
		}

		/*
			Triggered by onPreloaderOpened.
		*/
		protected function loadXml():void
		{
            xmlLoader.load(new URLRequest(configUrl));
		}

		/*
			Triggered by onXmlComplete.
		*/
		protected function loadSwf():void
		{
			try { romLoader.load(new URLRequest(configData.romUrl)); }
			catch(e:Error) { C.out(this, "Error - rom could not be loaded: " +e); }
		}
		

		/*
			Triggered by onSwfProgress and onXmlProgress.

			Creates a new ProgressEvent that totals the swf and xml bytes loaded and bytes total.
			Calls onPreloadProgress() with new ProgressEvent.

			@see ProgressEvent
		*/
		protected function updateProgress():void
		{
			var e:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
			e.bytesLoaded = swfBytesLoaded + xmlBytesLoaded;
			e.bytesTotal = swfBytesTotal + xmlBytesTotal;
			onPreloadProgress(e);
		}

		/*
			Triggered by onPreloaderClosed.
		*/
		protected function finalizeLoad():void
		{
			C.out(this, "finalizeLoad");
            _removeListeners();
            removeChild(preloaderContainer);

            if (romLoader.content)
			{
				var gameRom:IGameRom;
				
				if (romLoader.content is IGameRom) gameRom = IGameRom(romLoader.content);
				else if (getQualifiedClassName(romLoader.content) == "flash::Boot")
				{
					if (HaxeSideDoor.romInstance && HaxeSideDoor.romInstance is IGameRom) gameRom = IGameRom(HaxeSideDoor.romInstance);
				}
				else trace("finalizeLoad() - Error: content is not a valid rom (" +getQualifiedClassName(romLoader.content) +")");
				
				if (gameRom)
				{
					C.out(this, "finalizeLoad() - valid game rom found, sending over controls proxy and scores proxy")
					
					// provide access to game controls and high scores
					controlsProxy = new KeyboardGameControlsProxy();
					var k:ConfigDataProxy = configData;
					if (k.p1HasKeys) controlsProxy.setKeys(0, k.p1U, k.p1R, k.p1D, k.p1L, k.p1X, k.p1A, k.p1B, k.p1C); else C.out(this, "no keys for p1");
					if (k.p2HasKeys) controlsProxy.setKeys(1, k.p2U, k.p2R, k.p2D, k.p2L, k.p2X, k.p2A, k.p2B, k.p2C); else C.out(this, "no keys for p2");
					if (k.p3HasKeys) controlsProxy.setKeys(2, k.p3U, k.p3R, k.p3D, k.p3L, k.p3X, k.p3A, k.p3B, k.p3C); else C.out(this, "no keys for p3");
					if (k.p4HasKeys) controlsProxy.setKeys(3, k.p4U, k.p4R, k.p4D, k.p4L, k.p4X, k.p4A, k.p4B, k.p4C); else C.out(this, "no keys for p4");
					
					highScoresProxy = new LocalHighScores();
					
					romLoader.visible = true; // reveal container
					
					gameRom.setControlsProxy(controlsProxy);
					gameRom.setHighScoresProxy(highScoresProxy);
					
					C.out(this, "finalizeLoad() - game should be ready, calling enterAttractLoop()")
					gameRom.enterAttractLoop();
				}
			}
			else C.out(this, "finalizeLoad() - Error: content unable to be loaded");
		}

		/**
		 * @inheritDoc
		 */
		protected function addListeners():void
		{
			// to be overridden
			// base implementation does nothing.
		}

		/**
		 * @inheritDoc
		 */
		protected function removeListeners():void
		{
			// to be overridden
			// base implementation does nothing.
		}
		
		
		
		private function _addListeners():void
		{
            romLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onSwfProgress);
			romLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSwfComplete);
            romLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);

            xmlLoader.addEventListener(ProgressEvent.PROGRESS, onXmlProgress);
			xmlLoader.addEventListener(Event.COMPLETE, onXmlComplete);
            xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
            xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);

            addListeners(); // let subclasses do their own
		}

		private function _removeListeners():void
		{
            romLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onSwfProgress);
			romLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onSwfComplete);
            romLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);

            xmlLoader.removeEventListener(ProgressEvent.PROGRESS, onXmlProgress);
			xmlLoader.removeEventListener(Event.COMPLETE, onXmlComplete);
            xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
            xmlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);

			removeListeners(); // ask subclasses to clean up their listeners
		}
	}
}