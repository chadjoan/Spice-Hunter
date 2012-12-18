package {

import Drawable;
import IDrawable;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;


public class RoundSummaryPane implements IDrawable
  {
  public var bonusNames : Array;
  public var bonusValues : Array;
  public var bonusValuesNumeric : Array;

  public var isDone : Boolean;

  private var position : Number;
  private var spec : ShipSpec;

  private var gs:GlamourShot;

  private var cashLabel:TextField;
  private var cash : TextField;

  private var careerEarningsLabel: TextField;
  private var careerEarnings : TextField;

  private var justifyLeft:TextFormat;
  private var justifyRight:TextFormat;

  private static const TEXT_Y_INCREMENT : int = 24;
  private static const TEXT_WIDTH : int = 160;
  private static const WRITE_COOLDOWN_INITIALIZE : Number = 25.0;
  private static const WRITE_COOLDOWN_FIRSTWAIT : Array = [5.0,10.0,0.0,15.0];
  private var write_cooldown : Number;
  private var next_to_write : Number;

  public function RoundSummaryPane(_spec:ShipSpec, _position:Number)
    {
    spec = _spec;
    position = _position;

    gs = new GlamourShot(spec,1.0);
    gs.x = position;
    gs.y = 75;

    // Left justification. Used for bonus titles.
    justifyLeft = new TextFormat();
    justifyLeft.font = "text";
  	justifyLeft.color = Screen.getColor(spec.teamCode);
  	justifyLeft.size = 16;
  	justifyLeft.align = "left";

    // Right justification. Used for bonus values.
    justifyRight = new TextFormat();
    justifyRight.font = "text";
  	justifyRight.color = Screen.getColor(spec.teamCode);
  	justifyRight.size = 16;
  	justifyRight.align = "right";

    // Write out "Cash" and "Career Earnings" text fields and values.
    cashLabel = new TextField();
    cashLabel.embedFonts = true;
    cashLabel.width = TEXT_WIDTH;
    cashLabel.text = "Cash";
    cashLabel.x = position - TEXT_WIDTH/2;
    cashLabel.y = 500;
    cashLabel.setTextFormat(justifyLeft);

    cash = new TextField();
    cash.embedFonts = true;
    cash.width = TEXT_WIDTH;
    cash.text = ""+spec.accountBalance;
    cash.x = position - TEXT_WIDTH/2;
    cash.y = cashLabel.y;
    cash.setTextFormat(justifyRight);

    careerEarningsLabel = new TextField();
    careerEarningsLabel.embedFonts = true;
    careerEarningsLabel.width = TEXT_WIDTH;
    careerEarningsLabel.text = "Career";
    careerEarningsLabel.x = position - TEXT_WIDTH/2;
    careerEarningsLabel.y = cashLabel.y + TEXT_Y_INCREMENT;
    careerEarningsLabel.setTextFormat(justifyLeft);

    careerEarnings = new TextField();
    careerEarnings.embedFonts = true;
    careerEarnings.width = TEXT_WIDTH;
    careerEarnings.text = "" + spec.careerEarnings;
    careerEarnings.x = position - TEXT_WIDTH/2;
    careerEarnings.y = careerEarningsLabel.y;
    careerEarnings.setTextFormat(justifyRight);

    Screen.queueDraw(this);

    bonusNames = new Array;
    bonusValues = new Array;
    bonusValuesNumeric = new Array;

    // write_cooldown = WRITE_COOLDOWN_INITIALIZE;
    write_cooldown = WRITE_COOLDOWN_FIRSTWAIT[spec.playerID];
    next_to_write = 0;



    }

  // IDrawable implementation
  public function isVisible() : Boolean { return true; }
  public function getLayer() : uint { return Drawable.midground; }
  public function draw( backbuffer : BitmapData ) : void
    {
    // Done in the same order that they were addChild'ed in the original code.

    backbuffer.draw(gs,
                    gs.transform.matrix,
                    gs.transform.colorTransform,
                    null,null,true);

    backbuffer.draw(cashLabel,
                    cashLabel.transform.matrix,
                    cashLabel.transform.colorTransform,
                    null,null,true);

    backbuffer.draw(cash,
                    cash.transform.matrix,
                    cash.transform.colorTransform,
                    null,null,true);

    backbuffer.draw(careerEarningsLabel,
                    careerEarningsLabel.transform.matrix,
                    careerEarningsLabel.transform.colorTransform,
                    null,null,true);

    backbuffer.draw(careerEarnings,
                    careerEarnings.transform.matrix,
                    careerEarnings.transform.colorTransform,
                    null,null,true);

    var end : int = next_to_write;
    if ( end > bonusNames.length )
      end = bonusNames.length;

    for (var i : int = 0; i < end; i++)
      {
      backbuffer.draw(bonusNames[i],
                      bonusNames[i].transform.matrix,
                      bonusNames[i].transform.colorTransform,
                      null,null,true);

      backbuffer.draw(bonusValues[i],
                      bonusValues[i].transform.matrix,
                      bonusValues[i].transform.colorTransform,
                      null,null,true);
      }
    }
  // End IDrawable implementation.

  public function appendBonus (name:String, value:Number) : void
    {
    // Makes new text fields for both the name and value.
    // Sets their position but does not add them to the container.
    var nameField : TextField;
    var valueField : TextField;

    nameField = new TextField ();
    nameField.embedFonts = true;
    nameField.width = TEXT_WIDTH;
    nameField.text = name;
    nameField.x = position - TEXT_WIDTH/2;
    nameField.y = bonusNames.length * TEXT_Y_INCREMENT + 175;
    nameField.setTextFormat (justifyLeft);
    nameField.alpha = 0.8;

    valueField = new TextField ();
    valueField.embedFonts = true;
    valueField.width = TEXT_WIDTH;
    valueField.text = ""+value;
    valueField.x = position - TEXT_WIDTH/2;
    valueField.y = bonusNames.length * TEXT_Y_INCREMENT + 175;
    valueField.setTextFormat (justifyRight);
    valueField.alpha = 0.8;



    bonusNames.push (nameField);
    bonusValues.push (valueField);
    bonusValuesNumeric.push (value);

    }

  public function update (deltaT:Number) : void
    {
    if (isDone)
      return;

    write_cooldown -= deltaT;
    if (write_cooldown < 0)
      {
      Utility.playSound ( Assets.addmoney );

      write_cooldown = WRITE_COOLDOWN_INITIALIZE;

      // Accumulate this bonus into the shipspec.
      spec.accountBalance += bonusValuesNumeric[next_to_write];
      spec.careerEarnings += bonusValuesNumeric[next_to_write];
      // Update the cash and earnings blurbs with their new values.
      cash.text = ""+spec.accountBalance;
      cash.setTextFormat(justifyRight);
      careerEarnings.text = "" + spec.careerEarnings;
      careerEarnings.setTextFormat(justifyRight);
      // Update the "next-to-write" state variable.
      next_to_write++;
      // Are we done yet?
      if (next_to_write == bonusNames.length)
        isDone = true;
      }

    }

  public function expire () : void
    {
    Screen.queueRemove(this);
    }

  }
}