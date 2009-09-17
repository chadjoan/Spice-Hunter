package play
{

import Assets;
import flash.display.Sprite;
import flash.display.Bitmap;

public class Explosion extends Animation
  {  
  public static var explFrames : Array;
  public static var initialized : Boolean = false;
  
  public static function init() : void
    {
    explFrames = new Array(10);
    explFrames[0] = new Assets.explode01;
    explFrames[1] = new Assets.explode02;
    explFrames[2] = new Assets.explode03;
    explFrames[3] = new Assets.explode04;
    explFrames[4] = new Assets.explode05;
    explFrames[5] = new Assets.explode06;
    explFrames[6] = new Assets.explode07;
    explFrames[7] = new Assets.explode08;
    explFrames[8] = new Assets.explode09;
    explFrames[9] = new Assets.explode10;
    initialized = true;
    }
  
  public function Explosion ()
    {
    if ( !initialized )
      init();
    super ();
    frames = explFrames;
    duration = 25;  // 1 second duration - this variable measured in 1/25ths of a second.
    }
  }
} // end package