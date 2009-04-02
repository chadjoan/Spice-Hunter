
package com.pixeldroid.r_c4d3.controls.fourplayer {
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;

	import com.pixeldroid.r_c4d3.PathConstants;
	import com.pixeldroid.r_c4d3.controls.ControlEvent;
	import com.pixeldroid.r_c4d3.controls.fourplayer.FourPlayerButtonSet;

// Events - - - - -

// menu
	/**
	* Dispatched when the <strong>menu</strong> button is <em>pressed</em>.
	* This event is sent only once, no matter how long the button is held down.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.MENU_PRESS
	*/
	[Event(name="menuPress", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>menu</strong> button is <em>released</em>
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.MENU_RELEASE
	*/
	[Event(name="menuRelease", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]



// anykey
	/**
	* Dispatched when <strong>any</strong> key is <em>pressed</em>.
	* This event is sent only once, no matter how long the key is held down.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.ANY_PRESS
	*/
	[Event(name="anyPress", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when <strong>any</strong> key is <em>released</em>
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.ANY_RELEASE
	*/
	[Event(name="anyRelease", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]


// P1 press
	/**
	* Dispatched when the <strong>right</strong> direction is <em>engaged</em> for joystick of player 1.
	* This event is sent only once, no matter how long the direction is engaged.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P1_R_PRESS
	*/
	[Event(name="P1_R_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>up</strong> direction is <em>engaged</em> for joystick of player 1.
	* This event is sent only once, no matter how long the direction is engaged.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P1_U_PRESS
	*/
	[Event(name="P1_U_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>left</strong> direction is <em>engaged</em> for joystick of player 1.
	* This event is sent only once, no matter how long the direction is engaged.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P1_L_PRESS
	*/
	[Event(name="P1_L_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>down</strong> direction is <em>engaged</em> for joystick of player 1.
	* This event is sent only once, no matter how long the direction is engaged.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P1_D_PRESS
	*/
	[Event(name="P1_D_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>X</strong> button is <em>pressed</em> for player 1.
	* This event is sent only once, no matter how long the button is held down.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P1_X_PRESS
	*/
	[Event(name="P1_X_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>A</strong> button is <em>pressed</em> for player 1.
	* This event is sent only once, no matter how long the button is held down.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P1_A_PRESS
	*/
	[Event(name="P1_A_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>B</strong> button is <em>pressed</em> for player 1.
	* This event is sent only once, no matter how long the button is held down.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P1_B_PRESS
	*/
	[Event(name="P1_B_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>C</strong> button is <em>pressed</em> for player 1.
	* This event is sent only once, no matter how long the button is held down.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P1_C_PRESS
	*/
	[Event(name="P1_C_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]

// P1 release
	/**
	* Dispatched when the <strong>right</strong> direction is <em>disengaged</em> for joystick of player 1.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P1_R_RELEASE
	*/
	[Event(name="P1_R_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>up</strong> direction is <em>disengaged</em> for joystick of player 1.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P1_U_RELEASE
	*/
	[Event(name="P1_U_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>left</strong> direction is <em>disengaged</em> for joystick of player 1.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P1_L_RELEASE
	*/
	[Event(name="P1_L_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>down</strong> direction is <em>disengaged</em> for joystick of player 1.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P1_D_RELEASE
	*/
	[Event(name="P1_D_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>X</strong> button is <em>released</em> for player 1.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P1_X_RELEASE
	*/
	[Event(name="P1_X_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>A</strong> button is <em>released</em> for player 1.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P1_A_RELEASE
	*/
	[Event(name="P1_A_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>B</strong> button is <em>released</em> for player 1.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P1_B_RELEASE
	*/
	[Event(name="P1_B_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>C</strong> button is <em>released</em> for player 1.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P1_C_RELEASE
	*/
	[Event(name="P1_C_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]


// P2 press
	/**
	* Dispatched when the <strong>right</strong> direction is <em>engaged</em> for joystick of player 2.
	* This event is sent only once, no matter how long the direction is engaged.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P2_R_PRESS
	*/
	[Event(name="P2_R_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>up</strong> direction is <em>engaged</em> for joystick of player 2.
	* This event is sent only once, no matter how long the direction is engaged.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P2_U_PRESS
	*/
	[Event(name="P2_U_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>left</strong> direction is <em>engaged</em> for joystick of player 2.
	* This event is sent only once, no matter how long the direction is engaged.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P2_L_PRESS
	*/
	[Event(name="P2_L_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>down</strong> direction is <em>engaged</em> for joystick of player 2.
	* This event is sent only once, no matter how long the direction is engaged.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P2_D_PRESS
	*/
	[Event(name="P2_D_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>X</strong> button is <em>pressed</em> for player 2.
	* This event is sent only once, no matter how long the button is held down.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P2_X_PRESS
	*/
	[Event(name="P2_X_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>A</strong> button is <em>pressed</em> for player 2.
	* This event is sent only once, no matter how long the button is held down.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P2_A_PRESS
	*/
	[Event(name="P2_A_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>B</strong> button is <em>pressed</em> for player 2.
	* This event is sent only once, no matter how long the button is held down.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P2_B_PRESS
	*/
	[Event(name="P2_B_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>C</strong> button is <em>pressed</em> for player 2.
	* This event is sent only once, no matter how long the button is held down.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P2_C_PRESS
	*/
	[Event(name="P2_C_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]

// P2 release
	/**
	* Dispatched when the <strong>right</strong> direction is <em>disengaged</em> for joystick of player 2.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P2_R_RELEASE
	*/
	[Event(name="P2_R_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>up</strong> direction is <em>disengaged</em> for joystick of player 2.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P2_U_RELEASE
	*/
	[Event(name="P2_U_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>left</strong> direction is <em>disengaged</em> for joystick of player 2.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P2_L_RELEASE
	*/
	[Event(name="P2_L_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>down</strong> direction is <em>disengaged</em> for joystick of player 2.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P2_D_RELEASE
	*/
	[Event(name="P2_D_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>X</strong> button is <em>released</em> for player 2.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P2_X_RELEASE
	*/
	[Event(name="P2_X_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>A</strong> button is <em>released</em> for player 2.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P2_A_RELEASE
	*/
	[Event(name="P2_A_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>B</strong> button is <em>released</em> for player 2.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P2_B_RELEASE
	*/
	[Event(name="P2_B_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>C</strong> button is <em>released</em> for player 2.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P2_C_RELEASE
	*/
	[Event(name="P2_C_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]


// P3 press
	/**
	* Dispatched when the <strong>right</strong> direction is <em>engaged</em> for joystick of player 3.
	* This event is sent only once, no matter how long the direction is engaged.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P3_R_PRESS
	*/
	[Event(name="P3_R_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>up</strong> direction is <em>engaged</em> for joystick of player 3.
	* This event is sent only once, no matter how long the direction is engaged.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P3_U_PRESS
	*/
	[Event(name="P3_U_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>left</strong> direction is <em>engaged</em> for joystick of player 3.
	* This event is sent only once, no matter how long the direction is engaged.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P3_L_PRESS
	*/
	[Event(name="P3_L_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>down</strong> direction is <em>engaged</em> for joystick of player 3.
	* This event is sent only once, no matter how long the direction is engaged.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P3_D_PRESS
	*/
	[Event(name="P3_D_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>X</strong> button is <em>pressed</em> for player 3.
	* This event is sent only once, no matter how long the button is held down.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P3_X_PRESS
	*/
	[Event(name="P3_X_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>A</strong> button is <em>pressed</em> for player 3.
	* This event is sent only once, no matter how long the button is held down.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P3_A_PRESS
	*/
	[Event(name="P3_A_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>B</strong> button is <em>pressed</em> for player 3.
	* This event is sent only once, no matter how long the button is held down.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P3_B_PRESS
	*/
	[Event(name="P3_B_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>C</strong> button is <em>pressed</em> for player 3.
	* This event is sent only once, no matter how long the button is held down.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P3_C_PRESS
	*/
	[Event(name="P3_C_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]

// P3 release
	/**
	* Dispatched when the <strong>right</strong> direction is <em>disengaged</em> for joystick of player 3.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P3_R_RELEASE
	*/
	[Event(name="P3_R_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>up</strong> direction is <em>disengaged</em> for joystick of player 3.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P3_U_RELEASE
	*/
	[Event(name="P3_U_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>left</strong> direction is <em>disengaged</em> for joystick of player 3.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P3_L_RELEASE
	*/
	[Event(name="P3_L_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>down</strong> direction is <em>disengaged</em> for joystick of player 3.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P3_D_RELEASE
	*/
	[Event(name="P3_D_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>X</strong> button is <em>released</em> for player 3.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P3_X_RELEASE
	*/
	[Event(name="P3_X_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>A</strong> button is <em>released</em> for player 3.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P3_A_RELEASE
	*/
	[Event(name="P3_A_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>B</strong> button is <em>released</em> for player 3.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P3_B_RELEASE
	*/
	[Event(name="P3_B_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>C</strong> button is <em>released</em> for player 3.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P3_C_RELEASE
	*/
	[Event(name="P3_C_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]


// P4 press
	/**
	* Dispatched when the <strong>right</strong> direction is <em>engaged</em> for joystick of player 4.
	* This event is sent only once, no matter how long the direction is engaged.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P4_R_PRESS
	*/
	[Event(name="P4_R_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>up</strong> direction is <em>engaged</em> for joystick of player 4.
	* This event is sent only once, no matter how long the direction is engaged.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P4_U_PRESS
	*/
	[Event(name="P4_U_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>left</strong> direction is <em>engaged</em> for joystick of player 4.
	* This event is sent only once, no matter how long the direction is engaged.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P4_L_PRESS
	*/
	[Event(name="P4_L_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>down</strong> direction is <em>engaged</em> for joystick of player 4.
	* This event is sent only once, no matter how long the direction is engaged.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P4_D_PRESS
	*/
	[Event(name="P4_D_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>X</strong> button is <em>pressed</em> for player 4.
	* This event is sent only once, no matter how long the button is held down.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P4_X_PRESS
	*/
	[Event(name="P4_X_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>A</strong> button is <em>pressed</em> for player 4.
	* This event is sent only once, no matter how long the button is held down.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P4_A_PRESS
	*/
	[Event(name="P4_A_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>B</strong> button is <em>pressed</em> for player 4.
	* This event is sent only once, no matter how long the button is held down.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P4_B_PRESS
	*/
	[Event(name="P4_B_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>C</strong> button is <em>pressed</em> for player 4.
	* This event is sent only once, no matter how long the button is held down.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P4_C_PRESS
	*/
	[Event(name="P4_C_press", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]

// P4 release
	/**
	* Dispatched when the <strong>right</strong> direction is <em>disengaged</em> for joystick of player 4.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P4_R_RELEASE
	*/
	[Event(name="P4_R_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>up</strong> direction is <em>disengaged</em> for joystick of player 4.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P4_U_RELEASE
	*/
	[Event(name="P4_U_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>left</strong> direction is <em>disengaged</em> for joystick of player 4.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P4_L_RELEASE
	*/
	[Event(name="P4_L_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>down</strong> direction is <em>disengaged</em> for joystick of player 4.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P4_D_RELEASE
	*/
	[Event(name="P4_D_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>X</strong> button is <em>released</em> for player 4.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P4_X_RELEASE
	*/
	[Event(name="P4_X_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>A</strong> button is <em>released</em> for player 4.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P4_A_RELEASE
	*/
	[Event(name="P4_A_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>B</strong> button is <em>released</em> for player 4.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P4_B_RELEASE
	*/
	[Event(name="P4_B_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]
	/**
	* Dispatched when the <strong>C</strong> button is <em>released</em> for player 4.
	* 
	* @eventType com.pixeldroid.r_c4d3.controls.ControlEvent.P4_C_RELEASE
	*/
	[Event(name="P4_C_release", type="com.pixeldroid.r_c4d3.controls.ControlEvent")]



	/**
	* <code>FourPlayerControl</code> monitors game control input as keyboard events and dispatches <code>ControlEvent</code>. 
	* This includes the menu button event to return to the main menu html page.
	* 
	* <code>FourPlayerControl</code> is designed to work with a controller having
	* one menu button and for each of four players, a 4-way joystick and four buttons.
	* 
	* <code>FourPlayerControl</code> is a singleton--get a reference to it via its instance property
	* 
	* Call the #connect method to activate the control.
	* 
	* @see com.pixeldroid.r_c4d3.controls.ControlEvent
	* @see com.pixeldroid.r_c4d3.controls.FourPlayerControlListener
	* @see com.pixeldroid.r_c4d3.controls.PlayerControlListener
	*/
	public final class FourPlayerControl extends EventDispatcher {
		private static const M_key:uint = 123;
		private static const M_URL:URLRequest = new URLRequest(PathConstants.RETURN_TO_MENU);
	
		private static const P0:FourPlayerButtonSet = new FourPlayerButtonSet(0); // default player 1
		private static const P1:FourPlayerButtonSet = new FourPlayerButtonSet(1);
		private static const P2:FourPlayerButtonSet = new FourPlayerButtonSet(2);
		private static const P3:FourPlayerButtonSet = new FourPlayerButtonSet(3);
		private static const P4:FourPlayerButtonSet = new FourPlayerButtonSet(4);
		private static const players:Array = [P0, P1, P2, P3, P4];
		private static const totalPlayers:uint = players.length;
		
		private static var M_press:ControlEvent;
		private static var M_release:ControlEvent;
		private static var M:Boolean = false;
		private static var menuDisabled:Boolean;
		
		private static var A_press:ControlEvent;
		private static var A_release:ControlEvent;
		private static var A:Boolean = false;
		
		private static var stageRef:Stage;
		private static var FPCinstance:FourPlayerControl = new FourPlayerControl();
		
		/**
		* Create a new <code>FourPlayerControl</code> to add event listeners to.
		*/
		public function FourPlayerControl() {
			if(!FPCinstance) {
				super(); // should not provide any value for target to EventDispatcher here
				
				M_press = new ControlEvent(ControlEvent.MENU_PRESS);
				M_release = new ControlEvent(ControlEvent.MENU_RELEASE);
				
				A_press = new ControlEvent(ControlEvent.ANY_PRESS);
				A_release = new ControlEvent(ControlEvent.ANY_RELEASE);
			}
		}
		
		
		/**
		* Connect the FourPlayerControl to a stage reference.
		* 
		* @param stage A reference to the caller's stage, 
		* for the <code>FourPlayerControl</code> to attach key listeners to
		* @param disableMenuLoad When <code>true</code>, the menu key will be ignored. 
		* <em>For debugging use only.</em>
		*/
		public function connect(stage:Stage, disableMenuLoad:Boolean = false):void {
			stageRef = stage;
			stageRef.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stageRef.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			menuDisabled = (disableMenuLoad == true);
		}
	
	
		/**
		* Disconnect this FourPlayerControl from its stage reference.
		*/
		public function disconnect():void {
			stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stageRef.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stageRef = null;
		}


		/**
		* Retrieve the FourPlayerControl instance.
		*/
		public static function get instance():FourPlayerControl {
			return FPCinstance;
		}
	
	
		
		private function onKeyDown(e:KeyboardEvent):void {
			var kc:uint = e.keyCode;
			if (kc == M_key) { if (!M) { M = true; dispatchEvent(M_press); return; } }
			
			if (!A) { A = true; A_press.keyCode = kc; dispatchEvent(A_press); }
	
			var b:uint = 0;
			var P:FourPlayerButtonSet;
			while (b < totalPlayers) {
				P = players[b];
				switch(kc) {
					case P.R_key : if (!P.R) { P.R = true; dispatchEvent(P.R_press); } return;
					case P.U_key : if (!P.U) { P.U = true; dispatchEvent(P.U_press); } return;
					case P.L_key : if (!P.L) { P.L = true; dispatchEvent(P.L_press); } return;
					case P.D_key : if (!P.D) { P.D = true; dispatchEvent(P.D_press); } return;
					case P.X_key : if (!P.X) { P.X = true; dispatchEvent(P.X_press); } return;
					case P.A_key : if (!P.A) { P.A = true; dispatchEvent(P.A_press); } return;
					case P.B_key : if (!P.B) { P.B = true; dispatchEvent(P.B_press); } return;
					case P.C_key : if (!P.C) { P.C = true; dispatchEvent(P.C_press); } return;
				}
				b++;
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			var kc:uint = e.keyCode;
			if (kc == M_key) { 
				M = false; 
				dispatchEvent(M_release); 
				if (!menuDisabled) { navigateToURL(M_URL, "_top"); }
				return; 
			}
			
			A = false; A_release.keyCode = kc; dispatchEvent(A_release);
	
			var b:uint = 0;
			var P:FourPlayerButtonSet;
			while (b < totalPlayers) {
				P = players[b];
				switch(kc) {
					case P.R_key : P.R = false; dispatchEvent(P.R_release); return;
					case P.U_key : P.U = false; dispatchEvent(P.U_release); return;
					case P.L_key : P.L = false; dispatchEvent(P.L_release); return;
					case P.D_key : P.D = false; dispatchEvent(P.D_release); return;
					case P.X_key : P.X = false; dispatchEvent(P.X_release); return;
					case P.A_key : P.A = false; dispatchEvent(P.A_release); return;
					case P.B_key : P.B = false; dispatchEvent(P.B_release); return;
					case P.C_key : P.C = false; dispatchEvent(P.C_release); return;
				}
				b++;
			}
		}
		
	}
}
