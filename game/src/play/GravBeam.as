package play
{

import play.Ship;
import play.Body;

import flash.media.Sound;
import flash.filters.BlurFilter;
import flash.display.Sprite;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.SpreadMethod;
import flash.display.GradientType;
import flash.display.InterpolationMethod;
import flash.geom.Matrix;
import flash.geom.Point;

public class GravBeam implements IDrawable
  {
  // beam types.
  public static const ATTRACT : int = 1;
  public static const REPEL : int = 2;
  
  public var beamType : uint;
  
  public var drawingPlane : Sprite;
  public var frame : Number;
  public var strength : Number;
  
  private var owner : Ship;
  private var m_target : Body;
  
  public function GravBeam( theOwner : Ship, typeOfBeam : uint )
    {
    if ( !initialized )
      init();
    
    beamType = typeOfBeam;
    owner = theOwner;
    m_target = null;
    drawingPlane = new Sprite();
    drawingPlane.filters = [new BlurFilter(8,8)];
    frame = 0;
    
    // increase repelStrength and gravityStrength at these aspects of the ship are upgraded.
    if ( beamType == ATTRACT )
      strength = 0.06 + 0.015 * owner.spec.gravityLevel;
    else if ( beamType == REPEL )
      strength = 0.06 + 0.015 * owner.spec.repelLevel;
    
    Screen.queueDraw(this);
    }
  
  public function get target() : Body { return m_target; }
  public function set target( value : Body ) : void
    {
    if ( m_target == value )
      return; // No change = no sound effects, or anything else.
    
    if ( value != Body(owner) ) // We can't gravitate on ourselves!
      m_target = value;
    
    if ( m_target == null )
      return; // don't play the sound if we are turning off.
    
    if ( owner.spec.isCPUControlled )
      return; // CPUs toggle a lot and it gets awfully noisy.
              // So don't let them make noise. 
              // It may not be the optimal strategy, but it replicates legacy Spice Hunter.  
    
    // Pew pew gravity beams.
    if ( beamType == REPEL )
      Utility.playSound( Assets.BeamRepel );
    else if ( beamType == ATTRACT )
      Utility.playSound( Assets.BeamAttract );
    }
  
  private function targetIsValid() : Boolean
    {
    if ( target == null )
      return true;
    
    if ( target.isExpired )
      {
      target = null;
      return true;
      }
    
    return false;
    }
  
  public function updateFrame( deltaT : Number ) : void
    {
    frame += deltaT* (0.5 + 2.5 * owner.spec.repelLevel/10);       
    if ( frame > 8*Math.sqrt(8) )
      frame = 0;
    }
    
  public function applyForces( deltaT : Number ) : void
    {
    if ( targetIsValid() )
      return;
    
    var dx:Number;
    var dy:Number;
    var dl:Number;
    
    dx = target.rx - owner.rx;
    dy = target.ry - owner.ry;
    dl = Math.sqrt(dx*dx + dy*dy);
    dx /= dl;
    dy /= dl;
    
    if ( beamType == ATTRACT )
      {
      // Add a little velocity kick towards (dx,dy);
      owner.vx += dx * strength * deltaT;
      owner.vy += dy * strength * deltaT;
      // Add a little velocity kick to the other thing
      var K1 : Number = 4;
      target.vx -= dx * strength * owner.mass / target.mass * deltaT / K1;
      target.vy -= dy * strength * owner.mass / target.mass * deltaT / K1;
      }
    else if ( beamType == REPEL )
      {
      // Add a little velocity kick away from (dx,dy);
      owner.vx -= dx * strength * deltaT;
      owner.vy -= dy * strength * deltaT;	
      // Add a little velocity kick to the other thing
      var K2 : Number = 4;
      target.vx += dx * strength * owner.mass / target.mass * deltaT / K2;
      target.vy += dy * strength * owner.mass / target.mass * deltaT / K2;
      }
    }
  
  // IDrawable implementation
  public function isVisible() : Boolean { return !targetIsValid(); }
  public function getLayer() : uint { return Drawable.midground; }
  public function draw( backbuffer : BitmapData ) : void
    {
    if ( targetIsValid() )
      return;
    
    callForceBeam();
    
    backbuffer.draw(drawingPlane,
                    drawingPlane.transform.matrix,
                    drawingPlane.transform.colorTransform,
                    null,null,Screen.useSmoothing(0.0)); // I'm figuring the blur smooths it anyways.
    }
  
  // Extra stub onto beam drawing routine
  private function callForceBeam() : void
    {
    var hiColorR : uint = 0;
    var hiColorG : uint = 0;
    var hiColorB : uint = 0;
    
    var rx : Number = owner.rx;
    var ry : Number = owner.ry;
    var r : Number = owner.collision_radius;
    var angle : Number;
    if ( beamType == REPEL )
      {
      // Origin of repel beam is on left arm.
      angle = owner.phi-Math.PI/8;
      
      // It is reddish in color
      hiColorR = 128 + Math.round(127*owner.spec.repelLevel / 10);
      }
    else if ( beamType == ATTRACT )
      {
      // Origin of gravity beam is on right arm.
      angle = owner.phi+Math.PI/8;
      
      // It is blueish in color
      hiColorB = 128 + Math.round(127*owner.spec.repelLevel / 10);
      }
    
    var hiColor : uint = hiColorR*256*256 + hiColorG*256 + hiColorB;  
    
    drawForceBeam(rx + r*Math.cos(angle) , ry  + r*Math.sin(angle), target.rx, target.ry, 
                  3, target.collision_radius, 0x000000, hiColor);
    }
  
  // Procedural beam drawing routine
  public function drawForceBeam( x1:int, y1:int, x2:int, y2:int, 
                            startThickness:uint, endThickness:uint, color1:uint, color2:uint) : void
    {
    // alphas are 0-100, with 100 being fully opaque
    const alpha1 : Number = 0.75;
    const alpha2 : Number = 0.75;
    
    const period : uint = 8; // how far apart the 'arrows' are
    
    var attracts : Boolean = false;
    if ( beamType == ATTRACT )
      attracts = true;
    
    var graphics : Graphics = drawingPlane.graphics;
    graphics.clear();
    
    var dx : int = x2 - x1;
    var dy : int = y2 - y1;
    var angle : Number = 0;
    
    if ( dx == 0 )
      {
      if ( dy >= 0 )
        angle = Math.PI / 2;
      else
        angle = Math.PI * 3 / 2;
      }
    else if ( dx > 0 )
      angle = Math.atan( dy/dx );
    else
      angle = Math.atan( dy/dx ) + Math.PI;
    
    angle %= 2 * Math.PI;
    if ( angle < 0 )
      angle += 2 * Math.PI;
    
    var spread : Number;
    if ( attracts )
      spread = Math.PI / 4;
    else
      spread = -Math.PI / 4;
    
    var minX : int = Math.min( x1, x2 );
    var minY : int = Math.min( y1, y2 );
    var length : int = Math.sqrt( dx*dx + dy*dy );
    
    var cosine : Number = Math.cos( angle );
    var sine : Number = Math.sin( angle );
    
    // bread-and-butter rotation matrix
    matrix.a = cosine;
    matrix.b = -sine;
    matrix.c = sine;
    matrix.d = cosine;
    matrix.tx = x1;
    matrix.ty = y1;
    
    // now let's just say that the beam is shooting from the left to right, 
    //   we define a set of points describing the top and bottom halves of
    //   the beam.
    
    // top half
    pt0 = transformPoint( matrix, pt0, length, 0 );
    pt1 = transformPoint( matrix, pt1, length, -endThickness/2 );
    pt2 = transformPoint( matrix, pt2, 0, -startThickness/2 );
    pt3 = transformPoint( matrix, pt3, 0, 0 );
    
    // bottom half
    pb0 = transformPoint( matrix, pb0, length, 0 );
    pb1 = transformPoint( matrix, pb1, length, endThickness/2 );
    pb2 = transformPoint( matrix, pb2, 0, startThickness/2 );
    pb3 = transformPoint( matrix, pb3, 0, 0 );
    
    // let's get our animation groove on - animShift changes over time to make the 
    //   beam look like it is moving in one direction
    rotMatrix.a = cosine;
    rotMatrix.b = -sine;
    rotMatrix.c = sine;
    rotMatrix.d = cosine;
    rotMatrix.tx = 0;
    rotMatrix.ty = 0;
    animShift = transformPoint( rotMatrix, animShift, 0, frame );
    
    // now for gradient stuff
    // top
    matrix.createGradientBox( period, period, angle+spread, x1 - animShift.x, y1 - animShift.y );        
    
    graphics.beginGradientFill(GradientType.LINEAR,[color1,color2],[alpha1,alpha2],[0,255],matrix,
      SpreadMethod.REFLECT,InterpolationMethod.LINEAR_RGB,0);
    graphics.moveTo( pt0.x, pt0.y );
    graphics.lineTo( pt1.x, pt1.y );
    graphics.lineTo( pt2.x, pt2.y );
    graphics.lineTo( pt3.x, pt3.y );
    graphics.lineTo( pt0.x, pt0.y );
    graphics.endFill();
    
    // bottom
    
    // but first, let's align the one side of the beam with the other
    phaseShift = assignPoint( phaseShift, 0, 0 );
    
    if ( attracts )
      {
      if ( angle <= Math.PI / 2 )
        phaseShift = assignPoint( phaseShift, period * (cosine - sine), 0 );
      else if ( Math.PI / 2 < angle && angle <= Math.PI )
        phaseShift = transformPoint( rotMatrix, phaseShift, 0, period );
      else if ( Math.PI < angle && angle <= Math.PI * 3 / 2 )
        phaseShift = assignPoint( phaseShift, period * (sine - cosine), 0 );
      else
        phaseShift = transformPoint( rotMatrix, phaseShift, period, 0 );
      }
    else
      {
      if ( angle <= Math.PI / 2 )
        phaseShift = assignPoint( phaseShift, 0, period * ( sine - cosine ) );
      else if ( Math.PI / 2 < angle && angle <= Math.PI )
        phaseShift = transformPoint( rotMatrix, phaseShift, 0, period );
      else if ( Math.PI < angle && angle <= Math.PI * 3 / 2 )
        phaseShift = assignPoint( phaseShift, 0, period * (cosine - sine) );
      else
        phaseShift = transformPoint( rotMatrix, phaseShift, -period, 0 );
      }
    
    phaseShift.x += animShift.x;
    phaseShift.y += animShift.y;
    
    // ok done, bottom now.  for real this time.  
    matrix.createGradientBox( period, period, angle-spread, x1 + phaseShift.x, y1 + phaseShift.y);    
    
    graphics.beginGradientFill(GradientType.LINEAR,[color1,color2],[alpha1,alpha2],[0,255],matrix,
      SpreadMethod.REFLECT,InterpolationMethod.LINEAR_RGB,0);
    graphics.moveTo( pb0.x, pb0.y );
    graphics.lineTo( pb1.x, pb1.y );
    graphics.lineTo( pb2.x, pb2.y );
    graphics.lineTo( pb3.x, pb3.y );
    graphics.lineTo( pb0.x, pb0.y );
    graphics.endFill();
    }
  
  // ==========================================================================
  // anti-heap-abuse optimization
  // ==========================================================================
  
  // No littering variables - cache stuff so the GC doesn't have to collect.
  private static var initialized : Boolean = false;
  
  private static var matrix : Matrix = new Matrix();
  private static var rotMatrix : Matrix = new Matrix();
  
  private static var pt0 : Point = new Point(0,0);
  private static var pt1 : Point = new Point(0,0);
  private static var pt2 : Point = new Point(0,0);
  private static var pt3 : Point = new Point(0,0);
  
  private static var pb0 : Point = new Point(0,0);
  private static var pb1 : Point = new Point(0,0);
  private static var pb2 : Point = new Point(0,0);
  private static var pb3 : Point = new Point(0,0);
  
  private static var animShift : Point = new Point(0,0);
  private static var phaseShift : Point = new Point(0,0);
  
  public static function init() : void
    {
    initialized = true;
    }
  
  // Same thing as matrix.transformPoint(pt), but with no heap usage.
  // The dst parameter is how you specify what point to place the results into.  
  // x and y specify what dst's contents should be replaced by before applying
  //   the transformation.
  // returns: reference to dst (dst is transformed).
  private function transformPoint( matrix : Matrix, dst:Point, 
                                  x:Number, y:Number ) : Point
    {
    dst.x = (matrix.a * x) + (matrix.b * y) + matrix.tx;
    dst.y = (matrix.c * x) + (matrix.d * y) + matrix.ty;
    return dst;
    }
    
  // Convenience function that assigns values to a point in one function call.
  private function assignPoint( dst:Point, x:Number, y:Number ) : Point
    {
    dst.x = x;
    dst.y = y;
    return dst;
    }
  
  } // class GravBeam
}