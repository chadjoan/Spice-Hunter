
package com.pixeldroid.r_c4d3.controls
{
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	A JOY_BALL_MOTION event occurs when a user moves a trackball on the joystick. 
	The field 'which' is the index of the joystick that reported the event and 'ball' is 
	the index of the trackball. Trackballs only return relative motion--the change in 
	position on the ball since it was last polled (last cycle of the event loop) and it is 
	stored in xrel and yrel.
	*/
	public class JoyBallEvent extends Event
	{

		/**
		Type of event triggered by pressing a button down
		*/
		public static const JOY_BALL_MOTION:String = "JOY_BALL_MOTION";


		
		/**
		Joystick device index
		*/
		public var which:int;
		
		/**
		Joystick ball index
		*/
		public var ball:int;
		
		/**
		The relative motion in the X/Y direction (dx, dy)
		*/
		public var displacement:Point;
		
		/**
		The relative motion in the X direction
		*/
		public function get xrel():Number { return displacement.x };
		
		/**
		The relative motion in the Y direction
		*/
		public function get yrel():Number { return displacement.y };
		
		
		
		public function JoyBallEvent(whichJoystick:int, whichBall:int, xrel:Number, yrel:Number, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(JOY_BALL_MOTION, bubbles, cancelable);
			
			which = whichJoystick;
			ball = whichBall;
			displacement = new Point(xrel, yrel);
		}
		
		override public function clone():Event
		{
			return new JoyBallEvent(which, ball, displacement.x, displacement.y, bubbles, cancelable);
		}
	}
}
