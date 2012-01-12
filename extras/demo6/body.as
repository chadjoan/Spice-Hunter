class Body extends Particle
  {
  public var phi:Number;
  public var omega:Number;
  public var moment:Number;
  public var collision_radius:Number;
  
  private var avatar:MovieClip;
  
  public function bounceClip ()
    {
    // Bounce off walls.
    if (rx < collision_radius)
      {
      rx = collision_radius;
      vx = Math.abs(vx);
      }
    if (rx > 800-collision_radius)
      {
      rx = 800-collision_radius;        
      vx = -Math.abs(vx);	
      }
    if (ry < collision_radius)
      {
      ry = collision_radius;
      vy = Math.abs(vy);	
      }
    if (ry > 600-collision_radius)
      {
      vy = -Math.abs(vy);	
      }
    }
  
  }