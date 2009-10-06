
package com.pixeldroid.r_c4d3.interfaces
{
	import com.pixeldroid.r_c4d3.interfaces.IGameRom;
	
	
	/**
	Provides a way for HaXe users to declare compliance with the IGameRom interface 
	since they don't have a way to implement IGameRom at the root of their generated SWF.
	*/
	public class HaxeSideDoor {
	
		private var memberVar:int; // prevent the haxe extern gen from optimizing this class into an enum
		
		/**
		Checked by the rom loader when the game rom SWF is detected to be HaXe generated.
		
		<p>
		The HaXe swf should provide a reference to a valid IGameRom implementor here.
		</p>
		
		@default null
		@see IGameRom
		*/
		public static var romInstance:IGameRom;
	}
}
