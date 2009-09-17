package play
{

import Assets;
import Drawable;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.ColorTransform;

public class BombCountAnim extends Animation
  {  
  public override function getLayer() : uint { return Drawable.hud; }
  
  private var teamCode : Number; 
  private var count : Number;
  
  public static var initialized : Boolean = false;
  public static var bcFrames : Array;
  public static function init() : void
    {
    bcFrames = new Array(10);
    bcFrames[0] = new Assets.bombCount0;
    bcFrames[1] = new Assets.bombCount1;
    bcFrames[2] = new Assets.bombCount2;
    bcFrames[3] = new Assets.bombCount3;
    bcFrames[4] = new Assets.bombCount4;
    bcFrames[5] = new Assets.bombCount5;
    bcFrames[6] = new Assets.bombCount6;
    bcFrames[7] = new Assets.bombCount7;
    bcFrames[8] = new Assets.bombCount8;
    bcFrames[9] = new Assets.bombCount9;
    initialized = true;
    }
  
  public function BombCountAnim (_teamCode : Number, _count : Number)
    {
    if ( !initialized )
      init();
    
    super();
    frames = bcFrames;
    duration = 12.5;  // 1 second duration - this variable measured in 1/25ths of a second.  
    teamCode = _teamCode;
    count = _count;
    
    // Apply a color transform
    cachebmp.transform.colorTransform = Screen.getColorTransform(teamCode);
    }
  
  public override function maxFrames() : uint
    {
    return 10;
    }
  
  public override function getFrame(frameNumber:uint) : Bitmap
    {
    cachebmp.bitmapData = frames[count].bitmapData;
    
    Utility.center(cachebmp);
    // Apply an alpha jumpin / jumpout. Sweep from 0.4 to 1.0 to 0.4
    cachebmp.alpha = 1.0 - 0.6 * Math.abs(frameNumber-5)/5;
    return cachebmp;
    }
  }
} // end package