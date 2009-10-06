package legacy {

import flash.display.Sprite;

import legacy.FourPlayerControl;

import com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy;
import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;

/**
* This class emulates functionality provided by an old version of R-C4D3.
* It is Spice Hunter specific.
*
* <code>PlayerControlListener</code> encapsulates the event hookups to <code>FourPlayerControl</code>,
* to provide a convenient base class for control integration.
*
* Sub classes can override only the methods they wish make use of, and needn't worry about hooking up events.
*
* Unlike <code>FourPlayerControl</code>, <code>PlayerControl</code> makes no differentiation between
* player numbers, expecting the user to check the playerIndex property of the event being handled.
*
* @example The following code shows a subclass of <code>PlayerControlListener</code>
* overriding the right joystick press (<em>Rp</em>) event handler:
* <listing version="3.0" >
* package {
*    import legacy.ControlEvent;
*    import legacy.PlayerControlListener;
*
*    public class MyControlEventHandler extends PlayerControlListener {
*       public function MyControlEventHandler() {
*          super();
*       }
*       protected override function Rp(e:ControlEvent):void {
*            // event handling code here
*           // use e.playerIndex to determine which player
*       }
*    }
* }
* </listing>
*
* @see legacy.FourPlayerControl
* @see legacy.FourPlayerControlListener
*/
public class PlayerControlListener extends Sprite
  {

  private var connected:Boolean;

  /**
  * Create a new <code>FourPlayerControlListener</code>.
  */
  public function PlayerControlListener()
    {
    super();
    connect();
    }

  /**
  * Connect listeners to the <code>FourPlayerControlListener</code>.
  */
  public function connect():void
    {
    if (connected) { return; }

    var controls : IGameControlsProxy = FourPlayerControl.instance.gameControlsProxy;
    controls.addEventListener(JoyHatEvent.JOY_HAT_MOTION, onHatMotion); // add a listener for joystick hat events
    controls.addEventListener(JoyButtonEvent.JOY_BUTTON_MOTION, onButtonMotion); // add a listener for joystick button events
    connected = true;
    }

  /**
  * Disconnect listeners from the <code>FourPlayerControlListener</code>.
  */
  public function disconnect():void
    {
    if (!connected) { return; }

    var controls : IGameControlsProxy = FourPlayerControl.instance.gameControlsProxy;
    controls.removeEventListener(JoyHatEvent.JOY_HAT_MOTION, onHatMotion); // remove the listener for joystick hat events
    controls.removeEventListener(JoyButtonEvent.JOY_BUTTON_MOTION, onButtonMotion); // remove the listener for joystick button events
    connected = false;
    }

  private var lastHatValues : Array = new Array();
  private var currentPlayerId : uint;
  private var currentHatValue : uint;

  private function onHatMotion( evt : JoyHatEvent ) : void
    {
    trace("onHatMotion(player = "+evt.which+")");
    currentHatValue = evt.value;
    currentPlayerId = evt.which;

    if ( joyPressed(JoyHatEvent.HAT_UP) )
      Up(newControlEvent("U_press",currentPlayerId));

    if ( joyReleased(JoyHatEvent.HAT_UP) )
      Ur(newControlEvent("U_release",currentPlayerId));

    if ( joyPressed(JoyHatEvent.HAT_DOWN) )
      Dp(newControlEvent("D_press",currentPlayerId));

    if ( joyReleased(JoyHatEvent.HAT_DOWN) )
      Dr(newControlEvent("D_release",currentPlayerId));

    if ( joyPressed(JoyHatEvent.HAT_RIGHT) )
      Rp(newControlEvent("R_press"  ,currentPlayerId));

    if ( joyReleased(JoyHatEvent.HAT_RIGHT) )
      Rr(newControlEvent("R_release",currentPlayerId));

    if ( joyPressed(JoyHatEvent.HAT_LEFT) )
      Lp(newControlEvent("L_press"  ,currentPlayerId));

    if ( joyReleased(JoyHatEvent.HAT_LEFT) )
      Lr(newControlEvent("L_release",currentPlayerId));

    lastHatValues[currentPlayerId] = currentHatValue;
    }

  private function joyPressed( mask : uint ) : Boolean
    {
    var lastHatValue : uint = lastHatValues[currentPlayerId];
    var diff : uint = lastHatValue ^ currentHatValue;
    if ( diff & currentHatValue & mask )
      return true;
    else
      return false;
    }

  private function joyReleased( mask : uint ) : Boolean
    {
    var lastHatValue : uint = lastHatValues[currentPlayerId];
    var diff : uint = lastHatValue ^ currentHatValue;
    if ( diff & lastHatValue & mask )
      return true;
    else
      return false;
    }

  private function onButtonMotion( evt : JoyButtonEvent ) : void
    {
    if ( evt.pressed )
      {
      switch( evt.button )
        {
        case 0: Xp(newControlEvent("X_press",evt.which)); break;
        case 1: Ap(newControlEvent("A_press",evt.which)); break;
        case 2: Bp(newControlEvent("B_press",evt.which)); break;
        case 3: Cp(newControlEvent("C_press",evt.which)); break;
        }
      }
    else
      {
      switch( evt.button )
        {
        case 0: Xr(newControlEvent("X_release",evt.which)); break;
        case 1: Ar(newControlEvent("A_release",evt.which)); break;
        case 2: Br(newControlEvent("B_release",evt.which)); break;
        case 3: Cr(newControlEvent("C_release",evt.which)); break;
        }
      }
    }

  private function newControlEvent( buttonType : String, pid : uint ) : ControlEvent
    {
    var playerPrefix : String;
    switch ( pid )
      {
      case 0: playerPrefix = "P1_"; break;
      case 1: playerPrefix = "P2_"; break;
      case 2: playerPrefix = "P3_"; break;
      case 3: playerPrefix = "P4_"; break;
      }

    var type : String = playerPrefix + buttonType;
    var event : ControlEvent = new ControlEvent(type);
    event.playerIndex = pid;

    // HACK: We just leave the keyCode be its default value,
    //   since we don't actually know what it should be.
    
    return event;
    }

  /**
  * Handle joystick right press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function Rp(e:ControlEvent):void {  }
  /**
  * Handle joystick right release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function Rr(e:ControlEvent):void {  }
  /**
  * Handle joystick up press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function Up(e:ControlEvent):void {  }
  /**
  * Handle joystick up release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function Ur(e:ControlEvent):void {  }
  /**
  * Handle joystick left press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function Lp(e:ControlEvent):void {  }
  /**
  * Handle joystick left release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function Lr(e:ControlEvent):void {  }
  /**
  * Handle joystick down press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function Dp(e:ControlEvent):void {  }
  /**
  * Handle joystick down release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function Dr(e:ControlEvent):void {  }
  /**
  * Handle X button press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function Xp(e:ControlEvent):void {  }
  /**
  * Handle X button release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function Xr(e:ControlEvent):void {  }
  /**
  * Handle A button press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function Ap(e:ControlEvent):void {  }
  /**
  * Handle A button release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function Ar(e:ControlEvent):void {  }
  /**
  * Handle B button press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function Bp(e:ControlEvent):void {  }
  /**
  * Handle B button release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function Br(e:ControlEvent):void {  }
  /**
  * Handle C button press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function Cp(e:ControlEvent):void {  }
  /**
  * Handle C button release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function Cr(e:ControlEvent):void {  }

  }
}