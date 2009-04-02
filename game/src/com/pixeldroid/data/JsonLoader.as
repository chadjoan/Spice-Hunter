package com.pixeldroid.data {
 

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

	[Event(name="ready", type="com.pixeldroid.data.DataEvent")]
	[Event(name="error", type="com.pixeldroid.data.DataEvent")]

	public class JsonLoader extends EventDispatcher {
	
		private var UL:URLLoader;
		
		private var dataReady:DataEvent;
		private var dataError:DataEvent;
		
		private var _bytesLoaded:uint;
		private var _bytesTotal:uint;
	
	
	
      public function JsonLoader(request:URLRequest = null) {
			dataReady = new DataEvent(DataEvent.READY);
			dataError = new DataEvent(DataEvent.ERROR);
			
			UL = new URLLoader();
			UL.dataFormat = URLLoaderDataFormat.TEXT;
			configureListeners(UL);

			if (request != null) { load(request); }
		}
		
		public function load(request:URLRequest):void {
			try {
				_bytesLoaded = 0;
				_bytesTotal = 0;
				UL.load(request);
  			trace("[JsonLoader] load executed");
			}
			catch (error:Error) {
				dataError.message = "unable to load requested document";
				trace(dataError.message);
				dispatchEvent(dataError);
			}
			trace("[JsonLoader] load end");
		}
		
		public function get percent():uint {
			var p:uint = (_bytesTotal > 0) ? Math.round(_bytesLoaded / _bytesTotal * 100) : 0;
			return p;
		}
		
		public function get bytesLoaded():uint {
			return _bytesLoaded;
		}
		
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
			trace("[JsonLoader] - completeHandler: " + loader.data);
			dataReady.data = JSON.decode(loader.data);
			dataReady.message = "json data load completed (" +_bytesTotal +")";
			dispatchEvent(dataReady);
		}
		
		private function securityErrorHandler(e:SecurityErrorEvent):void {
			trace("[JsonLoader] - securityErrorHandler: " + e);
			dataError.message = e.text;
			dispatchEvent(dataError);
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void {
			trace("[JsonLoader] - ioErrorHandler: " + e);
			dataError.message = e.text;
			dispatchEvent(dataError);
		}
		
		private function openHandler(e:Event):void {
			//trace("[JsonLoader] - openHandler: " + e);
		}
		
		private function progressHandler(e:ProgressEvent):void {
			trace("[JsonLoader] - progressHandler loaded:" + e.bytesLoaded + " total: " + e.bytesTotal);
			_bytesLoaded = e.bytesLoaded;
			_bytesTotal = e.bytesTotal;
		}
		
		private function httpStatusHandler(e:HTTPStatusEvent):void {
			trace("[JsonLoader] - httpStatusHandler: " + e);
		}
    }
}