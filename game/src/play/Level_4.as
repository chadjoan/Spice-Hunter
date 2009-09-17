package play
{

import Assets;
import Utility;

import play.Level;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.geom.Point;

public class Level_4 extends Level
  // Level_4 - implements fighting for one space spice
  {
  public var Nanchor : Number; // Number of anchors
  public var spiceSize : Number;
  public var SwitchGradient : Number; //Switch background
 
  public function Level_4 ()
    {
    gradientMap = new Assets.FallMiddle;
    // This is required - reducing the image to just one channel. Otherwise weird things will happen.
    reduceGradientToOneChannel ();    
    name = "All For One";
    Nanchor = 9;    
    SwitchGradient = 0;
    spiceSize = 10;
    
    // Define the background
    background = new Assets.Background_4;
    destPoint = new Point(0,-1200);
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
    
    // Seed a handful of new asteroids.
       
    // Make a random initial field of stationary Spices.   
    for (var s:Number=0; s < 1; s++)
      {
      env.spices[s] = new Spice();
	    env.spices[s].setMass(spiceSize);
      // Randomize position.
      env.spices[s].rx = Math.random()*(800-2.0*env.spices[s].collision_radius) + env.spices[s].collision_radius;
      env.spices[s].ry = Math.random()*(600-2.0*env.spices[s].collision_radius) + env.spices[s].collision_radius;
      }            
    
      
    
    for (var i:Number = 0; i < Nanchor; i++)      
      env.anchors.push(new Anchor() );
	            
       env.levelDuration = 175;
      env.asteroidTrigger = 0;
      env.spiceTrigger = 0; 	
      env.levelMusic  = Assets.m04;
    }


  public override function updateAnchors (env : Environment, deltaT : Number)  : void
    // A hook for moving the anchors around the screen, if you desire.
    {
      // move background
      destPoint.y += .15*deltaT;
      
      //create new spice if someone scores.
	if (env.spices.length == 0){
		for (var s:Number=0; s < 1; s++)
      	{
                  spiceSize += 2;
      		env.spices[s] = new Spice();
			env.spices[s].setMass(spiceSize);
      		// Randomize position.
      		env.spices[s].rx = Math.random()*(800-2.0*env.spices[s].collision_radius) + env.spices[s].collision_radius;
      		env.spices[s].ry = Math.random()*(600-2.0*env.spices[s].collision_radius) + env.spices[s].collision_radius;
		}
	}
    env.anchors[0].rx = 200;
    env.anchors[0].ry = 150;    
    
    env.anchors[1].rx = 400;
    env.anchors[1].ry = 150;
    
    env.anchors[2].rx = 600;
    env.anchors[2].ry = 150;
    
    env.anchors[3].rx = 200;
    env.anchors[3].ry = 300;
    
    env.anchors[4].rx = 400;
    env.anchors[4].ry = 300; 

    env.anchors[5].rx = 600;
    env.anchors[5].ry = 300;    
    
    env.anchors[6].rx = 200;
    env.anchors[6].ry = 450;
    
    env.anchors[7].rx = 400;
    env.anchors[7].ry = 450;
    
    env.anchors[8].rx = 600;
    env.anchors[8].ry = 450;
    
    
    }
  }
}