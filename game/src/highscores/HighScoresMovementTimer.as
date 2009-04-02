package highscores
{

import flash.utils.Timer;
import flash.events.*;

public class HighScoresMovementTimer extends Timer
  {
  
  public static const movementDelay : Number = 250; // 500 milliseconds between movements
  
  public var player : uint;
  public var callback : Function;
  
  public function HighScoresMovementTimer()
    {
    super(movementDelay);
    addEventListener(TimerEvent.TIMER, onTick);
    }
  
  private function onTick(event:Event) : void
    {
    callback( player );
    }
  
  } // class HighScoresMovementTimer

}