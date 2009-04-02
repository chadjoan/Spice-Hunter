package {

import Assets;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.geom.ColorTransform;

public class OhSnapAnim extends Animation
  {  
  private var teamCode : Number; 
  
  public function OhSnapAnim (RenderPlane : Sprite, _teamCode : Number)
    {    	          
    super(RenderPlane);
    duration = 25;  // 1 second duration - this variable measured in 1/25ths of a second.
    maxState = 10;    
    teamCode = _teamCode;  
    }
       
  public override function getFrame(whichstate:Number) : Bitmap
    {   
    var ans : Bitmap;    
    ans = new Assets.bonusOhSnap;
    Utility.center(ans);
    // Apply a color transform
    ans.bitmapData.colorTransform(ans.bitmapData.rect, Screen.getColorTransform(teamCode) );
    // Apply an alpha jumpin / jumpout. Sweep from 0.4 to 1.0 to 0.4
    ans.alpha = 1.0 - 0.6 * Math.abs(whichstate-5)/5;    
    return ans;
    }      
  }
} // end package