class Reticle
  {
  // Public interface.
  public var rx:Number;
  public var ry:Number;    
  
  // Private implementation.
  private var avatar:MovieClip;
  private var vx:Number;
  private var vy:Number;
  private var lr_state;  // Left/right joystick state.
  private var ud_state;  // Up/down joystick state;
  
  // Functions.
  public function Reticle()
    {
    rx = 400;
    ry = 300;
    vx = 0;
    vy = 0;
    ud_state = 0;
    lr_state = 0;	    
    avatar = _root.createEmptyMovieClip (""+_root.getNextHighestDepth(),_root.getNextHighestDepth() );
    draw();          
    }
  
  public function draw ()
    {
    avatar.clear ();	
    // Reticle - draws an empty circle.
    avatar.lineStyle(2, 0x009900, 100);
    var radius:Number = 5;	
	var steps:Number = 20;			
    avatar.moveTo(radius,0);           
    for (var counter:Number = 1; counter <= steps; counter++) 
      {
      var angle:Number = (counter / steps) * 2.0 * Math.PI;
      avatar.lineTo( radius*Math.cos(angle), radius*Math.sin(angle) );      
      }       
    }
  
  public function expire() : Void
    {
    avatar.removeMovieClip();
    }
    
  public function stickLeftRight (state:Number)
    {
    lr_state = state;	
    // Quick stop upon release.
    if (lr_state == 0)
      vx = 0;
    }
    
  public function stickUpDown(state:Number)
    {
    ud_state = state;	
    // Quick stop upon release.
    if (ud_state == 0)
      vy = 0;
    }
    
  public function updatePosition()
    {    
    // Update velocity.
    var scale:Number = 3;    
    vx += lr_state*scale;
    vy += ud_state*scale;
    
    // Clamp velocity x.
    var max:Number = 20;    
    if (vx > max)
      vx = max;
    if (vx < -max)
      vx = -max;
    // Clamp velocity y.      
    if (vy > max)
      vy = max;
    if (vy < -max)
      vy = -max;
    
    // Update position.	
    rx += vx;
    ry += vy;	
    
    // Tie avatar position to (rx,ry).
    avatar._x = rx;
    avatar._y = ry;
    }
  
  
  }
