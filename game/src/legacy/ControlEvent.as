package legacy {

import flash.events.Event;

/**
* This class emulates functionality provided by an old version of R-C4D3.
* It is Spice Hunter specific.
*
* <code>ControlEvent</code> objects are dispatched in response to user input through the R-C4D3 joysticks and buttons.
* There are sixteen types of control events for each player:
* <em>press</em> and <em>release</em> for each of the four joystick directions and the four buttons.
*
* @see legacy.FourPlayerControl
*/
public class ControlEvent extends Event {


  /**
  * Value of the <code>type</code> property of the event object for a <code>menuPress</code> event.
  *
  * @eventType menuPress
  */
  public static const MENU_PRESS:String = "menuPress";
  /**
  * Value of the <code>type</code> property of the event object for a <code>menuRelease</code> event.
  *
  * @eventType menuRelease
  */
  public static const MENU_RELEASE:String = "menuRelease";


  /**
  * Value of the <code>type</code> property of the event object for an <code>anyPress</code> event.
  *
  * @eventType anyPress
  */
  public static const ANY_PRESS:String = "anyPress";
  /**
  * Value of the <code>type</code> property of the event object for an <code>anyRelease</code> event.
  *
  * @eventType anyRelease
  */
  public static const ANY_RELEASE:String = "anyRelease";


  /**
  * Value of the <code>type</code> property of the event object for a <code>P1_R_press</code> event.
  *
  * @eventType P1_R_press
  */
  public static const P1_R_PRESS:String = "P1_R_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P1_U_press</code> event.
  *
  * @eventType P1_U_press
  */
  public static const P1_U_PRESS:String = "P1_U_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P1_L_press</code> event.
  *
  * @eventType P1_L_press
  */
  public static const P1_L_PRESS:String = "P1_L_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P1_D_press</code> event.
  *
  * @eventType P1_D_press
  */
  public static const P1_D_PRESS:String = "P1_D_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P1_X_press</code> event.
  *
  * @eventType P1_X_press
  */
  public static const P1_X_PRESS:String = "P1_X_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P1_A_press</code> event.
  *
  * @eventType P1_A_press
  */
  public static const P1_A_PRESS:String = "P1_A_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P1_B_press</code> event.
  *
  * @eventType P1_B_press
  */
  public static const P1_B_PRESS:String = "P1_B_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P1_C_press</code> event.
  *
  * @eventType P1_C_press
  */
  public static const P1_C_PRESS:String = "P1_C_press";


  /**
  * Value of the <code>type</code> property of the event object for a <code>P1_R_RELEASE</code> event.
  *
  * @eventType P1_R_RELEASE
  */
  public static const P1_R_RELEASE:String = "P1_R_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P1_U_RELEASE</code> event.
  *
  * @eventType P1_U_RELEASE
  */
  public static const P1_U_RELEASE:String = "P1_U_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P1_L_RELEASE</code> event.
  *
  * @eventType P1_L_RELEASE
  */
  public static const P1_L_RELEASE:String = "P1_L_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P1_D_RELEASE</code> event.
  *
  * @eventType P1_D_RELEASE
  */
  public static const P1_D_RELEASE:String = "P1_D_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P1_X_RELEASE</code> event.
  *
  * @eventType P1_X_RELEASE
  */
  public static const P1_X_RELEASE:String = "P1_X_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P1_A_RELEASE</code> event.
  *
  * @eventType P1_A_RELEASE
  */
  public static const P1_A_RELEASE:String = "P1_A_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P1_B_RELEASE</code> event.
  *
  * @eventType P1_B_RELEASE
  */
  public static const P1_B_RELEASE:String = "P1_B_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P1_C_RELEASE</code> event.
  *
  * @eventType P1_C_RELEASE
  */
  public static const P1_C_RELEASE:String = "P1_C_release";


  /**
  * Value of the <code>type</code> property of the event object for a <code>P2_R_press</code> event.
  *
  * @eventType P2_R_press
  */
  public static const P2_R_PRESS:String = "P2_R_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P2_U_press</code> event.
  *
  * @eventType P2_U_press
  */
  public static const P2_U_PRESS:String = "P2_U_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P2_L_press</code> event.
  *
  * @eventType P2_L_press
  */
  public static const P2_L_PRESS:String = "P2_L_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P2_D_press</code> event.
  *
  * @eventType P2_D_press
  */
  public static const P2_D_PRESS:String = "P2_D_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P2_X_press</code> event.
  *
  * @eventType P2_X_press
  */
  public static const P2_X_PRESS:String = "P2_X_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P2_A_press</code> event.
  *
  * @eventType P2_A_press
  */
  public static const P2_A_PRESS:String = "P2_A_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P2_B_press</code> event.
  *
  * @eventType P2_B_press
  */
  public static const P2_B_PRESS:String = "P2_B_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P2_C_press</code> event.
  *
  * @eventType P2_C_press
  */
  public static const P2_C_PRESS:String = "P2_C_press";


  /**
  * Value of the <code>type</code> property of the event object for a <code>P2_R_RELEASE</code> event.
  *
  * @eventType P2_R_RELEASE
  */
  public static const P2_R_RELEASE:String = "P2_R_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P2_U_RELEASE</code> event.
  *
  * @eventType P2_U_RELEASE
  */
  public static const P2_U_RELEASE:String = "P2_U_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P2_L_RELEASE</code> event.
  *
  * @eventType P2_L_RELEASE
  */
  public static const P2_L_RELEASE:String = "P2_L_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P2_D_RELEASE</code> event.
  *
  * @eventType P2_D_RELEASE
  */
  public static const P2_D_RELEASE:String = "P2_D_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P2_X_RELEASE</code> event.
  *
  * @eventType P2_X_RELEASE
  */
  public static const P2_X_RELEASE:String = "P2_X_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P2_A_RELEASE</code> event.
  *
  * @eventType P2_A_RELEASE
  */
  public static const P2_A_RELEASE:String = "P2_A_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P2_B_RELEASE</code> event.
  *
  * @eventType P2_B_RELEASE
  */
  public static const P2_B_RELEASE:String = "P2_B_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P2_C_RELEASE</code> event.
  *
  * @eventType P2_C_RELEASE
  */
  public static const P2_C_RELEASE:String = "P2_C_release";


  /**
  * Value of the <code>type</code> property of the event object for a <code>P3_R_press</code> event.
  *
  * @eventType P3_R_press
  */
  public static const P3_R_PRESS:String = "P3_R_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P3_U_press</code> event.
  *
  * @eventType P3_U_press
  */
  public static const P3_U_PRESS:String = "P3_U_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P3_L_press</code> event.
  *
  * @eventType P3_L_press
  */
  public static const P3_L_PRESS:String = "P3_L_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P3_D_press</code> event.
  *
  * @eventType P3_D_press
  */
  public static const P3_D_PRESS:String = "P3_D_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P3_X_press</code> event.
  *
  * @eventType P3_X_press
  */
  public static const P3_X_PRESS:String = "P3_X_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P3_A_press</code> event.
  *
  * @eventType P3_A_press
  */
  public static const P3_A_PRESS:String = "P3_A_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P3_B_press</code> event.
  *
  * @eventType P3_B_press
  */
  public static const P3_B_PRESS:String = "P3_B_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P3_C_press</code> event.
  *
  * @eventType P3_C_press
  */
  public static const P3_C_PRESS:String = "P3_C_press";


  /**
  * Value of the <code>type</code> property of the event object for a <code>P3_R_RELEASE</code> event.
  *
  * @eventType P3_R_RELEASE
  */
  public static const P3_R_RELEASE:String = "P3_R_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P3_U_RELEASE</code> event.
  *
  * @eventType P3_U_RELEASE
  */
  public static const P3_U_RELEASE:String = "P3_U_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P3_L_RELEASE</code> event.
  *
  * @eventType P3_L_RELEASE
  */
  public static const P3_L_RELEASE:String = "P3_L_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P3_D_RELEASE</code> event.
  *
  * @eventType P3_D_RELEASE
  */
  public static const P3_D_RELEASE:String = "P3_D_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P3_X_RELEASE</code> event.
  *
  * @eventType P3_X_RELEASE
  */
  public static const P3_X_RELEASE:String = "P3_X_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P3_A_RELEASE</code> event.
  *
  * @eventType P3_A_RELEASE
  */
  public static const P3_A_RELEASE:String = "P3_A_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P3_B_RELEASE</code> event.
  *
  * @eventType P3_B_RELEASE
  */
  public static const P3_B_RELEASE:String = "P3_B_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P3_C_RELEASE</code> event.
  *
  * @eventType P3_C_RELEASE
  */
  public static const P3_C_RELEASE:String = "P3_C_release";


  /**
  * Value of the <code>type</code> property of the event object for a <code>P4_R_press</code> event.
  *
  * @eventType P4_R_press
  */
  public static const P4_R_PRESS:String = "P4_R_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P4_U_press</code> event.
  *
  * @eventType P4_U_press
  */
  public static const P4_U_PRESS:String = "P4_U_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P4_L_press</code> event.
  *
  * @eventType P4_L_press
  */
  public static const P4_L_PRESS:String = "P4_L_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P4_D_press</code> event.
  *
  * @eventType P4_D_press
  */
  public static const P4_D_PRESS:String = "P4_D_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P4_X_press</code> event.
  *
  * @eventType P4_X_press
  */
  public static const P4_X_PRESS:String = "P4_X_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P4_A_press</code> event.
  *
  * @eventType P4_A_press
  */
  public static const P4_A_PRESS:String = "P4_A_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P4_B_press</code> event.
  *
  * @eventType P4_B_press
  */
  public static const P4_B_PRESS:String = "P4_B_press";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P4_C_press</code> event.
  *
  * @eventType P4_C_press
  */
  public static const P4_C_PRESS:String = "P4_C_press";


  /**
  * Value of the <code>type</code> property of the event object for a <code>P4_R_RELEASE</code> event.
  *
  * @eventType P4_R_RELEASE
  */
  public static const P4_R_RELEASE:String = "P4_R_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P4_U_RELEASE</code> event.
  *
  * @eventType P4_U_RELEASE
  */
  public static const P4_U_RELEASE:String = "P4_U_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P4_L_RELEASE</code> event.
  *
  * @eventType P4_L_RELEASE
  */
  public static const P4_L_RELEASE:String = "P4_L_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P4_D_RELEASE</code> event.
  *
  * @eventType P4_D_RELEASE
  */
  public static const P4_D_RELEASE:String = "P4_D_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P4_X_RELEASE</code> event.
  *
  * @eventType P4_X_RELEASE
  */
  public static const P4_X_RELEASE:String = "P4_X_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P4_A_RELEASE</code> event.
  *
  * @eventType P4_A_RELEASE
  */
  public static const P4_A_RELEASE:String = "P4_A_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P4_B_RELEASE</code> event.
  *
  * @eventType P4_B_RELEASE
  */
  public static const P4_B_RELEASE:String = "P4_B_release";
  /**
  * Value of the <code>type</code> property of the event object for a <code>P4_C_RELEASE</code> event.
  *
  * @eventType P4_C_RELEASE
  */
  public static const P4_C_RELEASE:String = "P4_C_release";


  /**
  * Player index [0,3).
  */
  public var playerIndex:uint;


  /**
  * From Key.getCode(). Only set for ANY_PRESS and ANY_RELEASE events.
  */
  public var keyCode:Number;


  /**
  * Creates a new ControlEvent instance for a specific control event type.
  *
  * @param type The control event flavor, e.g. <code>ControlEvent.P1_J_RELEASE</code>
  */
  public function ControlEvent(type:String) {
    super(type); // bubbles and cancelable are optional
  }

  /**
  * @inheritDoc
  */
  public override function clone():Event {
    // override clone so the event can be redispatched
    var e:ControlEvent = new ControlEvent(type);
    e.playerIndex = playerIndex;
    e.keyCode = keyCode;
    return e;
  }

  }
}