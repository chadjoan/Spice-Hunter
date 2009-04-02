
package com.pixeldroid.r_c4d3.controls.fourplayer {

	import com.pixeldroid.r_c4d3.controls.ControlEvent;

	/**
	* <code>FourPlayerButtonSet</code> encapsulates key code, event, 
	* and button state information for a single player.
	* 
	* @see com.pixeldroid.r_c4d3.controls.fourplayer.FourPlayerControl
	*/
	public class FourPlayerButtonSet {

		/**
		* Stores the key code mapped to the <strong>right</strong> direction for this player
		*/
		public var R_key:uint;
		/**
		* Stores the key code mapped to the <strong>up</strong> direction for this player
		*/
		public var U_key:uint;
		/**
		* Stores the key code mapped to the <strong>left</strong> direction for this player
		*/
		public var L_key:uint;
		/**
		* Stores the key code mapped to the <strong>down</strong> direction for this player
		*/
		public var D_key:uint;
		/**
		* Stores the key code mapped to the <strong>X</strong> button for this player
		*/
		public var X_key:uint;
		/**
		* Stores the key code mapped to the <strong>A</strong> button for this player
		*/
		public var A_key:uint;
		/**
		* Stores the key code mapped to the <strong>B</strong> button for this player
		*/
		public var B_key:uint;
		/**
		* Stores the key code mapped to the <strong>C</strong> button for this player
		*/
		public var C_key:uint;
	
		/**
		* Stores the <strong>right</strong> direction engage <code>ControlEvent</code> for this player
		*/
		public var R_press:ControlEvent;
		/**
		* Stores the <strong>up</strong> direction engage <code>ControlEvent</code> for this player
		*/
		public var U_press:ControlEvent;
		/**
		* Stores the <strong>left</strong> direction engage <code>ControlEvent</code> for this player
		*/
		public var L_press:ControlEvent;
		/**
		* Stores the <strong>down</strong> direction engage <code>ControlEvent</code> for this player
		*/
		public var D_press:ControlEvent;
		/**
		* Stores the <strong>X</strong> button press <code>ControlEvent</code> for this player
		*/
		public var X_press:ControlEvent;
		/**
		* Stores the <strong>A</strong> button press <code>ControlEvent</code> for this player
		*/
		public var A_press:ControlEvent;
		/**
		* Stores the <strong>B</strong> button press <code>ControlEvent</code> for this player
		*/
		public var B_press:ControlEvent;
		/**
		* Stores the <strong>C</strong> button press <code>ControlEvent</code> for this player
		*/
		public var C_press:ControlEvent;
	
		/**
		* Stores the <strong>right</strong> direction disengage <code>ControlEvent</code> for this player
		*/
		public var R_release:ControlEvent;
		/**
		* Stores the <strong>up</strong> direction disengage <code>ControlEvent</code> for this player
		*/
		public var U_release:ControlEvent;
		/**
		* Stores the <strong>left</strong> direction disengage <code>ControlEvent</code> for this player
		*/
		public var L_release:ControlEvent;
		/**
		* Stores the <strong>down</strong> direction disengage <code>ControlEvent</code> for this player
		*/
		public var D_release:ControlEvent;
		/**
		* Stores the <strong>X</strong> button release <code>ControlEvent</code> for this player
		*/
		public var X_release:ControlEvent;
		/**
		* Stores the <strong>A</strong> button release <code>ControlEvent</code> for this player
		*/
		public var A_release:ControlEvent;
		/**
		* Stores the <strong>B</strong> button release <code>ControlEvent</code> for this player
		*/
		public var B_release:ControlEvent;
		/**
		* Stores the <strong>C</strong> button release <code>ControlEvent</code> for this player
		*/
		public var C_release:ControlEvent;
	
		/**
		* <code>true</code> when <strong>right</strong> direction is engaged on joystick of this player
		*/
		public var R:Boolean = false;
		/**
		* <code>true</code> when <strong>up</strong> direction is engaged on joystick of this player
		*/
		public var U:Boolean = false;
		/**
		* <code>true</code> when <strong>left</strong> direction is engaged on joystick of this player
		*/
		public var L:Boolean = false;
		/**
		* <code>true</code> when <strong>down</strong> direction is engaged on joystick of this player
		*/
		public var D:Boolean = false;
		/**
		* <code>true</code> when <strong>X</strong> button is pressed for this player
		*/
		public var X:Boolean = false;
		/**
		* <code>true</code> when <strong>A</strong> button is pressed for this player
		*/
		public var A:Boolean = false;
		/**
		* <code>true</code> when <strong>B</strong> button is pressed for this player
		*/
		public var B:Boolean = false;
		/**
		* <code>true</code> when <strong>C</strong> button is pressed for this player
		*/
		public var C:Boolean = false;


		/**
		* Create a new <code>FourPlayerButtonSet</code> for a specific player.
		* 
		* @param playerNumber Numeric player id
		*/
		public function FourPlayerButtonSet(playerNumber:uint = 0) {
		
			switch(playerNumber) {
				case 1:
					R_key = 49;  /* 1 */
					U_key = 50;  /* 2 */
					L_key = 51;  /* 3 */
					D_key = 52;  /* 4 */
					X_key = 53;  /* 5 */
					A_key = 54;  /* 6 */
					B_key = 55;  /* 7 */
					C_key = 56;  /* 8 */
				break;
				
				case 2:
					R_key = 81;  /* Q */
					U_key = 87;  /* W */
					L_key = 69;  /* E */
					D_key = 82;  /* R */
					X_key = 84;  /* T */
					A_key = 89;  /* Y */
					B_key = 85;  /* U */
					C_key = 73;  /* I */
				break;
				
				case 3:
					R_key = 65;  /* A */
					U_key = 83;  /* S */
					L_key = 68;  /* D */
					D_key = 70;  /* F */
					X_key = 71;  /* G */
					A_key = 72;  /* H */
					B_key = 74;  /* J */
					C_key = 75;  /* K */
				break;
				
				case 4:
					R_key = 90;  /* Z */
					U_key = 88;  /* X */
					L_key = 67;  /* C */
					D_key = 86;  /* V */
					X_key = 66;  /* B */
					A_key = 78;  /* N */
					B_key = 77;  /* M */
					C_key = 188; /* , */
				break;
				
				case 0:
				// a default player, with keys that work easier for testing
					playerNumber = 1;
					R_key = 39;  /* ARROW RIGHT */
					U_key = 38;  /* ARROW UP */
					L_key = 37;  /* ARROW LEFT */
					D_key = 40;  /* ARROW DOWN */
					X_key = 32;  /* SPACE */
					A_key = 17;  /* CONTROL */
					B_key = 16;  /* SHIFT */
					C_key = 13;  /* ENTER */
				break;
			}
			
			var prefix:String = "P" +playerNumber;
			var playerIndex:uint = playerNumber - 1;
			
			R_press = new ControlEvent(prefix +"_R_press"); R_press.playerIndex = playerIndex;
			U_press = new ControlEvent(prefix +"_U_press"); U_press.playerIndex = playerIndex;
			L_press = new ControlEvent(prefix +"_L_press"); L_press.playerIndex = playerIndex;
			D_press = new ControlEvent(prefix +"_D_press"); D_press.playerIndex = playerIndex;
			X_press = new ControlEvent(prefix +"_X_press"); X_press.playerIndex = playerIndex;
			A_press = new ControlEvent(prefix +"_A_press"); A_press.playerIndex = playerIndex;
			B_press = new ControlEvent(prefix +"_B_press"); B_press.playerIndex = playerIndex;
			C_press = new ControlEvent(prefix +"_C_press"); C_press.playerIndex = playerIndex;
			
			R_release = new ControlEvent(prefix +"_R_release"); R_release.playerIndex = playerIndex;
			U_release = new ControlEvent(prefix +"_U_release"); U_release.playerIndex = playerIndex;
			L_release = new ControlEvent(prefix +"_L_release"); L_release.playerIndex = playerIndex;
			D_release = new ControlEvent(prefix +"_D_release"); D_release.playerIndex = playerIndex;
			X_release = new ControlEvent(prefix +"_X_release"); X_release.playerIndex = playerIndex;
			A_release = new ControlEvent(prefix +"_A_release"); A_release.playerIndex = playerIndex;
			B_release = new ControlEvent(prefix +"_B_release"); B_release.playerIndex = playerIndex;
			C_release = new ControlEvent(prefix +"_C_release"); C_release.playerIndex = playerIndex;
		}
		
	}
}
