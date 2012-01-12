// This member of a CPUship is responsible for moving the reticle
// onto objects and calling the right usetool messages. Tough to get right.
class ReticleAI
  {  
  var priority : Number;  
  var priorityBody: Body;
  // Action priority:
  // 0 = idle.  (return to ship)
  // 1 = gravity.
  // 2 = repel.
  // 3 = tether.
  var priorityCooldown:Number;
  
  // Pointers for different bodies.
  var gravityBody : Body;
  var repelBody : Body;  
  
  // These parameters are set when the Reticle is on a target.
  var onLR : Boolean;
  var onUD : Boolean;
  var ready : Boolean;
  
  // Owner CPUship
  private var owner:CPUShip;
    
  
  public function ReticleAI(newowner:CPUShip)
    {
    gravityBody = null;
    repelBody = null;	
    priorityBody = null;
    owner = newowner;
    
    priority = 0;    
    onLR = false;
    onUD = false;
    ready = false;
    
    priorityCooldown = 0;
    }
  
  public function setGravityBody (b:Body)
    {
    gravityBody = b;	
    }
  
  public function setRepelBody (b:Body)
    {
    repelBody = b;	
    }
  
  public function setPriority (n:Number)
    // Devotes the reticle to a particular tool.
    {
    priorityCooldown--;	
    if (priorityCooldown <= 0)	
      {
      priority = n;	
      priorityCooldown = 1;
      }
    }
  
  public function unsetPriority(n:Number)
    // A weird method ... deemphasizes a tool.
    {
    if (n == 1)
      if (repelBody != null)
        priority = 2;
      else
        priority = 0;  	
    	
    if (n == 2)
      if (gravityBody != null)
        priority = 1;
      else  
        priority = 0;
    
    if (priority == 0)
      {
      owner.reticle.stickLeftRight(0);
      owner.reticle.stickUpDown(0);	
      }
    }
  
  public function update()
    {	
    // _root.cout.text = "priority " + priority;
    
    switch (priority)
      {      
      case 0: priorityBody = owner; break;
      case 1: priorityBody = gravityBody; break;
      case 2: priorityBody = repelBody; break;
      }

    onLR = false;		
    onUD = false;
    ready = false;  
    if (priorityBody != null)	    	
      {

      // Put the reticle on the priorityBody - left/right.
      if (Math.abs(priorityBody.rx - owner.reticle.rx) > 10)        
        if (priorityBody.rx > owner.reticle.rx)
          owner.reticle.stickLeftRight(1);
        else
          owner.reticle.stickLeftRight(-1);        
      else
        {
        owner.reticle.stickLeftRight(0);      
        onLR = true;
        }
        
      // Put the reticle on the priorityBody - up/down.
      if (Math.abs(priorityBody.ry - owner.reticle.ry) > 10)      
        if (priorityBody.ry > owner.reticle.ry)
          owner.reticle.stickUpDown(1);
        else
          owner.reticle.stickUpDown(-1);        
      else
        {
        owner.reticle.stickUpDown(0);               
        onUD = true;
        }
      if (onUD && onLR)         
        ready = true;     
        
      if (ready)
        {
        switch (priority)
          {
          case 1: owner.gravityTarget = gravityBody; break;	
          case 2: owner.repelTarget = repelBody; break;
          }
        }
      }
    }
  }