package play
{

import Assets;
import Drawable;
import IDrawable;

import play.Particle;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Transform;

public class Body extends Particle implements IDrawable
  {
  public var cachebmp:Bitmap;
  
  public var phi:Number;
  public var omega:Number;
  public var moment:Number;
  
  public var isExpired:Boolean;
  public var tooltiptext:String;
  
  public function Body ()
    {
    cachebmp = new Bitmap();
    
    phi = 0;
    omega = 0;
    moment = 0;
    collision_radius = 0;
    
    Screen.queueDraw(this);
    isExpired = false;
    tooltiptext = "howdy";
    }
  
  // IDrawable implementation
  public function isVisible() : Boolean { return !isExpired; }
  public function getLayer() : uint { return Drawable.foreground; }
  public function draw( backbuffer : BitmapData ) : void
    {
    // Compute scale so that this ship will be drawn with the right collision radius.
    var scaleX : Number = collision_radius / (cachebmp.width/2);
    var scaleY : Number = collision_radius / (cachebmp.height/2);  
    
    Utility.center(cachebmp);
    
    var trans : Transform = cachebmp.transform;
    var matrix : Matrix =  trans.matrix;
    matrix.rotate(phi);
    matrix.scale(scaleX,scaleY);
    matrix.tx += rx;
    matrix.ty += ry;
    
    backbuffer.draw(cachebmp,matrix,trans.colorTransform,null,null,useSmoothing());
    }
  // End IDrawable implementation
  
  // override it to change it.
  public function useSmoothing() : Boolean
    {
    return Screen.useSmoothing(0.8);
    }
  
  public function bounceClipDamped () : void
    {
    var damping:Number = 0.25;
    	
    // Bounce off walls.+5)
    if (rx < collision_radius)
      {
      rx = collision_radius;
      vx = damping*Math.abs(vx);
      //vy = damping*vy;
      }
    if (rx > 800-collision_radius)
      {
      rx = 800-collision_radius;        
      vx = -damping*Math.abs(vx);	
      //vy = damping*vy;
      }
    if (ry < collision_radius)
      {
      ry = collision_radius;
      vy = damping*Math.abs(vy);	
      //vx = damping*vx;
      }
    if (ry > 600-collision_radius)
      {
      ry = 600-collision_radius;	
      vy = -damping*Math.abs(vy);
      //vx = damping*vx;	
      }
    }
  
  public function bounceClip() : void
    {
    var damping:Number = 1;
    	
    // Bounce off walls.+5)
    if (rx < collision_radius)
      {
      rx = collision_radius;
      vx = damping*Math.abs(vx);
      //vy = damping*vy;
      }
    if (rx > 800-collision_radius)
      {
      rx = 800-collision_radius;        
      vx = -damping*Math.abs(vx);	
      //vy = damping*vy;
      }
    if (ry < collision_radius)
      {
      ry = collision_radius;
      vy = damping*Math.abs(vy);	
      //vx = damping*vx;
      }
    if (ry > 600-collision_radius)
      {
      ry = 600-collision_radius;	
      vy = -damping*Math.abs(vy);
      //vx = damping*vx;	
      }
    }
  
  public function expire() : void
    {
    Screen.queueRemove(this);
    isExpired = true;
    }
  
  }
  
} // end package