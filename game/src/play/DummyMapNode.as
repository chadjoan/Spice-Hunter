package play
{

import Assets;
import Utility;

import play.Body;

import flash.display.Bitmap;
import flash.display.Sprite;

public class DummyMapNode extends Body
  {
  public function DummyMapNode (_x : Number,_y : Number)
    {     
    // Initialize Particle members.
    super();
    rx = _x;
    ry = _y;
    vx = 0;
    vy = 0;
    mass = 1;
    
    // Initialize Body members.
    omega = 0;
    phi = 0;    
    collision_radius = 2;        
    moment = mass*collision_radius*collision_radius;      
    }
    
  
  
  
    
  }
  
} // end of package.