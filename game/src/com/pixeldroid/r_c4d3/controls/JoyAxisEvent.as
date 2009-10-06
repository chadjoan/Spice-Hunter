
package com.pixeldroid.r_c4d3.controls
{
	import flash.events.Event;
	
	/**
	A JOY_AXIS_MOTION event occurs whenever a user moves a joystick along one of its axes.
	The field 'which' is the index of the joystick that reported the event and 'axis' is 
	the index of the axis. 'value' is the current position of the axis.
	*/
	public class JoyAxisEvent extends Event
	{
		/**
		Type of event triggered by joystick motion
		@eventtype JOY_AXIS_MOTION
		*/
		public static const JOY_AXIS_MOTION:String = "JOY_AXIS_MOTION";


	
		/**
		Joystick X axis
		@default 0
		*/
		public static const AXIS_X:int = 0;
		
		/**
		Joystick Y axis
		@default 1
		*/
		public static const AXIS_Y:int = 1;
		
		/**
		Minimum axis value; indicates joystick is fully pressed along the negative axis direction.
		@default -32768
		*/
		public static const AXIS_VALUE_MIN:int = -32768;
		
		/**
		Maximum axis value; indicates joystick is fully pressed along the positive axis direction.
		@default 32767
		*/
		public static const AXIS_VALUE_MAX:int =  32767;
		
		/**
		Middle axis value; indicates joystick is released.
		@default 0
		*/
		public static const AXIS_VALUE_CENTER:int = 0;


	
		/**
		Joystick device index
		@default null
		*/
		public var which:int;
		
		/**
		Joystick axis index (use AXIS_X and AXIS_Y to compare)
		@default null
		*/
		public var axis:int;
		
		/**
		Axis value (range: AXIS_VALUE_MIN to AXIS_VALUE_MAX)
		@default null
		*/
		public var value:int;
		
		
		
		/**
		Creates an event object which contains information about analog stick motion.
		Event objects are passed as parameters to event listeners.
		*/
		public function JoyAxisEvent(whichJoystick:int, axisIndex:int, motionValue:int, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(JOY_AXIS_MOTION, bubbles, cancelable);
			
			which = whichJoystick;
			axis = axisIndex;
			value = motionValue;
		}
		
		/**
		@inheritdoc
		*/
		override public function clone():Event
		{
			return new JoyAxisEvent(which, axis, value, bubbles, cancelable);
		}
	}
}
