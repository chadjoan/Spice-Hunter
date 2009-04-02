package {

import Assets;
import Utility;

import flash.display.Bitmap;
import flash.display.Sprite;

public class Asteroid extends Body
  {
  public function Asteroid ()
    { 
    // Initialize with random mass.
    setMass (Math.random()*10+10);    
    // Initialize Body members.
    omega = Math.random()*0.2 - 0.1;
    phi = Math.random()*2.0*Math.PI;
    
    draw();
    }
  
  public function setMass (m:Number) : void
    {
    // Take in new mass.
    mass = m;	
    // Compute new collision radius:    
    collision_radius = 25*Math.sqrt(mass/10);	
    // Compute new moment of inertia.
    moment = mass*collision_radius^2;
    tooltiptext = "Asteroid\nMass " + Utility.oneDigit(mass);
    }
  
  public override function draw () : void
    {
    super.draw();
    
    // Pick an asteroid.
    var bmp : Bitmap;    
    var bmpCode:Number = Math.round( Math.random() * 4 );
    switch (bmpCode % 4)
      {
      case 0: bmp = new Assets.Asteroid; break;	
      case 1: bmp = new  Assets.Asteroid6; break;
      case 2: bmp = new  Assets.Asteroid7; break;
      case 3: bmp = new  Assets.Asteroid8; break;
      }    
    // Compute scale so that this asteroid will be drawn with the right collision radius.
    bmp.scaleX = collision_radius / (bmp.width/2);
    bmp.scaleY = collision_radius / (bmp.height/2);
    Utility.center(bmp); 
    avatar.addChildAt(bmp,0);
    
    
    avatar.graphics.clear ();	    
    avatar.graphics.lineStyle(2, 0xFFFFFF, 1);   
    
    //avatar.graphics.drawCircle(0,0,collision_radius);
    
    }
  
  public function updatePosition(deltaT : Number) : void
    {
    // Update position.	
    rx += vx * deltaT;
    ry += vy * deltaT;
    phi += omega * deltaT;
    
    // Bounce off walls.
    super.bounceClip(); 
    
    // Damp velocity.    
    // Loose 1% of your velocity every second.
    var percentage:Number = 0.05;    
    vx = vx * (1 - percentage * deltaT / 25);
    vy = vy * (1 - percentage * deltaT / 25);
    
    avatar.x = rx;
    avatar.y = ry;
    avatar.rotation = phi*180/Math.PI;
    }
  

  // No bouncing off walls logic for this - for when the asteroid is outside the boundary.
  public function updatePositionOutside(deltaT : Number) : void
    {
    // Update position.	
    rx += vx * deltaT;
    ry += vy * deltaT;
    phi += omega * deltaT;
    
    // Bounce off walls.        
    avatar.x = rx;
    avatar.y = ry;
    avatar.rotation = phi*180/Math.PI;    	
    }


  }
  
} // end of package.