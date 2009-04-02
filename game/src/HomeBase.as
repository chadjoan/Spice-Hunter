package {

import Assets;
import Utility;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.geom.*;

public class HomeBase extends Body
  {
  public var score:Number;
  public var spec : ShipSpec;
  	
  public function HomeBase (_spec:ShipSpec)
    {
    spec = _spec; 	
    	
    mass = 1;    
    // Initialize Body members.
    omega = 0;
    phi = 0;
    moment = 1;
    collision_radius = 65;    
    // Sketch something "Base"ic.
    draw ();
    
    // Initialize HomeBase members.
    score = 0;
    addScore(0);
    }
  
  public override function draw () : void
    {
    var bmp : Bitmap = new Assets.Base;    
       
    // figure out what color we want
    var colorXForm : ColorTransform = Screen.getColorTransform(spec.teamCode);   
    bmp.bitmapData.colorTransform(bmp.getRect(bmp),colorXForm);
    
    bmp.scaleX = collision_radius / (bmp.width/2);
    bmp.scaleY = collision_radius / (bmp.height/2);
    Utility.center(bmp); 
    
    
    avatar.addChild(bmp);
    
    avatar.graphics.clear ();	        
    avatar.graphics.lineStyle(2, 0xFFFFFF, 1);  
    
    //avatar.graphics.drawCircle(0,0,collision_radius);     
    }
  
  public function updatePosition() : void 
    {
    avatar.x = rx;
    avatar.y = ry;	
    
    avatar.rotation = phi * 180 / Math.PI;
    }
  
  public function addScore(s:Number) : void
    {
    score += s;
    switch(spec.teamCode)
      {
      case ShipSpec.BLUE_TEAM:   tooltiptext = "Blue Base\nScore "+Utility.oneDigit(score); break;
      case ShipSpec.RED_TEAM:    tooltiptext = "Red Base\nScore "+Utility.oneDigit(score); break;
      case ShipSpec.YELLOW_TEAM: tooltiptext = "Yellow Base\nScore "+Utility.oneDigit(score); break;
      case ShipSpec.GREEN_TEAM:  tooltiptext = "Green Base\nScore "+Utility.oneDigit(score); break;
      }
    }



  }
  
} // end package.