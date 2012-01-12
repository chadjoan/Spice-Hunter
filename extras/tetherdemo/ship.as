class Ship
  {		 
  public var r:Array;    // Position vector [x,y]
  public var v:Array;    // Velocity vector [x,y]
  public var m:Number;   // Mass 
  public var theta: Number; // Heading.	  
  public var display: MovieClip; // display widget.
  public var thrusting:Boolean;
  public var turning:Number;
  public var thrust:Number;
  public var backdrop:MovieClip;
  public var tether:Tether;
	
  public function Ship (inputbackdrop:MovieClip)
    {		
	backdrop = inputbackdrop;			
	// Initialize.	
	r = new Array;
	r[0] = 400;
	r[1] = 300;
	v = new Array;
    v[0] = 0;
	v[1] = 0;
	m = 10.0;
	thrust = 10;
	theta = Math.PI/2;
		
	thrusting = false;
	turning = 0;
		
		
	// Create and draw display widget.			
	display = backdrop.createEmptyMovieClip("",backdrop.nextid++);	
    display.beginFill(0xFF0000);
    display.lineStyle(2,0x330000, 100);
	var dl:Number = 20;
    display.moveTo(-dl, 0);
    display.lineTo(0, -2*dl);
    display.lineTo(dl, 0);
    display.endFill();		
    
    // Create a new TetherNode.
    tether = new Tether (this, 10, 4);
    
    // Add this object to trap key events.
	Key.addListener(this);	
	}
		
  // Create action handler. 
  public function onEnterFrame () : Void
    {   
    
    if (thrusting)
	  {
	  v[0] += Math.cos (theta) * thrust / m;
	  v[1] -= Math.sin (theta) * thrust / m;
	  }
        
	// Update position.	
	r[0] = r[0] + v[0];
	r[1] = r[1] + v[1];		
	
	// Damp velocity.
	v[0] *= 0.95;
	v[1] *= 0.95;		
	
	// Tie the display widget to the position/orientation of the ship.
	display._rotation = (Math.PI/2-theta) * 180.0 / Math.PI;
    display._x = r[0];
	display._y = r[1];	
	
   
		
	if (turning == -1)		  
	  theta += 0.2;				  
    if (turning == 1)
      theta -= 0.2;
       
    tether.onEnterFrame();
	}


  public function onKeyDown():Void 
    {
	// toggle key states for the arrow keys
	var kc:Number = Key.getCode();
	switch (kc) 
	  {
	  case (Key.UP) : thrusting = true; break;			
	  case (Key.LEFT) : turning = -1; break;
	  case (Key.RIGHT) : turning = 1; break;
	  case (Key.SPACE): 
        tether.setTarget (null);	   
        /*	  
 	    if (tether.target == null) 
	      tether.setTarget (_root.spice1); 
	    else  
	      tether.setTarget (null);	      
	    */  
	  break;
	  }
	}
		
  public function onKeyUp():Void 
    {
	// toggle key states for the arrow keys
	var kc:Number = Key.getCode();
	switch (kc) 
	  {
	  case (Key.UP) : thrusting = false; break;			
	  case (Key.LEFT) : turning = 0; break;
	  case (Key.RIGHT) : turning = 0; break;
	  }	
	}			
  }

