

package {

import Drawable;
import IDrawable;

import Assets;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.ColorTransform;

public class GameClock implements IDrawable
  {
  public var rx:Number;
  public var ry:Number;

  // Finite state machine variables.
  public var state:Number;            // What number of seconds should be on the screen.

  public var counter : Number;   // Current time on the clock. Measured in 1/25ths of a second.

  // Glyph size of the bitmap fonts.
  public static const FONTWIDTH:Number = 26;
  public static const FONTHEIGHT:Number = 33;

  // Scaled glyph sizes
  private var fontWidth:Number;
  private var fontHeight:Number;
  private var fontScaleX:Number;
  private var fontScaleY:Number;

  // State variables for rendering.
  public var isExpired:Boolean;

  private var glyphs : Array;
  private var alpha : Number;

  // Static/constant stuff that should be allocated once and never again.
  private static var initialized : Boolean = false;
  private static var scoreDigits : Array; // of bitmaps.
  private static var colonGlyph : Bitmap;
  private static var noHue : ColorTransform;
  private static var redHue : ColorTransform;
  private static var orangeHue : ColorTransform;

  public static function init() : void
    {
    scoreDigits = new Array(10);
    scoreDigits[0] = new Assets.score0;
    scoreDigits[1] = new Assets.score1;
    scoreDigits[2] = new Assets.score2;
    scoreDigits[3] = new Assets.score3;
    scoreDigits[4] = new Assets.score4;
    scoreDigits[5] = new Assets.score5;
    scoreDigits[6] = new Assets.score6;
    scoreDigits[7] = new Assets.score7;
    scoreDigits[8] = new Assets.score8;
    scoreDigits[9] = new Assets.score9;
    colonGlyph = new Assets.colon;
    noHue     = new ColorTransform ();
    redHue    = new ColorTransform (1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0);
    orangeHue = new ColorTransform (1.0, 0.5, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0);

    initialized = true;
    }
  // End static/constant stuff.

  public function GameClock (timeLimitSeconds:Number, x:int=400, y:int=10,
                             _fontScaleX:Number=1.0, _fontScaleY:Number=1.0 )
    {
    if ( !initialized )
      init();

    fontScaleX = _fontScaleX;
    fontScaleY = _fontScaleY;
    fontWidth = FONTWIDTH * _fontScaleX;
    fontHeight = FONTHEIGHT * _fontScaleY;

    isExpired = false;
    rx = x;
    ry = y;

    // Counter is measured in 1/25ths of a second.
    counter = timeLimitSeconds*25;

    // Compute state - measured in seconds.
    state = timeLimitSeconds;

    glyphs = new Array;
    for (var i : Number=0; i < 4; i++)
      {
      glyphs[i] = new Bitmap();
      glyphs[i].scaleX = fontScaleX;
      glyphs[i].scaleY = fontScaleY;
      }
    alpha = 0.4;

    Screen.queueDraw(this);
    }

  // IDrawable implementation
  public function isVisible() : Boolean { return !isExpired; }
  public function getLayer() : uint { return Drawable.hud; }
  public function draw( backbuffer : BitmapData ) : void
    {
    var i : int;

    // Pick out and place our four glyphs:
    // Minutes (1 digit)
    // Colon character (1 digit)
    // Seconds (2 digits)
    var minutes:Number = Math.floor (state/60);
    glyphs[0].bitmapData = scoreDigits[minutes % 10].bitmapData;
    glyphs[1].bitmapData = colonGlyph.bitmapData;

    var seconds:Number = state - minutes*60;
    var seconds1:Number = Math.floor(seconds/10);
    var seconds2:Number = seconds - 10*seconds1;

    glyphs[2].bitmapData = scoreDigits[seconds1 % 10].bitmapData;
    glyphs[3].bitmapData = scoreDigits[seconds2 % 10].bitmapData;

    // If the state is less than 30 seconds to go, make it orangy.
    // If the state is less than 10 seconds to go, make it red.
    var hue : ColorTransform = noHue;
    if (state <= 10)
      hue = redHue;
    else
      if (state <= 30)
        hue = orangeHue;

    for (i=0; i < 4; i++)
      {
      glyphs[i].x = rx + i*fontWidth - 2*fontWidth;  // What's the -2*FONDWIDTH - stepping left enough pixels for 2 glyphs, so that the whole 4-glyphs display is centered in avatar.
      glyphs[i].y = ry;

      glyphs[i].scaleX = fontScaleX;
      glyphs[i].scaleY = fontScaleY;
      hue.alphaMultiplier = alpha;

      backbuffer.draw(glyphs[i],glyphs[i].transform.matrix,hue,
                      null,null,Screen.useSmoothing(0.8));
      }

    }


  public function update (deltaT:Number) : void
    {
    counter -= deltaT;
    var oldstate:Number = state;

    state = Math.round (counter / 25);
    if (state < 0)
      state = 0;

    // Some alpha stuff - if the seconds is a multiple of 30, brighten.
    if (oldstate != state && state % 30 == 0 && alpha == 0.4)
      {
      alpha = 1;
      Utility.playSound (Assets.countdown );
      }
    // If less than 10 seconds - alpha = brighten on every tick.
    if (oldstate != state && state <= 10 && alpha == 0.4)
      {
      alpha = 1;
      Utility.playSound (Assets.countdown );
      }

    alpha = alpha - deltaT / 12.5;
    if (alpha < 0.4)
      alpha = 0.4;
    }

  public function clockIsZero() : Boolean
    {
    return (state == 0)
    }

  public function expire () : void
    {
    Screen.queueRemove(this);
    }
  }
} // end package