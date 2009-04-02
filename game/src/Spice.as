package {

import Assets;
import Utility;

import flash.display.Bitmap;
import flash.display.Sprite;

public class Spice extends Body
  {
  public var fingerprint : SpiceReleaseFingerprint;	
  	
  public function Spice ()
    {     
    // Initialize Particle members.
    rx = 600;
    ry = 100;
    vx = 0;
    vy = 0;
    setMass(Math.random()*1.0+1.0);
    
    // Initialize Body members.
    omega = Math.random()*0.2 - 0.1;
    phi = 0;    
    collision_radius = 10*Math.sqrt(mass/1);
        
    moment = mass*collision_radius*collision_radius;
    
    draw();
    }
  
  public function setMass (m:Number) : void
    {
    // Take in new mass.
    mass = m;	
    // Compute new collision radius:    
    collision_radius = 10*Math.sqrt(mass/1);	
    // Compute new moment of inertia.
    moment = mass*collision_radius^2;            
    tooltiptext = "Spice\nValue " + Utility.oneDigit(value());
    }
  
  
  
  public override function draw () : void
    {
    super.draw();
    var bmp : Bitmap = new Assets.SpaceSpice;
    bmp.scaleX = collision_radius / (bmp.width/2);
    bmp.scaleY = collision_radius / (bmp.height/2);
    Utility.center(bmp); 
    avatar.addChild(bmp);
   
    avatar.graphics.clear ();	    
    avatar.graphics.lineStyle(2, 0xFFFFFF, 1);   
    /*
    var steps:Number = 20;
    avatar.graphics.moveTo(collision_radius,0);
    for (var counter:Number = 1; counter <= steps; counter++)
      {
      var angle:Number = (counter / steps) * 2.0 * Math.PI;
      avatar.graphics.lineTo(collision_radius*Math.cos(angle), collision_radius*Math.sin(angle) );
      } 
    */  
    // avatar.graphics.drawCircle(0,0,collision_radius);
   
    }
  
  public function value () : Number
    {
    return Math.round(mass*50);
    }
  
  public function updatePosition(deltaT:Number) : void
    {
    // Update position.	
    rx += vx * deltaT;
    ry += vy * deltaT;
    phi += omega * deltaT;
    
    // Bounce off walls.
    super.bounceClipDamped(); 
        
    
    avatar.x = rx;
    avatar.y = ry;
    avatar.rotation = phi*180/Math.PI;
    }
  
  public function updatePositionOutside(deltaT : Number) : void
    {
    // Update position.	
    rx += vx * deltaT;
    ry += vy * deltaT;
    phi += omega * deltaT;
           
    avatar.x = rx;
    avatar.y = ry;
    avatar.rotation = phi*180/Math.PI;    	
    }
  
    
  }
  
} // end of package.