package play
{

import Assets;
import Utility;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Transform;

public class Spice extends Body
  {
  public static var bitmap : Bitmap = new Assets.SpaceSpice;
  public var fingerprint : SpiceReleaseFingerprint;

  public function Spice ()
    {
    // Initialize Particle members.
    rx = 600;
    ry = 100;
    vx = 0;
    vy = 0;
    setMass(Math.random()*1.0+1.0);

    // Initialize Body members.
    omega = Math.random()*0.2 - 0.1;
    phi = 0;
    collision_radius = 10*Math.sqrt(mass/1);

    moment = mass*collision_radius*collision_radius;

    cachebmp.bitmapData = bitmap.bitmapData;
    }

  public function setMass (m:Number) : void
    {
    // Take in new mass.
    mass = m;
    // Compute new collision radius:
    collision_radius = 10*Math.sqrt(mass/1);
    // Compute new moment of inertia.
    moment = mass*collision_radius^2;
    tooltiptext = "Spice\nValue " + Utility.oneDigit(value());
    }



  public override function getLayer() : uint { return super.getLayer() - 5; }

  // They kinda look better without smoothing...
  public override function useSmoothing() : Boolean { return Screen.useSmoothing(0.0); }

  public function value () : Number
    {
    return Math.round(mass*50);
    }

  public function updatePosition(deltaT:Number) : void
    {
    // Update position.
    rx += vx * deltaT;
    ry += vy * deltaT;
    phi += omega * deltaT;

    // Bounce off walls.
    super.bounceClipDamped();
    }

  public function updatePositionOutside(deltaT : Number) : void
    {
    // Update position.
    rx += vx * deltaT;
    ry += vy * deltaT;
    phi += omega * deltaT;
    }


  }

} // end of package.