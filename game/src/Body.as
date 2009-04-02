package {

import Assets;

import Particle;
import flash.display.Sprite;

public class Body extends Particle
  {
  public var phi:Number;
  public var omega:Number;
  public var moment:Number;
  
  public var avatar:Sprite;
  public var isExpired:Boolean;
  public var tooltiptext:String;
  
  public function Body ()
    {
    	
    phi = 0;
    omega = 0;
    moment = 0;
    collision_radius = 0;
    
    avatar = new Sprite;	
    Screen.foreground.addChild(avatar);
    isExpired = false;
    tooltiptext = "howdy";
    }
  
  public function draw() : void
    {
    var i : uint = 0;
    while ( avatar.numChildren > 0 )
      {
      avatar.removeChildAt(i);
      i++;
      }
    
    avatar.graphics.clear();
    }
  
  public function bounceClipDamped () : void
    {
    var damping:Number = 0.25;
    	
    // Bounce off walls.+5)
    if (rx < collision_radius)
      {
      rx = collision_radius;
      vx = damping*Math.abs(vx);
      //vy = damping*vy;
      }
    if (rx > 800-collision_radius)
      {
      rx = 800-collision_radius;        
      vx = -damping*Math.abs(vx);	
      //vy = damping*vy;
      }
    if (ry < collision_radius)
      {
      ry = collision_radius;
      vy = damping*Math.abs(vy);	
      //vx = damping*vx;
      }
    if (ry > 600-collision_radius)
      {
      ry = 600-collision_radius;	
      vy = -damping*Math.abs(vy);
      //vx = damping*vx;	
      }
    }
  
  public function bounceClip() : void
    {
    var damping:Number = 1;
    	
    // Bounce off walls.+5)
    if (rx < collision_radius)
      {
      rx = collision_radius;
      vx = damping*Math.abs(vx);
      //vy = damping*vy;
      }
    if (rx > 800-collision_radius)
      {
      rx = 800-collision_radius;        
      vx = -damping*Math.abs(vx);	
      //vy = damping*vy;
      }
    if (ry < collision_radius)
      {
      ry = collision_radius;
      vy = damping*Math.abs(vy);	
      //vx = damping*vx;
      }
    if (ry > 600-collision_radius)
      {
      ry = 600-collision_radius;	
      vy = -damping*Math.abs(vy);
      //vx = damping*vx;	
      }
    }
  
  public function expire() : void
    {
    Screen.foreground.removeChild(avatar);	
    isExpired = true;
    }
  
  }
  
} // end package