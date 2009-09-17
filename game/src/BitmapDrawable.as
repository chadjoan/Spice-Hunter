package
{
/*************
As an unfortunate side effect of making the Screen rendering accept only IDrawable's,
certain things like raw Bitmaps are inconvenient to queue.  This hack is a wrapper
around Bitmap that allows bitmaps to be drawn more conveniently.  
*************/

import IDrawable;

import flash.display.Bitmap;
import flash.display.BitmapData;

public class BitmapDrawable extends Bitmap implements IDrawable
  {
  private var m_layer : uint;
  private var smooth : Boolean;
  
  // See constants in Drawable to know what kind of things to put in for "layer".
  // It is the responsibility of the creator of this to queue this bitmap for drawing.
  // Ex:  new BitmapDrawable( Drawable.hud );
  public function BitmapDrawable( layer : uint, useSmoothing : Boolean = false ) : void
    {
    m_layer = layer;
    smooth = useSmoothing;
    }
  
  public function setLayer( layer : uint ) : void { m_layer = layer; }
  
  // IDrawable implementation
  public function isVisible() : Boolean { return true; }
  public function getLayer() : uint { return m_layer; }
  public function draw( backbuffer : BitmapData ) : void
    {
    backbuffer.draw(this,this.transform.matrix,this.transform.colorTransform,
                    null,null,smooth);
    }
  }
}