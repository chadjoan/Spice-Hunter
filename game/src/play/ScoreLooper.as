package play
{

import Drawable;
import IDrawable;

import ShipSpec;
import Assets;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.ColorTransform;

public class ScoreLooper implements IDrawable
  {  
  public var rx : Number;
  public var ry : Number;
  
  // Integer numbers which represent the current score, and the score that we are rolling up to.
  private var currentScore : Array;
  private var targetScore : Array;
  private var addend : Array;
  
  // Color to match the player's ship.
  public var hue : ColorTransform;
  
  private var digit_bitmaps : Array;
  private var addend_bitmaps : Array;
  private var plus_bitmap : Bitmap;
  
  // An animation counter - for alpha blending.
  private var alphacounter:Number;
  private var scoresmatch : Boolean;

  private var scoreN : Number;  
  private var addendN : Number;
  
  private var spec:ShipSpec;
  
  public static var FONTWIDTH:Number;
  public static var FONTHEIGHT:Number;
  public static var NDIGITS:Number;
  public static var ALPHASTEPS:Number;
  
  private static var initialized : Boolean = false;
  private static var scoreDigits : Array; // of bitmaps
  private static var plusbmp : Bitmap = new Assets.plus;
  
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
    
    initialized = true;
    }
  
  public function ScoreLooper (_spec: ShipSpec)
    // ShipSpec argument is used to establish the color.
    {
    if ( !initialized )
      init();
    
    NDIGITS = 4;
    FONTWIDTH = 26;
    FONTHEIGHT = 33;
    ALPHASTEPS = 25; // measured in 1/25ths of a second
    	      
    spec = _spec;
      
    // Make new score arrays, initialize to zero.
    currentScore = new Array;
    targetScore = new Array;    
    digit_bitmaps = new Array;
    addend = new Array;
    addend_bitmaps = new Array;
    
    
    scoreN = 0;
    
    for (var i:Number = 0; i < NDIGITS; i++)
      {      	
      currentScore[i] = 0;
      targetScore[i] = 0;
      
      digit_bitmaps[i] = new Bitmap();
      
      addend[i] = 0;
      addend_bitmaps[i] = new Bitmap();
      
      }
    plus_bitmap = new Bitmap();
    
    // Convention:
    // currentScore[0] = leftmost digit (most significant)
    // currentScore[NDIGITS-1] = rightmost digit (least significant)
    scoresmatch = true;
    
    alphacounter = 0;
    
    // Get color hueing transformation from Screen and COPY it.
    // The copying is important, otherwise we redifine the alpha values of the Screen's hues - BAD.
    var tmphue : ColorTransform = Screen.getColorTransform(spec.teamCode);
    hue = new ColorTransform( tmphue.redMultiplier,
                              tmphue.greenMultiplier,
                              tmphue.blueMultiplier);
    
    Screen.queueDraw(this);
    }
  
  public function setTargetScore (newscore:int) : void
    {    
    addendN = newscore - scoreN;
    scoreN = newscore;
    
    var temp:int = newscore;    
    for (var i:Number = NDIGITS-1; i >= 0; i--)
      {
      targetScore[i] = temp % 10;
      temp = temp / 10;	
      }      
      
    temp = addendN;
    for (i = NDIGITS-1; i >= 0; i--)
      {
      addend[i] = temp%10;
      temp = temp/10;	
      }
    }
  
  // IDrawable implementation
  public function isVisible() : Boolean { return true; }
  public function getLayer() : uint { return Drawable.hud; }
  public function draw( backbuffer : BitmapData ) : void
    {
    // Building the score loop display.
    for (var i:Number = 0; i < NDIGITS; i++)
      {
      digit_bitmaps[i].bitmapData = scoreDigits[currentScore[i] % 10].bitmapData;
      
      digit_bitmaps[i].x = rx + i*FONTWIDTH;
      digit_bitmaps[i].y = ry;
      
      hue.alphaMultiplier = Math.max (0.4, alphacounter / ALPHASTEPS );
      
      backbuffer.draw(digit_bitmaps[i],digit_bitmaps[i].transform.matrix,hue,
                      null,null,Screen.useSmoothing(0.6));
      }        

    // Building the addend display.
    for (i = 0; i < NDIGITS; i++)
      {
      addend_bitmaps[i].bitmapData = scoreDigits[addend[i] % 10].bitmapData;
      
      addend_bitmaps[i].scaleX = NDIGITS/(NDIGITS+1);
      addend_bitmaps[i].scaleY = NDIGITS/(NDIGITS+1);
      addend_bitmaps[i].x = rx + (i+1)*FONTWIDTH*NDIGITS/(NDIGITS+1);
      addend_bitmaps[i].y = ry + FONTHEIGHT;
      
      hue.alphaMultiplier = Math.max (0, alphacounter / ALPHASTEPS / 2 );
      
      backbuffer.draw(addend_bitmaps[i],addend_bitmaps[i].transform.matrix,hue,
                      null,null,Screen.useSmoothing(0.6));
      }

    plus_bitmap.bitmapData = plusbmp.bitmapData;
    plus_bitmap.scaleX = NDIGITS/(NDIGITS+1);
    plus_bitmap.scaleY = NDIGITS/(NDIGITS+1);
    plus_bitmap.x = rx;
    plus_bitmap.y = ry + FONTHEIGHT;
    
    hue.alphaMultiplier = Math.max (0, alphacounter / ALPHASTEPS / 2 );
    
    backbuffer.draw(plus_bitmap,plus_bitmap.transform.matrix,hue,
                    null,null,Screen.useSmoothing(0.6));
    }
 
  public function update(deltaT:Number) : void
    {  	  
    // Find if the rightmost digit of currentScore and targetScore that does not match.
    var wrongdigit:Number = -1;
    for (var i:Number = 0; i < NDIGITS; i++)
      if (currentScore[i] != targetScore[i])
        wrongdigit = i;    
    // If wrongdigit is never set to something other than -1, the scores match.
    if (wrongdigit == -1)                 
      scoresmatch = true;      
    else
      {
      scoresmatch = false;
      alphacounter = ALPHASTEPS;
      }
          
    // Change the wrongdigit - we'll get it right eventually.
    currentScore[wrongdigit] = (currentScore[wrongdigit]+1)%10;    
    // Trigger a redraw.    
    if (scoresmatch && alphacounter > 0)
      alphacounter -= deltaT;
    if (alphacounter < 0)
      alphacounter = 0;    
    }
    
  public function expire() : void
    {
    Screen.queueRemove(this);
    }
  }
} // end package