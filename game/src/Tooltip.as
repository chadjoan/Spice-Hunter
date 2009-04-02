

package {

import Assets;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class Tooltip
  {  
  public var rx : Number;
  public var ry : Number;
  public var text:String;
    
  // Finite state machine variables.
  public var state:Number;  
  public var renderedState : Number;
  public var counter : Number;
  public var duration : Number;  // How long does it take to write the whole message?
      
  public var avatar:Sprite;  
  public var isExpired:Boolean;
  public var isRendered:Boolean;  
    
  public function Tooltip (reticleLevel:Number)
    {    	      
    avatar = new Sprite;	
    Screen.hud.addChild(avatar);
    isExpired = false;
    isRendered = false;
    rx = 0;
    ry = 0;    
    
    state = 0;
    renderedState = 0;
    counter = 0;
    
    duration = 15 - 10*(reticleLevel/10);
    
    text = "";
    }
  
  public function draw() : void
    {    
    avatar.x = rx;
    avatar.y = ry; 
    if (avatar.x > 800-85)
      avatar.x = 800-85;
    if (avatar.y > 600-45)
      avatar.y = 600-45;  
    
    
    if (state == renderedState)
      return;
      
    if (isRendered)
      avatar.removeChildAt(0);
    
    
   	var format:TextFormat = new TextFormat();
	format.font = "number";
	format.color = 0xffffff;
	format.size = 16;			         
    var tf : TextField = new TextField();
    tf.embedFonts = true;    
    tf.width = 100;
    tf.text = text.slice (0,state);        
    tf.setTextFormat(format);
    
    renderedState = state;
        
    avatar.addChildAt(tf,0);          
    isRendered = true;
    }
 
  public function update(deltaT : Number) : void
    {  	
    counter += deltaT;    
    if (counter > duration)
      counter = duration;    
    state = Math.round (text.length * counter / duration);  
    draw();
    }
    
  public function expire() : void
    {    
    if (!isExpired)    
      {
      Screen.hud.removeChild(avatar);	
      isExpired = true;
      }
    }
  }
} // end package