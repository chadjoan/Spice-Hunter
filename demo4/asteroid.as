class Asteroid extends Body
  {
  public function Asteroid ()
    { 
    // Initialize Particle members.
    rx = 400;
    ry = 300;
    vx = -1;
    vy = 1;
    mass = 10;
    
    // Initialize Body members.
    omega = 0.1;
    phi = 0;
    moment = 1;
    avatar = _root.createEmptyMovieClip (""+_root.getNextHighestDepth(),_root.getNextHighestDepth() );
    collision_radius = 50;
    
    // Sketch an asteroid.
    draw ();
    }
  
  public function draw ()
    {
    avatar.clear ();	
    // Asteriod - draws an filled brown circle.
    avatar.lineStyle(2, 0x000000, 100);
    // Red   200=0xC8 
    // Green 100=0x64
    // Blue    0=0x0    
    avatar.beginFill(0xC86400);
    var steps:Number = 20;
    avatar.moveTo(collision_radius,0);
    for (var counter:Number = 1; counter <= steps; counter++)
      {
      var angle:Number = (counter / steps) * 2.0 * Math.PI;
      avatar.lineTo(collision_radius*Math.cos(angle), collision_radius*Math.sin(angle) );
      }    	    
    avatar.endFill();	    	
    avatar.moveTo(0,0);
    avatar.lineTo(collision_radius,0);
    }
  
  public function updatePosition()
    {
    // Update position.	
    rx += vx;
    ry += vy;
    phi += omega;
    
    // Bounce off walls.
    super.bounceClip(); 
    
    avatar._x = rx;
    avatar._y = ry;
    avatar._rotation = phi*180/Math.PI;
    }
  
  public function expire ()
    {
    avatar.removeMovieClip();
    }
  }