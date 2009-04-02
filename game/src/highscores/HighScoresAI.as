// An AI for entering high scores in the high scores entry screen.  
package highscores
{

import flash.utils.Timer;
import flash.events.TimerEvent;
import flash.events.Event;

import highscores.HighScoresMovementTimer;
import highscores.HighScoresPanel;

public class HighScoresAI extends Timer
  {
  public var expired : Boolean;
  
  private var name : String;
  private var playerID : uint;
  private var x : int;
  private var y : int;
  private var xPress : Function;
  private var yPress : Function;
  private var board : Array; // a reference to the letter pool
  private var panel : HighScoresPanel;
  
  public function get initials() : String { return panel.initials; }
  
  // He will start entering his name as soon as he is constructed.  
  public function HighScoresAI( _name:String, _playerID:uint, _x:int, _y:int, _board:Array, _panel:HighScoresPanel,
                                _xPress:Function, _yPress:Function )
    {
    name = _name;
    playerID = _playerID;
    x = _x;
    y = _y;
    board = _board;
    panel = _panel;
    xPress = _xPress;
    yPress = _yPress;
    
    panel.enterSelection("CLR");
    
    super(HighScoresMovementTimer.movementDelay);
    addEventListener(TimerEvent.TIMER, think);
    
    this.start();
    }
  
  // Takes a player id as an argument, which is a bit redundant.  
  public function think( e : Event ) : void
    {
    var i : int;
    var j : int;
    
    var targetChar : String;
    if ( initials.length < name.length+1 )
      {
      targetChar = name.charAt(initials.length-1);
      if ( targetChar == " " )
        targetChar = "SPC";
      }
    else // we're done here
      {
      if ( !expired )
        {
        panel.enterSelection("DONE");
        expired = true;
        }
      this.stop();
      return;
      }
    
    var searchComplete : Boolean = false;
    var targetX : int = 0;
    var targetY : int = 0;
    for ( i = 0; i < board.length; i++ )
      {
      var row : Array = board[i];
      for ( j = 0; j < row.length; j++ )
        {
        if ( row[j] == targetChar )
          {
          searchComplete = true;
          targetX = j;
          targetY = i;
          }
        }
      }
    
    var dx : int = x - targetX;
    var dy : int = y - targetY;
    
    if ( Math.abs(dx) > Math.abs(dy) )
      {
      if ( dx > 0 )
        x = xPress(-1,playerID);
      else if ( dx < 0 )
        x = xPress(1,playerID);
      else
        panel.enterSelection( targetChar );
      }
    else
      {
      if ( dy > 0 )
        y = yPress(-1,playerID);
      else if ( dy < 0 )
        y = yPress(1,playerID);
      else
        panel.enterSelection( targetChar );
      }
    } // function think()
  } // class HighScoresAI
} // package