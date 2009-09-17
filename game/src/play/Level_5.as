package play
{
import Assets;
import Utility;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Matrix;

public class Level_5 extends Level
  // Level_5 - implements spiral galaxy level (rotating anchors)
  {
  public var phi : Number;    // Angular position - in radians.	
  public var omega : Number;  // Angular velocity in radians per 25th of a second
  public var radius : Number  // radius of spiral path, in pixels. 
  public var Nanchor : Number; // Number of anchors
  public var angle : Number;
  public var speed : Number;
  public var bgContainer : Sprite;
     
 
  public function Level_5 ()
    {
    gradientMap = null;
    name = "Spirius Galaxy";
    phi = 0;
    omega = 0.01;
    radius = 200;
    Nanchor = 2;  
    angle = 0;  
    speed = -.0005;
    
    background = new Assets.Background_5;
    }
  
  public override function draw( backbuffer : BitmapData ) : void
    {
    var matrix : Matrix = background.transform.matrix;
    
    matrix.tx -= background.width / 2;
    matrix.ty -= background.height / 2;
    matrix.rotate(angle);
    matrix.tx += Screen.width / 2;
    matrix.ty += Screen.height / 2;
    
    backbuffer.draw(background, matrix,
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
    env.asteroids[0] = new Asteroid();
    env.asteroids[0].rx = 400;
    env.asteroids[0].ry = 300;
    
    env.asteroids[1] = new Asteroid();
    env.asteroids[1].rx = 600;
    env.asteroids[1].ry = 100;
    
    env.asteroids[2] = new Asteroid();
    env.asteroids[2].rx = 100;
    env.asteroids[2].ry = 500;
    
    env.asteroids[3] = new Asteroid();
    env.asteroids[3].rx = 150;
    env.asteroids[3].ry = 120;
    
    env.asteroids[4] = new Asteroid();
    env.asteroids[4].rx = 600;
    env.asteroids[4].ry = 400;    
    
    // Make a random initial field of stationary Spices.   
    for (var s:Number=0; s < 8; s++)
      {
      env.spices[s] = new Spice();
      // Randomize position.
      env.spices[s].rx = Math.random()*(800-2.0*env.spices[s].collision_radius) + env.spices[s].collision_radius;
      env.spices[s].ry = Math.random()*(600-2.0*env.spices[s].collision_radius) + env.spices[s].collision_radius;
      }            
    
      
    
    for (var i:Number = 0; i < Nanchor; i++)      
      env.anchors.push(new Anchor() );


    env.levelDuration = 188;
    
    /*
    // Define the background
    env.bg = new Assets.Background_5;
    Utility.center(env.bg);
    
    var tMatrix:Matrix = new Matrix();
		tMatrix.translate(400, 300);
		var tempMatrix:Matrix = env.bg.transform.matrix;
		tempMatrix.concat(tMatrix);
		env.bg.transform.matrix = tempMatrix;
    */
    
    env.asteroidTrigger = 30.0;
    env.spiceTrigger = 5.0; 	
    env.levelMusic  = Assets.m05;
  }
 

  /*
 	private function rotateBackground (env : Environment, deltaT : Number):void {
		var phi2:Number = Math.PI - (angle / 180.0 * Math.PI) - Math.PI/4;
		var dx : Number = 400 + ( 500*Math.SQRT2 * Math.cos(phi2) );
		var dy : Number = 300 - ( 500*Math.SQRT2 * Math.sin(phi2) );

		dx = 400;
		dy = 300;

    var tInMatrix:Matrix = new Matrix();
		tInMatrix.translate(-dx, -dy);

    var rotMatrix:Matrix = new Matrix();
		rotMatrix.rotate(speed*deltaT);

    var tOutMatrix:Matrix = new Matrix();
		tOutMatrix.translate(dx, dy);
		
		var tempMatrix:Matrix = env.bg.transform.matrix;
		tempMatrix.concat(tInMatrix);
		tempMatrix.concat(rotMatrix);
		tempMatrix.concat(tOutMatrix);
		env.bg.transform.matrix = tempMatrix;

		angle += speed*deltaT; 


		// begin subcomment commented out code
		//env.bg.rotation = Math.round(angle);
		//var phi2:Number = Math.PI - (angle / 180.0 * Math.PI) - Math.PI/4;

		//var phi2_discrete:Number = Math.round(phi2*180.0/Math.PI) * Math.PI / 180.0;

		//var dx : Number = 400 + 500*Math.sqrt(2) * Math.cos(phi2);
		//var dy : Number = 300 - 500*Math.sqrt(2) * Math.sin(phi2);
		//env.bg.x = dx;
		//env.bg.y = dy;

		//angle += speed*deltaT; 
		// end subcomment commented out code
    }*/


  public override function updateAnchors (env : Environment, deltaT : Number)  : void
    // A hook for moving the anchors around the screen, if you desire.
    {
    // move background
    //rotateBackground (env, deltaT);
		angle += speed*deltaT; 
    
    phi += omega * deltaT;
    if (phi > 2 * Math.PI)
    phi -= 2*Math.PI;
    
    for (var i: Number = 0; i < Nanchor; i++)
      {
      // Set position.	
      env.anchors[i].rx = 400 + radius * Math.cos(phi + i*2*Math.PI/Nanchor);
      env.anchors[i].ry = 300 + radius * Math.sin(phi + i*2*Math.PI/Nanchor);
      // Set velocity.
      env.anchors[i].vx = radius*omega * Math.cos(phi + i*2*Math.PI/Nanchor +  Math.PI/2 );
      env.anchors[i].vy = radius*omega * Math.sin(phi + i*2*Math.PI/Nanchor +  Math.PI/2 );
      }
      	
    }
    
  
  }

} // end of package.