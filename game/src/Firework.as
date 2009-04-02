

package {

import Assets;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.geom.ColorTransform;

public class Firework extends Animation
  {  
   
  public function Firework (RenderPlane : Sprite)
    {    	          
    super(RenderPlane);
    duration = 50;  // 1 second duration - this variable measured in 1/25ths of a second.
    maxState = 28;    
    }
       
  public override function getFrame(whichstate:Number) : Bitmap
    {   
    var ans : Bitmap;
     
    switch(whichstate)
      {
      case 0: ans = new Assets.firework1; break;
      case 1: ans = new Assets.firework2; break;
      case 2: ans =  new Assets.firework3; break;
      case 3: ans =  new Assets.firework4; break;
      case 4: ans =  new Assets.firework5; break;  
      case 5: ans =  new Assets.firework6; break;          
      case 6: ans =  new Assets.firework7; break;
      case 7: ans =  new Assets.firework8; break;
      case 8: ans =  new Assets.firework9; break;      
      case 9: ans = new Assets.firework10; break;            
      case 10: ans = new Assets.firework11; break;
      case 11: ans =  new Assets.firework12; break;
      case 12: ans =  new Assets.firework13; break;
      case 13: ans =  new Assets.firework14; break;
      case 14: ans =  new Assets.firework15; break;
      case 15: ans =  new Assets.firework16; break;
      case 16: ans =  new Assets.firework17; break;
      case 17: ans =  new Assets.firework18; break;
      case 18: ans =  new Assets.firework19; break;
      case 19: ans =  new Assets.firework20; break;      
      case 20: ans =  new Assets.firework21; break;
      case 21: ans =  new Assets.firework22; break;
      case 22: ans =  new Assets.firework23; break;
      case 23: ans =  new Assets.firework24; break;
      case 24: ans =  new Assets.firework25; break;
      case 25: ans =  new Assets.firework26; break;
      case 26: ans =  new Assets.firework27; break;
      case 27: ans =  new Assets.firework28; break;
      case 28: ans =  new Assets.firework29; break;            
      }              
    applyCludge(ans);
    return ans;          
    }
  
  public function applyCludge ( bmp : Bitmap) : void
    {
    var colorTransform : ColorTransform = new ColorTransform (3,1,1,3,0,0,0,0);
    bmp.bitmapData.colorTransform(bmp.bitmapData.rect,colorTransform);
    }
    
  }
} // end package