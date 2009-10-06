
package com.pixeldroid.r_c4d3.interfaces
{
	
	/**
	Marker interface for joysticks.
	*/
	public interface IJoystick
	{
	
		/**
		* Retrieve the zero-based system index for this joystick.
		*/
		function get index():int
	
		/**
		* Retrieve the system-specific name for this joystick.
		*/
		function get systemName():String;
		
		/**
		* Retrieve a bitfield representing the current state of the hat at the given index
		*/
		function getHat(index:int):int;
		
		/**
		* Set a bitfield representing the current state of the hat at the given index
		*/
		function setHat(index:int, bitField:int):void
		
		/**
		* Retrieve a Boolean representing the current state of the button at the given index
		*/
		function getButton(index:int):Boolean;
		
		/**
		* Set a Boolean representing the current state of the button at the given index
		*/
		function setButton(index:int, pressed:Boolean):void
		
		/**
		* Retrieve a motion value for the given axis.
		*/
		function getAxis(index:int):int;
		
		/**
		* Set a motion value for the given axis.
		*/
		function setAxis(index:int, value:int):void
	}
}