
package com.pixeldroid.r_c4d3.scores {
	
	import flash.net.SharedObject;
	
	import com.pixeldroid.r_c4d3.scores.HighScores;

	
	
	/**
	* <code>LocalHighScores</code> extends the abstract HighScores base class to
	* store a set of high scores and initials on the local hard drive,
	* using a local SharedObject.
	* 
	* @see com.pixeldroid.r_c4d3.scores.HighScores
	*/
	public class LocalHighScores extends HighScores {
	
		private var LSO:SharedObject;
	
	
		/**
		* @param id A unique identifier for this set of scores and initials
		* @param maxScores The maximum number of entries to store
		*/
		public function LocalHighScores(id:String=null, maxScores:int=10) {
			super(id, maxScores);
		}
	
	
		/**
		* Commit the score entries to file
		*/
		override public function store():void {
			LSO.data.scoreList.scores = this.scores;
			LSO.data.scoreList.initials = this.initials;
			LSO.flush();
		}
	
	
	
		override public function initialize(id:String=null):void {
			LSO = SharedObject.getLocal(id);
			if (LSO.data.scoreList == null) {
				LSO.data.scoreList = { scores:[], initials:[] };
			}
			this.scores = LSO.data.scoreList.scores;
			this.initials = LSO.data.scoreList.initials;
		}
	
	}
	
}
