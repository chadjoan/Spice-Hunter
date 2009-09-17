package play
{

import Assets;

import play.Ship;

import flash.display.*;
import flash.filters.*;

public class Tether implements IDrawable
  {
  public var blurSprite:Sprite;
  public var avatar:Sprite;  
  
  public var owner:Ship;
  public var target:Body;
  
  public var state:Number;
  public var framecounter:Number;
  
  // Little state variables for sketched the maximum permissible radius.
  public var radiusframecounter:Number;
  public var direction_x:Number;
  public var direction_y:Number;
  
  
  public static var TETHER_READY:Number;  
  public static var TETHER_ATTACHED:Number;
  public static var TETHER_RECOILING:Number;
  
  public var nodes : Array;
  
  // dl is the equilibrium length between nodes.
  public var dl:Number;
  public static const max_dl:Number = 5;
  public static const min_dl:Number = 3;
  
  private var k:Number;  // Spring constant - structural.
  private var k2:Number;  // Spring constant - flexion.
  private var snap:Number; // excess length at which a tether will snap.
  
  // Physical mass of the tether.
  private static const numNodes:uint = 21;
  private static const m:Number = 0.25; // Mass of complete tether - distributed uniformly across its length.
  private static const nodeMass:Number = m/numNodes;
  
  public function Tether (_owner:Ship)
    {
    Screen.queueDraw(this);
    avatar = new Sprite();
    owner = _owner;
    target = null;
    
    k = 0.25 + 0.1 * (owner.spec.tetherLevel/10.0);  
    k2 = k/4;
    snap = 1.5 + 0.5*(owner.spec.tetherLevel/10.0);
    
    // Allocate some nodes.
    nodes = new Array(numNodes);
    
    for (var n:Number = 0; n < numNodes; n++)
      {
      nodes[n] = new Particle();
      nodes[n].mass = nodeMass;
      nodes[n].collision_radius = 1;
      }
    
    TETHER_READY = 0;    
    TETHER_ATTACHED = 1;
    TETHER_RECOILING = 2;   
    state = TETHER_READY;    
    
    radiusframecounter = 0;
    direction_x = 1;
    direction_y = 0;
    
    blurSprite = new Sprite();
    blurSprite.filters = [new BlurFilter(4,4)];
    avatar.addChild(blurSprite);
    }
  
  // IDrawable implementation
  public function isVisible() : Boolean { return true; }
  public function getLayer() : uint { return Drawable.midground; }
  public function draw( backbuffer : BitmapData ) : void
    {  
    avatar.graphics.clear();        
    blurSprite.graphics.clear();
    avatar.x = owner.rx;
    avatar.y = owner.ry;
    // Red   = 250 = 0xFA
    // Green = 201 = 0xC9
    // Blue  = 86  = 0x56
    var n:Number;
    
    if (radiusframecounter > 0)
      {
      drawRadius(direction_x, direction_y);
      radiusframecounter--;
      backbuffer.draw(avatar,avatar.transform.matrix,avatar.transform.colorTransform,
                    null,null,Screen.useSmoothing(0.7));
      }
    
    if (state == TETHER_READY)      
      return;	      
    
    if (state == TETHER_ATTACHED)    
      {
      drawTether();
      }
      
    if (state == TETHER_RECOILING)
      {      
      drawTether();
      framecounter--;
      if (framecounter == 0)
        state = TETHER_READY;
      }
    
    backbuffer.draw(avatar,avatar.transform.matrix,avatar.transform.colorTransform,
                    null,null,Screen.useSmoothing(0.7));
    }
  
  public function drawTether() : void
    {
    var i : uint;
    var level : uint = owner.spec.tetherLevel;
    var graphics : Graphics = avatar.graphics;
    var blurgfx : Graphics = blurSprite.graphics;
    
    var rx : int = nodes[0].rx;
    var ry : int = nodes[0].ry;
    
    // for lightning effects
    var radiusOfLightning : Number = 3 + level - 7;
    var lastRandDir1 : Number = Math.random() * Math.PI * 2;
    var lastRandMag1 : Number = Math.random() * radiusOfLightning;
    var lastRandDir2 : Number = Math.random() * Math.PI * 2;
    var lastRandMag2 : Number = Math.random() * radiusOfLightning;
    
    var nextRandDir1 : Number;
    var nextRandMag1 : Number;
    var nextRandDir2 : Number;
    var nextRandMag2 : Number;
    
    for ( i = 1; i < nodes.length; i++ )
      {
      var rx1 : int = nodes[i-1].rx - rx;
      var ry1 : int = nodes[i-1].ry - ry;
      var rx2 : int = nodes[i].rx - rx;
      var ry2 : int = nodes[i].ry - ry;
      
      // colors roughly based off of "glamour shot" tether renderings
      const color1 : uint = 0x888888;
      const color2 : uint = 0xC4A48C;
      const color3 : uint = 0xEAD8A4;
      
      //level %= 4;
      
      if ( level < 7 )
        {
        switch ( level )
          {
          // low level tethers
          case 0:
            graphics.lineStyle( 1, color1 );
            break;
          case 1:
            graphics.lineStyle( 1, color1 );
            break;
          case 2:
            graphics.lineStyle( 2, color1 );
            break;
          case 3:
            graphics.lineStyle( 3, color1 );
            break;
          
          // mid level tethers
          case 4:
            graphics.lineStyle( 1, color2 );
            break;
          case 5:
            graphics.lineStyle( 2, color2 );
            break;
          case 6:
            graphics.lineStyle( 3, color2 );
            break;
          } // switch case
        graphics.moveTo( rx1, ry1 );
        graphics.lineTo( rx2, ry2 );
        }
      else
        {
        nextRandMag1 = Math.random() * radiusOfLightning;
        nextRandDir1 = Math.random() * Math.PI * 2;
        nextRandMag2 = Math.random() * radiusOfLightning;
        nextRandDir2 = Math.random() * Math.PI * 2;
        
        // bolt as in lightning bolt
        var boltX1a : Number = rx1 + lastRandMag1 * Math.cos( lastRandDir1 );
        var boltY1a : Number = ry1 + lastRandMag1 * Math.sin( lastRandDir1 );
        var boltX1b : Number = rx1 + lastRandMag2 * Math.cos( lastRandDir2 );
        var boltY1b : Number = ry1 + lastRandMag2 * Math.sin( lastRandDir2 );
        
        var boltX2a : Number = rx2 + nextRandMag1 * Math.cos( nextRandDir1 );
        var boltY2a : Number = ry2 + nextRandMag1 * Math.sin( nextRandDir1 );
        var boltX2b : Number = rx2 + nextRandMag2 * Math.cos( nextRandDir2 );
        var boltY2b : Number = ry2 + nextRandMag2 * Math.sin( nextRandDir2 );
        
        switch( level )
          {
          case 7:
            graphics.lineStyle( 1, 0xffff7f );
            graphics.moveTo( boltX1a, boltY1a );
            graphics.lineTo( boltX2a, boltY2a );
            graphics.moveTo( boltX1b, boltY1b );
            graphics.lineTo( boltX2b, boltY2b );
            break;
          
          case 8:
            graphics.lineStyle( 1, 0xffffff );
            graphics.moveTo( boltX1a, boltY1a );
            graphics.lineTo( boltX2a, boltY2a );
            graphics.moveTo( boltX1b, boltY1b );
            graphics.lineTo( boltX2b, boltY2b );
            
            //blurgfx.lineStyle( 2, 0x00ff00 );
            blurgfx.lineStyle( 2, 0x7f7f00 );
            blurgfx.moveTo( rx1, ry1 );
            blurgfx.lineTo( rx2, ry2 );
            //blurgfx.lineStyle( 1, 0x00ff7f );
            blurgfx.lineStyle( 1, 0xbfbf7f );
            blurgfx.lineTo( rx1, ry1 );
            break;
          
          case 9:
            graphics.lineStyle( 1, 0xffffff );
            graphics.moveTo( boltX1a, boltY1a );
            graphics.lineTo( boltX2a, boltY2a );
            graphics.moveTo( boltX1b, boltY1b );
            graphics.lineTo( boltX2b, boltY2b );
            
            blurgfx.lineStyle( 4, 0xffff00 );
            blurgfx.moveTo( rx1, ry1 );
            blurgfx.lineTo( rx2, ry2 );
            blurgfx.lineStyle( 2, 0xffffff );
            blurgfx.lineTo( rx1, ry1 );
            break;
          
          // the ultimate!
          case 10:
            graphics.lineStyle( 1, 0xffffff );
            graphics.moveTo( boltX1a, boltY1a );
            graphics.lineTo( boltX2a, boltY2a );
            graphics.moveTo( boltX1b, boltY1b );
            graphics.lineTo( boltX2b, boltY2b );
            
            blurgfx.lineStyle( 6, 0xffff7f );
            blurgfx.moveTo( rx1, ry1 );
            blurgfx.lineTo( rx2, ry2 );
            blurgfx.lineStyle( 5, 0xffffff );
            blurgfx.lineTo( rx1, ry1 );
            break;
          } // switch case
          
        lastRandMag1 = nextRandMag1;
        lastRandDir1 = nextRandDir1;
        lastRandMag2 = nextRandMag2;
        lastRandDir2 = nextRandDir2;
        } // if ( level < 9 ) ... else ...
      } // for
    } // public function drawTether
    
  public function updatePosition(upsample_rate:Number, deltaT:Number) : void
    {
    if (state == TETHER_READY)
      return;
    
    // Make sure we satisfy assumptions made later on.  
    if (nodes.length < 2 )
      return;
    
    // Place tether on ship.
    nodes[0].rx = owner.rx;
    nodes[0].ry = owner.ry;       
    // Place tether on target if applicable.   
    
    if (target != null)
      {
      nodes[numNodes-1].rx = target.rx;
      nodes[numNodes-1].ry = target.ry;
      }
    
    var frameElasticityConstant:Number;
    var dx:Number;
    var dy:Number;
    var cl:Number; // temporary to hold distance between two nodes.
    var excesslength:Number;
    var velocity_kick:Number
    var n:Number;
    
    var total_length:Number = 0;
    
    var thisNode : Particle;
    var nextNode : Particle;
    
    // Apply structural spring forces.
    frameElasticityConstant = k*deltaT/(nodeMass*upsample_rate);
    for (n = 0; n < nodes.length-1; n++)
      {
      thisNode = nodes[n];
      nextNode = nodes[n+1];
      
      dx = nextNode.rx - thisNode.rx;
      dy = nextNode.ry - thisNode.ry;
      
      cl = Math.sqrt ( dx*dx + dy*dy );
      
      excesslength = cl - dl;
      total_length += cl;
      
      //velocity_kick = excesslength*k/(nodeMass);
      velocity_kick = excesslength*frameElasticityConstant/cl;
      if (n > 0)
        {
        //thisNode.vx += (nextNode.rx - thisNode.rx) / cl * velocity_kick / upsample_rate * deltaT;
        //thisNode.vy += (nextNode.ry - thisNode.ry) / cl * velocity_kick / upsample_rate * deltaT;
        thisNode.vx += dx * velocity_kick;
        thisNode.vy += dy * velocity_kick;
        }
      else
        {
        if (state == TETHER_ATTACHED)	
          {
          // Special handler to apply force to whatever object is attached to nodes[0]  (the Ship)	
          owner.vx += (nextNode.rx - thisNode.rx)/ cl * excesslength*k/owner.mass / upsample_rate * deltaT;
          owner.vy += (nextNode.ry - thisNode.ry)/ cl * excesslength*k/owner.mass / upsample_rate * deltaT;
          }
        }
      if (n < nodes.length-2) 
        {
        //nextNode.vx += (thisNode.rx - nextNode.rx)/ cl * velocity_kick/ upsample_rate * deltaT;
        //nextNode.vy += (thisNode.ry - nextNode.ry)/ cl * velocity_kick/ upsample_rate * deltaT;
        nextNode.vx += -dx * velocity_kick;
        nextNode.vy += -dy * velocity_kick;
        }
      else
        {        
        // The last dangling tether node.
        if (target == null)
          {
          //nextNode.vx += (thisNode.rx - nextNode.rx)/ cl * velocity_kick/ upsample_rate * deltaT;
          //nextNode.vy += (thisNode.ry - nextNode.ry)/ cl * velocity_kick/ upsample_rate * deltaT; 
          nextNode.vx += -dx * velocity_kick;
          nextNode.vy += -dy * velocity_kick;
          }
        else
          {
          // Special handler to apply force to whatever object is attached to nodes[N-1]  (the Spice)	        	
          target.vx += (thisNode.rx - nextNode.rx)/ cl * excesslength*k/target.mass / upsample_rate* deltaT;
          target.vy += (thisNode.ry - nextNode.ry)/ cl * excesslength*k/target.mass / upsample_rate* deltaT;   	
          nodes[nodes.length-1].vx = target.vx;
          nodes[nodes.length-1].vy = target.vy;            
          }
        }
      }
    // Apply flexion spring forces.  
    frameElasticityConstant = k2*deltaT/(nodeMass*upsample_rate);
    for (n = 0; n < nodes.length-2; n++)
      {
      thisNode = nodes[n];
      nextNode = nodes[n+2];
      
      dx = nextNode.rx - thisNode.rx;
      dy = nextNode.ry - thisNode.ry;
      
      cl = Math.sqrt ( dx*dx + dy*dy );
      
      excesslength = cl - 2*dl;
      //velocity_kick = excesslength*k2/(m/nodes.length);
      velocity_kick = excesslength*frameElasticityConstant/cl;
      if (n > 0)
        {
        //thisNode.vx += (nextNode.rx - thisNode.rx) / cl * velocity_kick/ upsample_rate* deltaT;
        //thisNode.vy += (nextNode.ry - thisNode.ry) / cl * velocity_kick/ upsample_rate* deltaT;
        thisNode.vx += dx * velocity_kick;
        thisNode.vy += dy * velocity_kick;
        }
      else
        {
        // Special handler to apply force to whatever object is attached to nodes[0] (the Ship)	
        if (state == TETHER_ATTACHED)
          {
          owner.vx += (nextNode.rx - thisNode.rx)/ cl * excesslength*k2/owner.mass / upsample_rate* deltaT;
          owner.vy += (nextNode.ry - thisNode.ry)/ cl * excesslength*k2/owner.mass / upsample_rate* deltaT;
          }
        }     
      if (n < nodes.length-3) 
        {
        //nextNode.vx += (thisNode.rx - nextNode.rx)/ cl * velocity_kick/ upsample_rate* deltaT;
        //nextNode.vy += (thisNode.ry - nextNode.ry)/ cl * velocity_kick/ upsample_rate* deltaT;
        nextNode.vx += -dx * velocity_kick;
        nextNode.vy += -dy * velocity_kick;
        }
      else
        {        
        // The last dangling tether node.
        if (target == null)
          {
          //nextNode.vx += (thisNode.rx - nextNode.rx)/ cl * velocity_kick/ upsample_rate* deltaT;
          //nextNode.vy += (thisNode.ry - nextNode.ry)/ cl * velocity_kick/ upsample_rate* deltaT;
          nextNode.vx += -dx * velocity_kick;
          nextNode.vy += -dy * velocity_kick;
          }
        else
          {
          // Special handler to apply force to whatever object is attached to nodes[N-1]  (the Spice)	        	
          target.vx += (thisNode.rx - nextNode.rx)/ cl * excesslength*k2/target.mass / upsample_rate* deltaT;
          target.vy += (thisNode.ry - nextNode.ry)/ cl * excesslength*k2/target.mass / upsample_rate* deltaT; 	
          nodes[nodes.length-1].vx = target.vx;
          nodes[nodes.length-1].vy = target.vy;
          }        
        }
      }
    
    // Update position with velocity, damp velocity.
    for (n = 1; n < nodes.length; n++)
      {
      thisNode = nodes[n];
      thisNode.rx += thisNode.vx / upsample_rate* deltaT;
      thisNode.ry += thisNode.vy / upsample_rate* deltaT;	   
      thisNode.vx -= 0.025*thisNode.vx*deltaT;
      thisNode.vx -= 0.025*thisNode.vx*deltaT;
      
      // Old code.
      //nodes[n].vx *= 0.975;
      //nodes[n].vy *= 0.975;
      }
       
    // Check for tether snap (too much tension).
    if (state == TETHER_ATTACHED)
      if ( total_length > maximumPermissibleLength() )
        {  
        Utility.playSound ( Assets.Snap );         	        	
        owner.triggerReset (Ship.TETHER_SNAP_EVENT);
        startRecoil();            
        }
         
    }
  
  public function startRecoil() : void
    {
    if (state != TETHER_RECOILING)
      {	
      target = null;	
      state = TETHER_RECOILING;
      framecounter = nodes.length;        
      // Add some more tension to make the recoil look chaotic.    
      dl = dl*0.75;
      // Add some random position to the nodes for more chaos.              
      for (var n:Number=1; n < nodes.length; n++)
        {
        nodes[n].rx += Math.random()*20-10;	
        nodes[n].ry += Math.random()*20-10;	
        }          
      }
    }
  
  public function recoilALittle (deltaT:Number) : void
    {
    // Loose 5-15% of your length every second	(based on level)
    var percentage:Number = 0.05 + 0.1 * (owner.spec.tetherLevel / 10);    
    dl = dl*(1-percentage*deltaT/25);
    }
  
  public function maximumPermissibleLength() : Number
    {
    return snap*dl*(nodes.length-1);    	
    // return snap+max_dl*(nodes.length-1);    	
    }
  
  public function setTarget(b:Body) : Boolean
    {
    
    
    if (state == TETHER_ATTACHED && b == null)
      // User controlled release - start recoiling.
      {
      // If the target is spice, fingerprint it with release data. 
      // Clunky cast coming up...
      if (target is Spice)  
        {
        var targetSpice : Spice = Spice(target);
        targetSpice.fingerprint = new SpiceReleaseFingerprint(targetSpice.rx, targetSpice.ry, owner);	
        }
      startRecoil();
      return false;
      }   
   
    // User controlled attach. 	
    if (state == TETHER_READY && b != null)	    	
      {
      // Compute direction and distance to target.
      var dx : Number = b.rx - owner.rx;
      var dy : Number = b.ry - owner.ry;
      var d : Number = Math.sqrt(dx*dx + dy*dy);
      // Establish "rest length"
      dl = d / (nodes.length-1);       
      // If rest length is greater than our tether specifies, cap it.
      if (dl > max_dl )
        dl = max_dl;    
      if (dl < min_dl)
        dl = min_dl;  
          
      // Test the length, d, against the maximum allowable length of this tether.
      if (d > maximumPermissibleLength() )
        {
        Utility.playSound (Assets.Buzz );
        // Draw a radius of influence.
        radiusframecounter = 5;
        direction_x = dx;
        direction_y = dy;
        target = null;
        return false;
        }
      else
        {
        // Attach the tether and initialize its position / velocity settings.
        target = b;	
        for (var n:Number = 0; n < nodes.length; n++)
          {                       
          nodes[n].rx = owner.rx+ n*dx/(nodes.length-1);
          nodes[n].ry = owner.ry+ n*dy/(nodes.length-1);
          var alpha:Number = n / (nodes.length-1);      
          nodes[n].vx = (1-alpha)*owner.vx+  alpha*target.vx; 
          nodes[n].vy = (1-alpha)*owner.vy+  alpha*target.vy; 
          }        
        state = TETHER_ATTACHED;  
        Utility.playSound ( Assets.Tether );    
        radiusframecounter = 0;
        
        // Clunkiness here to avoid a subtle scoring exploit:
        // A player can capture spice with the tether, then release it (establishing a fingerprint on it).
        // An allied player can capture the adrift spice and then tow it back to base without letting it go.
        // The score will use the fingerprint from the first player, and possible give long-range bonus status
        // when it is not deserved (because a new fingerprint was never established). The solution is to
        // set the fingerprint data to null every time spice is touched. It's a non issue for any other tetherable.
        if (target is Spice)
          {
          var targetSpice2 : Spice = Spice(target);
          targetSpice2.fingerprint = null;
          }
        
        return true;
        }      
      }
    target = null;  
    return false;  
    } 
  
  
  public function drawRadius (dx:Number, dy:Number) : void
    {
    // Draw a little circular arc towards dx dy, with the radius established by maximumPermissibleLength
    var theta:Number = Math.atan2(dy,dx);	
    var steps:Number = 5;
    var halfangle:Number = Math.PI / 6;
    var r : Number = maximumPermissibleLength();
    
    var startangle:Number = -halfangle + theta;
    var endangle:Number = startangle + 2*halfangle / steps;
    for (var s : Number = 0; s < steps; s++)
      {
      var b1 : Number = startangle + (endangle - startangle)* 1/3;
      var b2 : Number = startangle + (endangle - startangle)* 2/3;
      // Draw dashed lines.      
      avatar.graphics.lineStyle(2 + 3*(owner.spec.tetherLevel/10), 0xA0A0A0, 0.25 + (radiusframecounter/5)*0.75 );
      // Avatars coordinate system is always relative to owner position.
      avatar.graphics.moveTo(r*Math.cos(startangle),  r*Math.sin(startangle) );
      avatar.graphics.lineTo(r*Math.cos(b1), r*Math.sin(b1) );
      avatar.graphics.moveTo(r*Math.cos(b2), r*Math.sin(b2) );
      avatar.graphics.lineTo(r*Math.cos(endangle), r*Math.sin(endangle) );      
      // Setup next wedge.
      startangle = endangle;
      endangle = startangle+2*halfangle/steps;
      }          
    }
  
        
  public function expire() : void
    {
    Screen.queueRemove(this);
    }
  }
} // end package