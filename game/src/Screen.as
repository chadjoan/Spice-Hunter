package {

import flash.display.*;
import flash.geom.*;

import ShipSpec;
import Assets;
import Drawable;
import IDrawable;

public class Screen
  {
  // width height are not used everywhere.  
  // Rewrite things to use them whenever possible though.
  public static const width  : uint = 800;
  public static const height : uint = 600;
  public static const rect   : Rectangle = new Rectangle(0,0,width,height);
  public static const origin : Point = new Point(0,0);
  
  public static var root : Sprite;
  
  private static var backbuffer : Bitmap;
  
  // drawing queue
  private static var drawQueue : Array; // array of drawing operations to be performed.
  private static var drawQueueLength : uint; // current number of drawing operations queued
  
  public static var swfs : Sprite; // sprite to throw swfs onto. 
  
  public static var redXForm : ColorTransform; 
  public static var blueXForm : ColorTransform;
  public static var greenXForm : ColorTransform; 
  public static var yellowXForm : ColorTransform;      
  
  public static var redColor : uint;
  public static var blueColor : uint;
  public static var greenColor : uint;
  public static var yellowColor : uint;
  
  public static var splashBmp : Bitmap = new Assets.splash;
  
  public static function init(m_root:Sprite) : void
    {
    root = m_root;
    
    swfs = new Sprite();
    
    backbuffer = new Bitmap();
    backbuffer.bitmapData = new BitmapData(800,600,true,0x00ffffff);
    
    m_root.addChild( backbuffer );
    m_root.addChild( swfs );
    
    // Create color transforms.
    redXForm = new ColorTransform(1.0, 0.0, 0.0);
    greenXForm  = new ColorTransform(0.0, 1.0, 0.0);
    yellowXForm = new ColorTransform(1.0, 1.0, 0.0);
    // Lighten/"cyanize" the blue.
    blueXForm = new ColorTransform(0.29, 0.65, 1.0);    
    
    // Create colors.
    redColor = 0xFF0000;
    greenColor = 0x00FF00;
    yellowColor = 0xFFFF00;
    // Lighten/"cyanize" the blue.
    blueColor = 0x4AA5FF;
    
    drawQueue = new Array(10);
    for ( var i : int = 0; i < drawQueue.length; i++ )
      drawQueue[i] = null;
    drawQueueLength = 0;
    trace(drawQueue);
    trace("Screen init complete.");
    }
  
  // This is very simple, but it can be extended to dynamically make
  //   some things render smooth and others not based on how
  //   well the FPS is doing.  
  // The importance variable determine how important it is that the
  //   caller use smoothing.  It varies between 0 and 1. 
  // A value of 1 means it should always be smoothed, and a value
  //   of 0 means it should never be smoothed.
  // ex:
  // Screen.useSmoothing(1.0) is functionally equivelant to true.
  // Screen.useSmoothing(0.0) is functionally equivelant to false.
  // What happens inbetween is debatable.  
  public static function useSmoothing( importance : Number ) : Boolean
    {
    // for now, let's push it pretty hard.  
    if ( importance > 0.21 )
      return true;
    
    return false;
    }
  
  public static function queueDraw( drawable : IDrawable ) : void
    {
    if ( drawQueueLength == drawQueue.length )
      drawQueue[drawQueue.length] = drawable;
    else
      drawQueue[drawQueueLength] = drawable;
    drawQueueLength++;
    }
  
  public static function queueRemove( drawable : IDrawable ) : void
    {
    var i : int;
    for ( i = 0; i < drawQueueLength; i++ )
      {
      if ( drawQueue[i] == drawable )
        {
        drawQueue[i] = null;
        drawQueueLength--;
        
        // If things were removed, it needs to be resorted before any
        //   queue addition is valid.  
        drawQueue.sort(cmpDrawables);
        break;
        }
      }
    }
  
  public static function clearQueue() : void
    {
    for ( var i : int = 0; i < drawQueueLength; i++ )
      drawQueue[i] = null;
    drawQueueLength = 0;
    
    // clear the backbuffer
    backbuffer.bitmapData.copyPixels(splashBmp.bitmapData,rect,new Point(0,0));
    }
  
  public static function cmpDrawables( d1 : IDrawable, d2 : IDrawable ) : int
    {
    if ( d1 == null )
      return 1;
    
    if ( d2 == null )
      return -1;
    
    var a : int = d1.getLayer();
    var b : int = d2.getLayer();
    
    if ( a > b )
      return -1;
    else if ( a < b )
      return 1;
    else
      return 0;
    }
  
  public static function draw() : void
    {
    // clear the backbuffer
    backbuffer.bitmapData.copyPixels(splashBmp.bitmapData,rect,new Point(0,0));
    
    drawQueue.sort(cmpDrawables);
    for ( var i : int = 0; i < drawQueueLength; i++ )
      if ( drawQueue[i].isVisible() )
        drawQueue[i].draw(backbuffer.bitmapData);
      
    // If things were removed, it needs to be resorted before any
    //   queue addition is valid.  
    drawQueue.sort(cmpDrawables);
    }
  
  public static function reset() : void
    {
    clearQueue();
    expire();
    addGrounds();
    }
  
  // function that recursively removes children from a sprite
  private static function clearSprite( sprite : DisplayObjectContainer ) : void
    {
    while ( sprite.numChildren > 0 )
      {
      var child : * = sprite.getChildAt(0);
      if ( child is DisplayObjectContainer )
        clearSprite( child as DisplayObjectContainer ); 
      
      sprite.removeChild( child );
      }
    }
  
  public static function addGrounds() : void
    {
    swfs = new Sprite();
    
    root.addChild( backbuffer );
    root.addChild( swfs );
    }
  
  public static function expire() : void
    {
    clearSprite( root );
    }
  
  public static function getArm( level : uint ) : Bitmap
    {
    switch ( level )
      {
      case 0: return new Assets.ShipArm1();
      case 1: return new Assets.ShipArm1();
      case 2: return new Assets.ShipArm2();
      case 3: return new Assets.ShipArm3();
      case 4: return new Assets.ShipArm4();
      case 5: return new Assets.ShipArm5();
      case 6: return new Assets.ShipArm6();
      case 7: return new Assets.ShipArm7();
      case 8: return new Assets.ShipArm8();
      case 9: return new Assets.ShipArm9();
      case 10: return new Assets.ShipArm10();
      default: break;//crash
      }
    return null;
    }
  
  public static function getBody( level : uint ) : Bitmap
    {
    switch ( level )
      {
      case 0: return new Assets.ShipBody1();
      case 1: return new Assets.ShipBody2();
      case 2: return new Assets.ShipBody3();
      case 3: return new Assets.ShipBody4();
      default: break; // argh
      }
    return null;
    }
  
  public static function getColorTransform (teamCode : Number) : ColorTransform
    {
    switch (teamCode)
      {
      case ShipSpec.RED_TEAM:    return redXForm;    break;
      case ShipSpec.BLUE_TEAM:   return blueXForm;   break;
      case ShipSpec.GREEN_TEAM:  return greenXForm;  break;
      case ShipSpec.YELLOW_TEAM: return yellowXForm; break;
      }
    return null;	
    }
  
  public static function getColor (teamCode : Number) : uint
    {
    switch (teamCode)
      {
      case ShipSpec.RED_TEAM:    return redColor;    break;
      case ShipSpec.BLUE_TEAM:   return blueColor;   break;
      case ShipSpec.GREEN_TEAM:  return greenColor;  break;
      case ShipSpec.YELLOW_TEAM: return yellowColor; break;
      }	    
    return 0x000000;	
    }
  
  public static function getShipSprite( ss : ShipSpec ) : Bitmap
    {
    var bmp : Bitmap = new Bitmap();
    var leftArm : Bitmap = getArm( ss.repelLevel );
    var rightArm : Bitmap = getArm( ss.gravityLevel );
    var body : Bitmap = getBody( ss.playerID );
    var back : Bitmap = new Assets.ShipBack();
    
 
    // figure out what color we want
    var colorXForm : ColorTransform = getColorTransform (ss.teamCode);
      
    bmp = new Bitmap( new BitmapData(body.width,body.height,true,0x00000000) );
    const p : Point = new Point(0,0);
    var matrix : Matrix = new Matrix(1,0,0,-1,0,bmp.width);
    var bmpd : BitmapData = bmp.bitmapData;
    bmpd.draw( leftArm.bitmapData, matrix );
    bmpd.copyPixels( back.bitmapData,     bmp.getRect(bmp), p, null, null, true );
    bmpd.copyPixels( rightArm.bitmapData, bmp.getRect(bmp), p, null, null, true );
    body.bitmapData.colorTransform(bmp.getRect(bmp),colorXForm);
    bmpd.copyPixels( body.bitmapData,     bmp.getRect(bmp), p, null, null, true );
    //bmpd.colorTransform(bmp.getRect(bmp),colorXForm);
    
    return bmp;
    } 
 
  } // class Screen

}