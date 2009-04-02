package
{

import Ship;
import Environment;

// pixeldroid packages
import com.pixeldroid.r_c4d3.controls.ControlEvent;
import com.pixeldroid.r_c4d3.controls.fourplayer.FourPlayerControl;

public class PlaytimeControls
  {
  
  public var p1 : Ship;
  public var p2 : Ship;
  public var p3 : Ship;
  public var p4 : Ship;
  
  public var environment : Environment;
  public var shipSpecs : Array;
  
  private var FPC : FourPlayerControl;
  
  //---------------------------------------------------------------------------
  //           constructor()
  //---------------------------------------------------------------------------
  public function PlaytimeControls( env : Environment, _shipSpecs:Array )
    {
    shipSpecs = _shipSpecs;
    
    //FPC = new FourPlayerControl(Screen.root.stage);
    FPC = Screen.FPC;
    environment = env;
    
    p1 = env.ships[0];
    p2 = env.ships[1];
    p3 = env.ships[2];
    p4 = env.ships[3];
    
    if (!shipSpecs[0].isCPUControlled )
      {
			FPC.addEventListener(ControlEvent.P1_R_PRESS,   p1Rp);
			FPC.addEventListener(ControlEvent.P1_R_RELEASE, p1Rr);
			FPC.addEventListener(ControlEvent.P1_U_PRESS,   p1Up);
			FPC.addEventListener(ControlEvent.P1_U_RELEASE, p1Ur);
			FPC.addEventListener(ControlEvent.P1_L_PRESS,   p1Lp);
			FPC.addEventListener(ControlEvent.P1_L_RELEASE, p1Lr);
			FPC.addEventListener(ControlEvent.P1_D_PRESS,   p1Dp);
			FPC.addEventListener(ControlEvent.P1_D_RELEASE, p1Dr);
			FPC.addEventListener(ControlEvent.P1_X_PRESS,   p1Xp);
			FPC.addEventListener(ControlEvent.P1_X_RELEASE, p1Xr);
			FPC.addEventListener(ControlEvent.P1_A_PRESS,   p1Ap);
			FPC.addEventListener(ControlEvent.P1_A_RELEASE, p1Ar);
			FPC.addEventListener(ControlEvent.P1_B_PRESS,   p1Bp);
			FPC.addEventListener(ControlEvent.P1_B_RELEASE, p1Br);
			FPC.addEventListener(ControlEvent.P1_C_PRESS,   p1Cp);
			FPC.addEventListener(ControlEvent.P1_C_RELEASE, p1Cr);
      }
    
    if ( !shipSpecs[1].isCPUControlled )
      {
			FPC.addEventListener(ControlEvent.P2_R_PRESS,   p2Rp);
			FPC.addEventListener(ControlEvent.P2_R_RELEASE, p2Rr);
			FPC.addEventListener(ControlEvent.P2_U_PRESS,   p2Up);
			FPC.addEventListener(ControlEvent.P2_U_RELEASE, p2Ur);
			FPC.addEventListener(ControlEvent.P2_L_PRESS,   p2Lp);
			FPC.addEventListener(ControlEvent.P2_L_RELEASE, p2Lr);
			FPC.addEventListener(ControlEvent.P2_D_PRESS,   p2Dp);
			FPC.addEventListener(ControlEvent.P2_D_RELEASE, p2Dr);
			FPC.addEventListener(ControlEvent.P2_X_PRESS,   p2Xp);
			FPC.addEventListener(ControlEvent.P2_X_RELEASE, p2Xr);
			FPC.addEventListener(ControlEvent.P2_A_PRESS,   p2Ap);
			FPC.addEventListener(ControlEvent.P2_A_RELEASE, p2Ar);
			FPC.addEventListener(ControlEvent.P2_B_PRESS,   p2Bp);
			FPC.addEventListener(ControlEvent.P2_B_RELEASE, p2Br);
			FPC.addEventListener(ControlEvent.P2_C_PRESS,   p2Cp);
			FPC.addEventListener(ControlEvent.P2_C_RELEASE, p2Cr);
      }
    
    if ( !shipSpecs[2].isCPUControlled )
      {
			FPC.addEventListener(ControlEvent.P3_R_PRESS,   p3Rp);
			FPC.addEventListener(ControlEvent.P3_R_RELEASE, p3Rr);
			FPC.addEventListener(ControlEvent.P3_U_PRESS,   p3Up);
			FPC.addEventListener(ControlEvent.P3_U_RELEASE, p3Ur);
			FPC.addEventListener(ControlEvent.P3_L_PRESS,   p3Lp);
			FPC.addEventListener(ControlEvent.P3_L_RELEASE, p3Lr);
			FPC.addEventListener(ControlEvent.P3_D_PRESS,   p3Dp);
			FPC.addEventListener(ControlEvent.P3_D_RELEASE, p3Dr);
			FPC.addEventListener(ControlEvent.P3_X_PRESS,   p3Xp);
			FPC.addEventListener(ControlEvent.P3_X_RELEASE, p3Xr);
			FPC.addEventListener(ControlEvent.P3_A_PRESS,   p3Ap);
			FPC.addEventListener(ControlEvent.P3_A_RELEASE, p3Ar);
			FPC.addEventListener(ControlEvent.P3_B_PRESS,   p3Bp);
			FPC.addEventListener(ControlEvent.P3_B_RELEASE, p3Br);
			FPC.addEventListener(ControlEvent.P3_C_PRESS,   p3Cp);
			FPC.addEventListener(ControlEvent.P3_C_RELEASE, p3Cr);
      }
    
    if ( !shipSpecs[3].isCPUControlled )
      {
			FPC.addEventListener(ControlEvent.P4_R_PRESS,   p4Rp);
			FPC.addEventListener(ControlEvent.P4_R_RELEASE, p4Rr);
			FPC.addEventListener(ControlEvent.P4_U_PRESS,   p4Up);
			FPC.addEventListener(ControlEvent.P4_U_RELEASE, p4Ur);
			FPC.addEventListener(ControlEvent.P4_L_PRESS,   p4Lp);
			FPC.addEventListener(ControlEvent.P4_L_RELEASE, p4Lr);
			FPC.addEventListener(ControlEvent.P4_D_PRESS,   p4Dp);
			FPC.addEventListener(ControlEvent.P4_D_RELEASE, p4Dr);
			FPC.addEventListener(ControlEvent.P4_X_PRESS,   p4Xp);
			FPC.addEventListener(ControlEvent.P4_X_RELEASE, p4Xr);
			FPC.addEventListener(ControlEvent.P4_A_PRESS,   p4Ap);
			FPC.addEventListener(ControlEvent.P4_A_RELEASE, p4Ar);
			FPC.addEventListener(ControlEvent.P4_B_PRESS,   p4Bp);
			FPC.addEventListener(ControlEvent.P4_B_RELEASE, p4Br);
			FPC.addEventListener(ControlEvent.P4_C_PRESS,   p4Cp);
			FPC.addEventListener(ControlEvent.P4_C_RELEASE, p4Cr);
      }
    
    } // function init
  
  //---------------------------------------------------------------------------
  //           expire()
  //---------------------------------------------------------------------------
  public function expire() : void
    {
    if ( !shipSpecs[0].isCPUControlled )
      {
			FPC.removeEventListener(ControlEvent.P1_R_PRESS,   p1Rp);
			FPC.removeEventListener(ControlEvent.P1_R_RELEASE, p1Rr);
			FPC.removeEventListener(ControlEvent.P1_U_PRESS,   p1Up);
			FPC.removeEventListener(ControlEvent.P1_U_RELEASE, p1Ur);
			FPC.removeEventListener(ControlEvent.P1_L_PRESS,   p1Lp);
			FPC.removeEventListener(ControlEvent.P1_L_RELEASE, p1Lr);
			FPC.removeEventListener(ControlEvent.P1_D_PRESS,   p1Dp);
			FPC.removeEventListener(ControlEvent.P1_D_RELEASE, p1Dr);
			FPC.removeEventListener(ControlEvent.P1_X_PRESS,   p1Xp);
			FPC.removeEventListener(ControlEvent.P1_X_RELEASE, p1Xr);
			FPC.removeEventListener(ControlEvent.P1_A_PRESS,   p1Ap);
			FPC.removeEventListener(ControlEvent.P1_A_RELEASE, p1Ar);
			FPC.removeEventListener(ControlEvent.P1_B_PRESS,   p1Bp);
			FPC.removeEventListener(ControlEvent.P1_B_RELEASE, p1Br);
			FPC.removeEventListener(ControlEvent.P1_C_PRESS,   p1Cp);
			FPC.removeEventListener(ControlEvent.P1_C_RELEASE, p1Cr);
      }
    
    if ( !shipSpecs[1].isCPUControlled )
      {
			FPC.removeEventListener(ControlEvent.P2_R_PRESS,   p2Rp);
			FPC.removeEventListener(ControlEvent.P2_R_RELEASE, p2Rr);
			FPC.removeEventListener(ControlEvent.P2_U_PRESS,   p2Up);
			FPC.removeEventListener(ControlEvent.P2_U_RELEASE, p2Ur);
			FPC.removeEventListener(ControlEvent.P2_L_PRESS,   p2Lp);
			FPC.removeEventListener(ControlEvent.P2_L_RELEASE, p2Lr);
			FPC.removeEventListener(ControlEvent.P2_D_PRESS,   p2Dp);
			FPC.removeEventListener(ControlEvent.P2_D_RELEASE, p2Dr);
			FPC.removeEventListener(ControlEvent.P2_X_PRESS,   p2Xp);
			FPC.removeEventListener(ControlEvent.P2_X_RELEASE, p2Xr);
			FPC.removeEventListener(ControlEvent.P2_A_PRESS,   p2Ap);
			FPC.removeEventListener(ControlEvent.P2_A_RELEASE, p2Ar);
			FPC.removeEventListener(ControlEvent.P2_B_PRESS,   p2Bp);
			FPC.removeEventListener(ControlEvent.P2_B_RELEASE, p2Br);
			FPC.removeEventListener(ControlEvent.P2_C_PRESS,   p2Cp);
			FPC.removeEventListener(ControlEvent.P2_C_RELEASE, p2Cr);
      }
    
    if ( !shipSpecs[2].isCPUControlled )
      {
			FPC.removeEventListener(ControlEvent.P3_R_PRESS,   p3Rp);
			FPC.removeEventListener(ControlEvent.P3_R_RELEASE, p3Rr);
			FPC.removeEventListener(ControlEvent.P3_U_PRESS,   p3Up);
			FPC.removeEventListener(ControlEvent.P3_U_RELEASE, p3Ur);
			FPC.removeEventListener(ControlEvent.P3_L_PRESS,   p3Lp);
			FPC.removeEventListener(ControlEvent.P3_L_RELEASE, p3Lr);
			FPC.removeEventListener(ControlEvent.P3_D_PRESS,   p3Dp);
			FPC.removeEventListener(ControlEvent.P3_D_RELEASE, p3Dr);
			FPC.removeEventListener(ControlEvent.P3_X_PRESS,   p3Xp);
			FPC.removeEventListener(ControlEvent.P3_X_RELEASE, p3Xr);
			FPC.removeEventListener(ControlEvent.P3_A_PRESS,   p3Ap);
			FPC.removeEventListener(ControlEvent.P3_A_RELEASE, p3Ar);
			FPC.removeEventListener(ControlEvent.P3_B_PRESS,   p3Bp);
			FPC.removeEventListener(ControlEvent.P3_B_RELEASE, p3Br);
			FPC.removeEventListener(ControlEvent.P3_C_PRESS,   p3Cp);
			FPC.removeEventListener(ControlEvent.P3_C_RELEASE, p3Cr);
      }
    
    if ( !shipSpecs[3].isCPUControlled )
      {
			FPC.removeEventListener(ControlEvent.P4_R_PRESS,   p4Rp);
			FPC.removeEventListener(ControlEvent.P4_R_RELEASE, p4Rr);
			FPC.removeEventListener(ControlEvent.P4_U_PRESS,   p4Up);
			FPC.removeEventListener(ControlEvent.P4_U_RELEASE, p4Ur);
			FPC.removeEventListener(ControlEvent.P4_L_PRESS,   p4Lp);
			FPC.removeEventListener(ControlEvent.P4_L_RELEASE, p4Lr);
			FPC.removeEventListener(ControlEvent.P4_D_PRESS,   p4Dp);
			FPC.removeEventListener(ControlEvent.P4_D_RELEASE, p4Dr);
			FPC.removeEventListener(ControlEvent.P4_X_PRESS,   p4Xp);
			FPC.removeEventListener(ControlEvent.P4_X_RELEASE, p4Xr);
			FPC.removeEventListener(ControlEvent.P4_A_PRESS,   p4Ap);
			FPC.removeEventListener(ControlEvent.P4_A_RELEASE, p4Ar);
			FPC.removeEventListener(ControlEvent.P4_B_PRESS,   p4Bp);
			FPC.removeEventListener(ControlEvent.P4_B_RELEASE, p4Br);
			FPC.removeEventListener(ControlEvent.P4_C_PRESS,   p4Cp);
			FPC.removeEventListener(ControlEvent.P4_C_RELEASE, p4Cr);
      }
    }
    
  //---------------------------------------------------------------------------
  //      blah blah blah blah
  //---------------------------------------------------------------------------
  
  private function p1Rp(e:ControlEvent):void { p1.reticle.stickLeftRight(1); }
  private function p1Rr(e:ControlEvent):void { p1.reticle.stickLeftRight(0); }
  private function p1Up(e:ControlEvent):void { p1.reticle.stickUpDown(-1); }
  private function p1Ur(e:ControlEvent):void { p1.reticle.stickUpDown(0); }
  private function p1Lp(e:ControlEvent):void { p1.reticle.stickLeftRight(-1); }
  private function p1Lr(e:ControlEvent):void { p1.reticle.stickLeftRight(0); }
  private function p1Dp(e:ControlEvent):void { p1.reticle.stickUpDown(1); }
  private function p1Dr(e:ControlEvent):void { p1.reticle.stickUpDown(0); }
  private function p1Cp(e:ControlEvent):void { p1.gBombPress(); }
  private function p1Cr(e:ControlEvent):void { p1.launchGravBomb(); }
  private function p1Ap(e:ControlEvent):void { p1.repelBeamAt(p1.reticle.rx, p1.reticle.ry); }
  private function p1Ar(e:ControlEvent):void { p1.repelBeamOff(); }
  private function p1Bp(e:ControlEvent):void { p1.attractBeamAt(p1.reticle.rx, p1.reticle.ry); }
  private function p1Br(e:ControlEvent):void { p1.attractBeamOff(); }
  private function p1Xp(e:ControlEvent):void { p1.tetherPress(); }
  private function p1Xr(e:ControlEvent):void {  }
  
  private function p2Rp(e:ControlEvent):void { p2.reticle.stickLeftRight(1); }
  private function p2Rr(e:ControlEvent):void { p2.reticle.stickLeftRight(0); }
  private function p2Up(e:ControlEvent):void { p2.reticle.stickUpDown(-1); }
  private function p2Ur(e:ControlEvent):void { p2.reticle.stickUpDown(0); }
  private function p2Lp(e:ControlEvent):void { p2.reticle.stickLeftRight(-1); }
  private function p2Lr(e:ControlEvent):void { p2.reticle.stickLeftRight(0); }
  private function p2Dp(e:ControlEvent):void { p2.reticle.stickUpDown(1); }
  private function p2Dr(e:ControlEvent):void { p2.reticle.stickUpDown(0); }
  private function p2Cp(e:ControlEvent):void { p2.gBombPress();  }
  private function p2Cr(e:ControlEvent):void { p2.launchGravBomb(); }
  private function p2Ap(e:ControlEvent):void { p2.repelBeamAt(p2.reticle.rx, p2.reticle.ry); }
  private function p2Ar(e:ControlEvent):void { p2.repelBeamOff(); }
  private function p2Bp(e:ControlEvent):void { p2.attractBeamAt(p2.reticle.rx, p2.reticle.ry); }
  private function p2Br(e:ControlEvent):void { p2.attractBeamOff(); }
  private function p2Xp(e:ControlEvent):void { p2.tetherPress(); }
  private function p2Xr(e:ControlEvent):void {  }
  
  private function p3Rp(e:ControlEvent):void { p3.reticle.stickLeftRight(1); }
  private function p3Rr(e:ControlEvent):void { p3.reticle.stickLeftRight(0); }
  private function p3Up(e:ControlEvent):void { p3.reticle.stickUpDown(-1); }
  private function p3Ur(e:ControlEvent):void { p3.reticle.stickUpDown(0); }
  private function p3Lp(e:ControlEvent):void { p3.reticle.stickLeftRight(-1); }
  private function p3Lr(e:ControlEvent):void { p3.reticle.stickLeftRight(0); }
  private function p3Dp(e:ControlEvent):void { p3.reticle.stickUpDown(1); }
  private function p3Dr(e:ControlEvent):void { p3.reticle.stickUpDown(0); }
  private function p3Cp(e:ControlEvent):void { p3.gBombPress(); }
  private function p3Cr(e:ControlEvent):void { p3.launchGravBomb(); }
  private function p3Ap(e:ControlEvent):void { p3.repelBeamAt(p3.reticle.rx, p3.reticle.ry); }
  private function p3Ar(e:ControlEvent):void { p3.repelBeamOff(); }
  private function p3Bp(e:ControlEvent):void { p3.attractBeamAt(p3.reticle.rx, p3.reticle.ry); }
  private function p3Br(e:ControlEvent):void { p3.attractBeamOff(); }
  private function p3Xp(e:ControlEvent):void { p3.tetherPress(); }
  private function p3Xr(e:ControlEvent):void {  }
  
  private function p4Rp(e:ControlEvent):void { p4.reticle.stickLeftRight(1); }
  private function p4Rr(e:ControlEvent):void { p4.reticle.stickLeftRight(0); }
  private function p4Up(e:ControlEvent):void { p4.reticle.stickUpDown(-1); }
  private function p4Ur(e:ControlEvent):void { p4.reticle.stickUpDown(0); }
  private function p4Lp(e:ControlEvent):void { p4.reticle.stickLeftRight(-1); }
  private function p4Lr(e:ControlEvent):void { p4.reticle.stickLeftRight(0); }
  private function p4Dp(e:ControlEvent):void { p4.reticle.stickUpDown(1); }
  private function p4Dr(e:ControlEvent):void { p4.reticle.stickUpDown(0); }
  private function p4Cp(e:ControlEvent):void { p4.gBombPress(); }
  private function p4Cr(e:ControlEvent):void { p4.launchGravBomb(); }
  private function p4Ap(e:ControlEvent):void { p4.repelBeamAt(p4.reticle.rx, p4.reticle.ry); }
  private function p4Ar(e:ControlEvent):void { p4.repelBeamOff(); }
  private function p4Bp(e:ControlEvent):void { p4.attractBeamAt(p4.reticle.rx, p4.reticle.ry); }
  private function p4Br(e:ControlEvent):void { p4.attractBeamOff(); }
  private function p4Xp(e:ControlEvent):void { p4.tetherPress(); }
  private function p4Xr(e:ControlEvent):void {  }
  
  
  } // class Controls

}