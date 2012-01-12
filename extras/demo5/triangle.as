// Primitive class for representing triangles.
class Triangle
  {
  var A:Body;
  var B:Body;
  var C:Body;
  
  var edgeAB:Edge;
  var edgeBC:Edge;
  var edgeCA:Edge;
  
  var ID:Number;
  
  var angleA:Number;
  var angleB:Number;
  var angleC:Number;
  var minAngle:Number;
  
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
    
  public function computeAngles() : Void
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
    
    
  public function rotate (rotateby:Number) : Void
    {
    // Does cyclic permutation of nodes / edges / angles.	
    if (rotateby == 0)
      return;	
      
    if (rotateby == 1)
      { 
      var tempBody:Body = A;
      A = B;
      B = C;
      C = tempBody;
      
      var tempEdge:Edge = edgeAB;	
      edgeAB = edgeBC;
      edgeBC = edgeCA;
      edgeCA = tempEdge;
      
      var tempAngle:Number = angleA;
      angleA = angleB;
      angleB = angleC;
      angleC = tempAngle;	
      }
      
    if (rotateby == -1)
      {
      var tempBody:Body = A;
      A = C;
      C = B;
      B = tempBody
      
      var tempEdge:Edge = edgeAB;
      edgeAB = edgeCA;
      edgeCA = edgeBC;
      edgeBC = tempEdge;
      
      var tempAngle:Number = angleA;
      angleA = angleC;
      angleC = angleB;
      angleB = tempAngle;
      }
    }
  }