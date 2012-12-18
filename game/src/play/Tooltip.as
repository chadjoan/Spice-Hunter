
package play
{

import Assets;
import Drawable;
import Screen;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.geom.Transform;

public class Tooltip extends Drawable
  {
  public var rx : Number;
  public var ry : Number;
  public var text:String;

  // Finite state machine variables.
  public var state:Number;
  public var counter : Number;
  public var duration : Number;  // How long does it take to write the whole message?

  //public var avatar:Sprite;
  public var isExpired:Boolean;

  public var format : TextFormat;
  public var textfield : TextField;

  public function Tooltip (reticleLevel:Number)
    {
    //avatar = new Sprite;
    //Screen.hud.addChild(avatar);
    isExpired = false;
    rx = 0;
    ry = 0;

    state = 0;
    counter = 0;

    duration = 15 - 10*(reticleLevel/10);

    format = new TextFormat();
  	format.font = "number";
  	format.color = 0xffffff;
  	format.size = 16;
  	textfield = new TextField();
    textfield.embedFonts = true;
    textfield.width = 100;

    text = "";

    layer = Drawable.hud;
    visible = true;
    Screen.queueDraw(this);
    }

  public override function draw( backbuffer : BitmapData ) : void
    {
    var x : int = rx;
    var y : int = ry;
    if ( x > 800-85)
      x = 800-85;
    if (y > 600-45)
      y = 600-45;

    textfield.x = x;
    textfield.y = y;
    textfield.text = text.slice (0,state);
    textfield.setTextFormat(format);

    var trans : Transform = textfield.transform;
    // draw it, and smooth it if at all possible!  (Text is small and looks ugly when not smoothed)
    backbuffer.draw(textfield,trans.matrix,trans.colorTransform,null,null,Screen.useSmoothing(0.9));
    }

  public function update(deltaT : Number) : void
    {
    counter += deltaT;
    if (counter > duration)
      counter = duration;
    state = Math.round (text.length * counter / duration);
    }

  public function expire() : void
    {
    if (!isExpired)
      {
      //Screen.hud.removeChild(avatar);
      Screen.queueRemove(this);
      visible = false;
      isExpired = true;
      }
    }
  }

} // end package