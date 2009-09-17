package play
{

public class Particle
  {
  public var rx:Number;
  public var ry:Number;
  
  public var vx:Number;
  public var vy:Number;	
  
  public var mass:Number;	
  public var collision_radius:Number;
  
  public function Particle ()
    {
    rx = 0;
    ry = 0;
    vx = 0;
    vy = 0;
    mass = 1;
    collision_radius = 1;	
    }
  
  }
  
} // end of package