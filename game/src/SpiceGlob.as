

package {

import Assets;
import flash.display.Sprite;
import flash.display.Bitmap;

public class SpiceGlob extends Animation
  {  
   
  public function SpiceGlob (RenderPlane : Sprite)
    {    	       
    super(RenderPlane);   
    duration = 10;  // 1 second duration - this variable measured in 1/25ths of a second.
    maxState = 9;    
    }
       
  public override function getFrame(whichstate:Number) : Bitmap
    {
    switch(state)
      {
      case 0: return new Assets.SpaceSpiceCollision1; break;
      case 1: return new Assets.SpaceSpiceCollision2; break;
      case 2: return new Assets.SpaceSpiceCollision3; break;
      case 3: return new Assets.SpaceSpiceCollision4; break;
      case 4: return new Assets.SpaceSpiceCollision5; break;  
      case 5: return new Assets.SpaceSpiceCollision6; break;          
      case 6: return new Assets.SpaceSpiceCollision7; break;
      case 7: return new Assets.SpaceSpiceCollision8; break;
      case 8: return new Assets.SpaceSpiceCollision9; break;
      case 9: return new Assets.SpaceSpiceCollision10; break;      
      }    
    
    return null;
    }
  }
} // end package