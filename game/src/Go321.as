

package {

import Assets;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.geom.ColorTransform;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class Go321
  {  
  private var avatar:Sprite;  
  private var framecounter:Number;  
  private var state:Number;  
  
  private static var BLANK:Number;  
  private static var THREE:Number;
  private static var TWO:Number;
  private static var ONE:Number;
  private static var GO:Number;
  private static var DONE:Number;
  private static var FRAMEMAX:Number;
  
  private var bmp:Bitmap;
    
  private var levelTitle : String;
  
  
  public function Go321 (_levelTitle : String)
    
    {          
    levelTitle = _levelTitle;
    
    avatar = new Sprite;	
    Screen.hud.addChild(avatar);
    
    BLANK = 0;
    THREE = 1;
    TWO = 2;
    ONE = 3;
    GO = 4;
    DONE = 5;
    FRAMEMAX = 20;   // Decrease FRAMEMAX to make the 3-2-1-GO! sequence take less time to complete.
          
    state = BLANK;
    framecounter = FRAMEMAX;    
    
    bmp = new Assets.blank;    
    avatar.addChild(bmp);
    }
  
 
  public function draw() : void
    {      
    // Center the avatar in the Screen.
    avatar.x = 400;
    avatar.y = 300;
    
    if (state != DONE)
      {       
      // Remove the old bitmap.
      avatar.removeChild(bmp);
      // Switch on state to figure out what graphic to display.
      switch (state)
        {
        case BLANK: bmp = new Assets.blank; break;	
        case THREE: bmp = new Assets.score3; break;
        case TWO: bmp = new Assets.score2; break;
        case ONE: bmp = new Assets.score1; break;
        case GO: bmp = new Assets.go; break;      
        }
      // Framecounter starts at FRAMEMAX and counts DOWN to zero.  
      // Use framecounter to establish an alpha (transparency) value.              
      bmp.alpha = 0.4 + 0.6 * (framecounter / FRAMEMAX); 
      // Use framecounter to establish and x/y scale.
      bmp.scaleX = 9 - 4 * (framecounter / FRAMEMAX);
      bmp.scaleY = 9 - 4 * (framecounter / FRAMEMAX);
      Utility.center(bmp);                   
      avatar.addChild(bmp);
      
      // Add a text blurb about what "galaxy" you're in.
      
      
      var format:TextFormat = new TextFormat();
	  format.font = "title";
	  var tmp:int = Math.round(0xFF*bmp.alpha);
	  
	  format.color = tmp*256*256 + tmp*256 + tmp;
	  format.size = 32;			         
	  format.align = "center";
	  
      var tf : TextField = new TextField();
      tf.embedFonts = true;    
      tf.width = 800;      
      tf.text = "Entering:\n"+levelTitle;
      tf.x = -400;
      tf.y = 215;      
      tf.setTextFormat(format);
      
      
      avatar.addChild (tf);
      }
    
    }
 
  public function update(deltaT:Number) : void
    {  	  
    framecounter-= deltaT;
    if (framecounter < 0)
      {
      framecounter=FRAMEMAX;
      state++;
      // Play a sound.
      switch (state)
        {
        case THREE: Utility.playSound (new Assets.count3); break;
        case TWO: Utility.playSound (new Assets.count2); break;
        case ONE: Utility.playSound (new Assets.count1); break;
        case GO: Utility.playSound (new Assets.countgo); break;
        }
      }
    draw ();  
    }
  
  public function isDone() : Boolean
    {
    return (state == DONE );	
    }
    
  public function expire() : void
    {
    Screen.hud.removeChild(avatar);	        
    }
  }
} // end package