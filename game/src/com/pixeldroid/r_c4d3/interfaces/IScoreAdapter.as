
package com.pixeldroid.r_c4d3.interfaces
{

	import com.pixeldroid.r_c4d3.data.CommonScoreData;
	
	public interface IScoreAdapter
	{
		
		/**
		* Retrieve the game's high scores in a standard format.
		*/
		function get commonScoreData():CommonScoreData;
		
	}
}