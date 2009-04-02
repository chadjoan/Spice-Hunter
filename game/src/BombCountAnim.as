package {

import Assets;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.geom.ColorTransform;

public class BombCountAnim extends Animation
  {  
  private var teamCode : Number; 
  private var count : Number;
  
  public function BombCountAnim (RenderPlane : Sprite, _teamCode : Number, _count : Number)
    {    	          
    super(RenderPlane);
    duration = 12.5;  // 1 second duration - this variable measured in 1/25ths of a second.
    maxState = 10;    
    teamCode = _teamCode;
    count = _count;
    }
       
  public override function getFrame(whichstate:Number) : Bitmap
    {   
    var ans : Bitmap;    
    
    // Pickup the right count image.
    switch (count)
      {
      case 0: ans = new Assets.bombCount0; break;	
      case 1: ans = new Assets.bombCount1; break;	
      case 2: ans = new Assets.bombCount2; break;	
      case 3: ans = new Assets.bombCount3; break;	
      case 4: ans = new Assets.bombCount4; break;	
      case 5: ans = new Assets.bombCount5; break;	
      case 6: ans = new Assets.bombCount6; break;	
      case 7: ans = new Assets.bombCount7; break;	
      case 8: ans = new Assets.bombCount8; break;	
      case 9: ans = new Assets.bombCount9; break;	      
      }
        
    Utility.center(ans);
    // Apply a color transform
    ans.bitmapData.colorTransform(ans.bitmapData.rect, Screen.getColorTransform(teamCode) );
    // Apply an alpha jumpin / jumpout. Sweep from 0.4 to 1.0 to 0.4
    ans.alpha = 1.0 - 0.6 * Math.abs(whichstate-5)/5;
    
    // Sneaky, write the procedural art inside here too.
    /*
    Screen.hud.graphics.lineStyle (3,Screen.getColor(teamCode),1.0);
    var beta:Number = whichstate / 10;    
    Screen.hud.graphics.drawCircle( beta*xend + (1-beta)*xstart, beta*yend + (1-beta)*ystart, 2);    
    */
    return ans;
    }      
  }
} // end package