package play
{

import Assets;
import Utility;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.geom.Point;

public class Level_0 extends Level
  // Level_0 - implements black hole level (sucks everything into center.)
  {
 
  public function Level_0 ()
    {
    gradientMap = new Assets.blackhole;
    // This is required - reducing the image to just one channel. Otherwise weird things will happen.
    reduceGradientToOneChannel ();
    name = "Black Hole Zone";    
    background = new Assets.Background_0;
    destPoint = new Point(0,0);
    }
  
  public override function initializeIntoEnvironment (env:Environment) : void
    // Environment gives you permission to change the contents of the following objects:
    // asteroids : Array<Asteroid> - empty
    // spices : Array<Spice> - empty
    // anchors : Array<Anchor>  - empty
    // asteroidTrigger : Number - 0, increase it to allow spontaneous asteroid generation outside the map.
    // spiceTrigger : Number - 0, increase it to allow spontaneous spice generation outside the map.
    // bg : Bitmap
    
    // You are not permitted to change:
    // homebases : Array<HomeBase>
    // ships : Array<Ship>
    // dummyNodes : Array<DummyMapNode>
    // shipSpecs : Array<ShipSpec>    	
    {
  
    
    // Make a random initial field of stationary Spices.   
    for (var s:Number=0; s < 8; s++)
      {
      env.spices[s] = new Spice();
      // Randomize position.
      env.spices[s].rx = Math.random()*(800-2.0*env.spices[s].collision_radius) + env.spices[s].collision_radius;
      env.spices[s].ry = Math.random()*(600-2.0*env.spices[s].collision_radius) + env.spices[s].collision_radius;
      }            
              
    for (s = 0; s < 1; s++)          
      env.anchors.push(new Anchor() );

                 
    // Define the background
    
    env.levelDuration = 186
    env.asteroidTrigger = 50.0;   
    env.spiceTrigger = 5.0; 	 	
    env.levelMusic  = Assets.m0;
    }

  public override function updateAnchors (env : Environment, deltaT : Number)  : void
    // A hook for moving the anchors around the screen, if you desire.
    {
    env.anchors[0].rx = 400;
    env.anchors[0].ry = 300;    
    /*
    env.anchors[1].rx = 100;
    env.anchors[1].ry = 300;
    
    env.anchors[2].rx = 700;
    env.anchors[2].ry = 300;
    
    env.anchors[3].rx = 400;
    env.anchors[3].ry = 100;
    
    env.anchors[4].rx = 400;
    env.anchors[4].ry = 500;
    */
    
    for (var i : Number = 0; i < env.anchors.length; i++)
      {
      env.anchors[i].vx = 0;
      env.anchors[i].vy = 0;    	 
      }   	
    }
  }
} // end of package.