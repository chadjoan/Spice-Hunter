package play
{

import play.Ship;

import flash.display.Bitmap;
import flash.display.Sprite;

// Computer player ship - has some basic AI.
public class CPUShip extends Ship
  {   
  public var desired_Body:Body;    // The object we are chasing.
  private var desired_vx:Number;   // The direction/speed that we'd like to be going.
  private var desired_vy:Number;	  
  
  // A neighborhood of objects, unit vector directions to these objects, and ranges.   
  // These are set by the "computeVelocityAndNeighborhood" method.
  private var bodyBuffer : Array;
  private var normals_x:Array;
  private var normals_y:Array;
  private var normals_L:Array;
    
  private var reticleAI : ReticleAI;  // Reticle helper logic.
  // The spot that the reticle is trying to reach is reticleAI.target
  
  // Objectives for CPU ships - finding spice (and disrupting enemy activities?)
  private static var GOAL_FIND_HOMEBASE : Number;
  private static var GOAL_FIND_SPICE : Number;
  private static var GOAL_NONE : Number;
  private static var GOAL_SUCK_SPICE_INTO_HOMEBASE : Number;
  
  private var goal_state:Number;
  
  public var goal_countdown : Number;
  // If a CPU ship fails to meet its goal in a certain amount of time, they give up and start over from scratch.
  
  // Finite state machine - names of each state for clarity.  
  private static var GOAL_DECIDING : Number;
  private static var NAVIGATION_DECIDING : Number;
  private static var NAVIGATION_WAITING : Number;
  private static var NAVIGATION_MOVING : Number;  
  private static var NAVIGATION_PROJECT_DECIDE:Number;
  private static var NAVIGATION_PROJECT_PUSH:Number;
  private static var NAVIGATION_PROJECT_PULL:Number;
  private static var NAVIGATION_DETONATE_ASTEROID_DECIDE:Number;
  private static var NAVIGATION_RETICLE_TO_DESIRED:Number;  
  private static var NAVIGATION_RETICLE_TO_SUCK: Number;
  // This AI opponents current state.
  private var ai_state:Number;
  
  // Various "moveCodes" - so the agent can remember what was just trying to do (really, another state variable).
  private static var HOLD_REPEL_MOVE_GRAVITY : Number;
  private static var RELEASE_REPEL_MOVE_GRAVITY: Number;
  private static var HOLD_GRAVITY_MOVE_REPEL: Number;
  private static var RELEASE_GRAVITY_MOVE_REPEL: Number;
  private static var NOMOVE: Number;        
  // Indicates what action should be performed once the reticle is on reticleSpot.
  private var moveCode:Number;	
  	
  public function CPUShip (_spec:ShipSpec, env_reference : Environment)
    {    
    super(_spec,env_reference);    
    
    // Initialize AI members.    
    desired_vx = 0;
    desired_vy = 0;
    
    reticleAI = new ReticleAI(this);
    
    GOAL_DECIDING = 0;                 // Picking a goal.
    NAVIGATION_DECIDING = 1;           // Deciding state - both beams are on one target, we are adrift, move one beam.
    NAVIGATION_WAITING = 2;            // Waiting state - reticle is in transit.
    NAVIGATION_MOVING = 3;             // Moving state - beams are on different objects and we are scooting.      
    NAVIGATION_PROJECT_DECIDE = 4;     // Projection decision state - beams are on same target and we are cutting error along beam axis.
    NAVIGATION_PROJECT_PULL = 5;       // Projection decided we should pull into our target.
    NAVIGATION_PROJECT_PUSH = 6;       // Projection decided we should push away from our target.
    NAVIGATION_DETONATE_ASTEROID_DECIDE = 7;  // We just finished projection. Should be try to blow up this asteroid with our gravity device?
    NAVIGATION_RETICLE_TO_DESIRED = 8; // Put the reticle on a target - we plan to tether it.
    NAVIGATION_RETICLE_TO_SUCK = 9;    // Put the reticle on homebase, we will suck spice into it.
    
    ai_state = GOAL_DECIDING;
        
    GOAL_FIND_HOMEBASE = 0;
    GOAL_FIND_SPICE = 1;
    GOAL_SUCK_SPICE_INTO_HOMEBASE = 2;
    
    GOAL_NONE = 4;    
    
    goal_state = GOAL_NONE;  // you gotta have goals in life, son
    
    desired_Body = null;
   
    HOLD_REPEL_MOVE_GRAVITY = 0;
    RELEASE_REPEL_MOVE_GRAVITY = 1;
    HOLD_GRAVITY_MOVE_REPEL = 2;    
    RELEASE_GRAVITY_MOVE_REPEL = 3;
    NOMOVE = 4;
              
    goal_countdown = 0;           
    }
  
  // The oh-shit function.
  public override function triggerReset(eventCode : Number) : void
    {      	    
    super.triggerReset(eventCode);
    
    switch (eventCode)
      {
      case Ship.GRAVITY_SNAP_EVENT:
      case Ship.REPEL_SNAP_EVENT:
      	repelBeam.target = null;
        attractBeam.target = null;         
        moveCode = NOMOVE;           	
        ai_state = NAVIGATION_DECIDING;	                
      break;
       	
      case Ship.TETHER_SNAP_EVENT:    
      case Ship.GOAL_COUNTDOWN_EVENT:  	    
        repelBeam.target = null;
        attractBeam.target = null;         
        moveCode = NOMOVE;     
      	desired_Body = null;
        ai_state = GOAL_DECIDING;	
        goal_state = GOAL_NONE;
        tether.setTarget(null);
      break;
      }    
    
    }
  
  public function computeRange() : Number
    {
    var dx:Number = desired_Body.rx - rx;
    var dy:Number = desired_Body.ry - ry;
    var L:Number = Math.sqrt( dx * dx + dy*dy);    	 
    return L;  
    }

  
  public function updateAI () : void
    {
    if (goal_countdown > 0)	
      goal_countdown--;
    
    if (goal_countdown == 0)                  
      triggerReset (Ship.GOAL_COUNTDOWN_EVENT);      
      
    	
    // Sketch desired body.        
    // commented out this debug code - Chad
    /*if (desired_Body != null)
      if (!desired_Body.isExpired)
        {
        switch (spec.teamCode)
          {	    
          case ShipSpec.RED_TEAM: Screen.hud.graphics.lineStyle(1, 0xFF0000, 0.5); break;
          case ShipSpec.BLUE_TEAM: Screen.hud.graphics.lineStyle(1, 0x0000FF, 0.5); break;
          case ShipSpec.GREEN_TEAM: Screen.hud.graphics.lineStyle(1, 0x00FF00, 0.5); break;
          case ShipSpec.YELLOW_TEAM: Screen.hud.graphics.lineStyle(1, 0xFFFF00, 0.5); break;
          }          
	    Screen.hud.graphics.moveTo(desired_Body.rx-10,desired_Body.ry-10);
	    Screen.hud.graphics.lineTo(desired_Body.rx+10,desired_Body.ry+10);
	    Screen.hud.graphics.moveTo(desired_Body.rx-10,desired_Body.ry+10);
	    Screen.hud.graphics.lineTo(desired_Body.rx+10,desired_Body.ry-10);	        
        }
    */
    
    // Just switch on ai_state and pick the method that implements this state.	
    switch (ai_state)
      {
      case GOAL_DECIDING:
        do_GOAL_DECIDING();	        
      break;	
      
      case NAVIGATION_DECIDING:
      	do_NAVIGATION_DECIDING();      	
      break;	
      
      case NAVIGATION_WAITING:
        do_NAVIGATION_WAITING();        
      break;	
      
      case NAVIGATION_MOVING: 
        do_NAVIGATION_MOVING();
      break;
      
      case NAVIGATION_PROJECT_DECIDE:
      	do_NAVIGATION_PROJECT_DECIDE();
      break;
      
      case NAVIGATION_PROJECT_PUSH:
      	do_NAVIGATION_PROJECT_PUSH();
      break;
      
      case NAVIGATION_PROJECT_PULL:
      	do_NAVIGATION_PROJECT_PULL();
      break;
      
      case NAVIGATION_DETONATE_ASTEROID_DECIDE:
      	do_NAVIGATION_DETONATE_ASTEROID_DECIDE();
      break;     
      
      case NAVIGATION_RETICLE_TO_DESIRED:
      	do_NAVIGATION_RETICLE_TO_DESIRED();
      break;
      
      case NAVIGATION_RETICLE_TO_SUCK:
      	do_NAVIGATION_RETICLE_TO_SUCK();
      break;
      
      }
    
    // Update reticleAI.
    reticleAI.update();      
    }
  
  
  public function compute_best_spice() : Body
    {
    // For computing nearest/best desired_Body.
    var nearest_length : Number = 0;
    var temp_length:Number = 0;	
    var i:Number;   
    var j:Number;	
    	
    var answer:Body = null;
    
    for (i = 0; i < env.spices.length; i++)
      {          
      // Candidate spice must be:
      // 1. Not expired.
      // 2. At least 250 units away from all allied homebases.
      // 3. Close to us.
      // 4. Have few other players tethering it.
      var closeToBase:Boolean = false;
      for (j = 0; j < env.homebases.length; j++)      
        if (env.homebases[j].spec.teamCode == this.spec.teamCode)
          {
          temp_length = Math.sqrt( (env.spices[i].rx - env.homebases[j].rx)*(env.spices[i].rx - env.homebases[j].rx) + (env.spices[i].ry - env.homebases[j].ry)*(env.spices[i].ry - env.homebases[j].ry) ); 	
          if (temp_length < 250)
            closeToBase = true;
          }                      
      if (!closeToBase && !env.spices[i].isExpired )
        {
        // This spice is a candidate for retrieval. Is it closer than the current candidate?
        if (answer == null)
          {
          answer = env.spices[i];
          nearest_length = Math.sqrt( (answer.rx - rx)*(answer.rx - rx) + (answer.ry - ry)*(answer.ry - ry) );		
          // Add "penalty length" if unallied players have this spice tethered.
          for (j = 0; j < env.ships.length; j++)
            if (env.ships[j].tether.target == env.spices[i] && env.ships[j].spec.teamCode != this.spec.teamCode)
              nearest_length = nearest_length + 150.0 + (env.ships[j].spec.tetherLevel / 10.0)*150;
          }
        else
          {
          temp_length = Math.sqrt( (env.spices[i].rx - rx)*(env.spices[i].rx - rx) + (env.spices[i].ry - ry)*(env.spices[i].ry - ry) ); 	
          // Add "penalty length" if unallied players have this spice tethered.
          for (j = 0; j < env.ships.length; j++)
            if (env.ships[j].tether.target == env.spices[i] && env.ships[j].spec.teamCode != this.spec.teamCode)
              temp_length = temp_length + 150.0 + (env.ships[j].spec.tetherLevel / 10.0)*150;              
          if (temp_length < nearest_length)
            {
            nearest_length = temp_length;
            answer = env.spices[i];
            }	
          }                 
        }
      }
    return answer;    
    }
  
  public function do_GOAL_DECIDING() : void
    {
    // If the desired_Body is expired, set it to null.	
    if (desired_Body != null) 
      if (desired_Body.isExpired)
        desired_Body = null;
    
    // If the desired_Body is null, set goal_state to no goal, to trigger a reset.
    if (desired_Body == null)	
      goal_state = GOAL_NONE;
      
    // For computing nearest/best desired_Body.
    var nearest_length : Number = 0;
    var temp_length:Number = 0;	
    var i:Number;   
    var j:Number;
    var dx:Number = 0;
    var dy:Number = 0;
    var dl:Number = 0;
    var dot:Number = 0;
   
    switch(goal_state)
      {
      case GOAL_NONE:
        // No current goal. 
        
        // Is there any spice near an allied homebase? ... suck it in.
        // Search over allied homebases.
        if (gravBomb.isReady () )
        for (i = 0; i < env.homebases.length; i++)
          if (env.homebases[i].spec.teamCode == this.spec.teamCode)
            {
            // Search over spices.
            for (j = 0; j < env.spices.length; j++)
            if (!env.spices[j].isExpired)
              {
              dx = -env.spices[j].rx + env.homebases[i].rx;
              dy = -env.spices[j].ry + env.homebases[i].ry;
              dl = Math.sqrt ( dx*dx + dy*dy);              
              if (dl < 200)
                {
                // Check the velocity of this spice - is it already going in?
                dot = dx/dl * env.spices[j].vx + dy/dl*env.spices[j].vy;                
                if (dot < 1.0) // Closing at slower than 1.0 pixel per frame... we'll help it with a suck-bomb.
                  { 	                  
                  // desired_Body = env.homebases[i];
                  desired_Body = new DummyMapNode ( (env.homebases[i].rx + env.spices[j].rx)/2.0 , 
                                                    (env.homebases[i].ry + env.spices[j].ry)/2.0 );
                  
                  
                  goal_state = GOAL_SUCK_SPICE_INTO_HOMEBASE;	
                  ai_state = NAVIGATION_RETICLE_TO_SUCK;
                  reticleAI.setTarget(desired_Body);
                  goal_countdown = 500;
                  return;
                  }
                }
              }
            }
        
        
        // If that didn't pan out, pick some nearby spice to chase.
        desired_Body = compute_best_spice();                                         
        if (desired_Body != null)   
          {
          goal_state = GOAL_FIND_SPICE;
          ai_state = NAVIGATION_DECIDING;
          goal_countdown = 10;                    
          return;
          }
      break;     
         
      case GOAL_FIND_SPICE:
        // Goal was to find spice - now some spice is tethered. Let's find an allied homebase to bring it home to.
        desired_Body = null;               
        for (i = 0; i < env.homebases.length; i++)
          if (desired_Body == null && env.homebases[i].spec.teamCode == this.spec.teamCode)
            {
            desired_Body = env.homebases[i];
            nearest_length = Math.sqrt( (desired_Body.rx - rx)*(desired_Body.rx - rx) + (desired_Body.ry - ry)*(desired_Body.ry - ry) );
            }
          else
            {
            temp_length = Math.sqrt( (env.homebases[i].rx - rx)*(env.homebases[i].rx - rx) + (env.homebases[i].ry - ry)*(env.homebases[i].ry - ry) ); 	
            if (temp_length < nearest_length && env.homebases[i].spec.teamCode == this.spec.teamCode)
              {
              nearest_length = temp_length;
              desired_Body = env.homebases[i];
              }
            }
        if (desired_Body != null)   
          {
          goal_state = GOAL_FIND_HOMEBASE;
          ai_state = NAVIGATION_DECIDING;          
          goal_countdown = 500;
          return;
          }                    
      break;  
      
      case GOAL_SUCK_SPICE_INTO_HOMEBASE:
      	// Is there any spice near desired_Body? (it's an allied homebase) ... suck it in.
      	// This might not always be the case, if spice has already drifted in, or drifted too far away.      
        // Search over spices.                
        for (j = 0; j < env.spices.length; j++)
          {
          dx = -env.spices[j].rx + desired_Body.rx;
          dy = -env.spices[j].ry + desired_Body.ry;
          dl = Math.sqrt ( dx*dx + dy*dy);              
          if (dl < 200)
            {
            // Check the velocity of this spice - is it already going in?
            dot = dx/dl * env.spices[j].vx + dy/dl*env.spices[j].vy;            
            if (dot < 1.0) // Closing at slower than 1.0 pixel per frame... we'll help it with a suck-bomb.
              { 	
              // Set off the bomb.
              gravBomb.detonate (reticle.rx, reticle.ry);
              goal_state = GOAL_NONE;	
              ai_state = GOAL_DECIDING;
              goal_countdown = 0;
              desired_Body = null;
              reticleAI.setTarget(null);
              return;
              }
            }
          }    
        goal_state = GOAL_NONE;	
        ai_state = GOAL_DECIDING;
        goal_countdown = 0;
        desired_Body = null;
        reticleAI.setTarget(null)    	            	
      break; 	
      
      }   
   
    if (goal_state == GOAL_NONE)
      {
      repelBeam.target = null;
      attractBeam.target = null;
      reticleAI.setTarget(null);  
      goal_countdown = 0;    
      }
    }
    
    
      
  public function do_NAVIGATION_DECIDING() : void
    {
    
    	
    // Assert preconditions - we must be chasing a non-null desired_Body.
    if (desired_Body == null)
      {
      ai_state = GOAL_DECIDING;
      return;	
      }
   
    // Assert preconditions - we must be chasing a non-expired desired_Body.
    if (desired_Body.isExpired)
      {
      ai_state = GOAL_DECIDING;
      desired_Body = null;
      return;	
      }

    // Some snippets of code to break out if we are close to goal states ...  ...
    
    // Case 1: If we are spice-hunting and are close to our desired_Body, reticle onto it.                
    var D:Number = computeRange();
    if (goal_state == GOAL_FIND_SPICE && D < 75 )
      {
      ai_state = NAVIGATION_RETICLE_TO_DESIRED;      
      reticleAI.setTarget(desired_Body);      
      return;
      }
   
    // Case 2: We are dragging spice and are close to homebase.
    if (goal_state == GOAL_FIND_HOMEBASE)
      {            
      // Compute distance from spice to homebase.
      var hx:Number = desired_Body.rx - tether.target.rx;
      var hy:Number = desired_Body.ry - tether.target.ry;
      var hl:Number = Math.sqrt(hx*hx + hy*hy);
      hx /= hl;
      hy /= hl;      
      if (hl < 250)
        {      	
        // Check if the current velocity of the spice will pass through the homebase.
        var collisionPossible:Boolean = false;          
        var vl:Number = Math.sqrt(tether.target.vx*tether.target.vx + tether.target.vy*tether.target.vy);
        var greedyDot : Number = (tether.target.vx*hx + tether.target.vy*hy) / vl;
        if (greedyDot > 0.3)
          {	      
          // Compute perpendicular distance from the extrapolated path of the spice to the homebase.
          var orthogonal_x:Number = hx*hl - greedyDot*tether.target.vx/vl*hl;
          var orthogonal_y:Number = hy*hl - greedyDot*tether.target.vy/vl*hl;                    
          var orthogonal_L:Number = Math.sqrt (orthogonal_x*orthogonal_x + orthogonal_y*orthogonal_y);
          if (orthogonal_L < desired_Body.collision_radius + tether.target.collision_radius)
            collisionPossible = true;                          
          if (collisionPossible)
            {        
            // Let go of the spice.
            tether.setTarget(null);	          
            goal_state = GOAL_NONE;
            ai_state = GOAL_DECIDING;
            desired_Body = null;
            return;
            }
          }
        }
      }
   
   
   
    // ...  ... otherwise continue chasing desired_Body
    
    var i:Number;    
    var best:Number;
    var L:Number;   
    
    computeVelocityAndNeighborhood();
    
    // Sketch desired_vx, desired_vy.
    // Screen.hud.graphics.moveTo(rx,ry);
	// Screen.hud.graphics.lineTo(rx+desired_vx*100, ry+desired_vy*100);
        
    // Adjust velocity to avoid all other bodies - further away objects have less influence.
    // for (var i:Number = 0; i < bodyBuffer.length; i++)
    //  {
    //  desired_vx -= 50*normals_x[i]/normals_L[i];
    //  desired_vy -= 50*normals_y[i]/normals_L[i];
    //  }       
    
  
        
    // Compute the error between our current velocity and our desired velocity.
    var error_vx:Number = desired_vx - vx;
    var error_vy:Number = desired_vy - vy;   
    var E:Number = Math.sqrt(error_vx*error_vx + error_vy*error_vy);               
    
    // Compute current resultant force from gravity and repel beam.    
    var gravity_x:Number = 0;
    var gravity_y:Number = 0;
    if (attractBeam.target != null)
      {
      gravity_x = (attractBeam.target.rx - rx);
      gravity_y = (attractBeam.target.ry - ry);
      var G:Number = Math.sqrt(gravity_x*gravity_x + gravity_y*gravity_y);        
      gravity_x = gravity_x / G * attractBeam.strength;
      gravity_y = gravity_y / G * attractBeam.strength;
      }
     
    
   
    var repel_x:Number = 0;     
    var repel_y:Number = 0; 
    if (repelBeam.target != null) 
      {
      repel_x = -(repelBeam.target.rx - rx);
      repel_y = -(repelBeam.target.ry - ry);
      var R:Number = Math.sqrt(repel_x*repel_x + repel_y*repel_y);        
      repel_x = repel_x / R * repelBeam.strength;
      repel_y = repel_y / R * repelBeam.strength;           
      }

    // Create resultant.
    var resultant_x:Number = gravity_x + repel_x;
    var resultant_y:Number = gravity_y + repel_y;
    // Normalize resultant.
    var U:Number = Math.sqrt(resultant_x*resultant_x + resultant_y*resultant_y);
    if (U > 1e-3)
      {
      resultant_x /= U;
      resultant_y /= U;
      }
    else
      {
      resultant_x = 0;  
      resultant_y = 0;
      }        
    var currentDot:Number = resultant_x*error_vx/E + resultant_y*error_vy/E;
    
    
    
    // Look for gravity target which offers greatest improvement over currentDot, while leaving repel beam here.      
    var bestGravitySwitch:Body;
    var bestGravitySwitchDot:Number = currentDot;
    bestGravitySwitch = null;
    for (i = 0; i < bodyBuffer.length; i++)
      {
      resultant_x = normals_x[i]*attractBeam.strength + repel_x;
      resultant_y = normals_y[i]*attractBeam.strength + repel_y;	        
      U = Math.sqrt(resultant_x*resultant_x + resultant_y*resultant_y);
      if (U > 1e-3)
        {
        resultant_x /= U;
        resultant_y /= U;
        }
      else
        {
        resultant_x = 0;  
        resultant_y = 0;
        }        	
      var candidateGravityDot:Number = resultant_x*error_vx/E + resultant_y*error_vy/E;        
      if (candidateGravityDot > bestGravitySwitchDot)
        {
        bestGravitySwitch = bodyBuffer[i];
        bestGravitySwitchDot = candidateGravityDot;
        }
      }
    
    // Look for repel target which offers greatest improvement over current_dot, while leaving gravity beam here.
    var bestRepelSwitch:Body;
    var bestRepelSwitchDot:Number = currentDot;
    bestRepelSwitch = null;
    for (i = 0; i < bodyBuffer.length; i++)
      {                
      resultant_x = gravity_x - normals_x[i]*repelBeam.strength;
      resultant_y = gravity_y - normals_y[i]*repelBeam.strength;	        
      U = Math.sqrt(resultant_x*resultant_x + resultant_y*resultant_y);
      if (U > 1e-3)
        {
        resultant_x /= U;
        resultant_y /= U;
        }
      else
        {
        resultant_x = 0;  
        resultant_y = 0;
        }        	
        	
      var candidateRepelDot:Number = resultant_x*error_vx/E + resultant_y*error_vy/E;        
      if (candidateRepelDot > bestRepelSwitchDot)
        {
        bestRepelSwitch = bodyBuffer[i];
        bestRepelSwitchDot = candidateRepelDot;
        }
      }        
    
    // Look for gravity target which offers greatest improvement over currentDot, while turning repel beam off.
    var bestGravity:Body;
    var bestGravityDot:Number = currentDot;
    bestGravity = null;
    for (i = 0; i < bodyBuffer.length; i++)
      {
      resultant_x = normals_x[i]*attractBeam.strength;
      resultant_y = normals_y[i]*attractBeam.strength;	        
      U = Math.sqrt(resultant_x*resultant_x + resultant_y*resultant_y);
      if (U > 1e-3)
        {
        resultant_x /= U;
        resultant_y /= U;
        }
      else
        {
        resultant_x = 0;  
        resultant_y = 0;
        }        	
      var candidateGravityDot2:Number = resultant_x*error_vx/E + resultant_y*error_vy/E;
      // Assets.root.cout.text += (" " + GeometryTests.threeDigits(candidateGravityDot));
      if (candidateGravityDot2 > bestGravityDot)
        {
        bestGravity = bodyBuffer[i];
        bestGravityDot = candidateGravityDot2;
        }
      } 
      
    // Look for repel target which offers greatest improvement over current_dot, while turning gravity beam off.
    var bestRepel:Body;
    var bestRepelDot:Number = currentDot;
    bestRepel = null;
    for (i = 0; i < bodyBuffer.length; i++)
      {                
      resultant_x = -normals_x[i]*repelBeam.strength;
      resultant_y = -normals_y[i]*repelBeam.strength;	        
      U = Math.sqrt(resultant_x*resultant_x + resultant_y*resultant_y);
      if (U > 1e-3)
        {
        resultant_x /= U;
        resultant_y /= U;
        }
      else
        {
        resultant_x = 0;  
        resultant_y = 0;
        }        	
      	
      var candidateRepelDot2:Number = resultant_x*error_vx/E + resultant_y*error_vy/E;
      // Assets.root.cout.text += (" " + GeometryTests.threeDigits(candidateRepelDot));
      if (candidateRepelDot2 > bestRepelDot)
        {
        bestRepel = bodyBuffer[i];
        bestRepelDot = candidateRepelDot2;
        }
      }  
    
    // Generate a table of results.
    var options:Array = new Array;
    var optionScores:Array = new Array;
    
    options[HOLD_GRAVITY_MOVE_REPEL] = bestRepelSwitch;
    optionScores[HOLD_GRAVITY_MOVE_REPEL] = bestRepelSwitchDot;
    
    options[HOLD_REPEL_MOVE_GRAVITY] = bestGravitySwitch;
    optionScores[HOLD_REPEL_MOVE_GRAVITY] = bestGravitySwitchDot;
     
    options[RELEASE_REPEL_MOVE_GRAVITY] = bestGravity;
    optionScores[RELEASE_REPEL_MOVE_GRAVITY] = bestGravityDot;
       
    options[RELEASE_GRAVITY_MOVE_REPEL] = bestRepel;
    optionScores[RELEASE_GRAVITY_MOVE_REPEL] = bestRepelDot;
     
    // Pick the best option.
    best = 0;
    for (i=1; i < options.length; i++)
      if (optionScores[i] > optionScores[best])
        best = i;
      
    if (options[best] != null)
      {      
      reticleAI.setTarget(options[best]);
      ai_state = NAVIGATION_WAITING;
      moveCode = best;               	
      }            	
            
    }
  
  
  public function do_NAVIGATION_WAITING() : void
    {
    // Assert precondition - we must be chasing a non-null desired_Body.
    if (desired_Body == null)
      {
      ai_state = GOAL_DECIDING;
      return;	
      }   
    // Assert precondition - we must be chasing a non-expired desired_Body.
    if (desired_Body.isExpired)
      {
      ai_state = GOAL_DECIDING;
      desired_Body = null;
      return;	
      }	    
    // Verified: we are chasing a valid desired_Body.
    
    
    // Assert precondition - we must be reticle-ing to a non-null reticleAI.target.
    if (reticleAI.target == null)
      {
      ai_state = NAVIGATION_DECIDING;      
      return;
      }
    // Assert precondition - we must be reticle-ing to a non-expired reticleAI.target.  
    if (reticleAI.target.isExpired)
      {
      ai_state = NAVIGATION_DECIDING;
      reticleAI.setTarget(null);
      return;	
      }
    // Verified: the reticle target is valid.
    
    
    if (reticleAI.isReady)
      {
      switch (moveCode)
        {
        case HOLD_REPEL_MOVE_GRAVITY:
          attractBeam.target = reticleAI.target;
        break;
          
        case RELEASE_REPEL_MOVE_GRAVITY:
          repelBeam.target = null;
          attractBeam.target = reticleAI.target;
        break;	  
          
        case HOLD_GRAVITY_MOVE_REPEL:          	
          repelBeam.target = reticleAI.target;
        break;	
          	
        case RELEASE_GRAVITY_MOVE_REPEL:
          attractBeam.target = null;
          repelBeam.target = reticleAI.target;
        break;    
        }           
      ai_state = NAVIGATION_MOVING;
      }    	
      
    }
  
  public function do_NAVIGATION_MOVING () : void
    {    	
    // Assert precondition - we must be chasing a non-null desired_Body.
    if (desired_Body == null)
      {
      ai_state = GOAL_DECIDING;
      return;	
      }   
    // Assert precondition - we must be chasing a non-expired desired_Body.
    if (desired_Body.isExpired)
      {
      ai_state = GOAL_DECIDING;
      desired_Body = null;
      return;	
      }	    
    // Verified: we are chasing a valid desired_Body.
    
       
    computeVelocityAndNeighborhood();           
    // Compute the error between our current velocity and our desired velocity.
    var error_vx:Number = desired_vx - vx;
    var error_vy:Number = desired_vy - vy;   
    var E:Number = Math.sqrt(error_vx*error_vx + error_vy*error_vy);               
    
    // Compute current resultant force from gravity and repel beam.    
    var gravity_x:Number = 0;
    var gravity_y:Number = 0;
    if (attractBeam.target != null)
      {
      gravity_x = (attractBeam.target.rx - rx);
      gravity_y = (attractBeam.target.ry - ry);
      var G:Number = Math.sqrt(gravity_x*gravity_x + gravity_y*gravity_y);        
      gravity_x = gravity_x / G * attractBeam.strength;
      gravity_y = gravity_y / G * attractBeam.strength;
      }
        
    var repel_x:Number = 0;     
    var repel_y:Number = 0; 
    if (repelBeam.target != null) 
      {
      repel_x = -(repelBeam.target.rx - rx);
      repel_y = -(repelBeam.target.ry - ry);
      var R:Number = Math.sqrt(repel_x*repel_x + repel_y*repel_y);        
      repel_x = repel_x / R * repelBeam.strength;
      repel_y = repel_y / R * repelBeam.strength;           
      }

    // Create resultant.
    var resultant_x:Number = gravity_x + repel_x;
    var resultant_y:Number = gravity_y + repel_y;
    // Normalize resultant.
    var U:Number = Math.sqrt(resultant_x*resultant_x + resultant_y*resultant_y);
    if (U > 1e-3)
      {
      resultant_x /= U;
      resultant_y /= U;
      }
    else
      {
      resultant_x = 0;  
      resultant_y = 0;
      }
        
    var currentDot:Number = resultant_x*error_vx/E + resultant_y*error_vy/E;        
    
    // Stay in the move state as long as it's helping reduce the error significantly.
    if (currentDot < 0.8 )
      {
      // If the reticleAI.target is still valid, then we can advance to NAVIGATION_PROJECT_DECIDE.
      // Otherwise we regress back into NAVIGATION_DECIDE.
            
      if (reticleAI.target == null)
        {
        ai_state = NAVIGATION_DECIDING;    
        return;
        }      
      if (reticleAI.target.isExpired)
        {
        ai_state = NAVIGATION_DECIDING;
        reticleAI.setTarget(null);
        return;	
        }
      // The reticle target is valid.            
      repelBeam.target = reticleAI.target;
      attractBeam.target = reticleAI.target;       	      
      ai_state = NAVIGATION_PROJECT_DECIDE;                                         
      //ai_state = NAVIGATION_DECIDING;
      }                                    
    }
  
  
  public function do_NAVIGATION_PROJECT_DECIDE () : void
    {
    // Assert precondition - we must be chasing a non-null desired_Body.
    if (desired_Body == null)
      {
      ai_state = GOAL_DECIDING;
      return;	
      }   
    // Assert precondition - we must be chasing a non-expired desired_Body.
    if (desired_Body.isExpired)
      {
      ai_state = GOAL_DECIDING;
      desired_Body = null;
      return;	
      }	    
    // Verified: we are chasing a valid desired_Body.
        
    // Assert precondition - we must be reticle-ing to a non-null reticleAI.target.
    if (reticleAI.target == null)
      {
      ai_state = NAVIGATION_DECIDING;      
      return;
      }
    // Assert precondition - we must be reticle-ing to a non-expired reticleAI.target.  
    if (reticleAI.target.isExpired)
      {
      ai_state = NAVIGATION_DECIDING;
      reticleAI.setTarget(null);
      return;	
      }
    // Verified: the reticle target is valid.
        
    computeVelocityAndNeighborhood();           
    // Compute the error between our current velocity and our desired velocity.
    var error_vx:Number = desired_vx - vx;
    var error_vy:Number = desired_vy - vy;   
    var E:Number = Math.sqrt(error_vx*error_vx + error_vy*error_vy); 
           
    var beamaxis_x:Number;
    var beamaxis_y:Number;
    var B:Number;    
    var errorDot:Number;
                  
    beamaxis_x = reticleAI.target.rx - rx;
    beamaxis_y = reticleAI.target.ry - ry;                
    B = Math.sqrt (beamaxis_x*beamaxis_x + beamaxis_y*beamaxis_y);
    beamaxis_x /= B;
    beamaxis_y /= B;            
    
    // Take dot product.
    errorDot = (error_vx * beamaxis_x + error_vy * beamaxis_y);
      
    ai_state = NAVIGATION_DECIDING;      
    if (errorDot > 0 && Math.abs(errorDot) > attractBeam.strength)        
      ai_state = NAVIGATION_PROJECT_PULL;
    if (errorDot < 0 && Math.abs(errorDot) > repelBeam.strength)        
      ai_state = NAVIGATION_PROJECT_PUSH;           

    // Subtract - hey no cheating!
    // vx += errorDot*beamaxis_x;
    // vy += errorDot*beamaxis_y;
    }
  
    
  public function do_NAVIGATION_PROJECT_PUSH () : void
    {
    // Assert precondition - we must be chasing a non-null desired_Body.
    if (desired_Body == null)
      {
      ai_state = GOAL_DECIDING;
      return;	
      }   
    // Assert precondition - we must be chasing a non-expired desired_Body.
    if (desired_Body.isExpired)
      {
      ai_state = GOAL_DECIDING;
      desired_Body = null;
      return;	
      }	    
    // Verified: we are chasing a valid desired_Body.
        
    // Assert precondition - we must be reticle-ing to a non-null reticleAI.target.
    if (reticleAI.target == null)
      {
      ai_state = NAVIGATION_DECIDING;      
      return;
      }
    // Assert precondition - we must be reticle-ing to a non-expired reticleAI.target.  
    if (reticleAI.target.isExpired)
      {
      ai_state = NAVIGATION_DECIDING;                 
      reticleAI.setTarget(null);
      return;	
      }
    // Verified: the reticle target is valid.	
    
    computeVelocityAndNeighborhood();           
    // Compute the error between our current velocity and our desired velocity.
    var error_vx:Number = desired_vx - vx;
    var error_vy:Number = desired_vy - vy;   
    var E:Number = Math.sqrt(error_vx*error_vx + error_vy*error_vy); 
    
    var beamaxis_x:Number;
    var beamaxis_y:Number;
    var B:Number;    
    var errorDot:Number;      
    // Remove the error component along the beam direction.
    beamaxis_x = reticleAI.target.rx - rx; 
    beamaxis_y = reticleAI.target.ry - ry;
    // Normalize.
    B = Math.sqrt (beamaxis_x*beamaxis_x + beamaxis_y*beamaxis_y);
    beamaxis_x /= B;
    beamaxis_y /= B;            
    // Take dot product.
    errorDot = (error_vx * beamaxis_x + error_vy * beamaxis_y);	                  
    attractBeam.target = null;
    if (errorDot >= 0)
      {
      attractBeam.target = reticleAI.target; 	
      if (attractBeam.target == null)
        repelBeam.target = null;
      // ai_state = NAVIGATION_DECIDING;      
      // Gravity bomb usage?
      ai_state = NAVIGATION_DETONATE_ASTEROID_DECIDE;
      }
    	    	
    }
  
  
  public function do_NAVIGATION_PROJECT_PULL () : void
    {
    // Assert precondition - we must be chasing a non-null desired_Body.
    if (desired_Body == null)
      {
      ai_state = GOAL_DECIDING;
      return;	
      }   
    // Assert precondition - we must be chasing a non-expired desired_Body.
    if (desired_Body.isExpired)
      {
      ai_state = GOAL_DECIDING;
      desired_Body = null;
      return;	
      }	    
    // Verified: we are chasing a valid desired_Body.
        
    // Assert precondition - we must be reticle-ing to a non-null reticleAI.target.
    if (reticleAI.target == null)
      {
      ai_state = NAVIGATION_DECIDING;      
      return;
      }
    // Assert precondition - we must be reticle-ing to a non-expired reticleAI.target.  
    if (reticleAI.target.isExpired)
      {
      ai_state = NAVIGATION_DECIDING;
      reticleAI.setTarget(null);
      return;	
      }
    // Verified: the reticle target is valid.	
    
    computeVelocityAndNeighborhood();           
    // Compute the error between our current velocity and our desired velocity.
    var error_vx:Number = desired_vx - vx;
    var error_vy:Number = desired_vy - vy;   
    var E:Number = Math.sqrt(error_vx*error_vx + error_vy*error_vy); 
    
    var beamaxis_x:Number;
    var beamaxis_y:Number;
    var B:Number;    
    var errorDot:Number;      
    
    // Remove the error component along the beam direction.
    beamaxis_x = reticleAI.target.rx - rx; 
    beamaxis_y = reticleAI.target.ry - ry;
    // Normalize.
    B = Math.sqrt (beamaxis_x*beamaxis_x + beamaxis_y*beamaxis_y);
    beamaxis_x /= B;
    beamaxis_y /= B;            
    // Take dot product.
    errorDot = (error_vx * beamaxis_x + error_vy * beamaxis_y);	
    repelBeam.target = null;
    if (errorDot <= 0)
      {
      repelBeam.target = reticleAI.target; 	
      if (repelBeam.target == null)
        attractBeam.target = null;
      // ai_state = NAVIGATION_DECIDING;      
      // Gravity bomb usage?
      ai_state = NAVIGATION_DETONATE_ASTEROID_DECIDE;
      }
    	
    }
  
  public function do_NAVIGATION_DETONATE_ASTEROID_DECIDE() : void
    {
    // Assert precondition - we must be chasing a non-null desired_Body.
    if (desired_Body == null)
      {
      ai_state = GOAL_DECIDING;
      return;	
      }   
    // Assert precondition - we must be chasing a non-expired desired_Body.
    if (desired_Body.isExpired)
      {
      ai_state = GOAL_DECIDING;
      desired_Body = null;
      return;	
      }	    
    // Verified: we are chasing a valid desired_Body.
        
    // Assert precondition - we must be reticle-ing to a non-null reticleAI.target.
    if (reticleAI.target == null)
      {
      ai_state = NAVIGATION_DECIDING;      
      return;
      }
    // Assert precondition - we must be reticle-ing to a non-expired reticleAI.target.  
    if (reticleAI.target.isExpired)
      {
      ai_state = NAVIGATION_DECIDING;
      reticleAI.setTarget(null);
      return;	
      }
    // Verified: the reticle target is valid.	
    
    // Search for asteroids within a range of the reticle.    
    var radius : Number = 100;
    var asteroidcount : Number = 0;
    for (var i:Number = 0; i < env.asteroids.length; i++)
      {
      var dx:Number = env.asteroids[i].rx - reticle.rx;
      var dy:Number = env.asteroids[i].ry - reticle.ry;
      var dl:Number = Math.sqrt (dx*dx + dy*dy);
      if (dl < radius)
        asteroidcount++;
      }
    // Decide if we should use a bomb. If there are enough asteroids in the neighborhood, set it off.    
    if (asteroidcount > 3)
      if (gravBomb.isReady() )
        gravBomb.detonate(reticle.rx, reticle.ry);              
    ai_state = NAVIGATION_DECIDING;	
    }
  
  public function do_NAVIGATION_RETICLE_TO_SUCK () : void
    {        
    // Assert precondition - we must be chasing a non-null desired_Body.
    if (desired_Body == null)
      {
      ai_state = GOAL_DECIDING;
      return;	
      }   
    // Assert precondition - we must be chasing a non-expired desired_Body.
    if (desired_Body.isExpired)
      {
      ai_state = GOAL_DECIDING;
      desired_Body = null;
      return;	
      }
    // Verified: we are chasing a valid desired_Body.

    // Assert precondition - we must be reticle-ing to a non-null reticleAI.target.
    if (reticleAI.target == null)
      {
      ai_state = NAVIGATION_DECIDING;      
      return;
      }
    // Assert precondition - we must be reticle-ing to a non-expired reticleAI.target.  
    if (reticleAI.target.isExpired)
      {
      ai_state = NAVIGATION_DECIDING;
      reticleAI.setTarget(null);
      return;	
      }
    // Verified: the reticle target is valid.	

    // Blow up a bomb when reticle arrives on it. (handled in do_GOAL_DECIDE)
    if (reticleAI.isReady)                    
      ai_state = GOAL_DECIDING;
      
      
    }
  
  public function do_NAVIGATION_RETICLE_TO_DESIRED () : void
    {
    // Assert precondition - we must be chasing a non-null desired_Body.
    if (desired_Body == null)
      {
      ai_state = GOAL_DECIDING;
      return;	
      }   
    // Assert precondition - we must be chasing a non-expired desired_Body.
    if (desired_Body.isExpired)
      {
      ai_state = GOAL_DECIDING;
      desired_Body = null;
      return;	
      }
    // Verified: we are chasing a valid desired_Body.

    // Assert precondition - we must be reticle-ing to a non-null reticleAI.target.
    if (reticleAI.target == null)
      {
      ai_state = NAVIGATION_DECIDING;      
      return;
      }
    // Assert precondition - we must be reticle-ing to a non-expired reticleAI.target.  
    if (reticleAI.target.isExpired)
      {
      ai_state = NAVIGATION_DECIDING;
      reticleAI.setTarget(null);
      return;	
      }
    // Verified: the reticle target is valid.	

    // Set the tether on the target when reticle arrives on it.
    if (reticleAI.isReady)        
      {
      // Decide if we should try to glob this spice with a suck-bomb.
      // Search for spice within a range of the reticle.    
      var radius : Number = 100;
      var spicecount : Number = 0;
      for (var i:Number = 0; i < env.spices.length; i++)
        {
        var dx:Number = env.spices[i].rx - reticle.rx;
        var dy:Number = env.spices[i].ry - reticle.ry;
        var dl:Number = Math.sqrt (dx*dx + dy*dy);
        if (dl < radius)
          spicecount++;
        }
      // Decide if we should use a bomb. If there are enough spices in the neighborhood, set it off.    
      if (spicecount > 2)
        if (gravBomb.isReady() )
          gravBomb.detonate(reticle.rx, reticle.ry);               	
      if ( tether.setTarget(desired_Body) )   
        {     
        ai_state = GOAL_DECIDING;
        goal_countdown = 10;
        }
      else
        ai_state = NAVIGATION_DECIDING;        
      }	    	    	
    }
    
    
  public function computeVelocityAndNeighborhood() : void
    {
    var i:Number;    
    var best:Number;
    var L:Number; 	
    	
    // Range to desired position.
    var D:Number = computeRange();          
    // Use the map to find my bounding triangle.    
    var myTriangle : Triangle = env.map.whereIs(this);                 
    // Use the map to find the bounding triangle of the desired object.    
    var desiredTriangle:Triangle = env.map.whereIs(desired_Body);
    
    // Find all objects within radius.    
    var radius:Number = 300;
    var nTargets:Number = 0;
    bodyBuffer = new Array;
    while (nTargets < 2)
      {
      bodyBuffer = env.findBodies(this, radius);        
      nTargets = bodyBuffer.length;
      radius = radius*2;
      }
      
    // Compute displacement vectors to these objects.
    normals_x = new Array;
    normals_y = new Array;
    normals_L = new Array;        
    for (i = 0; i < bodyBuffer.length; i++)
      {           
      normals_x[i] = bodyBuffer[i].rx - rx;
      normals_y[i] = bodyBuffer[i].ry - ry;
      normals_L[i] = Math.sqrt(normals_x[i]*normals_x[i] + normals_y[i]*normals_y[i]);
      normals_x[i] /= normals_L[i];
      normals_y[i] /= normals_L[i];          
      }    
    
    // Establish the desired velocity, <desired_vx, desired_vy>
    if (desiredTriangle == myTriangle)
      {
      // If we are in the same triangle, fly straight towards it.	
      desired_vx = desired_Body.rx - rx;
      desired_vy = desired_Body.ry - ry;
      L = Math.sqrt( desired_vx * desired_vx + desired_vy*desired_vy);    
      desired_vx = desired_vx / L;
      desired_vy = desired_vy / L;     
      // Scale velocity - it's normalized. 
      desired_vx *= (2.0);
      desired_vy *= (2.0);
      } 
    else      
      { 
      // Me and my desired_Body reside in different triangles.                            
      // Set a "greedy" velocity to point in the best direction.          
      var greedy_vx:Number = desired_Body.rx - rx;
      var greedy_vy:Number = desired_Body.ry - ry;
      L = Math.sqrt( greedy_vx * greedy_vx + greedy_vy*greedy_vy);   
      greedy_vx /= L; 
      greedy_vy /= L;                  
      
      // Figure out if flying along the "greedy" velocity collides with any other object.                  
      var collisionPossible : Boolean = false;  
      for (i = 0; i < bodyBuffer.length; i++)
        if (bodyBuffer[i] != desired_Body) // Don't check collision against homebase when we're heading home.
          {  
          // Compute perpendicular distance from this object to the greedy path.
          var greedyDot:Number = greedy_vx*normals_x[i] + greedy_vy*normals_y[i];
          if (greedyDot > 0)
            {
            // Sketch collision neighborhood.	            
            // Screen.hud.graphics.moveTo(rx,ry);
	        // Screen.hud.graphics.lineTo(rx+normals_x[i]*normals_L[i], ry+normals_y[i]*normals_L[i]);       	          		        
            var orthogonal_x : Number = normals_x[i]*normals_L[i] - greedyDot*greedy_vx*normals_L[i];
            var orthogonal_y : Number = normals_y[i]*normals_L[i] - greedyDot*greedy_vy*normals_L[i];
            var orthogonal_L : Number = Math.sqrt (orthogonal_x*orthogonal_x + orthogonal_y*orthogonal_y);
            if (orthogonal_L < bodyBuffer[i].collision_radius + this.collision_radius)
              collisionPossible = true;
            }
          }         
      if (!collisionPossible)
        {
        // Fly towards target.		
        desired_vx = greedy_vx;
        desired_vy = greedy_vy;
        }
      else
        {           
        // Compute a path that attempts to avoid collisions.
        best = env.map.shortestPath (this, desired_Body,Screen.swfs);                             
        // Compute edge centroids. Reuse the "edge_normals" for scratch storage.
        var edge_normals_x:Array = new Array;
        var edge_normals_y:Array = new Array;           
        edge_normals_x[0] = 0.5 * myTriangle.A.rx + 0.5 * myTriangle.B.rx;
        edge_normals_y[0] = 0.5 * myTriangle.A.ry + 0.5 * myTriangle.B.ry;      
        edge_normals_x[1] = 0.5 * myTriangle.B.rx + 0.5 * myTriangle.C.rx;
        edge_normals_y[1] = 0.5 * myTriangle.B.ry + 0.5 * myTriangle.C.ry;      
        edge_normals_x[2] = 0.5 * myTriangle.C.rx + 0.5 * myTriangle.A.rx;
        edge_normals_y[2] = 0.5 * myTriangle.C.ry + 0.5 * myTriangle.A.ry;                 
        // Compute normalized displacement vectors to edge centroids.
        for (i = 0; i < 3; i++)
          {
          edge_normals_x[i] -= rx;
          edge_normals_y[i] -= ry;        
          L = Math.sqrt( edge_normals_x[i]*edge_normals_x[i] + edge_normals_y[i]*edge_normals_y[i]);   
          edge_normals_x[i] /= L; 
          edge_normals_y[i] /= L;
          }                      
        // Fly towards edge centroid.
        desired_vx = edge_normals_x[best];
        desired_vy = edge_normals_y[best];           
        } 
      // Scale velocity - it's normalized.
      desired_vx *= (2.0) + 1.0*(repelBeam.strength+attractBeam.strength);
      desired_vy *= (2.0) + 1.0*(repelBeam.strength+attractBeam.strength);             
      // Go extra fast if we are dragging it home, and there are no collisions in our path.
      if (goal_state == GOAL_FIND_HOMEBASE && ! collisionPossible)
        {
        desired_vx *= 2;
        desired_vy *= 2;
        }     
      // Tweaking function : damp velocity based on distance from the desired point.    
      desired_vx = desired_vx  / (1+Math.exp( (-D+30) / 30) );
      desired_vy = desired_vy  / (1+Math.exp( (-D+30) / 30) );        
      }    	    
    }  
  }
  
} // end package