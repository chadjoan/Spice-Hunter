class HomeBase extends Body
  {
  public var score:Number;
  	
  public function HomeBase ()
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
    moment = 1;
    avatar = _root.createEmptyMovieClip (""+_root.getNextHighestDepth(),_root.getNextHighestDepth() );
    collision_radius = 75;
    
    // Sketch something "Base"ic.
    draw ();
    
    // Initialize HomeBase members.
    score = 0;
    }
  
  public function draw ()
    {
    avatar.clear ();	
    // Homebase - draws an filled green circle.
    avatar.lineStyle(2, 0x000000, 100);
    // Red    62=0x3E 
    // Green 247=0xF7
    // Blue  103=0x67    
    avatar.beginFill(0x3EF767); 
    var steps:Number = 20;
    avatar.moveTo(collision_radius,0);
    for (var counter:Number = 1; counter <= steps; counter++)
      {
      var angle:Number = (counter / steps) * 2.0 * Math.PI;
      avatar.lineTo(collision_radius*Math.cos(angle), collision_radius*Math.sin(angle) );
      }    	    
    avatar.endFill();    
    }
  
  public function updatePosition() 
    {
    avatar._x = rx;
    avatar._y = ry;	
    }
  
  public function expire ()
    {
    avatar.removeMovieClip();
    }
  }