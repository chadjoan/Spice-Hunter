
package com.pixeldroid.r_c4d3.scoring {
	
	import com.pixeldroid.r_c4d3.scoring.HighScores;
	
	import flash.net.SharedObject;

	
	
	/**
	* Stores a set of high scores and initials on the local hard drive,
	* using a local SharedObject.
	*/
	public class LocalHighScores extends HighScores {
	
		private var LSO:SharedObject;
	
	
		/**
		* @param id A unique identifier for this set of scores and initials
		* @param maxScores The maximum number of entries to store
		*/
		public function LocalHighScores(id:String, maxScores:uint = 100) {
			super(id, maxScores);
		}
	
	
		/**
		* Commit the score entries to file
		*/
		public override function store() {
			LSO.data.scoreList.scores = this.scores;
			LSO.data.scoreList.initials = this.initials;
			LSO.flush();
		}
	
	
	
		protected override function initialize(id:String) {
			LSO = SharedObject.getLocal(id);
			if (LSO.data.scoreList == null) {
				LSO.data.scoreList = { scores:[], initials:[] };
			}
			this.scores = LSO.data.scoreList.scores;
			this.initials = LSO.data.scoreList.initials;
		}
	
	}
	
}
