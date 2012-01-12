class Ship extends Body
  {
  public var reticle:Reticle;
  public var gravityTarget:Body;
  public var repelTarget:Body;
  	
  public function Ship ()
    { 
    // Initialize Particle members.
    rx = 400;
    ry = 300;
    vx = 0;
    vy = 0;
    mass = 1;
    
    // Initialize Body members.
    omega = 0;
    phi = 0;
    moment = 5;
    avatar = _root.createEmptyMovieClip (""+_root.getNextHighestDepth(),_root.getNextHighestDepth() );
    collision_radius = 20;
    
    // Sketch something shippy.
    draw ();
    
    reticle = new Reticle(); 
    }
  
  public function draw ()
    {
    avatar.clear ();	
    // Ship - draw a triangle thats reddish.
    avatar.lineStyle(2, 0x000000, 100);
    // Red   255=0xFF 
    // Green  75=0x4B
    // Blue   55=0x37    
    avatar.beginFill(0xFF4B37); 
    var steps:Number = 3;
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
  
  public function updateVelocity()
    {
    }
  
  public function updatePosition() 
    {
    // Update position.	
    rx += vx;
    ry += vy;
       
    // Bounce off walls.
    super.bounceClip(); 
    
    avatar._x = rx;
    avatar._y = ry;	
    reticle.updatePosition();
    
    // Reorient the ship so that it points at the reticle.
    var angle:Number = Math.atan2 (reticle.ry - ry, reticle.rx-rx);
    avatar._rotation = angle*180.0/Math.PI;
    }
  
  public function expire ()
    {
    avatar.removeMovieClip();
    }
  }