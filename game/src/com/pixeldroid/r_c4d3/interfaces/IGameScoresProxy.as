
package com.pixeldroid.r_c4d3.interfaces
{


	public interface IGameScoresProxy
	{
		
		/**
		* Open an existing scores table or try to create a new one with the given game id.
		* Must be called with a valid game id before any scores transactions can take place.
		* @param gameId A valid game id
		*/
		function openScoresTable(gameId:String):void;
		
		/**
		* Retrieve the currently active game id.
		*/
		function get gameId():String;
		
		/**
		* Terminate access to  scores and clean up. 
		* Calls store() to push latest scores to storage before closing.
		*/
		function closeScoresTable():void;
		
		/**
		* Total number of slots to allocate for score storage (maximium of 100)
		* @param value An integer from 1 to 100 indicating the number of scores to be stored
		*/
		function set totalScores(value:int):void;
		function get totalScores():int;
		
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
		function isEligible(score:Number):Boolean;
		
		/**
		* Retrieve a score by zero-based rank index.
		* 
		* <em>Note:</em> Scores are stored in descending order (largest first).
		* @param i Index of score to retrieve. [0, MAX_SCORES)
		* @return The score matching the rank index; null if rank is invalid or no scores exist.
		*/
		function getScore(i:int):Number;

		/**
		* Retrieve a set of initials by zero-based rank index.
		* 
		* <em>Note:</em> Initials are stored in descending order,
		* based on the score they are associated with (highest first).
		* @param i Index of initials to retrieve. [0, MAX_SCORES)
		* @return The initials string matching the rank index; null if rank is invalid or no scores exist.
		*/
		function getInitials(i:int):String;

		/**
		* Add a score and associated initials string into the score list,
		* possibly bumping off the lowest score.
		* 
		* The new score and initials string will be added in rank order.
		* 
		* If adding the new score and initals string creates more than
		* MAX_SCORES entries, then the lowest rank score will be bumped off the list.
		* @param s The score to add
		* @param i The string of initials to add
		* @return true if score was added, false if 
		*/
		function insert(s:Number, i:String):Boolean;

		/**
		* Test the insertion of multiple scores in one call.
		* 
		* @param N An array of scores to test
		* @return An array of Booleans, indicating whether the score at 
		* the same index would be inserted or not.
		*/
		function testInsert(N:Array):Array;

		/**
		* Clear the  score list, erasing all scores and initials.
		*/
		function reset():void;

		/**
		* Write the scores and initials to the storage medium.
		*/
		function store():void;

		/**
		* Generate a human-readable version of the score list.
		* @return A human-readable version of the contents of the score list.
		*/
		function toString():String;

		/**
		* Retrieve the total number of entries currently in the score list.
		*/
		function get length():uint;
		
	}
}