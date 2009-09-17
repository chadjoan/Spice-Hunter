package {

import Drawable;
import IDrawable;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.geom.Point;
import flash.geom.ColorTransform;

public class JoinUp implements IDrawable
  {
  public var shipspecs : Array;  // Public so controls can see it.
  public var cursors : Array; //cursors is probably which item is highlighted
  public var IAmReady : Array; //the buttons at the bottom
  
  private var alpha : Number;
  
  private var tip:Tip;
  
  private var fpsDisplay:FPSDisplay;
  
  private var gameClock:GameClock;
  private var controls : JoinUpControls;
  public var isExpired : Boolean;
  
  private var Music:Sound = Assets.Music_joinup;
  private var MusicChannel:SoundChannel = new SoundChannel;
  
  // Constants ...
  private static const glamourShotPositions : Array = [300, 500, 100, 700];
  private static const columnPositions : Array = [200, 400, 0, 600];
  
  private var initialized : Boolean = false;
  private var glamourShots : Array; // of bitmaps
  private var coloredBoxes : Array; // of bitmaps
  private var coloredBars : Array; // of bitmaps
  private var highlights : Array; // of bitmaps
  private var playerIsHumanBmp : Bitmap = new Assets.barHuman;
  private var playerIsRobotBmp : Bitmap = new Assets.barRobot;
  private var blinkBmp    : Bitmap = new Assets.blink;
  private var readyBmp    : Bitmap = new Assets.ready;
  private var notReadyBmp : Bitmap = new Assets.readyNOT;
  private var staticText : Bitmap = new Assets.staticText;
  private var background : Bitmap = new Assets.bg;
  private var alphaTransform : ColorTransform = new ColorTransform;
  private var tempBitmap : Bitmap = new Bitmap(); // Used to temporarily hold (x,y) values, etc.
  private var destPoint : Point = new Point(0,0); // Allocate it now so we don't have to allocate it over and over.
  
  public function JoinUp (_shipspecs : Array)
    {
    shipspecs = _shipspecs;
    Screen.queueDraw(this);
    fpsDisplay = new FPSDisplay();
    gameClock = new GameClock(20);
    controls = new JoinUpControls(this);
    
    isExpired = false;
    
    cursors = new Array(4);
    cursors[0] = 0;
    cursors[1] = 0;
    cursors[2] = 0;
    cursors[3] = 0;
    
    IAmReady = new Array(4);
    IAmReady[0]=false;
    IAmReady[1]=false;
    IAmReady[2]=false;
    IAmReady[3]=false;
    
    // Normally all of the bitmap arrays that are new'd would be new'd in a 
    // static "init" function.  Not here.  That is because this class only exists once
    // during the entire game, and it'd be nice if that memory becomes reclaimable
    // after we are done with the joinup screen.
    // If someone plays through more than once, it doesn't kill anything either.  It's all good.
    coloredBoxes = new Array(4);
    coloredBoxes[0] = new Assets.boxRed;
    coloredBoxes[1] = new Assets.boxBlue;
    coloredBoxes[2] = new Assets.boxYellow;
    coloredBoxes[3] = new Assets.boxGreen;
    
    coloredBars = new Array(4);
    coloredBars[0] = new Assets.barRed;
    coloredBars[1] = new Assets.barBlue;
    coloredBars[2] = new Assets.barYellow;
    coloredBars[3] = new Assets.barGreen;
    
    highlights = new Array(3);
    highlights[0] = new Assets.highlight1;
    highlights[1] = new Assets.highlight2;
    highlights[2] = new Assets.highlight3;
    
    glamourShots = new Array(4);
    
    tip = new Tip("JoinUp");
    
    alpha = 0.5;
    
    invalidate();
    
    MusicChannel = Music.play();
    
    }
  
  
  
  // We need to know when we should get new glamour shots.  
  public function invalidate() : void
    {
    for (var i : int = 0; i < 4; i++)
      {
      var gs : GlamourShot = new GlamourShot (shipspecs[i],1.0);
      gs.x = glamourShotPositions[i];
      gs.y = 60;
      glamourShots[i] = gs;
      }
    }
  
  // IDrawable implementation
  public function isVisible() : Boolean { return !isExpired; }
  public function getLayer() : uint { return Drawable.midground; }
  public function draw( backbuffer : BitmapData ) : void
    {
    
    var i:int;
    
    // background
    var bdata : BitmapData = background.bitmapData;
    backbuffer.copyPixels(bdata, bdata.rect, destPoint);
    
    /////////////////////////// Place glamour shots.
    for (i = 0; i < 4; i++)
      backbuffer.draw(glamourShots[i],
                      glamourShots[i].transform.matrix,
                      glamourShots[i].transform.colorTransform,
                      null,null,true);
    
    /////////////////////////////// Place color windows.
    for (i = 0; i < 4; i++)
      {
      tempBitmap.bitmapData = coloredBoxes[shipspecs[i].teamCode].bitmapData;
      tempBitmap.x = columnPositions[i];
      tempBitmap.y = 0;
      
      backbuffer.draw(tempBitmap,
                      tempBitmap.transform.matrix,
                      tempBitmap.transform.colorTransform,
                      null,null,true);
      }
    
    //////////////////////////////////////////bars for teams
    for (i = 0; i < 4; i++)
      {
      tempBitmap.bitmapData = coloredBars[shipspecs[i].teamCode].bitmapData;
      tempBitmap.x = columnPositions[i];
      tempBitmap.y = 0;
      
      backbuffer.draw(tempBitmap,
                      tempBitmap.transform.matrix,
                      tempBitmap.transform.colorTransform,
                      null,null,true);
      }
  
  
    ///////////////////////////////////////bars for controls:
    for (i = 0; i < 4; i++)
      {
      if (shipspecs[i].isCPUControlled)
        tempBitmap.bitmapData = playerIsRobotBmp.bitmapData;
      else
        tempBitmap.bitmapData = playerIsHumanBmp.bitmapData;
      
      tempBitmap.x = columnPositions[i];
      tempBitmap.y = 0;
      
      backbuffer.draw(tempBitmap,
                      tempBitmap.transform.matrix,
                      tempBitmap.transform.colorTransform,
                      null,null,true);
      }
    
    
    /////////////////////////////////////////ready or not ready:
    for (i = 0; i < 4; i++)
      {
      if ( IAmReady[i] )
        tempBitmap.bitmapData = readyBmp.bitmapData;
      else
        tempBitmap.bitmapData = notReadyBmp.bitmapData;
      
      tempBitmap.x = columnPositions[i];
      tempBitmap.y = 515;
      
      backbuffer.draw(tempBitmap,
                      tempBitmap.transform.matrix,
                      tempBitmap.transform.colorTransform,
                      null,null,true);
      }
  
    
    ////////////////////////////////////static text
    backbuffer.draw(staticText,
                    staticText.transform.matrix,
                    staticText.transform.colorTransform,
                    null,null,true);
    
    // highlight the columns
    for (i = 0; i < 4; i++)
      {
      tempBitmap.bitmapData = highlights[cursors[i]].bitmapData;
      
      tempBitmap.x = columnPositions[i];
      tempBitmap.y = 0;
      
      backbuffer.draw(tempBitmap,
                      tempBitmap.transform.matrix,
                      tempBitmap.transform.colorTransform,
                      null,null,true);
      }
    
    // Blinking.
    for (i = 0; i < 4; i++)
      {
      tempBitmap.bitmapData = blinkBmp.bitmapData;
      
      tempBitmap.x = columnPositions[i];
      switch (cursors[i])
        {
        case 0: tempBitmap.y=294; break;
        case 1: tempBitmap.y=419; break;
        case 2: tempBitmap.y=526; break;
        case 3: tempBitmap.y=900; break;
        }
      
      alphaTransform.alphaMultiplier = alpha;
      backbuffer.draw(tempBitmap,
                      tempBitmap.transform.matrix,
                      alphaTransform,
                      null,null,true);
      }
    
    backbuffer.draw(tip, tip.transform.matrix, tip.transform.colorTransform,
                    null,null,true);
    }
  // End IDrawable implementation
  
  // Used to implement "button mash style" skipping
  public function fakeTick () : void
    {
    fpsDisplay.update();        
    gameClock.update(25);
    }
  
  
  
  public function update () : void
    {
    fpsDisplay.update();    
    var deltaT : Number = 25.0 / fpsDisplay.FPS;
    gameClock.update(deltaT);
    
    // Update chevron alpha parameter.
    /**/alpha = alpha + deltaT / 25.0;
    if (alpha > 1)
      alpha = 0.4;
    
    tip.scrollTip(deltaT);
    
    // Compute expiration status.
    // If everyone is ready, expire.
    // If the countdown is complete, expire.
    if (gameClock.clockIsZero() )
      {
      expire ();
      return;
      }
    
    if (IAmReady[0])
      if (IAmReady[1])
        if (IAmReady[2])
          if (IAmReady[3])
            {
            expire();
            return; 
            }
    }
  
  
  
  
  
  public function expire () : void
    {
    Screen.queueRemove(this);
    isExpired = true; 
    controls.expire();    
    gameClock.expire();
    fpsDisplay.expire();
    MusicChannel.stop();
    }
    
  }
}
