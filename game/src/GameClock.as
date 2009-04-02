

package {

import Assets;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.geom.ColorTransform;

public class GameClock
  {  
  public var rx:Number;
  public var ry:Number;
  
  // Finite state machine variables.
  public var state:Number;            // What number of seconds should be on the screen.
  public var renderedState : Number;  // What number of seconds is on the screen - when these are not the same, pull the old image and put up a new one.  
  
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
  public var avatar:Sprite;  
  public var isExpired:Boolean;  
  
  private var glyphs : Array;
  private var alpha : Number;
     
  public function GameClock (timeLimitSeconds:Number, x:int=400, y:int=10, 
                             _fontScaleX:Number=1.0, _fontScaleY:Number=1.0 )
    { 
    fontScaleX = _fontScaleX;
    fontScaleY = _fontScaleY;   
    fontWidth = FONTWIDTH * _fontScaleX;
    fontHeight = FONTHEIGHT * _fontScaleY;
    
    avatar = new Sprite;	
    Screen.hud.addChild(avatar);
    isExpired = false;    
    rx = x;
    ry = y; 	
    	    	          
    // Counter is measured in 1/25ths of a second.    
    counter = timeLimitSeconds*25;
    
    // Compute state - measured in seconds.
    state = timeLimitSeconds;
    renderedState = -1;
    
    glyphs = new Array;
    for (var i : Number=0; i < 4; i++)
      {
      glyphs[i] = new Bitmap();
      glyphs[i].scaleX = fontScaleX;
      glyphs[i].scaleY = fontScaleY;
      avatar.addChild(glyphs[i]);
      }
    alpha = 0.4;
    
    }
  
  public function draw(deltaT : Number) : void
    {    
    avatar.x = rx;
    avatar.y = ry; 
    
    if (state == renderedState && alpha == 0.4)
      return;
    
    for (var i : Number = 0; i < 4; i++)      
      avatar.removeChild(glyphs[i]);      
           
    // Pick out and place our four glyphs:
    // Minutes (1 digit)
    // Colon character (1 digit)
    // Seconds (2 digits)
    var minutes:Number = Math.floor (state/60);    
    switch (minutes)
      {      
      case 0: glyphs[0] = new Assets.score0; break;
      case 1: glyphs[0] = new Assets.score1; break;
      case 2: glyphs[0] = new Assets.score2; break;
      case 3: glyphs[0] = new Assets.score3; break;
      case 4: glyphs[0] = new Assets.score4; break;
      case 5: glyphs[0] = new Assets.score5; break;
      case 6: glyphs[0] = new Assets.score6; break;
      case 7: glyphs[0] = new Assets.score7; break;
      case 8: glyphs[0] = new Assets.score8; break;
      case 9: glyphs[0] = new Assets.score9; break;                
      }
    glyphs[1] = new Assets.colon;  
      
    var seconds:Number = state - minutes*60;
    var seconds1:Number = Math.floor(seconds/10);
    var seconds2:Number = seconds - 10*seconds1;
    
    switch (seconds1)
      {      
      case 0: glyphs[2] = new Assets.score0; break;
      case 1: glyphs[2] = new Assets.score1; break;
      case 2: glyphs[2] = new Assets.score2; break;
      case 3: glyphs[2] = new Assets.score3; break;
      case 4: glyphs[2] = new Assets.score4; break;
      case 5: glyphs[2] = new Assets.score5; break;
      case 6: glyphs[2] = new Assets.score6; break;
      case 7: glyphs[2] = new Assets.score7; break;
      case 8: glyphs[2] = new Assets.score8; break;
      case 9: glyphs[2] = new Assets.score9; break;                
      }
    switch (seconds2)
      {
      case 0: glyphs[3] = new Assets.score0; break;
      case 1: glyphs[3] = new Assets.score1; break;
      case 2: glyphs[3] = new Assets.score2; break;
      case 3: glyphs[3] = new Assets.score3; break;
      case 4: glyphs[3] = new Assets.score4; break;
      case 5: glyphs[3] = new Assets.score5; break;
      case 6: glyphs[3] = new Assets.score6; break;
      case 7: glyphs[3] = new Assets.score7; break;
      case 8: glyphs[3] = new Assets.score8; break;
      case 9: glyphs[3] = new Assets.score9; break;	
      }           
    
    alpha = alpha - deltaT / 12.5;
    if (alpha < 0.4)
      alpha = 0.4;
    
    for (i=0; i < 4; i++)
      {
      glyphs[i].x = i*fontWidth - 2*fontWidth;  // What's the -2*FONDWIDTH - stepping left enough pixels for 2 glyphs, so that the whole 4-glyphs display is centered in avatar.
      glyphs[i].y = 0;                   
      
      glyphs[i].scaleX = fontScaleX;
      glyphs[i].scaleY = fontScaleY;
      
      // If the state is less than 30 seconds to go, make it orangy.
      // If the state is less than 10 seconds to go, make it red.      
      if (state <= 10)
        glyphs[i].bitmapData.colorTransform(glyphs[i].bitmapData.rect, new ColorTransform (1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0) );
      else
        if (state <= 30)
          glyphs[i].bitmapData.colorTransform(glyphs[i].bitmapData.rect, new ColorTransform (1.0, 0.5, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0) );         
      glyphs[i].alpha = alpha;          
      avatar.addChild(glyphs[i]);
      }
    
    renderedState = state;
    
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
      Utility.playSound (new Assets.countdown );
      }
    // If less than 10 seconds - alpha = brighten on every tick.
    if (oldstate != state && state <= 10 && alpha == 0.4)
      {
      alpha = 1;
      Utility.playSound (new Assets.countdown );
      }
      
    draw (deltaT);  
    }
  
  public function clockIsZero() : Boolean
    {
    return (state == 0)
    }
    
  public function expire () : void
    {
    Screen.hud.removeChild(avatar);	
    }
  }
} // end package