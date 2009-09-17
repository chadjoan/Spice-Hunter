package
{

import play.Ship;
import play.Environment;

import Debouncer;

import legacy.ControlEvent;
import legacy.PlayerControlListener;

public class JoinUpControls extends PlayerControlListener
  {
    
  public var joinup : JoinUp;
  public var shipSpecs : Array;
  
  private var debouncer : Debouncer; // helps with accidental diagonal clicks
  
  private static const CURSOR_BASE : int = 3;
  private static const COLOR_BASE : int = 4;
  
  //---------------------------------------------------------------------------
  //           constructor()
  //---------------------------------------------------------------------------
  private function mymod (arg:Number, base:Number) : Number
    {
    return ( (arg + base) % base );
    }
  
  public function JoinUpControls( _joinup : JoinUp) : void
    {
    joinup = _joinup;
    debouncer = new Debouncer();
    } // function init
  
  //---------------------------------------------------------------------------
  //           expire()
  //---------------------------------------------------------------------------
  public function expire() : void
    {
    joinup = null;
    disconnect();
    }
    
  //---------------------------------------------------------------------------
  //      blah blah blah blah
  //---------------------------------------------------------------------------
  
  protected override function Xr(e:ControlEvent) : void { joinup.fakeTick(); }
  protected override function Br(e:ControlEvent) : void { joinup.fakeTick(); }
  protected override function Cr(e:ControlEvent) : void { joinup.fakeTick(); }
  protected override function Ar(e:ControlEvent) : void { joinup.fakeTick(); }
  
  protected override function Rp(e:ControlEvent):void { rightPress( e.playerIndex ); }
  protected override function Up(e:ControlEvent):void { upPress   ( e.playerIndex ); }
  protected override function Lp(e:ControlEvent):void { leftPress ( e.playerIndex ); }
  protected override function Dp(e:ControlEvent):void { downPress ( e.playerIndex ); }
  
  private function rightPress(ID:uint):void 
    {
    if(!debouncer.debounced())
      return;
    else
      debouncer.setLastEventTime();
    
    switch ( joinup.cursors[ID] )
      {
      case 0:   joinup.shipspecs[ID].teamCode = mymod (joinup.shipspecs[ID].teamCode+1, COLOR_BASE); break; 
      case 1:   joinup.shipspecs[ID].isCPUControlled = !joinup.shipspecs[ID].isCPUControlled; break;
    case 2:   joinup.IAmReady[ID] = !(joinup.IAmReady[ID]);
      } 
    Utility.playSound (Assets.joinupLeftRight); 
    joinup.invalidate();  
    }
  
  private function leftPress(ID:uint):void
    {
    if(!debouncer.debounced())
      return;
    else
      debouncer.setLastEventTime();
    
    switch ( joinup.cursors[ID] )
      {
      case 0: 	joinup.shipspecs[ID].teamCode = mymod (joinup.shipspecs[ID].teamCode-1, COLOR_BASE); break;	
      case 1: 	joinup.shipspecs[ID].isCPUControlled = !joinup.shipspecs[ID].isCPUControlled; break;
      case 2: 	joinup.IAmReady[ID] = !(joinup.IAmReady[ID]);
      }
    Utility.playSound (Assets.joinupLeftRight);   
    joinup.invalidate();
    }

  private function upPress(ID:uint):void
    {
    if(!debouncer.debounced())
      return;
    else
      debouncer.setLastEventTime();
    
    if (joinup.cursors[ID]==2 && joinup.IAmReady[ID]==true) 
      {}
    else
      {
      joinup.cursors[ID] = mymod (joinup.cursors[ID]-1, CURSOR_BASE);
      Utility.playSound (Assets.joinupUpDown);
      }
    }
  
  private function downPress(ID:uint):void
    {
    if(!debouncer.debounced())
      return;
    else
      debouncer.setLastEventTime();
		
    if (joinup.cursors[ID]==2 && joinup.IAmReady[ID]==true)
      {}
    else
      {
      joinup.cursors[ID] = mymod (joinup.cursors[ID]+1, CURSOR_BASE);
      Utility.playSound (Assets.joinupUpDown);
      }
    }
  
  } // class Controls

}