

package {

import Assets;
import flash.display.Sprite;
import flash.display.Bitmap;

public class Explosion extends Animation
  {  
   
  public function Explosion (RenderPlane : Sprite)
    {    	  
    super (RenderPlane);        
    duration = 25;  // 1 second duration - this variable measured in 1/25ths of a second.
    maxState = 9;    
    }
       
  public override function getFrame(whichstate:Number) : Bitmap
    {
    switch(whichstate)
      {
      case 0: return new Assets.explode01; break;
      case 1: return new Assets.explode02; break;
      case 2: return new Assets.explode03; break;
      case 3: return new Assets.explode04; break;
      case 4: return new Assets.explode05; break;  
      case 5: return new Assets.explode06; break;          
      case 6: return new Assets.explode07; break;
      case 7: return new Assets.explode08; break;
      case 8: return new Assets.explode09; break;
      case 9: return new Assets.explode10; break;      
      }    
    
    return null;
    }
  }
} // end package