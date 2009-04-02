

package {

import Assets;
import flash.display.Sprite;
import flash.display.Bitmap;

public class Animation
  {  
  public var rx : Number;
  public var ry : Number;
  public var radius : Number;
  
  // Finite state machine variables.
  public var state:Number;            // What frame should be on the screen.
  public var renderedState : Number;  // What frame is actually on the screen - when these are not the same, pull the old image and put up a new one.
  public var maxState : Number;       // The last state we have.
  public var counter : Number;   // How long this animation has been displayed so far. Measured in 1/25ths of a second.
  public var duration : Number;  // How long this animation should last. Measured in 1/25ths of a second.
  
  // State variables for rendering.
  public var avatar:Sprite;  
  public var isExpired:Boolean;
  public var isRendered:Boolean;
  
  // This pointer can be set to make an animation follow this body.
  public var boundTo:Body;
  public var boundTo_offsetx : Number;  // Some programmable offsets too. 
  public var boundTo_offsety : Number;  // Initialized to zero, publicly visible properties so that other objects can set them.
  public var boundTo_enableRotation : Boolean; // Set true to let the animation rotate with the boundTo body. If false, no rotation is applied (so text stays legible).
  
  // State variable for keeping track of what renderplane this animation is on.
  // Previously, it was assumed that all animations resided on the midground plane.
  // However, it was desired to move the bonus messages ("Nice Shot", "Oh Snap", et al) to
  // the HUD plane on top of the other objects. Since all animations are no longer defined
  // on the same plane, they need a state variable (supplied through a constructor) to
  // determine where they go.
  private var renderPlane : Sprite;
  
  public function Animation (RenderPlane : Sprite)
    {    	      
    renderPlane = RenderPlane;
    avatar = new Sprite;
    renderPlane.addChild(avatar);
    isExpired = false;
    isRendered = false;
    rx = 0;
    ry = 0;
    radius = 0;
    
    // Start in state 0 (first frame), set renderedState to state 1 to trigger a draw.
    state = 0;
    renderedState = -1;
    counter = 0;
    
    boundTo = null;        
    boundTo_offsetx = 0;
    boundTo_offsety = 0;
    boundTo_enableRotation = true;
    }
  
  public function draw() : void
    {    
    if (boundTo != null)
      {
      rx = boundTo.rx + boundTo_offsetx;
      ry = boundTo.ry + boundTo_offsety;
      if (boundTo_enableRotation)
        avatar.rotation = boundTo.avatar.rotation;
        
      }
    
    /*
    if (state == renderedState)
      return;
    */  
      
    if (isRendered)
      avatar.removeChildAt(0);
     
    var bmp : Bitmap = getFrame(state);	
    
    renderedState = state;
    bmp.scaleX = radius / (bmp.width/2);
    bmp.scaleY = radius / (bmp.height/2);      
    
    // eep hack    
    bmp.scaleY = bmp.scaleX;
    
    Utility.center(bmp); 
    avatar.addChildAt(bmp,0);       
    avatar.x = rx;
    avatar.y = ry;    
    isRendered = true;
    }
 
  public function update(deltaT:Number) : void
    {  	
    // Figure out what state to display.
    counter += deltaT;    
    if (counter > duration)
      expire ();    
    state = Math.round(maxState*counter / duration);    
    if (state > maxState)
      state = maxState;
    draw();
    }
    
  public function expire() : void
    {
    if (isRendered)	
      {
      renderPlane.removeChild(avatar);	
      isRendered = false;
      }
    isExpired = true;
    }
    
  public function getFrame(whichstate:Number) : Bitmap
    {
    switch(state)
      {
      case 0: return new Assets.explode01; break;
      case 1: return new Assets.explode02; break;
      case 2: return new Assets.explode03; break;
      case 3: return new Assets.explode04; break;
      case 4: return new Assets.explode05; break;  
      case 5: return new Assets.explode06; break;          
      case 6: return new Assets.explode07; break;
      case 7: return new Assets.explode08; break;
      case 8: return new Assets.explode09; break;
      case 9: return new Assets.explode10; break;      
      }    
    
    return null;
    }
  }
} // end package