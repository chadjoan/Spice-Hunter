package play
{

import Assets;
import Utility;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.geom.Point;

public class Level_2 extends Level
  // Level_2 - implements crisscross Anchors)
  {
 
public var AnchorArrayX : Array;
public var AnchorArrayY : Array;

public var AnchorAddX1 : Number;
public var AnchorAddX2 : Number;
public var AnchorAddX3 : Number;
public var AnchorAddX4 : Number;

public var AnchorAddY1 : Number;
public var AnchorAddY2 : Number;
public var AnchorAddY3 : Number;
public var AnchorAddY4 : Number;

  public function Level_2 ()
    {
    gradientMap = new Assets.Gemini;
    // This is required - reducing the image to just one channel. Otherwise weird things will happen.
    reduceGradientToOneChannel ();
    name = "Gemini"; 
    AnchorArrayX = [0,0,0,0];
    AnchorArrayY = [0,0,0,0];

    background = new Assets.Background_2;
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
              
    for (s = 0; s < 4; s++)          
      env.anchors.push(new Anchor() );

                  
    env.levelDuration = 188;
    env.asteroidTrigger = 50.0;   
    env.spiceTrigger = 5.0; 	 	
    env.levelMusic  = Assets.m0205;

    //setup variables that controll speed of anchors
    AnchorArrayX[0] = -.5;
    AnchorArrayY[0] = .375;
    AnchorArrayX[1] = .5;
    AnchorArrayY[1] = .375;
    AnchorArrayX[2] = .5;
    AnchorArrayY[2] = -.375;
    AnchorArrayX[3] = -.5;
    AnchorArrayY[3] = -.375;

    // position anchors
    env.anchors[0].rx = 800;
    env.anchors[0].ry = 0;    
    
    env.anchors[1].rx = 0;
    env.anchors[1].ry = 0;
    
    env.anchors[2].rx = 0;
    env.anchors[2].ry = 600;
    
    env.anchors[3].rx = 800;
    env.anchors[3].ry = 600;

    // Set starting positions of anchors that will set anchor position during game
    AnchorAddX1 = 800;
    AnchorAddX2 = 0;
    AnchorAddX3 = 0;
    AnchorAddX4 = 800;

    AnchorAddY1 = 0;
    AnchorAddY2 = 0;
    AnchorAddY3 = 600;
    AnchorAddY4 = 600;
    
    }

  public override function updateAnchors (env : Environment, deltaT : Number)  : void
    // A hook for moving the anchors around the screen, if you desire.
    {

    for (var j : Number = 0; j < env.anchors.length; j++)
    {

	if (env.anchors[j].rx < 0)
	{
                env.anchors[j].rx = 1
		AnchorArrayX[j] = AnchorArrayX[j]*-1;
                AnchorArrayY[j] = AnchorArrayY[j]*-1;
	}


	if (env.anchors[j].rx > 800)
	{
		env.anchors[j].rx = 798;
		AnchorArrayX[j] = AnchorArrayX[j]*-1;
                AnchorArrayY[j] = AnchorArrayY[j]*-1;
	}

     }

  for (var s : Number = 0; s < 4; s++)
	{
	// a fixed number to anchor set position
	AnchorAddX1 = AnchorAddX1 + AnchorArrayX[0];
	AnchorAddX2 = AnchorAddX2 + AnchorArrayX[1];
	AnchorAddX3 = AnchorAddX3 + AnchorArrayX[2];
	AnchorAddX4 = AnchorAddX4 + AnchorArrayX[3];

	AnchorAddY1 = AnchorAddY1 + AnchorArrayY[0];
	AnchorAddY2 = AnchorAddY2 + AnchorArrayY[1];
	AnchorAddY3 = AnchorAddY3 + AnchorArrayY[2];
	AnchorAddY4 = AnchorAddY4 + AnchorArrayY[3];

	//reset the position of the anchors
	env.anchors[0].rx = AnchorAddX1;
	env.anchors[1].rx = AnchorAddX2;
	env.anchors[2].rx = AnchorAddX3;
	env.anchors[3].rx = AnchorAddX4;

	env.anchors[0].ry = AnchorAddY1;
	env.anchors[1].ry = AnchorAddY2;
	env.anchors[2].ry = AnchorAddY3;
	env.anchors[3].ry = AnchorAddY4;
	
	}
   
    for (var i : Number = 0; i < env.anchors.length; i++)
      {
      env.anchors[i].vx = 0;
      env.anchors[i].vy = 0;    	 
      }

             	
    }
  
  }

} // end of package.
