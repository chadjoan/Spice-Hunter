package play
{

import Assets;
import Utility;

import play.Level;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;

public class Level_6 extends Level
  // Level_6 - implements A gravity pull Down
  {
  public var Nanchor : Number; // Number of anchors

  public var SwitchGradient : Number; //Switch background
 
  public function Level_6 ()
    {
    gradientMap = new Assets.FallMiddle;
    // This is required - reducing the image to just one channel. Otherwise weird things will happen.
    reduceGradientToOneChannel ();    
    name = "FallDown";
    Nanchor = 9;    
    
    // Define the background
    background = new Assets.Background_6;
	  background.scaleX = 2;
    background.scaleY = 2;
    background.x = -1000;
    }
  
  public override function draw( backbuffer : BitmapData ) : void
    {
    backbuffer.draw(background,
                    background.transform.matrix,
                    background.transform.colorTransform);
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
    for (var s:Number=0; s < 20; s++)
      {
      env.spices[s] = new Spice();
	    env.spices[s].setMass(1);
      // Randomize position.
      env.spices[s].rx = Math.random()*(800-2.0*env.spices[s].collision_radius) + env.spices[s].collision_radius;
      env.spices[s].ry = Math.random()*(600-2.0*env.spices[s].collision_radius) + env.spices[s].collision_radius;
      }            
    
      
    
    for (var i:Number = 0; i < Nanchor; i++)      
      env.anchors.push(new Anchor() );
                    
  	env.levelDuration = 183;
    env.asteroidTrigger = 10;
    env.spiceTrigger = 10; 	
    env.levelMusic  = Assets.m06;
    }


  public override function updateAnchors (env : Environment, deltaT : Number)  : void
    // A hook for moving the anchors around the screen, if you desire.
    {
    //Mpve the background Image
    background.x += .1*deltaT;  
    background.y -= .005*deltaT;  

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