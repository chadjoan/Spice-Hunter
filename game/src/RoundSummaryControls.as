package
{

import legacy.ControlEvent;
import legacy.PlayerControlListener;

public class RoundSummaryControls extends PlayerControlListener
  {
    
  public var roundSummary : RoundSummary;
  
  public function RoundSummaryControls (_roundSummary : RoundSummary) : void
    {
    roundSummary = _roundSummary;
    } // function init
  
  public function expire() : void
    {
    disconnect();
    }
  
  protected override function Xp(e:ControlEvent):void { roundSummary.skipOut(); }
  protected override function Ap(e:ControlEvent):void { roundSummary.skipOut(); }
  protected override function Bp(e:ControlEvent):void { roundSummary.skipOut(); }
  protected override function Cp(e:ControlEvent):void { roundSummary.skipOut(); }
  
  }

}