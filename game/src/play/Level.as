package play
{

import Assets;
import Utility;
import Screen;
import Drawable;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;

import flash.geom.Point;

public class Level implements IDrawable
  {
  // A class for implementing different level designs.	
  public var gradientMap : Bitmap;
  public var name : String;  
  // For the future
  // public var flowForces : Array;
  
  public var background : Bitmap;
  public var destPoint : Point;
  
  public function Level ()
    {
    gradientMap = null;
    name = "Untitled";	
    destPoint = new Point(0,0);
    Screen.queueDraw(this);
    }
  
  // IDrawable implementation
  public function getLayer() : uint { return Drawable.background; }
  public function isVisible() : Boolean { return true; }
  public function draw( backbuffer : BitmapData ) : void
    {
    var bdata : BitmapData = background.bitmapData;
    backbuffer.copyPixels(bdata, bdata.rect, destPoint);
    }
  
  public function initializeIntoEnvironment (env:Environment) : void
    // Environment gives you permission to change the contents of the following objects:
    // asteroids : Array<Asteroid> - empty
    // spices : Array<Spice> - empty
    // anchors : Array<Anchor>  - empty
    // asteroidTrigger : Number - 0, increase it to allow spontaneous asteroid generation outside the map.
    // spiceTrigger : Number - 0, increase it to allow spontaneous spice generation outside the map.
    // bg : Bitmap
    // levelDuration : Number, the duration of this level in seconds (for the countdown timer). Defaults to 180 seconds if you don't change it. Capped at 9:59 = 599 seconds
    // levelMusic : Sound, the music of this level. Initialized to null, you change it.
    
    // You are not permitted to change:
    // homebases : Array<HomeBase>
    // ships : Array<Ship>
    // dummyNodes : Array<DummyMapNode>
    // shipSpecs : Array<ShipSpec>
    	
    {
    }
  
  public function reduceGradientToOneChannel () : void
    {
    	
    for (var ix : Number = 0; ix < 800; ix++)
      for (var iy : Number = 0; iy < 600; iy++)
        {
        var newColor : uint = gradientMap.bitmapData.getPixel(ix,iy) % 256;
        gradientMap.bitmapData.setPixel(ix,iy,newColor);
        }
        
    }
    
  public function updateAnchors (env : Environment, deltaT : Number)  : void
    // A hook for moving the anchors around the screen, if you desire.
    {
    }
  
  public function applyForcesTo(body : Body, deltaT : Number) : void
    {
    var gx_int:int;
    var gy_int:int;
    
    var gx:Number;
    var gy:Number;
    
    var rx_int : int;
    var ry_int : int;
        
    var tau : uint = 5;
    var scale:Number = 0.05 / tau / body.mass;
    
    // Establish an integer position within the bitmap.
    rx_int = Math.round (body.rx);	
    ry_int = Math.round (body.ry);
    if (rx_int > 800-tau-1)
      rx_int = 800-tau-1;
    if (ry_int > 600-tau-1)
      ry_int = 600-tau-1;
    if (rx_int < tau)
      rx_int = tau;
    if (ry_int < tau)
      ry_int = tau;
                        
    // Compute gradient data using 9 point sobel high pass filter. 
    gx_int = 2*gradientMap.bitmapData.getPixel(rx_int+tau, ry_int) - 2*gradientMap.bitmapData.getPixel(rx_int-tau, ry_int)
           + 1*gradientMap.bitmapData.getPixel(rx_int+tau, ry_int+tau) - 1*gradientMap.bitmapData.getPixel(rx_int-tau, ry_int+tau)
           + 1*gradientMap.bitmapData.getPixel(rx_int+tau, ry_int-tau) - 1*gradientMap.bitmapData.getPixel(rx_int-tau, ry_int-tau); 
                         
    gy_int = 2*gradientMap.bitmapData.getPixel(rx_int, ry_int+tau) - 2*gradientMap.bitmapData.getPixel(rx_int, ry_int-tau)
           + 1*gradientMap.bitmapData.getPixel(rx_int+tau, ry_int+tau) - 1*gradientMap.bitmapData.getPixel(rx_int+tau, ry_int-tau)
           + 1*gradientMap.bitmapData.getPixel(rx_int-tau, ry_int+tau) - 1*gradientMap.bitmapData.getPixel(rx_int-tau, ry_int-tau)
                                             
    gx = -gx_int*scale*deltaT;
    gy = -gy_int*scale*deltaT;        
    body.vx += gx;
    body.vy += gy;	    
    }
  
  public function applyForcesIntoEnvironment (env : Environment, deltaT : Number) : void
    // A hook for applying forces to objects in the environment, if you desire.
    // Default method will give you gradient field only.
    {
    var i:Number;	      
    if (gradientMap != null)
      {      
      // Loop over spices.
      /*
      for (i = 0; i < env.spices.length; i++)    
        applyForcesTo (env.spices[i], deltaT);    
      */  
        
      // Loop over asteroids.
      for (i = 0; i < env.asteroids.length; i++)    
        applyForcesTo (env.asteroids[i], deltaT);             
      // Loop over ships.	
      for (i = 0; i < env.ships.length; i++)    
        applyForcesTo (env.ships[i], deltaT);                      
      }
      
    }
  
    
  
  }

} // end of package.