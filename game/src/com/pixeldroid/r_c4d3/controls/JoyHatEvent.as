
package com.pixeldroid.r_c4d3.controls
{
	import flash.events.Event;
	
	/**
	A JOY_HAT_MOTION event occurs when ever a user moves a 4-way hat on the joystick.
	<p>
	The field 'which' is the index of the joystick that reported the event and 'hat' is 
	the index of the hat. 'value' is the current position of the hat encoded as a bitfield.
	</p>
	*/
	public class JoyHatEvent extends Event
	{

		/**
		Type of event triggered by pressing a button down
		@eventtype JOY_HAT_MOTION
		*/
		public static const JOY_HAT_MOTION:String = "JOY_HAT_MOTION";

		/**
		Hat value when centered (resting position)
		@default 0x00
		*/
		public static const HAT_CENTERED:int = 0x00;

		/**
		Hat value mask for the up position
		@default 0x01 - binary 0001
		*/
		public static const HAT_UP:int = 0x01;

		/**
		Hat value mask for the right position
		@default 0x02 - binary 0010
		*/
		public static const HAT_RIGHT:int = 0x02;

		/**
		Hat value mask for the down position
		@default 0x04 - binary 0100
		*/
		public static const HAT_DOWN:int = 0x04;

		/**
		Hat value mask for the left position
		@default 0x08 - binary 1000
		*/
		public static const HAT_LEFT:int = 0x08;
		
		/**
		Hat value mask for the right-up diagonal position
		@default 0x03 - binary 0011
		*/
		public static const HAT_RIGHTUP:int = (HAT_RIGHT | HAT_UP);
		
		/**
		Hat value mask for the right-down diagonal position
		@default 0x06 - binary 0110
		*/
		public static const HAT_RIGHTDOWN:int = (HAT_RIGHT | HAT_DOWN);
		
		/**
		Hat value mask for the left-up diagonal position
		@default 0x09 - binary 1001
		*/
		public static const HAT_LEFTUP:int = (HAT_LEFT | HAT_UP);
		
		/**
		Hat value mask for the left-down diagonal position
		@default 0x0c - binary 1100
		*/
		public static const HAT_LEFTDOWN:int = (HAT_LEFT | HAT_DOWN);


		
		/**
		Joystick device index
		@default null
		*/
		public var which:int;
		
		/**
		Joystick hat index
		@default null
		*/
		public var hat:int;
		
		/**
		Hat value as bitfield
		@default null
		*/
		public var value:int;
		
		
		
		/**
		Creates an event object which contains information about digital (4- or 8-way) stick motion.
		Event objects are passed as parameters to event listeners.
		*/
		public function JoyHatEvent(whichJoystick:int, whichHat:int, motionValue:int, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(JOY_HAT_MOTION, bubbles, cancelable);
			
			which = whichJoystick;
			hat = whichHat;
			value = motionValue;
		}
		
		/** @inheritdoc */
		override public function clone():Event
		{
			return new JoyHatEvent(which, hat, value, bubbles, cancelable);
		}
		
		/** @inheritdoc */
		override public function toString():String
		{
			var s:String = "(JoyHatEvent)";
			s += "  joystick: " +which;
			s += "       hat: " +hat;
			s += "     value: " +bit4ToString(value);
			return s;
		}
		
		/**
		Pretty print a 4-bit int.
		
		@example The following code prints the bitfield value of a JoyHatEvent:
		<listing version="3.0">
		function onHatEvent(e:JoyHatEvent):void {
		    trace(e.bit4ToString(e.value));
		}
		</listing>
		*/
		public function bit4ToString(n:int):String
		{
			var s:String = n.toString(2);
			while (s.length < 4) s = "0" + s;
			return s;
		}

		
		/**	<code>true</code> when joyhat is not pressed in any direction. */
		public function get isCentered():Boolean { return (value == HAT_CENTERED); }
		
		/**	<code>true</code> when joyhat is pressed any type of up (leftUp, up, or rightUp). */
		public function get isUp():Boolean { return Boolean(value & HAT_UP); }
		
		/**	<code>true</code> when joyhat is pressed strictly up. */
		public function get isStrictlyUp():Boolean { return Boolean(value == HAT_UP); }
		
		/**	<code>true</code> when joyhat is pressed any type of right (rightup, right, rightdown). */
		public function get isRight():Boolean { return Boolean(value & HAT_RIGHT); }
		
		/**	<code>true</code> when joyhat is pressed strictly right. */
		public function get isStrictlyRight():Boolean { return Boolean(value == HAT_RIGHT); }
		
		/**	<code>true</code> when joyhat is pressed any type of down (leftDown, down, or rightDown). */
		public function get isDown():Boolean { return Boolean(value & HAT_DOWN); }
		
		/**	<code>true</code> when joyhat is pressed strictly down. */
		public function get isStrictlyDown():Boolean { return Boolean(value == HAT_DOWN); }
		
		/**	<code>true</code> when joyhat is pressed any type of left (leftup, left, leftdown). */
		public function get isLeft():Boolean { return Boolean(value & HAT_LEFT); }
		
		/**	<code>true</code> when joyhat is pressed strictly left. */
		public function get isStrictlyLeft():Boolean { return Boolean(value == HAT_LEFT); }
		
		/**	<code>true</code> when joyhat is pressed diagonally right and up. */
		public function get isRightUp():Boolean { return Boolean(value == HAT_RIGHTUP); }
		
		/**	<code>true</code> when joyhat is pressed diagonally right and down. */
		public function get isRightDown():Boolean { return Boolean(value == HAT_RIGHTDOWN); }
		
		/**	<code>true</code> when joyhat is pressed diagonally left and up. */
		public function get isLeftUp():Boolean { return Boolean(value == HAT_LEFTUP); }
		
		/**	<code>true</code> when joyhat is pressed diagonally left and down. */
		public function get isLeftDown():Boolean { return Boolean(value == HAT_LEFTDOWN); }

	}
}
