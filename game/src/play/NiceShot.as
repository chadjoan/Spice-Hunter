package play
{

import Assets;
import Drawable;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.ColorTransform;

// This better be drawn on the hud layer!
public class NiceShot extends Animation
  {  
  private var drawingPlane : Sprite = new Sprite();
  public static var image : Bitmap = new Assets.bonusNiceShot;
  public override function getLayer() : uint { return Drawable.hud; }
  
  private var teamCode : Number; 
  private var xstart : Number; 
  private var ystart : Number;
  private var xend : Number;
  private var yend : Number;
   
  public function NiceShot (_teamCode : Number, _xstart : Number, _ystart  : Number, _xend : Number, _yend : Number)
    {    	          
    super();
    cachebmp.bitmapData = image.bitmapData;
    duration = 25;  // 1 second duration - this variable measured in 1/25ths of a second.
    teamCode = _teamCode;
    
    xstart = _xstart;
    ystart = _ystart;
    xend = _xend;
    yend = _yend;
    
    // Apply a color transform
    cachebmp.transform.colorTransform = Screen.getColorTransform(teamCode);
    }
  
  public override function maxFrames() : uint
    {
    return 10;
    }
  
  public override function draw(backbuffer : BitmapData) : void
    {
    drawingPlane.graphics.clear();
    
    drawingPlane.graphics.lineStyle (3,Screen.getColor(teamCode),1.0);
    var beta:Number = frame / 10;    
    drawingPlane.graphics.drawCircle( beta*xend + (1-beta)*xstart, beta*yend + (1-beta)*ystart, 2);
    
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
    drawingPlane.graphics.moveTo (xstart, ystart);
    drawingPlane.graphics.lineTo (xstart + dx*excessPixels/2, ystart + dy*excessPixels/2);    
    drawingPlane.graphics.moveTo (xend, yend);
    drawingPlane.graphics.lineTo (xend - dx*excessPixels/2, yend-dy*excessPixels/2);
    
    // Draw periodic sections.
    for (var i : Number = 0; i < completePeriods; i++)
      {
      var xtemp : Number = xstart + dx*(excessPixels/2 + period / 4 + i*period);
      var ytemp : Number = ystart + dy*(excessPixels/2 + period / 4 + i*period);      	
      drawingPlane.graphics.moveTo (xtemp, ytemp);
      drawingPlane.graphics.lineTo (xtemp + dx*period/2, ytemp+dy*period/2);
      }
    
    backbuffer.draw(drawingPlane);
    
    super.draw(backbuffer);
    }
  
  public override function getFrame(frameNumber:uint) : Bitmap
    {
    Utility.center(cachebmp);
    // Apply an alpha jumpin / jumpout. Sweep from 0.4 to 1.0 to 0.4
    cachebmp.alpha = 1.0 - 0.6 * Math.abs(frameNumber-5)/5;
    
    return cachebmp;
    }      
  }
} // end package