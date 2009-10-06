
package com.pixeldroid.r_c4d3.scores {
 

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	import com.adobe.serialization.json.JSON;

	import com.pixeldroid.r_c4d3.data.DataEvent;
	import com.pixeldroid.r_c4d3.data.JsonLoader;
	import com.pixeldroid.r_c4d3.scores.HighScores;
	import com.pixeldroid.r_c4d3.scores.ScoreEvent;

	/**
	* Dispatched when the score saving process has completed.
	* 
	* @eventType com.pixeldroid.r_c4d3.scores.ScoreEvent.SAVE
	*/
	[Event(name="save", type="com.pixeldroid.r_c4d3.scores.ScoreEvent")]
	/**
	* Dispatched when the score retrieval process has completed.
	* 
	* @eventType com.pixeldroid.r_c4d3.scores.ScoreEvent.LOAD
	*/
	[Event(name="load", type="com.pixeldroid.r_c4d3.scores.ScoreEvent")]
	/**
	* Dispatched when the score posting or retrieval process fails.
	* 
	* @eventType com.pixeldroid.data.DataEvent.ERROR
	*/
	[Event(name="dataError", type="com.pixeldroid.data.DataEvent")]


	/**
	* <code>RemoteHighScores</code> extends the abstract HighScores base class to
	* store the contents of HighScores instance to a remote server,
	* using a web service that accepts the following parameters:<ul>
	* <li><code>game</code> : <i>String</i> Unique game id</li>
	* <li><code>format</code> : <i>String</i> "json" or "vrml"</li>
	* <li><code>data</code> : <i>String</i> Score data--as json string--to store; omission or empty value for data triggers retrieval</li>
	* </ul>
	* and returns the following data:<ul>
	* <li><code>type</code>: <i>String</i> "get" or "set"</li>
	* <li><code>success</code> : <i>Boolean</i></li>
	* <li><code>message</code> : <i>String</i></li>
	* <li><code>data</code> : <i>String</i> Score data as json string</li>
	* </ul>
	*
	* Notes:<ul>
	* <li>Requires <code>com.adobe.serialization.json.JSON</code></li>
	* 
	* @see com.pixeldroid.r_c4d3.scores.HighScores
	* @see com.adobe.serialization.json.JSON
	* @see http://code.google.com/p/as3corelib/
	*/
	public class RemoteHighScores extends HighScores implements IEventDispatcher {
		
		private var _remoteUrl:String;
		
		private var storeRequest:URLRequest;
		private var retrieveRequest:URLRequest;
		
		private var storeEvent:ScoreEvent;
		private var retrieveEvent:ScoreEvent;
	
		private var JL:JsonLoader;
		private var ED:EventDispatcher;
	
	
	
		/**
		*
		* @param id A unique identifier for this set of scores and initials
		* @param maxScores The maximum number of entries to store
		* @param accessUrl The storage webservice URL
		*/
		public function RemoteHighScores(id:String=null, maxScores:int=10, accessUrl:String=null) {
			super(id, maxScores);
	
			JL = new JsonLoader();
			JL.addEventListener(DataEvent.READY, onJsonData);
			JL.addEventListener(DataEvent.ERROR, onJsonError);
			
			ED = new EventDispatcher(this);
			
			storeEvent = new ScoreEvent(ScoreEvent.SAVE);
			retrieveEvent = new ScoreEvent(ScoreEvent.LOAD);
			
			if (accessUrl) remoteUrl = accessUrl;
		}
	
	
		/**
		* Provide the high score storage webservice URL.
		* @param value A URL to a webservice that supports 
		* game (string), format ('json' | 'vrml') and data (string) query params
		*/
		public function set remoteUrl(value:String):void
		{
			_remoteUrl = value;
			storeRequest = new URLRequest(_remoteUrl);
			storeRequest.method = URLRequestMethod.GET;
			retrieveRequest = new URLRequest(_remoteUrl);
			retrieveRequest.method = URLRequestMethod.GET;
		}
		public function get remoteUrl():String { return _remoteUrl; }
	
		/** @inheritdoc */
		override public function closeScoresTable():void
		{
			super.closeScoresTable();
			
			storeRequest = null;
			retrieveRequest = null;
		}
	
		/** @inheritdoc */
		override public function openScoresTable(gameId:String):void
		{
			super.openScoresTable(gameId);
			
			if (gameId) load();
		}
		
		public function load():void {
			if (!retrieveRequest) return;
			
			var rVar:URLVariables = new URLVariables();
			rVar.format = "json";
			rVar.game = gameId;
			
			retrieveRequest.data = rVar;
			JL.load(retrieveRequest);
		}
		
		override public function store():void {
			if (!storeRequest) return;
			
			var sVar:URLVariables = new URLVariables();
			sVar.format = "json";
			sVar.game = gameId;
			sVar.data = this.toJson();
			
			storeRequest.data = sVar;
			JL.load(storeRequest);
		}
		
		override public function initialize(id:String=null):void {
			scores = [];
			initials = [];
		}
		
		public function toJson():String {
			return JSON.encode( {scores:scores, initials:initials} );
		}

		
		// EventDispatcher Interface
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			ED.addEventListener(type, listener, useCapture, priority);
		}
		  
		public function dispatchEvent(evt:Event):Boolean{
			return ED.dispatchEvent(evt);
		}
		
		public function hasEventListener(type:String):Boolean{
			return ED.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			ED.removeEventListener(type, listener, useCapture);
		}
					 
		public function willTrigger(type:String):Boolean {
			return ED.willTrigger(type);
		}

	
	
		private function onJsonError(e:DataEvent):void {
			dispatchEvent(e);
		}
		
		private function onJsonData(e:DataEvent):void {
			//trace("[RemoteHighScores] - onJsonData: " +e.message);
			var serverResponse:Object = e.data;
			switch (serverResponse.type) {
				case ("set") :
					if (serverResponse.success == true) {
					}
					
					else {
						trace("[RemoteHighScores] - communication error: " +serverResponse.message);
					}
	
					storeEvent.success = serverResponse.success;
					storeEvent.message = serverResponse.message;
					dispatchEvent(storeEvent);
				break;
	
				case ("get") :
					if ((serverResponse.success == true)) {
						this.scores = serverResponse.data.scores;
						this.initials = serverResponse.data.initials;
					}
	
					else {
						trace("[RemoteHighScores] - communication error: " +serverResponse.message);
					}
	
					retrieveEvent.success = serverResponse.success;
					retrieveEvent.message = serverResponse.message;
					dispatchEvent(retrieveEvent);
				break;
				
				default:
					trace("[RemoteHighScores] - unrecognized response type " +serverResponse.type);
				break;
			}
	
		}
	
	}

}
