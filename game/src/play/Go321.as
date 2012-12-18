package play
{

import IDrawable;

import Assets;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.ColorTransform;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class Go321 implements IDrawable
  {
  private var avatar:Sprite;
  private var framecounter:Number;
  private var state:Number;

  private static const BLANK:uint = 0;
  private static const THREE:uint = 1;
  private static const TWO  :uint = 2;
  private static const ONE  :uint = 3;
  private static const GO   :uint = 4;
  private static const DONE :uint = 5;

  // Decrease FRAMEMAX to make the 3-2-1-GO! sequence take less time to complete.
  private static const FRAMEMAX:uint = 20;

  private var bmp:Bitmap;

  private var levelTitle : String;

  private static var initialized : Boolean = false;
  private static var frames : Array; // of bitmaps.
  private var format : TextFormat;
  private var tf : TextField;

  public static function init() : void
    {
    frames = new Array(5); // BLANK, THREE, TWO, ONE, GO = 5 elements
    frames[BLANK] = new Assets.blank;
    frames[THREE] = new Assets.score3;
    frames[TWO]   = new Assets.score2;
    frames[ONE]   = new Assets.score1;
    frames[GO]    = new Assets.go;
    // There is no frame for "DONE".

    initialized = true;
    }

  public function Go321 (_levelTitle : String)

    {
    if ( !initialized )
      init();

    levelTitle = _levelTitle;

    avatar = new Sprite;

    state = BLANK;
    framecounter = FRAMEMAX;

    bmp = new Bitmap();
    bmp.bitmapData = frames[BLANK].bitmapData;

    // allocate them now so we don't allocate over and over.
    format = new TextFormat();
    tf = new TextField();

    avatar.addChild(bmp);
    avatar.addChild(tf);

    Screen.queueDraw(this);
    }

  // IDrawable Implementation
  public function isVisible() : Boolean { return true; }
  public function getLayer() : uint { return Drawable.hud; }
  public function draw( backbuffer : BitmapData ) : void
    {
    // Center the avatar in the Screen.
    avatar.x = 400;
    avatar.y = 300;

    if (state == DONE)
      return;

    // Lookup with state to figure out what graphic to display.
    bmp.bitmapData = frames[state].bitmapData;

    // Framecounter starts at FRAMEMAX and counts DOWN to zero.
    // Use framecounter to establish an alpha (transparency) value.
    bmp.alpha = 0.4 + 0.6 * (framecounter / FRAMEMAX);
    // Use framecounter to establish and x/y scale.
    bmp.scaleX = 9 - 4 * (framecounter / FRAMEMAX);
    bmp.scaleY = 9 - 4 * (framecounter / FRAMEMAX);
    Utility.center(bmp);
    avatar.addChild(bmp);

    // Add a text blurb about what "galaxy" you're in.


	  format.font = "title";
	  var tmp:int = Math.round(0xFF*bmp.alpha);

	  format.color = tmp*256*256 + tmp*256 + tmp;
	  format.size = 32;
	  format.align = "center";

    tf.embedFonts = true;
    tf.width = 800;
    tf.text = "Entering:\n"+levelTitle;
    tf.x = -400;
    tf.y = 215;
    tf.setTextFormat(format);

    backbuffer.draw(avatar,
                    avatar.transform.matrix,
                    avatar.transform.colorTransform,
                    null,null,Screen.useSmoothing(1.0));

    }

  public function update(deltaT:Number) : void
    {
    framecounter-= deltaT;
    if (framecounter < 0)
      {
      framecounter=FRAMEMAX;
      state++;
      // Play a sound.
      switch (state)
        {
        case THREE: Utility.playSound (Assets.count3); break;
        case TWO: Utility.playSound (Assets.count2); break;
        case ONE: Utility.playSound (Assets.count1); break;
        case GO: Utility.playSound (Assets.countgo); break;
        }
      }
    }

  public function isDone() : Boolean
    {
    return (state == DONE );
    }

  public function expire() : void
    {
    Screen.queueRemove(this);
    }
  }
} // end package