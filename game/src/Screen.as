package {

import flash.display.*;
import flash.geom.*;

import ShipSpec;
import Assets;

import com.pixeldroid.r_c4d3.controls.ControlEvent;
import com.pixeldroid.r_c4d3.controls.fourplayer.FourPlayerControl;

public class Screen
  {
  
  public static var FPC : FourPlayerControl;
  
  public static var root : Sprite;
  
  public static var splash : Sprite;
  public static var background : Sprite;
  public static var midground : Sprite;
  public static var foreground : Sprite;
  public static var hud : Sprite; // heads up display
  
  
  public static var redXForm : ColorTransform; 
  public static var blueXForm : ColorTransform;
  public static var greenXForm : ColorTransform; 
  public static var yellowXForm : ColorTransform;      
  
  public static var redColor : uint;
  public static var blueColor : uint;
  public static var greenColor : uint;
  public static var yellowColor : uint;
  
  public static function init(m_root:Sprite) : void
    {
    root = m_root;
    
    FourPlayerControl.instance.connect(root.stage);
    FPC = FourPlayerControl.instance;
    //FPC = new FourPlayerControl(root.stage);
    
    splash = new Sprite();
    background = new Sprite();
    midground = new Sprite();
    foreground = new Sprite();
    hud = new Sprite();
    
    var splashBmp : Bitmap = new Assets.splash;
    splash.addChild (splashBmp);
    
    m_root.addChild (splash);
    m_root.addChild( background );
    m_root.addChild( midground );
    m_root.addChild( foreground );
    m_root.addChild( hud );
    
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
    
    }
  
  public static function reset() : void
    {
    expire();
    addGrounds();
    }
  
  // heavy duty function that recursively removes children from a sprite
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
    splash = new Sprite();	
    background = new Sprite();
    midground = new Sprite();
    foreground = new Sprite();
    hud = new Sprite();
    
    var splashBmp : Bitmap = new Assets.splash;
    splash.addChild (splashBmp);
    
    root.addChild( splash );
    root.addChild( background );
    root.addChild( midground );
    root.addChild( foreground );
    root.addChild( hud );
    }
  
  public static function expire() : void
    {
    /*
    root.removeChild( splash );
    root.removeChild( background );
    root.removeChild( midground );
    root.removeChild( foreground );
    root.removeChild( hud );
    */
    
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