package play
{

import IDrawable;

import play.Body;
import play.Tooltip;

import flash.display.Sprite;
import flash.display.BitmapData;

public class Reticle implements IDrawable
  {
  // Public interface.
  public var rx:Number;
  public var ry:Number;
  public var tooltip:Tooltip;
  public var tooltipTarget:Body;
  
  // These store direction pad state.
  // It would seem intuitive to shove them into only two integer variables
  //   as in this former implementation:
  // private var lr_state:int;  // Left/right joystick state; 
  // private var ud_state:int;  // Up/down joystick state;
  //
  // But that leads to a bug where the player holds two opposing directions
  //   at once:
  //   - The cursor will move in the direction of the key last pressed.
  //   - When the player releases one of the buttons, (lr|ud)_state is cleared,
  //       so all motion stops, even though the player is still holding a button
  //       with intent to make the thing move.  
  // This wasn't a problem on the arcade because the joystick prevented
  //   opposites (up and down, left and right) from being pressed at the same 
  //   time.  However, on the PC this is entirely doable.
  public var isUpPressed   :Boolean = false;
  public var isDownPressed :Boolean = false;
  public var isLeftPressed :Boolean = false;
  public var isRightPressed:Boolean = false;
  
  // Private implementation.
  private var vx:Number = 0;
  private var vy:Number = 0;
  private var avatar:Sprite;
 
  public var phi:Number;
  public var omega:Number;
  
  public var lengthCounter:Number; 
  public var stickyFlag : Boolean;
  
  public var radius:Number;
  // Radius of stickiness.
  public var max : Number;
  // Speed.
  public var stickyalpha : Number;
  
  public var spec : ShipSpec;
  
  private static var oneOverSqrtTwo:Number=0;
  
  // Functions.
  public function Reticle(_spec: ShipSpec)
    {
    if ( oneOverSqrtTwo == 0 )
      oneOverSqrtTwo = 1/Math.sqrt(2);
    
    spec = _spec;
    avatar = new Sprite();
    
    phi = 0;
    
    
    // All these parameters increase as you upgrade, enhancing reticle performance.
    // Assuming the reticleLevel caps out at lvl 10.
    //radius = 20 + 20*(spec.reticleLevel / 10);  
    radius = 20 + 10*(spec.reticleLevel / 10);  
    max = 15 + 15*(spec.reticleLevel / 10);  
    stickyalpha = 0.125 + 0.3 * (spec.reticleLevel / 10);
    omega = 0.05 + 0.05 * (spec.reticleLevel/10);
    
    switch (spec.playerID)
      {	    
      case 0: phi = 0; break;
      case 1: phi = Math.PI/12; break;
      case 2: phi = 2*Math.PI/12;  break;
      case 3: phi = 3*Math.PI/12; break;
      }
    
    tooltip = null;
    tooltipTarget = null;
    stickyFlag = false;
    
    Screen.queueDraw(this);
    }
  
  public function setSticky(target:Body) : void
    {	
    stickyFlag = false;
    if (target == null)
      {
      if (tooltip != null)
        tooltip.expire();
      tooltip = null;
      tooltipTarget = null;
      return;
      }
          
    if (target != tooltipTarget) 
      {
      if (tooltip != null)
        tooltip.expire();
      	
      tooltip = new Tooltip(spec.reticleLevel);
      tooltip.rx = rx;
      tooltip.ry = ry;
      tooltip.text = target.tooltiptext;
      tooltipTarget = target;
      }
   
    // "Stickiness"    
    if ( !isUpPressed && !isDownPressed && !isLeftPressed && !isRightPressed )
      {
      rx = (1-stickyalpha)*rx + stickyalpha*target.rx;
      ry = (1-stickyalpha)*ry + stickyalpha*target.ry;      
      stickyFlag = true;
      }
    
      
    }
  
  // IDrawable implementation
  public function isVisible() : Boolean { return true; }
  public function getLayer() : uint { return Drawable.hud; }
  public function draw ( backbuffer : BitmapData ) :void
    {    
    // Reticle - drawn procedurally.        
    
    // public static function draw(spec:ShipSpec, screen:Sprite, phi:Number, radius:Number, lengthCounter:Number, stickyFlag:Boolean):void
    ReticleGraphics.draw (spec, avatar, phi, radius, lengthCounter, stickyFlag);
    
    backbuffer.draw(avatar,avatar.transform.matrix,avatar.transform.colorTransform,
                    null,null,Screen.useSmoothing(0.9));
    }
  // End IDrawable implementation
  
  public function expire() : void
    {
    Screen.queueRemove(this);
    if (tooltip != null)
      tooltip.expire();
    }
  
  public function stickLeftRight(dir:int) : void
    {
    isLeftPressed = false;
    isRightPressed = false;
    if ( dir == -1 )
      isLeftPressed = true;
    else if ( dir == 1 )
      isRightPressed = true;
    }
  
  public function stickUpDown(dir:int) : void
    {
    isUpPressed = false;
    isDownPressed = false;
    if ( dir == -1 )
      isUpPressed = true;
    else if ( dir == 1 )
      isDownPressed = true;
    }
  
  public function updatePosition(deltaT:Number) : void
    {
    // Update position.	
    var lr_state:Number = 0.0;
    var ud_state:Number = 0.0;
    var unit:Number = 1.0;
    if ( lr_state != 0 && ud_state != 0 ) // It's diagonal.
      unit = oneOverSqrtTwo; // normalize it.
    if ( isRightPressed ) lr_state += unit;
    if ( isLeftPressed )  lr_state -= unit;
    if ( isUpPressed )    ud_state -= unit;
    if ( isDownPressed )  ud_state += unit;
    
    if ( lr_state == 0 && ud_state == 0 )
      {
      vx = 0;
      vy = 0;
      }
    else
      {
      if ( lr_state != 0 )
        vx += lr_state*deltaT*4;
      else
        vx /= deltaT*0.25 + 1;
      
      if ( ud_state != 0 )
        vy += ud_state*deltaT*4;
      else
        vy /= deltaT*0.25 + 1;
      
      var speed:Number;
      var m2:Number = max*0.65;
      if ( vx*vx + vy*vy > m2*m2 )
        {
        // turn [vx,vy] into a unit vector. (normalize it)
        speed = Math.sqrt(vx*vx + vy*vy);
        vx = vx/speed;
        vy = vy/speed;
        
        // Make v have magnitude max.
        vx *= m2;
        vy *= m2;
        }
      
      rx += vx*deltaT;
      ry += vy*deltaT;
      }
    
    // Clip to screen.
    if (rx > 800)
      rx = 800;
    if (rx < 0)
      rx = 0;
    if (ry > 600)
      ry = 600;
    if (ry < 0)
      ry = 0;	
    
    // Tie avatar position to (rx,ry).
    avatar.x = rx;
    avatar.y = ry;
    
    // Update tooltip if there is one available.
    if (tooltip != null)
      {
      tooltip.rx = rx+10;
      tooltip.ry = ry+10;	
      tooltip.update(deltaT);
      }
    
    // Spin
    phi += omega*deltaT;
    
    // Grow little fingers when stickied.    
    if (stickyFlag)
      {
      lengthCounter++;
      if (lengthCounter > 10)
        lengthCounter = 10;        
      }
    else
      lengthCounter = 0;
    }
  
  
  }

} // end of package.