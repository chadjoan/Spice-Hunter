package play
{

import Assets;
import Utility;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;

public class Level_1 extends Level
  // Level_1 - implements uncharted space level (random configurations)
  {
 
  public function Level_1 ()
    {
    gradientMap = null;
    name = "Uncharted Space";
    // Define the background
    background = new Assets.Background_1;
    background.scaleX = 4;
    background.scaleY = 4;
    }
  
  public override function draw( backbuffer : BitmapData ) : void
    {
    backbuffer.draw(background,
                    background.transform.matrix,
                    background.transform.colorTransform);
    }
  
  public function expire():void
    {
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
    
    // Make an random initial field of moving Asteroids.   
    for (var a:Number=0; a < 8; a++)
      {
      env.asteroids[a] = new Asteroid();
      // Randomize position.
      env.asteroids[a].rx = Math.random()*(800-2.0*env.asteroids[a].collision_radius) + env.asteroids[a].collision_radius;
      env.asteroids[a].ry = Math.random()*(600-2.0*env.asteroids[a].collision_radius) + env.asteroids[a].collision_radius;                  
      // Randomize velocity.
      var v:Number = Math.random()*1.5;            
      var phi:Number = Math.random()*2.0*Math.PI;      
      env.asteroids[a].vx = v*Math.sin(phi);
      env.asteroids[a].vy = v*Math.cos(phi);
      }

    // Make a random initial field of stationary Spices.   
    for (var s:Number=0; s < 8; s++)
      {
      env.spices[s] = new Spice();
      // Randomize position.
      env.spices[s].rx = Math.random()*(800-2.0*env.spices[s].collision_radius) + env.spices[s].collision_radius;
      env.spices[s].ry = Math.random()*(600-2.0*env.spices[s].collision_radius) + env.spices[s].collision_radius;
      }            

    
    // set level duration
    env.levelDuration = 180;
    env.asteroidTrigger = 100.0;
    env.spiceTrigger = 5.0;	
    env.levelMusic  = Assets.m01;
    }

    public override function updateAnchors (env : Environment, deltaT : Number)  : void
    // A hook for moving the anchors around the screen, if you desire.
    {
        //Move background a hack!
        background.x-=.3*deltaT;
        background.y-=.3*deltaT;
        //env.bg.x-=.3*deltaT;
        //env.bg.y-=.3*deltaT;
    }
  }
} // end of package.