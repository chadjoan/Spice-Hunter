package play
{

import Assets;
import Utility;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.*;

public class HomeBase extends Body
  {
  public static var bitmap : Bitmap = new Assets.Base;

  public var score:Number;
  public var spec : ShipSpec;

  public function HomeBase (_spec:ShipSpec)
    {
    spec = _spec;

    mass = 1;
    // Initialize Body members.
    omega = 0;
    phi = 0;
    moment = 1;
    collision_radius = 65;
    // Sketch something "Base"ic.
    cachebmp.bitmapData = bitmap.bitmapData;
    cachebmp.transform.colorTransform = Screen.getColorTransform(spec.teamCode);

    // Initialize HomeBase members.
    score = 0;
    addScore(0);
    }

  public override function getLayer() : uint { return super.getLayer() - 1; }

  // These don't move, at all, therefore smoothing probably isn't noticable -
  //   so give it low priority.
  public override function useSmoothing() : Boolean { return Screen.useSmoothing(0.2); }

  // This function is only here because it might be called.  It /used/ to do something.
  public function updatePosition() : void  {}

  public function addScore(s:Number) : void
    {
    score += s;
    switch(spec.teamCode)
      {
      case ShipSpec.BLUE_TEAM:   tooltiptext = "Blue Base\nScore "+Utility.oneDigit(score); break;
      case ShipSpec.RED_TEAM:    tooltiptext = "Red Base\nScore "+Utility.oneDigit(score); break;
      case ShipSpec.YELLOW_TEAM: tooltiptext = "Yellow Base\nScore "+Utility.oneDigit(score); break;
      case ShipSpec.GREEN_TEAM:  tooltiptext = "Green Base\nScore "+Utility.oneDigit(score); break;
      }
    }



  }

} // end package.