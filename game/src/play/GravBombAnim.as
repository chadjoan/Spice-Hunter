package play
{

import Assets;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.geom.ColorTransform;

public class GravBombAnim extends Animation
  {  
  public static var explFrames : Array;
  public static var initialized : Boolean = false;
  public static var colorKludge : ColorTransform;
    
  public static function init() : void
    {
    colorKludge = new ColorTransform (0,1,0,3,0,0,0,0);
    explFrames = new Array(29);
    explFrames[0] = new Assets.firework29;
    explFrames[1] = new Assets.firework28;
    explFrames[2] = new Assets.firework27;
    explFrames[3] = new Assets.firework26;
    explFrames[4] = new Assets.firework25;  
    explFrames[5] = new Assets.firework24;          
    explFrames[6] = new Assets.firework23;
    explFrames[7] = new Assets.firework22;
    explFrames[8] = new Assets.firework21;      
    explFrames[9] = new Assets.firework20;            
    explFrames[10] = new Assets.firework19;
    explFrames[11] = new Assets.firework18;
    explFrames[12] = new Assets.firework17;
    explFrames[13] = new Assets.firework16;
    explFrames[14] = new Assets.firework15;
    explFrames[15] = new Assets.firework14;
    explFrames[16] = new Assets.firework13;
    explFrames[17] = new Assets.firework12;
    explFrames[18] = new Assets.firework11;
    explFrames[19] = new Assets.firework10;      
    explFrames[20] = new Assets.firework9;
    explFrames[21] = new Assets.firework8;
    explFrames[22] = new Assets.firework7;
    explFrames[23] = new Assets.firework6;
    explFrames[24] = new Assets.firework5;
    explFrames[25] = new Assets.firework4;
    explFrames[26] = new Assets.firework3;
    explFrames[27] = new Assets.firework2;
    explFrames[28] = new Assets.firework1;
    
    initialized = true;
    }
   
  public function GravBombAnim ()
    {    	          
    if ( !initialized )
      init();
    
    super();
    frames = explFrames;
    cachebmp.transform.colorTransform = colorKludge;
    duration = 10;  // 1 second duration - this variable measured in 1/25ths of a second.
    }
  }
} // end package