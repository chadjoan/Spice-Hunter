package {

import Triangle;

// Primitive for representing edges - holds the two bodies that makeup the edge,
// as well as the two triangles that border it (which might be null).
public class Edge
  {   
  public var B1:Body;
  public var B2:Body;  	  
  	
  public var Tleft:Triangle;
  public var Tright:Triangle;
  
  public var ID:Number;
  
  public function Edge (b1:Body, b2:Body)
    {
    B1 = b1;
    B2 = b2;	
    	
    Tleft = null;
    Tright = null;    
    ID = -1;
    }
  }
  
} // end package.