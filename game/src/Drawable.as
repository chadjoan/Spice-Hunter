package
{
import IDrawable;
import flash.display.BitmapData;

public class Drawable implements IDrawable
  {
  // layers
  public static const splash : uint      = 50;
  public static const background : uint  = 40;
  public static const midground : uint   = 30;
  public static const foreground : uint  = 20;
  public static const hud : uint         = 10;
  
  public var layer : uint;
  public var visible : Boolean = false;
  
  public function draw( bmpdata : BitmapData ) : void {}
  public function getLayer() : uint { return layer; }
  public function isVisible() : Boolean { return visible; }
  }

} // end package