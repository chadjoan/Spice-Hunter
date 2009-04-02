class Environment
  {  
  private var asteroids:Array;
  private var spices:Array;
  private var homebases:Array;  
  private var ships:Array;
  private var map:NavigationMap;
  
  private var mapUpdateFrame1 : Number;
  private var mapUpdateFrame2 : Number;
    
  public function Environment ()
    {    	
    asteroids = new Array;    
    spices = new Array;
    homebases = new Array;
    ships = new Array;
        
    // Make an interesting initial field of Asteroids.
    for (var a:Number=0; a < 7; a++)
      {
      asteroids[a] = new Asteroid();
      // Randomize position.
      asteroids[a].rx = Math.random()*(800-2.0*asteroids[a].collision_radius) + asteroids[a].collision_radius;
      asteroids[a].ry = Math.random()*(600-2.0*asteroids[a].collision_radius) + asteroids[a].collision_radius;                  
      // Randomize velocity.
      var v:Number = Math.random()*1.5;      
      var phi:Number = Math.random()*2.0*Math.PI;      
      asteroids[a].vx = v*Math.sin(phi);
      asteroids[a].vy = v*Math.cos(phi);
      }
      
    asteroids[0].rx = 100;
    asteroids[0].ry = 176;
    
    asteroids[1].rx = 650;
    asteroids[1].ry = 200;
    
    
    // Make an interesting initial field of Spices.
    for (var s:Number=0; s< 10; s++)
      {
      spices[s] = new Spice();
      // Randomize position.
      spices[s].rx = Math.random()*(800-2.0*spices[s].collision_radius) + spices[s].collision_radius;
      spices[s].ry = Math.random()*(600-2.0*spices[s].collision_radius) + spices[s].collision_radius;            
      }    
    
    // Initialize base locations to the corners.
    homebases[0] = new HomeBase();
    homebases[0].rx = 0;
    homebases[0].ry = 0;
    
    homebases[1] = new HomeBase();
    homebases[1].rx = 0;
    homebases[1].ry = 600;
    
    homebases[2] = new HomeBase();
    homebases[2].rx = 800;
    homebases[2].ry = 600;    
    
    homebases[3] = new HomeBase();
    homebases[3].rx = 800;
    homebases[3].ry = 0;
    
    for (var hb:Number=0; hb< homebases.length; hb++)
      homebases[hb].updatePosition();
        
    // Create new ships near the home bases.
    ships[0] = new Ship();
    ships[0].rx = 70;
    ships[0].ry = 70;  
 
    ships[1] = new Ship();
    ships[1].rx = 70;
    ships[1].ry = 600-70; 
    
    ships[2] = new Ship();
    ships[2].rx = 800-70;
    ships[2].ry = 600-70; 
    
    ships[3] = new Ship();
    ships[3].rx = 800-70;
    ships[3].ry = 70;     
    
    // Draw the domain borders.    
    _root.lineStyle(2, 0x000000, 100);
    _root.moveTo(0,0);
    _root.lineTo(800,0);
    _root.lineTo(800,600);
    _root.lineTo(0,600);
    _root.lineTo(0,0);    
    
    initializeMap(); 
    Key.addListener(this);    
    mapUpdateFrame1 = 0;
    mapUpdateFrame2 = 0;
    map.draw();      
    }
  
  public function onEnterFrame() : Void
    {       
    mapUpdateFrame1++;	           
    if (mapUpdateFrame1 == 10)
      {
      // Clean up the existing map using edge flips.	
      map.computeAngles();	
      map.cleanUp();
      mapUpdateFrame1 = 0;            
      mapUpdateFrame2++;      
      }    
    if (mapUpdateFrame2 == 10)     
      {
      // Make a new map from scratch.	
      initializeMap();  
      mapUpdateFrame2 = 0;      
      }
    map.draw();	    

    
    // Handle collisions between Asteroids by exchanging momentum.
    for (var a1:Number=0; a1 < asteroids.length; a1++)
      for (var a2:Number=a1+1; a2 < asteroids.length; a2++)
        if ( collisionCheck (asteroids[a1], asteroids[a2]) )
          momentumExchangeElastic (asteroids[a1], asteroids[a2]);
     
    // Handle collisions between Asteroid and Spice by exchanging momentum.
    for (var a:Number=0; a < asteroids.length; a++)
      for (var s:Number=0; s < spices.length; s++)
        if ( collisionCheck (asteroids[a], spices[s]) )
          momentumExchangeElastic (asteroids[a], spices[s]);
      
    // Handle collisions between Spices by globbing.   
    for (var s1:Number=0; s1 < spices.length; s1++)
      for (var s2:Number=s1+1; s2 < spices.length; s2++)
        if ( collisionCheck (spices[s1], spices[s2]) )
          {
          // Glob momentum into s1.	
          momentumExchangeInelastic (spices[s1], spices[s2]);
          spices[s1].mass += spices[s2].mass;
          // Make the spice grow a little bit. Enlarge its collision_radius.
          spices[s1].collision_radius = Math.sqrt (spices[s1].collision_radius*spices[s1].collision_radius 
                                                 + spices[s2].collision_radius*spices[s2].collision_radius);
          // Trigger a redraw, with larger mass.                                        
          spices[s1].draw();          
          
          // Remove the visual sprite of s2. 
          spices[s2].expire();
          // Move s2 to the end of the array and pop it off.
          spices[s2] = spices[spices.length-1];
          spices.pop();          
          
          // FUTURE GOTCHA
          // If s2 is a target of any ship tool, that reference is no longer valid.
          // Sweep through all ships, and if any of a ships tools reference s2
          // as a target, set s1 as a new target.
          }
    
    // Handle collisions between Spices and Homebases by reflection.
    for (var a:Number=0; a < asteroids.length; a++)
      for (var hb:Number=0; hb < homebases.length; hb++)
        if ( collisionCheck(asteroids[a], homebases[hb]) )
          momentumExchangeReflection (asteroids[a], homebases[hb]);
    
    // Handle collisions between Spices and Homebases by eliminating the spice and updating the Homebases score.
    for (var s:Number=0; s < spices.length; s++)
      for (var hb:Number=0; hb < homebases.length; hb++)
        if ( collisionCheck(spices[s], homebases[hb]) )
          {
          homebases[hb].score += spices[s].mass;	
          _root.cout.text = "HomeBase " + hb + " just scored " + spices[s].mass 
                            + " spices. Scoreboard: [" +homebases[0].score+ "," +homebases[1].score+ "," +homebases[2].score+ "," +homebases[3].score+ "]";
          
          
          // Remove the visual sprite of s. 
          spices[s].expire();
          // Move s2 to the end of the array and pop it off.          
          spices[s] = spices[spices.length-1];
          spices.pop();   
          
          // FUTURE GOTCHA
          // If s is a target of any ship tool, that reference is no longer valid.
          // Sweep through all ships, and if any of a ships tools reference s
          // as a target, set null as a new target.
                    	
          }
    
    // Handle collisions between Ships and Asteroids by momentum exchange (for now)
    for (var a:Number=0; a < asteroids.length; a++)
       for (var sh:Number=0; sh < ships.length; sh++)
         if ( collisionCheck (asteroids[a], ships[sh]) )
           momentumExchangeElastic (asteroids[a], ships[sh]);            
    
    // Handle collisions between Ships and Homebases by momentum exchange (for now)
    for (var sh:Number=0; sh < ships.length; sh++)   
       for (var hb:Number=0; hb < homebases.length; hb++)
          if ( collisionCheck(ships[sh], homebases[hb]) )
            momentumExchangeReflection (ships[sh], homebases[hb]);            
    
        
    // Handle collisions between Ships and other Ships by momentum exchange (for now)        
    for (var sh1:Number=0; sh1 < ships.length; sh1++)   
       for (var sh2:Number=sh1+1; sh2 < ships.length; sh2++)
          if ( collisionCheck(ships[sh1], ships[sh2]) )
            momentumExchangeElastic (ships[sh1], ships[sh2]);   
    
    // Update asteroid positions.
    for (var a:Number=0; a < asteroids.length; a++)    
      asteroids[a].updatePosition();	    
      
    // Update spice positions.
    for (var s:Number=0; s < spices.length; s++)    
      spices[s].updatePosition();  
   
    // Update ship positions.
    for (var sh:Number=0; sh < ships.length; sh++)
      ships[sh].updatePosition();
             
    }
  
  public function collisionCheck (b1:Body, b2:Body) : Boolean
    {
    // Compute difference in positions.    
    var dx:Number = b2.rx - b1.rx;
    var dy:Number = b2.ry - b1.ry;
    var d:Number = Math.sqrt(dx*dx + dy*dy);    
    // Do the collision_radii of the two Bodies overlap?    
    return (d < b1.collision_radius + b2.collision_radius);    	
    }
  
  public function momentumExchangeInelastic (b1:Body, b2:Body) : Void  
    {
    // Exchange momentum routine which is perfectly inelastic (objects adhere)
    b1.vx = (b1.mass*b1.vx + b2.vx*b2.mass)/(b1.mass+b2.mass);
    b1.vy = (b1.mass*b1.vy + b2.vy*b2.mass)/(b1.mass+b2.mass);
    
    // Reposition at a weighted centroid of the two Bodies.
    var frac1:Number = b1.mass / (b1.mass+b2.mass);
    var frac2:Number = 1-frac1;
    b1.rx = frac1 * b1.rx + frac2 * b2.rx;
    b1.ry = frac1 * b1.ry + frac2 * b2.ry;
    }
  
  public function momentumExchangeReflection (b1:Body, b2_immobile:Body) : Void
    {
    // Exchange momentum routine in which b2 is immobile and b1 just bounces off of it.     
    var dx:Number = b2_immobile.rx - b1.rx;
    var dy:Number = b2_immobile.ry - b1.ry;
    var d:Number = Math.sqrt(dx*dx + dy*dy);    
       
    // Compute f_hat vector (the "action" axis).    
    var fx = dx / d;
    var fy = dy / d;
    
    // Compute velocity projections onto f axis.
    var v1Tf:Number = b1.vx * fx + b1.vy * fy;	
    
    // Update velocity with a momentum kick.
    b1.vx = b1.vx - 2.0 * v1Tf * fx;
    b1.vy = b1.vy - 2.0 * v1Tf * fy;    
    
    // Restore tangency between the two Bodies so that they no longer collide.      
    b1.rx = b2_immobile.rx - fx*(b1.collision_radius + b2_immobile.collision_radius);
    b1.ry = b2_immobile.ry - fy*(b1.collision_radius + b2_immobile.collision_radius);        
    }
  
  public function momentumExchangeElastic (b1:Body, b2:Body) : Void
    {    
    // Exchange momentum routine which conserves kinetic energy. 
    var dx:Number = b2.rx - b1.rx;
    var dy:Number = b2.ry - b1.ry;
    var d:Number = Math.sqrt(dx*dx + dy*dy);    
       
    // Compute f_hat vector (the "action" axis).    
    var fx = dx / d;
    var fy = dy / d;
    
    // Compute velocity projections onto f axis.
    var v1Tf:Number = b1.vx * fx + b1.vy * fy;
    var v2Tf:Number = b2.vx * fx + b2.vy * fy;
    
    // Compute alpha - the exchange scalar for Body b1.
    var alpha:Number = 2.0 * (v1Tf - v2Tf);
    alpha = alpha / (1 + b1.mass / b2.mass);
    
    // Compute beta - the exchange scalar for Body b2.
    var beta:Number = b1.mass * alpha / b2.mass;
    
    // Update velocities with a momentum kick.
    b1.vx = b1.vx - alpha * fx;
    b1.vy = b1.vy - alpha * fy;
    
    b2.vx = b2.vx + beta * fx;
    b2.vy = b2.vy + beta * fy;
    
    // Restore tangency between the two Bodies so that they no longer collide.
    var excess_distance:Number = (b1.collision_radius + b2.collision_radius - d);      
    var frac1:Number = b2.mass / (b1.mass+b2.mass);
    var frac2:Number = 1-frac1;
      
    b1.rx = b1.rx - fx*excess_distance*frac1;
    b1.ry = b1.ry - fy*excess_distance*frac1;
      
    b2.rx = b2.rx + fx*excess_distance*frac2;
    b2.ry = b2.ry + fy*excess_distance*frac2;    
    }    
  
  
  
    
  public function findBody(x:Number, y:Number) : Body
    {
    // Search through the Arrays to find the object under this (x,y) position.	
    var foundBody : Body;
        
    // Search through asteroids Array.
    for (var a:Number = 0; a < asteroids.length; a++)
      {
      foundBody = asteroids[a];	
      var dx:Number = foundBody.rx - x;
      var dy:Number = foundBody.ry - y;
      var d:Number = Math.sqrt(dx*dx + dy*dy);    	
      if (d < foundBody.collision_radius)
        {
        _root.cout.text = "Reticled on Asteroid " + a;
        return foundBody;
        }
      }
    
    // Search through spices Array.
    for (var s:Number = 0; s < spices.length; s++)
      {
      foundBody = spices[s];	
      var dx:Number = foundBody.rx - x;
      var dy:Number = foundBody.ry - y;
      var d:Number = Math.sqrt(dx*dx + dy*dy);    	
      if (d < foundBody.collision_radius)
        {
        _root.cout.text = "Reticled on Spice " + s;	
        return foundBody;
        }
      } 
    
    // Search through homebases Array.
    for (var hb:Number = 0; hb < homebases.length; hb++)
      {
      foundBody = homebases[hb];	
      var dx:Number = foundBody.rx - x;
      var dy:Number = foundBody.ry - y;
      var d:Number = Math.sqrt(dx*dx + dy*dy);    	
      if (d < foundBody.collision_radius)
        {
        _root.cout.text = "Reticled on HomeBase " + hb;		
        return foundBody;
        }
      }
    
    // Search through ships Array.
    for (var sh:Number = 0; sh < ships.length; sh++)
      {
      foundBody = ships[sh];	
      var dx:Number = foundBody.rx - x;
      var dy:Number = foundBody.ry - y;
      var d:Number = Math.sqrt(dx*dx + dy*dy);    	
      if (d < foundBody.collision_radius)
        {
        _root.cout.text = "Reticled on Ship " + sh;		
        return foundBody;
        }
      }
      
    _root.cout.text = "No Body was found at (" + x + "," + y + ")";  
    }
  
  
  public function initializeMap ()
    {    
    map = new NavigationMap;
    // Initialize the triangulation with the convex hull - conveniently defined by the homebases.
    map.triangles.push (new Triangle(homebases[0], homebases[2], homebases[1]) );
    map.triangles[0].computeAngles();
    map.triangles[0].ID = 0;
    map.triangles.push (new Triangle(homebases[2], homebases[0], homebases[3]) );
    map.triangles[1].computeAngles();
    map.triangles[1].ID = 1;    

    var e:Edge;
    
    e = new Edge;
    e.B1 = homebases[2];
    e.B2 = homebases[0];
    e.Tleft = map.triangles[0];
    e.Tright = map.triangles[1];
    map.edges.push(e);
    
    e = new Edge;
    e.B1 = homebases[2];
    e.B2 = homebases[1];
    e.Tleft = null;
    e.Tright = map.triangles[0];
    map.edges.push(e);
    
    e = new Edge;
    e.B1 = homebases[2];
    e.B2 = homebases[3];
    e.Tleft = map.triangles[1];
    e.Tright = null;
    map.edges.push(e);
    
    e = new Edge;
    e.B1 = homebases[3];
    e.B2 = homebases[0];
    e.Tleft = map.triangles[1];
    e.Tright = null;
    map.edges.push(e);
    
    e = new Edge;
    e.B1 = homebases[0];
    e.B2 = homebases[1];
    e.Tleft = map.triangles[0];
    e.Tright = null; 
    map.edges.push(e);
    
    for (var i:Number=0; i < map.edges.length; i++)
      map.edges[i].ID = i;
    
    map.triangles[0].edgeAB = map.edges[0];
    map.triangles[0].edgeBC = map.edges[1];
    map.triangles[0].edgeCA = map.edges[4];    
    
    map.triangles[1].edgeAB = map.edges[0];
    map.triangles[1].edgeBC = map.edges[3];
    map.triangles[1].edgeCA = map.edges[2];        
    // Add asteroids to NavigationMap
    
    for (var a:Number=0; a < asteroids.length; a++)
     map.insert (asteroids[a]);
    
    map.cleanUp();        
    map.draw();
    }
  
  public function onKeyUp() : Void
      {	         
	  var kc:Number = Key.getCode();
	  switch (kc) 
	    {
	    case (Key.UP): 
	    case (Key.DOWN):
	      ships[0].reticle.stickUpDown(0);
	    break;			
	    
	    case (Key.LEFT) : 
	    case (Key.RIGHT) : 
	      ships[0].reticle.stickLeftRight(0);
	    break;
	    }
	  }

   
	
   public function onKeyDown() : Void
	  {	  	 
	  var kc:Number = Key.getCode();
	  switch (kc) 
	    {
	    case (Key.UP): 
	      ships[0].reticle.stickUpDown(-1);
	    break;
	    case (Key.DOWN):
	      ships[0].reticle.stickUpDown(1);
	    break;				    
	    case (Key.LEFT): 
	       ships[0].reticle.stickLeftRight(-1);
	    break;  
	    case (Key.RIGHT): 
	       ships[0].reticle.stickLeftRight(1);	
	    break;
	    case (Key.SPACE):
	       findBody (ships[0].reticle.rx, ships[0].reticle.ry);
	    break; 
	    }	    
	  }			 
    
  }