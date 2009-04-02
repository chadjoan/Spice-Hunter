package {

import Assets;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.geom.ColorTransform;

public class NiceShot extends Animation
  {  
  private var teamCode : Number; 
  private var xstart : Number; 
  private var ystart : Number;
  private var xend : Number;
  private var yend : Number;
   
  public function NiceShot (RenderPlane : Sprite, _teamCode : Number, _xstart : Number, _ystart  : Number, _xend : Number, _yend : Number)
    {    	          
    super(RenderPlane);
    duration = 25;  // 1 second duration - this variable measured in 1/25ths of a second.
    maxState = 10;    
    teamCode = _teamCode;
    
    xstart = _xstart;
    ystart = _ystart;
    xend = _xend;
    yend = _yend;
    }
       
  public override function getFrame(whichstate:Number) : Bitmap
    {   
    var ans : Bitmap;    
    ans = new Assets.bonusNiceShot;
    Utility.center(ans);
    // Apply a color transform
    ans.bitmapData.colorTransform(ans.bitmapData.rect, Screen.getColorTransform(teamCode) );
    // Apply an alpha jumpin / jumpout. Sweep from 0.4 to 1.0 to 0.4
    ans.alpha = 1.0 - 0.6 * Math.abs(whichstate-5)/5;
    
    // Sneaky, write the procedural art inside here too.
    Screen.hud.graphics.lineStyle (3,Screen.getColor(teamCode),1.0);
    var beta:Number = whichstate / 10;    
    Screen.hud.graphics.drawCircle( beta*xend + (1-beta)*xstart, beta*yend + (1-beta)*ystart, 2);
    
    // Draw a new dotted line thingy.    
    var dx : Number = (xend - xstart);
    var dy : Number = (yend - ystart);
    var dl : Number = Math.sqrt (dx*dx + dy*dy);
    // Normalize to a unit vector.
    dx /= dl;
    dy /= dl;
    
    // Compute how many full periods will fit into dl, and how many remainder pixels are left.   
    var period : Number = 50;
    var completePeriods : Number = Math.floor( dl / period );
    var excessPixels : Number = dl - completePeriods*period;
    
    // Draw the two tails of excessPixels/2
    Screen.hud.graphics.moveTo (xstart, ystart);
    Screen.hud.graphics.lineTo (xstart + dx*excessPixels/2, ystart + dy*excessPixels/2);    
    Screen.hud.graphics.moveTo (xend, yend);
    Screen.hud.graphics.lineTo (xend - dx*excessPixels/2, yend-dy*excessPixels/2);
    
    // Draw periodic sections.
    for (var i : Number = 0; i < completePeriods; i++)
      {
      var xtemp : Number = xstart + dx*(excessPixels/2 + period / 4 + i*period);
      var ytemp : Number = ystart + dy*(excessPixels/2 + period / 4 + i*period);      	
      Screen.hud.graphics.moveTo (xtemp, ytemp);
      Screen.hud.graphics.lineTo (xtemp + dx*period/2, ytemp+dy*period/2);
      }
    return ans;
    }      
  }
} // end package