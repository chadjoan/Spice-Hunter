package play
{

import Assets;
import Utility;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Transform;

public class Anchor extends Body
  {
  public static var bitmap : Bitmap = new Assets.anchor;

  public function Anchor ()
    {
    // Initialize with random mass.
    mass = 50;
    // Initialize Body members.
    omega = 0;
    phi = 0;
    collision_radius = 10;
    vx = 0;
    vy = 0;

    tooltiptext = "Anchor";

    cachebmp.bitmapData = bitmap.bitmapData;
    }

  public override function getLayer() : uint { return super.getLayer() - 3; }
  public override function useSmoothing() : Boolean { return Screen.useSmoothing(0.5); }

  // This function is only here because it might be called.  It /used/ to do something.
  public function updatePosition() : void {}

  }

} // end of package.