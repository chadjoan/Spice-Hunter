
package legacy {

import flash.display.Sprite;

import legacy.ControlEvent;
import legacy.FourPlayerControl;


/**
* This class emulates functionality provided by an old version of R-C4D3.
* It is Spice Hunter specific.
*
* <code>FourPlayerControlListener</code> encapsulates the event hookups to <code>FourPlayerControl</code>,
* to provide a convenient base class for control integration.
*
* Sub classes can override only the methods they wish make use of, and needn't worry about hooking up events.
*
* @example The following code shows a subclass of <code>FourPlayerControlListener</code>
* overriding the Player1 joystick right press (<em>P1Rp</em>) event handler:
* <listing version="3.0" >
* package {
*    import legacy.ControlEvent;
*    import legacy.FourPlayerControlListener;
*
*    public class MyControlEventHandler extends FourPlayerControlListener {
*       public function MyControlEventHandler() {
*          super();
*       }
*       protected override function P1Rp(e:ControlEvent):void {
*            // event handling code here
*       }
*    }
* }
* </listing>
*
* @see legacy.FourPlayerControl
*/
public class FourPlayerControlListener extends PlayerControlListener
  {


  /**
  * Create a new <code>FourPlayerControlListener</code>.
  */
  public function FourPlayerControlListener()
    {
      super();
    }

  // connect/disconnect are now inherited from PlayerControlListener

  // Sometimes... sometimes I wish I were writing D code and had powerful
  //   metaprogramming that is worth a damn.
  protected override function Rp(e:ControlEvent):void { dispatchEvent(e,P1Rp,P2Rp,P3Rp,P4Rp); }
  protected override function Rr(e:ControlEvent):void { dispatchEvent(e,P1Rr,P2Rr,P3Rr,P4Rr); }
  protected override function Up(e:ControlEvent):void { dispatchEvent(e,P1Up,P2Up,P3Up,P4Up); }
  protected override function Ur(e:ControlEvent):void { dispatchEvent(e,P1Ur,P2Ur,P3Ur,P4Ur); }
  protected override function Lp(e:ControlEvent):void { dispatchEvent(e,P1Lp,P2Lp,P3Lp,P4Lp); }
  protected override function Lr(e:ControlEvent):void { dispatchEvent(e,P1Lr,P2Lr,P3Lr,P4Lr); }
  protected override function Dp(e:ControlEvent):void { dispatchEvent(e,P1Dp,P2Dp,P3Dp,P4Dp); }
  protected override function Dr(e:ControlEvent):void { dispatchEvent(e,P1Dr,P2Dr,P3Dr,P4Dr); }
  protected override function Xp(e:ControlEvent):void { dispatchEvent(e,P1Xp,P2Xp,P3Xp,P4Xp); }
  protected override function Xr(e:ControlEvent):void { dispatchEvent(e,P1Xr,P2Xr,P3Xr,P4Xr); }
  protected override function Ap(e:ControlEvent):void { dispatchEvent(e,P1Ap,P2Ap,P3Ap,P4Ap); }
  protected override function Ar(e:ControlEvent):void { dispatchEvent(e,P1Ar,P2Ar,P3Ar,P4Ar); }
  protected override function Bp(e:ControlEvent):void { dispatchEvent(e,P1Bp,P2Bp,P3Bp,P4Bp); }
  protected override function Br(e:ControlEvent):void { dispatchEvent(e,P1Br,P2Br,P3Br,P4Br); }
  protected override function Cp(e:ControlEvent):void { dispatchEvent(e,P1Cp,P2Cp,P3Cp,P4Cp); }
  protected override function Cr(e:ControlEvent):void { dispatchEvent(e,P1Cr,P2Cr,P3Cr,P4Cr); }

  // Because having to write this switch-case in each of the above functions would be so ... blah.
  private function dispatchEvent(e:ControlEvent, p1f : Function, p2f : Function, p3f : Function, p4f : Function ) : void
    {
    switch ( e.playerIndex )
      {
      case 0: p1f(e); break;
      case 1: p2f(e); break;
      case 2: p3f(e); break;
      case 3: p4f(e); break;
      default: trace("Bad player index: " + e.playerIndex);
      }
    }

  /**
  * Handle player 1 joystick right press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P1Rp(e:ControlEvent):void {  }
  /**
  * Handle player 1 joystick right release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P1Rr(e:ControlEvent):void {  }
  /**
  * Handle player 1 joystick up press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P1Up(e:ControlEvent):void {  }
  /**
  * Handle player 1 joystick up release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P1Ur(e:ControlEvent):void {  }
  /**
  * Handle player 1 joystick left press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P1Lp(e:ControlEvent):void {  }
  /**
  * Handle player 1 joystick left release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P1Lr(e:ControlEvent):void {  }
  /**
  * Handle player 1 joystick down press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P1Dp(e:ControlEvent):void {  }
  /**
  * Handle player 1 joystick down release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P1Dr(e:ControlEvent):void {  }
  /**
  * Handle player 1 X button press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P1Xp(e:ControlEvent):void {  }
  /**
  * Handle player 1 X button release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P1Xr(e:ControlEvent):void {  }
  /**
  * Handle player 1 A button press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P1Ap(e:ControlEvent):void {  }
  /**
  * Handle player 1 A button release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P1Ar(e:ControlEvent):void {  }
  /**
  * Handle player 1 B button press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P1Bp(e:ControlEvent):void {  }
  /**
  * Handle player 1 B button release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P1Br(e:ControlEvent):void {  }
  /**
  * Handle player 1 C button press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P1Cp(e:ControlEvent):void {  }
  /**
  * Handle player 1 C button release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P1Cr(e:ControlEvent):void {  }


  /**
  * Handle player 2 joystick right press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P2Rp(e:ControlEvent):void {  }
  /**
  * Handle player 2 joystick right release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P2Rr(e:ControlEvent):void {  }
  /**
  * Handle player 2 joystick up press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P2Up(e:ControlEvent):void {  }
  /**
  * Handle player 2 joystick up release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P2Ur(e:ControlEvent):void {  }
  /**
  * Handle player 2 joystick left press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P2Lp(e:ControlEvent):void {  }
  /**
  * Handle player 2 joystick left release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P2Lr(e:ControlEvent):void {  }
  /**
  * Handle player 2 joystick down press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P2Dp(e:ControlEvent):void {  }
  /**
  * Handle player 2 joystick down release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P2Dr(e:ControlEvent):void {  }
  /**
  * Handle player 2 X button press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P2Xp(e:ControlEvent):void {  }
  /**
  * Handle player 2 X button release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P2Xr(e:ControlEvent):void {  }
  /**
  * Handle player 2 A button press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P2Ap(e:ControlEvent):void {  }
  /**
  * Handle player 2 A button release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P2Ar(e:ControlEvent):void {  }
  /**
  * Handle player 2 B button press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P2Bp(e:ControlEvent):void {  }
  /**
  * Handle player 2 B button release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P2Br(e:ControlEvent):void {  }
  /**
  * Handle player 2 C button press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P2Cp(e:ControlEvent):void {  }
  /**
  * Handle player 2 C button release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P2Cr(e:ControlEvent):void {  }


  /**
  * Handle player 3 joystick right press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P3Rp(e:ControlEvent):void {  }
  /**
  * Handle player 3 joystick right release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P3Rr(e:ControlEvent):void {  }
  /**
  * Handle player 3 joystick up press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P3Up(e:ControlEvent):void {  }
  /**
  * Handle player 3 joystick up release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P3Ur(e:ControlEvent):void {  }
  /**
  * Handle player 3 joystick left press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P3Lp(e:ControlEvent):void {  }
  /**
  * Handle player 3 joystick left release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P3Lr(e:ControlEvent):void {  }
  /**
  * Handle player 3 joystick down press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P3Dp(e:ControlEvent):void {  }
  /**
  * Handle player 3 joystick down release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P3Dr(e:ControlEvent):void {  }
  /**
  * Handle player 3 X button press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P3Xp(e:ControlEvent):void {  }
  /**
  * Handle player 3 X button release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P3Xr(e:ControlEvent):void {  }
  /**
  * Handle player 3 A button press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P3Ap(e:ControlEvent):void {  }
  /**
  * Handle player 3 A button release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P3Ar(e:ControlEvent):void {  }
  /**
  * Handle player 3 B button press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P3Bp(e:ControlEvent):void {  }
  /**
  * Handle player 3 B button release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P3Br(e:ControlEvent):void {  }
  /**
  * Handle player 3 C button press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P3Cp(e:ControlEvent):void {  }
  /**
  * Handle player 3 C button release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P3Cr(e:ControlEvent):void {  }


  /**
  * Handle player 4 joystick right press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P4Rp(e:ControlEvent):void {  }
  /**
  * Handle player 4 joystick right release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P4Rr(e:ControlEvent):void {  }
  /**
  * Handle player 4 joystick up press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P4Up(e:ControlEvent):void {  }
  /**
  * Handle player 4 joystick up release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P4Ur(e:ControlEvent):void {  }
  /**
  * Handle player 4 joystick left press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P4Lp(e:ControlEvent):void {  }
  /**
  * Handle player 4 joystick left release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P4Lr(e:ControlEvent):void {  }
  /**
  * Handle player 4 joystick down press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P4Dp(e:ControlEvent):void {  }
  /**
  * Handle player 4 joystick down release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P4Dr(e:ControlEvent):void {  }
  /**
  * Handle player 4 X button press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P4Xp(e:ControlEvent):void {  }
  /**
  * Handle player 4 X button release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P4Xr(e:ControlEvent):void {  }
  /**
  * Handle player 4 A button press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P4Ap(e:ControlEvent):void {  }
  /**
  * Handle player 4 A button release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P4Ar(e:ControlEvent):void {  }
  /**
  * Handle player 4 B button press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P4Bp(e:ControlEvent):void {  }
  /**
  * Handle player 4 B button release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P4Br(e:ControlEvent):void {  }
  /**
  * Handle player 4 C button press.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P4Cp(e:ControlEvent):void {  }
  /**
  * Handle player 4 C button release.
  * @param e com.pixeldroid.r_c4d3.controls.ControlEvent
  */
  protected function P4Cr(e:ControlEvent):void {  }

  }

}