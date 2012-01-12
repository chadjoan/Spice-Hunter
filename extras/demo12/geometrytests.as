// Geometry predicates - all static functions.
class GeometryTests
  {
  // Not really a GeometryTest, but a convenient place to put this. Reduces the number of displayed digits (3 places after decimal)
  static function threeDigits (argument:Number) : Number	
    {
    return Math.round (argument*1000)/1000;	
    }
  	
  // A test to determine if Body z is inside Triangle t(A,B,C)	
  static function inTriangle (t:Triangle, z:Body) : Boolean   
    {
    var ABx:Number = t.B.rx - t.A.rx;
    var ABy:Number = t.B.ry - t.A.ry;    
    var AZx:Number = z.rx - t.A.rx;
    var AZy:Number = z.ry - t.A.ry;
    if ((ABx*AZy - ABy*AZx) < 0)    
      return false;  
    
    var BCx:Number = t.C.rx - t.B.rx;
    var BCy:Number = t.C.ry - t.B.ry;
    var BZx:Number = z.rx - t.B.rx;
    var BZy:Number = z.ry - t.B.ry;
    if ((BCx*BZy - BCy*BZx) < 0)
      return false;

    var CAx:Number = t.A.rx - t.C.rx;
    var CAy:Number = t.A.ry - t.C.ry;
    var CZx:Number = z.rx - t.C.rx;
    var CZy:Number = z.ry - t.C.ry;
    if ((CAx*CZy - CAy*CZx) < 0)  
      return false;
    
    return true;
    }
  
  // A test to determine if four points compose a convex quadrilateral
  // Only convex quads are eligible for edge flipping.  
  static function isRightTurn (b1:Body, b2:Body, b3:Body) : Boolean
    {
    var x12:Number = b1.rx - b2.rx;	
    var y12:Number = b1.ry - b2.ry;
    
    var x32:Number = b3.rx - b2.rx;
    var y32:Number = b3.ry - b2.ry;
    
    return (x12*y32 - x32*y12 > 0);
    }
    
  }
  