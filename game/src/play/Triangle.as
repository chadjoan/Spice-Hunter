package play
{

import play.Body;
import play.Edge;

// Primitive class for representing triangles.
public class Triangle
  {
  public var A:Body;
  public var B:Body;
  public var C:Body;
  
  public var edgeAB:Edge;
  public var edgeBC:Edge;
  public var edgeCA:Edge;
  
  public var ID:Number;
  
  public var angleA:Number;
  public var angleB:Number;
  public var angleC:Number;
  public var minAngle:Number;
  
  public function Triangle(a:Body, b:Body, c:Body)
    {
    A = a;
    B = b;
    C = c;
    ID = -1; 	
    
    edgeAB = null;
    edgeBC = null;
    edgeCA = null;
    
    computeAngles();
    }
    
  public function computeAngles() : void
    {
    var BAx:Number = B.rx - A.rx;
    var BAy:Number = B.ry - A.ry;
    var BAL:Number = Math.sqrt(BAx*BAx + BAy*BAy);
    BAx /= BAL;
    BAy /= BAL;
    
    var CAx:Number = C.rx - A.rx;
    var CAy:Number = C.ry - A.ry;
    var CAL:Number = Math.sqrt(CAx*CAx + CAy*CAy);
    CAx /= CAL;
    CAy /= CAL;
    
    angleA = Math.acos (BAx * CAx + BAy * CAy) * 180.0 / Math.PI;
    
    var ABx:Number = -BAx; 
    var ABy:Number = -BAy;
    var CBx:Number = C.rx - B.rx;
    var CBy:Number = C.ry - B.ry;
    var CBL:Number = Math.sqrt(CBx*CBx + CBy*CBy);
    CBx /= CBL;
    CBy /= CBL;
    
    angleB = Math.acos (ABx*CBx + ABy*CBy) * 180.0 / Math.PI;
    
    var ACx:Number = -CAx;
    var ACy:Number = -CAy;
    var BCx:Number = -CBx;
    var BCy:Number = -CBy;
    
    angleC = Math.acos(ACx*BCx + ACy*BCy) * 180.0 / Math.PI;
    
    // Compute minimum angle of angleA, angleB, angleC.
    minAngle = Math.min( Math.min(angleA,angleB), angleC);
    }
    
    
  public function rotate (rotateby:Number) : void
    {
    // Does cyclic permutation of nodes / edges / angles.	
    if (rotateby == 0)
      return;	
    
    var tempEdge:Edge;
    var tempBody:Body;
    var tempAngle:Number;  
      
    if (rotateby == 1)
      { 
      tempBody = A;
      A = B;
      B = C;
      C = tempBody;
      
      tempEdge = edgeAB;	
      edgeAB = edgeBC;
      edgeBC = edgeCA;
      edgeCA = tempEdge;
      
      tempAngle = angleA;
      angleA = angleB;
      angleB = angleC;
      angleC = tempAngle;	
      }
      
    if (rotateby == -1)
      {
      tempBody = A;
      A = C;
      C = B;
      B = tempBody
      
      tempEdge = edgeAB;
      edgeAB = edgeCA;
      edgeCA = edgeBC;
      edgeBC = tempEdge;
      
      tempAngle = angleA;
      angleA = angleC;
      angleC = angleB;
      angleB = tempAngle;
      }
    }
  }
  
} // end package