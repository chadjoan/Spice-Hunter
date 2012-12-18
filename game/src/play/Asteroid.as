package play
{

import Assets;
import Utility;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;

import flash.geom.Transform;

public class Asteroid extends Body
  {
  private static var astBitmaps : Array;
  private static var initialized : Boolean = false;

  public static function init() : void
    {
    astBitmaps = new Array(4);
    astBitmaps[0] = new Assets.Asteroid;
    astBitmaps[1] = new Assets.Asteroid6;
    astBitmaps[2] = new Assets.Asteroid7;
    astBitmaps[3] = new Assets.Asteroid8;
    initialized = true;
    }

  public function Asteroid ()
    {
    if ( !initialized )
      init();

    // Initialize with random mass.
    setMass (Math.random()*10+10);
    // Initialize Body members.
    omega = Math.random()*0.2 - 0.1;
    phi = Math.random()*2.0*Math.PI;

    var bmpCode:Number = Math.round( Math.random() * 4 );
    cachebmp.bitmapData = astBitmaps[bmpCode % 4].bitmapData;
    }

  public function setMass (m:Number) : void
    {
    // Take in new mass.
    mass = m;
    // Compute new collision radius:
    collision_radius = 25*Math.sqrt(mass/10);
    // Compute new moment of inertia.
    moment = mass*collision_radius^2;
    tooltiptext = "Asteroid\nMass " + Utility.oneDigit(mass);
    }

  public override function getLayer() : uint { return super.getLayer() - 3; }
  public override function useSmoothing() : Boolean { return Screen.useSmoothing(0.6); }

  public function updatePosition(deltaT : Number) : void
    {
    // Update position.
    rx += vx * deltaT;
    ry += vy * deltaT;
    phi += omega * deltaT;

    // Bounce off walls.
    super.bounceClip();

    // Damp velocity.
    // Loose 1% of your velocity every second.
    var percentage:Number = 0.05;
    vx = vx * (1 - percentage * deltaT / 25);
    vy = vy * (1 - percentage * deltaT / 25);
    }


  // No bouncing off walls logic for this - for when the asteroid is outside the boundary.
  public function updatePositionOutside(deltaT : Number) : void
    {
    // Update position.
    rx += vx * deltaT;
    ry += vy * deltaT;
    phi += omega * deltaT;
    }


  }

} // end of package.