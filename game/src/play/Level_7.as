package play
{

import Assets;
import Utility;

import play.Level;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Matrix;

public class Level_7 extends Level
  // Level_7 - implements changing gradient maps
  {
  public var Nanchor : Number; // Number of anchors
  public var counter : Number; //
  public var dir : Number;
  public var speed : Number;
  public var angle : Number;
  


  public var SwitchGradient : Number; //Switch background
 
  public function Level_7 ()
    {

    gradientMap = new Assets.level7Gradient;
    // This is required - reducing the image to just one channel. Otherwise weird things will happen.
    reduceGradientToOneChannel ();
    speed = 5;
    angle = 0;
      
    name = "Fall Around";
    Nanchor = 5;
    
    background = new Assets.Background_7b;
    }
  
  public override function draw( backbuffer : BitmapData ) : void
    {
    var matrix : Matrix = background.transform.matrix;
    
    matrix.tx -= background.width / 2;
    matrix.ty -= background.height / 2;
    matrix.rotate(angle*Math.PI/180);
    matrix.tx += Screen.width / 2;
    matrix.ty += Screen.height / 2;
    
    backbuffer.draw(background, matrix,
                    background.transform.colorTransform);
    }
  
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
  public override function initializeIntoEnvironment (env:Environment) : void
    {
    
    // Seed a handful of new asteroids.
       
    // Make a random initial field of stationary Spices.   
    for (var s:Number=0; s < 20; s++)
      {
      env.spices[s] = new Spice();
	    env.spices[s].setMass(2);
      // Randomize position.
      env.spices[s].rx = Math.random()*(800-2.0*env.spices[s].collision_radius) + env.spices[s].collision_radius;
      env.spices[s].ry = Math.random()*(600-2.0*env.spices[s].collision_radius) + env.spices[s].collision_radius;
      }            
    
    for (var i:Number = 0; i < Nanchor; i++)      
      env.anchors.push(new Anchor() );
    

    env.levelDuration = 194;
    
    /*
    // Define the background
    env.bg = new Assets.Background_7b;
    Utility.center (env.bg);
    env.bg.x = 400;
    env.bg.y = 300;
    */
    
    env.asteroidTrigger = 75.0;
    env.spiceTrigger = 1.0; 	
    env.levelMusic  = Assets.m07;
    }

  public override function updateAnchors (env : Environment, deltaT : Number)  : void
    // A hook for moving the anchors around the screen, if you desire.
    {
    
    // rotate the background  
    
    //env.bg.rotation = angle;
    counter -= deltaT;
    
    /*
    var phi:Number = Math.PI - (angle / 180.0 * Math.PI) - Math.PI/4;
    var dx : Number = 400 + 500*Math.sqrt(2) * Math.cos(phi);
    var dy : Number = 300 - 500*Math.sqrt(2) * Math.sin(phi);
    env.bg.x = dx;
    env.bg.y = dy;
    */
    
    angle += speed*deltaT; 
    
    //set position of anchors
    env.anchors[0].rx = 400;
    env.anchors[0].ry = 300;    
    
    env.anchors[1].rx = 100;
    env.anchors[1].ry = 300;
    
    env.anchors[2].rx = 700;
    env.anchors[2].ry = 300;
    
    env.anchors[3].rx = 400;
    env.anchors[3].ry = 100;
    
    env.anchors[4].rx = 400;
    env.anchors[4].ry = 500; 	
    }
  }
} // end of package.