
package com.pixeldroid.r_c4d3.interfaces
{

	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;

	import com.pixeldroid.r_c4d3.controls.JoyEventStateEnum;
	import com.pixeldroid.r_c4d3.interfaces.IJoystick;
	
	
	/** 
	Dispatched when an analog stick motion occurs.
	@eventtype com.pixeldroid.r_c4d3.controls.JoyAxisEvent.JOY_AXIS_MOTION 
	*/
	[Event(name="JOY_AXIS_MOTION", type="com.pixeldroid.r_c4d3.controls.JoyAxisEvent")]
	
	/** 
	Dispatched when a trackball motion occurs.
	@eventtype com.pixeldroid.r_c4d3.controls.JoyBallEvent.JOY_BALL_MOTION 
	*/
	[Event(name="JOY_BALL_MOTION", type="com.pixeldroid.r_c4d3.controls.JoyBallEvent")]
	
	/** 
	Occurs when a button on the joystick is pressed or released
	@eventtype com.pixeldroid.r_c4d3.controls.JoyButtonEvent.JOY_BUTTON_MOTION 
	*/
	[Event(name="JOY_BUTTON_MOTION", type="com.pixeldroid.r_c4d3.controls.JoyButtonEvent")]
	
	/** 
	Occurs when a button on the joystick is pressed
	@eventtype com.pixeldroid.r_c4d3.controls.JoyButtonEvent.JOY_BUTTON_DOWN 
	*/
	[Event(name="JOY_BUTTON_DOWN", type="com.pixeldroid.r_c4d3.controls.JoyButtonEvent")]
	
	/** 
	Occurs when a button on the joystick is released
	@eventtype com.pixeldroid.r_c4d3.controls.JoyButtonEvent.JOY_BUTTON_UP 
	*/
	[Event(name="JOY_BUTTON_UP", type="com.pixeldroid.r_c4d3.controls.JoyButtonEvent")]
	
	/** 
	Dispatched when a digital stick (4- or 8-way) motion occurs.
	@eventtype com.pixeldroid.r_c4d3.controls.JoyHatEvent.JOY_HAT_MOTION
	*/
	[Event(name="JOY_HAT_MOTION", type="com.pixeldroid.r_c4d3.controls.JoyHatEvent")]
	
	
	/**
	Implementaors provides system specific access to Joystick, Trackball, and Button information.
	<p>
	Modeled after SDL Joystick API.
	</p>
	@see IGameRom
	@see IGameScoresProxy
	*/
	public interface IGameControlsProxy extends IEventDispatcher
	{
		
		/**
		Close a joystick previously opened with joystickOpen.
		@param joystick A reference to the IJoystick to close
		*/
		function joystickClose(joystick:IJoystick):void;
		
		/**
		Enable, disable or query current joystick event polling state.
		@param state A JoyEventStateEnum value (QUERY, ENABLE or IGNORE)
		@param stage A reference to the root of the display list
		@return If state is QUERY then the current state is returned, 
		otherwise the new processing state is returned.
		
		<p>Note:<i>
		In addition to setting the JoystickEventState to ENABLE, Event listeners must be added
		in order to receive event notifications.
		</i></p>
		*/
		function joystickEventState(state:String, stage:Stage):String;
		
		/**
		Get the current state of an axis control on a joystick.
		<p>
		The axis indices start at index 0.
		The X axis is index 0. The Y axis is index 1.
		</p>
		@param joystick A reference to the IJoystick to get the axis value from
		@param axis A zero-based index selecting the axis to get (0 for X, 1 for Y)
		@return A value ranging from -32,768 to 32,767.
		*/
		function joystickGetAxis(joystick:IJoystick, axis:int):int;
		
		/**
		Get the ball axis change since the last poll.
		<p>
		Trackballs only return relative motion since the last call to joystickGetBall, 
		these motion deltas are placed into the displacement parameter (modified in place).
		</p>
		<p>
		The ball indices start at index 0.
		</p>
		@param joystick A reference to the IJoystick to get the ball value from
		@param ball A zero-based index selecting the ball to get
		@param A Point instance for storing displacement (dx, dy)
		@return true on success or false on failure
		*/
		function joystickGetBall(joystick:IJoystick, ball:int, displacement:Point):Boolean;
		
		/**
		Get the current state of a button on a joystick.
		<p>
		The button indices start at index 0.
		</p>
		@param joystick A reference to the IJoystick to get the button value from
		@param button A zero-based index selecting the button to get
		@return true if button is pressed, false otherwise
		*/
		function joystickGetButton(joystick:IJoystick, button:int):Boolean;
		
		/**
		Get the current state of a POV hat on a joystick.
		<p>
		The hat indices start at index 0.
		</p>
		@param joystick A reference to the IJoystick to get the hat value from
		@param hat A zero-based index selecting the hat to get
		@return A bitfield value from JoyHatEvent (HAT_CENTERED, HAT_UP, HAT_LEFT, HAT_DOWN, HAT_RIGHT, HAT_RIGHTUP, HAT_RIGHTDOWN, HAT_LEFTUP, HAT_LEFTDOWN)
		*/
		function joystickGetHat(joystick:IJoystick, hat:int):int;
		
		/**
		Returns the index of a given IJoystick.
		@param joystick A reference to the IJoystick to get the index value of
		@return Index number of the joystick.
		*/
		function joystickIndex(joystick:IJoystick):int;
		
		/**
		Get the implementation dependent name of an IJoystick.
		@param joystick A reference to the IJoystick to get the name of
		@return System name of the joystick.
		*/
		function joystickName(joystick:IJoystick):String;
		
		/**
		Return the number of axes available from a previously opened IJoystick.
		@param joystick A reference to the IJoystick to get the number of axes for
		@return Number of axes the joystick supports.
		*/
		function joystickNumAxes(joystick:IJoystick):int;
		
		/**
		Return the number of trackballs available from a previously opened IJoystick.
		@param joystick A reference to the IJoystick to get the number of trackballs for
		@return Number of trackballs the joystick supports.
		*/
		function joystickNumBalls(joystick:IJoystick):int;
		
		/**
		Return the number of buttons available from a previously opened IJoystick.
		@param joystick A reference to the IJoystick to get the number of buttons for
		@return Number of buttons the joystick supports.
		*/
		function joystickNumButtons(joystick:IJoystick):int;
		
		/**
		Return the number of hats available from a previously opened IJoystick.
		@param joystick A reference to the IJoystick to get the number of hats for
		@return Number of hats the joystick supports.
		*/
		function joystickNumHats(joystick:IJoystick):int;
		
		/**
		Opens a joystick for use. A joystick must be opened before it can be used.
		@param index A zero-based index selecting the joystick to check
		@return IJoystick if the joystick has been opened, null if not.
		*/
		function joystickOpen(index:int):IJoystick;
		
		/**
		Determines whether a joystick has already been opened within the application.
		@param index A zero-based index selecting the joystick to check
		@return true if the joystick has been opened, false if not.
		*/
		function joystickOpened(index:int):Boolean;
		
		/**
		Counts the number of joysticks attached to the system.
		@return the number of joysticks available.
		*/
		function numJoysticks():int;
		
		/*
		Updates the state (position, buttons, etc.) of all open joysticks. 
		If joystick events have been enabled with joystickEventState then 
		there is no need to call this function.
		function joystickUpdate():void;
		*/
	}
	
}
