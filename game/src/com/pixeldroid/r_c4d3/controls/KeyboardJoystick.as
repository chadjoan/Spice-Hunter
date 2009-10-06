
package com.pixeldroid.r_c4d3.controls
{

	import com.pixeldroid.r_c4d3.interfaces.IJoystick;
	import com.pixeldroid.r_c4d3.controls.JoyAxisEvent;
	import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
	

	public class KeyboardJoystick implements IJoystick
	{
		private var _index:int;
		private var hat0:int;
		private var button0:Boolean;
		private var button1:Boolean;
		private var button2:Boolean;
		private var button3:Boolean;
		private var axisX:int;
		private var axisY:int;
		
		
		public function KeyboardJoystick(systemIndex:int)
		{
			_index = systemIndex;
			
			hat0 = JoyHatEvent.HAT_CENTERED;
			button0 = false;
			button1 = false;
			button2 = false;
			button3 = false;
			axisX = JoyAxisEvent.AXIS_VALUE_CENTER;
			axisY = JoyAxisEvent.AXIS_VALUE_CENTER;
		}
		
		
		/** @inheritdoc */
		public function get index():int { return _index; }
		
		/** @inheritdoc */
		public function get systemName():String { return "Keyboard simulated joystick for Player" +(_index+1); }
		
		/** @inheritdoc */
		public function getHat(index:int):int
		{
			var bitField:int = JoyHatEvent.HAT_CENTERED;
			
			switch (index)
			{
				case 0: bitField = hat0; break;
			}
			
			return bitField;
		}
		
		/** @inheritdoc */
		public function setHat(index:int, bitField:int):void
		{
			switch (index)
			{
				case 0: hat0 = bitField; break;
			}
		}
		
		/** @inheritdoc */
		public function getButton(index:int):Boolean
		{
			var pressed:Boolean = false;
			
			switch (index)
			{
				case 0: pressed = button0; break;
				case 1: pressed = button1; break;
				case 2: pressed = button2; break;
				case 3: pressed = button3; break;
			}
			
			return pressed;
		}
		
		/** @inheritdoc */
		public function setButton(index:int, pressed:Boolean):void
		{
			switch (index)
			{
				case 0: button0 = pressed; break;
				case 1: button1 = pressed; break;
				case 2: button2 = pressed; break;
				case 3: button3 = pressed; break;
			}
		}
		
		/** @inheritdoc */
		public function getAxis(index:int):int
		{
			var value:int = JoyAxisEvent.AXIS_VALUE_CENTER;
			
			switch (index)
			{
				case JoyAxisEvent.AXIS_X: value = axisX; break;
				case JoyAxisEvent.AXIS_Y: value = axisY; break;
			}
			
			return value;
		}
		
		/** @inheritdoc */
		public function setAxis(index:int, value:int):void
		{
			switch (index)
			{
				case JoyAxisEvent.AXIS_X: axisX = value; break;
				case JoyAxisEvent.AXIS_Y: axisY = value; break;
			}
		}
}
	}