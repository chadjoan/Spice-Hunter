class Spice
  {		 
  public var r:Array;    // Position vector [x,y]
  public var v:Array;    // Velocity vector [x,y]
  public var m:Number;   // Mass   
  public var display: MovieClip; // display widget.  
  public var backdrop:MovieClip;    

  private var bounceSound:Sound; //Pickup sound.

  public function Spice (inputbackdrop:MovieClip)
    {		
	backdrop = inputbackdrop;			
	// Initialize.	
	r = new Array;
	r[0] = 700;
	r[1] = 500;
	v = new Array;
    v[0] = 0;
	v[1] = 0;
	m = 2.0;			
		
	// Create and draw display widget.			
	display = backdrop.createEmptyMovieClip("",backdrop.nextid++);	
    display.beginFill(0xFF00FF);
    display.lineStyle(2,0x330000, 100);
	var dl:Number = 20;
    display.moveTo(-dl, -dl);
    display.lineTo(-dl, dl);
    display.lineTo(dl, dl);
    display.lineTo(dl, -dl);
    display.endFill();		    
    
    bounceSound = new Sound();
    bounceSound.loadSound("bounce.mp3",false);
	}
		
  // Create action handler. 
  public function onEnterFrame () : Void
    {
	// Update position.	
	r[0] = r[0] + v[0];
	r[1] = r[1] + v[1];	
	
	if (r[0] < 0)
	  {
	  r[0] = 0;
	  v[0] = -v[0];	
	  bounceSound.start(0.2,1);
	  }
	if (r[0] > 800)
	  {
	  r[0] = 800;
	  v[0] = -v[0];
	  bounceSound.start(0.2,1);
	  }
	if (r[1] < 0)
	  {
	  r[1] = 0;
	  v[1] = -v[1];	
	  bounceSound.start(0.2,1);
	  }
	if (r[1] > 600)
	  {
	  r[1] = 600;
	  v[1] = -v[1];	
	  bounceSound.start(0.2,1);
	  }
	// Damp velocity.
	v[0] *= 0.99;
	v[1] *= 0.99;		

    display._x = r[0];
	display._y = r[1];	
	}

  }

