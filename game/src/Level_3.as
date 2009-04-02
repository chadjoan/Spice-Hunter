package {

import Assets;
import Utility;

import flash.display.Bitmap;
import flash.display.Sprite;

public class Level_3 extends Level
  // Level_3 - implements BlueLevel (random configurations)
  {
 
	public var Nanchor : Number; // Number of anchors
	public var angle : Number;
	public var dist : Number;
	public var speed: Number;
      
	


  public function Level_3 ()
    {
    gradientMap = null;
    name = "Blue Horizon";
    Nanchor = 10;	  
    dist = 200; 
    speed = .005; 
    angle = 0;
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
    
   
    for (var i:Number = 0; i < Nanchor; i++)      
    env.anchors.push(new Anchor() );
    
    // Make a random initial field of stationary Spices.   
    for (var s:Number=0; s < 8; s++)
      {
      env.spices[s] = new Spice();
	env.spices[s].setMass(5);
      // Randomize position.
      env.spices[s].rx = Math.random()*(800-2.0*env.spices[s].collision_radius) + env.spices[s].collision_radius;
      env.spices[s].ry = Math.random()*(600-2.0*env.spices[s].collision_radius) + env.spices[s].collision_radius;
      }            
    
	

	//set Anchor positions
	for ( var t:Number = 0; t < Nanchor; t++){
	env.anchors[t].rx = 400 + Math.cos(t*.2*Math.PI)*dist; 
	env.anchors[t].ry = 300 + Math.sin(t*.2*Math.PI)*dist;

	}
     //set Levels duration;             
     env.levelDuration = 192;	
     // Define the background
     env.bg = new Assets.Background_3;
     env.bg.scaleX = 1.5;
     env.bg.scaleY = 1.5;
     env.bg.x = -200;
     env.asteroidTrigger = 20.0;
     env.spiceTrigger = 5.0;	
     env.levelMusic  = new Assets.m03;
}
    
public override function updateAnchors (env : Environment, deltaT : Number)  : void
    // A hook for moving the anchors around the screen, if you desire.
    {
      //move background hack!
      env.bg.x +=.01*deltaT;
      env.bg.y -=.01*deltaT;
      
	for ( var t:Number = 0; t < Nanchor; t++){
		env.anchors[t].rx = 400 +  Math.cos(angle+ t*.2*Math.PI)*dist; 
		env.anchors[t].ry = 300 +  Math.sin(angle+ t*.2*Math.PI)*dist;            
	} 	
    	angle += speed*deltaT;
    }  
  }
} // end of package.