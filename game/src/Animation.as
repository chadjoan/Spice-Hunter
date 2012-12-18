package
{

import Assets;

import play.Body;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Transform;
import flash.geom.ColorTransform;

public class Animation implements IDrawable
  {
  public var frames : Array;

  public var rx : Number;
  public var ry : Number;
  public var radius : Number;

  // Finite state machine variables.
  public var frame:Number;            // What frame should be on the screen.
  public var counter : Number;   // How long this animation has been displayed so far. Measured in 1/25ths of a second.
  public var duration : Number;  // How long this animation should last. Measured in 1/25ths of a second.

  // State variables for rendering.
  public var cachebmp:Bitmap;
  public var isExpired:Boolean;

  // This pointer can be set to make an animation follow this body.
  public var boundTo:Body;
  public var boundTo_offsetx : Number;  // Some programmable offsets too.
  public var boundTo_offsety : Number;  // Initialized to zero, publicly visible properties so that other objects can set them.

  private static var failureFrames : Array; // we'll know when we have issues now.
  private static var initialized : Boolean = false;

  public static function init() : void
    {
    failureFrames = new Array(1);
    failureFrames[1] = new Assets.EpicFail;
    initialized = true;
    }

  public function Animation ()
    {
    if ( !initialized )
      init();

    frames = failureFrames;
    cachebmp = new Bitmap();

    Screen.queueDraw(this);
    isExpired = false;
    rx = 0;
    ry = 0;
    radius = 0;

    frame = 0;
    counter = 0;

    boundTo = null;
    boundTo_offsetx = 0;
    boundTo_offsety = 0;
    }

  // IDrawable implementation
  public function getLayer() : uint { return Drawable.midground; } // can by changed by inherit,override
  public function isVisible() : Boolean { return !isExpired; }
  public function draw( backbuffer : BitmapData ) : void
    {
    if ( frame == maxFrames() )
      return;

    if (boundTo != null)
      {
      rx = boundTo.rx + boundTo_offsetx;
      ry = boundTo.ry + boundTo_offsety;
      }

    cachebmp.bitmapData = getFrame(frame).bitmapData;
    Utility.center(cachebmp);
    var matrix : Matrix = cachebmp.transform.matrix;
    var trans : ColorTransform = cachebmp.transform.colorTransform;

    var scaleX : Number = radius / (cachebmp.width/2);
    //var scaleY : Number = radius / (cachebmp.height/2);

    // eep hack
    matrix.scale(scaleX,scaleX);

    matrix.tx += rx;
    matrix.ty += ry;

    // These are fast, so in the long run their smoothing shouldn't cost too much.
    // Also, since they are fast, they could use the extra legibility.
    // Smoothing priority = fairly high.
    var smooth : Boolean = Screen.useSmoothing(0.8);

    backbuffer.draw(cachebmp,matrix,trans,null,null,smooth);
    }

  public function update(deltaT:Number) : void
    {
    // Figure out what state to display.
    counter += deltaT;
    if (counter > duration)
      expire ();
    frame = Math.round(frames.length * counter / duration);
    if (frame > maxFrames())
      frame = maxFrames();
    }

  public function maxFrames() : uint
    {
    return frames.length;
    }

  public function expire() : void
    {
    Screen.queueRemove(this);
    isExpired = true;
    }

  public function getFrame(frameNumber:uint) : Bitmap
    {
    if ( frameNumber >= frames.length )
      return null;
    else
      return frames[frameNumber];
    }
  }
} // end package
