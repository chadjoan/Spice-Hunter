// Computer player ship - has some basic AI.
class CPUShip extends Ship
  {
  public var map:NavigationMap;
  public var env:Environment;
  
  private var myTriangle:Triangle;
  
  private var bestGravity:Body;
  
  private var bestRepel:Body;        
  private var desired_rx:Number;
  private var desired_ry:Number;	
  
  private var desired_vx:Number;
  private var desired_vy:Number;
  	
  private var repelStrength : Number;
  private var gravityStrength : Number;  
  
  private var reticleAI : ReticleAI;
  private var collisionFlag : Boolean;
  	
  public function CPUShip ()
    {     
    myTriangle = null;
    map = null;
    
    bestGravity = null;
    bestRepel = null;    
    
    // Sketch something shippy.
    draw ();
    
    // Initialize AI members.
    desired_rx = 600;
    desired_ry = 400;
    desired_vx = 0;
    desired_vy = 0;
    
    repelStrength = 0.3;
    gravityStrength = 0.3;
    
    reticleAI = new ReticleAI(this);
    collisionFlag = false;
    }
  
  public function draw ()
    {
    avatar.clear ();	
    // CPUShip - draw a triangle thats bluish.
    avatar.lineStyle(2, 0x000000, 100);
    // Red      0=0x00
    // Green  127=0x7F
    // Blue   255=0xFF    
    avatar.beginFill(0x007FFF); 
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
    /*	
    if (bestGravity != null)
      {
      // Compute direction vector from me to bestGravity.
      var dx:Number = bestGravity.rx - rx;
      var dy:Number = bestGravity.ry - ry;
      var dl:Number = Math.sqrt(dx*dx + dy*dy);
      dx /= dl;
      dy /= dl;
      // Add a little velocity kick towards (dx,dy);
      vx += dx * gravityStrength;
      vy += dy * gravityStrength;
      }
      
    if (bestRepel != null)
      {
      // Compute direction vector from me to bestGravity.
      var dx:Number = bestRepel.rx - rx;
      var dy:Number = bestRepel.ry - ry;
      var dl:Number = Math.sqrt(dx*dx + dy*dy);
      dx /= dl;
      dy /= dl;
      // Add a little velocity kick away from (dx,dy);
      vx -= dx * repelStrength;
      vy -= dy * repelStrength;	
      }
    */
    
    if (gravityTarget != null)
      {
      // Compute direction vector from me to bestGravity.
      var dx:Number = gravityTarget.rx - rx;
      var dy:Number = gravityTarget.ry - ry;
      var dl:Number = Math.sqrt(dx*dx + dy*dy);
      dx /= dl;
      dy /= dl;
      // Add a little velocity kick towards (dx,dy);
      vx += dx * gravityStrength;
      vy += dy * gravityStrength;
      }
      
    if (repelTarget != null)
      {
      // Compute direction vector from me to bestGravity.
      var dx:Number = repelTarget.rx - rx;
      var dy:Number = repelTarget.ry - ry;
      var dl:Number = Math.sqrt(dx*dx + dy*dy);
      dx /= dl;
      dy /= dl;
      // Add a little velocity kick away from (dx,dy);
      vx -= dx * repelStrength;
      vy -= dy * repelStrength;	
      }
    
    
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
  
  public function testCloseness() : Number
    {
    var dx:Number = desired_rx - rx;
    var dy:Number = desired_ry - ry;
    var L:Number = Math.sqrt( dx * dx + dy*dy);    	
    if (L < 30)
      {
      desired_rx = Math.random()*700+50;
      desired_ry = Math.random()*500+50;
      }    
    return L;  
    }
  	
  public function updateAI ()
    {    	    
    // In the case of impending collision, collisionFlag is set and we should restore bestRepel if it gets changed.
    var oldRepel:Body = bestRepel;
    
    // Implements a "mostly safe" navigation strategy. Responsible for 
    // establising "bestGravity" and "bestRepel" members.
    
    // Range to desired position.
    var D:Number = testCloseness();
    // Determine what triangle the desired point is within.
    var desiredBody:Body = new Body();
    desiredBody.rx = desired_rx;
    desiredBody.ry = desired_ry;
    
    // Use the map to find my bounding triangle.    
    myTriangle = map.whereIs(this);   
    
    // Sketch      
    _root.lineStyle(2, 0x006400, 100);    
    _root.moveTo(myTriangle.A.rx,myTriangle.A.ry);
    _root.lineTo(myTriangle.B.rx,myTriangle.B.ry);
    _root.lineTo(myTriangle.C.rx,myTriangle.C.ry);
    _root.lineTo(myTriangle.A.rx,myTriangle.A.ry);
    
    // Use the map to find the bounding triangle of the desired object.    
    var desiredTriangle:Triangle = map.whereIs(desiredBody);
    
    if (desiredTriangle == myTriangle)
      {
      // If we are in the same triangle, fly straight towards it.	
      desired_vx = desired_rx - rx;
      desired_vy = desired_ry - ry;
      var L:Number = Math.sqrt( desired_vx * desired_vx + desired_vy*desired_vy);    
      desired_vx = desired_vx / L;
      desired_vy = desired_vy / L;     
      }
    else
      {
      // If we are not in the same triangle, fly towards the centroid of an edge (to avoid collision and demise).	
      // Fly towards the edge centroid whose normal is closest in direction towards the desiredBody
      var edge_normals_x:Array = new Array;
      var edge_normals_y:Array = new Array;      
      // Compute edge normals.
      edge_normals_y[0] = myTriangle.A.rx - myTriangle.B.rx;
      edge_normals_x[0] = myTriangle.B.ry - myTriangle.A.ry;      
      edge_normals_y[1] = myTriangle.B.rx - myTriangle.C.rx;
      edge_normals_x[1] = myTriangle.C.ry - myTriangle.B.ry;   
      edge_normals_y[2] = myTriangle.C.rx - myTriangle.A.rx;
      edge_normals_x[2] = myTriangle.A.ry - myTriangle.C.ry;   
  
      // Compute triangle centroid.
      var cx:Number = (myTriangle.A.rx + myTriangle.B.rx + myTriangle.C.rx)/3;
      var cy:Number = (myTriangle.A.ry + myTriangle.B.ry + myTriangle.C.ry)/3;
        
      // Compute direction to desiredBody from Triangle centroid.
      desired_vx = desired_rx - cx;
      desired_vy = desired_ry - cy;
      var L:Number = Math.sqrt( desired_vx * desired_vx + desired_vy*desired_vy);    
      desired_vx = desired_vx / L;
      desired_vy = desired_vy / L;                
      var dotValues:Array = new Array;
      // Find edge norm to that direction. Use dot products ... we want the largest.    
      for (var i:Number = 0; i < 3; i++)
        dotValues[i] = edge_normals_x[i] * desired_vx + edge_normals_y[i] * desired_vy;              
        
      // Tweak dot products for a little better performance.
      // 1. make wide edges more attractive.
      // 2. make edges that are growing wider more attractive.  
      var edgelengths:Array = new Array;
      edgelengths[0] = Math.sqrt( (myTriangle.A.rx - myTriangle.B.rx)*(myTriangle.A.rx - myTriangle.B.rx)  
                               +  (myTriangle.A.ry - myTriangle.B.ry)*(myTriangle.A.ry - myTriangle.B.ry) );	
      edgelengths[1] = Math.sqrt( (myTriangle.C.rx - myTriangle.B.rx)*(myTriangle.C.rx - myTriangle.B.rx)  
                               +  (myTriangle.C.ry - myTriangle.B.ry)*(myTriangle.C.ry - myTriangle.B.ry) );	   
      edgelengths[2] = Math.sqrt( (myTriangle.C.rx - myTriangle.A.rx)*(myTriangle.C.rx - myTriangle.A.rx)  
                               +  (myTriangle.C.ry - myTriangle.A.ry)*(myTriangle.C.ry - myTriangle.A.ry) );
      // Remove collision_radius to determine effective aperture.                         
      edgelengths[0] = edgelengths[0] - myTriangle.A.collision_radius - myTriangle.B.collision_radius - 2.0*collision_radius;
      edgelengths[1] = edgelengths[1] - myTriangle.B.collision_radius - myTriangle.C.collision_radius - 2.0*collision_radius;
      edgelengths[2] = edgelengths[2] - myTriangle.C.collision_radius - myTriangle.A.collision_radius - 2.0*collision_radius;        
      // Tweaking function - penalize edges heavily if they are less than this.collision_radius
      for (var i:Number = 0; i < 3; i++)
        dotValues[i] = dotValues[i] * (2.0 / (1+Math.exp( (-edgelengths[i]+collision_radius) / collision_radius) ) - 1.0);      
      // Search for best edge. 
      var best:Number = 0;
      for (var i:Number = 1; i < 3; i++)
        if (dotValues[i] > dotValues[best])
          best = i;
      
      // Set the desired velocity to point in the best direction.          
      var greedy_vx:Number = desired_rx - rx;
      var greedy_vy:Number = desired_ry - ry;
      L = Math.sqrt( greedy_vx * greedy_vx + greedy_vy*greedy_vy);   
      greedy_vx /= L; 
      greedy_vy /= L;                  
                 
      // Compute edge centroids. Reuse the "edge_normals" for scratch storage.
      edge_normals_x[0] = 0.5 * myTriangle.A.rx + 0.5 * myTriangle.B.rx;
      edge_normals_y[0] = 0.5 * myTriangle.A.ry + 0.5 * myTriangle.B.ry;      
      edge_normals_x[1] = 0.5 * myTriangle.B.rx + 0.5 * myTriangle.C.rx;
      edge_normals_y[1] = 0.5 * myTriangle.B.ry + 0.5 * myTriangle.C.ry;      
      edge_normals_x[2] = 0.5 * myTriangle.C.rx + 0.5 * myTriangle.A.rx;
      edge_normals_y[2] = 0.5 * myTriangle.C.ry + 0.5 * myTriangle.A.ry;      
      
       // Don't fly straight towards edge centroid.
      var P1 : Body = new Body;
      var P2 : Body = new Body;            
      switch (best)
        {
        case 0: 
          P1.rx = myTriangle.A.rx; P1.ry = myTriangle.A.ry; 
          P2.rx = myTriangle.B.rx; P2.ry = myTriangle.B.ry; 
          P1.collision_radius = myTriangle.A.collision_radius;
          P2.collision_radius = myTriangle.B.collision_radius;
        break;	
        case 1:  
          P1.rx = myTriangle.B.rx; P1.ry = myTriangle.B.ry;
          P2.rx = myTriangle.C.rx; P2.ry = myTriangle.C.ry; 
          P1.collision_radius = myTriangle.B.collision_radius;
          P2.collision_radius = myTriangle.C.collision_radius;
        break;
        case 2: 
          P1.rx = myTriangle.C.rx; P1.ry = myTriangle.C.ry;
          P2.rx = myTriangle.A.rx; P2.ry = myTriangle.A.ry; 
          P1.collision_radius = myTriangle.C.collision_radius;
          P2.collision_radius = myTriangle.A.collision_radius;
        break;
        }
        
        
        
      // Scoot inwards from the ends by collision radius.  
      var P12_x:Number = P2.rx-P1.rx;
      var P12_y:Number = P2.ry-P1.ry;
      L = Math.sqrt (P12_x*P12_x + P12_y*P12_y);
      P12_x /= L;
      P12_y /= L;
      
      // Scoot in from P1 to make P1'
      P1.rx += P12_x * (P1.collision_radius + 3 * collision_radius);
      P1.ry += P12_y * (P1.collision_radius + 3 * collision_radius);
      
      // Scoot in from P2 to make P2'
      P2.rx -= P12_x * (P2.collision_radius + 3 * collision_radius);
      P2.ry -= P12_y * (P2.collision_radius + 3 * collision_radius);
     
      // Blending parameter.      
      var alpha:Number;
      // If the path is clear, fly straight towards the desired point.      
      if (GeometryTests.isRightTurn (desiredBody, this, P2) &&
          GeometryTests.isRightTurn (P1, this, desiredBody) )
        alpha = 0.15;
      else
        alpha = 0.85;          

      // Sketch.      
      /*
      _root.lineStyle(2, 0x006400, 100);
      _root.moveTo(rx,ry);
      _root.lineTo(P1.rx, P1.ry);      
      _root.moveTo(rx,ry);
      _root.lineTo(P2.rx, P2.ry);
      _root.moveTo(rx,ry);
      _root.lineTo(desired_rx, desired_ry);      
      */
      
      for (var i:Number = 0; i < 3; i++)
        {
        edge_normals_x[i] -= rx;
        edge_normals_y[i] -= ry;        
        L = Math.sqrt( edge_normals_x[i]*edge_normals_x[i] + edge_normals_y[i]*edge_normals_y[i]);   
        edge_normals_x[i] /= L; 
        edge_normals_y[i] /= L;
        }            
      
      desired_vx = ( alpha*edge_normals_x[best] + (1-alpha)*greedy_vx ) ;
      desired_vy = ( alpha*edge_normals_y[best] + (1-alpha)*greedy_vy ) ;
      }      
    
    // Scale velocity - it's normalized. Shoot for 3 pixels / frame nominally, but go faster as tools improve.
    desired_vx *= (2.0 + 1.0*(repelStrength+gravityStrength));
    desired_vy *= (2.0 + 1.0*(repelStrength+gravityStrength));
    
    // Tweaking function : damp velocity based on distance from the desired point.    
    desired_vx = desired_vx  / (1+Math.exp( (-D+20) / 20) );
    desired_vy = desired_vy  / (1+Math.exp( (-D+20) / 20) );   
    
    // Compute the error between our current velocity and our desired velocity.
    var error_vx = desired_vx - vx;
    var error_vy = desired_vy - vy;   
    var E = Math.sqrt(error_vx*error_vx + error_vy*error_vy);
    
    
    // Find all objects within radius.
    var radius:Number = 250;
    var bodyBuffer:Array = env.findBodies(this, radius);
    // Nothing can be done, we are adrift.
    //if (bodyBuffer.length == 0)
//      return;
    
    if (bodyBuffer.length == 0)
      {
      bestGravity = null;
      bestRepel = null;
      gravityTarget = null;
      repelTarget = null;	
      reticleAI.setTarget(null);
      return;	      
      }
    
    
    // Compute unit normals to these objects.
    var from_ship_to_body_rx:Number;
    var from_ship_to_body_ry:Number;
    var dotValues:Array = new Array;    
    for (var i:Number = 0; i < bodyBuffer.length; i++)
      {           
      from_ship_to_body_rx = bodyBuffer[i].rx - rx;
      from_ship_to_body_ry = bodyBuffer[i].ry - ry;
      var L:Number = Math.sqrt(from_ship_to_body_rx * from_ship_to_body_rx + from_ship_to_body_ry*from_ship_to_body_ry);        
      from_ship_to_body_rx /= L;
      from_ship_to_body_ry /= L;    
      dotValues[i] = from_ship_to_body_rx * error_vx/E + from_ship_to_body_ry * error_vy/E;	
      }    
            
    // Find largest absolute dotValue    
    var bestIndex:Number = 0;    
    for (var i:Number = 1; i < dotValues.length; i++)
      if (Math.abs(dotValues[i]) > Math.abs(dotValues[bestIndex]) )
        bestIndex = i;     
          
    // Compute dot product to currently selected target. Needs to be updated as we move.
    var currTarget:Body;
    var currDot : Number = 0;    
    if (bestGravity != null)
      {
      currTarget = bestGravity;	
      // If error component along an active beam vanishes, turn it off.	
      from_ship_to_body_rx = currTarget.rx - rx;
      from_ship_to_body_ry = currTarget.ry - ry;
      var L:Number = Math.sqrt(from_ship_to_body_rx * from_ship_to_body_rx + from_ship_to_body_ry*from_ship_to_body_ry); 
      from_ship_to_body_rx /= L;
      from_ship_to_body_ry /= L;
      currDot = from_ship_to_body_rx * error_vx/E + from_ship_to_body_ry * error_vy/E;      
      if (currDot < 0.4)
        {
        bestGravity = null;
        gravityTarget = null;
        currTarget = null;  
        currDot = 0.0;
        }
        
      }
    if (bestRepel != null)
      {
      currTarget = bestRepel;  
      // If error component along an active beam vanishes, turn it off.	
      from_ship_to_body_rx = currTarget.rx - rx;
      from_ship_to_body_ry = currTarget.ry - ry;
      var L:Number = Math.sqrt(from_ship_to_body_rx * from_ship_to_body_rx + from_ship_to_body_ry*from_ship_to_body_ry); 
      from_ship_to_body_rx /= L;
      from_ship_to_body_ry /= L;
      currDot = from_ship_to_body_rx * error_vx/E + from_ship_to_body_ry * error_vy/E;
      if (currDot > -0.4)
        {
        bestRepel = null;        
        repelTarget = null;
        currTarget = null;  
        currDot = 0.0;        
        }
      }
    
    // A new target needs to be more attractive than our current beam.
    if (Math.abs(dotValues[bestIndex]) > Math.abs(currDot) + 0.8)      
      {           
      if (dotValues[bestIndex] < -0.0 && E > repelStrength)
        {      
        bestRepel = bodyBuffer[bestIndex];
        bestGravity = null;  
        gravityTarget = null;   
        currDot = dotValues[bestIndex];   
        }
            
      if (dotValues[bestIndex] > 0.0 && E > gravityStrength)
        {
        bestRepel = null;
        repelTarget = null;
        bestGravity = bodyBuffer[bestIndex];	        
        currDot = dotValues[bestIndex];
        }
      }
    
    if (collisionFlag)
      bestRepel = oldRepel;  
 
    // A sentinel value that represents no collision found yet.
    collisionFlag = false;
    var tmin:Number = -100;
   
    for (var i:Number = 0; i < bodyBuffer.length; i++)
      {        
        // Compute if a collision will occur.	
        var relative_rx:Number = bodyBuffer[i].rx - rx;
        var relative_ry:Number = bodyBuffer[i].ry - ry;      
        var relative_r:Number = Math.sqrt(relative_rx*relative_rx + relative_ry*relative_ry);
        var relative_vx:Number = bodyBuffer[i].vx - vx;
        var relative_vy:Number = bodyBuffer[i].vy - vy;
        var ttime = -(relative_vx*relative_rx + relative_vy*relative_ry)
                    /(relative_vx*relative_vx + relative_vy*relative_vy);      
        if (ttime > 0 && ttime < 20)           
          {
          var rmin_x:Number = relative_rx + relative_vx*ttime;
          var rmin_y:Number = relative_ry + relative_vy*ttime;
          var rmin:Number = Math.sqrt(rmin_x*rmin_x + rmin_y*rmin_y);
          if (rmin < (bodyBuffer[i].collision_radius+collision_radius) 
              || relative_r < (bodyBuffer[i].collision_radius + collision_radius)*1.2)
            if (ttime < tmin || tmin == -100)
              {
              // A collision will occur
              bestRepel = bodyBuffer[i];
              bestGravity = null;
              tmin = ttime;              
              collisionFlag = true;
              }
          }              
      }
    

    // Set the reticle with target information.
    if (bestGravity == null && bestRepel == null)
      reticleAI.setTarget(null);
    if (bestGravity != null)
      reticleAI.setTarget(bestGravity);    
    if (bestRepel != null)
      reticleAI.setTarget(bestRepel);        
    reticleAI.update(); 
    
    
    // Engage a beam if the reticle is ready.
    if (reticleAI.isReady)
      {
      gravityTarget = bestGravity;
      repelTarget = bestRepel;  
      }
    
    //gravityTarget = bestGravity;
    //repelTarget = bestRepel;
    
    // Sketch the desired position.
    _root.lineStyle(2,0x000000, 100);      
	_root.moveTo(desired_rx-10,desired_ry-10);
	_root.lineTo(desired_rx+10,desired_ry+10);
	_root.moveTo(desired_rx-10,desired_ry+10);
	_root.lineTo(desired_rx+10,desired_ry-10);
	
	
    // Sketch the bestGravity and bestRepel.
    if (gravityTarget != null)
      {
      _root.lineStyle(2, 0x007FFF, 100);
      _root.moveTo(rx,ry);
      _root.lineTo(gravityTarget.rx, gravityTarget.ry);
      }
    
    if (repelTarget != null)
      {
      _root.lineStyle(2, 0xFF4B37, 100);
      _root.moveTo(rx,ry);
      _root.lineTo(bestRepel.rx, bestRepel.ry);	
      }
	
  
    }
  }