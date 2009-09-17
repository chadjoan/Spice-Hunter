package
{
import flash.display.BitmapData;

public interface IDrawable
  {
  function getLayer() : uint;
  function isVisible() : Boolean;
  function draw( bmpdata : BitmapData ) : void;
  }

} // end package