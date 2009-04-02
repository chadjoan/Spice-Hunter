package {

import Assets;
import Utility;
import Environment;

import Body;
import Reticle;
import Screen;
import Debouncer;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.display.*;
import flash.filters.BlurFilter;
import flash.geom.*;

public class Ship extends Body
  {
  public var reticle:Reticle;
  public var tether:Tether;
  public var gravBomb : GravBomb;
  
  public var gravityTarget:Body;
  public var repelTarget:Body;  
  
  public var repelStrength : Number;
  public var gravityStrength : Number;    
  public var spec : ShipSpec;
  public var env:Environment;
  
  public var reticleLockingOn : Boolean = true;
  
  // Various eventCodes - these are passed into triggerReset so that CPUShips can handle these exception cases.
  public static var GRAVITY_SNAP_EVENT : Number;
  public static var REPEL_SNAP_EVENT : Number;
  public static var TETHER_SNAP_EVENT : Number;
  public static var GOAL_COUNTDOWN_EVENT : Number;
  
  public var repelSprite : Sprite;
  public var repelBeamFrame : Number;
  public var gravitySprite : Sprite;
  public var gravityBeamFrame : Number;

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
    
    // increase repelStrength and gravityStrength at these aspects of the ship are upgraded.
    repelStrength = 0.06 + 0.015 * spec.repelLevel;
    gravityStrength = 0.06 + 0.015 * spec.gravityLevel;
    
    //repelStrength = 0.02 + 0.015 * spec.repelLevel;
    //gravityStrength = 0.02 + 0.015 * spec.gravityLevel;
    //repelStrength = 0.15 + 0.15 * (spec.repelLevel/10);
    //gravityStrength = 0.15 + 0.15 * (spec.gravityLevel/10);
    
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
      
    draw();    
    reticle = new Reticle(spec); 
    tether = new Tether(this);
    tetherDebouncer = new Debouncer( 50 ); // 50 ms between clicks
    
    repelSprite = new Sprite();
    repelSprite.filters = [new BlurFilter(8,8)];
    repelBeamFrame = 0;
    gravitySprite = new Sprite();
    gravitySprite.filters = [new BlurFilter(8,8)];    
    gravityBeamFrame = 0;
    
    Screen.midground.addChild(gravitySprite);
    Screen.midground.addChild(repelSprite);
    
    
    gravBomb = new GravBomb (env, spec.shieldLevel);        
    }
  
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
      Utility.playSound (new Assets.Buzz );        
     
    // Display how many bombs are left.
    var bca : BombCountAnim = new BombCountAnim (Screen.hud, spec.teamCode, gravBomb.count);
    bca.radius = 30;
    bca.boundTo = this;
    bca.boundTo_enableRotation = false;
    bca.boundTo_offsety = 50;
    env.animations.push(bca); 
     
    }
  
  public override function draw () : void
    {
    var bmp : Bitmap = Screen.getShipSprite( spec );
    
    // Compute scale so that this ship will be drawn with the right collision radius.
    bmp.scaleX = collision_radius / (bmp.width/2);
    bmp.scaleY = collision_radius / (bmp.height/2);  
    
    Utility.center(bmp); 
    avatar.addChild(bmp);
    
    avatar.graphics.clear ();	        
    avatar.graphics.lineStyle(2, 0xFFFFFF, 1);
    
    //avatar.graphics.drawCircle(0,0,collision_radius); 
    }
  
  public function updateVelocity(deltaT:Number) : void
    {  
    var dx:Number;
    var dy:Number;
    var dl:Number;
    
    
    gravBomb.update (deltaT);
    
    
    if (gravityTarget != null )
      {
      // Compute direction vector from me to gravityTarget.
      dx = gravityTarget.rx - rx;
      dy = gravityTarget.ry - ry;
      dl = Math.sqrt(dx*dx + dy*dy);
      dx /= dl;
      dy /= dl;
      // Add a little velocity kick towards (dx,dy);
      vx += dx * gravityStrength * deltaT;
      vy += dy * gravityStrength * deltaT;
      // Add a little velocity kick to the other thing
      var K1 : Number = 4;
      gravityTarget.vx -= dx * gravityStrength * mass / gravityTarget.mass * deltaT / K1;
      gravityTarget.vy -= dy * gravityStrength * mass / gravityTarget.mass * deltaT / K1;
      }
      
    if (repelTarget != null )
      {
      // Compute direction vector from me to repelTarget.
      dx = repelTarget.rx - rx;
      dy = repelTarget.ry - ry;
      dl = Math.sqrt(dx*dx + dy*dy);
      dx /= dl;
      dy /= dl;
      // Add a little velocity kick away from (dx,dy);
      vx -= dx * repelStrength * deltaT;
      vy -= dy * repelStrength * deltaT;	
      // Add a little velocity kick to the other thing
      var K2 : Number = 4;
      repelTarget.vx += dx * repelStrength * mass / repelTarget.mass * deltaT / K2;
      repelTarget.vy += dy * repelStrength * mass / repelTarget.mass * deltaT / K2;
      }
    
    
    // Sketch the gravityTarget and repelTarget.
    /*
    if (gravityTarget != null)
      {
      Screen.midground.graphics.lineStyle(5, 0x007FFF, 0.5);
      Screen.midground.graphics.moveTo(rx,ry);
      Screen.midground.graphics.lineTo(gravityTarget.rx, gravityTarget.ry);
      }
    */
    
    /*
    if (repelTarget != null)
      {
      Screen.midground.graphics.lineStyle(5, 0xFF4B37, 0.5);
      Screen.midground.graphics.moveTo(rx,ry);
      Screen.midground.graphics.lineTo(repelTarget.rx, repelTarget.ry);	
      }
    */
    
    // Procedural beam draws.
    gravitySprite.graphics.clear();
    if (gravityTarget != null)  
      callForceBeam( gravityTarget );
    
    repelSprite.graphics.clear();
    if (repelTarget != null)
      callForceBeam( repelTarget );
    
    }
  
  public function updatePosition(deltaT:Number) : void
    {
    // Update position.	
    rx += vx * deltaT;
    ry += vy * deltaT;
       
    // Bounce off walls.
    super.bounceClipDamped(); 
    
    avatar.x = rx;
    avatar.y = ry;	
    reticle.updatePosition(deltaT);
    
    // Reorient the ship so that it points at the reticle.
    var angle:Number = Math.atan2 (reticle.ry - ry, reticle.rx-rx);
    phi = angle;
    avatar.rotation = angle*180.0/Math.PI;
    
    repelBeamFrame += deltaT* (0.5 + 2.5 * spec.repelLevel/10);       
    if ( repelBeamFrame > 8*Math.sqrt(8) )
      repelBeamFrame = 0;
    
    gravityBeamFrame += deltaT* (0.5 + 2.5 * spec.gravityLevel/10);       
    if ( gravityBeamFrame > 8*Math.sqrt(8) )
      gravityBeamFrame = 0;
    
    
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
              var ohsnap : OhSnapAnim = new OhSnapAnim(Screen.hud, env.ships[loop1].spec.teamCode);
              ohsnap.radius = 50;
              ohsnap.boundTo = tether.target;
              ohsnap.boundTo_enableRotation = false;
              env.animations.push(ohsnap);
              Utility.playSound (new Assets.oh_snap);
              }
      // Snapping a tether should clobber the fingerprint of the spice.
      if (tether.target is Spice)  
        {
        var targetSpice : Spice = Spice(tether.target);
        targetSpice.fingerprint = null;
        }        
      }
    }

  // Extra stub onto beam drawing routine
  private function callForceBeam( target : Body ) : void
    {
    var hiColorR : uint = 0;
    var hiColorG : uint = 0;
    var hiColorB : uint = 0;
    
    var r : Number = collision_radius;
    var angle : Number;
    var direction : Boolean;
    var frame : Number;
    var gfx : Graphics;
    if ( target == repelTarget )
      {
      // Origin of repel beam is on left arm.
      angle = phi-Math.PI/8;
      
      // It is reddish in color
      hiColorR = 128 + Math.round(127*spec.repelLevel / 10);
      
      direction = false;
      frame = repelBeamFrame;
      gfx = repelSprite.graphics;
      }
    else
      {
      // Origin of gravity beam is on right arm.
      angle = phi+Math.PI/8;
      
      // It is blueish in color
      hiColorB = 128 + Math.round(127*spec.repelLevel / 10);
      
      direction = true;
      frame = gravityBeamFrame;
      gfx = gravitySprite.graphics;
      }
    
    var hiColor : uint = hiColorR*256*256 + hiColorG*256 + hiColorB;  
    
    drawForceBeam (rx + r*Math.cos(angle) , ry  + r*Math.sin(angle), target.rx, target.ry, 3, target.collision_radius, 0x000000, hiColor, direction, gfx, frame);
    
    // Experimental code aimed at fixing movement speed issues.  
    /*
    // we want the beam to "originate" at the slowest target, or the beam tends to freak out
    var speed1 : Number = Math.sqrt( this.vx*this.vx + this.vy*this.vy );
    var speed2 : Number = Math.sqrt( target.vx*target.vx + target.vy*target.vy );
    
    // also realize that we flip the start and end thicknesses and the chevron directions, 
    //   so that the beam properties remain consistant to the observer
    if ( speed1 < speed2 )
      drawForceBeam (rx + r*Math.cos(angle) , ry  + r*Math.sin(angle), target.rx, target.ry, 3, target.collision_radius, 0x000000, hiColor, !direction, gfx, frame);
    else // flip it
      drawForceBeam (target.rx, target.ry, rx + r*Math.cos(angle) , ry  + r*Math.sin(angle), target.collision_radius, 3, 0x000000, hiColor, direction, gfx, frame);
    */
    }
  
  // Procedural beam drawing routine
  public function drawForceBeam( x1:int, y1:int, x2:int, y2:int, 
                            startThickness:uint, endThickness:uint, color1:uint, color2:uint,
                            attracts:Boolean, graphics:Graphics, beamFrame:Number) : void
    {
    // alphas are 0-100, with 100 being fully opaque
    const alpha1 : Number = 0.75;
    const alpha2 : Number = 0.75;
    
    const period : uint = 8; // how far apart the 'arrows' are
    
    var frame : Number = beamFrame;

    
    var dx : int = x2 - x1;
    var dy : int = y2 - y1;
    var angle : Number = 0;
    
    if ( dx == 0 )
      {
      if ( dy >= 0 )
        angle = Math.PI / 2;
      else
        angle = Math.PI * 3 / 2;
      }
    else if ( dx > 0 )
      angle = Math.atan( dy/dx );
    else
      angle = Math.atan( dy/dx ) + Math.PI;
    
    angle %= 2 * Math.PI;
    if ( angle < 0 )
      angle += 2 * Math.PI;
    
    var spread : Number;
    if ( attracts )
      spread = Math.PI / 4;
    else
      spread = -Math.PI / 4;
    
    var minX : int = Math.min( x1, x2 );
    var minY : int = Math.min( y1, y2 );
    var length : int = Math.sqrt( dx*dx + dy*dy );
    
    var cosine : Number = Math.cos( angle );
    var sine : Number = Math.sin( angle );
    
    // bread-and-butter rotation matrix
    var matrix : Matrix = new Matrix( cosine, sine, -sine, cosine );
    matrix.translate( x1, y1 );
    
    // now let's just say that the beam is shooting from the left to right, 
    //   we define a set of points describing the top and bottom halves of
    //   the beam.
    
    // top half
    var pt0 : Point = matrix.transformPoint( new Point( length, 0 ) );
    var pt1 : Point = matrix.transformPoint( new Point( length, -endThickness/2 ) );
    var pt2 : Point = matrix.transformPoint( new Point( 0, -startThickness/2 ) );
    var pt3 : Point = matrix.transformPoint( new Point( 0, 0 ) );
    
    // bottom half
    var pb0 : Point = matrix.transformPoint( new Point( length, 0 ) );
    var pb1 : Point = matrix.transformPoint( new Point( length, endThickness/2 ) );
    var pb2 : Point = matrix.transformPoint( new Point( 0, startThickness/2 ) );
    var pb3 : Point = matrix.transformPoint( new Point( 0, 0 ) );
    
    // let's get our animation groove on - animShift changes over time to make the 
    //   beam look like it is moving in one direction
    var rotMatrix : Matrix = new Matrix( cosine, sine, -sine, cosine );
    var animShift : Point  = rotMatrix.transformPoint( new Point( 0, frame ) );
    
    // now for gradient stuff
    // top
    matrix.createGradientBox( period, period, angle+spread, x1 - animShift.x, y1 - animShift.y );        
    
    graphics.beginGradientFill(GradientType.LINEAR,[color1,color2],[alpha1,alpha2],[0,255],matrix,
      SpreadMethod.REFLECT,InterpolationMethod.LINEAR_RGB,0);
    graphics.moveTo( pt0.x, pt0.y );
    graphics.lineTo( pt1.x, pt1.y );
    graphics.lineTo( pt2.x, pt2.y );
    graphics.lineTo( pt3.x, pt3.y );
    graphics.lineTo( pt0.x, pt0.y );
    graphics.endFill();
    
    // bottom
    
    // but first, let's align the one side of the beam with the other
    var phaseShift : Point;
    
    if ( attracts )
      {
      if ( angle <= Math.PI / 2 )
        phaseShift = new Point( period * (cosine - sine), 0 );
      else if ( Math.PI / 2 < angle && angle <= Math.PI )
        phaseShift = rotMatrix.transformPoint( new Point( 0, period ) );
      else if ( Math.PI < angle && angle <= Math.PI * 3 / 2 )
        phaseShift = new Point( period * (sine - cosine), 0 );
      else
        phaseShift = rotMatrix.transformPoint( new Point( period, 0 ) );
      }
    else
      {
      if ( angle <= Math.PI / 2 )
        phaseShift = new Point( 0, period * ( sine - cosine ) );
      else if ( Math.PI / 2 < angle && angle <= Math.PI )
        phaseShift = rotMatrix.transformPoint( new Point( 0, period ) );
      else if ( Math.PI < angle && angle <= Math.PI * 3 / 2 )
        phaseShift = new Point( 0, period * (cosine - sine) );
      else
        phaseShift = rotMatrix.transformPoint( new Point( -period, 0 ) );
      }
    
    phaseShift.x += animShift.x;
    phaseShift.y += animShift.y;
    
    // ok done, bottom now.  for real this time.  
    matrix.createGradientBox( period, period, angle-spread, x1 + phaseShift.x, y1 + phaseShift.y);    
    
    graphics.beginGradientFill(GradientType.LINEAR,[color1,color2],[alpha1,alpha2],[0,255],matrix,
      SpreadMethod.REFLECT,InterpolationMethod.LINEAR_RGB,0);
    graphics.moveTo( pb0.x, pb0.y );
    graphics.lineTo( pb1.x, pb1.y );
    graphics.lineTo( pb2.x, pb2.y );
    graphics.lineTo( pb3.x, pb3.y );
    graphics.lineTo( pb0.x, pb0.y );
    graphics.endFill();
    }


  


  public function attractBeamAt(x:int,y:int) : void
    {
    var target : Body = env.findBeamBody (x,y,reticle.radius);
    if ( target != null && target != Body(this) )
      attract( target );
    }
  
  public function attract(target:Body) : void
    {
    if (target != Body(this))
      gravityTarget = target;
    Utility.playSound( new Assets.BeamAttract() );
    }
  
  public function attractBeamOff() : void
    {
    gravityTarget = null;
    }
  
  public function repelBeamAt(x:int,y:int) : void
    {
    var target : Body = env.findBeamBody (x,y,reticle.radius);
    if ( target != null && target != Body(this) )
      repel( target );
    }
  
  public function repel(target:Body) : void
    {
    if (target != Body(this))
      repelTarget = target;
    Utility.playSound( new Assets.BeamRepel() );
    }
  
  public function repelBeamOff() : void
    {
    repelTarget = null;
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
    Screen.midground.removeChild(gravitySprite);
    Screen.midground.removeChild(repelSprite);	
    Screen.foreground.removeChild(avatar);	
    isExpired = true;
    }
  
  }
  
} // end of package