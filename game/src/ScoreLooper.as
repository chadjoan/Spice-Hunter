

package {

import Assets;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.geom.ColorTransform;

public class ScoreLooper
  {  
  public var rx : Number;
  public var ry : Number;
  
  // Integer numbers which represent the current score, and the score that we are rolling up to.
  private var currentScore : Array;
  private var targetScore : Array;
  private var addend : Array;
  
  
  private var digit_bitmaps : Array;
  private var addend_bitmaps : Array;
  private var plus_bitmap : Bitmap;
  
  // An animation counter - for alpha blending.
  private var alphacounter:Number;
  private var scoresmatch : Boolean;

  private var scoreN : Number;  
  private var addendN : Number;

  private var avatar:Sprite;  
  
  private var spec:ShipSpec;
  
  public static var FONTWIDTH:Number;
  public static var FONTHEIGHT:Number;
  public static var NDIGITS:Number;
  public static var ALPHASTEPS:Number;
  
  public function ScoreLooper (_spec: ShipSpec)
    // ShipSpec argument is used to establish the color.
    {    
    NDIGITS = 4;
    FONTWIDTH = 26;
    FONTHEIGHT = 33;
    ALPHASTEPS = 25; // measured in 1/25ths of a second
    	      
    spec = _spec;
    avatar = new Sprite;	
    Screen.hud.addChild(avatar);
      
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
      
      // Initialize text field position, relative to the avatar.
      digit_bitmaps[i] = new Bitmap();             
      digit_bitmaps[i].x = i*FONTWIDTH;
      digit_bitmaps[i].y = 0;                   
      avatar.addChild(digit_bitmaps[i]);
      
      // Initialize addend field position, relative to the avatar.
      addend[i] = 0;
      addend_bitmaps[i] = new Bitmap();
      addend_bitmaps[i].x = i*FONTWIDTH;
      addend_bitmaps[i].y = FONTHEIGHT;                   
      avatar.addChild(addend_bitmaps[i]);
      
      }
    plus_bitmap = new Bitmap();
    avatar.addChild(plus_bitmap);
    
    // Convention:
    // currentScore[0] = leftmost digit (most significant)
    // currentScore[NDIGITS-1] = rightmost digit (least significant)
    scoresmatch = true;
    
    alphacounter = 0;
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
  
  public function draw() : void
    {      
      
    avatar.x = rx;
    avatar.y = ry;
    // Building the score loop display.
    for (var i:Number = 0; i < NDIGITS; i++)
      {      
      avatar.removeChild(digit_bitmaps[i]);
      // Switch statement to lookup the right bitmap.
      switch (currentScore[i])
        {      
        case 0: digit_bitmaps[i] = new Assets.score0; break;
        case 1: digit_bitmaps[i] = new Assets.score1; break;
        case 2: digit_bitmaps[i] = new Assets.score2; break;
        case 3: digit_bitmaps[i] = new Assets.score3; break;
        case 4: digit_bitmaps[i] = new Assets.score4; break;
        case 5: digit_bitmaps[i] = new Assets.score5; break;
        case 6: digit_bitmaps[i] = new Assets.score6; break;
        case 7: digit_bitmaps[i] = new Assets.score7; break;
        case 8: digit_bitmaps[i] = new Assets.score8; break;
        case 9: digit_bitmaps[i] = new Assets.score9; break;                
        }          
      
      // Apply a color transform to match the player ships color.
      var colorTransform : ColorTransform = Screen.getColorTransform(spec.teamCode);
      digit_bitmaps[i].bitmapData.colorTransform(digit_bitmaps[i].bitmapData.rect, colorTransform );             
      digit_bitmaps[i].x = i*FONTWIDTH;
      digit_bitmaps[i].y = 0;             
      digit_bitmaps[i].alpha = Math.max (0.4, alphacounter / ALPHASTEPS );
      avatar.addChild(digit_bitmaps[i]);
      }        

    // Building the addend display.
    for (i = 0; i < NDIGITS; i++)
      {
      avatar.removeChild(addend_bitmaps[i]);
      // Switch statement to lookup the right bitmap.
      switch (addend[i])
        {      
        case 0: addend_bitmaps[i] = new Assets.score0; break;
        case 1: addend_bitmaps[i] = new Assets.score1; break;
        case 2: addend_bitmaps[i] = new Assets.score2; break;
        case 3: addend_bitmaps[i] = new Assets.score3; break;
        case 4: addend_bitmaps[i] = new Assets.score4; break;
        case 5: addend_bitmaps[i] = new Assets.score5; break;
        case 6: addend_bitmaps[i] = new Assets.score6; break;
        case 7: addend_bitmaps[i] = new Assets.score7; break;
        case 8: addend_bitmaps[i] = new Assets.score8; break;
        case 9: addend_bitmaps[i] = new Assets.score9; break;                
        }          
      
      // Apply a color transform to match the player ships color.
      colorTransform = Screen.getColorTransform(spec.teamCode);
      addend_bitmaps[i].bitmapData.colorTransform(addend_bitmaps[i].bitmapData.rect, colorTransform );   
      
      addend_bitmaps[i].x = (i+1)*FONTWIDTH*NDIGITS/(NDIGITS+1);
      addend_bitmaps[i].y = FONTHEIGHT;             
      addend_bitmaps[i].scaleX = NDIGITS/(NDIGITS+1);
      addend_bitmaps[i].scaleY = NDIGITS/(NDIGITS+1);
      
      addend_bitmaps[i].alpha = Math.max (0, alphacounter / ALPHASTEPS / 2 );
      avatar.addChild(addend_bitmaps[i]);      	
      }

    avatar.removeChild(plus_bitmap);
    plus_bitmap = new Assets.plus;
    plus_bitmap.x = 0;
    plus_bitmap.y = FONTHEIGHT;
    plus_bitmap.scaleX = NDIGITS/(NDIGITS+1);
    plus_bitmap.scaleY = NDIGITS/(NDIGITS+1);
    
    plus_bitmap.bitmapData.colorTransform (plus_bitmap.bitmapData.rect, colorTransform);    
    plus_bitmap.alpha = Math.max (0, alphacounter / ALPHASTEPS / 2 );
    avatar.addChild(plus_bitmap);
    
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
      
    draw();  
    }
    
  public function expire() : void
    {
    Screen.hud.removeChild(avatar);	    
    }
  }
} // end package