// Computer player ship - has some basic AI.
class CPUShip extends Ship
  {
  // AI navigation tools.	
  public var map:NavigationMap;
  private var myTriangle:Triangle;  
  private var bestGravity:Body;
  private var bestRepel:Body;      
  private var desired_rx:Number;
  private var desired_ry:Number;	  
  private var desired_vx:Number;
  private var desired_vy:Number;
  
  // ReticleAI object.
  private var reticleAI:ReticleAI;	
  	
  public function CPUShip ()
    {     
    myTriangle = null;
    map = null;
    
    bestGravity = null;
    bestRepel = null;
    
    // Sketch something shippy.
    draw ();
    
    // Initialize AI members.
    desired_rx = rx;
    desired_ry = ry;
    desired_vx = 0;
    desired_vy = 0;
    reticleAI = new ReticleAI(this);
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
    
    // if (bestGravity != null)
    if (gravityTarget != null)
      {
      // Compute direction vector from me to bestGravity.
      var dx:Number = gravityTarget.rx - rx;
      var dy:Number = gravityTarget.ry - ry;
      var dl:Number = Math.sqrt(dx*dx + dy*dy);
      dx /= dl;
      dy /= dl;
      // Add a little velocity kick towards (dx,dy);
      vx += dx * 0.4;
      vy += dy * 0.4;
      }

//     if (bestRepel != null)
    if (repelTarget != null)
      {
      // Compute direction vector from me to bestGravity.
      var dx:Number = repelTarget.rx - rx;
      var dy:Number = repelTarget.ry - ry;
      var dl:Number = Math.sqrt(dx*dx + dy*dy);
      dx /= dl;
      dy /= dl;
      // Add a little velocity kick away from (dx,dy);
      vx -= dx * 0.4;
      vy -= dy * 0.4;	      
      }
    }
  
  public function updatePosition() 
    {
    // Update position.	
    rx += vx;
    ry += vy;       
    // Bounce off walls.
    super.bounceClip(); 
    // Establish avatar position.
    reticle.updatePosition();    
    avatar._x = rx;
    avatar._y = ry;	
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
    // Use the map to find the bounding triangle of the desired object.    
    var desiredTriangle:Triangle = map.whereIs(desiredBody);
    
    if (desiredTriangle == myTriangle)
      {
      // If we are in the same triangle, fly straight towards it.	
      desired_vx = desired_rx - rx;
      desired_vy = desired_ry - ry;
      var L:Number = Math.sqrt( desired_vx * desired_vx + desired_vy*desired_vy);    
      desired_vx = desired_vx / L * 5.0;
      desired_vy = desired_vy / L * 5.0;     
      }
    else
      {
      // If we are not in the same triangle, fly towards the centroid of an edge (to avoid collision and demise).	
      // Fly towards the edge centroid whose normal points closest to desiredBody.
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
      edgelengths[0] = edgelengths[0] - myTriangle.A.collision_radius - myTriangle.B.collision_radius;
      edgelengths[1] = edgelengths[1] - myTriangle.B.collision_radius - myTriangle.C.collision_radius;
      edgelengths[2] = edgelengths[2] - myTriangle.C.collision_radius - myTriangle.A.collision_radius;        
      // Tweaking function - penalize edges heavily if they are less than this.collision_radius
      for (var i:Number = 0; i < 3; i++)
        dotValues[i] = dotValues[i] * (1.8 / (1+Math.exp( (-edgelengths[i]+collision_radius) / collision_radius) ) - 0.8);            
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
      // Add a little portion of "desired velocity" that points directly at the desired position.
      // The alpha parameter controls the blending between flying towards an edge (alpha=1) and
      // flying towards the desired position (alpha=0)
      var alpha = 0.75;            
      // Compute edge centroids. Reuse the "edge_normals" for scratch storage.
      edge_normals_x[0] = 0.5 * myTriangle.A.rx + 0.5 * myTriangle.B.rx;
      edge_normals_y[0] = 0.5 * myTriangle.A.ry + 0.5 * myTriangle.B.ry;      
      edge_normals_x[1] = 0.5 * myTriangle.B.rx + 0.5 * myTriangle.C.rx;
      edge_normals_y[1] = 0.5 * myTriangle.B.ry + 0.5 * myTriangle.C.ry;      
      edge_normals_x[2] = 0.5 * myTriangle.C.rx + 0.5 * myTriangle.A.rx;
      edge_normals_y[2] = 0.5 * myTriangle.C.ry + 0.5 * myTriangle.A.ry;      
      for (var i:Number = 0; i < 3; i++)
        {
        edge_normals_x[i] -= rx;
        edge_normals_y[i] -= ry;        
        L = Math.sqrt( edge_normals_x[i]*edge_normals_x[i] + edge_normals_y[i]*edge_normals_y[i]);   
        edge_normals_x[i] /= L; 
        edge_normals_y[i] /= L;
        }                  
      desired_vx = ( alpha*edge_normals_x[best] + (1-alpha)*greedy_vx ) * 5.0;
      desired_vy = ( alpha*edge_normals_y[best] + (1-alpha)*greedy_vy ) * 5.0;
      }      
    
    // Tweaking function : damp velocity based on distance from the desired point.    
    desired_vx = desired_vx  / (1+Math.exp( (-D+20) / 20) );
    desired_vy = desired_vy  / (1+Math.exp( (-D+20) / 20) );           
    
    // Compute the error between our current velocity and our desired velocity.
    var error_vx = desired_vx - vx;
    var error_vy = desired_vy - vy;    
    // Sweep through the 3 bounding bodies of myTriangle and figure out which are the bestGravity and bestRepel targets.     
    var dotValues:Array = new Array;
    var bodyBuffer:Array = new Array;
    bodyBuffer[0] = myTriangle.A;
    bodyBuffer[1] = myTriangle.B;
    bodyBuffer[2] = myTriangle.C;   
    var from_ship_to_body_rx:Number;
    var from_ship_to_body_ry:Number;
    // Compute dot products (directions) to these objects.
    for (var i:Number = 0; i < 3; i++)
      {
      from_ship_to_body_rx = bodyBuffer[i].rx - rx;
      from_ship_to_body_ry = bodyBuffer[i].ry - ry;
      var L:Number = Math.sqrt(from_ship_to_body_rx * from_ship_to_body_rx + from_ship_to_body_ry*from_ship_to_body_ry);        
      from_ship_to_body_rx /= L;
      from_ship_to_body_ry /= L;    
      dotValues[i] = from_ship_to_body_rx * error_vx + from_ship_to_body_ry * error_vy;
      }    
    // bestGravity target has the biggest dotValue. If the biggest dotValue is not at least 0.X, choose no bestGravity target and just drift.
    var best:Number = 0;
    var oldBestGravity:Body = bestGravity;
    for (var i:Number = 1; i < 3; i++)
      if (dotValues[i] > dotValues[best])
        best = i;
    var dotValueGravity:Number = dotValues[best];        
    if (dotValues[best] > 0.7)
      {
      switch (best)	
        {
        case 0: bestGravity = myTriangle.A; break;
        case 1: bestGravity = myTriangle.B; break;
        case 2: bestGravity = myTriangle.C; break; 
        }
      }
    else     
      bestGravity = null;       
    if (bestGravity != oldBestGravity)
      gravityTarget = null;
      
    // bestRepel target has the smallest dotValue.
    best = 0;
    for (var i:Number = 1; i < 3; i++)
      if (dotValues[i] < dotValues[best])
        best = i;
    var dotValueRepel:Number = dotValues[best];       
    var oldBestRepel:Body = bestRepel;
    if (dotValues[best] < -0.7)
      {
      switch (best)	
        {
        case 0: bestRepel = myTriangle.A; break;
        case 1: bestRepel = myTriangle.B; break;
        case 2: bestRepel = myTriangle.C; break; 
        }
      }
    else      
      bestRepel = null;
      
    if (bestRepel != oldBestRepel)
      repelTarget = null; 

    
     // Collision avoidance sub-objective. If I am too close to myTriangle.(A or B or C), repel from it to avoid collision.
     for (var i:Number = 0; i < 3; i++)
      {
      from_ship_to_body_rx = bodyBuffer[i].rx - rx;
      from_ship_to_body_ry = bodyBuffer[i].ry - ry;
      var L:Number = Math.sqrt(from_ship_to_body_rx * from_ship_to_body_rx + from_ship_to_body_ry*from_ship_to_body_ry);        
      if ( L < (bodyBuffer[i].collision_radius + collision_radius) * 1.5 )
        {
        bestRepel = bodyBuffer[i];
        // Emergency, dedicate reticle to the repel tool.
        reticleAI.setPriority(2);
        }
      }      
    
    if (bestRepel == null)            
      reticleAI.setPriority(1);           
    if (bestGravity == null)       
      reticleAI.setPriority(2);            
    
    if (bestRepel != null && bestGravity != null) 
      // Switch priorities if one action is significantly better than the other, or the reticle is idle.
      if ( Math.abs (Math.abs(dotValueRepel) - Math.abs(dotValueGravity)) > 0.2 || reticleAI.priority == 0 )            
      if (Math.abs(dotValueRepel) > Math.abs(dotValueGravity) )
        reticleAI.setPriority(2);
      else
        reticleAI.setPriority(1);  
    
    if (bestRepel == null && bestGravity == null)          
      reticleAI.setPriority(0); 
      
    // Sketch the desired position.
    _root.lineStyle(2,0x000000, 100);       
	_root.moveTo(desired_rx-10,desired_ry-10);
	_root.lineTo(desired_rx+10,desired_ry+10);
	_root.moveTo(desired_rx-10,desired_ry+10);
	_root.lineTo(desired_rx+10,desired_ry-10);

    reticleAI.setGravityBody (bestGravity);
    reticleAI.setRepelBody (bestRepel);
    reticleAI.update();

      
       // Sketch the bestGravity and bestRepel.
    //if (bestGravity != null)
    if (gravityTarget != null)
      {
      _root.lineStyle(2, 0x007FFF, 100);
      _root.moveTo(rx,ry);
      _root.lineTo(gravityTarget.rx, gravityTarget.ry);
      }
    
    //if (bestRepel != null)
    if (repelTarget != null)
      {
      _root.lineStyle(2, 0xFF4B37, 100);
      _root.moveTo(rx,ry);
      _root.lineTo(repelTarget.rx, repelTarget .ry);	
      }  
      
      
/*
    _root.cout.text = "Ship in Triangle " + myTriangle.ID + ". Desired velocity (" + GeometryTests.threeDigits(desired_vx) + ", " + GeometryTests.threeDigits(desired_vy) + 
                      "). dotValues scores: (" + GeometryTests.threeDigits(dotValues[0]) + "," + 
                                                 GeometryTests.threeDigits(dotValues[1]) + "," + 
                                                 GeometryTests.threeDigits(dotValues[2]) + ").";
  */  	
    }
  }