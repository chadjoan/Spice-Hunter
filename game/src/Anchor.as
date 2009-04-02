package {

import Assets;
import Utility;

import flash.display.Bitmap;
import flash.display.Sprite;

public class Anchor extends Body
  {
  public function Anchor ()
    { 
    // Initialize with random mass.
    mass = 50;
    // Initialize Body members.
    omega = 0;
    phi = 0;
    collision_radius = 10;
    vx = 0;
    vy = 0;
    
    tooltiptext = "Anchor";
    
    draw();
    }
   
  public override function draw () : void
    {
    super.draw();
    var bmp : Bitmap = new Assets.anchor;    
    bmp.scaleX = collision_radius / (bmp.width/2);
    bmp.scaleY = collision_radius / (bmp.height/2);
    Utility.center(bmp); 
    avatar.addChildAt(bmp,0);
    
    
    avatar.graphics.clear ();	    
    avatar.graphics.lineStyle(2, 0xFFFFFF, 1);
    
    //avatar.graphics.drawCircle(0,0,collision_radius);    
    }
    
  public function updatePosition() : void
    {   
    avatar.x = rx;
    avatar.y = ry;    
    }    
    
  }
  
} // end of package.