package play
{

import Assets;
import Utility;
import Screen;
import Debouncer;
import Drawable;
import IDrawable;

import play.Environment;
import play.GravBeam;
import play.Body;
import play.Reticle;

import flash.display.Bitmap;
import flash.display.BitmapData;

public class Ship extends Body
  {
  public var reticle:Reticle;
  public var tether:Tether;
  public var gravBomb : GravBomb;
  
  public var spec : ShipSpec;
  public var env:Environment;
  
  public var reticleLockingOn : Boolean = true;
  
  // Various eventCodes - these are passed into triggerReset so that CPUShips can handle these exception cases.
  public static var GRAVITY_SNAP_EVENT : Number;
  public static var REPEL_SNAP_EVENT : Number;
  public static var TETHER_SNAP_EVENT : Number;
  public static var GOAL_COUNTDOWN_EVENT : Number;
  
  public var attractBeam : GravBeam;
  public var repelBeam : GravBeam;

  private var tetherDebouncer : Debouncer;
  
  public function Ship (_spec:ShipSpec, env_reference : Environment)  
    {
    env = env_reference;
    
    GRAVITY_SNAP_EVENT = 0;
    REPEL_SNAP_EVENT = 1;
    TETHER_SNAP_EVENT = 2;
    GOAL_COUNTDOWN_EVENT = 3;
    
    // Initialize Particle members.
    rx = 100;
    ry = 100;
    vx = 0;
    vy = 0;
    mass = 5;
    
    spec = _spec;
    
    // Initialize Body members.
    omega = 0;
    phi = 0;
    moment = 5;    
    collision_radius = 25;
    
    switch(spec.teamCode)
      {
      case ShipSpec.BLUE_TEAM:   tooltiptext = "Blue Player"; break;
      case ShipSpec.RED_TEAM:    tooltiptext = "Red Player"; break;
      case ShipSpec.YELLOW_TEAM: tooltiptext = "Yellow Player"; break;
      case ShipSpec.GREEN_TEAM:  tooltiptext = "Green Player"; break;
      }
      
    //draw();    
    reticle = new Reticle(spec); 
    tether = new Tether(this);
    tetherDebouncer = new Debouncer( 50 ); // 50 ms between clicks
    
    gravBomb = new GravBomb (env, spec.shieldLevel);
    
    attractBeam = new GravBeam(this, GravBeam.ATTRACT);
    repelBeam = new GravBeam(this, GravBeam.REPEL);
    
    cachebmp.bitmapData = Screen.getShipSprite( spec ).bitmapData;
    }
  
  // Ships will be gazed upon a lot, they should be smoothed if at all possible!
  public override function useSmoothing() : Boolean { return Screen.useSmoothing(0.8); }
  
  public function gBombPress() : void
    {
    reticleLockingOn = false;
    }
  
  public function launchGravBomb () : void
    {
    reticleLockingOn = true;
    
    if (gravBomb.isReady() )	
      gravBomb.detonate (reticle.rx, reticle.ry);        
    else
      Utility.playSound (Assets.Buzz );        
     
    // Display how many bombs are left.
    var bca : BombCountAnim = new BombCountAnim (spec.teamCode, gravBomb.count);
    bca.radius = 30;
    bca.boundTo = this;
    bca.boundTo_offsety = 50;
    env.animations.push(bca); 
     
    }
  
  public function updateVelocity(deltaT:Number) : void
    {
    gravBomb.update (deltaT);
    
    repelBeam.applyForces(deltaT);
    attractBeam.applyForces(deltaT);
    }
  
  public function updatePosition(deltaT:Number) : void
    {
    // Update position.	
    rx += vx * deltaT;
    ry += vy * deltaT;
       
    // Bounce off walls.
    super.bounceClipDamped();
    
    reticle.updatePosition(deltaT);
    
    // Reorient the ship so that it points at the reticle.
    var angle:Number = Math.atan2 (reticle.ry - ry, reticle.rx-rx);
    phi = angle;
    
    repelBeam.updateFrame(deltaT);
    attractBeam.updateFrame(deltaT);
    }
  
  // Huge kludge/thunk here... here is the story:
  // Infrequently, a CPUship which has an object tethered/gravitied/repelled may find 
  // that object suddenly isExpired - it's not in play anymore. This causes a lot of CPUShip
  // references to be invalidated so it's state should be totally reset (ie go to idle state,
  // disable all beams, place the reticle in idle state, etc).
  // So there should be a method of CPUShip which can be called to trigger that reset, right? 
  // The catch is that Environment only holds references to the (base class), Ship. So you have
  // two (equally ugly, in my opinion) alternatives:
  //   1. Take your Ship reference and promote it to a CPUShip at runtime, call a reset method on it.
  //   2. Create a dummy method on the ship class which is the hook for this "reset" operation. The
  //      Ship version is (of course) a do-nothing function (because the Ship has no AI state). The
  //      CPUShip overrides this method with the reset operations.
  // Neither of these alternatives is particularly appealing. I implemented 2.
  
  // Update: conveniently, this method is also used to implement the "tug of war" title/award.
  // If event code is a TETHER_SNAP_EVENT... 
  //    For each ship of environment,
  //      If their tether target is my tether target, increment _their_ bonusData.tetherWins
  
  public function triggerReset(eventCode:Number) : void
    {    
    var loop1:Number;
    if (eventCode == TETHER_SNAP_EVENT)
      {
      for (loop1 = 0; loop1 < env.ships.length; loop1++)
        if (env.ships[loop1].spec.playerID != spec.playerID)  // Only consider other ships.
          if (env.ships[loop1].spec.teamCode != spec.teamCode) // Only consider unallied ships.
            if (env.ships[loop1].tether.target == tether.target)
              {            	
              env.bonusDatas[loop1].tetherWins++;
              // Add an "oh-snap" graphic - put it on top of tether.target
              var ohsnap : OhSnapAnim = new OhSnapAnim(env.ships[loop1].spec.teamCode);
              ohsnap.radius = 50;
              ohsnap.boundTo = tether.target;
              env.animations.push(ohsnap);
              Utility.playSound (Assets.oh_snap);
              }
      // Snapping a tether should clobber the fingerprint of the spice.
      if (tether.target is Spice)  
        {
        var targetSpice : Spice = Spice(tether.target);
        targetSpice.fingerprint = null;
        }        
      }
    }

  
  public function attractBeamAt(x:int,y:int) : void
    {
    var target : Body = env.findBeamBody (x,y,reticle.radius);
    if ( target != null && target != Body(this) )
      attract( target );
    }
  
  public function attract(target:Body) : void
    {
    attractBeam.target = target;
    }
  
  public function attractBeamOff() : void
    {
    attractBeam.target = null;
    }
  
  public function repelBeamAt(x:int,y:int) : void
    {
    var target : Body = env.findBeamBody (x,y,reticle.radius);
    if ( target != null && target != Body(this) )
      repel( target );
    }
  
  public function repel(target:Body) : void
    {
    repelBeam.target = target;
    }
  
  public function repelBeamOff() : void
    {
    repelBeam.target = null;
    }  
  
  public function tetherPress() : void
    {
    if ( tetherDebouncer.debounced() )
      tetherDebouncer.setLastEventTime();
    else
      return;
    
    if (tether.state == Tether.TETHER_READY) 
      tetherBeamAt(reticle.rx, reticle.ry); 
    else 
      tether.setTarget(null);
    }
  
  public function tetherBeamAt (x:int, y:int) : void
    {
    var target : Body = env.findBody (x,y,reticle.radius);
    if (target != null && target != Body(this) )
      tetherBeam ( target );	
    }
  
  public function tetherBeam (target:Body) : void
    {
    if (target != Body(this))    
      tether.setTarget (target);    
    }
  
  
  public override function expire () : void
    {
    isExpired = true;
    }
  
  }
  
} // end of package