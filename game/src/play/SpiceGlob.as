package play
{

import Assets;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;

public class SpiceGlob extends Animation
  {
  public static var globFrames : Array;
  public static var initialized : Boolean = false;

  public static function init() : void
    {
    globFrames = new Array(10);
    globFrames[0] = new Assets.SpaceSpiceCollision1;
    globFrames[1] = new Assets.SpaceSpiceCollision2;
    globFrames[2] = new Assets.SpaceSpiceCollision3;
    globFrames[3] = new Assets.SpaceSpiceCollision4;
    globFrames[4] = new Assets.SpaceSpiceCollision5;
    globFrames[5] = new Assets.SpaceSpiceCollision6;
    globFrames[6] = new Assets.SpaceSpiceCollision7;
    globFrames[7] = new Assets.SpaceSpiceCollision8;
    globFrames[8] = new Assets.SpaceSpiceCollision9;
    globFrames[9] = new Assets.SpaceSpiceCollision10;
    initialized = true;
    }

  public function SpiceGlob ()
    {
    if ( !initialized )
      init();

    super();
    frames = globFrames;
    duration = 10;  // 1 second duration - this variable measured in 1/25ths of a second.
    }
  }
} // end package