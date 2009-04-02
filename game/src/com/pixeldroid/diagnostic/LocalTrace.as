
package com.pixeldroid.diagnostic {
	
	import flash.events.AsyncErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;


	/**
	* Localtrace sends trace messages over a LocalConnection.
	* A swf running in another player instance (stand-alone, web browser, etc.) 
	* can listen on the same connection channel for the messages and display them.
	* LocalTrace sends two messages that a listener can implement: <code>out</code>, 
	* and <code>clear</code>.
	*
	* @see Outlog
	*/
	public class LocalTrace {
	
		public static const DEFAULT_CHANNEL:String = "LOCALTRACE";
		public static const TRACE:String = "out";
		public static const CLEAR:String = "clear";
	
		private static var traceSender:LocalConnection;
		private static var channelId:String;
		
		private var sending:Boolean;


		
		/**
		* Create a new LocalTrace instance for messaging a console running in another instance of Flash Player.
		* 
		* @param channel A custom channel name to use for the local connection. 
		*/
		public function LocalTrace(channel:String = DEFAULT_CHANNEL) {
			trace("in");
			channelId = channel;
			sending = true;
			trace("cnx");
			var C:LocalConnection = getConnection();
			C.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			C.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			C.addEventListener(StatusEvent.STATUS, onStatus);
		}
		
		private function onAsyncError(e:AsyncErrorEvent):void {
			trace("async error", e);
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void {
			trace("security error", e);
		}
		
		private function onStatus(e:StatusEvent):void {
			trace("status: " +e.level +" [" +e.code +"]");
		}
		
	
		/**
		* Send a message over the LocalTrace local connection (if not currently paused).
		* 
		* @param msg The message to send
		* 
		* @see pause
		*/
		public function out(msg:String):void {
			if (sending) {
				trace("sending '" +msg +"'");
				getConnection().send(
					channelId,
					TRACE,
					msg
				);
			}
		}
	
		/**
		* Send a request to clear any listening console(s).
		*/
		public function clear():void {
			getConnection().send(
				channelId,
				CLEAR
			);
		}
	
		/**
		* Prevent this instance from sending messages until resume() is called.
		* 
		* @see resume
		*/
		public function pause():void {
			sending = false;
		}
	
	
		/**
		* Allow this instance to send messages again after pasue() is called.
		* 
		* @see pause
		*/
		public function resume():void {
			sending = true;
		}

	
		private function getConnection():LocalConnection {
			if (traceSender == null) {
				traceSender = new LocalConnection();
			}
			return traceSender;
		}
	
	}
}
