
package com.pixeldroid.r_c4d3.controls
{
	import flash.events.Event;
	
	/**
	A JOY_BUTTON_DOWN or JOY_BUTTON_UP event occurs whenever a user presses or releases a 
	joystick button. The field 'which' is the index of the joystick that reported the 
	event and 'button' is the index of the button. 'pressed' is the current state of the 
	button which is true when PRESSED, false when RELEASED.
	*/
	public class JoyButtonEvent extends Event
	{

		/**
		Type of event triggered by any change in button state (pressed or released)
		*/
		public static const JOY_BUTTON_MOTION:String = "JOY_BUTTON_MOTION";

		/**
		Type of event triggered by pressing a button down
		*/
		public static const JOY_BUTTON_DOWN:String = "JOY_BUTTON_DOWN";

		/**
		Type of event triggered by releasing a button
		*/
		public static const JOY_BUTTON_UP:String = "JOY_BUTTON_UP";

		/** 
		Constant representing the yellow button (button X) 
		@default 0
		*/
		public static const BTN_X:int = 0;
		
		/** 
		Constant representing the red button (button A) 
		@default 1
		*/
		public static const BTN_A:int = 1;
		
		/** 
		Constant representing the blue button (button B) 
		@default 2
		*/
		public static const BTN_B:int = 2;
		
		/** 
		Constant representing the green button (button C) 
		@default 3
		*/
		public static const BTN_C:int = 3;

		/**
		Button state value when pressed
		@default true
		*/
		public static const PRESSED:Boolean = true;

		/**
		Button state value when released
		@default false
		*/
		public static const RELEASED:Boolean = false;


		
		/**
		Joystick device index
		@see IGameControlsProxy#numJoysticks
		*/
		public var which:int;
		
		/**
		Joystick button index (BTN_X, BTN_A, BTN_B, BTN_C)
		*/
		public var button:int;
		
		/**
		Button state (PRESSED, or RELEASED)
		*/
		public var pressed:Boolean;
		
		
		
		public function JoyButtonEvent(type:String, whichJoystick:int, whichButton:int, isPressed:Boolean, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			which = whichJoystick;
			button = whichButton;
			pressed = isPressed;
		}
		
		override public function clone():Event
		{
			return new JoyButtonEvent(type, which, button, pressed, bubbles, cancelable);
		}
		
		override public function toString():String
		{
			var s:String = "(JoyButtonEvent)";
			s += "  joystick: " +which;
			s += "    button: " +button;
			s += "   pressed: " +pressed;
			return s;
		}
	}
}
