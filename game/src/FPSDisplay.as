package {

import Drawable;
import IDrawable;

import flash.display.BitmapData;
import flash.utils.*;
import flash.text.*;

public class FPSDisplay implements IDrawable
  {
  private var lastTimer : int;        // Used to measure elapsed time, compute FPS, and display it.
  private var thisTimer : int;       
  private var tf : TextField;	
  private var tformat : TextFormat;
  public var FPS : Number;
  private var displayMe : Boolean;
  
  
  public function FPSDisplay(_displayMe:Boolean = false)
    {
    displayMe = _displayMe;	
    thisTimer = getTimer();
    lastTimer = 0;
    FPS = 25;
    
    if (displayMe)  
      {  
      tf = new TextField();
      //Screen.hud.addChild(tf);
      tf.text = "Hi.";
      tf.x = 720;
      tf.y = 480;    
      tformat = new TextFormat();
      tformat.color = 0xFFFFFF;
      tformat.size = 32;
      tf.setTextFormat(tformat);
      Screen.queueDraw(this);
      }
    
    }
    
  // IDrawable implementation
  public function isVisible() : Boolean { return true; }
  public function getLayer() : uint { return Drawable.foreground; }
  public function draw( backbuffer : BitmapData ) : void
    {
    backbuffer.draw(tf,tf.transform.matrix,tf.transform.colorTransform,
                    null,null,false);
    }
  // End IDrawable implementation
  
  public function update() : void
    {
    lastTimer = thisTimer;
    thisTimer = getTimer();
    // (thisTimer - lastTimer) was the time elapsed during last frame update, in milleseconds.
    // Compute frames per second.
    FPS = 1000 / (thisTimer-lastTimer);
    if (displayMe)
      {
      tf.text = "" + Utility.oneDigit(FPS);        
      tf.setTextFormat(tformat);	
      }
    }
  
  public function expire () : void
    {
    if (displayMe)
      Screen.queueRemove(this);
      //Screen.hud.removeChild(tf);	
    }
  	
  }
  
} // end of package.
