package {

import flash.display.Sprite;

public class Reticle
  {
  // Public interface.
  public var rx:Number;
  public var ry:Number;    
  public var tooltip:Tooltip;
  public var tooltipTarget:Body;
  
  // Private implementation.
  private var avatar:Sprite;
  private var lr_state:int;  // Left/right joystick state.
  private var ud_state:int;  // Up/down joystick state;
 
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
  
  // Functions.
  public function Reticle(_spec: ShipSpec)
    {        
    spec = _spec;
    
    ud_state = 0;
    lr_state = 0;	    
    avatar = new Sprite();     
    Screen.hud.addChild(avatar);	
    
    
    phi = 0;
    
    
    // All these parameters increase as you upgrade, enhancing reticle performance.
    // Assuming the reticleLevel caps out at lvl 10.
    radius = 20 + 20*(spec.reticleLevel / 10);  
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
    draw();
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
    if (ud_state == 0 && lr_state == 0)
      {
      rx = (1-stickyalpha)*rx + stickyalpha*target.rx;
      ry = (1-stickyalpha)*ry + stickyalpha*target.ry;      
      stickyFlag = true;
      }
    
      
    }
  
  public function draw () :void
    {    
    // Reticle - drawn procedurally.        
    
    // public static function draw(spec:ShipSpec, screen:Sprite, phi:Number, radius:Number, lengthCounter:Number, stickyFlag:Boolean):void
    ReticleGraphics.draw (spec, avatar, phi, radius, lengthCounter, stickyFlag);
    
    /*
    avatar.graphics.clear ();                
    var linewidth:Number = 2+(spec.reticleLevel/10)*2;
    
    avatar.graphics.lineStyle(linewidth, Screen.getColor(spec.teamCode), 1);
    
    //Draw the arcs.    
    var theta : Number;
    var steps: Number = 5;
    var i : Number;
    var theta_offset:Number = Math.PI/6;
    var beta : Number;
    
    theta = phi;    
    avatar.graphics.moveTo(radius*Math.cos(theta-theta_offset),  radius*Math.sin(theta-theta_offset)  );
    for (i = 1; i <= steps; i++)
      {
      beta = (theta - theta_offset) + 2*theta_offset*(i / steps);
      avatar.graphics.lineTo(radius*Math.cos(beta),  radius*Math.sin(beta) );
      }
    
    theta = phi + 2*Math.PI/3;    
    avatar.graphics.moveTo(radius*Math.cos(theta-theta_offset),  radius*Math.sin(theta-theta_offset)  );
    for (i = 1; i <= steps; i++)
      {
      beta = (theta - theta_offset) + 2*theta_offset*(i / steps);
      avatar.graphics.lineTo(radius*Math.cos(beta),  radius*Math.sin(beta) );
      }
    
    theta = phi - 2*Math.PI/3;    
    avatar.graphics.moveTo(radius*Math.cos(theta-theta_offset),  radius*Math.sin(theta-theta_offset)  );
    for (i = 1; i <= steps; i++)
      {
      beta = (theta - theta_offset) + 2*theta_offset*(i / steps);
      avatar.graphics.lineTo(radius*Math.cos(beta),  radius*Math.sin(beta) );
      }
    
    if (stickyFlag)
      {
          // Draw little lines.
          theta = phi;
          avatar.graphics.moveTo(radius*Math.cos(theta),  radius*Math.sin(theta)  );
          avatar.graphics.lineTo((radius-lengthCounter)*Math.cos(theta), (radius-lengthCounter)*Math.sin(theta) );
          
          // Draw little lines.
          theta = phi + 2*Math.PI/3;    
          avatar.graphics.moveTo(radius*Math.cos(theta),  radius*Math.sin(theta)  );
          avatar.graphics.lineTo((radius-lengthCounter)*Math.cos(theta), (radius-lengthCounter)*Math.sin(theta) );
          
          // Draw little lines.
          theta = phi - 2*Math.PI/3;    
          avatar.graphics.moveTo(radius*Math.cos(theta),  radius*Math.sin(theta)  );
          avatar.graphics.lineTo((radius-lengthCounter)*Math.cos(theta), (radius-lengthCounter)*Math.sin(theta) );
      }
    */
    
    }
  
  public function expire() : void
    {
    Screen.hud.removeChild(avatar);	
    if (tooltip != null)
      tooltip.expire();
    }
    
  public function stickLeftRight (state:Number) : void
    {
    lr_state = state;	    
    }
    
  public function stickUpDown(state:Number) : void
    {
    ud_state = state;	
    }
    
  public function updatePosition(deltaT:Number) : void
    {           
    // Update position.	
    rx += max*lr_state*deltaT;
    ry += max*ud_state*deltaT;	
    
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
      
    draw ();  
    }
  
  
  }

} // end of package.