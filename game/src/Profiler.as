package{

import flash.display.Sprite;
import flash.text.TextField;

public class Profiler extends Sprite
  {
  private static const doProfiling : Boolean = true; // toggles profiling on/off
  private static const updateRate : Number = 1000; // milliseconds between updates
  
  public var measureName : String;
  
  private var output : TextField;
  private var startTime : Number;
  private var lastOutputTime : Number; // when the average timed out and was dumped to the screen
  
  private var sum : Number; // sum of time that has elapsed since the last average was taken
  private var numFrames : int; // number of frames elapsed since the last average was taken
  
  // accepts, as an argument, the human-readable name for what you are measuring.  
  public function Profiler( _name : String )
    {
    if ( doProfiling )
      {
      var date : Date = new Date();
      startTime = date.getTime();
      lastOutputTime = date.getTime();
      measureName = _name;
      sum = 0;
      numFrames = 0;
      
      output = new TextField();
      output.textColor = 0xffffff;
      addChild( output );
      }
    }
  
  public function startBench() : void
    {
    if ( doProfiling )
      {
      var date : Date = new Date();
      startTime = date.getTime();
      }
    }
  
  public function endBench() : void
    {
    if ( doProfiling )
      {
      var date : Date = new Date();
      var currentTime : Number = date.getTime();
      
      var timeDelta : Number = currentTime - startTime;
      
      sum += timeDelta;
      numFrames++;
      
      startTime = currentTime; // just in case.
      
      if ( updateRate < currentTime - lastOutputTime )
        {
        var average : Number = sum / numFrames;
        output.text = measureName+average;
        
        sum = 0;
        numFrames = 0;
        
        lastOutputTime = currentTime;
        } // if ( ... )
      } // if ( doProfiling )
    } // endBench()
  
  }

}