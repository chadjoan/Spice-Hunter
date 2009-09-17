package play
{

import play.Ship;
import play.Environment;
import play.GravBeam;

import legacy.ControlEvent;
import legacy.PlayerControlListener;

public class Controls extends PlayerControlListener
  {
  public var p : Array; // array of ships
  
  public function Controls( env : Environment )
    {
    p = env.ships;
    }
    
  public function expire() : void
    {
    disconnect();
    }
  
  protected override function Rp(e:ControlEvent):void { stickRight(p[e.playerIndex],true ); }
  protected override function Rr(e:ControlEvent):void { stickRight(p[e.playerIndex],false); }
  protected override function Up(e:ControlEvent):void { stickUp   (p[e.playerIndex],true ); }
  protected override function Ur(e:ControlEvent):void { stickUp   (p[e.playerIndex],false); }
  protected override function Lp(e:ControlEvent):void { stickLeft (p[e.playerIndex],true ); }
  protected override function Lr(e:ControlEvent):void { stickLeft (p[e.playerIndex],false); }
  protected override function Dp(e:ControlEvent):void { stickDown (p[e.playerIndex],true ); }
  protected override function Dr(e:ControlEvent):void { stickDown (p[e.playerIndex],false); }
  
  protected override function Cp(e:ControlEvent) : void { gBomb(p[e.playerIndex],true ); }
  protected override function Cr(e:ControlEvent) : void { gBomb(p[e.playerIndex],false); }
  protected override function Ap(e:ControlEvent) : void { beam(p[e.playerIndex],true ,GravBeam.REPEL); }
  protected override function Ar(e:ControlEvent) : void { beam(p[e.playerIndex],false,GravBeam.REPEL); }
  protected override function Bp(e:ControlEvent) : void { beam(p[e.playerIndex],true ,GravBeam.ATTRACT); }
  protected override function Br(e:ControlEvent) : void { beam(p[e.playerIndex],false,GravBeam.ATTRACT); }
  protected override function Xp(e:ControlEvent) : void 
    { if ( !p[e.playerIndex].spec.isCPUControlled ) p[e.playerIndex].tetherPress(); }
  protected override function Xr(e:ControlEvent) : void {  }
  
  private function stickRight( agent : Ship, pressed : Boolean ) : void
    {
    if ( !agent.spec.isCPUControlled )
      agent.reticle.isRightPressed = pressed;
    }
  
  private function stickUp( agent : Ship, pressed : Boolean ) : void
    {
    if ( !agent.spec.isCPUControlled )
      agent.reticle.isUpPressed = pressed;
    }
  
  private function stickLeft( agent : Ship, pressed : Boolean ) : void
    {
    if ( !agent.spec.isCPUControlled )
      agent.reticle.isLeftPressed = pressed;
    }
  
  private function stickDown( agent : Ship, pressed : Boolean ) : void
    {
    if ( !agent.spec.isCPUControlled )
      agent.reticle.isDownPressed = pressed;
    }
  
  private function gBomb( agent : Ship, pressed : Boolean ) : void
    {
    if ( !agent.spec.isCPUControlled )
      {
      if ( pressed )
        agent.gBombPress();
      else
        agent.launchGravBomb();
      }
    }
  
  private function beam( agent : Ship, pressed : Boolean, direction : int ) : void 
    {
    if ( !agent.spec.isCPUControlled )
      {
      if ( pressed )
        {
        if ( direction == GravBeam.ATTRACT )
          agent.attractBeamAt(agent.reticle.rx, agent.reticle.ry);
        else
          agent.repelBeamAt(agent.reticle.rx, agent.reticle.ry);
        }
      else
        {
        if ( direction == GravBeam.ATTRACT )
          agent.attractBeamOff();
        else
          agent.repelBeamOff();
        }
      }
    } // function beam
  
  } // class Controls

}