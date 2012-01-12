class TetherNode
  {	
  public var r:Array;    // Position vector [x,y]
  public var v:Array;    // Velocity vector [x,y]    
  private var display: MovieClip; // display widget.  
  private var backdrop:MovieClip;
  
  public function TetherNode(inputbackdrop:MovieClip, x, y)
    {		
	backdrop = inputbackdrop;			
	// Initialize.	
	r = new Array;
	r[0] = x;
	r[1] = y;
	v = new Array;
    v[0] = 0;
	v[1] = 0;	

	// Create and draw display widget.				
	display = backdrop.createEmptyMovieClip("", backdrop.nextid++);
	display.lineStyle(2, 0x009900, 100);
	var radius:Number = 5;	
	var steps:Number = 20;			
    display.moveTo(radius,0);           
    for (var counter:Number = 1; counter <= steps; counter++) 
      {
      var angle:Number = (counter / steps) * 2.0 * Math.PI;
      display.lineTo( radius*Math.cos(angle), radius*Math.sin(angle) );      
      }              
	}  
  }