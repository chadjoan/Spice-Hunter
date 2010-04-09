

package com.pixeldroid.r_c4d3.scores 
{
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;
	

	/**
	* Base class for high score storage and retrieval.
	*
	* Notes:<ul>
	* <li>Scores are kept in descending order (highest first)</li>
	* <li>Ties are allowed (same score, different initials), duplicates are not</li>
	*/
	public class HighScores implements IGameScoresProxy
	{


		private var MAX_SCORES:int;
		private var _gameId:String;
		protected var scores:Array;
		protected var initials:Array;



		/**
		* @param id A unique identifier for this set of scores and initials
		* @param maxScores The maximum number of entries to store
		*/
		public function HighScores(id:String=null, maxScores:int=10) {
			if(maxScores) totalScores = maxScores;
			if(id) openScoresTable(id);
		}

		/** @inheritdoc */
		public function openScoresTable(gameId:String):void
		{
			if (gameId.length > 0 && gameId.length <= 32 && isApprovedChars(gameId))
			{
				_gameId = gameId;
				initialize(_gameId);
			}
			else
			{
				//C.out(this, "Error - invalid game id: '" +gameId+"'");
				_gameId = null;
			}
		}
		
		/** @inheritdoc */
		public function get gameId():String { return _gameId; }
		
		/** @inheritdoc */
		public function closeScoresTable():void
		{
			store();
			_gameId = null;
		}
		
		/** @inheritdoc */
		public function set totalScores(value:int):void
		{
			if (value > 0 && value <= 100) MAX_SCORES = value;
			else
			{
				//C.out(this, "Error - invalid value for totalScores: " +value);
				MAX_SCORES = 0;
			}
		}
		public function get totalScores():int { return MAX_SCORES; }
		
		private function isApprovedChars(s:String):Boolean
		{
			return ("abc".match(/\W/g).length == 0);
		}

		/**
		* A quick rejection test for candidate scores.
		* 
		* When <code>false</code> is returned, the score is definitely not eligible,
		* but when <code>true</code> is returned the score may still be ineligible if 
		* it is a duplicate of one already stored.
		* @see #insert
		* @param s A score
		* @return <code>true</code> if score is a candidate for inclusion, <code>false</code> if not
		*/
		public function isEligible(score:Number):Boolean {
			return (
				(score > 0)
				&&
				((scores.length < MAX_SCORES) || (scores[scores.length - 1] < score))
			);
		}


		/**
		* Retrieve a score by zero-based rank index.
		* 
		* <em>Note:</em> Scores are stored in descending order (highest first).
		* @param i Index of score to retrieve. [0, MAX_SCORES)
		* @return The score matching the rank index; null if rank is invalid or no scores exist.
		*/
		public function getScore(i:int):Number {
			var s:Number = (0 <= i && i < scores.length) ? scores[i] : null;
			return s;
		}


		/**
		* Retrieve a set of initials by zero-based rank index.
		* 
		* <em>Note:</em> Initials are stored in descending order (highest first),
		* based on the score they are associated with.
		* @param i Index of initials to retrieve. [0, MAX_SCORES)
		* @return The initials string matching the rank index; null if rank is invalid or no scores exist.
		*/
		public function getInitials(i:int):String {
			var s:String = (0 <= i && i < initials.length) ? initials[i] : null;
			return s;
		}


		/**
		* Add a score and associated initials string into the high score list,
		* possibly bumping off the lowest score.
		* 
		* The new score and initials string will be added in rank order.
		* 
		* If adding the new score and initals string creates more than
		* MAX_SCORES entries, then the lowest rank score will be bumped off the list.
		* @param s The score to add
		* @param i The string of initials to add
		*/
		public function insert(s:Number, i:String):Boolean {
			return _insert(s, i, scores, initials, MAX_SCORES);
		}


		/**
		* Test the insertion of multiple scores in one call.
		* 
		* @param N An array of scores to test
		* @return An array of Booleans, indicating whether the score at 
		* the same index would be inserted or not.
		*/
		public function testInsert(N:Array):Array {
			var results:Array = new Array();
			var S:Array = [];
			var I:Array = [];
			
			var b:Boolean;
			var totalScores:uint = N.length;
			for (var i:uint = 0; i < totalScores; i++) {
				b = (isEligible(N[i]) && _insert(N[i], ("~"+i+"~"+i+"~"), S, I, MAX_SCORES) );
				results.push(b);
			}
			return results;
		}


		/**
		* Clear the high score list, erasing all scores and initials.
		*/
		public function reset():void {
			scores = [];
			initials = [];
			store();
		}


		/**
		* Write the scores and initials to the storage medium.
		<strong>To be overridden by subclasses</strong>
		*/
		public function store():void {
			// sub-classes should override this method
		}


		/**
		* Generate a human-readable version of the high score list.
		* @return A human-readable version of the contents of the high score list.
		*/
		public function toString():String {
		
			var hr:String = "- - - - - - - - - - - - - - - -\n";
			var s:String = hr;
			s += " High Scores:\n";
			/*
			var totalScores:uint = scores.length;
			var p:String;
			for (var i:uint = 0; i < totalScores; i++) {
				p = pad((i+1).toString(), 5, " ");
				s += p +". " +initials[i] +" : " +scores[i] +"\n";
			}
			s += hr;
			*/
			return s;
		}
		
		private static function pad(s:String, x:Number, c:String):String {
			while (s.length < x) { s = c + s; }
			return s;
		}


		/**
		* The total number of entries currently in the high score list.
		*/
		public function get length():uint {
			return scores.length;
		}


		public function initialize(id:String=null):void {
			// sub-classes should override this method
			reset();
		}
		
		
		private static function _insert(score:Number, initial:String, S:Array, I:Array, max:uint):Boolean {
			var added:Boolean = false;
			
			if (S.length == 0) {
				S.push(score);
				I.push(initial);
				added = true;
			}
			
			else {
				var resolved:Boolean = false;
				var k:uint = 0;

				while (k < S.length) {

					if (score > S[k]) {
						resolved = true;
						S.splice(k, 0, score);
						I.splice(k, 0, initial);
						added = true;
						break;
					}

					if (score == S[k]) {
						resolved = true;
						while (
							(k < S.length) &&
							(score == S[k])
						) {
							if (initial == I[k]) { return false; }
							k++;
						}
						S.splice(k, 0, score);
						I.splice(k, 0, initial);
						added = true;
						break;
					}

					k++;
				}

				if (S.length > max) {
					S.pop();
					I.pop();
				}
				else if (!resolved && (S.length < max)) {
					S.push(score);
					I.push(initial);
					added = true;
				}
			}
			
			return added;
		}

	}

}
