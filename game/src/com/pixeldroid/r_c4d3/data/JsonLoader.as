package com.pixeldroid.r_c4d3.data {
 

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	import com.adobe.serialization.json.JSON;

	/**
	* Dispatched when the data retreival process has completed.
	* 
	* @eventType com.pixeldroid.r_c4d3.data.DataEvent.READY
	*/
	[Event(name="ready", type="com.pixeldroid.r_c4d3.data.DataEvent")]
	/**
	* Dispatched when the data retreival process has failed.
	* 
	* @eventType com.pixeldroid.r_c4d3.data.DataEvent.ERROR
	*/
	[Event(name="error", type="com.pixeldroid.r_c4d3.data.DataEvent")]


	/**
	* <code>JsonLoader</code> makes a JSON formatted http request and monitors the load progress.
	*
	* Notes:<ul>
	* <li>Requires <code>com.adobe.serialization.json.JSON</code></li>
	* 
	* @see http://code.google.com/p/as3corelib/
	*/
	public class JsonLoader extends EventDispatcher {
	
		private var UL:URLLoader;
		
		private var dataReady:DataEvent;
		private var dataError:DataEvent;
		
		private var _bytesLoaded:uint;
		private var _bytesTotal:uint;
	
	
	
		/**
		*
		* @param request An optional URLRequest to make immediately
		*/
		public function JsonLoader(request:URLRequest = null) {
			dataReady = new DataEvent(DataEvent.READY);
			dataError = new DataEvent(DataEvent.ERROR);
			
			UL = new URLLoader();
			UL.dataFormat = URLLoaderDataFormat.TEXT;
			configureListeners(UL);

			if (request != null) { load(request); }
		}
		
		/**
		* Attempt to load the provided URLRequest
		*
		* @param request URLRequest to make
		*/
		public function load(request:URLRequest):void {
			try {
				_bytesLoaded = 0;
				_bytesTotal = 0;
				UL.load(request);
			}
			catch (error:Error) {
				dataError.message = "unable to load requested document";
				trace(dataError.message);
				dispatchEvent(dataError);
			}
		}
		
		/**
		* Request the load progress percent.
		* Results are (0 - 100).
		*/
		public function get percent():uint {
			var p:uint = (_bytesTotal > 0) ? Math.round(_bytesLoaded / _bytesTotal * 100) : 0;
			return p;
		}
		
		/**
		* Request the number of bytes loaded.
		*/
		public function get bytesLoaded():uint {
			return _bytesLoaded;
		}
		
		/**
		* Request the total number of bytes to load.
		*/
		public function get bytesTotal():uint {
			return _bytesTotal;
		}


		
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}

		private function completeHandler(e:Event):void {
			var loader:URLLoader = URLLoader(e.target);
			//C.out(this, "completeHandler: " + loader.data);
			dataReady.data = JSON.decode(loader.data);
			dataReady.message = "json data load completed (" +_bytesTotal +")";
			dispatchEvent(dataReady);
		}
		
		private function securityErrorHandler(e:SecurityErrorEvent):void {
			//C.out(this, "securityErrorHandler: " + e);
			dataError.message = e.text;
			dispatchEvent(dataError);
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void {
			//C.out(this, "ioErrorHandler: " + e);
			dataError.message = e.text;
			dispatchEvent(dataError);
		}
		
		private function openHandler(e:Event):void {
			//C.out(this, "openHandler: " + e);
		}
		
		private function progressHandler(e:ProgressEvent):void {
			//C.out(this, "progressHandler loaded:" + e.bytesLoaded + " total: " + e.bytesTotal);
			_bytesLoaded = e.bytesLoaded;
			_bytesTotal = e.bytesTotal;
		}
		
		private function httpStatusHandler(e:HTTPStatusEvent):void {
			//C.out(this, "httpStatusHandler: " + e);
		}
    }
}
