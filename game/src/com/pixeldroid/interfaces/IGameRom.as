
package com.pixeldroid.interfaces
{

	import com.pixeldroid.interfaces.IGameControlsProxy;
	import com.pixeldroid.interfaces.IGameHighScoresProxy;


	/**
	Defines an interface for compatibility with R_C4D3 rom loaders.
	
	<p>
	Implementors of this interface can be loaded as external SWFs by 
	a system-specific rom loader in order to be granted access to controls and 
	scoring functionality for that system.
	</p>
	
	<p>
	For example, the same IGameRom SWF can be loaded by 
	a keyboard rom loader for play on a desktop pc,
	a web rom loader for play in a web browser,
	an R_C4D3 rom loader for play on an R_C4D3 system,
	etc.
	</p>
	
	<p>
	The rom loader will call the <code>setControlsProxy()</code> and
	<code>setHighScoresProxy()</code> methods to provide system-specific
	implementations of IGameControlsProxy, and IGameHighScoresProxy to
	the IGameRom. The IGameRom doesn't need to worry about how they work,
	since it can rely on the interfaces to call the same methods every time.
	</p>
	
	<p>Note: <i>
	Due to the way HaXe inserts top-level classes when compiling a SWF,
	HaXe users must use the HaxeSideDoor to declare IGameRom compliance.
	</i></p>
	
	@see IGameControlsProxy
	@see IGameHighScoresProxy
	@see com.pixeldroid.r_c4d3.romloader.DesktopRomLoaderForKeyboard
	@see com.pixeldroid.r_c4d3.romloader.HaxeSideDoor
	*/
	public interface IGameRom
	{
		/**
		Provide a reference to the controls proxy for the GameRom to 
		use for reading user input.
		@param value An implementation of IGameControlsProxy
		*/
		function setControlsProxy(value:IGameControlsProxy):void;
		
		/**
		Provide a reference to the high scores proxy for the GameRom to 
		use for retrieving and submitting scores.
		@param value An implementation of IGameHighScoresProxy
		*/
		function setHighScoresProxy(value:IGameHighScoresProxy):void;
		
		/**
		Ask the GameRom to display the title screen and begin the attract loop sequence.
		This will be called after the GameRom has completed loading and after the controls proxy and scores proxy have been set.
		*/
		function enterAttractLoop():void;
	}
}