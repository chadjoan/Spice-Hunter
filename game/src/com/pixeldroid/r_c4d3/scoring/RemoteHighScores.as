
package com.pixeldroid.r_c4d3.scoring {
 

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	import com.adobe.serialization.json.JSON;

	import com.pixeldroid.data.DataEvent;
	import com.pixeldroid.data.JsonLoader;
	import com.pixeldroid.r_c4d3.scoring.HighScores;
	import com.pixeldroid.r_c4d3.scoring.ScoreEvent;

	/**
	* Dispatched when the score retrieval process has completed.
	* 
	* @eventType com.pixeldroid.r_c4d3.scoring.ScoreEvent.SCORES_READY
	*/
	[Event(name="save", type="com.pixeldroid.r_c4d3.scoring.ScoreEvent")]
	[Event(name="load", type="com.pixeldroid.r_c4d3.scoring.ScoreEvent")]
	[Event(name="dataError", type="com.pixeldroid.data.DataEvent")]

	/**
	* Stores the contents of HighScores instance to a remote server,
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
	*/
	public class RemoteHighScores extends HighScores implements IEventDispatcher {
	
		
		private var storeRequest:URLRequest;
		private var retrieveRequest:URLRequest;
		
		private var gameId:String;
		
		private var storeEvent:ScoreEvent;
		private var retrieveEvent:ScoreEvent;
	
		private var JL:JsonLoader;
		private var ED:EventDispatcher;
	
	
	
		/**
		*
		* @param id A unique identifier for this set of scores and initials
		* @param maxScores The maximum number of entries to store
		* @param remoteUrl The storage webservice URL
		*/
		public function RemoteHighScores(id:String, maxScores:uint, remoteUrl:String) {
			super(id, maxScores);
			
			storeEvent = new ScoreEvent(ScoreEvent.SAVE);
			storeRequest = new URLRequest(remoteUrl);
			storeRequest.method = URLRequestMethod.GET;
			
			retrieveEvent = new ScoreEvent(ScoreEvent.LOAD);
			retrieveRequest = new URLRequest(remoteUrl);
			retrieveRequest.method = URLRequestMethod.GET;
	
			JL = new JsonLoader();
			JL.addEventListener(DataEvent.READY, onJsonData);
			JL.addEventListener(DataEvent.ERROR, onJsonError);
			
			ED = new EventDispatcher(this);
			
			gameId = id;
		}
	
	
	
		protected override function initialize(id:String=null):void {
			scores = [];
			initials = [];
		}
		
		public function load():void {
			var rVar:URLVariables = new URLVariables();
			rVar.format = "json";
			rVar.game = gameId;
			
			retrieveRequest.data = rVar;
			JL.load(retrieveRequest);
		}
		
		public override function store():void {
			var sVar:URLVariables = new URLVariables();
			sVar.format = "json";
			sVar.game = gameId;
			sVar.data = this.toJson();
			
			storeRequest.data = sVar;
			JL.load(storeRequest);
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
			trace("[RemoteHighScores] - onJsonData: " +e.message);
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