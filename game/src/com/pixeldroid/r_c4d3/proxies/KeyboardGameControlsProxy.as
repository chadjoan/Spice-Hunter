
package com.pixeldroid.r_c4d3.proxies
{

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.controls.JoyEventStateEnum;
	import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
	import com.pixeldroid.r_c4d3.controls.KeyboardJoystick;
	import com.pixeldroid.r_c4d3.controls.KeyLabels;
	import com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy;
	import com.pixeldroid.r_c4d3.interfaces.IJoystick;
	
	
	/**
	An implementation of IGameControlsProxy for keyboards.
	<p>
	Maps keyboard events to JoyHat and JoyButton events.
	</p>
	<p>
	Keys can be customized via <code>setKeys()</code> and queried via 
	<code>joystickGetHatKey()</code> and <code>joystickGetButtonKey()</code>
	</p>
	*/
	public class KeyboardGameControlsProxy extends EventDispatcher implements IGameControlsProxy
	{
		/** Constant representing the yellow button (button X) */
		public static const BTN_X:int = 0;
		
		/** Constant representing the red button (button A) */
		public static const BTN_A:int = 1;
		
		/** Constant representing the blue button (button B) */
		public static const BTN_B:int = 2;
		
		/** Constant representing the green button (button C) */
		public static const BTN_C:int = 3;
		
		
		/** Constant representing hat up */
		public static const HAT_U:int = 0;
		
		/** Constant representing hat right */
		public static const HAT_R:int = 1;
		
		/** Constant representing hat down */
		public static const HAT_D:int = 2;
		
		/** Constant representing hat left */
		public static const HAT_L:int = 3;

		
		protected var joysticks:Array;
		protected var joysticksDefined:Array;
		protected var gameStage:Stage;
		protected var _joystickEventState:String;
		
		protected var P1_R:uint = 49; //1  // TODO: set defaults to 9-square clusters (e.g. DWASQZXC)
		protected var P1_U:uint = 50; //2
		protected var P1_L:uint = 51; //3
		protected var P1_D:uint = 52; //4
		protected var P1_X:uint = 53; //5
		protected var P1_A:uint = 54; //6
		protected var P1_B:uint = 55; //7
		protected var P1_C:uint = 56; //8
		
		protected var P2_R:uint = 81; //q
		protected var P2_U:uint = 87; //w
		protected var P2_L:uint = 69; //e
		protected var P2_D:uint = 82; //r
		protected var P2_X:uint = 84; //t
		protected var P2_A:uint = 89; //y
		protected var P2_B:uint = 85; //u
		protected var P2_C:uint = 73; //i
		
		protected var P3_R:uint = 65; //a
		protected var P3_U:uint = 83; //s
		protected var P3_L:uint = 68; //d
		protected var P3_D:uint = 70; //f
		protected var P3_X:uint = 71; //g
		protected var P3_A:uint = 72; //h
		protected var P3_B:uint = 74; //j
		protected var P3_C:uint = 75; //k
		
		protected var P4_R:uint = 90; //z
		protected var P4_U:uint = 88; //x
		protected var P4_L:uint = 67; //c
		protected var P4_D:uint = 86; //v
		protected var P4_X:uint = 66; //b
		protected var P4_A:uint = 78; //n
		protected var P4_B:uint = 77; //m
		protected var P4_C:uint = 188;//,
		
		
		// Define an event queue that is populated with events as onKeyUp
		//   and onKeyDown are called.  When onEnterFrame is called, these
		//   will be acted upon and the queue cleared.
		// This is well-ordered FIFO.
		private var eventQueue : Array /* of KeyboardEvent */;
		
		// The capacity of the queue may be larger than it's actual size.
		// This gives it's actual size, not its capacity.
		private var nEvents : int; 
		
		// A list of keycodes that have been associated with a key release event
		//   during the latest frame.  
		private var keysReleased : Array /* of int (key codes) */;
		
		// As with the event queue, keysReleased may stay over-allocated.
		// This gives it's actual size, not its capacity.
		private var nKeysReleased : int;
		
		
		/**
		Constructor
		*/
		public function KeyboardGameControlsProxy()
		{
			super();
			
			keysReleased = new Array();
			keysReleased[0] = 0; // preallocate one element.
			nKeysReleased = 0;
			
			eventQueue = new Array();
			eventQueue[3] = null; // preallocate a bit.
			nEvents = 0;
			
			_joystickEventState = JoyEventStateEnum.IGNORE;
			joysticks = [null, null, null, null];
			joysticksDefined = [false, false, false];
		}
		
		/** @inheritdoc */
		public function joystickClose(joystick:IJoystick):void
		{
			joysticks[joystick.index] = null;
		}
		
		/** @inheritdoc */
		public function joystickEventState(state:String, gameStage:Stage):String
		{
			//C.out(this, "joystickEventState: " +state);
			//C.out(this, "joystickEventState, state == JoyEventStateEnum.ENABLE ? " +(state == JoyEventStateEnum.ENABLE));
			switch (state)
			{
				case JoyEventStateEnum.QUERY :
					// skip out to return the current state
				break;
				
				case JoyEventStateEnum.ENABLE :
					_joystickEventState = JoyEventStateEnum.ENABLE;
					gameStage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
					gameStage.addEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
					gameStage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				break;
				
				case JoyEventStateEnum.IGNORE :
					_joystickEventState = JoyEventStateEnum.IGNORE;
					gameStage.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
					gameStage.removeEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
					gameStage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				break;
			}
			
			return _joystickEventState;
		}
		
		/** @inheritdoc */
		public function joystickGetAxis(joystick:IJoystick, axis:int):int
		{
			return joystick.getAxis(axis);
		}
		
		/** @inheritdoc */
		public function joystickGetBall(joystick:IJoystick, ball:int, displacement:Point):Boolean
		{
			// no trackball support from keyboard
			return false;
		}
		
		/** @inheritdoc */
		public function joystickGetButton(joystick:IJoystick, button:int):Boolean
		{
			return joystick.getButton(button);
		}
		/** 
		Retrieves the key code currently assigned to trigger the given button.
		@param	joystick A reference to the IJoystick to get the keycode value from.
		@param button A KeyboardGameControlsProxy constant (<code>BTN_*</code>) 
		representing the button to get the keycode value for.
		*/
		public function joystickGetButtonKey(joystick:IJoystick, button:int):uint
		{
			var kc:uint;
			switch (joystick.index)
			{
				case 0:
					switch (button)
					{
						case BTN_X: kc = P1_X; break;
						case BTN_A: kc = P1_A; break;
						case BTN_B: kc = P1_B; break;
						case BTN_C: kc = P1_C; break;
					}
				break;
				
				case 1:
					switch (button)
					{
						case BTN_X: kc = P2_X; break;
						case BTN_A: kc = P2_A; break;
						case BTN_B: kc = P2_B; break;
						case BTN_C: kc = P2_C; break;
					}
				break;
				
				case 2:
					switch (button)
					{
						case BTN_X: kc = P3_X; break;
						case BTN_A: kc = P3_A; break;
						case BTN_B: kc = P3_B; break;
						case BTN_C: kc = P3_C; break;
					}
				break;
				
				case 3:
					switch (button)
					{
						case BTN_X: kc = P4_X; break;
						case BTN_A: kc = P4_A; break;
						case BTN_B: kc = P4_B; break;
						case BTN_C: kc = P4_C; break;
					}
				break;
			}
			return kc;
		}
		
		/** @inheritdoc */
		public function joystickGetHat(joystick:IJoystick, hat:int):int
		{
			return joystick.getHat(hat);
		}
		/** 
		Retrieves the key code currently assigned to trigger the given hat direction.
		@param	joystick A reference to the IJoystick to get the keycode value from.
		@param button A KeyboardGameControlsProxy constant (<code>HAT_*</code>) 
		representing the hat direction to get the keycode value for.
		*/
		public function joystickGetHatKey(joystick:IJoystick, direction:int):uint
		{
			var kc:uint;
			switch (joystick.index)
			{
				case 0:
					switch (direction)
					{
						case HAT_U: kc = P1_U;	break;
						case HAT_R: kc = P1_R;	break;
						case HAT_D: kc = P1_D;	break;
						case HAT_L: kc = P1_L;	break;
					}
				break;
				
				case 1:
					switch (direction)
					{
						case HAT_U: kc = P2_U;	break;
						case HAT_R: kc = P2_R;	break;
						case HAT_D: kc = P2_D;	break;
						case HAT_L: kc = P2_L;	break;
					}        
				break;
				
				case 2:
					switch (direction)
					{
						case HAT_U: kc = P3_U;	break;
						case HAT_R: kc = P3_R;	break;
						case HAT_D: kc = P3_D;	break;
						case HAT_L: kc = P3_L;	break;
					}        
				break;
				
				case 3:
					switch (direction)
					{
						case HAT_U: kc = P4_U;	break;
						case HAT_R: kc = P4_R;	break;
						case HAT_D: kc = P4_D;	break;
						case HAT_L: kc = P4_L;	break;
					}        
				break;
			}
			return kc;
		}
		
		/** @inheritdoc */
		public function joystickIndex(joystick:IJoystick):int
		{
			return joystick.index;
		}
		
		/** @inheritdoc */
		public function joystickName(joystick:IJoystick):String
		{
			return joystick.systemName;
		}
		
		/** @inheritdoc */
		public function joystickNumAxes(joystick:IJoystick):int
		{
			// no analog joystick support from keyboard; use hat instead
			return 0;
		}
		
		/** @inheritdoc */
		public function joystickNumBalls(joystick:IJoystick):int
		{
			// no trackball support from keyboard
			return 0;
		}
		
		/** @inheritdoc */
		public function joystickNumButtons(joystick:IJoystick):int
		{
			// X (yellow), A (red), B (green), C (blue)
			return 4;
		}
		
		/** @inheritdoc */
		public function joystickNumHats(joystick:IJoystick):int
		{
			// keyboard will always only support one hat per joystick
			return 1;
		}
		
		/** @inheritdoc */
		public function joystickOpen(index:int):IJoystick
		{
			checkJoystickIndex(index);
			var j:IJoystick;
			
			switch (index)
			{
				case 0 :
				case 1 :
				case 2 :
				case 3 :
					if (joystickOpened(index)) j = joysticks[index];
					else j = joysticks[index] = new KeyboardJoystick(index);
				break;
			}
			
			return j;
		}
		
		/** @inheritdoc */
		public function joystickOpened(index:int):Boolean
		{
			checkJoystickIndex(index);
			return joysticks[index] != null;
		}
		
		/** @inheritdoc */
		public function numJoysticks():int { return 4; }
		
		
		/**
		Determines whether keys have been defined for a specific joystick.
		@param index A zero-based index selecting the joystick to check
		*/
		public function joystickKeysDefined(index:int):Boolean
		{
			checkJoystickIndex(index);
			return joysticksDefined[index];
		}

		
		/**
		Provide custom key code assignment for a specific hat direction.
		@param playerIndex zero based index indicating which player joystick to set codes for.
		@param hat A KeyboardGameControlsProxy constant (<code>HAT_*</code>) 
		representing the hat direction to get the keycode value for.
		@param keyCode Keycode for hat direction
		*/
		public function setHatKey(playerIndex:uint, hat:int, keyCode:uint):void
		{
			switch (hat)
			{
				case HAT_U : setKeys(playerIndex, keyCode,0,0,0, 0,0,0,0); break;
				case HAT_R : setKeys(playerIndex, 0,keyCode,0,0, 0,0,0,0); break;
				case HAT_D : setKeys(playerIndex, 0,0,keyCode,0, 0,0,0,0); break;
				case HAT_L : setKeys(playerIndex, 0,0,0,keyCode, 0,0,0,0); break;
			}
		}
		
		/**
		Provide custom key code assignment for a specific button.
		@param playerIndex zero based index indicating which player joystick to set codes for.
		@param button A KeyboardGameControlsProxy constant (<code>BTN_*</code>) 
		representing the button to get the keycode value for.
		@param keyCode Keycode for button
		*/
		public function setButtonKey(playerIndex:uint, button:int, keyCode:uint):void
		{
			switch (button)
			{
				case BTN_X : setKeys(playerIndex, 0,0,0,0, keyCode,0,0,0); break;
				case BTN_A : setKeys(playerIndex, 0,0,0,0, 0,keyCode,0,0); break;
				case BTN_B : setKeys(playerIndex, 0,0,0,0, 0,0,keyCode,0); break;
				case BTN_C : setKeys(playerIndex, 0,0,0,0, 0,0,0,keyCode); break;
			}
		}

		/**
		Provide custom key code assignments for hat directions and buttons.
		@param playerIndex zero based index indicating which player joystick to set codes for.
		@param u Keycode for hat up
		@param r Keycode for hat right
		@param d Keycode for hat down
		@param l Keycode for hat left
		@param x Keycode for button X (yellow)
		@param a Keycode for button A (red)
		@param b Keycode for button B (blue)
		@param c Keycode for button C (green)
		*/
		public function setKeys(playerIndex:uint, u:uint, r:uint, d:uint, l:uint, x:uint, a:uint, b:uint, c:uint):void
		{
			//C.out(this, "setKeys for p" +playerIndex +": " +[u,r,d,l,x,a,b,c]);
			
			checkJoystickIndex(playerIndex);
			
			switch (playerIndex)
			{
				case 0 :
					P1_U = u || P1_U;
					P1_R = r || P1_R;
					P1_D = d || P1_D;
					P1_L = l || P1_L;
					P1_X = x || P1_X;
					P1_A = a || P1_A;
					P1_B = b || P1_B;
					P1_C = c || P1_C;
				break;        
				
				case 1 :
					P2_U = u || P2_U;
					P2_R = r || P2_R;
					P2_D = d || P2_D;
					P2_L = l || P2_L;
					P2_X = x || P2_X;
					P2_A = a || P2_A;
					P2_B = b || P2_B;
					P2_C = c || P2_C;
				break;              
				
				case 2 :
					P3_U = u || P3_U;
					P3_R = r || P3_R;
					P3_D = d || P3_D;
					P3_L = l || P3_L;
					P3_X = x || P3_X;
					P3_A = a || P3_A;
					P3_B = b || P3_B;
					P3_C = c || P3_C;
				break;              
				
				case 3 :
					P4_U = u || P4_U;
					P4_R = r || P4_R;
					P4_D = d || P4_D;
					P4_L = l || P4_L;
					P4_X = x || P4_X;
					P4_A = a || P4_A;
					P4_B = b || P4_B;
					P4_C = c || P4_C;
				break;              
			}
			joysticksDefined[playerIndex] = true;
		}
		
		override public function toString():String
		{
			var s:String = "[KeyboardGameControlsProxy]";
			s += "\nPlayer1:";
			s += "\n  Up: " +P1_U +" (" +KeyLabels.getLabel(P1_U) +")";
			s += "\n  Right: " +P1_R +" (" +KeyLabels.getLabel(P1_R) +")";
			s += "\n  Down: " +P1_D +" (" +KeyLabels.getLabel(P1_D) +")";
			s += "\n  Left: " +P1_L +" (" +KeyLabels.getLabel(P1_L) +")";
			s += "\n  Yellow (X): " +P1_X +" (" +KeyLabels.getLabel(P1_X) +")";
			s += "\n  Red (A): " +P1_A +" (" +KeyLabels.getLabel(P1_A) +")";
			s += "\n  Blue (B): " +P1_B +" (" +KeyLabels.getLabel(P1_B) +")";
			s += "\n  Green (C): " +P1_C +" (" +KeyLabels.getLabel(P1_C) +")";
			s += "\nPlayer2:";
			s += "\n  Up: " +P2_U +" (" +KeyLabels.getLabel(P2_U) +")";
			s += "\n  Right: " +P2_R +" (" +KeyLabels.getLabel(P2_R) +")";
			s += "\n  Down: " +P2_D +" (" +KeyLabels.getLabel(P2_D) +")";
			s += "\n  Left: " +P2_L +" (" +KeyLabels.getLabel(P2_L) +")";
			s += "\n  Yellow (X): " +P2_X +" (" +KeyLabels.getLabel(P2_X) +")";
			s += "\n  Red (A): " +P2_A +" (" +KeyLabels.getLabel(P2_A) +")";
			s += "\n  Blue (B): " +P2_B +" (" +KeyLabels.getLabel(P2_B) +")";
			s += "\n  Green (C): " +P2_C +" (" +KeyLabels.getLabel(P2_C) +")";
			s += "\nPlayer3:";
			s += "\n  Up: " +P3_U +" (" +KeyLabels.getLabel(P3_U) +")";
			s += "\n  Right: " +P3_R +" (" +KeyLabels.getLabel(P3_R) +")";
			s += "\n  Down: " +P3_D +" (" +KeyLabels.getLabel(P3_D) +")";
			s += "\n  Left: " +P3_L +" (" +KeyLabels.getLabel(P3_L) +")";
			s += "\n  Yellow (X): " +P3_X +" (" +KeyLabels.getLabel(P3_X) +")";
			s += "\n  Red (A): " +P3_A +" (" +KeyLabels.getLabel(P3_A) +")";
			s += "\n  Blue (B): " +P3_B +" (" +KeyLabels.getLabel(P3_B) +")";
			s += "\n  Green (C): " +P3_C +" (" +KeyLabels.getLabel(P3_C) +")";
			s += "\nPlayer4:";
			s += "\n  Up: " +P4_U +" (" +KeyLabels.getLabel(P4_U) +")";
			s += "\n  Right: " +P4_R +" (" +KeyLabels.getLabel(P4_R) +")";
			s += "\n  Down: " +P4_D +" (" +KeyLabels.getLabel(P4_D) +")";
			s += "\n  Left: " +P4_L +" (" +KeyLabels.getLabel(P4_L) +")";
			s += "\n  Yellow (X): " +P4_X +" (" +KeyLabels.getLabel(P4_X) +")";
			s += "\n  Red (A): " +P4_A +" (" +KeyLabels.getLabel(P4_A) +")";
			s += "\n  Blue (B): " +P4_B +" (" +KeyLabels.getLabel(P4_B) +")";
			s += "\n  Green (C): " +P4_C +" (" +KeyLabels.getLabel(P4_C) +")";
			return s;
		}

		protected function checkJoystickIndex(index:int):void
		{
			if (index < 0 || index >= numJoysticks()) throw new Error("index " +index +" invalid. Must be in range [0," +(numJoysticks()-1) +"]");
		}

		protected function sendHatPress(j:IJoystick, eventMask:int):void
		{
			if (!j) return;
			
			var b:int = j.getHat(0);
			if (!(b & eventMask))
			{
				b |= eventMask;
				j.setHat(0, b);
				dispatchEvent(new JoyHatEvent(j.index, 0, b));
			}
		}
		protected function sendHatRelease(j:IJoystick, eventMask:int):void
		{
			if (!j) return;
			
			var b:int = j.getHat(0);
			b &= ~eventMask;
			j.setHat(0, b);
			dispatchEvent(new JoyHatEvent(j.index, 0, b));
		}

		protected function sendBtnPress(j:IJoystick, i:int):void
		{
			if (!j) return;
			
			var b:Boolean = j.getButton(i);
			if (!b)
			{
				b = true;
				j.setButton(i, b);
				dispatchEvent(new JoyButtonEvent(JoyButtonEvent.JOY_BUTTON_DOWN, j.index, i, b));
				dispatchEvent(new JoyButtonEvent(JoyButtonEvent.JOY_BUTTON_MOTION, j.index, i, b));
			}
		}
		protected function sendBtnRelease(j:IJoystick, i:int):void
		{
			if (!j) return;
			
			var b:Boolean = false;
			j.setButton(i, b);
			dispatchEvent(new JoyButtonEvent(JoyButtonEvent.JOY_BUTTON_UP, j.index, i, b));
			dispatchEvent(new JoyButtonEvent(JoyButtonEvent.JOY_BUTTON_MOTION, j.index, i, b));
		}
		

		// On some versions of linux flash player, there is a bug that causes
		//   press-and-hold to be interpreted as many clicks.
		// https://bugs.adobe.com/jira/browse/FP-2369
		// The pattern is release-press pairs being issued on the same frame;
		//   a sequence unlikely to be performed by any mere mortal.
		// Here we filter out these events that are triggered faster than
		//   humanly possible.
		// Returns true if this event shouldn't be possible.
		private function isBogusKeyEvent(keyCode:uint):Boolean
		{
			var i : int;
			
			for ( i = 0; i < nKeysReleased; i++ )
				if ( keyCode == keysReleased[i] )
					return true;

			return false;
		}
		
		private function _onKeyDown(e:KeyboardEvent):void
		{
			if ( isBogusKeyEvent(e.keyCode) )
			{
				// Filter the release-press pairs typical of flash player's bug.
				var i : int;
				for ( i = 0; i < nEvents; i++ )
				{
					if ( eventQueue[i] != null && 
						eventQueue[i].keyCode == e.keyCode )
					{
						// My tactic here is to simply set bogus events to null,
						//   and just ignore the nulls when in onEnterFrame.
						// This is very intentional.
						// What you don't want to do is remove them.
						// That has two problems:
						// -If you use the fast O(1) method for removal, then
						//   it will change the ordering of the queues elements.
						//   That's bad.
						// -The O(n) method involves sliding the queue 
						//   remainder towards the 0th element by 1.
						//   This violates any indices pointing into the queue.
						//   The current scheme doesn't have such indices, but
						//   if that changes it would be an ugly thing to 
						//   violate.
						eventQueue[i] = null;
					}
				}
			}
			else
			{
				eventQueue[nEvents] = e;
				nEvents++;
			}
		}
		
		private function _onKeyUp(e:KeyboardEvent):void
		{
			eventQueue[nEvents] = e;
			nEvents++;
			
			keysReleased[nKeysReleased] = e.keyCode;
			nKeysReleased++;
		}
		
		private var frameCount : int = 0;
		private function onEnterFrame( e : Event ) : void
		{
			var i : int;
			
			for ( i = 0; i < nEvents; i++ )
			{
				var event : KeyboardEvent = eventQueue[i];
				
				if ( event != null ) // Some events were filtered out.
				{
					if ( event.type == KeyboardEvent.KEY_DOWN )
						onKeyDown(event);
					else
						onKeyUp(event);
				}
			}
			
			// Flush the queues.
			nKeysReleased = 0;
			nEvents = 0;
		}
		
		protected function onKeyDown(e:KeyboardEvent):void
		{
			var kc:uint = e.keyCode;
			//C.out(this, "onKeyDown - " +kc);

			switch(kc)
			{
				case P1_U : sendHatPress(IJoystick(joysticks[0]), JoyHatEvent.HAT_UP);   break;
				case P1_R : sendHatPress(IJoystick(joysticks[0]), JoyHatEvent.HAT_RIGHT);break;
				case P1_D : sendHatPress(IJoystick(joysticks[0]), JoyHatEvent.HAT_DOWN); break;
				case P1_L : sendHatPress(IJoystick(joysticks[0]), JoyHatEvent.HAT_LEFT); break;
				case P1_X : sendBtnPress(IJoystick(joysticks[0]), JoyButtonEvent.BTN_X); break;
				case P1_A : sendBtnPress(IJoystick(joysticks[0]), JoyButtonEvent.BTN_A); break;
				case P1_B : sendBtnPress(IJoystick(joysticks[0]), JoyButtonEvent.BTN_B); break;
				case P1_C : sendBtnPress(IJoystick(joysticks[0]), JoyButtonEvent.BTN_C); break;
				
				case P2_U : sendHatPress(IJoystick(joysticks[1]), JoyHatEvent.HAT_UP);   break;
				case P2_R : sendHatPress(IJoystick(joysticks[1]), JoyHatEvent.HAT_RIGHT);break;
				case P2_D : sendHatPress(IJoystick(joysticks[1]), JoyHatEvent.HAT_DOWN); break;
				case P2_L : sendHatPress(IJoystick(joysticks[1]), JoyHatEvent.HAT_LEFT); break;
				case P2_X : sendBtnPress(IJoystick(joysticks[1]), JoyButtonEvent.BTN_X); break;
				case P2_A : sendBtnPress(IJoystick(joysticks[1]), JoyButtonEvent.BTN_A); break;
				case P2_B : sendBtnPress(IJoystick(joysticks[1]), JoyButtonEvent.BTN_B); break;
				case P2_C : sendBtnPress(IJoystick(joysticks[1]), JoyButtonEvent.BTN_C); break;
				                                             
				case P3_U : sendHatPress(IJoystick(joysticks[2]), JoyHatEvent.HAT_UP);   break;
				case P3_R : sendHatPress(IJoystick(joysticks[2]), JoyHatEvent.HAT_RIGHT);break;
				case P3_D : sendHatPress(IJoystick(joysticks[2]), JoyHatEvent.HAT_DOWN); break;
				case P3_L : sendHatPress(IJoystick(joysticks[2]), JoyHatEvent.HAT_LEFT); break;
				case P3_X : sendBtnPress(IJoystick(joysticks[2]), JoyButtonEvent.BTN_X); break;
				case P3_A : sendBtnPress(IJoystick(joysticks[2]), JoyButtonEvent.BTN_A); break;
				case P3_B : sendBtnPress(IJoystick(joysticks[2]), JoyButtonEvent.BTN_B); break;
				case P3_C : sendBtnPress(IJoystick(joysticks[2]), JoyButtonEvent.BTN_C); break;
				                                             
				case P4_U : sendHatPress(IJoystick(joysticks[3]), JoyHatEvent.HAT_UP);   break;
				case P4_R : sendHatPress(IJoystick(joysticks[3]), JoyHatEvent.HAT_RIGHT);break;
				case P4_D : sendHatPress(IJoystick(joysticks[3]), JoyHatEvent.HAT_DOWN); break;
				case P4_L : sendHatPress(IJoystick(joysticks[3]), JoyHatEvent.HAT_LEFT); break;
				case P4_X : sendBtnPress(IJoystick(joysticks[3]), JoyButtonEvent.BTN_X); break;
				case P4_A : sendBtnPress(IJoystick(joysticks[3]), JoyButtonEvent.BTN_A); break;
				case P4_B : sendBtnPress(IJoystick(joysticks[3]), JoyButtonEvent.BTN_B); break;
				case P4_C : sendBtnPress(IJoystick(joysticks[3]), JoyButtonEvent.BTN_C); break;
			}                                                
		}
		
		protected function onKeyUp(e:KeyboardEvent):void
		{
			var kc:uint = e.keyCode;
			//C.out(this, "onKeyUp - " +kc);
			
			switch(kc)
			{
				case P1_U : sendHatRelease(IJoystick(joysticks[0]), JoyHatEvent.HAT_UP);   break;
				case P1_R : sendHatRelease(IJoystick(joysticks[0]), JoyHatEvent.HAT_RIGHT);break;
				case P1_D : sendHatRelease(IJoystick(joysticks[0]), JoyHatEvent.HAT_DOWN); break;
				case P1_L : sendHatRelease(IJoystick(joysticks[0]), JoyHatEvent.HAT_LEFT); break;
				case P1_X : sendBtnRelease(IJoystick(joysticks[0]), JoyButtonEvent.BTN_X); break;
				case P1_A : sendBtnRelease(IJoystick(joysticks[0]), JoyButtonEvent.BTN_A); break;
				case P1_B : sendBtnRelease(IJoystick(joysticks[0]), JoyButtonEvent.BTN_B); break;
				case P1_C : sendBtnRelease(IJoystick(joysticks[0]), JoyButtonEvent.BTN_C); break;
				                                               
				case P2_U : sendHatRelease(IJoystick(joysticks[1]), JoyHatEvent.HAT_UP);   break;
				case P2_R : sendHatRelease(IJoystick(joysticks[1]), JoyHatEvent.HAT_RIGHT);break;
				case P2_D : sendHatRelease(IJoystick(joysticks[1]), JoyHatEvent.HAT_DOWN); break;
				case P2_L : sendHatRelease(IJoystick(joysticks[1]), JoyHatEvent.HAT_LEFT); break;
				case P2_X : sendBtnRelease(IJoystick(joysticks[1]), JoyButtonEvent.BTN_X); break;
				case P2_A : sendBtnRelease(IJoystick(joysticks[1]), JoyButtonEvent.BTN_A); break;
				case P2_B : sendBtnRelease(IJoystick(joysticks[1]), JoyButtonEvent.BTN_B); break;
				case P2_C : sendBtnRelease(IJoystick(joysticks[1]), JoyButtonEvent.BTN_C); break;
				                                               
				case P3_U : sendHatRelease(IJoystick(joysticks[2]), JoyHatEvent.HAT_UP);   break;
				case P3_R : sendHatRelease(IJoystick(joysticks[2]), JoyHatEvent.HAT_RIGHT);break;
				case P3_D : sendHatRelease(IJoystick(joysticks[2]), JoyHatEvent.HAT_DOWN); break;
				case P3_L : sendHatRelease(IJoystick(joysticks[2]), JoyHatEvent.HAT_LEFT); break;
				case P3_X : sendBtnRelease(IJoystick(joysticks[2]), JoyButtonEvent.BTN_X); break;
				case P3_A : sendBtnRelease(IJoystick(joysticks[2]), JoyButtonEvent.BTN_A); break;
				case P3_B : sendBtnRelease(IJoystick(joysticks[2]), JoyButtonEvent.BTN_B); break;
				case P3_C : sendBtnRelease(IJoystick(joysticks[2]), JoyButtonEvent.BTN_C); break;
				                                               
				case P4_U : sendHatRelease(IJoystick(joysticks[3]), JoyHatEvent.HAT_UP);   break;
				case P4_R : sendHatRelease(IJoystick(joysticks[3]), JoyHatEvent.HAT_RIGHT);break;
				case P4_D : sendHatRelease(IJoystick(joysticks[3]), JoyHatEvent.HAT_DOWN); break;
				case P4_L : sendHatRelease(IJoystick(joysticks[3]), JoyHatEvent.HAT_LEFT); break;
				case P4_X : sendBtnRelease(IJoystick(joysticks[3]), JoyButtonEvent.BTN_X); break;
				case P4_A : sendBtnRelease(IJoystick(joysticks[3]), JoyButtonEvent.BTN_A); break;
				case P4_B : sendBtnRelease(IJoystick(joysticks[3]), JoyButtonEvent.BTN_B); break;
				case P4_C : sendBtnRelease(IJoystick(joysticks[3]), JoyButtonEvent.BTN_C); break;
			}                                                 
		}

	}
}
