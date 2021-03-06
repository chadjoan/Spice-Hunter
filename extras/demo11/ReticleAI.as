class ReticleAI
  {
  public var target:Body;
  public var owner:CPUShip;
  public var isReady:Boolean;
  
  // These parameters are set when the Reticle is aligned with the target along a given axis.
  private var onLR : Boolean;
  private var onUD : Boolean;
  
    

  
  public function ReticleAI (_owner:CPUShip)
    {
    owner = _owner;
    target = null;
    isReady = false;
    owner.reticle.rx = owner.rx;	
    owner.reticle.ry = owner.ry;
    }
  
  public function setTarget(t:Body) : Void
    {
    target = t;	
    if (t == null)
      {
      owner.reticle.stickLeftRight(0);  	
      owner.reticle.stickUpDown(0);  
      }
    }
  
  
  
  public function update()
    {	
    // _root.cout.text = "priority " + priority;   
    onLR = false;		
    onUD = false;
    isReady = false;  
    if (target != null)	    	
      {
      // Put the reticle on the target - left/right.
      if (Math.abs(target.rx - owner.reticle.rx) > 10)        
        if (target.rx > owner.reticle.rx)
          owner.reticle.stickLeftRight(1);
        else
          owner.reticle.stickLeftRight(-1);        
      else
        {
        owner.reticle.stickLeftRight(0);      
        onLR = true;
        }        
      // Put the reticle on the priorityBody - up/down.
      if (Math.abs(target.ry - owner.reticle.ry) > 10)      
        if (target.ry > owner.reticle.ry)
          owner.reticle.stickUpDown(1);
        else
          owner.reticle.stickUpDown(-1);        
      else
        {
        owner.reticle.stickUpDown(0);               
        onUD = true;
        }
      if (onUD && onLR)         
        isReady = true;     
              
      }
    else
      {
      // Put the reticle in front of the ship.
      var L:Number = 0;
      if (Math.abs(owner.rx + owner.vx*L - owner.reticle.rx) > 100)        
        if (owner.rx + owner.vx*L > owner.reticle.rx)
          owner.reticle.stickLeftRight(1);
        else
          owner.reticle.stickLeftRight(-1);
      else
        owner.reticle.stickLeftRight(0);               
      if (Math.abs(owner.ry + owner.vy*L - owner.reticle.ry) > 100)      
        if (owner.ry + owner.vy*L > owner.reticle.ry)
          owner.reticle.stickUpDown(1);
        else
          owner.reticle.stickUpDown(-1);      	
      else
        owner.reticle.stickUpDown(0);    
      }
    }
  }