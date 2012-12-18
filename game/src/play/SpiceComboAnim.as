package play
{

import Assets;
import Drawable;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.ColorTransform;

public class SpiceComboAnim extends Animation
  {
  private var teamCode : Number;
  public static var image : Bitmap = new Assets.bonusSpiceCombo;
  public override function getLayer() : uint { return Drawable.hud; }

  public function SpiceComboAnim (_teamCode : Number)
    {
    super();
    cachebmp.bitmapData = image.bitmapData;
    duration = 25;  // 1 second duration - this variable measured in 1/25ths of a second.
    teamCode = _teamCode;

    // Apply a color transform
    cachebmp.transform.colorTransform = Screen.getColorTransform(teamCode);
    }

  public override function maxFrames() : uint
    {
    return 10;
    }

  public override function getFrame(frameNumber:uint) : Bitmap
    {
    Utility.center(cachebmp);
    // Apply an alpha jumpin / jumpout. Sweep from 0.4 to 1.0 to 0.4
    cachebmp.alpha = 1.0 - 0.6 * Math.abs(frameNumber-5)/5;
    return cachebmp;
    }
  }
} // end package