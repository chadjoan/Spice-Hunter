
package com.pixeldroid.r_c4d3.interfaces
{

	import com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy;
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;


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
	<code>setScoresProxy()</code> methods to provide system-specific
	implementations of IGameControlsProxy, and IGameScoresProxy to
	the IGameRom. The IGameRom doesn't need to worry about how they work,
	since it can rely on the interfaces to call the same methods every time.
	</p>
	
	<p>Note: <i>
	Due to the way HaXe inserts top-level classes when compiling a SWF,
	HaXe users must use the HaxeSideDoor class to declare IGameRom compliance.
	</i></p>
	
	@see IGameControlsProxy
	@see IGameScoresProxy
	@see com.pixeldroid.r_c4d3.interfaces.HaxeSideDoor
	*/
	public interface IGameRom
	{
		/**
		Provide a reference to the preloaded config data for the GameRom to 
		use for initialization.
		@param value A ConfigDataProxy instance
		*/
		//TODO: function setConfigData(value:ConfigDataProxy):void;
		
		/**
		Provide a reference to the controls proxy for the GameRom to 
		use for reading user input.
		@param value An implementation of IGameControlsProxy
		*/
		function setControlsProxy(value:IGameControlsProxy):void;
		
		/**
		Provide a reference to the high scores proxy for the GameRom to 
		use for retrieving and submitting scores.
		@param value An implementation of IGameScoresProxy
		*/
		function setScoresProxy(value:IGameScoresProxy):void;
		
		/**
		Ask the GameRom to display the title screen and begin the attract loop sequence.
		This will be called after the GameRom has completed loading and after the controls proxy and scores proxy have been set.
		*/
		function enterAttractLoop():void;
	}
}