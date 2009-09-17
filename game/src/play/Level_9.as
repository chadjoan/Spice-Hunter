package play
{

import Assets;
import Utility;
import play.Level;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.geom.Point;

public class Level_9 extends Level
  // Level_9 - implements a lot of asteroids
  {
  public var Nanchor : Number; // Number of anchors

  public var SwitchGradient : Number; //Switch background
 
  public function Level_9 ()
    {
    gradientMap = null;   
    name = "Uber Asteroid";
    Nanchor = 0;    
    
    // Define the background
    background = new Assets.Background_9;
    destPoint  = new Point(0,0);
    }
  
  public override function initializeIntoEnvironment (env:Environment) : void
    // Environment gives you permission to change the contents of the following objects:
    // asteroids : Array<Asteroid> - empty
    // spices : Array<Spice> - empty
    // anchors : Array<Anchor>  - empty
    // asteroidTrigger : Number - 0, increase it to allow spontaneous asteroid generation outside the map. 50-100 is appropriate
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
	    env.spices[s].setMass(5);
      // Randomize position.
      env.spices[s].rx = Math.random()*(800-2.0*env.spices[s].collision_radius) + env.spices[s].collision_radius;
      env.spices[s].ry = Math.random()*(600-2.0*env.spices[s].collision_radius) + env.spices[s].collision_radius;
      }      
      
      //set level duration
	env.levelDuration = 223;

      env.asteroidTrigger = 300;
      env.spiceTrigger = 0; 	
      env.levelMusic  = Assets.m09;
    }

 public override function updateAnchors (env : Environment, deltaT : Number)  : void
    // A hook for moving the anchors around the screen, if you desire.
    {
     //Move background up
     destPoint.y -= .1*deltaT;
     //destPoint.x += 0*deltaT;


    }
  } 
}