
class Tether
  {	
  public var nodes:Array; // Tethernode Objects.
  public var N:Number;    // Number of tethernodes.
  public var DesiredLength:Number;   // Rest length between nodes.    
  public var owner:Ship;
  public var target:Spice;
  
  private var k:Number;  // Spring constant.
  private var m:Number;  // Mass, per node.
  private var cooldown:Number; // Delay parameter for changing targets.
  
  // Sound effects.
  private var pickupSound:Sound;  
  private var releaseSound:Sound;  
  
  public function Tether(inputOwner:Ship, inputN:Number, inputDL:Number)
    {	
    owner = inputOwner;
    target = null;
    N = inputN;    
    DesiredLength = inputDL;	
 
    nodes = new Array;
    for (var n:Number = 0; n < N; n++)
      nodes[n] = new TetherNode (owner.backdrop, 400,300+n*DesiredLength);
      
    k = 0.125;  
    m = 0.25;
    cooldown = 0;
    
    pickupSound = new Sound();
    pickupSound.loadSound("pickup.mp3",false);
    
    releaseSound = new Sound();
    releaseSound.loadSound("release.mp3",false);
    
	}  	

  public function setTarget (newtarget) :Void
    {
    if (cooldown != 0)
      return;	
    target = newtarget;	
    if (newtarget != null)
      {
      pickupSound.start(0,1);	
      /*
      // Linearly interpolate node positions.
      nodes[N-1].r[0] = target.r[0];
      nodes[N-1].r[1] = target.r[1];
      for (var n:Number = 1; n < N-1; n++)
        {
        nodes[n].r[0] =  n/(N-1)*nodes[N-1].r[0]  + (1-n/(N-1))*nodes[0].r[0];
        nodes[n].r[1] =  n/(N-1)*nodes[N-1].r[1]  + (1-n/(N-1))*nodes[0].r[1];               
        }
      */  
      }
    else      
      releaseSound.start(0,1);		           
    cooldown = 10; 
    }

  public function onEnterFrame () : Void
    {               
    if (cooldown > 0)
      cooldown--;
    // Place tether on ship.
    nodes[0].r[0] = owner.r[0];
    nodes[0].r[1] = owner.r[1];
    
    // Place tether on target if applicable.    
    if (target != null)
      {
      nodes[N-1].r[0] = target.r[0];
      nodes[N-1].r[1] = target.r[1];
      }    
        
    for (var n:Number = 0; n < N-1; n++)
      {
      var CurrentLength = Math.sqrt ( (nodes[n+1].r[0] - nodes[n].r[0])*(nodes[n+1].r[0] - nodes[n].r[0]) + (nodes[n+1].r[1] - nodes[n].r[1])*(nodes[n+1].r[1] - nodes[n].r[1]) );      
      var scale:Number = CurrentLength - DesiredLength;
      
      if (n > 0)
        {
        nodes[n].v[0] += scale * (nodes[n+1].r[0] - nodes[n].r[0]) / CurrentLength * k / m;
        nodes[n].v[1] += scale * (nodes[n+1].r[1] - nodes[n].r[1]) / CurrentLength * k / m;
        }
      else
        {
        // Special handler to apply force to whatever object is attached to nodes[0]  (the Ship)	
        owner.v[0] += scale * (nodes[n+1].r[0] - nodes[n].r[0])/ CurrentLength * k / owner.m;
        owner.v[1] += scale * (nodes[n+1].r[1] - nodes[n].r[1])/ CurrentLength * k / owner.m;
        }     

      if (n < N-2) 
        {
        nodes[n+1].v[0] += scale * (nodes[n].r[0] - nodes[n+1].r[0])/ CurrentLength * k / m;
        nodes[n+1].v[1] += scale * (nodes[n].r[1] - nodes[n+1].r[1])/ CurrentLength * k / m;
        }
      else
        {        
        // The last dangling tether node.
        if (target == null)
          {
          nodes[n+1].v[0] += scale * (nodes[n].r[0] - nodes[n+1].r[0])/ CurrentLength * k / (m);
          nodes[n+1].v[1] += scale * (nodes[n].r[1] - nodes[n+1].r[1])/ CurrentLength * k / (m);   
          }
        else
          {
          // Special handler to apply force to whatever object is attached to nodes[N-1]  (the Spice)	        	
          target.v[0] += scale * (nodes[n].r[0] - nodes[n+1].r[0])/ CurrentLength * k / target.m;
          target.v[1] += scale * (nodes[n].r[1] - nodes[n+1].r[1])/ CurrentLength * k / target.m;   	
          }        
        }                     
      }
    // Update position with velocity, damp velocity.
    for (var n:Number = 1; n < N-1; n++)
      {
      nodes[n].r[0] += nodes[n].v[0];
      nodes[n].r[1] += nodes[n].v[1];	   
      nodes[n].v[0] *= 0.95;
	  nodes[n].v[1] *= 0.95;     	
      } 	          
    
    if (target == null)
      {
      nodes[N-1].r[0] += nodes[N-1].v[0];
      nodes[N-1].r[1] += nodes[N-1].v[1];	   
      nodes[N-1].v[0] *= 0.99;
	  nodes[N-1].v[1] *= 0.99;  	
      }        
    
    // Set the position of the display widget.
    for (var n:Number = 0; n < N; n++)
      {
      nodes[n].display._x = nodes[n].r[0];
	  nodes[n].display._y = nodes[n].r[1];	  
      }    
    } 

  }
