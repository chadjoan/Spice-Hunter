
package com.pixeldroid.r_c4d3.data {

	import flash.events.Event;

	/**
	* <code>DataEvent</code> objects are dispatched in response to asynchronous data requests.
	* 
	* @see com.pixeldroid.r_c4d3.data.JsonLoader
	*/
	public class DataEvent extends Event {

	
		/**
		* Value of the <code>type</code> property of the event object for a <code>ready</code> event.
		* 
		* @eventType ready
		*/
		public static const READY:String = "ready";
		
		/**
		* Value of the <code>type</code> property of the event object for a <code>error</code> event.
		* 
		* @eventType error
		*/
		public static const ERROR:String = "error";

		/**
		* Information payload from the event broadcaster.
		*/
		public var data:Object;

		/**
		* Additional information from the event broadcaster.
		*/
		public var message:Object;



		/**
		* Creates a new DataEvent instance for a specific data event type.
		* 
		* @param type The data event flavor, e.g. <code>DataEvent.READY</code>
		*/
		public function DataEvent(type:String) {
			super(type); // bubbles and cancelable are optional
		}
		
		/**
		* @inheritDoc
		*/
		public override function clone():Event {
			// override clone so the event can be redispatched
			var e:DataEvent = new DataEvent(type);
			e.data = data;
			e.message = message;
			return e;
		}
		
	}
}
